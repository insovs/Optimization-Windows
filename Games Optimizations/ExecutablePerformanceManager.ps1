#Requires -Version 5.1
# https://github.com/insovs

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

if (-not ('Hide.Win32' -as [type])) {
    Add-Type -Name Win32 -Namespace Hide -MemberDefinition '
        [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]   public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    ' -ErrorAction SilentlyContinue
}
try { [Hide.Win32]::ShowWindow([Hide.Win32]::GetConsoleWindow(), 0) } catch {}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml, System.Windows.Forms

$script:BrushConv = [System.Windows.Media.BrushConverter]::new()
function New-Brush { param([string]$hex); $script:BrushConv.ConvertFromString($hex) }
function ConvertFrom-XamlString {
    param([string]$s)
    $xr = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($s.Trim()))
    return [System.Windows.Markup.XamlReader]::Load($xr)
}

$script:PrioBase      = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
$script:QosBase       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\QoS'
$script:GpuBase       = 'HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences'
$script:LayersBase    = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers'
$script:FullscreenKey = 'HKCU:\System\GameConfigStore'
$script:GraphicsKey   = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games'

# ─────────────────────────────────────────────────────────────
#  SPLASH SCREEN XAML
# ─────────────────────────────────────────────────────────────
$splashXaml = @'
<Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="Executable Performance Manager" Width="520" Height="555"
  WindowStartupLocation="CenterScreen"
  Background="Transparent" Foreground="#E8E8F0"
  FontFamily="Segoe UI" WindowStyle="None"
  AllowsTransparency="True" ResizeMode="NoResize">

  <Window.Resources>
    <Style x:Key="WinBtn" TargetType="Button">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#4B5563"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Width" Value="30"/>
      <Setter Property="Height" Value="26"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="Transparent" CornerRadius="5">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#222222"/>
                <Setter Property="Foreground" Value="#9CA3AF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="CloseBtn" TargetType="Button">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#4B5563"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Width" Value="30"/>
      <Setter Property="Height" Value="26"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="Transparent" CornerRadius="5">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#7F1D1D"/>
                <Setter Property="Foreground" Value="#EF4444"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Grid>
    <Border CornerRadius="14" Background="#0A0A0A" BorderBrush="#1F1F1F" BorderThickness="1" Margin="2">
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="46"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="52"/>
        </Grid.RowDefinitions>

        <!-- Titlebar -->
        <Border Grid.Row="0" Background="#0F0F0F" CornerRadius="14,14,0,0" BorderBrush="#1F1F1F" BorderThickness="0,0,0,1">
          <Grid Margin="14,0">
            <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
              <Ellipse Width="7" Height="7" Fill="#22C55E" Margin="0,0,9,0"/>
              <TextBlock Text="EXECUTABLE  PERFORMANCE  MANAGER" FontSize="13" FontWeight="Bold" Foreground="#C8C8C8"/>
              <!-- MODIFICATION 1: github badge replaces v1.0 -->
              <Border x:Name="SplashGithubBadge" Background="#141414" BorderBrush="#272727" BorderThickness="1"
                      CornerRadius="5" Padding="7,3" Margin="10,0,0,0" VerticalAlignment="Center" Cursor="Hand">
                <TextBlock Text="github / insovs" FontSize="9" Foreground="#444444"/>
              </Border>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
              <Button x:Name="SplashMinimize" Content="&#x2014;" Style="{StaticResource WinBtn}"/>
              <Button x:Name="SplashClose"    Content="&#x2715;" Style="{StaticResource CloseBtn}" Margin="2,0,0,0"/>
            </StackPanel>
          </Grid>
        </Border>

        <!-- Body: single centered column -->
        <StackPanel Grid.Row="1" VerticalAlignment="Center" Margin="28,10,28,10">

          <!-- Icon + Title -->
          <StackPanel HorizontalAlignment="Center" Margin="0,0,0,12">
            <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="12"
                    Width="44" Height="44" HorizontalAlignment="Center" Margin="0,0,0,10">
              <TextBlock Text="&#x26A1;" FontSize="19" HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <TextBlock Text="Executable Performance Manager" FontSize="17" FontWeight="Bold" Foreground="#C8C8C8"
                       HorizontalAlignment="Center" Margin="0,0,0,3"/>
            <TextBlock Text="System-level optimizations for games and applications" FontSize="9" Foreground="#2A2A2A"
                       HorizontalAlignment="Center" TextAlignment="Center" TextWrapping="Wrap"/>
          </StackPanel>

          <!-- Features grid -->
          <Border Background="#0F0F0F" BorderBrush="#1A1A1A" BorderThickness="1" CornerRadius="10" Padding="8,8" Margin="0,0,0,12">
            <StackPanel>

              <!-- Row 1 -->
              <Grid Margin="0,0,0,5">
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="5"/>
                  <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="BtnGoToCpu" Grid.Column="0" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand">
                  <Button.Template>
                    <ControlTemplate TargetType="Button">
                      <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                        <StackPanel>
                          <StackPanel Orientation="Horizontal" Margin="0,0,0,2">
                            <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                            <TextBlock Text="CPU Priority" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                          </StackPanel>
                          <TextBlock Text="High CPU + IO priority, better performance." FontSize="9" Foreground="#333333" Margin="11,0,0,0"/>
                        </StackPanel>
                      </Border>
                      <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                          <Setter TargetName="bd" Property="Background" Value="#111111"/>
                          <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                        </Trigger>
                      </ControlTemplate.Triggers>
                    </ControlTemplate>
                  </Button.Template>
                </Button>
                <Button x:Name="BtnGoToQos" Grid.Column="2" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand">
                  <Button.Template>
                    <ControlTemplate TargetType="Button">
                      <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                        <StackPanel>
                          <StackPanel Orientation="Horizontal" Margin="0,0,0,2">
                            <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                            <TextBlock Text="QoS Network" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                          </StackPanel>
                          <TextBlock Text="Prioritizes / give the highest network priority" FontSize="9" Foreground="#333333" Margin="11,0,0,0"/>
                        </StackPanel>
                      </Border>
                      <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                          <Setter TargetName="bd" Property="Background" Value="#111111"/>
                          <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                        </Trigger>
                      </ControlTemplate.Triggers>
                    </ControlTemplate>
                  </Button.Template>
                </Button>
              </Grid>

              <!-- Row 2 -->
              <Grid Margin="0,0,0,5">
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="5"/>
                  <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="BtnGoToGpu" Grid.Column="0" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand">
                  <Button.Template>
                    <ControlTemplate TargetType="Button">
                      <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                        <StackPanel>
                          <StackPanel Orientation="Horizontal" Margin="0,0,0,2">
                            <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                            <TextBlock Text="GPU Preference" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                          </StackPanel>
                          <TextBlock Text="Always uses the discrete GPU." FontSize="9" Foreground="#333333" Margin="11,0,0,0"/>
                        </StackPanel>
                      </Border>
                      <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                          <Setter TargetName="bd" Property="Background" Value="#111111"/>
                          <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                        </Trigger>
                      </ControlTemplate.Triggers>
                    </ControlTemplate>
                  </Button.Template>
                </Button>
                <Button x:Name="BtnGoToAdmin" Grid.Column="2" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand">
                  <Button.Template>
                    <ControlTemplate TargetType="Button">
                      <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                        <StackPanel>
                          <StackPanel Orientation="Horizontal" Margin="0,0,0,2">
                            <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                            <TextBlock Text="Run As Admin" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                          </StackPanel>
                          <TextBlock Text="Runs as administrator for better compatibility." FontSize="9" Foreground="#333333" Margin="11,0,0,0"/>
                        </StackPanel>
                      </Border>
                      <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                          <Setter TargetName="bd" Property="Background" Value="#111111"/>
                          <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                        </Trigger>
                      </ControlTemplate.Triggers>
                    </ControlTemplate>
                  </Button.Template>
                </Button>
              </Grid>

              <!-- Row 3 -->
              <Grid Margin="0,0,0,5">
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="5"/>
                  <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Button x:Name="BtnGoToFirewall" Grid.Column="0" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand">
                  <Button.Template>
                    <ControlTemplate TargetType="Button">
                      <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                        <StackPanel>
                          <StackPanel Orientation="Horizontal" Margin="0,0,0,2">
                            <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                            <TextBlock Text="Firewall" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                          </StackPanel>
                          <TextBlock Text="Allow rules in + out via Windows Firewall." FontSize="9" Foreground="#333333" Margin="11,0,0,0"/>
                        </StackPanel>
                      </Border>
                      <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                          <Setter TargetName="bd" Property="Background" Value="#111111"/>
                          <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                        </Trigger>
                      </ControlTemplate.Triggers>
                    </ControlTemplate>
                  </Button.Template>
                </Button>
                <Button x:Name="BtnGoToDefender" Grid.Column="2" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand">
                  <Button.Template>
                    <ControlTemplate TargetType="Button">
                      <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                        <StackPanel>
                          <StackPanel Orientation="Horizontal" Margin="0,0,0,2">
                            <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                            <TextBlock Text="Defender" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                          </StackPanel>
                          <TextBlock Text="Excludes game folder from Defender scans." FontSize="9" Foreground="#333333" Margin="11,0,0,0"/>
                        </StackPanel>
                      </Border>
                      <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                          <Setter TargetName="bd" Property="Background" Value="#111111"/>
                          <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                        </Trigger>
                      </ControlTemplate.Triggers>
                    </ControlTemplate>
                  </Button.Template>
                </Button>
              </Grid>

              <!-- Row 4 — Fullscreen full width -->
              <Button x:Name="BtnGoToFullscreen" Background="#0A0A0A" BorderBrush="#1A1A1A" BorderThickness="1" Cursor="Hand" HorizontalAlignment="Stretch">
                <Button.Template>
                  <ControlTemplate TargetType="Button">
                    <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="9,7">
                      <StackPanel HorizontalAlignment="Center">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,0,0,2">
                          <Ellipse Width="5" Height="5" Fill="#22C55E" Margin="0,0,6,0" VerticalAlignment="Center"/>
                          <TextBlock Text="Fullscreen Optimization" FontSize="10" FontWeight="SemiBold" Foreground="#555555"/>
                        </StackPanel>
                        <TextBlock Text="Forces true exclusive fullscreen to cut input lag." FontSize="9" Foreground="#333333" TextAlignment="Center"/>
                      </StackPanel>
                    </Border>
                    <ControlTemplate.Triggers>
                      <Trigger Property="IsMouseOver" Value="True">
                        <Setter TargetName="bd" Property="Background" Value="#111111"/>
                        <Setter TargetName="bd" Property="BorderBrush" Value="#22C55E"/>
                      </Trigger>
                    </ControlTemplate.Triggers>
                  </ControlTemplate>
                </Button.Template>
              </Button>

            </StackPanel>
          </Border>

        </StackPanel>

        <!-- Footer -->
        <Border Grid.Row="2" Background="#0F0F0F" CornerRadius="0,0,14,14" BorderBrush="#1F1F1F" BorderThickness="0,1,0,0">
          <Grid Margin="20,0">
            <TextBlock Text="Click a section to get started" FontSize="9" Foreground="#1E1E1E"
                       FontFamily="Consolas" VerticalAlignment="Center"/>
            <Border x:Name="SplashMoreInfoBtn" Background="#141414" BorderBrush="#272727" BorderThickness="1"
                    CornerRadius="5" Padding="8,4" HorizontalAlignment="Right" VerticalAlignment="Center" Cursor="Hand">
              <TextBlock Text="More about this" FontSize="9" Foreground="#444444"/>
            </Border>

          </Grid>
        </Border>

      </Grid>
    </Border>
  </Grid>
