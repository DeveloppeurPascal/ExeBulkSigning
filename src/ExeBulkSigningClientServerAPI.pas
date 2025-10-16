(* C2PP
  ***************************************************************************

  Exe Bulk Signing

  Copyright 2022-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://exebulksigning.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/ExeBulkSigning

  ***************************************************************************
  File last update : 2025-10-16T10:42:34.410+02:00
  Signature : 4c6c443b1bad849172f0dff5830743021dbf2352
  ***************************************************************************
*)

unit ExeBulkSigningClientServerAPI;

// ****************************************
// * Exe Bulk Signing Client / Server  API
// ****************************************
// 
// ****************************************
// File generator : Socket Messaging Code Generator (v1.1)
// Website : https://smcodegenerator.olfsoftware.fr/ 
// Generation date : 04/05/2024 16:37:41
// 
// Don't do any change on this file. They will be erased by next generation !
// ****************************************

// To compile this unit you need Olf.Net.Socket.Messaging.pas from
// https://github.com/DeveloppeurPascal/Socket-Messaging-Library
//
// Direct link to the file :
// https://raw.githubusercontent.com/DeveloppeurPascal/Socket-Messaging-Library/main/src/Olf.Net.Socket.Messaging.pas

interface

uses
  Olf.RTL.FileBuffer,
  System.Classes,
  Olf.Net.Socket.Messaging;

