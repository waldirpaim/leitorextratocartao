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
  TTipoOperadora = (extNenhum, extCielo, extRede, extSIPAG, extSODEXO);

  TParcelaCartao = class;

  TListaDeParcelas = class;

  TLeitorExtratoCartao = class;

  TOperadoraCartao = class
  private
    function GetNome: string;
    function IncluirParcela(const ALinha: string; ATemplate: TStrings): Boolean;
  protected
    FOwner: TLeitorExtratoCartao;
    fNome: string;
    FShortDateFormat: string;
    FListaDeParcelas: TListaDeParcelas;
    procedure ProcessaTemplate(ARetorno: TStrings; ATemplate: TStrings); virtual;
    function ColunaStr(ALinha: TArray<string>; const APosicao: string; Aquote: string): string;
    function ColunaData(ALinha: TArray<string>; const APosicao: string; Aquote: string): TDateTime;
    function ColunaFloat(ALinha: TArray<string>; const APosicao: string; Aquote: string): Extended;
  public
    constructor Create(AOwner: TLeitorExtratoCartao);
    destructor Destroy; override;
    function CriarParcelaNaLista: TParcelaCartao; virtual;
    function Parcelas: TListaDeParcelas;
    procedure LerExtrato(const ANomeArq: string); virtual;
    function ValidaArquivo(AExtrato: TStrings): Integer; virtual;
    property Nome: string read GetNome;
  end;

  TParcelaCartao = class(TPersistent)
  private
    fdatavenda: TDateTime;
    fvalorbruto: Extended;
    fnumerocartao: string;
    fvalordesconto: Extended;
    fcodautorizacao: string;
    fdescricao: string;
    fnumsequencia: Integer;
    fnsudoc: string;
    ftipotransacao: string;
    fvalorliquido: Extended;
    fdataprevista: TDateTime;
    fnumparcelas: string;
  public
    constructor Create;
    procedure Clear;
    function percentualdesconto: Extended;
  published
    property numsequencia: Integer read fnumsequencia write fnumsequencia;
    property datavenda: TDateTime read fdatavenda write fdatavenda;
    property dataprevista: TDateTime read fdataprevista write fdataprevista;
    property descricao: string read fdescricao write fdescricao;
    property tipotransacao: string read ftipotransacao write ftipotransacao;
    property numerocartao: string read fnumerocartao write fnumerocartao;
    property nsudoc: string read fnsudoc write fnsudoc;
    property numparcelas: string read fnumparcelas write fnumparcelas;
    property codautorizacao: string read fcodautorizacao write fcodautorizacao;
    property valorbruto: Extended read fvalorbruto write fvalorbruto;
    property valordesconto: Extended read fvalordesconto write fvalordesconto;
    property valorliquido: Extended read fvalorliquido write fvalorliquido;
  end;

  TListaDeParcelas = class(TObjectList<TParcelaCartao>);

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
    property TipoOperadora: TTipoOperadora read FTipoOperadora write setTipoOperadora;
  end;

const
  TipoConciliacaoStr: array[TTipoOperadora] of string = ('extNenhum', 'extCielo',
    'extRede', 'extSIPAG', 'extSODEXO');

resourcestring
  SFUNCAO_NAO_IMPLEMENTADA = 'Função %s não implementada %sPara a operadora %s';
  SINFORMAR_NOME_ARQ_CONCILICAO = 'Nome do arquivo de extrato do cartão deve ser informado';
  SNOME_ARQ_NAO_ENCONTRADO = 'Arquivo %s não encontrado: %s%s';
  SARQUIVO_FORA_FORMATO = 'Arquivo %s não está no formato esperado.';
  SOPERADORA_NAO_DEFINIDA = 'Você deve selecionar a operadora antes de ler o arquivo';
  STEMPLATE_NAO_INFORMADO = 'Você deve informar o template do arquivo antes de processar o extrato';

implementation

