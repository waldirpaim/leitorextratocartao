unit LeitorExtratoCartaoSIPAG;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoSIPAG }

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

resourcestring
  SARQUIVO_FORA_FORMATO = 'Arquivo %s não está no formato esperado.';

  { TCBrOperadoraSIPAG }

constructor TLeitorExtratoCartaoSIPAG.create(AOwner: TLeitorExtratoCartao);
begin
  inherited create(AOwner);
  FShortDateFormat := 'dd/MM/yy';
  fNome := 'Operadora SIPAG';
end;

procedure TLeitorExtratoCartaoSIPAG.Layout1(ARetorno: TStrings);
var
  Parcela: TParcela;
  I: Integer;
  Item: TStringList;
begin
  Item := TStringList.Create;
  try
    for I := 1 to Pred(ARetorno.Count) do
    begin
      CarregaItem(ARetorno.Strings[I], Item, '"', ',');
      if StrToData(Item.Strings[0]) = 0 then
        Continue;
      Parcela := CriarParcelaNaLista;
      Parcela.DataVenda := StrToData(Item.Strings[0]);
      Parcela.DataPrevista := 0;
      Parcela.NsuDoc := Item.Strings[2];
      Parcela.TipoTransacao := Item.Strings[3];
      Parcela.Descricao := Concat(Parcela.TipoTransacao, ' ', Item.Strings[4]);
      Parcela.NumParcelas := Item.Strings[5];
      Parcela.CodAutorizacao := Item.Strings[6];
      Parcela.NumeroCartao := Item.Strings[7];
      Parcela.ValorBruto := StringToFloat(Item.Strings[14]);
      Parcela.ValorDesconto := StringToFloat(Item.Strings[15]);
      Parcela.ValorLiquido := StringToFloat(Item.Strings[16]);
    end;
  finally
    Item.Free;
  end;
end;

function TLeitorExtratoCartaoSIPAG.TestaEstruturaArquivo
  (AList: TStrings): Boolean;
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
  VRetorno.Delimiter := ',';
  VRetorno.DelimitedText := '"';
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
