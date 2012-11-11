program WowTransfer;

uses
  Vcl.Forms,
  uTransfer in 'uTransfer.pas' {frmTransfer} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TfrmTransfer, frmTransfer);
  Application.Run;

end.
