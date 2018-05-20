unit LeitorExtratoCartaoCielo;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoCielo }

  TLeitorExtratoCartaoCielo = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
    procedure Layout2(ARetorno: TStrings);
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); override;
    function ValidaArquivo(ARetorno: TStrings): Integer; override;
  end;

implementation

{ TLeitorExtratoCartaoCielo }

constructor TLeitorExtratoCartaoCielo.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create(AOwner);
  fNome := 'Cielo';
end;

procedure TLeitorExtratoCartaoCielo.Layout1(ARetorno: TStrings);
var
  VTmp: TStringList;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '3');
    VTmp.AddPair('datavenda', '0');
    VTmp.AddPair('dataprevista', '1');
    VTmp.AddPair('tipotransacao', '2');
    VTmp.AddPair('descricao', '3|2');
    VTmp.AddPair('numerocartao', '4');
    VTmp.AddPair('nsudoc', '6');
    VTmp.AddPair('codautorizacao', '7');
    VTmp.AddPair('valorbruto', '8');
    VTmp.AddPair('valorliquido', '8');
    VTmp.AddPair('valordesconto', '-1');
    VTmp.AddPair('numparcelas', '-1');
    ProcessaTemplate(ARetorno, VTmp);
  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoCielo.Layout2(ARetorno: TStrings);
var
  VTmp: TStringList;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '4');
    VTmp.AddPair('dataprevista', '1');
    VTmp.AddPair('datavenda', '2');
    VTmp.AddPair('numerocartao', '3');
    VTmp.AddPair('tipotransacao', '4');
    VTmp.AddPair('descricao', '4');
    VTmp.AddPair('codautorizacao', '5');
    VTmp.AddPair('nsudoc', '5');
    VTmp.AddPair('valorbruto', '6');
    VTmp.AddPair('valorliquido', '7');
    VTmp.AddPair('valordesconto', '-1');
    VTmp.AddPair('numparcelas', '-1');
    ProcessaTemplate(ARetorno, VTmp);
  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoCielo.LerExtrato(const ANomeArq: string);
var
  VRetorno: TStringList;
begin
  inherited LerExtrato(ANomeArq);
  VRetorno := TStringList.Create;
  try
    VRetorno.LoadFromFile(ANomeArq);

    case ValidaArquivo(VRetorno) of
      1:
        Layout1(VRetorno);
      2:
        Layout2(VRetorno);
    else
      raise Exception.CreateResFmt(@SLAYOUT_ARQUIVO_NAO_DEFINIDO, [ANomeArq]);
    end;

  finally
    VRetorno.Free;
  end;
end;

function TLeitorExtratoCartaoCielo.ValidaArquivo(ARetorno: TStrings): Integer;
begin
  if (SameText(Copy(Trim(ARetorno[0].Replace('"', '')), 1, 8), 'Período:')) then
    Exit(1);
  if SameText(Copy(ARetorno[0], 1, 25), 'Central de Relacionamento') then
    Exit(2);
  Result := 0;
end;

end.