</Window>
'@

# ─────────────────────────────────────────────────────────────
#  Show Splash and wait for Launch or Close
# ─────────────────────────────────────────────────────────────
$splash = ConvertFrom-XamlString $splashXaml

$splash.Add_MouseLeftButtonDown({
    param($s,$e)
    $src = $e.OriginalSource
    if (-not ($src -is [System.Windows.Controls.Primitives.ButtonBase])) {
        $splash.DragMove()
    }
})

$splashClose    = $splash.FindName('SplashClose')
$splashMinimize = $splash.FindName('SplashMinimize')

# MODIFICATION 1: badge github dans la titlebar (remplace v1.0)
$splashGithubBadge = $splash.FindName('SplashGithubBadge')
$splashGithubBadge.Add_MouseLeftButtonDown({ Start-Process 'https://github.com/insovs' })
$splashGithubBadge.Add_MouseEnter({ $splashGithubBadge.Background = New-Brush '#1A1A1A' })
$splashGithubBadge.Add_MouseLeave({ $splashGithubBadge.Background = New-Brush '#141414' })

$script:ShouldLaunch = $false
$script:StartPage    = 'PageCpu'
$script:StartNav     = 'NavCpu'
$script:StartLoad    = 'Load-CpuRules'

$splashClose.Add_Click({ $splash.Close() })
$splashMinimize.Add_Click({ $splash.WindowState = [System.Windows.WindowState]::Minimized })

$splashMoreInfo = $splash.FindName('SplashMoreInfoBtn')
$splashMoreInfo.Add_MouseLeftButtonDown({ Start-Process 'https://github.com/insovs' })
$splashMoreInfo.Add_MouseEnter({ $splashMoreInfo.Background = New-Brush '#1A1A1A' })
$splashMoreInfo.Add_MouseLeave({ $splashMoreInfo.Background = New-Brush '#141414' })

function Invoke-SplashNav { param([string]$page,[string]$nav,[string]$load)
    $script:StartPage = $page; $script:StartNav = $nav; $script:StartLoad = $load
    $script:ShouldLaunch = $true; $splash.Close()
}

$splash.FindName('BtnGoToCpu').Add_Click(        { Invoke-SplashNav 'PageCpu'        'NavCpu'        'Load-CpuRules'      })
$splash.FindName('BtnGoToQos').Add_Click(        { Invoke-SplashNav 'PageQos'        'NavQos'        'Load-QosRules'      })
$splash.FindName('BtnGoToGpu').Add_Click(        { Invoke-SplashNav 'PageGpu'        'NavGpu'        'Load-GpuRules'      })
$splash.FindName('BtnGoToAdmin').Add_Click(      { Invoke-SplashNav 'PageAdmin'      'NavAdmin'      'Load-AdminRules'    })
$splash.FindName('BtnGoToFirewall').Add_Click(   { Invoke-SplashNav 'PageFirewall'   'NavFirewall'   ''                   })
$splash.FindName('BtnGoToDefender').Add_Click(   { Invoke-SplashNav 'PageDefender'   'NavDefender'   'Load-DefenderRules' })
$splash.FindName('BtnGoToFullscreen').Add_Click( { Invoke-SplashNav 'PageFullscreen' 'NavFullscreen' 'Load-FsoRules'      })

$splash.ShowDialog() | Out-Null

if (-not $script:ShouldLaunch) { exit }

