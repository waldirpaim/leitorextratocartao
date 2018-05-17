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
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Vcl.Grids;

type
  TFrmPrincipal = class(TForm)
    DBGrid1: TDBGrid;
    cdsParcelas: TFDMemTable;
    cdsParcelasDataVenda: TDateTimeField;
    cdsParcelasDescricao: TStringField;
    cdsParcelasNumeroCartao: TStringField;
    cdsParcelasNsuDoc: TStringField;
    cdsParcelasCodAutorizacao: TStringField;
    cdsParcelasValorBruto: TFloatField;
    cdsParcelasValorLiquido: TFloatField;
    cdsParcelasValorDesconto: TFloatField;
    cdsParcelasTipoTransacao: TStringField;
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
  VParcela: TParcela;
  VConcilia: TLeitorExtratoCartao;
begin
  if OpenDialog1.Execute then
  begin
    edArquivo.Text := OpenDialog1.FileName;
    if not cdsParcelas.Active then
      cdsParcelas.Active := True;
    cdsParcelas.EmptyDataSet;
    VConcilia := TLeitorExtratoCartao.Create;
    cdsParcelas.DisableControls;
    try
      VConcilia.TipoOperadora := TTipoOperadora(cbConciliacao.ItemIndex);
      VConcilia.LerArquivoOperadora(edArquivo.Text);
      for VParcela in VConcilia.Operadora.Parcelas do
      begin
        cdsParcelas.Append;
        cdsParcelasDataVenda.Value := VParcela.DataVenda;
        cdsParcelasDescricao.AsString := VParcela.Descricao;
        cdsParcelasTipoTransacao.AsString := VParcela.TipoTransacao;
        cdsParcelasNumeroCartao.AsString := VParcela.NumeroCartao;
        cdsParcelasNsuDoc.AsString := VParcela.NsuDoc;
        cdsParcelasCodAutorizacao.AsString := VParcela.CodAutorizacao;
        cdsParcelasValorBruto.AsFloat := VParcela.ValorBruto;
        cdsParcelasValorDesconto.AsFloat := VParcela.ValorDesconto;
        cdsParcelasValorLiquido.AsFloat := VParcela.ValorLiquido;
        cdsParcelas.Post;
      end;
      cdsParcelas.First;
    finally
      VConcilia.Free;
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
