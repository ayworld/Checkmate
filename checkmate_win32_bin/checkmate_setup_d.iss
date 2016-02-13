#define Publisher "Kaleb Klein"
#define AppURL "http://www.kalebklein.com/applications/checkmate"
#define VCLStylesSkinPath "{localappdata}\VCLStylesSkin"

[Setup]
AppId={{59F5B31A-8CCF-4541-AB31-F200C18AC3FC}
AppName={#AppName}
AppVersion={#Version}
AppVerName={#AppName} {#Version}
AppPublisher={#Publisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
LicenseFile=bin\license.txt
OutputBaseFilename={#SetupName}_setup
SetupIconFile=bin\gear.ico
WizardSmallImageFile=bin\gear.bmp
WizardImageFile=bin\gear_big.bmp
Compression=lzma
SolidCompression=yes
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#AppName}.exe

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full"; Description: "Default Installation"
Name: "source"; Description: "Include source code for {#AppName}"; Flags: iscustom

[Components]
Name: "app"; Description: "Default installation"; Types: full source; Flags: fixed
Name: "src"; Description: "Include Source Code"; Types: source

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Code]
// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall setuponly';
procedure LoadVCLStyle_UnInstall(VClStyleFile: String); external 'LoadVCLStyleW@{#VCLStylesSkinPath}\VclStylesInno.dll stdcall uninstallonly';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall setuponly';
procedure UnLoadVCLStyles_UnInstall; external 'UnLoadVCLStyles@{#VCLStylesSkinPath}\VclStylesInno.dll stdcall uninstallonly';

function InitializeSetup(): Boolean;
begin
 ExtractTemporaryFile('Glow.vsf');
 LoadVCLStyle(ExpandConstant('{tmp}\Glow.vsf'));
 Result := True;
end;

procedure DeinitializeSetup();
begin
    UnLoadVCLStyles;
end;

function InitializeUninstall: Boolean;
begin
  Result := True;
  LoadVCLStyle_UnInstall(ExpandConstant('{#VCLStylesSkinPath}\Glow.vsf'));
end;

procedure DeinitializeUninstall();
begin
  UnLoadVCLStyles_UnInstall;
end;

[Files]
;;;;;;;;;;;;; Checkmate Source ;;;;;;;;;;;;;;

Source: "..\src\*.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\*.h"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\*.ui"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\qt_resource.qrc"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\Checkmate.pro"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\res\*"; DestDir: "{app}\src\Checkmate\res"; Flags: ignoreversion recursesubdirs; Components: src

; Styles
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\VclStylesinno.dll"; DestDir: {#VCLStylesSkinPath}
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Styles\Glow.vsf"; DestDir: {#VCLStylesSkinPath}

; Rest of stuff
Source: "bin\source.md"; DestDir: "{app}"; Flags: ignoreversion; Components: src
Source: "bin\libgcc_s_dw2-1.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\libstdc++-6.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\libwinpthread-1.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\gear.ico"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\icudt53.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\icuin53.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\icuuc53.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\license.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\{#AppName}.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Cored.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Guid.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Widgetsd.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Networkd.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\platforms\qwindows.dll"; DestDir: "{app}\platforms"; Flags: ignoreversion recursesubdirs; Components: app

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppName}.exe"
Name: "{group}\{cm:ProgramOnTheWeb,{#AppName}}"; Filename: "{#AppURL}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppName}.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#AppName}"; Filename: "{app}\{#AppName}.exe"; Tasks: quicklaunchicon

[Run]
;; Change folder permissions so Checkmate can remove update files
Filename: "{sys}\icacls.exe"; Description: "Folder Permissions"; StatusMsg: "Changing Directory Permissions"; Parameters: """{app}"" /grant Users:F"; Flags: shellexec waituntilterminated 
Filename: "{app}\{#AppName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent unchecked
