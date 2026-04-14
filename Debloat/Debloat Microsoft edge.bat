@echo off
echo.
echo Application des tweaks Edge via registre
echo.

:: ----------- HKCU\MicrosoftEdge\TabPreloader -----------
set "KEY1=HKCU\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader"
for %%X in (
AllowTabPreloading=0
) do (
    for /f "tokens=1,2 delims==" %%A in ("%%X") do reg add "%KEY1%" /v %%A /t REG_DWORD /d %%B /f
)

:: ----------- HKLM\MicrosoftEdge\TabPreloader -----------
set "KEY2=HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader"
for %%X in (
AllowTabPreloading=0
) do (
    for /f "tokens=1,2 delims==" %%A in ("%%X") do reg add "%KEY2%" /v %%A /t REG_DWORD /d %%B /f
)

:: ----------- HKLM\EdgeUpdate : valeurs simples -----------
set "KEY3=HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate"
for %%X in (
AutoStartOnLogon=0
CreateDesktopShortcutDefault=0
RemoveDesktopShortcutDefault=1
DoNotCreateEdgeDesktopShortcut=1
UpdateDefault=0
AutoUpdateCheckPeriodMinutes=0
UpdatesSuppressedDurationMin=1440
UpdatesSuppressedStartHour=0
UpdatesSuppressedStartMin=0
InstallDefault=0
) do (
    for /f "tokens=1,2 delims==" %%A in ("%%X") do reg add "%KEY3%" /v %%A /t REG_DWORD /d %%B /f
)

:: ----------- HKLM\EdgeUpdate : GUIDs Update + Install -----------
for %%G in (
56EB18F8-B008-4CBD-B6D2-8C97FE7E9062
2CD8A007-E189-409D-A2C8-9AF4EF3C72AA
65C35B14-6C1D-4122-AC46-7148CC9D6497
0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10
F3C4FE00-EFD5-403B-9569-398A20F1BA4A
F3017226-FE2A-4295-8BDF-00C3A9A7E4C5
) do (
    reg add "%KEY3%" /v Update{%%G} /t REG_DWORD /d 0 /f
    reg add "%KEY3%" /v Install{%%G} /t REG_DWORD /d 0 /f
)

:: ----------- HKLM\Edge : toutes les valeurs -----------
set "KEY4=HKLM\SOFTWARE\Policies\Microsoft\Edge"
for %%X in (
AddressBarMicrosoftSearchInBingProviderEnabled=0
AlternateErrorPagesEnabled=0
AutofillAddressEnabled=0
AutofillCreditCardEnabled=0
AutoImportAtFirstRun=4
BackgroundModeEnabled=0
BrowserSignin=0
ConfigureDoNotTrack=1
DefaultBrowserSettingEnabled=0
EdgeCollectionsEnabled=0
EdgeShoppingAssistantEnabled=0
HideFirstRunExperience=1
HideRestoreDialogEnabled=1
HubsSidebarEnabled=0
MicrosoftEditorEnabled=0
NetworkPredictionOptions=0
NewTabPageAllowed=3
NewTabPageContentEnabled=0
NewTabPageQuickLinksEnabled=0
PasswordManagerEnabled=0
PaymentMethodQueryEnabled=0
PersonalizationReportingEnabled=0
PinBrowserEssentialsToolbarButtonEnabled=0
RecentSearchSuggestionsEnabled=0
ResolveNavigationErrorsUseWebService=0
RestoreOnStartup=0
SearchbarAllowed=0
SearchSuggestEnabled=0
ShowMicrosoftRewards=0
ShowDiscoverButtonInAddressBar=0
ShowDiscoverButtonInNewTabPage=0
ShowRecommendationsEnabled=0
SiteSafetyServiceEnabled=0
SmartScreenEnabled=0
SplitScreenEnabled=0
SpotlightExperiencesAndRecommendationsEnabled=0
StandaloneHubsSidebarEnabled=0
StartupBoostEnabled=0
SyncDisabled=1
TypoSquattingCheckEnabled=0
UserFeedbackAllowed=0
WebWidgetAllowed=0
LocalProvidersEnabled=0
MicrosoftEditorProofingEnabled=0
SiteSafetyServicesEnabled=0
TyposquattingCheckerEnabled=0
EdgeFollowEnabled=0
WebWidgetIsEnabledOnStartup=0
SearchbarIsEnabledOnStartup=0
RelatedMatchesCloudServiceEnabled=0
SignInCtaOnNtpEnabled=0
EdgeEnhanceImagesEnabled=0
NewTabPageAllowedBackgroundTypes=3
InAppSupportEnabled=0
ExperimentationAndConfigurationServiceControl=0
FamilySafetySettingsEnabled=0
DiagnosticData=0
MetricsReportingEnabled=0
SendSiteInfoToImproveServices=0
DiscoverPageContextEnabled=0
CopilotPageContext=0
CopilotCDPPageContext=0
BingAdsSuppression=0
PromotionalTabsEnabled=0
MicrosoftEdgeInsiderPromotionEnabled=0
ShowAcrobatSubscriptionButton=0
NewTabPageHideDefaultTopSites=1
TrackingPrevention=3
BlockThirdPartyCookies=1
SmartScreenDnsRequestsEnabled=0
QuickSearchShowMiniMenu=0
ImplicitSignInEnabled=0
PinBrowserEssentialsToolbarButton=0
) do (
    for /f "tokens=1,2 delims==" %%A in ("%%X") do reg add "%KEY4%" /v %%A /t REG_DWORD /d %%B /f
)

echo.
echo Tous les parametres ont ete appliques avec succes.
pause