# ─────────────────────────────────────────────────────────────
#  MAIN WINDOW XAML
# ─────────────────────────────────────────────────────────────
$xaml = @'
<Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="Executable Performance Manager" Width="560" Height="660"
  MinWidth="480" MinHeight="520"
  WindowStartupLocation="CenterScreen"
  Background="Transparent" Foreground="#E8E8F0"
  FontFamily="Segoe UI" WindowStyle="None"
  AllowsTransparency="True" ResizeMode="CanResize">

  <Window.Resources>

    <Style x:Key="NavBtn" TargetType="Button">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#333333"/>
      <Setter Property="FontSize" Value="11"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="HorizontalContentAlignment" Value="Left"/>
      <Setter Property="Padding" Value="12,0"/>
      <Setter Property="Height" Value="36"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="7" Padding="{TemplateBinding Padding}">
              <ContentPresenter VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#111111"/>
                <Setter Property="Foreground" Value="#555555"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style x:Key="NavBtnActive" TargetType="Button">
      <Setter Property="Background" Value="#111111"/>
      <Setter Property="Foreground" Value="#AAAAAA"/>
      <Setter Property="FontSize" Value="11"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="HorizontalContentAlignment" Value="Left"/>
      <Setter Property="Padding" Value="12,0"/>
      <Setter Property="Height" Value="36"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="7" Padding="{TemplateBinding Padding}">
              <ContentPresenter VerticalAlignment="Center"/>
            </Border>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style x:Key="BigBtn" TargetType="Button">
      <Setter Property="Background" Value="#2A2A2A"/>
      <Setter Property="Foreground" Value="#D0D0D0"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="FontWeight" Value="Bold"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="BorderBrush" Value="#3A3A3A"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="9" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#333333"/>
                <Setter TargetName="bd" Property="BorderBrush" Value="#505050"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#1E1E1E"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter TargetName="bd" Property="Background" Value="#161616"/>
                <Setter TargetName="bd" Property="BorderBrush" Value="#222222"/>
                <Setter Property="Foreground" Value="#303030"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style x:Key="DelBtn" TargetType="Button">
      <Setter Property="Background" Value="#1A1A1A"/>
      <Setter Property="Foreground" Value="#4B5563"/>
      <Setter Property="FontSize" Value="11"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="BorderBrush" Value="#2A2A2A"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#450A0A"/>
                <Setter TargetName="bd" Property="BorderBrush" Value="#7F1D1D"/>
                <Setter Property="Foreground" Value="#FCA5A5"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#7F1D1D"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter TargetName="bd" Property="Background" Value="#111111"/>
                <Setter TargetName="bd" Property="BorderBrush" Value="#1E1E1E"/>
                <Setter Property="Foreground" Value="#252525"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style x:Key="WinBtn" TargetType="Button">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#4B5563"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Width" Value="30"/>
      <Setter Property="Height" Value="26"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="Transparent" CornerRadius="5">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#222222"/>
                <Setter Property="Foreground" Value="#9CA3AF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style x:Key="CloseBtn" TargetType="Button">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="#4B5563"/>
      <Setter Property="FontSize" Value="12"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Width" Value="30"/>
      <Setter Property="Height" Value="26"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="Transparent" CornerRadius="5">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Background" Value="#7F1D1D"/>
                <Setter Property="Foreground" Value="#EF4444"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <Style TargetType="ScrollBar">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Width" Value="4"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ScrollBar">
            <Grid>
              <Track x:Name="PART_Track" IsDirectionReversed="True">
                <Track.Thumb>
                  <Thumb>
                    <Thumb.Template>
                      <ControlTemplate TargetType="Thumb">
                        <Border Background="#2D2D2D" CornerRadius="2"/>
                      </ControlTemplate>
                    </Thumb.Template>
                  </Thumb>
                </Track.Thumb>
              </Track>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

  </Window.Resources>

  <Grid>
    <Border CornerRadius="14" Background="#0A0A0A" BorderBrush="#1F1F1F" BorderThickness="1" Margin="2">
      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="46"/>
          <RowDefinition Height="*"/>
          <RowDefinition Height="42"/>
        </Grid.RowDefinitions>

        <!-- Titlebar -->
        <Border Grid.Row="0" Background="#0F0F0F" CornerRadius="14,14,0,0" BorderBrush="#1F1F1F" BorderThickness="0,0,0,1">
          <Grid Margin="14,0">
            <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
              <Ellipse Width="7" Height="7" Fill="#22C55E" Margin="0,0,9,0"/>
              <TextBlock Text="EXECUTABLE  PERFORMANCE  MANAGER" FontSize="13" FontWeight="Bold" Foreground="#C8C8C8"/>
              <Border x:Name="GithubBtn" Background="#141414" BorderBrush="#272727" BorderThickness="1"
                      CornerRadius="5" Padding="7,3" Margin="10,0,0,0" Cursor="Hand" VerticalAlignment="Center">
                <TextBlock Text="github / insovs" FontSize="9" Foreground="#666666"/>
              </Border>
            </StackPanel>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
              <Button x:Name="BtnMinimize" Content="&#x2014;" Style="{StaticResource WinBtn}"/>
              <Button x:Name="BtnClose"    Content="&#x2715;" Style="{StaticResource CloseBtn}" Margin="2,0,0,0"/>
            </StackPanel>
          </Grid>
        </Border>

        <!-- Body: Sidebar + Content -->
        <Grid Grid.Row="1">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="148"/>
            <ColumnDefinition Width="*"/>
          </Grid.ColumnDefinitions>

          <!-- Sidebar -->
          <Border Grid.Column="0" Background="#0C0C0C" BorderBrush="#1A1A1A" BorderThickness="0,0,1,0">
            <StackPanel Margin="8,12,8,0">
              <Button x:Name="NavCpu"        Content="CPU Priority"    Style="{StaticResource NavBtnActive}" Margin="0,0,0,2"/>
              <Button x:Name="NavQos"        Content="QoS Network"     Style="{StaticResource NavBtn}"       Margin="0,0,0,2"/>
              <Button x:Name="NavGpu"        Content="GPU Preference"  Style="{StaticResource NavBtn}"       Margin="0,0,0,2"/>
              <Button x:Name="NavAdmin"      Content="Run As Admin"    Style="{StaticResource NavBtn}"       Margin="0,0,0,2"/>
              <Button x:Name="NavFirewall"   Content="Firewall"        Style="{StaticResource NavBtn}"       Margin="0,0,0,2"/>
              <Button x:Name="NavDefender"   Content="Defender"        Style="{StaticResource NavBtn}"       Margin="0,0,0,2"/>
              <Button x:Name="NavFullscreen" Content="Fullscreen"      Style="{StaticResource NavBtn}"       Margin="0,0,0,2"/>
            </StackPanel>
          </Border>

          <!-- Pages container -->
          <ScrollViewer Grid.Column="1" x:Name="PageScrollViewer" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
            <StackPanel x:Name="PageHost" Margin="14,12,14,10">

              <!-- PAGE: CPU Priority -->
              <StackPanel x:Name="PageCpu">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What is CPU priority ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Sets CpuPriorityClass=3 (High) and IoPriority=3 (High) via Image File Execution Options. Windows will schedule the process with elevated CPU and disk access priority at every launch.
                    </TextBlock>
                  </StackPanel>
                </Border>
                <Button x:Name="BtnCpuBrowse" Content="+ Add a game or app" Style="{StaticResource BigBtn}" Padding="0,13" Margin="0,0,0,12"/>
                <Grid Margin="0,0,0,6">
                  <TextBlock Text="ACTIVE RULES" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" VerticalAlignment="Center"/>
                  <Button x:Name="BtnCpuDelete" Content="Delete selected" Style="{StaticResource DelBtn}" Padding="10,5" HorizontalAlignment="Right" IsEnabled="False"/>
                </Grid>
                <Border Background="#111111" CornerRadius="10" BorderBrush="#1F1F1F" BorderThickness="1" MinHeight="70">
                  <Grid>
                    <StackPanel x:Name="CpuEmpty" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,18,0,18">
                      <TextBlock Text="No rules yet" Foreground="#222222" FontSize="13" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock Text="Add your first app above" Foreground="#1A1A1A" FontSize="10" HorizontalAlignment="Center" Margin="0,3,0,0"/>
                    </StackPanel>
                    <StackPanel x:Name="CpuList" Margin="8,6,8,6"/>
                  </Grid>
                </Border>
              </StackPanel>

              <!-- PAGE: QoS -->
              <StackPanel x:Name="PageQos" Visibility="Collapsed">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What is a QoS rule ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Gives an app the highest network priority via DSCP 46. Windows and your router process its packets first, reducing ping spikes and jitter when other apps are active on the network.
                    </TextBlock>
                  </StackPanel>
                </Border>
                <Button x:Name="BtnQosBrowse" Content="+ Add a game or app" Style="{StaticResource BigBtn}" Padding="0,13" Margin="0,0,0,12"/>
                <Grid Margin="0,0,0,6">
                  <TextBlock Text="ACTIVE RULES" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" VerticalAlignment="Center"/>
                  <Button x:Name="BtnQosDelete" Content="Delete selected" Style="{StaticResource DelBtn}" Padding="10,5" HorizontalAlignment="Right" IsEnabled="False"/>
                </Grid>
                <Border Background="#111111" CornerRadius="10" BorderBrush="#1F1F1F" BorderThickness="1" MinHeight="70">
                  <Grid>
                    <StackPanel x:Name="QosEmpty" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,18,0,18">
                      <TextBlock Text="No rules yet" Foreground="#222222" FontSize="13" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock Text="Add your first app above" Foreground="#1A1A1A" FontSize="10" HorizontalAlignment="Center" Margin="0,3,0,0"/>
                    </StackPanel>
                    <StackPanel x:Name="QosList" Margin="8,6,8,6"/>
                  </Grid>
                </Border>
              </StackPanel>

              <!-- PAGE: GPU -->
              <StackPanel x:Name="PageGpu" Visibility="Collapsed">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What is GPU preference ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Forces Windows to use the High Performance GPU for the selected app (GpuPreference=2). Useful on laptops with hybrid GPU setups to ensure the discrete GPU is always used.
                    </TextBlock>
                  </StackPanel>
                </Border>
                <Button x:Name="BtnGpuBrowse" Content="+ Add a game or app" Style="{StaticResource BigBtn}" Padding="0,13" Margin="0,0,0,12"/>
                <Grid Margin="0,0,0,6">
                  <TextBlock Text="ACTIVE RULES" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" VerticalAlignment="Center"/>
                  <Button x:Name="BtnGpuDelete" Content="Delete selected" Style="{StaticResource DelBtn}" Padding="10,5" HorizontalAlignment="Right" IsEnabled="False"/>
                </Grid>
                <Border Background="#111111" CornerRadius="10" BorderBrush="#1F1F1F" BorderThickness="1" MinHeight="70">
                  <Grid>
                    <StackPanel x:Name="GpuEmpty" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,18,0,18">
                      <TextBlock Text="No rules yet" Foreground="#222222" FontSize="13" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock Text="Add your first app above" Foreground="#1A1A1A" FontSize="10" HorizontalAlignment="Center" Margin="0,3,0,0"/>
                    </StackPanel>
                    <StackPanel x:Name="GpuList" Margin="8,6,8,6"/>
                  </Grid>
                </Border>
              </StackPanel>

              <!-- PAGE: Run As Admin -->
              <StackPanel x:Name="PageAdmin" Visibility="Collapsed">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What is Run As Admin ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Configures the app to always launch with administrator privileges via AppCompatFlags and IFEO. Grants elevated rights for better compatibility and resource access. Note: some apps may refuse to launch with this set.
                    </TextBlock>
                  </StackPanel>
                </Border>
                <Button x:Name="BtnAdminBrowse" Content="+ Add a game or app" Style="{StaticResource BigBtn}" Padding="0,13" Margin="0,0,0,12"/>
                <Grid Margin="0,0,0,6">
                  <TextBlock Text="ACTIVE RULES" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" VerticalAlignment="Center"/>
                  <Button x:Name="BtnAdminDelete" Content="Delete selected" Style="{StaticResource DelBtn}" Padding="10,5" HorizontalAlignment="Right" IsEnabled="False"/>
                </Grid>
                <Border Background="#111111" CornerRadius="10" BorderBrush="#1F1F1F" BorderThickness="1" MinHeight="70">
                  <Grid>
                    <StackPanel x:Name="AdminEmpty" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,18,0,18">
                      <TextBlock Text="No rules yet" Foreground="#222222" FontSize="13" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock Text="Add your first app above" Foreground="#1A1A1A" FontSize="10" HorizontalAlignment="Center" Margin="0,3,0,0"/>
                    </StackPanel>
                    <StackPanel x:Name="AdminList" Margin="8,6,8,6"/>
                  </Grid>
                </Border>
              </StackPanel>

              <!-- PAGE: Firewall -->
              <StackPanel x:Name="PageFirewall" Visibility="Collapsed">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What are firewall rules ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Adds explicit Inbound and Outbound Allow rules to Windows Firewall for the selected app. Prevents the firewall from blocking connections, reducing latency and packet loss.
                    </TextBlock>
                  </StackPanel>
                </Border>

                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,12" Margin="0,0,0,10">
                  <StackPanel>
                    <TextBlock Text="ADD FIREWALL RULE" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" Margin="0,0,0,10"/>
                    <TextBlock Text="Allow app through firewall" FontSize="11" FontWeight="SemiBold" Foreground="#666666"/>
                    <TextBlock Text="Creates Inbound + Outbound Allow rules for the selected executable" FontSize="9" Foreground="#282828" Margin="0,2,0,10" TextWrapping="Wrap"/>
                    <Button x:Name="BtnFirewallBrowse" Content="+ Add app" Style="{StaticResource BigBtn}" Padding="0,8" HorizontalAlignment="Stretch"/>
                  </StackPanel>
                </Border>
              </StackPanel>

              <!-- PAGE: Defender -->
              <StackPanel x:Name="PageDefender" Visibility="Collapsed">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What is a Defender exclusion ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Adds the folder containing the selected executable to Windows Defender's exclusion list. Prevents real-time background scans from impacting game performance and causing stutter.
                    </TextBlock>
                  </StackPanel>
                </Border>
                <!-- Warning banner: shown when Defender is unavailable -->
                <Border x:Name="DefenderWarningBanner" Visibility="Collapsed"
                        Background="#1A0A00" BorderBrush="#7C2D12" BorderThickness="1"
                        CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,6">
                      <Border Background="#2D1000" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="!" FontSize="11" FontWeight="Bold" Foreground="#F97316" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock x:Name="DefenderWarningTitle" Text="Windows Defender unavailable" FontSize="12" FontWeight="Bold" Foreground="#F97316" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock x:Name="DefenderWarningMsg" TextWrapping="Wrap" Foreground="#7C3A1A" FontSize="11" LineHeight="17" Margin="28,0,0,0"/>
                  </StackPanel>
                </Border>

                <Button x:Name="BtnDefenderBrowse" Content="+ Add a game or app" Style="{StaticResource BigBtn}" Padding="0,13" Margin="0,0,0,12"/>
                <Grid Margin="0,0,0,6">
                  <TextBlock Text="ACTIVE EXCLUSIONS" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" VerticalAlignment="Center"/>
                  <Button x:Name="BtnDefenderDelete" Content="Delete selected" Style="{StaticResource DelBtn}" Padding="10,5" HorizontalAlignment="Right" IsEnabled="False"/>
                </Grid>
                <Border Background="#111111" CornerRadius="10" BorderBrush="#1F1F1F" BorderThickness="1" MinHeight="70">
                  <Grid>
                    <StackPanel x:Name="DefenderEmpty" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,18,0,18">
                      <TextBlock Text="No exclusions yet" Foreground="#222222" FontSize="13" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock Text="Add your first app above" Foreground="#1A1A1A" FontSize="10" HorizontalAlignment="Center" Margin="0,3,0,0"/>
                    </StackPanel>
                    <StackPanel x:Name="DefenderList" Margin="8,6,8,6"/>
                  </Grid>
                </Border>
              </StackPanel>

              <!-- PAGE: Fullscreen -->
              <StackPanel x:Name="PageFullscreen" Visibility="Collapsed">
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,11" Margin="0,0,0,10">
                  <StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,5">
                      <Border Background="#1E1E1E" CornerRadius="4" Width="20" Height="20" Margin="0,0,8,0" VerticalAlignment="Center">
                        <TextBlock Text="?" FontSize="11" FontWeight="Bold" Foreground="#888888" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                      </Border>
                      <TextBlock Text="What is Fullscreen Optimization ?" FontSize="12" FontWeight="Bold" Foreground="#666666" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock TextWrapping="Wrap" Foreground="#3A3A3A" FontSize="11" LineHeight="17">
