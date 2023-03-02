unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Menus,
  Olf.FMX.AboutDialog;

type
  TfrmMain = class(TForm)
    VertScrollBox1: TVertScrollBox;
    lblSignedFolderPath: TLabel;
    edtSigntoolPath: TEdit;
    lblProgramURL: TLabel;
    edtTimeStampServerURL: TEdit;
    lblProgramTitle: TLabel;
    edtProgramURL: TEdit;
    lblSignToolPath: TLabel;
    edtProgramTitle: TEdit;
    lblTimeStampServerURL: TLabel;
    edtPFXPassword: TEdit;
    lblPFXFiePath: TLabel;
    edtSignedFolderPath: TEdit;
    lblPFXPassword: TLabel;
    edtPFXFilePath: TEdit;
    FindSigntoolDialog: TOpenDialog;
    FindPFXFileDialog: TOpenDialog;
    btnStart: TButton;
    bntCancel: TButton;
    GridPanelLayout1: TGridPanelLayout;
    btnSigntoolPathFind: TButton;
    btnPFXFilePathFind: TButton;
    btnSignedFolderPathFind: TButton;
    lblDownloadWindowsSDK: TLabel;
    lblBuyACodeSigningCertificate: TLabel;
    ChooseFolderToSignIn: TOpenDialog;
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
    lblRecursivity: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStartClick(Sender: TObject);
    procedure lblDownloadWindowsSDKClick(Sender: TObject);
    procedure lblBuyACodeSigningCertificateClick(Sender: TObject);
    procedure btnSigntoolPathFindClick(Sender: TObject);
    procedure btnPFXFilePathFindClick(Sender: TObject);
    procedure btnSignedFolderPathFindClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
  private
    { Déclarations privées }
    FOldRecursivityValue: Boolean;
    function HasChanged: Boolean;
    procedure UpdateParams;
    procedure UpdateChanges;
    procedure CancelChanges;
    procedure BeginBlockingActivity;
    procedure EndBlockingActivity;
    procedure SignAFolder(SignedFolderPath: string; cmd: string;
      cmdparam: string; WithSubFolders: Boolean);
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses Olf.RTL.Params, System.IOUtils, FMX.DialogService, u_urlOpen,
  Winapi.ShellAPI, Winapi.Windows;

procedure TfrmMain.BeginBlockingActivity;
begin
  LockScreen.Visible := true;
  LockScreen.BringToFront;
  LockScreenBackground.Visible := true;
  LockScreenAnimation.Enabled := true;
  LockScreenAnimation.BringToFront;
end;

procedure TfrmMain.btnPFXFilePathFindClick(Sender: TObject);
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

procedure TfrmMain.btnSignedFolderPathFindClick(Sender: TObject);
var
  FolderName: string;
begin
  if (edtSignedFolderPath.Text.IsEmpty) then
    ChooseFolderToSignIn.InitialDir := tpath.GetDocumentsPath
  else
    ChooseFolderToSignIn.InitialDir := edtSignedFolderPath.Text;
  ChooseFolderToSignIn.FileName := '';
  if ChooseFolderToSignIn.Execute then
  begin
    FolderName := tpath.GetDirectoryName(ChooseFolderToSignIn.FileName);
    if FolderName.IsEmpty then
      raise exception.Create
        ('Select a file in the directory you want to sign in !');
    if not tdirectory.Exists(FolderName) then
      raise exception.Create(FolderName + ' doesn''t exist !');
    if FolderName.StartsWith(GetEnvironmentVariable('PROGRAMFILES(X86)')) or
      FolderName.StartsWith(GetEnvironmentVariable('PROGRAMFILES')) or
      FolderName.StartsWith(GetEnvironmentVariable('SYSTEMROOT')) or
      FolderName.StartsWith(GetEnvironmentVariable('WINDIR')) then
      raise exception.Create('Folder ' + FolderName + ' not authorized !');
    edtSignedFolderPath.Text := FolderName;
  end;

end;

procedure TfrmMain.btnSigntoolPathFindClick(Sender: TObject);
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

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  SigntoolPath, PFXFilePath, PFXPassword, TimeStampServerURL, ProgramTitle,
    ProgramURL, SignedFolderPath: string;
  cmd, cmdparam: string;
