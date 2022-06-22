program ExeBulkSigning;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
