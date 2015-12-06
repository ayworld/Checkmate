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
 ExtractTemporaryFile('Amakrits.vsf');
 LoadVCLStyle(ExpandConstant('{tmp}\Amakrits.vsf'));
 Result := True;
end;

procedure DeinitializeSetup();
begin
    UnLoadVCLStyles;
end;

function InitializeUninstall: Boolean;
begin
  Result := True;
  LoadVCLStyle_UnInstall(ExpandConstant('{#VCLStylesSkinPath}\Amakrits.vsf'));
end;

procedure DeinitializeUninstall();
begin
  UnLoadVCLStyles_UnInstall;
end;

[Files]
Source: "bin\{#AppName}.exe"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: app
Source: "bin\platforms\qwindows.dll"; DestDir: "{app}\platforms"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: app

; ================
; Source
; ================


;;;;;;;;;;;;; Checkmate Source ;;;;;;;;;;;;;;

; about dialog
Source: "..\src\aboutdialog.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: src
Source: "..\src\aboutdialog.h"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\aboutdialog.ui"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src

; checksum generator
Source: "..\src\checksumgenerator.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\checksumgenerator.h"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\checksumgenerator.ui"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src

; main window
Source: "..\src\mainwindow.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\mainwindow.h"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\mainwindow.ui"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src

; validation thread
Source: "..\src\validationthread.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\validationthread.h"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src

; Downloader
Source: "..\src\filedownloader.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\filedownloader.h"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src

; Extras
Source: "..\src\main.cpp"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\gear.png"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\gear.ico"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\qt_resource.qrc"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\icon.rc"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src
Source: "..\src\{#AppName}.pro"; DestDir: "{app}\src\Checkmate"; Flags: ignoreversion; Components: src

;;;;;;;;;;;;; Checkmate Updater Source ;;;;;;;;;;;;;;

; Update dialog
Source: "..\updater_src\updater.cpp"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src
Source: "..\updater_src\updater.h"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src

; File downloader
Source: "..\updater_src\filedownloader.cpp"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src
Source: "..\updater_src\filedownloader.h"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src

; Extras
Source: "..\updater_src\main.cpp"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src
Source: "..\updater_src\updater.qrc"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src
Source: "..\updater_src\updater.rc"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src
Source: "..\updater_src\{#AppName}Updater.pro"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src
Source: "..\updater_src\{#AppName}Updater.exe.manifest"; DestDir: "{app}\src\CheckmateUpdater"; Flags: ignoreversion; Components: src

; Styles
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\VclStylesinno.dll"; DestDir: {#VCLStylesSkinPath};
Source: "C:\Program Files (x86)\The Road To Delphi\VCL Styles Inno\Styles\Amakrits.vsf"; DestDir: {#VCLStylesSkinPath};

; Rest of stuff
;Source: "bin\source.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: src
Source: "bin\libgcc_s_dw2-1.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\libstdc++-6.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\libwinpthread-1.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\gear.ico"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\icudt53.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\icuin53.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\icuuc53.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\license.txt"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\{#AppName}.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Core.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Gui.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Widgets.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: "bin\Qt5Network.dll"; DestDir: "{app}"; Flags: ignoreversion; Components: app

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppName}.exe"
Name: "{group}\{cm:ProgramOnTheWeb,{#AppName}}"; Filename: "{#AppURL}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppName}.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#AppName}"; Filename: "{app}\{#AppName}.exe"; Tasks: quicklaunchicon

[Run]
;; Change folder permissions so Checkmate can remove update files
Filename: "{sys}\icacls.exe"; Description: "Folder Permissions"; StatusMsg: "Changing Directory Permissions"; Parameters: """{app}"" /grant Users:F"; Flags: shellexec waituntilterminated 
Filename: "{app}\{#AppName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

