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
  Olf.FMX.SelectDirectory;

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
    btnStart: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStartClick(Sender: TObject);
    procedure lblDownloadWindowsSDKClick(Sender: TObject);
    procedure lblBuyACodeSigningCertificateClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure btnSignedFolderPathFindClick(Sender: TObject);
    procedure EllipsesEditButton2Click(Sender: TObject);
    procedure EllipsesEditButton3Click(Sender: TObject);
    procedure ShowCertificateManagerClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
  private
    { Déclarations privées }
    FOldRecursivityValue: Boolean;
    FDefaultSignToolPath: string;
    function HasChanged: Boolean;
    procedure UpdateParams;
    procedure UpdateChanges;
    procedure CancelChanges;
    procedure BeginBlockingActivity;
    procedure EndBlockingActivity;
    procedure SignAFolder(SignedFolderPath: string; cmd: string;
      cmdparam: string; WithSubFolders: Boolean);
    procedure InitializeProjectSettingsStorrage;
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
  Olf.RTL.GenRandomID;

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

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  SigntoolPath, Signtooloptions, PFXFilePath, PFXPassword, TimeStampServerURL,
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
      Signtooloptions := edtSignToolOtherOptions.TextPrompt
    else
      Signtooloptions := edtSignToolOtherOptions.Text.trim;
    cmdparam := 'sign ' + Signtooloptions;

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

procedure TfrmMain.CancelChanges;
begin
  edtSigntoolPath.Text := edtSigntoolPath.tagstring;
  edtSignToolOtherOptions.Text := edtSignToolOtherOptions.tagstring;
  edtPFXFilePath.Text := edtPFXFilePath.tagstring;
  edtCertificateName.Text := edtCertificateName.tagstring;
  edtTimeStampServerURL.Text := edtTimeStampServerURL.tagstring;
  edtProgramTitle.Text := edtProgramTitle.tagstring;
  edtProgramURL.Text := edtProgramURL.tagstring;
  edtSignedFolderPath.Text := edtSignedFolderPath.tagstring;
  cbRecursivity.IsChecked := FOldRecursivityValue;
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

procedure TfrmMain.SignAFolder(SignedFolderPath: string; cmd: string;
cmdparam: string; WithSubFolders: Boolean);
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
  InitializeProjectSettingsStorrage;

  TabControl1.ActiveTab := tiProject;

  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;

{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ELSEIF Defined(PRIVATERELEASE)}
  caption := '[DEBUG] ' + caption + ' - PERSONAL RELEASE - DON''T DISTRIBUTE';
{$ENDIF}
  EndBlockingActivity;
  edtSigntoolPath.Text := tparams.getValue('SignToolPath', '');
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
  edtSignToolOtherOptions.Text := tparams.getValue('SignToolOptions', '');
{$IFDEF DEBUG}
  edtSignToolOtherOptions.TextPrompt := '/v /debug /td SHA256 /fd SHA256';
{$ELSE}
  edtSignToolOtherOptions.TextPrompt := '/td SHA256 /fd SHA256';
{$ENDIF}
  edtPFXFilePath.Text := tparams.getValue('PFXFilePath', '');
  edtCertificateName.Text := tparams.getValue('CertNameOrId', '');
  edtPFXPassword.Text := '';
  edtTimeStampServerURL.Text := tparams.getValue('TimeStampServerURL', '');
  edtTimeStampServerURL.TextPrompt :=
    'http://time.certum.pl, http://timestamp.digicert.com, http://timestamp.sectigo.com, ...';
  edtProgramTitle.Text := tparams.getValue('ProgramTitle', '');
  edtProgramURL.Text := tparams.getValue('ProgramURL', '');
  edtSignedFolderPath.Text := tparams.getValue('SignedFolderPath', '');
  cbRecursivity.IsChecked := tparams.getValue
    ('SignedFolderWithSubFolders', false);
  UpdateChanges;
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
    (FOldRecursivityValue <> cbRecursivity.IsChecked);
end;

procedure TfrmMain.InitializeProjectSettingsStorrage;
var
  MigrationID: string;
begin
  MigrationID := '';
  tparams.InitDefaultFileNameV2('OlfSoftware', 'ExeBulkSigning', false);
{$IF Defined(RELEASE)}
  if tfile.Exists(tparams.getFilePath) then
  begin
    tparams.load;
    MigrationID := TOlfRandomIDGenerator.getIDBase62(50);
    tparams.setValue(MigrationID, '');
    tparams.Remove(MigrationID);
    tparams.Delete;
  end;
  tparams.onCryptProc := function(Const AParams: string): TStream
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
  tparams.onDecryptProc := function(Const AStream: TStream): string
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
    tparams.save
  else
    tparams.load;
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

procedure TfrmMain.UpdateChanges;
begin
  edtSigntoolPath.tagstring := edtSigntoolPath.Text;
  edtSignToolOtherOptions.tagstring := edtSignToolOtherOptions.Text;
  edtPFXFilePath.tagstring := edtPFXFilePath.Text;
  edtCertificateName.tagstring := edtCertificateName.Text;
  edtTimeStampServerURL.tagstring := edtTimeStampServerURL.Text;
  edtProgramTitle.tagstring := edtProgramTitle.Text;
  edtProgramURL.tagstring := edtProgramURL.Text;
  edtSignedFolderPath.tagstring := edtSignedFolderPath.Text;
  FOldRecursivityValue := cbRecursivity.IsChecked;
end;

procedure TfrmMain.UpdateParams;
begin
  tparams.setValue('SignToolPath', edtSigntoolPath.Text);
  tparams.setValue('SignToolOptions', edtSignToolOtherOptions.Text);
  tparams.setValue('PFXFilePath', edtPFXFilePath.Text);
  tparams.setValue('CertNameOrId', edtCertificateName.Text);
  tparams.setValue('TimeStampServerURL', edtTimeStampServerURL.Text);
  tparams.setValue('ProgramTitle', edtProgramTitle.Text);
  tparams.setValue('ProgramURL', edtProgramURL.Text);
  tparams.setValue('SignedFolderPath', edtSignedFolderPath.Text);
  tparams.setValue('SignedFolderWithSubFolders', cbRecursivity.IsChecked);
  tparams.save;
  UpdateChanges;
end;

initialization

randomize;
TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;

{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
