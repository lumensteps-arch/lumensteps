; ============================================================================
;  Lumen Steps - Windows installer script (Inno Setup)
;
;  HOW TO USE (one-time, on your Windows machine):
;    1. Install Inno Setup (free): https://jrsoftware.org/isdl.php
;    2. Edit the "SourceBuildFolder" line below to point at your Unity build
;       folder - the one containing "Lumen Steps.exe" and "Lumen Steps_Data"
;       (e.g. your builds\ folder or "Official Release Build Beta 0.01" folder).
;    3. Open this file in Inno Setup Compiler and click Build > Compile
;       (or run: iscc LumenSteps.iss from a command prompt).
;    4. The output installer lands in an "Output" folder next to this script,
;       named exactly LumenSteps-Setup-1.0.0.exe - that's the file you upload
;       as a GitHub Release asset (see the setup instructions you were given
;       alongside this file).
;
;  Bump #define MyAppVersion (and the OutputBaseFilename) for every future
;  release, and re-compile - each version should get its own filename/URL
;  per Microsoft's guidance, never overwrite a previous version's file.
; ============================================================================

#define MyAppName "Lumen Steps"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Lumen Steps LLC"
#define MyAppURL "https://getlumensteps.com"
#define MyAppExeName "Lumen Steps.exe"

; >>> EDIT THIS to the full path of your Unity build folder on this machine <<<
#define SourceBuildFolder "C:\Users\Dylan\Documents\ABAv5\abapp v4\builds"

[Setup]
AppId={{6E2C7E6E-6E7A-4C7A-9C9B-4C7A6E2C7E6E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=Output
OutputBaseFilename=LumenSteps-Setup-{#MyAppVersion}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; This is a plain unsigned build. If you later buy a code-signing certificate,
; sign the compiled installer afterward with signtool - Windows SmartScreen
; will otherwise warn users on first run, which is normal for a new publisher.
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; Pulls in the exe, the *_Data folder, UnityPlayer.dll, MonoBleedingEdge,
; D3D12, and the crash handler - everything the build folder produces except
; the debug-symbols folder, which isn't needed to run the app.
Source: "{#SourceBuildFolder}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*_BurstDebugInformation_DoNotShip\*,*.pdb"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
