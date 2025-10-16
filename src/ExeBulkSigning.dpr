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
  Signature : 2839dcf8f7b182abf3c86d1abdd4c2efb4c0e3db
  ***************************************************************************
*)

program ExeBulkSigning;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uDMProjectLogo in 'uDMProjectLogo.pas' {dmProjectLogo: TDataModule},
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  Olf.RTL.CryptDecrypt in '..\lib-externes\librairies\src\Olf.RTL.CryptDecrypt.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  u_urlOpen in '..\lib-externes\librairies\src\u_urlOpen.pas',
  Olf.FMX.SelectDirectory in '..\lib-externes\Delphi-FMXExtend-Library\src\Olf.FMX.SelectDirectory.pas',
  ExeBulkSigningClientServerAPI in 'ExeBulkSigningClientServerAPI.pas',
  Olf.Net.Socket.Messaging in '..\lib-externes\Socket-Messaging-Library\src\Olf.Net.Socket.Messaging.pas',
  Olf.RTL.FileBuffer in '..\lib-externes\librairies\src\Olf.RTL.FileBuffer.pas',
  ExeBulkSigningClientLib in 'ExeBulkSigningClientLib.pas',
  ExeBulkSigningServerLib in 'ExeBulkSigningServerLib.pas',
  ExeBulkSigningClientServerAPIConsts in 'ExeBulkSigningClientServerAPIConsts.pas',
  Olf.RTL.GenRandomID in '..\lib-externes\librairies\src\Olf.RTL.GenRandomID.pas',
  DosCommand in '..\lib-externes\DOSCommand\Source\DosCommand.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmProjectLogo, dmProjectLogo);
  Application.Run;
end.
