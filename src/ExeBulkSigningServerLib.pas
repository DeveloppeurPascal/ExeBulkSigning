unit ExeBulkSigningServerLib;

interface

uses
  ExeBulkSigningClientServerAPI,
  Olf.Net.Socket.Messaging;

type
  TESBServer = class
  private
    FAPIServer: TExeBulkSigningClientServerAPIServer;
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
    constructor Create(Const AIP: string; Const APort: word;
      Const AAuthKey: string);
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  Olf.RTL.FileBuffer,
  ExeBulkSigningClientServerAPIConsts,
  Olf.RTL.GenRandomID;

{ TESBServer }

constructor TESBServer.Create(Const AIP: string; Const APort: word;
  Const AAuthKey: string);
begin
  inherited Create;
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
begin
  // TODO : à compléter
end;

procedure TESBServer.ReceiveFileToSignMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TFileToSignMessage);
begin
  // TODO : à compléter
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
    msg.ErrorText := ErrorText;
    ToClient.SendMessage(msg);
  finally
    msg.Free;
  end;

  raise Exception.Create(ErrorText);
end;

procedure TESBServer.ServerConnected(AServer: TOlfSMServer);
begin
  // TODO : inform the UI the server is ok
end;

procedure TESBServer.ServerDisconnected(AServer: TOlfSMServer);
begin
  // TODO : inform the UI the server is down
end;

end.
