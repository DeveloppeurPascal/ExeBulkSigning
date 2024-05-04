unit ExeBulkSigningClientLib;

interface

uses
  ExeBulkSigningClientServerAPI,
  System.Generics.Collections,
  Olf.Net.Socket.Messaging;

type
  TESBClient = class
  private
    FAPIClient: TExeBulkSigningClientServerAPIClient;
    FWaitingFiles: TObjectQueue<TFileToSignMessage>;
    FSentFiles: TDictionary<string, string>;
  protected
    FSessionID: string;
    FAuthKey: string;
    procedure ReceiveLoginAnswerMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TLoginAnswerMessage);
    procedure ReceiveSignedFileMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TSignedFileMessage);
    procedure ReceiveErrorMessage(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TErrorMessage);
    procedure SendErrorMessage(Const ErrorText: string);
    procedure ClientConnected(Const AConnectedClient: TOlfSMSrvConnectedClient);
  public
    /// <summary>
    /// Check if the client is connected to a server.
    /// </summary>
    function isConnected: boolean;
    /// <summary>
    /// Send a file to the signing server.
    /// </summary>
    procedure SendFileToServer(const Title, URL, Filename: string);
    /// <summary>
    /// Returns the number of file sent to the server waiting for its response.
    /// </summary>
    function HasWaitingFiles: int64;
    /// <summary>
    /// Create an instance of the client and try to connect to a signing server.
    /// </summary>
    constructor Create(Const AIP: string; Const APort: word;
      Const AAuthKey: string);
    /// <summary>
    /// Close the connection and free the memory used by this instance.
    /// </summary>
    destructor Destroy; override;
  end;

implementation

uses
  System.IOUtils,
  Olf.RTL.FileBuffer,
  System.SysUtils,
  ExeBulkSigningClientServerAPIConsts,
  Olf.RTL.GenRandomID;

{ TESBClient }

procedure TESBClient.ClientConnected(const AConnectedClient
  : TOlfSMSrvConnectedClient);
var
  LoginMsg: TLoginMessage;
begin
  LoginMsg := TLoginMessage.Create;
  try
    LoginMsg.APIVersionNumber := CESBAPIVersion;
    LoginMsg.AuthorizationKey := FAuthKey;
    AConnectedClient.SendMessage(LoginMsg);
  finally
    LoginMsg.Free;
  end;
end;

constructor TESBClient.Create(Const AIP: string; Const APort: word;
  Const AAuthKey: string);
begin
  inherited Create;
  FSessionID := '';
  FAuthKey := AAuthKey;

  FWaitingFiles := TObjectQueue<TFileToSignMessage>.Create(true);
  FSentFiles := TDictionary<string, string>.Create;

  FAPIClient := TExeBulkSigningClientServerAPIClient.Create(AIP, APort);
  FAPIClient.onReceiveLoginAnswerMessage := ReceiveLoginAnswerMessage;
  FAPIClient.onReceiveSignedFileMessage := ReceiveSignedFileMessage;
  FAPIClient.onReceiveErrorMessage := ReceiveErrorMessage;
  FAPIClient.onConnected := ClientConnected;
  FAPIClient.Connect;
end;

destructor TESBClient.Destroy;
begin
  FAPIClient.Free;
  FWaitingFiles.Free;
  FSentFiles.Free;
  inherited;
end;

function TESBClient.HasWaitingFiles: int64;
var
  msg: TFileToSignMessage;
{$IFDEF DEBUG}
  Log: string;
{$ENDIF}
begin
  result := 0;

{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningClientLog.txt');
{$ENDIF}
  tmonitor.enter(FWaitingFiles);
  try
    result := result + FWaitingFiles.Count;
    if (result > 0) and (not FSessionID.IsEmpty) then
    begin
      while (FWaitingFiles.Count > 0) do
      begin
        msg := FWaitingFiles.Extract;
        try
{$IFDEF DEBUG}
          tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) +
            slinebreak + 'Wait list to sent list : ' +
            msg.FileNameWithItsExtension, tencoding.UTF8);
{$ENDIF}
          msg.SessionID := FSessionID;
          FAPIClient.SendMessage(msg);
          tmonitor.enter(FSentFiles);
          try
            FSentFiles.Add(msg.FileID, msg.FileNameWithItsExtension);
          finally
            tmonitor.Exit(FSentFiles);
          end;
        finally
          msg.Free;
        end;
      end;
      result := 0;
    end;
  finally
    tmonitor.Exit(FWaitingFiles);
  end;

  tmonitor.enter(FSentFiles);
  try
    result := result + FSentFiles.Count;
  finally
    tmonitor.Exit(FSentFiles);
  end;

{$IFDEF DEBUG}
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    'Nb files to sign : ' + result.tostring, tencoding.UTF8);
{$ENDIF}
end;

