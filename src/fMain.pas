unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Menus,
  Olf.FMX.AboutDialog,
  uDMProjectLogo,
  FMX.TabControl,
  Olf.FMX.SelectDirectory,
  ExeBulkSigningClientLib,
  ExeBulkSigningServerLib;

type
  TfrmMain = class(TForm)
    lblSignedFolderPath: TLabel;
    lblProgramURL: TLabel;
    edtTimeStampServerURL: TEdit;
    lblProgramTitle: TLabel;
    edtProgramURL: TEdit;
    edtProgramTitle: TEdit;
    lblTimeStampServerURL: TLabel;
    edtPFXPassword: TEdit;
    lblPFXFilePath: TLabel;
    edtSignedFolderPath: TEdit;
    lblPFXPassword: TLabel;
    edtPFXFilePath: TEdit;
    FindSigntoolDialog: TOpenDialog;
    FindPFXFileDialog: TOpenDialog;
    lblBuyACodeSigningCertificate: TLabel;
    LockScreenBackground: TRectangle;
    LockScreen: TLayout;
    LockScreenAnimation: TAniIndicator;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuQuit: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAbout: TMenuItem;
    OlfAboutDialog1: TOlfAboutDialog;
    cbRecursivity: TCheckBox;
    TabControl1: TTabControl;
    tiProject: TTabItem;
    tiCertificate: TTabItem;
    vsbProject: TVertScrollBox;
    vsbCertificate: TVertScrollBox;
    btnSignedFolderPathFind: TEllipsesEditButton;
    btnPFXFilePathFind: TEllipsesEditButton;
    StyleBook1: TStyleBook;
    tiSignTool: TTabItem;
    vsbSignTool: TVertScrollBox;
    lblSignToolPath: TLabel;
    lblDownloadWindowsSDK: TLabel;
    edtSigntoolPath: TEdit;
    btnSigntoolPathFind: TEllipsesEditButton;
    lblCertificateName: TLabel;
    edtCertificateName: TEdit;
    ShowCertificateManager: TEllipsesEditButton;
    edtPFXPasswordShowBtn: TPasswordEditButton;
    ChooseFolderToSignIn: TOlfSelectDirectoryDialog;
    lblSignToolOtherOptions: TLabel;
    edtSignToolOtherOptions: TEdit;
    GridPanelLayout1: TGridPanelLayout;
    btnCertificateSave: TButton;
    btnCertificateCancel: TButton;
    GridPanelLayout2: TGridPanelLayout;
    btnMSSDKSave: TButton;
    btnMSSDKCancel: TButton;
    tiClientServer: TTabItem;
    vsbClientServer: TVertScrollBox;
    lblCSServerIP: TLabel;
    lblCSServerPort: TLabel;
    edtCSServerPort: TEdit;
    edtCSServerIP: TEdit;
    lblCSAuthorizationKey: TLabel;
    edtCSAuthorizationKey: TEdit;
    GridPanelLayout3: TGridPanelLayout;
    btnCSSave: TButton;
    btnCSCancel: TButton;
    PasswordEditButton1: TPasswordEditButton;
    GridPanelLayout4: TGridPanelLayout;
    btnSignLocally: TButton;
    btnSignRemotely: TButton;
    btnStartSigningServer: TButton;
    btnStopSigningServer: TButton;
    cbCSServerAutoStart: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lblDownloadWindowsSDKClick(Sender: TObject);
    procedure lblBuyACodeSigningCertificateClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure btnSignedFolderPathFindClick(Sender: TObject);
    procedure EllipsesEditButton2Click(Sender: TObject);
    procedure EllipsesEditButton3Click(Sender: TObject);
    procedure ShowCertificateManagerClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure btnCertificateCancelClick(Sender: TObject);
    procedure btnCertificateSaveClick(Sender: TObject);
    procedure btnMSSDKSaveClick(Sender: TObject);
    procedure btnMSSDKCancelClick(Sender: TObject);
    procedure btnCSSaveClick(Sender: TObject);
    procedure btnCSCancelClick(Sender: TObject);
    procedure btnSignLocallyClick(Sender: TObject);
    procedure btnStartSigningServerClick(Sender: TObject);
    procedure btnStopSigningServerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSignRemotelyClick(Sender: TObject);
  private
    { Déclarations privées }
    FOldRecursivityValue: Boolean;
    FOldStartServerAtLaunchValue: Boolean;
    FDefaultSignToolPath: string;
    FCSServer: TESBServer;
    FCSClient: TESBClient;
    function HasChanged: Boolean;
    procedure UpdateParams;
    procedure UpdateChanges(Const SaveParams: Boolean);
    procedure UpdateCertificateChanges(Const SaveParams: Boolean);
    procedure UpdateMicrosoftSDKChanges(Const SaveParams: Boolean);
    procedure UpdateClientServerChanges(Const SaveParams: Boolean);
    procedure CancelChanges;
    procedure CancelCertificateChanges;
    procedure CancelMicrosoftSDKChanges;
    procedure CancelClientServerChanges;
    procedure BeginBlockingActivity;
    procedure EndBlockingActivity;
    procedure SignAFolder(Const SignedFolderPath, cmd, cmdparam: string;
      Const WithSubFolders: Boolean);
    procedure RemoteSignAFolder(Const ProgramTitle, ProgramURL, SignedFolderPath
      : string; Const WithSubFolders: Boolean);
    procedure InitializeProjectSettingsStorrage;
    procedure InitAboutDialogDescriptionAndLicense;
    procedure DoSignFile(Const ATitle, AURL, AFileName: string);
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  Olf.RTL.Params,
  System.IOUtils,
  FMX.DialogService,
  u_urlOpen,
  Winapi.ShellAPI,
  Winapi.Windows,
  Olf.RTL.CryptDecrypt,
  Olf.RTL.GenRandomID,
  ExeBulkSigningClientServerAPI;

