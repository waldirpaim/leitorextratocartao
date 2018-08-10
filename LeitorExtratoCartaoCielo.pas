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
    procedure Layout3(ARetorno: TStrings);
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); override;
    class function ValidaArquivo(AExt: TStrings): Integer; override;
  end;

implementation

uses
  LeitorExtratoCartaoSODEXO;

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

procedure TLeitorExtratoCartaoCielo.Layout3(ARetorno: TStrings);
var
  VObj: TLeitorExtratoCartaoSODEXO;
  VParc : TParcelaCartao;
begin
  VObj := TLeitorExtratoCartaoSODEXO.Create(FOwner);
  try
   VObj.LerExtrato(ARetorno);
   for VParc in VObj.Parcelas do
   Parcelas.Add(VParc.Clone);
  finally
    VObj.Free;
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
      3:
        Layout3(VRetorno);
    else
      raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, [ANomeArq]);
    end;

  finally
    VRetorno.Free;
  end;
end;

class function TLeitorExtratoCartaoCielo.ValidaArquivo(AExt: TStrings): Integer;
begin
  if (SameText(Copy(Trim(AExt[0].Replace('"', '')), 1, 8), 'Período:')) then
    Exit(1);
  if SameText(Copy(AExt[0], 1, 25), 'Central de Relacionamento') then
    Exit(2);
  if TLeitorExtratoCartaoSODEXO.ValidaArquivo(AExt) = 1 then
    Exit(3);
  Result := 0;
end;

end.

