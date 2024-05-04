unit ExeBulkSigningServerLib;

interface

uses
  ExeBulkSigningClientServerAPI,
  Olf.Net.Socket.Messaging;

type
  TSignFileEvent = procedure(Const ATitle, AURL, AFileName: string) of object;

  TESBServer = class
  private
    FAPIServer: TExeBulkSigningClientServerAPIServer;
    FonSignFile: TSignFileEvent;
    procedure SetonSignFile(const Value: TSignFileEvent);
  protected
    FAuthKey: string;
    procedure ReceiveFileToSignMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TFileToSignMessage);
    procedure ReceiveLoginMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TLoginMessage);
    procedure ReceiveLogoutMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TLogoutMessage);
    procedure ReceiveErrorMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TErrorMessage);
    procedure SendErrorMessage(const ToClient: TOlfSMSrvConnectedClient;
      Const ErrorText: string);
    procedure ServerConnected(AServer: TOlfSMServer);
    procedure ServerDisconnected(AServer: TOlfSMServer);
  public
    property onSignFile: TSignFileEvent read FonSignFile write SetonSignFile;
    constructor Create(Const AIP: string; Const APort: word;
      Const AAuthKey: string);
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,
  Olf.RTL.FileBuffer,
  ExeBulkSigningClientServerAPIConsts,
  Olf.RTL.GenRandomID;

{ TESBServer }

constructor TESBServer.Create(Const AIP: string; Const APort: word;
  Const AAuthKey: string);
begin
  inherited Create;
  FonSignFile := nil;
  FAuthKey := AAuthKey;

  FAPIServer := TExeBulkSigningClientServerAPIServer.Create(AIP, APort);
  FAPIServer.onReceiveFileToSignMessage := ReceiveFileToSignMessage;
  FAPIServer.onReceiveLoginMessage := ReceiveLoginMessage;
  FAPIServer.onReceiveLogoutMessage := ReceiveLogoutMessage;
  FAPIServer.onReceiveErrorMessage := ReceiveErrorMessage;
  // TODO : add an onListenError event
  FAPIServer.onServerConnected := ServerConnected;
  FAPIServer.onServerDisconnected := ServerDisconnected;
  FAPIServer.Listen;
end;

destructor TESBServer.Destroy;
begin
  FAPIServer.Free;
  inherited;
end;

procedure TESBServer.ReceiveErrorMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TErrorMessage);
{$IFDEF DEBUG}
var
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningServerLog.txt');
{$ENDIF}
{$IFDEF DEBUG}
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    '*** ERROR *** ' + AMessage.ErrorCode.tostring + ' - ' + AMessage.ErrorText,
    tencoding.UTF8);
{$ENDIF}
  // TODO : à compléter
end;

procedure TESBServer.ReceiveFileToSignMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TFileToSignMessage);
var
  FileName: string;
  FileID: string;
  Title, URL: string;
  ToClient: TOlfSMSrvConnectedClient;
{$IFDEF DEBUG}
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningServerLog.txt');
{$ENDIF}
{$IFDEF DEBUG}
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    AMessage.FileNameWithItsExtension + ' (' + AMessage.FileBuffer.Size.tostring
    + ')', tencoding.UTF8);
{$ENDIF}
  if (ASender.TagString <> AMessage.SessionID) then
  begin
{$IFDEF DEBUG}
    tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak
      + 'wrong session id "' + AMessage.SessionID + '" <> "' + ASender.TagString
      + '"', tencoding.UTF8);
{$ENDIF}
    SendErrorMessage(ASender, 'Wrong session ID.');
  end
  else
  begin
    // TODO : s'assurer que le fichier transmis a une extension supportée
    // if (tpath.GetExtension(FileName).ToLower = '.exe') or
    // (tpath.GetExtension(FileName).ToLower = '.msix') then

    ToClient := ASender;
    FileID := AMessage.FileID;
    Title := AMessage.SignToolTitle;
    URL := AMessage.SignToolURL;
    FileName := tpath.GetTempFileName;
    if tfile.Exists(FileName) then
      tfile.Delete(FileName);
    FileName := FileName + tpath.GetExtension
      (AMessage.FileNameWithItsExtension);
    try
      AMessage.FileBuffer.SaveToFile(FileName);
      tthread.forcequeue(nil,
        procedure
        var
          msg: TSignedFileMessage;
        begin
          if assigned(FonSignFile) then
            FonSignFile(Title, URL, FileName);
          msg := TSignedFileMessage.Create;
          try
            msg.FileBuffer.LoadFromFile(FileName);
            msg.FileID := FileID;
            ToClient.SendMessage(msg);
            tfile.Delete(FileName);
          finally
            msg.Free;
          end;
        end);
    except
      tfile.Delete(FileName);
    end;
  end;
end;

procedure TESBServer.ReceiveLoginMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TLoginMessage);
var
  msg: TLoginAnswerMessage;
begin
  if (AMessage.APIVersionNumber <> CESBAPIVersion) then
    SendErrorMessage(ASender, 'Wrong API number. Update your client.');

  if (AMessage.AuthorizationKey <> FAuthKey) then
    SendErrorMessage(ASender, 'Wrong password.');

  // TODO: stocker client dans liste clients (si garbage collector un jour pour virer les "vieilles" connexions)

  ASender.TagString := TOlfRandomIDGenerator.getIDBase62(random(30) + 10);

  msg := TLoginAnswerMessage.Create;
  try
    msg.SessionID := ASender.TagString;
    ASender.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TESBServer.ReceiveLogoutMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TLogoutMessage);
begin
  tthread.forcequeue(nil,
    procedure
    begin
      ASender.Free;
    end);
end;

procedure TESBServer.SendErrorMessage(const ToClient: TOlfSMSrvConnectedClient;
const ErrorText: string);
var
  msg: TErrorMessage;
begin
  msg := TErrorMessage.Create;
  try
    msg.ErrorCode := 0;
    msg.ErrorText := ErrorText;
    ToClient.SendMessage(msg);
  finally
    msg.Free;
  end;

  raise Exception.Create(ErrorText);
end;

procedure TESBServer.ServerConnected(AServer: TOlfSMServer);
{$IFDEF DEBUG}
var
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningServerLog.txt');
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    'Server connected', tencoding.UTF8);
{$ENDIF}
  // TODO : inform the UI the server is ok
end;

procedure TESBServer.ServerDisconnected(AServer: TOlfSMServer);
{$IFDEF DEBUG}
var
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningServerLog.txt');
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    'Server disconnected', tencoding.UTF8);
{$ENDIF}
  // TODO : inform the UI the server is down
end;

procedure TESBServer.SetonSignFile(const Value: TSignFileEvent);
begin
  FonSignFile := Value;
end;

end.