begin
  if (not edtSigntoolPath.Text.IsEmpty) and (tfile.Exists(edtSigntoolPath.Text))
    and (edtSigntoolPath.Text.EndsWith('signtool.exe')) then
    SigntoolPath := edtSigntoolPath.Text
  else
  begin
    edtSigntoolPath.SetFocus;
    raise exception.Create('Invalid signtool.exe path');
  end;
  if (not edtPFXFilePath.Text.IsEmpty) and (tfile.Exists(edtPFXFilePath.Text))
    and (edtPFXFilePath.Text.EndsWith('.pfx')) then
    PFXFilePath := edtPFXFilePath.Text
  else
  begin
    edtPFXFilePath.SetFocus;
    raise exception.Create('Invalid code signing certificate file path');
  end;
  if not edtPFXPassword.Text.IsEmpty then
    PFXPassword := edtPFXPassword.Text
  else
  begin
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
    edtSignedFolderPath.SetFocus;
    raise exception.Create('Invalid folder path');
  end;

  BeginBlockingActivity;
  try
    cmd := '"' + SigntoolPath + '"';
    cmdparam := 'sign /v /debug /td SHA256 /fd SHA256 /f "' + PFXFilePath +
      '" /p ' + PFXPassword;
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
  edtPFXFilePath.Text := edtPFXFilePath.tagstring;
  // edtPFXPassword.text := edtPFXPassword.tagstring;
  edtTimeStampServerURL.Text := edtTimeStampServerURL.tagstring;
  edtProgramTitle.Text := edtProgramTitle.tagstring;
  edtProgramURL.Text := edtProgramURL.tagstring;
  edtSignedFolderPath.Text := edtSignedFolderPath.tagstring;
  cbRecursivity.IsChecked := FOldRecursivityValue;
end;

procedure TfrmMain.EndBlockingActivity;
begin
  LockScreenAnimation.Enabled := false;
  LockScreen.Visible := false;
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
          if (res <= 32) then
            raise exception.Create('ShellExecute error ' + res.ToString +
              ' for file ' + FileName);
          // Look at http://delphiprogrammingdiary.blogspot.com/2014/07/shellexecute-in-delphi.html for return values
        end);
      // Look at http://delphiprogrammingdiary.blogspot.com/2014/07/shellexecute-in-delphi.html for return values
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
{$IFDEF DEBUG}
  caption := caption + ' - DEBUG MODE';
{$ENDIF}
  EndBlockingActivity;
  edtSigntoolPath.Text := tparams.getValue('SignToolPath', '');
  edtPFXFilePath.Text := tparams.getValue('PFXFilePath', '');
  // edtPFXPassword.text := tparams.getValue('PFXPassword', '');
  edtPFXPassword.Text := '';
  edtTimeStampServerURL.Text := tparams.getValue('TimeStampServerURL', '');
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
    (edtPFXFilePath.tagstring <> edtPFXFilePath.Text) or
  // (edtPFXPassword.tagstring <> edtPFXPassword.text) or
    (edtTimeStampServerURL.tagstring <> edtTimeStampServerURL.Text) or
    (edtProgramTitle.tagstring <> edtProgramTitle.Text) or
    (edtProgramURL.tagstring <> edtProgramURL.Text) or
    (edtSignedFolderPath.tagstring <> edtSignedFolderPath.Text) or
    (FOldRecursivityValue <> cbRecursivity.IsChecked);
end;

procedure TfrmMain.lblBuyACodeSigningCertificateClick(Sender: TObject);
begin
  url_Open_In_Browser('https://www.ksoftware.net/code-signing-certificates/');
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
  edtPFXFilePath.tagstring := edtPFXFilePath.Text;
  // edtPFXPassword.tagstring := edtPFXPassword.text;
  edtTimeStampServerURL.tagstring := edtTimeStampServerURL.Text;
  edtProgramTitle.tagstring := edtProgramTitle.Text;
  edtProgramURL.tagstring := edtProgramURL.Text;
  edtSignedFolderPath.tagstring := edtSignedFolderPath.Text;
  FOldRecursivityValue := cbRecursivity.IsChecked;
end;

procedure TfrmMain.UpdateParams;
begin
  tparams.setValue('SignToolPath', edtSigntoolPath.Text);
  tparams.setValue('PFXFilePath', edtPFXFilePath.Text);
  // tparams.setValue('PFXPassword', edtPFXPassword.text);
  tparams.setValue('TimeStampServerURL', edtTimeStampServerURL.Text);
  tparams.setValue('ProgramTitle', edtProgramTitle.Text);
  tparams.setValue('ProgramURL', edtProgramURL.Text);
  tparams.setValue('SignedFolderPath', edtSignedFolderPath.Text);
  tparams.setValue('SignedFolderWithSubFolders', cbRecursivity.IsChecked);
  tparams.Save;
  UpdateChanges;
end;

initialization

randomize;
TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;

{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
tparams.setFolderName(tpath.Combine(tpath.Combine(tpath.GetDocumentsPath,
  'OlfSoftware-debug'), 'ExeBulkSigning-debug'));
{$ELSE}
tparams.setFolderName(tpath.Combine(tpath.Combine(tpath.GetHomePath,
  'OlfSoftware'), 'ExeBulkSigning'));
{$ENDIF}

end.
