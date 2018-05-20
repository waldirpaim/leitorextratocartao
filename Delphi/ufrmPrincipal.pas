unit ufrmPrincipal;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.DBGrids,
  LeitorExtratoCartao,
  Data.DB,
  Vcl.Grids,
  Datasnap.DBClient;

type
  TFrmPrincipal = class(TForm)
    DBGrid1: TDBGrid;
    cdsParcelas: TClientDataSet;
    cdsParcelasDataVenda: TDateTimeField;
    cdsParcelasDescricao: TStringField;
    cdsParcelasNumeroCartao: TStringField;
    cdsParcelasNsuDoc: TStringField;
    cdsParcelasCodAutorizacao: TStringField;
    cdsParcelasValorBruto: TFloatField;
    cdsParcelasValorLiquido: TFloatField;
    cdsParcelasValorDesconto: TFloatField;
    cdsParcelasTipoTransacao: TStringField;
    cdsParcelasnumsequencia: TIntegerField;
    cdsParcelaspercentualdesconto: TFloatField;
    dsParcelas: TDataSource;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edArquivo: TEdit;
    btAbrir: TBitBtn;
    OpenDialog1: TOpenDialog;
    cbConciliacao: TComboBox;
    Label2: TLabel;
    procedure btAbrirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.btAbrirClick(Sender: TObject);
var
  VParcela: TParcelaCartao;
  VLeitor: TLeitorExtratoCartao;
begin
  if OpenDialog1.Execute then
  begin
    edArquivo.Text := OpenDialog1.FileName;
    if not cdsParcelas.Active then
    begin
      cdsParcelas.CreateDataSet;
      cdsParcelas.Active := True;
    end;
    cdsParcelas.EmptyDataSet;
    VLeitor := TLeitorExtratoCartao.Create;
    cdsParcelas.DisableControls;
    try
      VLeitor.TipoOperadora := TTipoOperadora(cbConciliacao.ItemIndex);
      VLeitor.LerArquivo(edArquivo.Text);
      for VParcela in VLeitor.Operadora.Parcelas do
      begin
        cdsParcelas.Append;
        cdsParcelasnumsequencia.Value := VParcela.numsequencia;
        cdsParcelasDataVenda.Value := VParcela.DataVenda;
        cdsParcelasDescricao.AsString := VParcela.Descricao;
        cdsParcelasTipoTransacao.AsString := VParcela.TipoTransacao;
        cdsParcelasNumeroCartao.AsString := VParcela.NumeroCartao;
        cdsParcelasNsuDoc.AsString := VParcela.NsuDoc;
        cdsParcelasCodAutorizacao.AsString := VParcela.CodAutorizacao;
        cdsParcelasValorBruto.AsFloat := VParcela.ValorBruto;
        cdsParcelasValorDesconto.AsFloat := VParcela.ValorDesconto;
        cdsParcelasValorLiquido.AsFloat := VParcela.ValorLiquido;
        cdsParcelaspercentualdesconto.AsFloat := VParcela.percentualdesconto;
        cdsParcelas.Post;
      end;
      cdsParcelas.First;
    finally
      VLeitor.Free;
      cdsParcelas.EnableControls;
    end;
  end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
var
  S: string;
begin
  cbConciliacao.Clear;
  for S in TipoConciliacaoStr do
    cbConciliacao.Items.Add(S);
  cbConciliacao.ItemIndex := 1;
  cbConciliacao.SetFocus;
end;

end.

