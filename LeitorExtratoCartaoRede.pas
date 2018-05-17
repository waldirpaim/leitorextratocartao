unit LeitorExtratoCartaoRede;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoRede}

  TLeitorExtratoCartaoRede = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    procedure LerArquivoOperadora(const ANomeArq: string); override;
    function ValidaArquivoOperadora(ARetorno: TStringList): Integer; override;
  end;

implementation

{ TLeitorExtratoCartaoRede }

constructor TLeitorExtratoCartaoRede.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create(AOwner);
  fNome := 'Operadora Rede';
end;

procedure TLeitorExtratoCartaoRede.Layout1(ARetorno: TStrings);
var
  Parcela: TParcela;
  I: Integer;
  Item: TStringList;
  DataVenda: TDateTime;
begin
  Item := TStringList.Create;
  DataVenda := StrToData(Copy(ARetorno[3], 17, 11));
  try
    for I := 7 to Pred(ARetorno.Count) do
    begin
      CarregaItem(ARetorno.Strings[I], Item, '"', ',');
      if StrToIntDef(Trim(Item.Strings[0]), 0) = 0 then
        Continue;
      Parcela := CriarParcelaNaLista;
      Parcela.DataVenda := DataVenda;
      Parcela.DataPrevista := DataVenda;
      Parcela.NumeroCartao := '';
      Parcela.TipoTransacao := '';
      Parcela.NsuDoc := Item.Strings[0];
      Parcela.ValorBruto := StringToFloat(Item.Strings[1]);
      Parcela.Descricao := Trim(Item.Strings[6]);
      if Parcela.Descricao = '' then
        Parcela.Descricao := Trim(Item.Strings[3]);
      Parcela.ValorLiquido := Parcela.ValorBruto;
      Parcela.ValorDesconto := Parcela.ValorBruto - Parcela.ValorLiquido;
      Parcela.CodAutorizacao := Parcela.NsuDoc;
    end;
  finally
    Item.Free;
  end;
end;

procedure TLeitorExtratoCartaoRede.LerArquivoOperadora(const ANomeArq: string);
var
  VRetorno: TStringList;
begin
  inherited LerArquivoOperadora(ANomeArq);
  VRetorno := TStringList.Create;
  try
    VRetorno.LoadFromFile(ANomeArq);

    case ValidaArquivoOperadora(VRetorno) of
      1:
        Layout1(VRetorno);
    else
      raise Exception.CreateRes(@SLAYOUT_ARQUIVO_NAO_DEFINIDO);
    end;

  finally
    VRetorno.Free;
  end;
end;

function TLeitorExtratoCartaoRede.ValidaArquivoOperadora(ARetorno: TStringList): Integer;
begin
  if SameText(Copy(ARetorno[0], 1, 14), 'Extrato Rede -') then
    Exit(1);
  Result := 0;
end;

end.