{$IFDEF PRIVATERELEASE}
{$INCLUDE '../_PRIVATE/PFXPasswordConst.inc.pas'}
(*
  Copy this lines in '../_PRIVATE/PFXPasswordConst.inc.pas' file with your real
  developer certificate if you want a personal release with the password
  hardcoded.

  Const
  CPFXCertificate = 'MyCertificat.pfx'; // name of your certificate file
  CPFXPassword = 'MyPassword'; // password of the pfx file
*)
{$ENDIF}

procedure TfrmMain.BeginBlockingActivity;
begin
  LockScreen.Visible := true;
  LockScreen.BringToFront;
  LockScreenBackground.Visible := true;
  LockScreenAnimation.Enabled := true;
  LockScreenAnimation.BringToFront;
end;

procedure TfrmMain.CancelCertificateChanges;
begin
  edtPFXFilePath.Text := edtPFXFilePath.tagstring;
  edtCertificateName.Text := edtCertificateName.tagstring;
  edtTimeStampServerURL.Text := edtTimeStampServerURL.tagstring;
end;

procedure TfrmMain.CancelChanges;
begin
  CancelClientServerChanges;
  CancelMicrosoftSDKChanges;
  CancelCertificateChanges;
  edtProgramTitle.Text := edtProgramTitle.tagstring;
  edtProgramURL.Text := edtProgramURL.tagstring;
  edtSignedFolderPath.Text := edtSignedFolderPath.tagstring;
  cbRecursivity.IsChecked := FOldRecursivityValue;
end;

procedure TfrmMain.CancelClientServerChanges;
begin
  edtCSServerPort.Text := edtCSServerPort.tagstring;
  edtCSServerIP.Text := edtCSServerIP.tagstring;
  edtCSAuthorizationKey.Text := edtCSAuthorizationKey.tagstring;
  cbCSServerAutoStart.IsChecked := FOldStartServerAtLaunchValue;
end;

procedure TfrmMain.CancelMicrosoftSDKChanges;
begin
  edtSigntoolPath.Text := edtSigntoolPath.tagstring;
  edtSignToolOtherOptions.Text := edtSignToolOtherOptions.tagstring;
end;