Disables Windows Fullscreen Optimizations (FSO) and configures the system scheduler for gaming. FSO can cause input lag and frame pacing issues — disabling it forces true exclusive fullscreen for lower latency.
                    </TextBlock>
                  </StackPanel>
                </Border>

                <!-- System-wide FSO toggle only -->
                <Border Background="#111111" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="10" Padding="14,12" Margin="0,0,0,10">
                  <StackPanel>
                    <TextBlock Text="SYSTEM-WIDE TWEAKS" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" Margin="0,0,0,10"/>

                    <!-- FSO toggle -->
                    <Grid>
                      <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                      </Grid.ColumnDefinitions>
                      <StackPanel>
                        <TextBlock Text="Disable Fullscreen Optimizations" FontSize="11" FontWeight="SemiBold" Foreground="#666666"/>
                        <TextBlock Text="GameConfigStore — forces true exclusive fullscreen" FontSize="9" Foreground="#282828" Margin="0,2,0,0"/>
                      </StackPanel>
                      <Button x:Name="BtnFsoToggle" Grid.Column="1" Content="Apply" Style="{StaticResource BigBtn}" Padding="14,6" VerticalAlignment="Center"/>
                    </Grid>
                  </StackPanel>
                </Border>

                <!-- Per-app FSO disable -->
                <Button x:Name="BtnFsoBrowse" Content="+ Disable FSO for a specific app" Style="{StaticResource BigBtn}" Padding="0,13" Margin="0,0,0,12"/>
                <Grid Margin="0,0,0,6">
                  <TextBlock Text="PER-APP FSO DISABLED" FontSize="10" FontWeight="Bold" Foreground="#2E2E2E" VerticalAlignment="Center"/>
                  <Button x:Name="BtnFsoDelete" Content="Delete selected" Style="{StaticResource DelBtn}" Padding="10,5" HorizontalAlignment="Right" IsEnabled="False"/>
                </Grid>
                <Border Background="#111111" CornerRadius="10" BorderBrush="#1F1F1F" BorderThickness="1" MinHeight="70">
                  <Grid>
                    <StackPanel x:Name="FsoEmpty" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="0,18,0,18">
                      <TextBlock Text="No per-app rules yet" Foreground="#222222" FontSize="13" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock Text="Add an app above" Foreground="#1A1A1A" FontSize="10" HorizontalAlignment="Center" Margin="0,3,0,0"/>
                    </StackPanel>
                    <StackPanel x:Name="FsoList" Margin="8,6,8,6"/>
                  </Grid>
                </Border>
              </StackPanel>

            </StackPanel>
          </ScrollViewer>
        </Grid>

        <!-- Footer -->
        <Border Grid.Row="2" Background="#0F0F0F" CornerRadius="0,0,14,14" BorderBrush="#1F1F1F" BorderThickness="0,1,0,0">
          <Grid Margin="14,0">
            <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
              <Ellipse x:Name="StatusDot" Width="6" Height="6" Fill="#1E1E1E" Margin="0,0,7,0" VerticalAlignment="Center"/>
              <TextBlock x:Name="StatusLabel" Text="Ready" Foreground="#2E2E2E" FontSize="11"/>
            </StackPanel>

          </Grid>
        </Border>

      </Grid>
    </Border>

    <!-- Resize thumbs -->
    <Thumb x:Name="ThumbR"  Width="6"  HorizontalAlignment="Right" VerticalAlignment="Stretch"   Margin="0,14,0,14" Opacity="0" Cursor="SizeWE"/>
    <Thumb x:Name="ThumbL"  Width="6"  HorizontalAlignment="Left"  VerticalAlignment="Stretch"   Margin="0,14,0,14" Opacity="0" Cursor="SizeWE"/>
    <Thumb x:Name="ThumbB"  Height="6" VerticalAlignment="Bottom"  HorizontalAlignment="Stretch" Margin="14,0,14,0" Opacity="0" Cursor="SizeNS"/>
    <Thumb x:Name="ThumbBR" Width="14" Height="14" HorizontalAlignment="Right" VerticalAlignment="Bottom" Opacity="0" Cursor="SizeNWSE"/>
    <Path Data="M 0 9 L 9 0 M 4 9 L 9 4 M 7 9 L 9 7" Stroke="#2D2D2D" StrokeThickness="1.3"
          HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,8,8" IsHitTestVisible="False"/>
  </Grid>
</Window>
'@

# ─────────────────────────────────────────────────────────────
#  Parse + bind
# ─────────────────────────────────────────────────────────────
$script:Win = ConvertFrom-XamlString $xaml

$bindNames = @(
    'NavCpu','NavQos','NavGpu','NavAdmin','NavFirewall','NavDefender','NavFullscreen',
    'PageCpu','PageQos','PageGpu','PageAdmin','PageFirewall','PageDefender','PageFullscreen',
    'PageHost','PageScrollViewer',
    'BtnCpuBrowse','BtnCpuDelete','CpuEmpty','CpuList',
    'BtnQosBrowse','BtnQosDelete','QosEmpty','QosList',
    'BtnGpuBrowse','BtnGpuDelete','GpuEmpty','GpuList',
    'BtnAdminBrowse','BtnAdminDelete','AdminEmpty','AdminList',
    'BtnFirewallBrowse',
    'BtnDefenderBrowse','BtnDefenderDelete','DefenderEmpty','DefenderList',
    'DefenderWarningBanner','DefenderWarningTitle','DefenderWarningMsg',
    'BtnFsoBrowse','BtnFsoDelete','FsoEmpty','FsoList',
    'BtnFsoToggle',
    'BtnClose','BtnMinimize','StatusDot','StatusLabel',
    'GithubBtn',
    'ThumbR','ThumbL','ThumbB','ThumbBR'
)
foreach ($n in $bindNames) {
    Set-Variable -Name $n -Scope Script -Value $script:Win.FindName($n)
}

$script:SelectedCpu      = [System.Collections.Generic.List[string]]::new()
$script:SelectedQos      = [System.Collections.Generic.List[string]]::new()
$script:SelectedGpu      = [System.Collections.Generic.List[string]]::new()
$script:SelectedAdmin    = [System.Collections.Generic.List[string]]::new()
$script:SelectedDefender = [System.Collections.Generic.List[string]]::new()
$script:SelectedFso      = [System.Collections.Generic.List[string]]::new()

# ─────────────────────────────────────────────────────────────
#  Navigation
# ─────────────────────────────────────────────────────────────
$script:AllPages = @('PageCpu','PageQos','PageGpu','PageAdmin','PageFirewall','PageDefender','PageFullscreen')
$script:AllNavs  = @('NavCpu','NavQos','NavGpu','NavAdmin','NavFirewall','NavDefender','NavFullscreen')

function Switch-Page {
    param([string]$page, [string]$nav)
    foreach ($p in $script:AllPages) {
        (Get-Variable -Name $p -Scope Script -ValueOnly).Visibility = [System.Windows.Visibility]::Collapsed
    }
    foreach ($n in $script:AllNavs) {
        (Get-Variable -Name $n -Scope Script -ValueOnly).Style = $script:Win.FindResource('NavBtn')
    }
    (Get-Variable -Name $page -Scope Script -ValueOnly).Visibility = [System.Windows.Visibility]::Visible
    (Get-Variable -Name $nav  -Scope Script -ValueOnly).Style = $script:Win.FindResource('NavBtnActive')
    $script:PageScrollViewer.ScrollToTop()
    Set-Status 'Ready' '#2E2E2E'
}

# ─────────────────────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────────────────────
function Set-Status {
    param([string]$text, [string]$color = '#2E2E2E')
    $script:StatusLabel.Text = $text
    $script:StatusDot.Fill   = New-Brush $color
}

function Get-PrioLabel { param([string]$v)
    switch ($v) { '4'{'Realtime'} '3'{'High'} '2'{'Above Normal'} '1'{'Normal'} '0'{'Idle'} default{"Level $v"} }
}
function Get-PrioColor { param([string]$v)
    switch ($v) { '4'{'#F87171'} '3'{'#22C55E'} '2'{'#F59E0B'} '1'{'#3A3A3A'} '0'{'#EF4444'} default{'#4A4A4A'} }
}

function New-PillRow {
    param([string]$labelText, [string]$valueText, [string]$valueColor)
    $pill  = [System.Windows.Controls.Border]::new()
    $pill.Background      = New-Brush '#0A0A0A'
    $pill.BorderBrush     = New-Brush '#1F1F1F'
    $pill.BorderThickness = [System.Windows.Thickness]::new(1)
    $pill.CornerRadius    = [System.Windows.CornerRadius]::new(4)
    $pill.Padding         = [System.Windows.Thickness]::new(7,3,7,3)
    $pill.Margin          = [System.Windows.Thickness]::new(0,0,5,0)
    $inner = [System.Windows.Controls.StackPanel]::new()
    $inner.Orientation = [System.Windows.Controls.Orientation]::Horizontal
    $lbl = [System.Windows.Controls.TextBlock]::new()
    $lbl.Text = "$labelText  "; $lbl.FontSize = 9; $lbl.Foreground = New-Brush '#3A3A3A'
    $val = [System.Windows.Controls.TextBlock]::new()
    $val.Text = $valueText; $val.FontSize = 9; $val.FontWeight = [System.Windows.FontWeights]::SemiBold
    $val.Foreground = New-Brush $valueColor
    [void]$inner.Children.Add($lbl); [void]$inner.Children.Add($val)
    $pill.Child = $inner
    return $pill
}

