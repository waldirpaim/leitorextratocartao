unit LeitorExtratoCartaoSODEXO;

interface

uses
  Classes,
  SysUtils,
  Math,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoSODEXO }

  TLeitorExtratoCartaoSODEXO = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
    procedure CalcRateio(AValBruto, AValDesc: Extended; const ATipo: string);
    function ObterValBruto(ARetorno: TStrings): Extended;
    function ObterValor(ARetorno: TStrings; ALinha: Integer; ACol: Integer): Extended;
    function ObterStr(ARetorno: TStrings; ALinha: Integer; const ASep: string = ';'): string;
    function ObterValLiquido(ARetorno: TStrings): Extended;
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); overload; override;
    procedure LerExtrato(AExtrato: TStrings); overload; override;
    class function ValidaArquivo(AExt: TStrings): Integer; override;
  end;

implementation

{ TLeitorExtratoCartaoSODEXO }

constructor TLeitorExtratoCartaoSODEXO.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create(AOwner);
  fNome := 'SODEXO';
end;

procedure TLeitorExtratoCartaoSODEXO.Layout1(ARetorno: TStrings);
var
  VTmp: TStringList;
  VTipo: string;
  VValBruto: Extended;
  VValLiquido: Extended;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ';');
    VTmp.AddPair('quote', '"');
    VTmp.AddPair('linhainicial', '14');
    VTmp.AddPair('dataprevista', '-1');
    VTmp.AddPair('datavenda', '2');
    VTmp.AddPair('numerocartao', '2');
    VTmp.AddPair('tipotransacao', '-1');
    VTmp.AddPair('descricao', '5|4');
    VTmp.AddPair('codautorizacao', '7');
    VTmp.AddPair('nsudoc', '7');
    VTmp.AddPair('valorbruto', '8');
    VTmp.AddPair('valorliquido', '-1');
    VTmp.AddPair('valordesconto', '-1');
    VTmp.AddPair('numparcelas', '-1');
    ProcessaTemplate(ARetorno, VTmp);

    VTipo := ObterStr(ARetorno, 4);

    VValBruto := ObterValBruto(ARetorno);
    VValLiquido := ObterValLiquido(ARetorno);

    CalcRateio(VValBruto, VValBruto - VValLiquido, VTipo);

  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoSODEXO.LerExtrato(AExtrato: TStrings);
begin
  case ValidaArquivo(AExtrato) of
      1:
        Layout1(AExtrato);
    else
      raise Exception.CreateResFmt(@SARQUIVO_FORA_FORMATO, ['']);
    end;
end;

procedure TLeitorExtratoCartaoSODEXO.CalcRateio(AValBruto: Extended; AValDesc:
  Extended; const ATipo: string);

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

function TLeitorExtratoCartaoSODEXO.ObterValor(ARetorno: TStrings; ALinha:
  Integer; ACol: Integer): Extended;
var
  VArray: TArray<string>;
begin
  VArray := ARetorno[ALinha].Split([';']);
  if Length(VArray) >= ACol then
    Exit(ColunaFloat([VArray[ACol]], '0', ''));
  Result := 0;
end;

function TLeitorExtratoCartaoSODEXO.ObterStr(ARetorno: TStrings; ALinha: Integer;
  const ASep: string): string;
var
  VArray: TArray<string>;
  VText: string;
begin
  VArray := ARetorno[ALinha].Split([ASep]);
  if Length(VArray) >= 1 then
  begin
    VText := VArray[0];
    if VText.contains(':') then
      VArray := VText.Split([':']);
    Exit(ColunaStr([VArray[1]], '0', ''));
  end;
  Result := '';
end;

function TLeitorExtratoCartaoSODEXO.ObterValBruto(ARetorno: TStrings): Extended;
begin
  Result := ObterValor(ARetorno, 6, 8);
end;

function TLeitorExtratoCartaoSODEXO.ObterValLiquido(ARetorno: TStrings): Extended;
begin
  Result := ObterValor(ARetorno, 10, 8);
end;

procedure TLeitorExtratoCartaoSODEXO.LerExtrato(const ANomeArq: string);
var
  VRetorno: TStringList;
begin
  inherited LerExtrato(ANomeArq);
  VRetorno := TStringList.Create;
  VRetorno.LineBreak := #10;
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

class function TLeitorExtratoCartaoSODEXO.ValidaArquivo(AExt: TStrings): Integer;
begin
  if SameText(Copy(AExt[0], 1, 14), 'Nome Fantasia:') and SameText(Copy(AExt
    [1], 1, 13), 'Razão Social:') then
    Exit(1);
  Result := 0;
end;

end.

