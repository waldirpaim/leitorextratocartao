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
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); override;
    function ValidaArquivo(ARetorno: TStrings): Integer; override;
  end;

implementation

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
  VArray: TArray<string>;
  Vdescricao: string;
  VTipo : string;
  VDesconto: Extended;
  VDifDesconto: Extended;
  VSomaDesconto: Extended;
  VValDesc : Extended;
  VPerDesconto: Extended;
  VValBruto: Extended;
  VParcela: TParcelaCartao;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '11');
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

    Vdescricao := '';

    VArray := ARetorno[2].Split([';']);
    if Length(VArray) >= 1 then
      Vdescricao := ColunaStr([VArray[1]], '0', '');

    VTipo := '';

    VArray := ARetorno[3].Split([';']);
    if Length(VArray) >= 1 then
      VTipo := ColunaStr([VArray[1]], '0', '');

    Vdescricao := Concat( Vdescricao, ' ', VTipo );

    VValBruto := 0;

    VArray := ARetorno[5].Split([';']);
    if Length(VArray) >= 1 then
      VValBruto := ColunaFloat([VArray[1]], '0', '');

    VDesconto := 0;

    VArray := ARetorno[6].Split([';']);
    if Length(VArray) >= 1 then
      VDesconto := ColunaFloat([VArray[1]], '0', '');

    VPerDesconto := 0;

    if VDesconto > 0 then
      VPerDesconto := (VDesconto / VValBruto * 100);

    VSomaDesconto := 0;

    for VParcela in FListaDeParcelas do
    begin
      VParcela.descricao := Vdescricao;
      VParcela.tipotransacao := VTipo;
      VValDesc := RoundTo( VParcela.valorbruto * VPerDesconto / 100, -2);
      VParcela.valordesconto := VValDesc;
      VSomaDesconto := Sum([VSomaDesconto, VParcela.valordesconto]);
      VParcela.valorliquido := VParcela.valorbruto - VParcela.valordesconto;
      if CompareValue(VSomaDesconto, VDesconto, 0.0001) > 0 then
      begin
        VDifDesconto := RoundTo(VSomaDesconto - VDesconto, 2);
        if VDifDesconto > 0 then
          VParcela.valordesconto := VParcela.valordesconto + VDifDesconto
        else if VParcela.valordesconto > Abs(VDifDesconto) then
          VParcela.valordesconto := VParcela.valordesconto - VDifDesconto;
      end;
    end;

  finally
    VTmp.Free;
  end;
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
    else
      raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, [ANomeArq]);
    end;

  finally
    VRetorno.Free;
  end;
end;

function TLeitorExtratoCartaoRede.ValidaArquivo(ARetorno: TStrings): Integer;
var
  VText: string;
begin
  VText := Copy(ARetorno[0], 1, 14);
  if SameText(VText, 'Extrato Rede -') then
    Exit(1);
  if SameText(VText, 'data da venda;') and SameText(Copy(ARetorno[1], 1, 14), 'resumo vendas;') then
    Exit(2);
  Result := 0;
end;

end.

