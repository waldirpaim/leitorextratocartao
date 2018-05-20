unit LeitorExtratoCartaoRede;

interface

uses
  Classes,
  SysUtils,
  LeitorExtratoCartao;

type
  { TLeitorExtratoCartaoRede }

  TLeitorExtratoCartaoRede = class(TOperadoraCartao)
  private
    procedure Layout1(ARetorno: TStrings);
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
    Vdatavenda := StrToData(Copy(ARetorno[3], 17, 11));
    for VParcela in FListaDeParcelas do
    begin
      VParcela.datavenda := Vdatavenda;
      VParcela.dataprevista := Vdatavenda;
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
    else
      raise Exception.CreateRes(@SLAYOUT_ARQUIVO_NAO_DEFINIDO);
    end;

  finally
    VRetorno.Free;
  end;
end;

function TLeitorExtratoCartaoRede.ValidaArquivo(ARetorno: TStrings): Integer;
begin
  if SameText(Copy(ARetorno[0], 1, 14), 'Extrato Rede -') then
    Exit(1);
  Result := 0;
end;

end.