function New-SimpleRow {
    param([string]$listName, [string]$selListName, [string]$deleteBtnName,
          [string]$displayName, [string]$keyName, [string]$subText = '')

    $selList   = Get-Variable -Name $selListName   -Scope Script -ValueOnly
    $deleteBtn = Get-Variable -Name $deleteBtnName -Scope Script -ValueOnly

    $row = [System.Windows.Controls.Border]::new()
    $row.CornerRadius    = [System.Windows.CornerRadius]::new(8)
    $row.Margin          = [System.Windows.Thickness]::new(0,0,0,4)
    $row.Padding         = [System.Windows.Thickness]::new(10,8,10,8)
    $row.Background      = New-Brush '#0E0E0E'
    $row.BorderBrush     = New-Brush '#1F1F1F'
    $row.BorderThickness = [System.Windows.Thickness]::new(1)

    $grid = [System.Windows.Controls.Grid]::new()
    $c0 = [System.Windows.Controls.ColumnDefinition]::new(); $c0.Width = [System.Windows.GridLength]::Auto
    $c1 = [System.Windows.Controls.ColumnDefinition]::new(); $c1.Width = [System.Windows.GridLength]::new(1,[System.Windows.GridUnitType]::Star)
    [void]$grid.ColumnDefinitions.Add($c0); [void]$grid.ColumnDefinitions.Add($c1)

    $cb = [System.Windows.Controls.CheckBox]::new()
    $cb.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
    $cb.Margin = [System.Windows.Thickness]::new(0,0,10,0)

    $cb.Tag = [pscustomobject]@{ Key = $keyName; List = $selList; Btn = $deleteBtn }

    $cb.Add_Checked({
        $t = $this.Tag
        if (-not $t.List.Contains($t.Key)) { $t.List.Add($t.Key) }
        $t.Btn.IsEnabled = $true
    })
    $cb.Add_Unchecked({
        $t = $this.Tag
        $t.List.Remove($t.Key) | Out-Null
        $t.Btn.IsEnabled = ($t.List.Count -gt 0)
    })
    [System.Windows.Controls.Grid]::SetColumn($cb, 0)

    $info = [System.Windows.Controls.StackPanel]::new()
    [System.Windows.Controls.Grid]::SetColumn($info, 1)

    $nameRow = [System.Windows.Controls.StackPanel]::new()
    $nameRow.Orientation = [System.Windows.Controls.Orientation]::Horizontal
    $nameRow.Margin = [System.Windows.Thickness]::new(0,0,0,2)

    $dot = [System.Windows.Shapes.Ellipse]::new()
    $dot.Width = 5; $dot.Height = 5; $dot.Fill = New-Brush '#22C55E'
    $dot.Margin = [System.Windows.Thickness]::new(0,0,7,0)
    $dot.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
    [void]$nameRow.Children.Add($dot)

    $nameTb = [System.Windows.Controls.TextBlock]::new()
    $nameTb.Text = $displayName; $nameTb.FontSize = 12
    $nameTb.FontWeight = [System.Windows.FontWeights]::SemiBold
    $nameTb.Foreground = New-Brush '#A0A0A0'
    $nameTb.TextTrimming = [System.Windows.TextTrimming]::CharacterEllipsis
    $nameTb.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
    [void]$nameRow.Children.Add($nameTb)
    [void]$info.Children.Add($nameRow)

    if ($subText -and $subText -ne '') {
        $subTb = [System.Windows.Controls.TextBlock]::new()
        $subTb.Text = $subText; $subTb.FontSize = 9
        $subTb.Foreground = New-Brush '#252525'
        $subTb.TextTrimming = [System.Windows.TextTrimming]::CharacterEllipsis
        [void]$info.Children.Add($subTb)
    }

    [void]$grid.Children.Add($cb); [void]$grid.Children.Add($info)
    $row.Child = $grid
    return $row
}

function Show-SuccessPopup {
    param([string]$exeName, [string]$line1, [string]$line2 = '')
    $ns = 'xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"'
    $btnTpl = '<Button.Template><ControlTemplate TargetType="Button"><Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="5" Padding="{TemplateBinding Padding}"><ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/></Border><ControlTemplate.Triggers><Trigger Property="IsMouseOver" Value="True"><Setter TargetName="bd" Property="Background" Value="#2A2A2A"/></Trigger></ControlTemplate.Triggers></ControlTemplate></Button.Template>'
    $px  = '<Window ' + $ns + ' Width="280" SizeToContent="Height" WindowStartupLocation="Manual" Background="Transparent" WindowStyle="None" AllowsTransparency="True" ResizeMode="NoResize" ShowInTaskbar="False">'
    $px += '<Border CornerRadius="12" Padding="28,24,28,24"><Border.Background><SolidColorBrush Color="#0D0D0D" Opacity="0.98"/></Border.Background>'
    $px += '<StackPanel>'
    $px += '<TextBlock Text="&#x2714;" FontSize="26" FontWeight="Bold" Foreground="#22C55E" HorizontalAlignment="Center" Margin="0,0,0,10"/>'
    $px += '<TextBlock Text="Applied" FontSize="15" FontWeight="Bold" Foreground="#C8C8C8" HorizontalAlignment="Center" Margin="0,0,0,4"/>'
    $px += '<TextBlock Text="' + [System.Security.SecurityElement]::Escape($exeName) + '" FontSize="11" Foreground="#555555" HorizontalAlignment="Center" Margin="0,0,0,14"/>'
    if ($line1) {
        $px += '<Border Background="#0A0A0A" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="4" Padding="8,4" Margin="0,0,0,4" HorizontalAlignment="Center">'
        $px += '<TextBlock Text="' + [System.Security.SecurityElement]::Escape($line1) + '" FontSize="9" FontWeight="SemiBold" Foreground="#22C55E"/></Border>'
    }
    if ($line2) {
        $px += '<Border Background="#0A0A0A" BorderBrush="#1F1F1F" BorderThickness="1" CornerRadius="4" Padding="8,4" Margin="0,0,0,0" HorizontalAlignment="Center">'
        $px += '<TextBlock Text="' + [System.Security.SecurityElement]::Escape($line2) + '" FontSize="9" FontWeight="SemiBold" Foreground="#22C55E"/></Border>'
    }
    $px += '<Rectangle Height="1" Fill="#1A1A1A" Margin="0,16,0,16"/>'
    $px += '<Button x:Name="BtnOK" Content="OK" Width="80" Height="28" HorizontalAlignment="Center" FontSize="12" FontWeight="SemiBold" Foreground="#888888" Background="#161616" BorderThickness="0" Cursor="Hand">' + $btnTpl + '</Button>'
    $px += '</StackPanel></Border></Window>'
    $popup = ConvertFrom-XamlString $px
    $popup.Owner = $script:Win
    $popup.Add_ContentRendered({
        $popup.Left = $script:Win.Left + ($script:Win.ActualWidth  - $popup.ActualWidth)  / 2
        $popup.Top  = $script:Win.Top  + ($script:Win.ActualHeight - $popup.ActualHeight) / 2
    })
    $popup.Add_MouseLeftButtonDown({ param($s,$e); if ($e.Source -isnot [System.Windows.Controls.Button]) { $popup.DragMove() } })
    $popup.FindName('BtnOK').Add_Click({ $popup.Close() })
    $popup.ShowDialog() | Out-Null
}


# ─────────────────────────────────────────────────────────────
#  CPU Priority
# ─────────────────────────────────────────────────────────────
function Load-CpuRules {
    $script:CpuList.Children.Clear()
    $script:SelectedCpu.Clear()
    $script:BtnCpuDelete.IsEnabled = $false
    $rules = @()
    if (Test-Path $script:PrioBase) {
        try {
            foreach ($key in Get-ChildItem -Path $script:PrioBase -ErrorAction Stop) {
                $perfPath = Join-Path $key.PSPath 'PerfOptions'
                if (-not (Test-Path $perfPath)) { continue }
                $p = Get-ItemProperty -Path $perfPath -ErrorAction SilentlyContinue
                if ($null -eq $p.CpuPriorityClass -and $null -eq $p.IoPriority) { continue }
                $rules += [pscustomobject]@{
                    Name    = $key.PSChildName
                    CpuPrio = if ($null -ne $p.CpuPriorityClass) { "$($p.CpuPriorityClass)" } else { '?' }
                    IoPrio  = if ($null -ne $p.IoPriority)       { "$($p.IoPriority)"       } else { '?' }
                }
            }
        } catch {}
    }
    if ($rules.Count -eq 0) {
        $script:CpuEmpty.Visibility = [System.Windows.Visibility]::Visible
        Set-Status 'No CPU rules found' '#1E1E1E'; return
    }
    $script:CpuEmpty.Visibility = [System.Windows.Visibility]::Collapsed
    foreach ($rule in $rules) {
        $row = [System.Windows.Controls.Border]::new()
        $row.CornerRadius = [System.Windows.CornerRadius]::new(8)
        $row.Margin = [System.Windows.Thickness]::new(0,0,0,4)
        $row.Padding = [System.Windows.Thickness]::new(10,8,10,8)
        $row.Background = New-Brush '#0E0E0E'; $row.BorderBrush = New-Brush '#1F1F1F'
        $row.BorderThickness = [System.Windows.Thickness]::new(1)
        $grid = [System.Windows.Controls.Grid]::new()
        $c0 = [System.Windows.Controls.ColumnDefinition]::new(); $c0.Width = [System.Windows.GridLength]::Auto
        $c1 = [System.Windows.Controls.ColumnDefinition]::new(); $c1.Width = [System.Windows.GridLength]::new(1,[System.Windows.GridUnitType]::Star)
        [void]$grid.ColumnDefinitions.Add($c0); [void]$grid.ColumnDefinitions.Add($c1)
        $ruleName = $rule.Name
        $cb = [System.Windows.Controls.CheckBox]::new()
        $cb.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        $cb.Margin = [System.Windows.Thickness]::new(0,0,10,0)
        $cb.Tag = [pscustomobject]@{ Key = $ruleName; List = $script:SelectedCpu; Btn = $script:BtnCpuDelete }
        $cb.Add_Checked({
            $t = $this.Tag
            if (-not $t.List.Contains($t.Key)) { $t.List.Add($t.Key) }
            $t.Btn.IsEnabled = $true
        })
        $cb.Add_Unchecked({
            $t = $this.Tag
            $t.List.Remove($t.Key) | Out-Null
            $t.Btn.IsEnabled = ($t.List.Count -gt 0)
        })
        [System.Windows.Controls.Grid]::SetColumn($cb, 0)
        $info = [System.Windows.Controls.StackPanel]::new()
        [System.Windows.Controls.Grid]::SetColumn($info, 1)
        $nameRow = [System.Windows.Controls.StackPanel]::new()
        $nameRow.Orientation = [System.Windows.Controls.Orientation]::Horizontal
        $nameRow.Margin = [System.Windows.Thickness]::new(0,0,0,2)
        $dot = [System.Windows.Shapes.Ellipse]::new(); $dot.Width = 5; $dot.Height = 5
        $dot.Fill = New-Brush '#22C55E'; $dot.Margin = [System.Windows.Thickness]::new(0,0,7,0)
        $dot.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        [void]$nameRow.Children.Add($dot)
        $nameTb = [System.Windows.Controls.TextBlock]::new()
        $nameTb.Text = $ruleName; $nameTb.FontSize = 12
        $nameTb.FontWeight = [System.Windows.FontWeights]::SemiBold; $nameTb.Foreground = New-Brush '#A0A0A0'
        $nameTb.TextTrimming = [System.Windows.TextTrimming]::CharacterEllipsis
        $nameTb.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        [void]$nameRow.Children.Add($nameTb); [void]$info.Children.Add($nameRow)
        $pillsRow = [System.Windows.Controls.StackPanel]::new()
        $pillsRow.Orientation = [System.Windows.Controls.Orientation]::Horizontal
        $pillsRow.Margin = [System.Windows.Thickness]::new(0,4,0,0)
        [void]$pillsRow.Children.Add((New-PillRow 'CPU Priority' (Get-PrioLabel $rule.CpuPrio) (Get-PrioColor $rule.CpuPrio)))
        [void]$pillsRow.Children.Add((New-PillRow 'IO Priority'  (Get-PrioLabel $rule.IoPrio)  (Get-PrioColor $rule.IoPrio)))
        [void]$info.Children.Add($pillsRow)
        [void]$grid.Children.Add($cb); [void]$grid.Children.Add($info)
        $row.Child = $grid; [void]$script:CpuList.Children.Add($row)
    }
    Set-Status "$($rules.Count) CPU rule$(if($rules.Count -ne 1){'s'}) active" '#22C55E'
}