procedure TfrmMain.DoSignFile(const ATitle, AURL, AFileName: string);
var
  SigntoolPath, SigntoolOptions: string;
  PFXFilePath, CertificateName, PFXPassword, TimeStampServerURL: string;
  cmd, cmdparam: string;
  ShellExecuteResult: Cardinal;
{$IFDEF DEBUG}
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningServerLog.txt');
{$ENDIF}
  if not edtSigntoolPath.Text.IsEmpty then
    SigntoolPath := edtSigntoolPath.Text
  else if not FDefaultSignToolPath.IsEmpty then
    SigntoolPath := FDefaultSignToolPath
  else
    SigntoolPath := '';

  if SigntoolPath.IsEmpty or (not tfile.Exists(SigntoolPath)) or
    (not SigntoolPath.EndsWith('signtool.exe')) then
    raise exception.Create('Invalid signtool.exe path');

  if not edtPFXFilePath.Text.IsEmpty then
    if tfile.Exists(edtPFXFilePath.Text) and
      (edtPFXFilePath.Text.EndsWith('.pfx')) then
      PFXFilePath := edtPFXFilePath.Text
    else
      raise exception.Create('Invalid code signing certificate file path');

  if not edtCertificateName.Text.IsEmpty then
    CertificateName := edtCertificateName.Text;

  if not edtPFXPassword.Text.IsEmpty then
    PFXPassword := edtPFXPassword.Text
{$IFDEF PRIVATERELEASE}
  else if edtPFXFilePath.Text.EndsWith(CPFXCertificate) and
    (not CPFXPassword.IsEmpty) then
    PFXPassword := CPFXPassword
{$ENDIF}
  else if not PFXFilePath.IsEmpty then
  begin
    TabControl1.ActiveTab := tiCertificate;
    edtPFXPassword.SetFocus;
    raise exception.Create('Invalid PFX password');
  end;

  TimeStampServerURL := edtTimeStampServerURL.Text;

  cmd := '"' + SigntoolPath + '"';

  if edtSignToolOtherOptions.Text.trim.IsEmpty then
    SigntoolOptions := edtSignToolOtherOptions.TextPrompt
  else
    SigntoolOptions := edtSignToolOtherOptions.Text.trim;
  cmdparam := 'sign ' + SigntoolOptions;

  if (not PFXFilePath.IsEmpty) then
    cmdparam := cmdparam + ' /f "' + PFXFilePath + '"';
  if (not PFXPassword.IsEmpty) then
    cmdparam := cmdparam + ' /p ' + PFXPassword;
  if (not CertificateName.IsEmpty) then
    cmdparam := cmdparam + ' /n "' + CertificateName + '"';
  if (not TimeStampServerURL.IsEmpty) then
    cmdparam := cmdparam + ' /tr "' + TimeStampServerURL + '"';
  if (not ATitle.IsEmpty) then
    cmdparam := cmdparam + ' /d "' + ATitle + '"';
  if (not AURL.IsEmpty) then
    cmdparam := cmdparam + ' /du "' + AURL + '"';
{$IFDEF DEBUG}
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    'cmd : ' + cmd + slinebreak + 'cmdparam : ' + cmdparam, tencoding.UTF8);
{$ENDIF}
  cmdparam := cmdparam + ' "' + AFileName + '"';

  ShellExecuteResult := ShellExecute(0, 'OPEN', PWideChar(cmd),
    PWideChar(cmdparam), nil, SW_SHOWNORMAL);
  // Look at http://delphiprogrammingdiary.blogspot.com/2014/07/shellexecute-in-delphi.html for return values
  if (ShellExecuteResult <= 32) then
    raise exception.Create('ShellExecute error ' + ShellExecuteResult.ToString +
      ' for file ' + AFileName);
end;

procedure TfrmMain.btnCertificateCancelClick(Sender: TObject);
begin
  CancelCertificateChanges;
end;

procedure TfrmMain.btnCertificateSaveClick(Sender: TObject);
begin
  UpdateCertificateChanges(true);
  TParams.Save;
end;

procedure TfrmMain.btnCSCancelClick(Sender: TObject);
begin
  CancelClientServerChanges;
end;

procedure TfrmMain.btnCSSaveClick(Sender: TObject);
begin
  UpdateClientServerChanges(true);
  TParams.Save;
end;

procedure TfrmMain.btnMSSDKCancelClick(Sender: TObject);
begin
  CancelMicrosoftSDKChanges;
end;

procedure TfrmMain.btnMSSDKSaveClick(Sender: TObject);
begin
  UpdateMicrosoftSDKChanges(true);
  TParams.Save;
end;

procedure TfrmMain.btnSignedFolderPathFindClick(Sender: TObject);
begin
  if (edtSignedFolderPath.Text.IsEmpty) then
    ChooseFolderToSignIn.Directory := tpath.GetDocumentsPath
  else
    ChooseFolderToSignIn.Directory := edtSignedFolderPath.Text;

  if ChooseFolderToSignIn.Execute then
  begin
    if ChooseFolderToSignIn.Directory.IsEmpty then
      raise exception.Create
        ('Select a file in the directory you want to sign in !');
    if not tdirectory.Exists(ChooseFolderToSignIn.Directory) then
      raise exception.Create(ChooseFolderToSignIn.Directory +
        ' doesn''t exist !');
    if ChooseFolderToSignIn.Directory.StartsWith
      (GetEnvironmentVariable('PROGRAMFILES(X86)')) or
      ChooseFolderToSignIn.Directory.StartsWith
      (GetEnvironmentVariable('PROGRAMFILES')) or
      ChooseFolderToSignIn.Directory.StartsWith
      (GetEnvironmentVariable('SYSTEMROOT')) or
      ChooseFolderToSignIn.Directory.StartsWith(GetEnvironmentVariable('WINDIR'))
    then
      raise exception.Create('Folder ' + ChooseFolderToSignIn.Directory +
        ' not authorized !');
    edtSignedFolderPath.Text := ChooseFolderToSignIn.Directory;
  end;
end;

procedure TfrmMain.btnSignLocallyClick(Sender: TObject);
var
  SigntoolPath, SigntoolOptions, PFXFilePath, PFXPassword, TimeStampServerURL,
    ProgramTitle, ProgramURL, SignedFolderPath: string;
  cmd, cmdparam: string;
  CertificateName: string;