type
  /// <summary>
  /// Message ID 9: Error message
  /// </summary>
  TErrorMessage = class(TOlfSMMessage)
  private
    FErrorCode: integer;
    FErrorText: string;
    procedure SetErrorCode(const Value: integer);
    procedure SetErrorText(const Value: string);
  public
    /// <summary>
    /// Error code
    /// </summary>
    property ErrorCode: integer read FErrorCode write SetErrorCode;
    /// <summary>
    /// Error text
    /// </summary>
    property ErrorText: string read FErrorText write SetErrorText;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 7: File to sign
  /// </summary>
  /// <remarks>
  /// The client send a file to the server with
  /// signing parameters like the "title" and
  /// "url" to use with SignTool.exe command.
  /// </remarks>
  TFileToSignMessage = class(TOlfSMMessage)
  private
    FSignToolTitle: string;
    FSignToolURL: string;
    FFileBuffer: TOlfFileBuffer;
    FFileID: string;
    FSessionID: string;
    FFileNameWithItsExtension: string;
    procedure SetSignToolTitle(const Value: string);
    procedure SetSignToolURL(const Value: string);
    procedure SetFileBuffer(const Value: TOlfFileBuffer);
    procedure SetFileID(const Value: string);
    procedure SetSessionID(const Value: string);
    procedure SetFileNameWithItsExtension(const Value: string);
  public
    /// <summary>
    /// SignTool Title
    /// </summary>
    property SignToolTitle: string read FSignToolTitle write SetSignToolTitle;
    /// <summary>
    /// SignTool URL
    /// </summary>
    property SignToolURL: string read FSignToolURL write SetSignToolURL;
    /// <summary>
    /// File buffer
    /// </summary>
    property FileBuffer: TOlfFileBuffer read FFileBuffer write SetFileBuffer;
    /// <summary>
    /// File ID
    /// </summary>
    /// <remarks>
    /// ID of the file in the client program. The
    /// server don't need the file name or path, but the client yes.
    /// </remarks>
    property FileID: string read FFileID write SetFileID;
    /// <summary>
    /// Session ID
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    /// <summary>
    /// File name (with its extension)
    /// </summary>
    property FileNameWithItsExtension: string read FFileNameWithItsExtension write SetFileNameWithItsExtension;
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 5: LoginAnswer
  /// </summary>
  /// <remarks>
  /// Sent by the server after a login. If a
  /// SessionID is given, you can proceed, if not
  /// the server didn't accept the login.
  /// </remarks>
  TLoginAnswerMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    procedure SetSessionID(const Value: string);
  public
    /// <summary>
    /// Session ID
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 1: Login
  /// </summary>
  /// <remarks>
  /// Sent by the client to the server to open a
  /// session and get a session ID.
  /// </remarks>
  TLoginMessage = class(TOlfSMMessage)
  private
    FAPIVersionNumber: int64;
    FAuthorizationKey: string;
    procedure SetAPIVersionNumber(const Value: int64);
    procedure SetAuthorizationKey(const Value: string);
  public
    /// <summary>
    /// API version number
    /// </summary>
    property APIVersionNumber: int64 read FAPIVersionNumber write SetAPIVersionNumber;
    /// <summary>
    /// Authorization key
    /// </summary>
    property AuthorizationKey: string read FAuthorizationKey write SetAuthorizationKey;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 6: Logout
  /// </summary>
  /// <remarks>
  /// Sent by the client to the server to close a
  /// session
  /// </remarks>
  TLogoutMessage = class(TOlfSMMessage)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 8: Signed file
  /// </summary>
  TSignedFileMessage = class(TOlfSMMessage)
  private
    FFileBuffer: TOlfFileBuffer;
    FFileID: string;
    procedure SetFileBuffer(const Value: TOlfFileBuffer);
    procedure SetFileID(const Value: string);
  public
    /// <summary>
    /// Signed file buffer
    /// </summary>
    property FileBuffer: TOlfFileBuffer read FFileBuffer write SetFileBuffer;
    /// <summary>
    /// File ID
    /// </summary>
    property FileID: string read FFileID write SetFileID;
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  TExeBulkSigningClientServerAPIServer = class(TOlfSMServer)
  private
  protected
    procedure onReceiveMessage9(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage7(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage1(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage6(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
  public
    onReceiveErrorMessage
      : TOlfSMReceivedMessageEvent<TErrorMessage>;
    onReceiveFileToSignMessage
      : TOlfSMReceivedMessageEvent<TFileToSignMessage>;
    onReceiveLoginMessage
      : TOlfSMReceivedMessageEvent<TLoginMessage>;
    onReceiveLogoutMessage
      : TOlfSMReceivedMessageEvent<TLogoutMessage>;
    constructor Create; override;
  end;

  TExeBulkSigningClientServerAPIClient = class(TOlfSMClient)
  private
  protected
    procedure onReceiveMessage9(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage5(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage8(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
  public
    onReceiveErrorMessage
      : TOlfSMReceivedMessageEvent<TErrorMessage>;
    onReceiveLoginAnswerMessage
      : TOlfSMReceivedMessageEvent<TLoginAnswerMessage>;
    onReceiveSignedFileMessage
      : TOlfSMReceivedMessageEvent<TSignedFileMessage>;
    constructor Create; override;
  end;

procedure RegisterMessagesReceivedByTheServer(Const Server: TOlfSMServer);
procedure RegisterMessagesReceivedByTheClient(Const Client: TOlfSMClient);

implementation

uses
  System.SysUtils;

{$REGION 'code from Olf.RTL.Streams'}

procedure SaveStringToStream(AString: string; AStream: TStream;
  AEncoding: TEncoding); overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
var
  StrLen: int64; // typeof(System.Classes.TStream.size)
  StrStream: TStringStream;
begin
  StrStream := TStringStream.Create(AString, AEncoding);
  try
    StrLen := StrStream.Size;
    AStream.write(StrLen, sizeof(StrLen));
    if (StrLen > 0) then
    begin
      StrStream.Position := 0;
      AStream.CopyFrom(StrStream);
    end;
  finally
    StrStream.Free;
  end;
end;

procedure SaveStringToStream(AString: string; AStream: TStream); overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
begin
  SaveStringToStream(AString, AStream, TEncoding.UTF8);
end;

function LoadStringFromStream(AStream: TStream; AEncoding: TEncoding)
  : string; overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
var
  StrLen: int64; // typeof(System.Classes.TStream.size)
  StrStream: TStringStream;
begin
  AStream.Read(StrLen, sizeof(StrLen));
  if (StrLen > 0) then
  begin
    StrStream := TStringStream.Create('', AEncoding);
    try
      StrStream.CopyFrom(AStream, StrLen);
      result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  end
  else
    result := '';
end;

function LoadStringFromStream(AStream: TStream): string; overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
begin
  result := LoadStringFromStream(AStream, TEncoding.UTF8);
end;

{$ENDREGION}

procedure RegisterMessagesReceivedByTheServer(Const Server: TOlfSMServer);
begin
  Server.RegisterMessageToReceive(TErrorMessage.Create);
  Server.RegisterMessageToReceive(TFileToSignMessage.Create);
  Server.RegisterMessageToReceive(TLoginMessage.Create);
  Server.RegisterMessageToReceive(TLogoutMessage.Create);
end;

procedure RegisterMessagesReceivedByTheClient(Const Client: TOlfSMClient);
begin
  Client.RegisterMessageToReceive(TErrorMessage.Create);
  Client.RegisterMessageToReceive(TLoginAnswerMessage.Create);
  Client.RegisterMessageToReceive(TSignedFileMessage.Create);
end;

{$REGION 'TExeBulkSigningClientServerAPIServer'}

constructor TExeBulkSigningClientServerAPIServer.Create;
begin
  inherited;
  RegisterMessagesReceivedByTheServer(self);
  SubscribeToMessage(9, onReceiveMessage9);
  SubscribeToMessage(7, onReceiveMessage7);
  SubscribeToMessage(1, onReceiveMessage1);
  SubscribeToMessage(6, onReceiveMessage6);
end;

procedure TExeBulkSigningClientServerAPIServer.onReceiveMessage9(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TErrorMessage) then
    exit;
  if not assigned(onReceiveErrorMessage) then
    exit;
  onReceiveErrorMessage(ASender, AMessage as TErrorMessage);
end;

procedure TExeBulkSigningClientServerAPIServer.onReceiveMessage7(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TFileToSignMessage) then
    exit;
  if not assigned(onReceiveFileToSignMessage) then
    exit;
  onReceiveFileToSignMessage(ASender, AMessage as TFileToSignMessage);
end;

procedure TExeBulkSigningClientServerAPIServer.onReceiveMessage1(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TLoginMessage) then
    exit;
  if not assigned(onReceiveLoginMessage) then
    exit;
  onReceiveLoginMessage(ASender, AMessage as TLoginMessage);
end;

procedure TExeBulkSigningClientServerAPIServer.onReceiveMessage6(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TLogoutMessage) then
    exit;
  if not assigned(onReceiveLogoutMessage) then
    exit;
  onReceiveLogoutMessage(ASender, AMessage as TLogoutMessage);
end;

{$ENDREGION}

{$REGION 'TExeBulkSigningClientServerAPIClient'}

constructor TExeBulkSigningClientServerAPIClient.Create;
begin
  inherited;
  RegisterMessagesReceivedByTheClient(self);
  SubscribeToMessage(9, onReceiveMessage9);
  SubscribeToMessage(5, onReceiveMessage5);
  SubscribeToMessage(8, onReceiveMessage8);
end;

procedure TExeBulkSigningClientServerAPIClient.onReceiveMessage9(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TErrorMessage) then
    exit;
  if not assigned(onReceiveErrorMessage) then
    exit;
  onReceiveErrorMessage(ASender, AMessage as TErrorMessage);
end;

procedure TExeBulkSigningClientServerAPIClient.onReceiveMessage5(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TLoginAnswerMessage) then
    exit;
  if not assigned(onReceiveLoginAnswerMessage) then
    exit;
  onReceiveLoginAnswerMessage(ASender, AMessage as TLoginAnswerMessage);
end;

procedure TExeBulkSigningClientServerAPIClient.onReceiveMessage8(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TSignedFileMessage) then
    exit;
  if not assigned(onReceiveSignedFileMessage) then
    exit;
  onReceiveSignedFileMessage(ASender, AMessage as TSignedFileMessage);
end;

{$ENDREGION}

{$REGION 'TErrorMessage' }

constructor TErrorMessage.Create;
begin
  inherited;
  MessageID := 9;
  FErrorCode := 0;
  FErrorText := '';
end;

function TErrorMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TErrorMessage.Create;
end;

procedure TErrorMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FErrorCode, sizeof(FErrorCode)) <> sizeof(FErrorCode)) then
    raise exception.Create('Can''t load "ErrorCode" value.');
  FErrorText := LoadStringFromStream(Stream);
end;

procedure TErrorMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FErrorCode, sizeof(FErrorCode));
  SaveStringToStream(FErrorText, Stream);
end;

procedure TErrorMessage.SetErrorCode(const Value: integer);
begin
  FErrorCode := Value;
end;

procedure TErrorMessage.SetErrorText(const Value: string);
begin
  FErrorText := Value;
end;

{$ENDREGION}

{$REGION 'TFileToSignMessage' }

constructor TFileToSignMessage.Create;
begin
  inherited;
  MessageID := 7;
  FSignToolTitle := '';
  FSignToolURL := '';
  FFileBuffer := TOlfFileBuffer.Create;
  FFileID := '';
  FSessionID := '';
  FFileNameWithItsExtension := '';
end;

destructor TFileToSignMessage.Destroy;
begin
  FFileBuffer.Free;
  inherited;
end;

function TFileToSignMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TFileToSignMessage.Create;
end;

procedure TFileToSignMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSignToolTitle := LoadStringFromStream(Stream);
  FSignToolURL := LoadStringFromStream(Stream);
  FFileBuffer.LoadFromStream(Stream);
  FFileID := LoadStringFromStream(Stream);
  FSessionID := LoadStringFromStream(Stream);
  FFileNameWithItsExtension := LoadStringFromStream(Stream);
end;

procedure TFileToSignMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSignToolTitle, Stream);
  SaveStringToStream(FSignToolURL, Stream);
  FFileBuffer.SaveToStream(Stream);
  SaveStringToStream(FFileID, Stream);
  SaveStringToStream(FSessionID, Stream);
  SaveStringToStream(FFileNameWithItsExtension, Stream);
end;

procedure TFileToSignMessage.SetSignToolTitle(const Value: string);
begin
  FSignToolTitle := Value;
end;

procedure TFileToSignMessage.SetSignToolURL(const Value: string);
begin
  FSignToolURL := Value;
end;

procedure TFileToSignMessage.SetFileBuffer(const Value: TOlfFileBuffer);
begin
  FFileBuffer := Value;
end;

procedure TFileToSignMessage.SetFileID(const Value: string);
begin
  FFileID := Value;
end;

procedure TFileToSignMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TFileToSignMessage.SetFileNameWithItsExtension(const Value: string);
begin
  FFileNameWithItsExtension := Value;
end;

{$ENDREGION}

{$REGION 'TLoginAnswerMessage' }

constructor TLoginAnswerMessage.Create;
begin
  inherited;
  MessageID := 5;
  FSessionID := '';
end;

function TLoginAnswerMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TLoginAnswerMessage.Create;
end;

procedure TLoginAnswerMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
end;

procedure TLoginAnswerMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
end;

procedure TLoginAnswerMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

{$ENDREGION}

{$REGION 'TLoginMessage' }

constructor TLoginMessage.Create;
begin
  inherited;
  MessageID := 1;
  FAPIVersionNumber := 0;
  FAuthorizationKey := '';
end;

function TLoginMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TLoginMessage.Create;
end;

procedure TLoginMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FAPIVersionNumber, sizeof(FAPIVersionNumber)) <> sizeof(FAPIVersionNumber)) then
    raise exception.Create('Can''t load "APIVersionNumber" value.');
  FAuthorizationKey := LoadStringFromStream(Stream);
end;

procedure TLoginMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FAPIVersionNumber, sizeof(FAPIVersionNumber));
  SaveStringToStream(FAuthorizationKey, Stream);