function Add-CpuRule { param([string]$exePath)
    $exeName = [System.IO.Path]::GetFileName($exePath)
    try {
        $keyPath = Join-Path $script:PrioBase $exeName
        if (-not (Test-Path $keyPath)) { New-Item -Path $keyPath -Force -ErrorAction Stop | Out-Null }
        $perfCheckPath = Join-Path $keyPath 'PerfOptions'
        if (Test-Path $perfCheckPath) {
            $existing = Get-ItemProperty -Path $perfCheckPath -ErrorAction SilentlyContinue
            if ($existing.CpuPriorityClass -eq 3 -and $existing.IoPriority -eq 3) {
                Set-Status "Already set: $exeName" '#F59E0B'; return
            }
        }
        $perfPath = Join-Path $keyPath 'PerfOptions'
        if (-not (Test-Path $perfPath)) { New-Item -Path $perfPath -Force -ErrorAction Stop | Out-Null }
        Set-ItemProperty -Path $perfPath -Name 'CpuPriorityClass' -Value 3 -Type DWord
        Set-ItemProperty -Path $perfPath -Name 'IoPriority'       -Value 3 -Type DWord
        Load-CpuRules
        Show-SuccessPopup -exeName $exeName -line1 'CPU Priority  High' -line2 'IO Priority  High'
        Set-Status "Priority set: $exeName" '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
}

$script:BtnCpuBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Set-Status "Setting priority..." '#888888'; Add-CpuRule -exePath $dlg.FileName
    }
})
$script:BtnCpuDelete.Add_Click({
    if ($script:SelectedCpu.Count -eq 0) { return }
    $ok = 0; $fail = 0
    foreach ($name in @($script:SelectedCpu)) {
        try {
            $perfPath = Join-Path $script:PrioBase "$name\PerfOptions"
            if (Test-Path $perfPath) {
                Remove-ItemProperty -Path $perfPath -Name 'CpuPriorityClass' -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $perfPath -Name 'IoPriority'       -ErrorAction SilentlyContinue
                $remaining = Get-ItemProperty -Path $perfPath -ErrorAction SilentlyContinue
                $props = ($remaining.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' }).Count
                if ($props -eq 0) { Remove-Item -Path $perfPath -Force -ErrorAction SilentlyContinue }
            }
            $ifeoPath = Join-Path $script:PrioBase $name
            $subKeys  = (Get-ChildItem -Path $ifeoPath -ErrorAction SilentlyContinue).Count
            $vals     = (Get-ItemProperty -Path $ifeoPath -ErrorAction SilentlyContinue).PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' }
            if ($subKeys -eq 0 -and ($vals | Measure-Object).Count -eq 0) {
                Remove-Item -Path $ifeoPath -Recurse -Force -ErrorAction SilentlyContinue
            }
            $ok++
        } catch { $fail++ }
    }
    Set-Status (if ($fail -eq 0) { "$ok rule$(if($ok -ne 1){'s'}) deleted" } else { "$ok deleted, $fail failed" }) `
               (if ($fail -eq 0) { '#22C55E' } else { '#F59E0B' })
    Load-CpuRules
})

# ─────────────────────────────────────────────────────────────
#  QoS
# ─────────────────────────────────────────────────────────────
function Load-QosRules {
    $script:QosList.Children.Clear()
    $script:SelectedQos.Clear()
    $script:BtnQosDelete.IsEnabled = $false
    $rules = @()
    if (Test-Path $script:QosBase) {
        try {
            foreach ($key in Get-ChildItem -Path $script:QosBase -ErrorAction Stop) {
                $p = Get-ItemProperty -Path $key.PSPath -ErrorAction SilentlyContinue
                if (-not $p) { continue }
                $rules += [pscustomobject]@{
                    Name    = $key.PSChildName
                    AppName = "$($p.'Application Name')"
                    AppPath = "$($p.'AppPathName')"
                }
            }
        } catch {}
    }
    if ($rules.Count -eq 0) {
        $script:QosEmpty.Visibility = [System.Windows.Visibility]::Visible
        Set-Status 'No QoS rules found' '#1E1E1E'; return
    }
    $script:QosEmpty.Visibility = [System.Windows.Visibility]::Collapsed
    foreach ($rule in $rules) {
        $disp = if ($rule.AppName -and $rule.AppName -ne '') { $rule.AppName } else { $rule.Name }
        $row = New-SimpleRow 'QosList' 'SelectedQos' 'BtnQosDelete' $disp $rule.Name $rule.AppPath
        [void]$script:QosList.Children.Add($row)
    }
    Set-Status "$($rules.Count) QoS rule$(if($rules.Count -ne 1){'s'}) active" '#22C55E'
}

function Add-QosRule { param([string]$exePath)
    $exeName  = [System.IO.Path]::GetFileName($exePath)
    $ruleName = [System.IO.Path]::GetFileNameWithoutExtension($exePath)
    try {
        if (-not (Test-Path $script:QosBase)) { New-Item -Path $script:QosBase -Force -ErrorAction Stop | Out-Null }
        $keyPath = Join-Path $script:QosBase $ruleName
        if (Test-Path $keyPath) { Set-Status "Already exists: $exeName" '#F59E0B'; return }
        New-Item -Path $keyPath -Force -ErrorAction Stop | Out-Null
        @{
            'Version'='1.0'; 'Application Name'=$exeName; 'AppPathName'=$exePath
            'DSCP Value'='46'; 'Throttle Rate'='-1'; 'Protocol'='*'
            'Local Port'='*'; 'Remote Port'='*'; 'Local IP'='*'
            'Local IP Prefix Length'='*'; 'Remote IP'='*'; 'Remote IP Prefix Length'='*'
        }.GetEnumerator() | ForEach-Object { Set-ItemProperty -Path $keyPath -Name $_.Key -Value $_.Value -Type String }
        Load-QosRules
        Show-SuccessPopup -exeName $exeName -line1 'DSCP 46 (EF)' -line2 'Throttle Rate  Disabled'
        Set-Status "QoS rule active: $exeName" '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
}

$script:BtnQosBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Set-Status "Adding QoS rule..." '#888888'; Add-QosRule -exePath $dlg.FileName
    }
})
$script:BtnQosDelete.Add_Click({
    if ($script:SelectedQos.Count -eq 0) { return }
    $ok = 0; $fail = 0
    foreach ($name in @($script:SelectedQos)) {
        try { Remove-Item -Path (Join-Path $script:QosBase $name) -Recurse -Force -ErrorAction Stop; $ok++ }
        catch { $fail++ }
    }
    Set-Status (if ($fail -eq 0) { "$ok rule$(if($ok -ne 1){'s'}) deleted" } else { "$ok deleted, $fail failed" }) `
               (if ($fail -eq 0) { '#22C55E' } else { '#F59E0B' })
    Load-QosRules
})

# ─────────────────────────────────────────────────────────────
#  GPU Preference
# ─────────────────────────────────────────────────────────────
function Load-GpuRules {
    $script:GpuList.Children.Clear()
    $script:SelectedGpu.Clear()
    $script:BtnGpuDelete.IsEnabled = $false
    $rules = @()
    if (Test-Path $script:GpuBase) {
        try {
            $p = Get-ItemProperty -Path $script:GpuBase -ErrorAction SilentlyContinue
            if ($p) {
                $p.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                    if ($_.Value -like '*GpuPreference=2*') {
                        $rules += [pscustomobject]@{ Path = $_.Name; Name = [System.IO.Path]::GetFileName($_.Name) }
                    }
                }
            }
        } catch {}
    }
    if ($rules.Count -eq 0) {
        $script:GpuEmpty.Visibility = [System.Windows.Visibility]::Visible
        Set-Status 'No GPU rules found' '#1E1E1E'; return
    }
    $script:GpuEmpty.Visibility = [System.Windows.Visibility]::Collapsed
    foreach ($rule in $rules) {
        $row = New-SimpleRow 'GpuList' 'SelectedGpu' 'BtnGpuDelete' $rule.Name $rule.Path $rule.Path
        [void]$script:GpuList.Children.Add($row)
    }
    Set-Status "$($rules.Count) GPU rule$(if($rules.Count -ne 1){'s'}) active" '#22C55E'
}