uses
  LeitorExtratoCartaoCielo,
  LeitorExtratoCartaoRede,
  LeitorExtratoCartaoSODEXO,
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
  if not Assigned(FOperadora) then
    raise Exception.CreateRes(@SOPERADORA_NAO_DEFINIDA);
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
    extSODEXO:
      FOperadora := TLeitorExtratoCartaoSODEXO.Create(Self);
  else
    FOperadora := TOperadoraCartao.Create(Self);
  end;
  FTipoOperadora := Value;
end;

{ TOperadoraCartao }

constructor TOperadoraCartao.Create(AOwner: TLeitorExtratoCartao);
begin
  inherited Create;
  FListaDeParcelas := TListaDeParcelas.Create(True);
  FShortDateFormat := 'dd/MM/yyyy';
  FOwner := AOwner;
end;

function TOperadoraCartao.GetNome: string;
begin
  Result := fNome;
end;

function TOperadoraCartao.CriarParcelaNaLista: TParcelaCartao;
begin
  Result := FListaDeParcelas[FListaDeParcelas.Add(TParcelaCartao.Create)];
  Result.numsequencia := FListaDeParcelas.Count;
end;

destructor TOperadoraCartao.Destroy;
begin
  FListaDeParcelas.Free;
  inherited Destroy;
end;

procedure TOperadoraCartao.LerExtrato(const ANomeArq: string);
begin
  FListaDeParcelas.Clear;
  if ANomeArq = '' then
    raise Exception.CreateRes(@SINFORMAR_NOME_ARQ_CONCILICAO);
  if not TFile.Exists(ANomeArq) then
    raise Exception.CreateResFmt(@SNOME_ARQ_NAO_ENCONTRADO, [sLineBreak, ANomeArq]);
end;

function TOperadoraCartao.Parcelas: TListaDeParcelas;
begin
  Result := FListaDeParcelas;
end;

function TOperadoraCartao.ColunaStr(ALinha: TArray<string>; const APosicao:
  string; Aquote: string): string;

  procedure AddStr(var S: string; AText: string);
  begin
    if S = '' then
      S := AText
    else
      S := S + ' ' + AText;
  end;

var
  VPosicao: TArray<string>;
  I: Integer;
  VPos: Integer;
begin
  VPosicao := APosicao.Split(['|']);
  Result := '';
  for I := Low(VPosicao) to High(VPosicao) do
  begin
    VPos := StrToIntDef(VPosicao[I], -1);
    if (VPos < 0) or (VPos > Length(ALinha)) then
      Exit('');
    AddStr(Result, ALinha[VPos].Replace(Aquote, ''));
  end;
end;

function TOperadoraCartao.ColunaFloat(ALinha: TArray<string>; const APosicao:
  string; Aquote: string): Extended;
var
  VColuna: string;
begin
  VColuna := ColunaStr(ALinha, APosicao, Aquote).Replace('R$', '');
  if VColuna.contains(',') and VColuna.contains('.') then
    VColuna := VColuna.Replace('.', '');
  Result := StrToFloatDef(VColuna.Replace(' ', '', [rfReplaceAll]), 0);
end;

function TOperadoraCartao.ColunaData(ALinha: TArray<string>; const APosicao:
  string; Aquote: string): TDateTime;
var
  VStings: TFormatSettings;
begin
  VStings := FormatSettings;
  VStings.ShortDateFormat := FShortDateFormat;
  Result := StrToDateDef(Trim(ColunaStr(ALinha, APosicao, Aquote)), 0, VStings);
end;

function Posicao(ATemplate: TStrings; const AName: string; const ADef: string = ''): string;
var
  VIndex: Integer;
begin
  VIndex := ATemplate.IndexOfName(AName);
  if VIndex = -1 then
    Exit(ADef);
  Result := ATemplate.ValueFromIndex[VIndex];
end;

