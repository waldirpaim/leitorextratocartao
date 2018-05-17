program LeitorExtratoCartaoDemo;

uses
  Vcl.Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {FrmPrincipal},
  LeitorExtratoCartao in '..\LeitorExtratoCartao.pas',
  LeitorExtratoCartaoCielo in '..\LeitorExtratoCartaoCielo.pas',
  LeitorExtratoCartaoRede in '..\LeitorExtratoCartaoRede.pas',
  LeitorExtratoCartaoSIPAG in '..\LeitorExtratoCartaoSIPAG.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