function Add-GpuRule { param([string]$exePath)
    $exeName = [System.IO.Path]::GetFileName($exePath)
    try {
        if (-not (Test-Path $script:GpuBase)) { New-Item -Path $script:GpuBase -ItemType Directory | Out-Null }
        New-ItemProperty -Path $script:GpuBase -Name $exePath -Value 'GpuPreference=2' -PropertyType String -Force | Out-Null
        Load-GpuRules
        Show-SuccessPopup -exeName $exeName -line1 'GPU Preference  High Performance'
        Set-Status "GPU preference set: $exeName" '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
}

$script:BtnGpuBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Set-Status "Setting GPU preference..." '#888888'; Add-GpuRule -exePath $dlg.FileName
    }
})
$script:BtnGpuDelete.Add_Click({
    if ($script:SelectedGpu.Count -eq 0) { return }
    $ok = 0; $fail = 0
    foreach ($path in @($script:SelectedGpu)) {
        try {
            Remove-ItemProperty -Path $script:GpuBase -Name $path -Force -ErrorAction Stop
            $ok++
        } catch { $fail++ }
    }
    Set-Status (if ($fail -eq 0) { "$ok rule$(if($ok -ne 1){'s'}) deleted" } else { "$ok deleted, $fail failed" }) `
               (if ($fail -eq 0) { '#22C55E' } else { '#F59E0B' })
    Load-GpuRules
})

# ─────────────────────────────────────────────────────────────
#  Run As Admin
# ─────────────────────────────────────────────────────────────
function Load-AdminRules {
    $script:AdminList.Children.Clear()
    $script:SelectedAdmin.Clear()
    $script:BtnAdminDelete.IsEnabled = $false
    $rules = @()
    if (Test-Path $script:LayersBase) {
        try {
            $p = Get-ItemProperty -Path $script:LayersBase -ErrorAction SilentlyContinue
            if ($p) {
                $p.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                    if ($_.Value -like '*RUNASADMIN*') {
                        $rules += [pscustomobject]@{ Path = $_.Name; Name = [System.IO.Path]::GetFileName($_.Name) }
                    }
                }
            }
        } catch {}
    }
    if ($rules.Count -eq 0) {
        $script:AdminEmpty.Visibility = [System.Windows.Visibility]::Visible
        Set-Status 'No Run As Admin rules found' '#1E1E1E'; return
    }
    $script:AdminEmpty.Visibility = [System.Windows.Visibility]::Collapsed
    foreach ($rule in $rules) {
        $row = New-SimpleRow 'AdminList' 'SelectedAdmin' 'BtnAdminDelete' $rule.Name $rule.Path $rule.Path
        [void]$script:AdminList.Children.Add($row)
    }
    Set-Status "$($rules.Count) admin rule$(if($rules.Count -ne 1){'s'}) active" '#22C55E'
}

function Add-AdminRule { param([string]$exePath)
    $exeName = [System.IO.Path]::GetFileName($exePath)
    try {
        New-ItemProperty -Path $script:LayersBase -Name $exePath -Value '~ RUNASADMIN' -PropertyType String -Force | Out-Null
        $ifeoPath = Join-Path $script:PrioBase ([System.IO.Path]::GetFileName($exePath))
        if (-not (Test-Path $ifeoPath)) { New-Item -Path $ifeoPath -Force | Out-Null }
        New-ItemProperty -Path $ifeoPath -Name 'RunAsAdmin' -Value 1 -PropertyType DWord -Force | Out-Null
        Load-AdminRules
        Show-SuccessPopup -exeName $exeName -line1 'Run As Administrator  Enabled'
        Set-Status "Admin configured: $exeName" '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
}

$script:BtnAdminBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Set-Status "Configuring admin..." '#888888'; Add-AdminRule -exePath $dlg.FileName
    }
})
$script:BtnAdminDelete.Add_Click({
    if ($script:SelectedAdmin.Count -eq 0) { return }
    $ok = 0; $fail = 0
    foreach ($path in @($script:SelectedAdmin)) {
        try {
            Remove-ItemProperty -Path $script:LayersBase -Name $path -Force -ErrorAction SilentlyContinue
            $ifeoPath = Join-Path $script:PrioBase ([System.IO.Path]::GetFileName($path))
            if (Test-Path $ifeoPath) {
                Remove-ItemProperty -Path $ifeoPath -Name 'RunAsAdmin' -Force -ErrorAction SilentlyContinue
                $subKeys = (Get-ChildItem -Path $ifeoPath -ErrorAction SilentlyContinue).Count
                $vals    = (Get-ItemProperty -Path $ifeoPath -ErrorAction SilentlyContinue).PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' }
                if ($subKeys -eq 0 -and ($vals | Measure-Object).Count -eq 0) {
                    Remove-Item -Path $ifeoPath -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
            $ok++
        } catch { $fail++ }
    }
    Set-Status (if ($fail -eq 0) { "$ok rule$(if($ok -ne 1){'s'}) deleted" } else { "$ok deleted, $fail failed" }) `
               (if ($fail -eq 0) { '#22C55E' } else { '#F59E0B' })
    Load-AdminRules
})

# ─────────────────────────────────────────────────────────────
#  Firewall
# ─────────────────────────────────────────────────────────────
function Add-FirewallRule { param([string]$exePath)
    $exeName  = [System.IO.Path]::GetFileName($exePath)
    $baseName = "PerfMgr_$([System.IO.Path]::GetFileNameWithoutExtension($exePath))"
    try {
        New-NetFirewallRule -DisplayName "${baseName}_In"  -Direction Inbound  -Program $exePath -Action Allow -ErrorAction SilentlyContinue | Out-Null
        New-NetFirewallRule -DisplayName "${baseName}_Out" -Direction Outbound -Program $exePath -Action Allow -ErrorAction SilentlyContinue | Out-Null
        Show-SuccessPopup -exeName $exeName -line1 'Firewall  Inbound + Outbound Allow'
        Set-Status "Firewall rules added: $exeName" '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
}

$script:BtnFirewallBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Set-Status "Adding firewall rules..." '#888888'; Add-FirewallRule -exePath $dlg.FileName
    }
})

# ─────────────────────────────────────────────────────────────
#  Defender
# ─────────────────────────────────────────────────────────────
# Detects why Defender/MpPreference is unavailable and returns a descriptive reason string, or $null if OK
function Get-DefenderUnavailableReason {
    # 1. Check if the WinDefend service exists at all
    $svc = Get-Service -Name 'WinDefend' -ErrorAction SilentlyContinue
    if ($null -eq $svc) {
        return @{
            Title = 'Windows Defender is not installed'
            Msg   = 'The WinDefend service was not found on this system. Defender may have been removed or replaced by a third-party antivirus. Exclusions cannot be managed.'
        }
    }

    # 2. Check if Defender is disabled via registry (third-party AV or policy)
    $disabledKey = 'HKLM:\SOFTWARE\Microsoft\Windows Defender'
    try {
        $dval = (Get-ItemProperty -Path $disabledKey -Name 'DisableAntiSpyware' -ErrorAction SilentlyContinue).DisableAntiSpyware
        if ($dval -eq 1) {
            return @{
                Title = 'Windows Defender is disabled'
                Msg   = 'Defender has been disabled via registry (DisableAntiSpyware=1). This usually happens when a third-party antivirus is installed (e.g. Avast, Bitdefender, Kaspersky). Exclusions cannot be added while Defender is inactive.'
            }
        }
    } catch {}

    # 3. Check service status
    if ($svc.Status -ne 'Running') {
        return @{
            Title = "Windows Defender service is $($svc.Status)"
            Msg   = "The WinDefend service exists but is not running (current state: $($svc.Status)). It may be stopped by a policy or a third-party security suite. Try starting it manually or check your antivirus settings."
        }
    }

    # 4. Check if Get-MpPreference cmdlet is available
    if (-not (Get-Command 'Get-MpPreference' -ErrorAction SilentlyContinue)) {
        return @{
            Title = 'Defender PowerShell module unavailable'
            Msg   = 'The Get-MpPreference cmdlet is not available. The Windows Defender PowerShell module may be missing or blocked by policy. Try running: "Import-Module Defender" in an admin PowerShell.'
        }
    }

    # 5. Try calling it
    try {
        Get-MpPreference -ErrorAction Stop | Out-Null
    } catch {
        $msg = $_.Exception.Message
        if ($msg -like '*0x800106ba*' -or $msg -like '*service is not running*') {
            return @{
                Title = 'Defender service not responding'
                Msg   = "Windows Defender is installed but its service is not responding (error: $msg). It may be blocked by a Group Policy or a third-party security product."
            }
        }
        return @{
            Title = 'Cannot access Defender preferences'
            Msg   = "An error occurred while querying Windows Defender: $msg"
        }
    }

    return $null  # All good
}

function Load-DefenderRules {
    $script:DefenderList.Children.Clear()
    $script:SelectedDefender.Clear()
    $script:BtnDefenderDelete.IsEnabled = $false
    $script:DefenderWarningBanner.Visibility = [System.Windows.Visibility]::Collapsed
    $script:BtnDefenderBrowse.IsEnabled = $true
    $rules = @()

    # Check availability first
    $unavailable = Get-DefenderUnavailableReason
    if ($unavailable) {
        $script:DefenderWarningTitle.Text = $unavailable.Title
        $script:DefenderWarningMsg.Text   = $unavailable.Msg
        $script:DefenderWarningBanner.Visibility = [System.Windows.Visibility]::Visible
        $script:BtnDefenderBrowse.IsEnabled = $false
        $script:DefenderEmpty.Visibility = [System.Windows.Visibility]::Visible
        Set-Status $unavailable.Title '#F97316'
        return
    }

    try {
        $prefs = Get-MpPreference -ErrorAction Stop
        if ($null -ne $prefs) {
            if ($prefs.ExclusionPath -and $prefs.ExclusionPath.Count -gt 0) {
                foreach ($p in $prefs.ExclusionPath) {
                    if (-not $p -or $p.Trim() -eq '') { continue }
                    $clean = $p.TrimEnd('\')
                    $rules += [pscustomobject]@{ Path = $clean; Name = [System.IO.Path]::GetFileName($clean); Type = 'Path' }
                }
            }
            if ($prefs.ExclusionProcess -and $prefs.ExclusionProcess.Count -gt 0) {
                foreach ($p in $prefs.ExclusionProcess) {
                    if (-not $p -or $p.Trim() -eq '') { continue }
                    $rules += [pscustomobject]@{ Path = $p; Name = [System.IO.Path]::GetFileName($p); Type = 'Process' }
                }
            }
            if ($prefs.ExclusionExtension -and $prefs.ExclusionExtension.Count -gt 0) {
                foreach ($p in $prefs.ExclusionExtension) {
                    if (-not $p -or $p.Trim() -eq '') { continue }
                    $rules += [pscustomobject]@{ Path = $p; Name = "*.$p"; Type = 'Extension' }
                }
            }
        }
    } catch {}

    if ($rules.Count -eq 0) {
        try {
            $regBase = 'HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions'
            $pathsKey = Join-Path $regBase 'Paths'
            $procsKey = Join-Path $regBase 'Processes'
            if (Test-Path $pathsKey) {
                $pp = Get-ItemProperty -Path $pathsKey -ErrorAction SilentlyContinue
                if ($pp) {
                    $pp.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                        $clean = $_.Name.TrimEnd('\')
                        $rules += [pscustomobject]@{ Path = $clean; Name = [System.IO.Path]::GetFileName($clean); Type = 'Path' }
                    }
                }
            }
            if (Test-Path $procsKey) {
                $pp = Get-ItemProperty -Path $procsKey -ErrorAction SilentlyContinue
                if ($pp) {
                    $pp.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                        $rules += [pscustomobject]@{ Path = $_.Name; Name = [System.IO.Path]::GetFileName($_.Name); Type = 'Process' }
                    }
                }
            }
        } catch {}
    }

    if ($rules.Count -eq 0) {
        $script:DefenderEmpty.Visibility = [System.Windows.Visibility]::Visible
        Set-Status 'No Defender exclusions found' '#1E1E1E'; return
    }
    $script:DefenderEmpty.Visibility = [System.Windows.Visibility]::Collapsed
    foreach ($rule in $rules) {
        $display = if ($rule.Type -ne 'Path') { "$($rule.Name)  [$($rule.Type)]" } else { $rule.Name }
        $row = New-SimpleRow 'DefenderList' 'SelectedDefender' 'BtnDefenderDelete' $display $rule.Path $rule.Path
        [void]$script:DefenderList.Children.Add($row)
    }
    Set-Status "$($rules.Count) exclusion$(if($rules.Count -ne 1){'s'}) active" '#22C55E'
}