begin
  if not edtSigntoolPath.Text.IsEmpty then
    SigntoolPath := edtSigntoolPath.Text
  else if not FDefaultSignToolPath.IsEmpty then
    SigntoolPath := FDefaultSignToolPath
  else
    SigntoolPath := '';

  if SigntoolPath.IsEmpty or (not tfile.Exists(SigntoolPath)) or
    (not SigntoolPath.EndsWith('signtool.exe')) then
  begin
    TabControl1.ActiveTab := tiSignTool;
    edtSigntoolPath.SetFocus;
    raise exception.Create('Invalid signtool.exe path');
  end;
  if not edtPFXFilePath.Text.IsEmpty then
    if tfile.Exists(edtPFXFilePath.Text) and
      (edtPFXFilePath.Text.EndsWith('.pfx')) then
      PFXFilePath := edtPFXFilePath.Text
    else
    begin
      TabControl1.ActiveTab := tiCertificate;
      edtPFXFilePath.SetFocus;
      raise exception.Create('Invalid code signing certificate file path');
    end;
  if not edtCertificateName.Text.IsEmpty then
    CertificateName := edtCertificateName.Text;
  if not edtPFXPassword.Text.IsEmpty then
    PFXPassword := edtPFXPassword.Text
{$IFDEF PRIVATERELEASE}
  else if edtPFXFilePath.Text.EndsWith(CPFXCertificate) and
    (not CPFXPassword.IsEmpty) then
    PFXPassword := CPFXPassword
{$ENDIF}
  else if not PFXFilePath.IsEmpty then
  begin
    TabControl1.ActiveTab := tiCertificate;
    edtPFXPassword.SetFocus;
    raise exception.Create('Invalid PFX password');
  end;
  TimeStampServerURL := edtTimeStampServerURL.Text;
  ProgramTitle := edtProgramTitle.Text;
  ProgramURL := edtProgramURL.Text;
  if (not edtSignedFolderPath.Text.IsEmpty) and
    tdirectory.Exists(edtSignedFolderPath.Text)
{$IFDEF MSWINDOWS}
  // in Win32, ProgramFiles = ProgramFiles(x86)
  // in Win64, ProgramFiles <> ProgramFiles(x86)
    and (not edtSignedFolderPath.Text.StartsWith
    (GetEnvironmentVariable('PROGRAMFILES(X86)'))) and
    (not edtSignedFolderPath.Text.StartsWith(GetEnvironmentVariable
    ('PROGRAMFILES'))) and
    (not edtSignedFolderPath.Text.StartsWith(GetEnvironmentVariable
    ('SYSTEMROOT'))) and
    (not edtSignedFolderPath.Text.StartsWith(GetEnvironmentVariable('WINDIR')))
{$ENDIF}
  then
    SignedFolderPath := edtSignedFolderPath.Text
  else
  begin
    TabControl1.ActiveTab := tiProject;
    edtSignedFolderPath.SetFocus;
    raise exception.Create('Invalid folder path');
  end;

  BeginBlockingActivity;
  try
    cmd := '"' + SigntoolPath + '"';

    if edtSignToolOtherOptions.Text.trim.IsEmpty then
      SigntoolOptions := edtSignToolOtherOptions.TextPrompt
    else
      SigntoolOptions := edtSignToolOtherOptions.Text.trim;
    cmdparam := 'sign ' + SigntoolOptions;

    if (not PFXFilePath.IsEmpty) then
      cmdparam := cmdparam + ' /f "' + PFXFilePath + '"';
    if (not PFXPassword.IsEmpty) then
      cmdparam := cmdparam + ' /p ' + PFXPassword;
    if (not CertificateName.IsEmpty) then
      cmdparam := cmdparam + ' /n "' + CertificateName + '"';
    if (not TimeStampServerURL.IsEmpty) then
      cmdparam := cmdparam + ' /tr "' + TimeStampServerURL + '"';
    if (not ProgramTitle.IsEmpty) then
      cmdparam := cmdparam + ' /d "' + ProgramTitle + '"';
    if (not ProgramURL.IsEmpty) then
      cmdparam := cmdparam + ' /du "' + ProgramURL + '"';
{$IFDEF DEBUG}
    // showmessage(cmd);
    // showmessage(cmdParam);
{$ENDIF}
    tthread.CreateAnonymousThread(
      procedure
      var
        WithSubFolders: Boolean;
      begin
        try
          tthread.Synchronize(nil,
            procedure
            begin
              WithSubFolders := cbRecursivity.IsChecked;
            end);
          SignAFolder(SignedFolderPath, cmd, cmdparam, WithSubFolders);
        finally
          tthread.forcequeue(nil,
            procedure
            begin
              EndBlockingActivity;
            end);
        end;
      end).Start;
  except
    EndBlockingActivity;
  end;
end;

procedure TfrmMain.btnSignRemotelyClick(Sender: TObject);
var
  ProgramTitle, ProgramURL, SignedFolderPath, IP, AuthKey: string;
  Port: word;
  WithSubFolders: Boolean;