function TESBClient.isConnected: boolean;
begin
  result := FAPIClient.isConnected;
end;

procedure TESBClient.ReceiveErrorMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TErrorMessage);
{$IFDEF DEBUG}
var
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningClientLog.txt');
{$ENDIF}
{$IFDEF DEBUG}
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    '*** ERROR *** ' + AMessage.ErrorCode.tostring + ' - ' + AMessage.ErrorText,
    tencoding.UTF8);
{$ENDIF}
  // TODO : prévenir l'UI qu'une erreur a été détectée
end;

procedure TESBClient.ReceiveLoginAnswerMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TLoginAnswerMessage);
begin
  if AMessage.SessionID.IsEmpty then
    raise Exception.Create('Can''t login.');

  FSessionID := AMessage.SessionID;
end;

procedure TESBClient.ReceiveSignedFileMessage(const ASender
  : TOlfSMSrvConnectedClient; const AMessage: TSignedFileMessage);
var
  Filename: string;
{$IFDEF DEBUG}
var
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningClientLog.txt');
{$ENDIF}
  tmonitor.enter(FSentFiles);
  try
    if FSentFiles.TryGetValue(AMessage.FileID, Filename) then
      FSentFiles.Remove(AMessage.FileID)
    else
      Filename := '';
  finally
    tmonitor.Exit(FSentFiles);
  end;
{$IFDEF DEBUG}
  tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak +
    'Signed file received : ' + AMessage.FileID + ' - ' + Filename,
    tencoding.UTF8);
{$ENDIF}
  if Filename.IsEmpty then
  begin
    // TODO : signaler anomalie au niveau de l'UI
{$IFDEF DEBUG}
    tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) + slinebreak
      + '*** ERROR *** ' + AMessage.FileID + ' not found in SentFiles list.',
      tencoding.UTF8);
{$ENDIF}
  end
  else
    AMessage.FileBuffer.SaveToFile
      (tpath.Combine(tpath.GetDirectoryName(Filename),
      tpath.GetFileNameWithoutExtension(Filename) + '-signed' +
      tpath.GetExtension(Filename)));
end;

procedure TESBClient.SendErrorMessage(const ErrorText: string);
var
  msg: TErrorMessage;
begin
  msg := TErrorMessage.Create;
  try
    msg.ErrorCode := 0;
    msg.ErrorText := ErrorText;
    FAPIClient.SendMessage(msg);
  finally
    msg.Free;
  end;

  raise Exception.Create(ErrorText);
end;

procedure TESBClient.SendFileToServer(const Title, URL, Filename: string);
var
  msg: TFileToSignMessage;
{$IFDEF DEBUG}
  Log: string;
{$ENDIF}
begin
{$IFDEF DEBUG}
  Log := tpath.Combine(tpath.GetDocumentsPath, 'ExeBulkSigningClientLog.txt');
{$ENDIF}
  if not tfile.Exists(Filename) then
    raise Exception.Create('File "' + Filename + '" doesn''t exist !');

  if FSessionID.IsEmpty then
  begin
    msg := TFileToSignMessage.Create;
    try
      msg.SignToolTitle := Title;
      msg.SignToolURL := URL;
      msg.SessionID := '';
      msg.FileNameWithItsExtension := Filename;
      msg.FileID := TOlfRandomIDGenerator.getIDBase62(50);
      msg.FileBuffer.LoadFromFile(Filename);
      tmonitor.enter(FWaitingFiles);
      try
        FWaitingFiles.Enqueue(msg);
{$IFDEF DEBUG}
        tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) +
          slinebreak + 'Wait list : ' + msg.FileNameWithItsExtension,
          tencoding.UTF8);
{$ENDIF}
      finally
        tmonitor.Exit(FWaitingFiles);
      end;
    except
      msg.Free;
    end;
  end
  else
  begin
    msg := TFileToSignMessage.Create;
    try
      msg.SignToolTitle := Title;
      msg.SignToolURL := URL;
      msg.SessionID := FSessionID;
      msg.FileNameWithItsExtension := Filename;
      msg.FileID := TOlfRandomIDGenerator.getIDBase62(50);
      msg.FileBuffer.LoadFromFile(Filename);
      FAPIClient.SendMessage(msg);
      tmonitor.enter(FSentFiles);
      try
        FSentFiles.Add(msg.FileID, msg.FileNameWithItsExtension);
{$IFDEF DEBUG}
        tfile.WriteAllText(Log, tfile.ReadAllText(Log, tencoding.UTF8) +
          slinebreak + 'Sent list : ' + msg.FileNameWithItsExtension,
          tencoding.UTF8);
{$ENDIF}
      finally
        tmonitor.Exit(FSentFiles);
      end;
    finally
      msg.Free;
    end;
  end;
end;

end.
