unit ExeBulkSigningClientLib;

interface

uses
  ExeBulkSigningClientServerAPI,
  Olf.Net.Socket.Messaging;

type
  TESBClient = class
  private
    FAPIClient: TExeBulkSigningClientServerAPIClient;
  protected
    FSessionID: string;
    procedure ReceiveLoginAnswerMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TLoginAnswerMessage);
    procedure ReceiveSignedFileMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TSignedFileMessage);
    procedure ReceiveErrorMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TErrorMessage);
    procedure SendErrorMessage(Const ErrorText: string);
  public
    constructor Create(Const AIP: string; Const APort: word;
      Const AAuthKey: string);
    destructor Destroy; override;
  end;

implementation

uses
  Olf.RTL.FileBuffer,
  System.SysUtils,
  ExeBulkSigningClientServerAPIConsts;

{ TESBClient }

constructor TESBClient.Create(Const AIP: string; Const APort: word;
  Const AAuthKey: string);
var
  LoginMsg: TLoginMessage;
begin
  inherited Create;
  FSessionID := '';

  FAPIClient := TExeBulkSigningClientServerAPIClient.Create(AIP, APort);
  FAPIClient.onReceiveLoginAnswerMessage := ReceiveLoginAnswerMessage;
  FAPIClient.onReceiveSignedFileMessage := ReceiveSignedFileMessage;
  FAPIClient.onReceiveErrorMessage := ReceiveErrorMessage;
  FAPIClient.Connect;

  LoginMsg := TLoginMessage.Create;
  try
    LoginMsg.APIVersionNumber := CESBAPIVersion;
    LoginMsg.AuthorizationKey := AAuthKey;
    FAPIClient.SendMessage(LoginMsg);
  finally
    LoginMsg.Free;
  end;
end;

destructor TESBClient.Destroy;
begin
  FAPIClient.Free;
  inherited;
end;

procedure TESBClient.ReceiveErrorMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TErrorMessage);
begin
  // TODO : prévenir l'UI qu'une erreur a été détectée
end;

procedure TESBClient.ReceiveLoginAnswerMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TLoginAnswerMessage);
begin
  if AMessage.SessionID.IsEmpty then
    raise exception.Create('Can''t login.');

  FSessionID := AMessage.SessionID;

  // TODO : prévenir l'UI que la connexion est OK
end;

procedure TESBClient.ReceiveSignedFileMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TSignedFileMessage);
begin
  // TODO : à compléter
end;

procedure TESBClient.SendErrorMessage(const ErrorText: string);
var
  msg: TErrorMessage;
begin
  msg := TErrorMessage.Create;
  try
    msg.ErrorText := ErrorText;
    FAPIClient.SendMessage(msg);
  finally
    msg.Free;
  end;

  raise exception.Create(ErrorText);
end;

end.
