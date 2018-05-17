unit LeitorExtratoCartao;

interface

uses
  Classes,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF}
  System.Generics.Collections,
  System.IOUtils,
  SysUtils;

const
  CLeitorExtratoCartao_Versao = '0.0.1';

type
  TTipoOperadora = (extNenhum, extCielo, extRede, extSIPAG);

  TParcela = class;

  TListadeParcelas = class;

  TLeitorExtratoCartao = class;

  TOperadoraCartao = class
  private
    function GetNome: string;
  protected
    FOwner: TLeitorExtratoCartao;
    fNome: string;
    FShortDateFormat: string;
    fListadeParcelas: TListadeParcelas;
    procedure CarregaItem(const Alinha: string; ALista: TStrings;
      const QuoteChar: Char = '"'; Delimiter: Char = ';'); virtual;
    function StrToData(const AText: string): TDateTime; virtual;
    function StringToFloat(const AText: string): Extended; virtual;
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    function CriarParcelaNaLista: TParcela; virtual;
    function Parcelas: TListadeParcelas;
    procedure LerExtrato(const ANomeArq: string); virtual;
    function ValidaArquivo(AExtrato: TStrings): Integer; virtual;
    property Nome: string read GetNome;
  end;

  TParcela = class
  private
    fDataVenda: TDateTime;
    fDataPrevista: TDateTime;
    fDescricao: string;
    fNumeroCartao: string;
    fTID: string;
    fNsuDoc: string;
    fCodAutorizacao: string;
    fValorBruto: Extended;
    fValorLiquido: Extended;
    FValorDesconto: Extended;
    fNumParcelas: string;
    fTipoTransacao: string;
  public
    constructor Create;
    property DataVenda: TDateTime read fDataVenda write fDataVenda;
    property DataPrevista: TDateTime read fDataPrevista write fDataPrevista;
    property Descricao: string read fDescricao write fDescricao;
    property TipoTransacao: string read fTipoTransacao write fTipoTransacao;
    property NumeroCartao: string read fNumeroCartao write fNumeroCartao;
    property NsuDoc: string read fNsuDoc write fNsuDoc;
    property NumParcelas: string read fNumParcelas write fNumParcelas;
    property CodAutorizacao: string read fCodAutorizacao write fCodAutorizacao;
    property ValorBruto: Extended read fValorBruto write fValorBruto;
    property ValorDesconto: Extended read FValorDesconto write FValorDesconto;
    property ValorLiquido: Extended read fValorLiquido write fValorLiquido;
  end;

  TListadeParcelas = class(TObjectList<TParcela>);

  TLeitorExtratoCartao = class
  private
    FOperadora: TOperadoraCartao;
    FTipoOperadora: TTipoOperadora;
    function GetAbout: string;
    procedure setTipoOperadora(const Value: TTipoOperadora);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LerArquivo(const ANomeArq: string);
    function Operadora: TOperadoraCartao;
    property About: string read GetAbout;
    property TipoOperadora: TTipoOperadora read FTipoOperadora
      write setTipoOperadora;
  end;

const
  TipoConciliacaoStr: array [TTipoOperadora] of string = ('extNenhum',
    'extCielo', 'extRede', 'extSIPAG');

resourcestring
  SFUNCAO_NAO_IMPLEMENTADA =
    'Função %s não implementada %s Para a operadora %s';
  SLAYOUT_ARQUIVO_NAO_DEFINIDO = 'Layout do arquivo não definido';
  SINFORMAR_NOME_ARQ_CONCILICAO =
    'Nome do arquivo de extrato do cartão deve ser informado';
  SNOME_ARQ_NAO_ENCONTRADO = 'Arquivo %s não encontrado: %s%s';

implementation

uses
  LeitorExtratoCartaoCielo,
  LeitorExtratoCartaoRede,
  LeitorExtratoCartaoSIPAG;

{ TLeitorExtratoCartao }

constructor TLeitorExtratoCartao.Create;
begin
  inherited Create;
  TipoOperadora := extNenhum;
end;

destructor TLeitorExtratoCartao.Destroy;
begin
  if Assigned(FOperadora) then
    FOperadora.Free;
  inherited Destroy;
end;

function TLeitorExtratoCartao.GetAbout: string;
begin
  Result := 'LeitorExtratoCartao Ver: ' + CLeitorExtratoCartao_Versao;
