unit LeitorExtratoCartaoGoodCard;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoGoodCard }

  TLeitorExtratoCartaoGoodCard = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); overload; override;
    procedure LerExtrato(AExtrato: TStrings); overload; override;
    procedure TratarLayout(ARetorno: TStrings); override;
    class function ValidaArquivo(AExt: TStrings): Integer; override;
  end;

implementation

{ TLeitorExtratoCartaoGoodCard }

constructor TLeitorExtratoCartaoGoodCard.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create(AOwner);
  FShortDateFormat := 'dd/MM/yyyy hh:nn:ss';
  fNome := 'GoodCard';
end;

procedure TLeitorExtratoCartaoGoodCard.Layout1(ARetorno: TStrings);
var
  VTmp: TStringList;
  VParcela: TParcelaCartao;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '8');
    VTmp.AddPair('dataprevista', '6');
    VTmp.AddPair('datavenda', '3');
    VTmp.AddPair('numerocartao', '9');
    VTmp.AddPair('tipotransacao', '-1');
    VTmp.AddPair('descricao', '10|11');
    VTmp.AddPair('codautorizacao', '2');
    VTmp.AddPair('nsudoc', '2');
    VTmp.AddPair('valorbruto', '12');
    VTmp.AddPair('valorliquido', '15');
    VTmp.AddPair('valordesconto', '14');
    VTmp.AddPair('numparcelas', '4');
    TratarLayout(ARetorno);
    ProcessaTemplate(ARetorno, VTmp);
    for VParcela in FListaDeParcelas do
      VParcela.tipotransacao := 'Crédito';
  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoGoodCard.LerExtrato(AExtrato: TStrings);
begin
  case ValidaArquivo(AExtrato) of
    1:
      Layout1(AExtrato);
  else
    raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, ['']);
  end;
end;

procedure TLeitorExtratoCartaoGoodCard.TratarLayout(ARetorno: TStrings);
var
  I: Integer;
  VText: string;
begin
  for I := ARetorno.Count - 1 downto 0 do
  begin
    VText := ARetorno[I].Trim;
    if (VText = '') or (VText.contains('Sub-Total')) or (VText.contains('Total Geral2')) then
      ARetorno.Delete(I);
  end;
end;

procedure TLeitorExtratoCartaoGoodCard.LerExtrato(const ANomeArq: string);
var
  VRetorno: TStringList;
begin
  inherited LerExtrato(ANomeArq);
  VRetorno := TStringList.Create;
  VRetorno.Delimiter := ';';
  try
    VRetorno.LoadFromFile(ANomeArq);

    case ValidaArquivo(VRetorno) of
      1:
        Layout1(VRetorno);
    else
      raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, [ANomeArq]);
    end;

  finally
    VRetorno.Free;
  end;
end;

class function TLeitorExtratoCartaoGoodCard.ValidaArquivo(AExt: TStrings): Integer;
begin
  if SameText(Copy(AExt[1], 1, 7), 'Filial:') and SameText(Copy(AExt[2], 1, 18),
    'Data do pagamento:') then
    Exit(1);
  Result := 0;
end;

end.

