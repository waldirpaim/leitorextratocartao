unit LeitorExtratoCartaoSIPAG;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  TLeitorExtratoCartaoSIPAG = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
    function TestaEstruturaArquivo(AList: TStrings): Boolean;
  public
    constructor create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); override;
    function ValidaArquivo(ARetorno: TStrings): Integer; override;
  end;

implementation

constructor TLeitorExtratoCartaoSIPAG.create(AOwner: TLeitorExtratoCartao);
begin
  inherited create(AOwner);
  FShortDateFormat := 'dd/MM/yy';
  fNome := 'SIPAG';
end;

procedure TLeitorExtratoCartaoSIPAG.Layout1(ARetorno: TStrings);
var
  VTmp: TStringList;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ',');
    VTmp.AddPair('linhainicial', '1');
    VTmp.AddPair('datavenda', '0');
    VTmp.AddPair('dataprevista', '0');
    VTmp.AddPair('nsudoc', '2');
    VTmp.AddPair('tipotransacao', '3');
    VTmp.AddPair('descricao', '3|4');
    VTmp.AddPair('numparcelas', '5');
    VTmp.AddPair('numerocartao', '-1');
    VTmp.AddPair('codautorizacao', '6');
    VTmp.AddPair('valorbruto', '14');
    VTmp.AddPair('valordesconto', '15');
    VTmp.AddPair('valorliquido', '16');
    ProcessaTemplate(ARetorno, VTmp);
  finally
    VTmp.Free;
  end;
end;

function TLeitorExtratoCartaoSIPAG.TestaEstruturaArquivo(AList: TStrings): Boolean;
var
  S: string;
begin
  S := Copy(AList.Text, 1, 21);
  if SameText(S, 'DATATRANSACAO,CLIENTE') then
    Exit(True);
  Result := False;
end;

procedure TLeitorExtratoCartaoSIPAG.LerExtrato(const ANomeArq: string);
var
  VRetorno: TStringList;
begin
  inherited LerExtrato(ANomeArq);
  VRetorno := TStringList.create;
  try
    VRetorno.LoadFromFile(ANomeArq);
    if not TestaEstruturaArquivo(VRetorno) then
      raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, [ANomeArq]);

    case ValidaArquivo(VRetorno) of
      1:
        Layout1(VRetorno);
    else
      raise Exception.CreateRes(@SLAYOUT_ARQUIVO_NAO_DEFINIDO);
    end;

  finally
    VRetorno.Free;
  end;
end;

function TLeitorExtratoCartaoSIPAG.ValidaArquivo(ARetorno: TStrings): Integer;
begin
  Result := 1;
end;

end.