function Add-DefenderRule { param([string]$exePath)
    $exeName = [System.IO.Path]::GetFileName($exePath)
    $folder  = [System.IO.Path]::GetDirectoryName($exePath)

    # Re-check availability before attempting
    $unavailable = Get-DefenderUnavailableReason
    if ($unavailable) {
        Set-Status $unavailable.Title '#F97316'
        return
    }

    try {
        Add-MpPreference -ExclusionPath $folder -ErrorAction Stop
        Load-DefenderRules
        Show-SuccessPopup -exeName $exeName -line1 "Exclusion  $([System.IO.Path]::GetFileName($folder))"
        Set-Status "Exclusion added: $exeName" '#22C55E'
    } catch {
        $msg = $_.Exception.Message
        if ($msg -like '*0x800106ba*' -or $msg -like '*service*') {
            Set-Status 'Defender service not running — cannot add exclusion' '#F97316'
        } else {
            Set-Status "Error: $msg" '#EF4444'
        }
    }
}

$script:BtnDefenderBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Set-Status "Adding exclusion..." '#888888'; Add-DefenderRule -exePath $dlg.FileName
    }
})
$script:BtnDefenderDelete.Add_Click({
    if ($script:SelectedDefender.Count -eq 0) { return }
    $ok = 0; $fail = 0
    foreach ($path in @($script:SelectedDefender)) {
        try {
            Remove-MpPreference -ExclusionPath      $path -ErrorAction SilentlyContinue
            Remove-MpPreference -ExclusionProcess   $path -ErrorAction SilentlyContinue
            Remove-MpPreference -ExclusionExtension $path -ErrorAction SilentlyContinue
            $ok++
        } catch { $fail++ }
    }
    Set-Status (if ($fail -eq 0) { "$ok exclusion$(if($ok -ne 1){'s'}) deleted" } else { "$ok deleted, $fail failed" }) `
               (if ($fail -eq 0) { '#22C55E' } else { '#F59E0B' })
    Load-DefenderRules
})

# ─────────────────────────────────────────────────────────────
#  Fullscreen / FSO toggle only
# ─────────────────────────────────────────────────────────────
function Refresh-FullscreenButtons {
    $fsoVal = $null
    try { $fsoVal = (Get-ItemProperty -Path $script:FullscreenKey -Name 'GameDVR_FSEBehaviorMode' -ErrorAction SilentlyContinue).GameDVR_FSEBehaviorMode } catch {}
    $script:BtnFsoToggle.Content = if ($fsoVal -eq 2) { 'v Applied' } else { 'Apply' }
}

function Load-FsoRules {
    $script:FsoList.Children.Clear()
    $script:SelectedFso.Clear()
    $script:BtnFsoDelete.IsEnabled = $false
    $rules = @()
    try {
        Get-ChildItem -Path 'HKCU:\System\GameConfigStore\Children' -ErrorAction SilentlyContinue | ForEach-Object {
            $p = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
            if ($p -and $p.MatchedExeFullPath) {
                $rules += [pscustomobject]@{
                    SubKey = $_.PSChildName
                    Path   = $p.MatchedExeFullPath
                    Name   = [System.IO.Path]::GetFileName($p.MatchedExeFullPath)
                }
            }
        }
    } catch {}
    if ($rules.Count -eq 0) {
        $script:FsoEmpty.Visibility = [System.Windows.Visibility]::Visible; return
    }
    $script:FsoEmpty.Visibility = [System.Windows.Visibility]::Collapsed
    foreach ($rule in $rules) {
        $row = New-SimpleRow 'FsoList' 'SelectedFso' 'BtnFsoDelete' $rule.Name $rule.SubKey $rule.Path
        [void]$script:FsoList.Children.Add($row)
    }
}

$script:BtnFsoToggle.Add_Click({
    try {
        if (-not (Test-Path $script:FullscreenKey)) { New-Item -Path $script:FullscreenKey -Force | Out-Null }
        Set-ItemProperty -Path $script:FullscreenKey -Name 'GameDVR_FSEBehaviorMode'              -Value 2 -Type DWord -Force
        Set-ItemProperty -Path $script:FullscreenKey -Name 'GameDVR_HonorUserFSEBehaviorMode'     -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $script:FullscreenKey -Name 'GameDVR_DXGIHonorFSEWindowsCompatible' -Value 1 -Type DWord -Force
        Refresh-FullscreenButtons
        Show-SuccessPopup -exeName 'System-wide' -line1 'Fullscreen Optimizations  Disabled'
        Set-Status 'FSO disabled system-wide' '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
})

$script:BtnFsoBrowse.Add_Click({
    $dlg = [System.Windows.Forms.OpenFileDialog]::new()
    $dlg.Filter = 'Executables (*.exe)|*.exe'; $dlg.Title = 'Select executable'
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }
    $exePath = $dlg.FileName
    $exeName = [System.IO.Path]::GetFileName($exePath)
    try {
        $childBase = 'HKCU:\System\GameConfigStore\Children'
        if (-not (Test-Path $childBase)) { New-Item -Path $childBase -Force | Out-Null }
        $newId  = '{' + [System.Guid]::NewGuid().ToString().ToUpper() + '}'
        $newKey = Join-Path $childBase $newId
        New-Item -Path $newKey -Force | Out-Null
        Set-ItemProperty -Path $newKey -Name 'MatchedExeFullPath' -Value $exePath -Type String -Force
        Set-ItemProperty -Path $newKey -Name 'HwSchMode'          -Value 0        -Type DWord  -Force
        Load-FsoRules
        Show-SuccessPopup -exeName $exeName -line1 'Per-app FSO  Disabled'
        Set-Status "Per-app FSO disabled: $exeName" '#22C55E'
    } catch { Set-Status "Error: $($_.Exception.Message)" '#EF4444' }
})

$script:BtnFsoDelete.Add_Click({
    if ($script:SelectedFso.Count -eq 0) { return }
    $ok = 0; $fail = 0
    foreach ($subKey in @($script:SelectedFso)) {
        try {
            $path = "HKCU:\System\GameConfigStore\Children\$subKey"
            if (Test-Path $path) { Remove-Item -Path $path -Recurse -Force -ErrorAction Stop }
            $ok++
        } catch { $fail++ }
    }
    Set-Status (if ($fail -eq 0) { "$ok rule$(if($ok -ne 1){'s'}) deleted" } else { "$ok deleted, $fail failed" }) `
               (if ($fail -eq 0) { '#22C55E' } else { '#F59E0B' })
    Load-FsoRules
})

# ─────────────────────────────────────────────────────────────
#  Window events
# ─────────────────────────────────────────────────────────────
$script:Win.Add_MouseLeftButtonDown({
    param($s,$e)
    $src = $e.OriginalSource
    if (-not (($src -is [System.Windows.Controls.Primitives.ButtonBase]) -or
              ($src -is [System.Windows.Controls.Primitives.Thumb]))) {
        $script:Win.DragMove()
    }
})

$script:BtnClose.Add_Click({ $script:Win.Close() })
$script:BtnMinimize.Add_Click({ $script:Win.WindowState = [System.Windows.WindowState]::Minimized })

$script:GithubBtn.Add_MouseLeftButtonDown({ Start-Process 'https://github.com/insovs' })
$script:GithubBtn.Add_MouseEnter({ $script:GithubBtn.Background = New-Brush '#1A1A1A' })
$script:GithubBtn.Add_MouseLeave({ $script:GithubBtn.Background = New-Brush '#141414' })



# ─────────────────────────────────────────────────────────────
#  Resize
# ─────────────────────────────────────────────────────────────
function Resize-Win {
    param([double]$dw, [double]$dh, [bool]$fromLeft, [bool]$fromTop)
    $minW = $script:Win.MinWidth; $minH = $script:Win.MinHeight
    if ($fromLeft) {
        $newW = $script:Win.Width - $dw
        if ($newW -lt $minW) { $dw = $script:Win.Width - $minW; $newW = $minW }
        $script:Win.Left += $dw; $script:Win.Width = $newW
    } elseif ($dw -ne 0) { $script:Win.Width = [Math]::Max($minW, $script:Win.Width + $dw) }
    if ($fromTop) {
        $newH = $script:Win.Height - $dh
        if ($newH -lt $minH) { $dh = $script:Win.Height - $minH; $newH = $minH }
        $script:Win.Top += $dh; $script:Win.Height = $newH
    } elseif ($dh -ne 0) { $script:Win.Height = [Math]::Max($minH, $script:Win.Height + $dh) }
}
$script:ThumbR.Add_DragDelta({  param($s,$e); Resize-Win  $e.HorizontalChange 0                 $false $false })
$script:ThumbL.Add_DragDelta({  param($s,$e); Resize-Win  $e.HorizontalChange 0                 $true  $false })
$script:ThumbB.Add_DragDelta({  param($s,$e); Resize-Win  0 $e.VerticalChange                   $false $false })
$script:ThumbBR.Add_DragDelta({ param($s,$e); Resize-Win  $e.HorizontalChange $e.VerticalChange $false $false })

# ─────────────────────────────────────────────────────────────
#  Navigation
# ─────────────────────────────────────────────────────────────
$script:NavCpu.Add_Click(        { Switch-Page 'PageCpu'        'NavCpu';        Load-CpuRules })
$script:NavQos.Add_Click(        { Switch-Page 'PageQos'        'NavQos';        Load-QosRules })
$script:NavGpu.Add_Click(        { Switch-Page 'PageGpu'        'NavGpu';        Load-GpuRules })
$script:NavAdmin.Add_Click(      { Switch-Page 'PageAdmin'      'NavAdmin';      Load-AdminRules })
$script:NavFirewall.Add_Click(   { Switch-Page 'PageFirewall'   'NavFirewall' })
$script:NavDefender.Add_Click(   { Switch-Page 'PageDefender'   'NavDefender';   Load-DefenderRules })
$script:NavFullscreen.Add_Click( { Switch-Page 'PageFullscreen' 'NavFullscreen'; Load-FsoRules; Refresh-FullscreenButtons })

# ─────────────────────────────────────────────────────────────
#  Init
# ─────────────────────────────────────────────────────────────
Switch-Page $script:StartPage $script:StartNav
if ($script:StartLoad -ne '') { & $script:StartLoad }
$script:Win.ShowDialog() | Out-Null
# https://github.com/insovs
