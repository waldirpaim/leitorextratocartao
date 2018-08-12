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
    procedure Layout2(ARetorno: TStrings);
  public
    constructor create(AOwner: TLeitorExtratoCartao);
    procedure LerExtrato(const ANomeArq: string); override;
    procedure TratarLayout(ARetorno: TStrings); override;
    class function ValidaArquivo(AExt: TStrings): Integer; override;
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

procedure TLeitorExtratoCartaoSIPAG.TratarLayout(ARetorno: TStrings);
var
  I: Integer;
  VText: string;
  VResumo: string;
  VPos: Integer;
begin
  for I := ARetorno.Count - 1 downto 0 do
  begin
    VText := ARetorno[I].Trim;
    if (VText = '') or (VText.contains('"",,,,,,,,,,,,,,,,,')) then
      ARetorno.Delete(I);
  end;

  VResumo := '';
  for I := 0 to Pred(ARetorno.Count) do
  begin
    VText := ARetorno[I].Trim;
    if VText.contains('Resumo de Vendas:') then
    begin
      VPos := Pos('"Data de Crédito:', VText);
      if VPos > 0 then
        VText := Copy(VText, VPos + 18, 8);
      VResumo := VText;
      ARetorno[I] := '';
    end
    else if VResumo <> '' then
      ARetorno[I] := Concat(ARetorno[I], ',', VResumo);
  end;

  for I := ARetorno.Count - 1 downto 0 do
  begin
    VText := ARetorno[I].Trim;
    if (VText = '') then
      ARetorno.Delete(I);
  end;
end;

procedure TLeitorExtratoCartaoSIPAG.Layout2(ARetorno: TStrings);
var
  VTmp: TStringList;
begin
  VTmp := TStringList.Create;
  try
    VTmp.AddPair('separador', ',');
    VTmp.AddPair('linhainicial', '3');
    VTmp.AddPair('datavenda', '0');
    VTmp.AddPair('dataprevista', '18');
    VTmp.AddPair('nsudoc', '2');
    VTmp.AddPair('tipotransacao', '3');
    VTmp.AddPair('descricao', '3|4');
    VTmp.AddPair('numparcelas', '5');
    VTmp.AddPair('numerocartao', '7');
    VTmp.AddPair('codautorizacao', '6');
    VTmp.AddPair('valorbruto', '14');
    VTmp.AddPair('valordesconto', '15');
    VTmp.AddPair('valorliquido', '16');
    TratarLayout(ARetorno);
    ProcessaTemplate(ARetorno, VTmp);
  finally
    VTmp.Free;
  end;
end;

procedure TLeitorExtratoCartaoSIPAG.LerExtrato(const ANomeArq: string);
var
  VRetorno: TStringList;
begin
  inherited LerExtrato(ANomeArq);
  VRetorno := TStringList.create;
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

class function TLeitorExtratoCartaoSIPAG.ValidaArquivo(AExt: TStrings): Integer;
var
  VText: string;
begin
  VText := Copy(AExt.Text, 1, 21);
  if SameText(VText, 'DATATRANSACAO,CLIENTE') then
    Exit(1);
  VText := '';
  if AExt.Count >= 3 then
    VText := AExt[3];
  if SameText(Copy(VText, 1, 21), '"Histórico de Vendas"') then
    Exit(2);
  Result := 0;
end;

end.