end;

procedure TLeitorExtratoCartao.LerArquivo(const ANomeArq: string);
begin
  FOperadora.LerExtrato(ANomeArq);
end;

function TLeitorExtratoCartao.Operadora: TOperadoraCartao;
begin
  Result := FOperadora;
end;

procedure TLeitorExtratoCartao.setTipoOperadora(const Value: TTipoOperadora);
begin
  if FTipoOperadora = Value then
    Exit;
  FOperadora.Free;
  case Value of
    extCielo:
      FOperadora := TLeitorExtratoCartaoCielo.Create(Self);
    extRede:
      FOperadora := TLeitorExtratoCartaoRede.Create(Self);
    extSIPAG:
      FOperadora := TLeitorExtratoCartaoSIPAG.Create(Self);
  else
    FOperadora := TOperadoraCartao.Create(Self);
  end;
  FTipoOperadora := Value;
end;

{ TOperadoraCartao }

constructor TOperadoraCartao.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create;
  fListadeParcelas := TListadeParcelas.Create(True);
  FShortDateFormat := 'dd/MM/yyyy';
  FOwner := AOwner;
end;

function TOperadoraCartao.StrToData(const AText: string): TDateTime;
var
  VStings: TFormatSettings;
begin
  VStings := FormatSettings;
  VStings.ShortDateFormat := FShortDateFormat;
  Result := StrToDateDef(Trim(AText), 0, VStings);
end;

procedure TOperadoraCartao.CarregaItem(const Alinha: string; ALista: TStrings;
  const QuoteChar: Char; Delimiter: Char);
var
  P, P1: PChar;
  S: string;
begin
  ALista.BeginUpdate;
  try
    ALista.Clear;
    P := PChar(Alinha);

    while P^ <> #0 do
    begin
      if P^ = QuoteChar then
        S := AnsiExtractQuotedStr(P, QuoteChar)
      else
      begin
        P1 := P;
        while (P^ <> #0) and (P^ <> Delimiter) do
{$IFDEF MSWINDOWS}
          P := CharNext(P);
{$ELSE}
          Inc(P);
{$ENDIF}
        SetString(S, P1, P - P1);
      end;
      ALista.Add(S);

      if P^ = Delimiter then
      begin
        P1 := P;

{$IFDEF MSWINDOWS}
        if CharNext(P1)^ = #0 then
{$ELSE}
        Inc(P1);
        if P1^ = #0 then
{$ENDIF}
          ALista.Add('');

        repeat
{$IFDEF MSWINDOWS}
          P := CharNext(P);
{$ELSE}
          Inc(P);
{$ENDIF}
        until not(CharInSet(P^, [#1 .. ' ']));
      end;
    end;
  finally
    ALista.EndUpdate;
  end;
end;

function TOperadoraCartao.GetNome: string;
begin
  Result := fNome;
end;

function TOperadoraCartao.StringToFloat(const AText: string): Extended;
begin
  Result := StrToFloatDef(Trim(AText.Replace('R$ ', '')), 0);
end;

function TOperadoraCartao.CriarParcelaNaLista: TParcela;
begin
  Result := fListadeParcelas[fListadeParcelas.Add(TParcela.Create)];
end;

procedure TOperadoraCartao.LerExtrato(const ANomeArq: string);
begin
  fListadeParcelas.Clear;

  if ANomeArq = '' then
    raise Exception.CreateRes(@SINFORMAR_NOME_ARQ_CONCILICAO);

  if not TFile.Exists(ANomeArq) then
    raise Exception.CreateResFmt(@SNOME_ARQ_NAO_ENCONTRADO,
      [sLineBreak, ANomeArq]);

end;

function TOperadoraCartao.Parcelas: TListadeParcelas;
begin
  Result := fListadeParcelas;
end;

function TOperadoraCartao.ValidaArquivo(AExtrato: TStrings): Integer;
begin
  Result := 0;
end;

{ TParcela }

constructor TParcela.Create;
begin
  inherited Create;
  fDataVenda := 0;
  fDataPrevista := 0;
  fDescricao := '';
  fNumeroCartao := '';
  fTID := '';
  fNsuDoc := '';
  fCodAutorizacao := '';
  fValorBruto := 0;
  fValorLiquido := 0;
  FValorDesconto := 0;
  fNumParcelas := '';
  fTipoTransacao := '';
end;

end.
