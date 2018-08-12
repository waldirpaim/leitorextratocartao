unit LeitorExtratoCartaoRede;

interface

uses
  Classes,
  SysUtils,
  Math,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoRede }

  TLeitorExtratoCartaoRede = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
    procedure Layout2(ARetorno: TStrings);
    procedure Layout3(ARetorno: TStrings);
    procedure Layout4(ARetorno: TStrings);
    procedure CalcRateio(AValBruto, AValDesc: Extended; const ADescricao, ATipo: string);
    function ObterValBruto(ARetorno: TStrings): Extended;
    function ObterValDesc(ARetorno: TStrings): Extended;
    function ObterValor(ARetorno: TStrings; ALinha: Integer): Extended;
    function ObterStr(ARetorno: TStrings; ALinha: Integer): string;
    procedure Layout5(ARetorno: TStrings);
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); override;
    class function ValidaArquivo(AExt: TStrings): Integer; override;
  end;

implementation

uses
  LeitorExtratoCartaoSODEXO,
  LeitorExtratoCartaoGoodCard;

{ TLeitorExtratoCartaoRede }

constructor TLeitorExtratoCartaoRede.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create(AOwner);
  fNome := 'Rede';
end;

procedure TLeitorExtratoCartaoRede.Layout1(ARetorno: TStrings);
var
  VTmp: TStringList;
  Vdatavenda: TDateTime;
  VParcela: TParcelaCartao;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ',');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '7');
    VTmp.AddPair('nsudoc', '0');
    VTmp.AddPair('codautorizacao', '0');
    VTmp.AddPair('valorbruto', '1');
    VTmp.AddPair('descricao', '6|3');
    VTmp.AddPair('valorliquido', '1');
    VTmp.AddPair('valordesconto', '-1');
    VTmp.AddPair('datavenda', '-1');
    VTmp.AddPair('dataprevista', '-1');
    VTmp.AddPair('tipotransacao', '-1');
    VTmp.AddPair('numerocartao', '-1');
    VTmp.AddPair('numparcelas', '-1');
    ProcessaTemplate(ARetorno, VTmp);
    Vdatavenda := ColunaData([Copy(ARetorno[3], 17, 11)], '0', '');
    for VParcela in FListaDeParcelas do
    begin
      VParcela.datavenda := Vdatavenda;
      VParcela.dataprevista := Vdatavenda;
    end;
  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoRede.Layout2(ARetorno: TStrings);
var
  VTmp: TStringList;
  Vdescricao: string;
  VTipo: string;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '10');
    VTmp.AddPair('nsudoc', '1');
    VTmp.AddPair('codautorizacao', '-1');
    VTmp.AddPair('valorbruto', '6');
    VTmp.AddPair('descricao', '-1');
    VTmp.AddPair('valorliquido', '-1');
    VTmp.AddPair('valordesconto', '-1');
    VTmp.AddPair('datavenda', '4');
    VTmp.AddPair('dataprevista', '-1');
    VTmp.AddPair('tipotransacao', '-1');
    VTmp.AddPair('numerocartao', '2');
    VTmp.AddPair('numparcelas', '-1');
    ProcessaTemplate(ARetorno, VTmp);

    VTipo := ObterStr(ARetorno, 3);

    Vdescricao := Concat(ObterStr(ARetorno, 2), ' ', VTipo);

    CalcRateio(ObterValBruto(ARetorno), ObterValDesc(ARetorno), Vdescricao, VTipo);

  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoRede.Layout3(ARetorno: TStrings);
var
  VTmp: TStringList;
  Vdescricao: string;
  VTipo: string;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '14');
    VTmp.AddPair('dataprevista', '-1');
    VTmp.AddPair('datavenda', '5');
    VTmp.AddPair('numerocartao', '2');
    VTmp.AddPair('tipotransacao', '-1');
    VTmp.AddPair('descricao', '-1');
    VTmp.AddPair('codautorizacao', '1');
    VTmp.AddPair('nsudoc', '1');
    VTmp.AddPair('valorbruto', '7');
    VTmp.AddPair('valorliquido', '-1');
    VTmp.AddPair('valordesconto', '-1');
    VTmp.AddPair('numparcelas', '8');
    ProcessaTemplate(ARetorno, VTmp);

    VTipo := 'Crédito';

    Vdescricao := Concat(ObterStr(ARetorno, 3), ' ', VTipo);

    CalcRateio(ObterValBruto(ARetorno), ObterValDesc(ARetorno), Vdescricao, VTipo);

  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoRede.Layout4(ARetorno: TStrings);
