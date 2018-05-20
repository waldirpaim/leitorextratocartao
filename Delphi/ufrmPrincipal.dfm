object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Leitor de arquivo de extrato do cart'#227'o...'
  ClientHeight = 365
  ClientWidth = 944
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 121
    Width = 944
    Height = 244
    Align = alClient
    DataSource = dsParcelas
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 944
    Height = 121
    Align = alTop
    Caption = ' Informe '
    TabOrder = 0
    ExplicitWidth = 876
    DesignSize = (
      944
      121)
    object Label1: TLabel
      Left = 8
      Top = 67
      Width = 82
      Height = 13
      Caption = 'Nome do Arquivo'
      Color = clBtnFace
      ParentColor = False
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 74
      Height = 13
      Caption = 'Tipo do Extrato'
      Color = clBtnFace
      ParentColor = False
    end
    object edArquivo: TEdit
      Left = 8
      Top = 83
      Width = 673
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 605
    end
    object btAbrir: TBitBtn
      Left = 687
      Top = 81
      Width = 99
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Abrir'
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00000000FFFF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00001808FF086531FF000400FFFF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00001808FF39A66BFF6BEBB5FF39925AFF000800FFFF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00001800FF31A263FF39E39CFF18DB8CFF52E7ADFF398E5AFF000C
        00FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00001C00FF219E52FF29D78CFF18CF84FF18D384FF18D784FF42DF9CFF318A
        4AFF000C00FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00001C
        00FF109242FF18C773FF18C36BFF18C773FF18C77BFF18CB7BFF18CF7BFF29D7
        8CFF218642FF001000FFFF00FF00FF00FF00FF00FF00FF00FF00002400FF108E
        39FF18BA63FF18B663FF31C373FF42CB84FF42D38CFF4ACF8CFF39CB84FF29C7
        7BFF21CB7BFF108A39FF001800FFFF00FF00FF00FF00FF00FF00087129FF21B6
        5AFF52BE84FF73CF9CFF7BD7A5FF42BE7BFF107D42FF52CF94FF7BDBADFF73D7
        A5FF6BD39CFF42CB84FF108A31FF002000FFFF00FF00FF00FF00003010FF4AB2
        6BFF9CDBB5FF94DBB5FF42BA73FF003010FFFF00FF00084521FF5ACF8CFF9CDF
        BDFF94DBB5FF94DBB5FF5ACB8CFF108A31FF002800FFFF00FF00FF00FF000020
        08FF52AE73FF42AA6BFF001C08FFFF00FF00FF00FF00FF00FF00003010FF5ABE
        84FFB5E7CEFFB5E3C6FFB5E3C6FF73CF9CFF108629FF002C00FFFF00FF00FF00
        FF00001800FF001400FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF000020
        08FF52AE73FFD6F3DEFFCEEBDEFFDEEFE7FF94DBADFF085D18FFFF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00001400FF529E63FFEFFFF7FFDEF7E7FF42965AFF001000FFFF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00000000FF428E52FF39864AFF000000FFFF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00000C00FF000C00FFFF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      TabOrder = 2
      OnClick = btAbrirClick
      ExplicitLeft = 619
    end
    object cbConciliacao: TComboBox
      Left = 8
      Top = 39
      Width = 229
      Height = 22
      Style = csOwnerDrawFixed
      TabOrder = 0
    end
  end
  object cdsParcelas: TClientDataSet
    PersistDataPacket.Data = {
      390100009619E0BD01000000180000000B00000000000300000039010C6E756D
      73657175656E6369610400010000000000096461746176656E64610800080000
      0000000D7469706F7472616E736163616F010049000000010005574944544802
      0002001E000964657363726963616F0100490000000100055749445448020002
      0032000C6E756D65726F63617274616F01004900000001000557494454480200
      02001400066E7375646F630100490000000100055749445448020002000F000E
      636F646175746F72697A6163616F010049000000010005574944544802000200
      0F000A76616C6F72627275746F08000400000000000D76616C6F72646573636F
      6E746F08000400000000000C76616C6F726C69717569646F0800040000000000
      1270657263656E7475616C646573636F6E746F08000400000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'numsequencia'
        DataType = ftInteger
      end
      item
        Name = 'datavenda'
        DataType = ftDateTime
      end
      item
        Name = 'tipotransacao'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'descricao'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'numerocartao'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'nsudoc'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'codautorizacao'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'valorbruto'
        DataType = ftFloat
      end
      item
        Name = 'valordesconto'
        DataType = ftFloat
      end
      item
        Name = 'valorliquido'
        DataType = ftFloat
      end
      item
        Name = 'percentualdesconto'
        DataType = ftFloat
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 224
    Top = 224
    object cdsParcelasnumsequencia: TIntegerField
      DisplayLabel = ' #'
      DisplayWidth = 5
      FieldName = 'numsequencia'
    end
    object cdsParcelasDataVenda: TDateTimeField
      DisplayLabel = 'Data Venda'
      DisplayWidth = 11
      FieldName = 'datavenda'
    end
    object cdsParcelasTipoTransacao: TStringField
      DisplayLabel = 'Transa'#231#227'o'
      DisplayWidth = 14
      FieldName = 'tipotransacao'
      Size = 30
    end
    object cdsParcelasDescricao: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      DisplayWidth = 28
      FieldName = 'descricao'
      Size = 50
    end
    object cdsParcelasNumeroCartao: TStringField
      DisplayLabel = 'N'#250'mero Cart'#227'o'
      DisplayWidth = 14
      FieldName = 'numerocartao'
    end
    object cdsParcelasNsuDoc: TStringField
      DisplayLabel = 'NSU'
      DisplayWidth = 11
      FieldName = 'nsudoc'
      Size = 15
    end
    object cdsParcelasCodAutorizacao: TStringField
      DisplayLabel = 'Autoriza'#231#227'o'
      DisplayWidth = 12
      FieldName = 'codautorizacao'
      Size = 15
    end
    object cdsParcelasValorBruto: TFloatField
      DisplayLabel = 'Valor Bruto'
      DisplayWidth = 11
      FieldName = 'valorbruto'
      DisplayFormat = '#,##0.00'
    end
    object cdsParcelasValorDesconto: TFloatField
      DisplayLabel = 'Desconto'
      DisplayWidth = 11
      FieldName = 'valordesconto'
      DisplayFormat = '#,##0.00'
    end
    object cdsParcelasValorLiquido: TFloatField
      DisplayLabel = 'Valor Liquido'
      DisplayWidth = 12
      FieldName = 'valorliquido'
      DisplayFormat = '#,##0.00'
    end
    object cdsParcelaspercentualdesconto: TFloatField
      DisplayLabel = 'Percentual'
      DisplayWidth = 10
      FieldName = 'percentualdesconto'
      DisplayFormat = '#,##0.000'
    end
  end
  object dsParcelas: TDataSource
    DataSet = cdsParcelas
    Left = 336
    Top = 216
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.csv'
    Filter = 'Arquivo|*.csv'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = 'Abrir arquivo'
    Left = 813
    Top = 32
  end
end