function TOperadoraCartao.IncluirParcela(const ALinha: string; ATemplate: TStrings): Boolean;
var
  VSeparador: TArray<string>;
  VLinha: TArray<string>;
  VQuote: Char;
  VParcela: TParcelaCartao;
begin
  VSeparador := Posicao(ATemplate, 'separador').Split(['|']);
  VQuote := Posicao(ATemplate, 'quote', '"')[1];
  VLinha := ALinha.Split(VSeparador, VQuote);

  VParcela := CriarParcelaNaLista;

  with VParcela do
  begin
    Result := True;
    datavenda := ColunaData(VLinha, Posicao(ATemplate, 'datavenda'), VQuote);
    dataprevista := ColunaData(VLinha, Posicao(ATemplate, 'dataprevista'), VQuote);
    tipotransacao := ColunaStr(VLinha, Posicao(ATemplate, 'tipotransacao'), VQuote);
    descricao := ColunaStr(VLinha, Posicao(ATemplate, 'descricao'), VQuote);
    numerocartao := ColunaStr(VLinha, Posicao(ATemplate, 'numerocartao'), VQuote);
    nsudoc := ColunaStr(VLinha, Posicao(ATemplate, 'nsudoc'), VQuote);
    codautorizacao := ColunaStr(VLinha, Posicao(ATemplate, 'codautorizacao'), VQuote);
    valorbruto := ColunaFloat(VLinha, Posicao(ATemplate, 'valorbruto'), VQuote);
    valorliquido := ColunaFloat(VLinha, Posicao(ATemplate, 'valorliquido'), VQuote);
    if valorliquido = 0 then
      valorliquido := valorbruto;
    valordesconto := ColunaFloat(VLinha, Posicao(ATemplate, 'valordesconto'), VQuote);
    if valordesconto = 0 then
      valordesconto := valorbruto - valorliquido;
    numparcelas := ColunaStr(VLinha, Posicao(ATemplate, 'numparcelas'), VQuote);
  end;
  if SameText(fNome, 'SODEXO') and (VParcela.codautorizacao = '') and (VParcela.nsudoc
    = '') and (VParcela.datavenda = 0) then
  begin
    Result := False;
    FListaDeParcelas.Remove(VParcela);
  end;
end;

procedure TOperadoraCartao.ProcessaTemplate(ARetorno: TStrings; ATemplate: TStrings);
var
  VLinhaIni: Integer;
  VLinhaFim: Integer;
  I: Integer;
begin
  if not Assigned(ATemplate) then
    raise Exception.CreateRes(@STEMPLATE_NAO_INFORMADO);
  VLinhaIni := StrToIntDef(Posicao(ATemplate, 'linhainicial'), 1);
  VLinhaFim := StrToIntDef(Posicao(ATemplate, 'qtdregistros'), -1);
  if VLinhaFim = -1 then
    VLinhaFim := Pred(ARetorno.Count);
  for I := VLinhaIni to VLinhaFim do
    if not IncluirParcela(ARetorno[I], ATemplate) then
      Exit;
end;

function TOperadoraCartao.ValidaArquivo(AExtrato: TStrings): Integer;
begin
  Result := 0;
end;

{ TParcela }

procedure TParcelaCartao.Clear;
begin
  fdatavenda := 0;
  fvalorbruto := 0;
  fnumerocartao := '';
  fvalordesconto := 0;
  fcodautorizacao := '';
  fdescricao := '';
  fnumsequencia := 0;
  fnsudoc := '';
  ftipotransacao := '';
  fvalorliquido := 0;
  fdataprevista := 0;
  fnumparcelas := '';
end;

constructor TParcelaCartao.Create;
begin
  inherited Create;
  Clear;
end;

function TParcelaCartao.percentualdesconto: Extended;
begin
  if (fvalorbruto = 0) then
    Exit(0);
  Result := (fvalordesconto / fvalorbruto) * 100;
end;

end.