begin
  BeginBlockingActivity;
  try
    ProgramTitle := edtProgramTitle.Text;
    ProgramURL := edtProgramURL.Text;
    if (not edtSignedFolderPath.Text.IsEmpty) and
      tdirectory.Exists(edtSignedFolderPath.Text)
{$IFDEF MSWINDOWS}
    // in Win32, ProgramFiles = ProgramFiles(x86)
    // in Win64, ProgramFiles <> ProgramFiles(x86)
      and (not edtSignedFolderPath.Text.StartsWith
      (GetEnvironmentVariable('PROGRAMFILES(X86)'))) and
      (not edtSignedFolderPath.Text.StartsWith
      (GetEnvironmentVariable('PROGRAMFILES'))) and
      (not edtSignedFolderPath.Text.StartsWith
      (GetEnvironmentVariable('SYSTEMROOT'))) and
      (not edtSignedFolderPath.Text.StartsWith
      (GetEnvironmentVariable('WINDIR')))
{$ENDIF}
    then
      SignedFolderPath := edtSignedFolderPath.Text
    else
    begin
      TabControl1.ActiveTab := tiProject;
      edtSignedFolderPath.SetFocus;
      raise exception.Create('Invalid folder path');
    end;

    if assigned(FCSClient) then
      try
        freeandnil(FCSClient);
      except
        FCSClient := nil;
      end;

    // TODO : tester la validité de l'adresse IP (v4)
    IP := edtCSServerIP.Text;

    Port := edtCSServerPort.Text.ToInteger;

    AuthKey := edtCSAuthorizationKey.Text.trim;

    WithSubFolders := cbRecursivity.IsChecked;

    tthread.CreateAnonymousThread(
      procedure
      begin
        try
          FCSClient := TESBClient.Create(IP, Port, AuthKey);
          try
            RemoteSignAFolder(ProgramTitle, ProgramURL, SignedFolderPath,
              WithSubFolders);

            while FCSClient.HasWaitingFiles > 0 do
              sleep(1000);
          finally
            freeandnil(FCSClient);
          end;
        finally
          tthread.forcequeue(nil,
            procedure
            begin
              EndBlockingActivity;
            end);
        end;
      end).Start;
  except
    EndBlockingActivity;
  end;
end;

procedure TfrmMain.btnStartSigningServerClick(Sender: TObject);
var
  IP: string;
  Port: word;
begin
  // TODO : tester la validité de l'adresse IP (v4)
  IP := edtCSServerIP.Text;

  Port := edtCSServerPort.Text.ToInteger;

  btnStartSigningServer.Visible := false;
  btnStopSigningServer.Visible := not btnStartSigningServer.Visible;

  if assigned(FCSServer) then
    try
      freeandnil(FCSServer);
    except
      FCSServer := nil;
    end;

  FCSServer := TESBServer.Create(IP, Port, edtCSAuthorizationKey.Text);
  FCSServer.onSignFile := DoSignFile;
end;

procedure TfrmMain.btnStopSigningServerClick(Sender: TObject);
begin
  if assigned(FCSServer) then
    try
      freeandnil(FCSServer);
    except
      FCSServer := nil;
    end;

  btnStartSigningServer.Visible := true;
  btnStopSigningServer.Visible := not btnStartSigningServer.Visible;
end;

procedure TfrmMain.EllipsesEditButton2Click(Sender: TObject);
var
  FileName: string;
begin
  if (edtPFXFilePath.Text.IsEmpty) then
    FindPFXFileDialog.InitialDir := tpath.GetDocumentsPath
  else
    FindPFXFileDialog.InitialDir := tpath.GetDirectoryName(edtPFXFilePath.Text);
  FindPFXFileDialog.FileName := '';
  if FindPFXFileDialog.Execute then
  begin
    FileName := FindPFXFileDialog.FileName;
    if FileName.IsEmpty then
      raise exception.Create('Select your code signing certificate file !');
    if not tfile.Exists(FileName) then
      raise exception.Create(FileName + ' doesn''t exist !');
    if not tpath.GetExtension(FileName).ToLower.Equals('.pfx') then
      raise exception.Create('Please choose a PFX file !');
    edtPFXFilePath.Text := FileName;
  end;
end;

procedure TfrmMain.EllipsesEditButton3Click(Sender: TObject);
var
  FileName: string;
begin
  if (edtSigntoolPath.Text.IsEmpty) then
    FindSigntoolDialog.InitialDir := 'C:\Program Files (x86)\Windows Kits'
  else
    FindSigntoolDialog.InitialDir := tpath.GetDirectoryName
      (edtSigntoolPath.Text);
  FindSigntoolDialog.FileName := '';
  if FindSigntoolDialog.Execute then
  begin
    FileName := FindSigntoolDialog.FileName;
    if FileName.IsEmpty then
      raise exception.Create('Select SignTool.exe file !');
    if not tfile.Exists(FileName) then
      raise exception.Create(FileName + ' doesn''t exist !');
    if not tpath.GetFileName(FileName).ToLower.Equals('signtool.exe') then
      raise exception.Create('Please choose "signtool.exe" file !');
    edtSigntoolPath.Text := FileName;
  end;