var
  VObj: TLeitorExtratoCartaoSODEXO;
  VParc: TParcelaCartao;
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

procedure TLeitorExtratoCartaoRede.Layout5(ARetorno: TStrings);
var
  VObj: TLeitorExtratoCartaoGoodCard;
  VParc: TParcelaCartao;
begin
  VObj := TLeitorExtratoCartaoGoodCard.Create(FOwner);
  try
    VObj.LerExtrato(ARetorno);
    for VParc in VObj.Parcelas do
      Parcelas.Add(VParc.Clone);
  finally
    VObj.Free;
  end;
end;

procedure TLeitorExtratoCartaoRede.CalcRateio(AValBruto: Extended; AValDesc:
  Extended; const ADescricao: string; const ATipo: string);

  function AplicarDif(AVal1: Extended; AVal2: Extended): Boolean;
  begin
    Result := SameValue(AVal1, Abs(AVal2), 0.0001) or (CompareValue(AVal1, Abs(AVal2),
      0.0001) <> 0);
  end;

var
  VDifDesconto: Extended;
  VSomaDesconto: Extended;
  VValDesc: Extended;
  VPerDesconto: Extended;
  VParcela: TParcelaCartao;
begin
  VPerDesconto := 0;

  if AValDesc > 0 then
    VPerDesconto := (AValDesc / AValBruto * 100);

  VSomaDesconto := 0;

  for VParcela in FListaDeParcelas do
  begin
    VParcela.descricao := ADescricao;
    VParcela.tipotransacao := ATipo;
    VValDesc := RoundTo(VParcela.valorbruto * VPerDesconto / 100, -2);
    VParcela.valordesconto := VValDesc;
    VSomaDesconto := Sum([VSomaDesconto, VParcela.valordesconto]);
    VParcela.valorliquido := VParcela.valorbruto - VParcela.valordesconto;
  end;

  if (CompareValue(VSomaDesconto, AValDesc, 0.0001) <> 0) then
  begin
    VDifDesconto := RoundTo(AValDesc - VSomaDesconto, -2);
    for VParcela in FListaDeParcelas do
      if AplicarDif(VParcela.valordesconto, VDifDesconto) then
      begin
        VParcela.valordesconto := VParcela.valordesconto + VDifDesconto;
        Exit;
      end;
  end;
end;

function TLeitorExtratoCartaoRede.ObterValor(ARetorno: TStrings; ALinha: Integer): Extended;
var
  VArray: TArray<string>;
begin
  VArray := ARetorno[ALinha].Split([';']);
  if Length(VArray) >= 1 then
    Exit(ColunaFloat([VArray[1]], '0', ''));
  Result := 0;
end;

function TLeitorExtratoCartaoRede.ObterStr(ARetorno: TStrings; ALinha: Integer): string;
var
  VArray: TArray<string>;
begin
  VArray := ARetorno[ALinha].Split([';']);
  if Length(VArray) >= 1 then
    Exit(ColunaStr([VArray[1]], '0', ''));
  Result := '';
end;

function TLeitorExtratoCartaoRede.ObterValBruto(ARetorno: TStrings): Extended;
begin
  Result := ObterValor(ARetorno, 5);
end;

function TLeitorExtratoCartaoRede.ObterValDesc(ARetorno: TStrings): Extended;
begin
  Result := ObterValor(ARetorno, 6);
end;

procedure TLeitorExtratoCartaoRede.LerExtrato(const ANomeArq: string);
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
      4:
        Layout4(VRetorno);
      5:
        Layout5(VRetorno);
    else
      raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, [ANomeArq]);
    end;

  finally
    VRetorno.Free;
  end;
end;

class function TLeitorExtratoCartaoRede.ValidaArquivo(AExt: TStrings): Integer;
var
  VText: string;
begin
  VText := Copy(AExt[0], 1, 14);
  if SameText(VText, 'Extrato Rede -') then
    Exit(1);
  if SameText(VText, 'data da venda;') and SameText(Copy(AExt[1], 1, 14), 'resumo vendas;') then
    Exit(2);
  if SameText(VText, 'data da venda;') and SameText(Copy(AExt[1], 1, 22),
    'data do processamento;') then
    Exit(3);
  if TLeitorExtratoCartaoSODEXO.ValidaArquivo(AExt) = 1 then
    Exit(4);
  if TLeitorExtratoCartaoGoodCard.ValidaArquivo(AExt) = 1 then
    Exit(5);
  Result := 0;
end;

end.

