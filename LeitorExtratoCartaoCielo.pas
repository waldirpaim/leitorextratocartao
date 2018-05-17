unit LeitorExtratoCartaoCielo;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoCielo }

  TLeitorExtratoCartaoCielo = class(TOperadoraCartao)
  protected
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
  fNome := 'Operadora Cielo';
end;

procedure TLeitorExtratoCartaoCielo.Layout1(ARetorno: TStrings);
var
  Parcela: TParcela;
  I: Integer;
  Item: TStringList;
begin
  Item := TStringList.Create;
  try
    for I := 3 to ARetorno.Count - 1 do
    begin
      CarregaItem(ARetorno.Strings[I], Item);
      if StrToData(Item.Strings[0]) = 0 then
        Continue;
      Parcela := CriarParcelaNaLista;
      Parcela.DataVenda := StrToData(Item.Strings[0]);
      Parcela.DataPrevista := StrToData(Item.Strings[1]);
      Parcela.Descricao := Item.Strings[3];
      Parcela.NumeroCartao := Item.Strings[4];
      Parcela.NumParcelas := '';
      Parcela.TipoTransacao := Item.Strings[2];
      Parcela.NsuDoc := Item.Strings[6];
      Parcela.CodAutorizacao := Item.Strings[7];
      Parcela.ValorBruto := StringToFloat(Item.Strings[8]);
      Parcela.ValorLiquido := Parcela.ValorBruto;
      Parcela.ValorDesconto := Parcela.ValorBruto - Parcela.ValorLiquido;
      Parcela.NsuDoc := Parcela.CodAutorizacao;
    end;
  finally
    Item.Free;
  end;
end;

procedure TLeitorExtratoCartaoCielo.Layout2(ARetorno: TStrings);
var
  Parcela: TParcela;
  I: Integer;
  Item: TStringList;
begin
  Item := TStringList.Create;
  try
    for I := 4 to Pred(ARetorno.Count) do
    begin
      CarregaItem(ARetorno.Strings[I], Item);
      if StrToData(Item.Strings[1]) = 0 then
        Continue;
      Parcela := CriarParcelaNaLista;
      Parcela.DataPrevista := StrToData(Item.Strings[1]);
      Parcela.DataVenda := StrToData(Item.Strings[2]);
      Parcela.NumeroCartao := Item.Strings[3];
      Parcela.NumParcelas := '';
      Parcela.TipoTransacao := Item.Strings[4];
      Parcela.Descricao := Parcela.TipoTransacao;
      Parcela.CodAutorizacao := Item.Strings[5];
      Parcela.ValorBruto := StringToFloat(Item.Strings[6]);
      Parcela.ValorLiquido := StringToFloat(Item.Strings[7]);
      Parcela.ValorDesconto := Parcela.ValorBruto - Parcela.ValorLiquido;
      Parcela.NsuDoc := Parcela.CodAutorizacao;
    end;
  finally
    Item.Free;
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
      raise Exception.CreateRes(@SLAYOUT_ARQUIVO_NAO_DEFINIDO);
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