end;

procedure TfrmMain.EndBlockingActivity;
begin
  LockScreenAnimation.Enabled := false;
  LockScreen.Visible := false;
end;

procedure TfrmMain.ShowCertificateManagerClick(Sender: TObject);
begin
  // Look at http://delphiprogrammingdiary.blogspot.com/2014/07/shellexecute-in-delphi.html for return values
  if (ShellExecute(0, 'OPEN', PWideChar('certmgr.msc'), nil, nil, SW_SHOWNORMAL)
    <= 32) then
    raise exception.Create('Can''t open Windows certificate Manager.');
end;

procedure TfrmMain.SignAFolder(Const SignedFolderPath, cmd, cmdparam: string;
Const WithSubFolders: Boolean);
var
  cmdParamWithFile: string;
  FileList: tstringdynarray;
  FileName: string;
  FolderList: tstringdynarray;
  NewPath: string;
begin
  if not tdirectory.Exists(SignedFolderPath) then
    exit;

  FileList := tdirectory.GetFiles(SignedFolderPath);
  for FileName in FileList do
    if (tpath.GetExtension(FileName).ToLower = '.exe') or
      (tpath.GetExtension(FileName).ToLower = '.msix') then
    begin
      cmdParamWithFile := cmdparam + ' "' + FileName + '"';
      tthread.Synchronize(nil,
        procedure
        begin
          var
          res := ShellExecute(0, 'OPEN', PWideChar(cmd),
            PWideChar(cmdParamWithFile), nil, SW_SHOWNORMAL);
          // Look at http://delphiprogrammingdiary.blogspot.com/2014/07/shellexecute-in-delphi.html for return values
          if (res <= 32) then
            raise exception.Create('ShellExecute error ' + res.ToString +
              ' for file ' + FileName);
        end);
    end;
  if WithSubFolders then
  begin
    FolderList := tdirectory.GetDirectories(SignedFolderPath);
    for NewPath in FolderList do
      SignAFolder(NewPath, cmd, cmdparam, WithSubFolders);
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if HasChanged then
  begin
    CanClose := false;
    TDialogService.MessageDialog('Save changes ?', tmsgdlgtype.mtConfirmation,
      [tmsgdlgbtn.mbYes, tmsgdlgbtn.mbno], tmsgdlgbtn.mbYes, 0,
      procedure(const AResult: TModalResult)
      begin
        case AResult of
          mrYes:
            UpdateParams;
          mrno:
            CancelChanges;
        end;
        close;
      end);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FOldRecursivityValue := false;
  FOldStartServerAtLaunchValue := false;
  FDefaultSignToolPath := '';
  FCSServer := nil;
  FCSClient := nil;

  InitializeProjectSettingsStorrage;

  TabControl1.ActiveTab := tiProject;

  InitAboutDialogDescriptionAndLicense;

  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;

{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ELSEIF Defined(PRIVATERELEASE)}
  caption := '[DEBUG] ' + caption + ' - PERSONAL RELEASE - DON''T DISTRIBUTE';
{$ENDIF}
  EndBlockingActivity;
  edtSigntoolPath.Text := TParams.getValue('SignToolPath', '');
  if tfile.Exists
    ('C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe')
  then
    FDefaultSignToolPath :=
      'C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe'
  else if tfile.Exists
    ('C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe')
  then
    FDefaultSignToolPath :=
      'C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe'
  else
    FDefaultSignToolPath := '';
  edtSigntoolPath.TextPrompt := FDefaultSignToolPath;
  edtSignToolOtherOptions.Text := TParams.getValue('SignToolOptions', '');
{$IFDEF DEBUG}
  edtSignToolOtherOptions.TextPrompt := '/v /debug /td SHA256 /fd SHA256';
{$ELSE}
  edtSignToolOtherOptions.TextPrompt := '/td SHA256 /fd SHA256';
{$ENDIF}
  edtPFXFilePath.Text := TParams.getValue('PFXFilePath', '');
  edtCertificateName.Text := TParams.getValue('CertNameOrId', '');
  edtPFXPassword.Text := '';
  edtTimeStampServerURL.Text := TParams.getValue('TimeStampServerURL', '');
  edtTimeStampServerURL.TextPrompt :=
    'http://time.certum.pl, http://timestamp.digicert.com, http://timestamp.sectigo.com, ...';
  edtProgramTitle.Text := TParams.getValue('ProgramTitle', '');
  edtProgramURL.Text := TParams.getValue('ProgramURL', '');
  edtSignedFolderPath.Text := TParams.getValue('SignedFolderPath', '');
  cbRecursivity.IsChecked := TParams.getValue
    ('SignedFolderWithSubFolders', false);
  edtCSServerPort.Text := TParams.getValue('CSSvrPort', '8080');
  edtCSServerIP.Text := TParams.getValue('CSSvrIP', '0.0.0.0');
  edtCSAuthorizationKey.Text := TParams.getValue('CSAuthKey', '');
  cbCSServerAutoStart.IsChecked := TParams.getValue('CSAutoStartServer', false);
  UpdateChanges(false);

  btnStartSigningServer.Visible := true;
  btnStopSigningServer.Visible := not btnStartSigningServer.Visible;
  tthread.forcequeue(nil,
    procedure
    begin
      if cbCSServerAutoStart.IsChecked then
        btnStartSigningServerClick(Sender);
    end);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(FCSClient) then
    FCSClient.free;

  if assigned(FCSServer) then
    FCSServer.free;