end;

procedure TLoginMessage.SetAPIVersionNumber(const Value: int64);
begin
  FAPIVersionNumber := Value;
end;

procedure TLoginMessage.SetAuthorizationKey(const Value: string);
begin
  FAuthorizationKey := Value;
end;

{$ENDREGION}

{$REGION 'TLogoutMessage' }

constructor TLogoutMessage.Create;
begin
  inherited;
  MessageID := 6;
end;

function TLogoutMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TLogoutMessage.Create;
end;

procedure TLogoutMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
end;

procedure TLogoutMessage.SaveToStream(Stream: TStream);
begin
  inherited;
end;

{$ENDREGION}

{$REGION 'TSignedFileMessage' }

constructor TSignedFileMessage.Create;
begin
  inherited;
  MessageID := 8;
  FFileBuffer := TOlfFileBuffer.Create;
  FFileID := '';
end;

destructor TSignedFileMessage.Destroy;
begin
  FFileBuffer.Free;
  inherited;
end;

function TSignedFileMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TSignedFileMessage.Create;
end;

procedure TSignedFileMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FFileBuffer.LoadFromStream(Stream);
  FFileID := LoadStringFromStream(Stream);
end;

procedure TSignedFileMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  FFileBuffer.SaveToStream(Stream);
  SaveStringToStream(FFileID, Stream);
end;

procedure TSignedFileMessage.SetFileBuffer(const Value: TOlfFileBuffer);
begin
  FFileBuffer := Value;
end;

procedure TSignedFileMessage.SetFileID(const Value: string);
begin
  FFileID := Value;
end;

{$ENDREGION}

end.
