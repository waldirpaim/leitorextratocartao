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
    procedure ErroAbstract(const AError: string);
    function GetNome: string;
    procedure SetNome(const Value: string);
  protected
    FOwner: TLeitorExtratoCartao;
    fNome: string;
    FShortDateFormat: string;
    fListadeParcelas: TListadeParcelas;
    procedure CarregaItem(const Alinha: string; ALista: TStringList; const
      QuoteChar: Char = '"'; Delimiter: Char = ';'); virtual;
    function StrToData(const AText: string): TDateTime; virtual;
    function StringToFloat(const AText: string): Extended; virtual;
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    function CriarParcelaNaLista: TParcela; virtual;
    function Parcelas: TListadeParcelas;
    procedure LerArquivoOperadora(const ANomeArq: string); virtual;
    function ValidaArquivoOperadora(ARetorno: TStringList): Integer; virtual;
    property Nome: string read GetNome write SetNome stored False;
  end;

  { TParcela }

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
    property ValorLiquido: Extended read FValorLiquido write FValorLiquido;
  end;

  { TListadeParcelas }
  TListadeParcelas = class(TObjectList<TParcela>);

  TLeitorExtratoCartao = class(TComponent)
  private
    FOperadora: TOperadoraCartao;
    FTipoOperadora: TTipoOperadora;
    function GetAbout: string;
    procedure SetAbout(const AValue: string);
    procedure setTipoOperadora(const Value: TTipoOperadora);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LerArquivoOperadora(const ANomeArq: string);
    function Operadora: TOperadoraCartao;
    property TipoOperadora: TTipoOperadora read FTipoOperadora write setTipoOperadora;
  published
    property About: string read GetAbout write SetAbout stored False;
  end;

const
  TipoConciliacaoStr: array[TTipoOperadora] of string = ('extNenhum', 'extCielo',
    'extRede', 'extSIPAG');

resourcestring
  SFUNCAO_NAO_IMPLEMENTADA = 'Função %s não implementada %s Para a operadora %s';
  SAOWNER_DEVE_SER_DO_TIPO = 'Aowner deve ser do tipo TLeitorExtratoCartao';
  SLAYOUT_ARQUIVO_NAO_DEFINIDO = 'Layout do arquivo não definido';
  SSEM_DADOS_PROCESSAR = 'O Arquivo de extrato do cartão %s%s %s%s';
  SARQUIVO_VAZIO = 'Está vazio e não há dados para processar';
  SARQUIVO_INVALIDO = 'Está inválido';
  SARQUIVO_CONCILICAO = 'Arquivo de concicliação %s';
  SINFORMAR_NOME_ARQ_CONCILICAO = 'Nome do arquivo de extrato do cartão deve ser informado';
  SNOME_ARQ_NAO_ENCONTRADO = 'Arquivo %s não encontrado: %s%s';

implementation

uses
  LeitorExtratoCartaoCielo,
  LeitorExtratoCartaoRede,
  LeitorExtratoCartaoSIPAG;

procedure Register;
begin
  RegisterComponents('LeitorExtratoCartao', [TLeitorExtratoCartao]);
end;

{ TLeitorExtratoCartao }

constructor TLeitorExtratoCartao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
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

procedure TLeitorExtratoCartao.LerArquivoOperadora(const ANomeArq: string);
begin
  FOperadora.LerArquivoOperadora(ANomeArq);
end;

procedure TLeitorExtratoCartao.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

function TLeitorExtratoCartao.Operadora: TOperadoraCartao;
begin
  Result := FOperadora;
end;

procedure TLeitorExtratoCartao.SetAbout(const AValue: string);
begin
 {}
end;

procedure TLeitorExtratoCartao.setTipoOperadora(const Value: TTipoOperadora);
begin
  if FTipoOperadora = Value then
    Exit;
  FOperadora.Free;
  case Value of
    extCielo:
      FOperadora := TLeitorExtratoCartaoCielo.create(Self);
    extRede:
      FOperadora := TLeitorExtratoCartaoRede.create(Self);
    extSIPAG:
      FOperadora := TLeitorExtratoCartaoSIPAG.create(Self);
  else
    FOperadora := TOperadoraCartao.create(Self);
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

procedure TOperadoraCartao.CarregaItem(const Alinha: string; ALista: TStringList;
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
        until not (CharInSet(P^, [#1..' ']));
      end;
    end;
  finally
    ALista.EndUpdate;
  end;
end;

procedure TOperadoraCartao.SetNome(const Value: string);
begin
  fNome := Value;
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

procedure TOperadoraCartao.ErroAbstract(const AError: string);
begin
  raise Exception.CreateResFmt(@SFUNCAO_NAO_IMPLEMENTADA, [AError, fNome]);
end;

procedure TOperadoraCartao.LerArquivoOperadora(const ANomeArq: string);
begin
  fListadeParcelas.Clear;

  if ANomeArq = '' then
    raise Exception.CreateRes(@SINFORMAR_NOME_ARQ_CONCILICAO);

  if not TFile.Exists(ANomeArq) then
    raise Exception.CreateResFmt(@SNOME_ARQ_NAO_ENCONTRADO, [sLineBreak, ANomeArq]);

end;

function TOperadoraCartao.Parcelas: TListadeParcelas;
begin
  Result := fListadeParcelas;
end;

function TOperadoraCartao.ValidaArquivoOperadora(ARetorno: TStringList): Integer;
begin
  Result := 0;
  ErroAbstract('ValidaArquivoOperadora');
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