end;

function TfrmMain.HasChanged: Boolean;
begin
  result := (edtSigntoolPath.tagstring <> edtSigntoolPath.Text) or
    (edtSignToolOtherOptions.tagstring <> edtSignToolOtherOptions.Text) or
    (edtPFXFilePath.tagstring <> edtPFXFilePath.Text) or
    (edtCertificateName.tagstring <> edtCertificateName.Text) or
    (edtTimeStampServerURL.tagstring <> edtTimeStampServerURL.Text) or
    (edtProgramTitle.tagstring <> edtProgramTitle.Text) or
    (edtProgramURL.tagstring <> edtProgramURL.Text) or
    (edtSignedFolderPath.tagstring <> edtSignedFolderPath.Text) or
    (FOldRecursivityValue <> cbRecursivity.IsChecked) or
    (edtCSServerPort.tagstring <> edtCSServerPort.Text) or
    (edtCSServerIP.tagstring <> edtCSServerIP.Text) or
    (edtCSAuthorizationKey.tagstring <> edtCSAuthorizationKey.Text) or
    (FOldStartServerAtLaunchValue <> cbCSServerAutoStart.IsChecked);
end;

procedure TfrmMain.InitAboutDialogDescriptionAndLicense;
begin
  OlfAboutDialog1.Licence.Text :=
    'This program is distributed as shareware. If you use it (especially for ' +
    'commercial or income-generating purposes), please remember the author and '
    + 'contribute to its development by purchasing a license.' + slinebreak +
    slinebreak +
    'This software is supplied as is, with or without bugs. No warranty is offered '
    + 'as to its operation or the data processed. Make backups!';
  OlfAboutDialog1.Description.Text :=
    'Exe Bulk Signing call SignTool.exe from the Microsoft Windows SDK to sign all program files in a folder or a folder tree. It can act locally or in a client/server mode on a network or the internet (not recommanded) to share CSC token or keys between developers in the same company.'
    + slinebreak + slinebreak + '*****************' + slinebreak +
    '* Publisher info' + slinebreak + slinebreak +
    'This application was developed by Patrick Prémartin.' + slinebreak +
    slinebreak +
    'It is published by OLF SOFTWARE, a company registered in Paris (France) under the reference 439521725.'
    + slinebreak + slinebreak + '****************' + slinebreak +
    '* Personal data' + slinebreak + slinebreak +
    'This program is autonomous in its current version. It does not depend on the Internet and communicates nothing to the outside world.'
    + slinebreak + slinebreak + 'We have no knowledge of what you do with it.' +
    slinebreak + slinebreak +
    'No information about you is transmitted to us or to any third party.' +
    slinebreak + slinebreak +
    'We use no cookies, no tracking, no stats on your use of the application.' +
    slinebreak + slinebreak + '**********************' + slinebreak +
    '* User support' + slinebreak + slinebreak +
    'If you have any questions or require additional functionality, please leave us a message on the application''s website or on its code repository.'
    + slinebreak + slinebreak +
    'To find out more, visit https://exebulksigning.olfsoftware.fr';
end;

procedure TfrmMain.InitializeProjectSettingsStorrage;
var
  MigrationID: string;
begin
  MigrationID := '';
  TParams.InitDefaultFileNameV2('OlfSoftware', 'ExeBulkSigning', false);
{$IF Defined(RELEASE)}
  if tfile.Exists(TParams.getFilePath) then
  begin
    TParams.load;
    MigrationID := TOlfRandomIDGenerator.getIDBase62(50);
    TParams.setValue(MigrationID, '');
    TParams.Remove(MigrationID);
    TParams.Delete;
  end;
  TParams.onCryptProc := function(Const AParams: string): TStream
    var
      Keys: TByteDynArray;
      ParStream: TStringStream;
    begin
      ParStream := TStringStream.Create(AParams);
      try
{$I '..\_PRIVATE\src\paramsxorkey.inc'}
        result := TOlfCryptDecrypt.XORCrypt(ParStream, Keys);
      finally
        ParStream.free;
      end;
    end;
  TParams.onDecryptProc := function(Const AStream: TStream): string
    var
      Keys: TByteDynArray;
      Stream: TStream;
      StringStream: TStringStream;
    begin
{$I '..\_PRIVATE\src\paramsxorkey.inc'}
      result := '';
      Stream := TOlfCryptDecrypt.XORdeCrypt(AStream, Keys);
      try
        if assigned(Stream) and (Stream.Size > 0) then
        begin
          StringStream := TStringStream.Create;
          try
            Stream.Position := 0;
            StringStream.CopyFrom(Stream);
            result := StringStream.DataString;
          finally
            StringStream.free;
          end;
        end;
      finally
        Stream.free;
      end;
    end;
{$ENDIF}
  if not MigrationID.IsEmpty then
    TParams.Save
  else
    TParams.load;
end;

procedure TfrmMain.lblBuyACodeSigningCertificateClick(Sender: TObject);
begin
  url_Open_In_Browser('https://www.certum.eu/en/code-signing-certificates/');
end;

procedure TfrmMain.lblDownloadWindowsSDKClick(Sender: TObject);
begin
  url_Open_In_Browser
    ('https://developer.microsoft.com/windows/downloads/windows-sdk/');
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.mnuQuitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.RemoteSignAFolder(Const ProgramTitle, ProgramURL,
  SignedFolderPath: string; Const WithSubFolders: Boolean);
var
  FileList: tstringdynarray;
  FileName: string;
  FolderList: tstringdynarray;
  NewPath: string;
begin
  if not tdirectory.Exists(SignedFolderPath) then
    exit;

  FileList := tdirectory.GetFiles(SignedFolderPath);
  for FileName in FileList do
    if (tpath.GetExtension(FileName).ToLower = '.exe') or
      (tpath.GetExtension(FileName).ToLower = '.msix') then
      if assigned(FCSClient) and FCSClient.isConnected then
        FCSClient.SendFileToServer(ProgramTitle, ProgramURL, FileName);
  if WithSubFolders then
  begin
    FolderList := tdirectory.GetDirectories(SignedFolderPath);
    for NewPath in FolderList do
      RemoteSignAFolder(ProgramTitle, ProgramURL, NewPath, WithSubFolders);
  end;
end;

procedure TfrmMain.UpdateCertificateChanges(Const SaveParams: Boolean);
begin
  edtPFXFilePath.tagstring := edtPFXFilePath.Text;
  edtCertificateName.tagstring := edtCertificateName.Text;
  edtTimeStampServerURL.tagstring := edtTimeStampServerURL.Text;
  if SaveParams then
  begin
    TParams.setValue('PFXFilePath', edtPFXFilePath.Text);
    TParams.setValue('CertNameOrId', edtCertificateName.Text);
    TParams.setValue('TimeStampServerURL', edtTimeStampServerURL.Text);
  end;
end;

procedure TfrmMain.UpdateChanges(Const SaveParams: Boolean);
begin
  UpdateClientServerChanges(SaveParams);
  UpdateMicrosoftSDKChanges(SaveParams);
  UpdateCertificateChanges(SaveParams);
  edtProgramTitle.tagstring := edtProgramTitle.Text;
  edtProgramURL.tagstring := edtProgramURL.Text;
  edtSignedFolderPath.tagstring := edtSignedFolderPath.Text;
  FOldRecursivityValue := cbRecursivity.IsChecked;
  if SaveParams then
  begin
    TParams.setValue('ProgramTitle', edtProgramTitle.Text);
    TParams.setValue('ProgramURL', edtProgramURL.Text);
    TParams.setValue('SignedFolderPath', edtSignedFolderPath.Text);
    TParams.setValue('SignedFolderWithSubFolders', cbRecursivity.IsChecked);
  end;
end;

procedure TfrmMain.UpdateClientServerChanges(const SaveParams: Boolean);
begin
  edtCSServerPort.tagstring := edtCSServerPort.Text;
  edtCSServerIP.tagstring := edtCSServerIP.Text;
  edtCSAuthorizationKey.tagstring := edtCSAuthorizationKey.Text;
  FOldStartServerAtLaunchValue := cbCSServerAutoStart.IsChecked;
  if SaveParams then
  begin
    TParams.setValue('CSSvrPort', edtCSServerPort.Text);
    TParams.setValue('CSSvrIP', edtCSServerIP.Text);
    TParams.setValue('CSAuthKey', edtCSAuthorizationKey.Text);
    TParams.setValue('CSAutoStartServer', cbCSServerAutoStart.IsChecked);
  end;
end;

procedure TfrmMain.UpdateMicrosoftSDKChanges(const SaveParams: Boolean);
begin
  edtSigntoolPath.tagstring := edtSigntoolPath.Text;
  edtSignToolOtherOptions.tagstring := edtSignToolOtherOptions.Text;
  if SaveParams then
  begin
    TParams.setValue('SignToolPath', edtSigntoolPath.Text);
    TParams.setValue('SignToolOptions', edtSignToolOtherOptions.Text);
  end;
end;

procedure TfrmMain.UpdateParams;
begin
  UpdateChanges(true);
  TParams.Save;
end;

initialization

randomize;
TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;

{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
