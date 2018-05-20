object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Leitor de arquivo de extrato do cart'#227'o...'
  ClientHeight = 365
  ClientWidth = 876
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
    Left = 8
    Top = 127
    Width = 905
    Height = 230
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
    Width = 876
    Height = 121
    Align = alTop
    Caption = ' Informe '
    TabOrder = 0
    DesignSize = (
      876
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
      Width = 605
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object btAbrir: TBitBtn
      Left = 619
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
      090100009619E0BD010000001800000009000000000003000000090109446174
      6156656E646108000800000000000D5469706F5472616E736163616F01004900
      00000100055749445448020002001E000944657363726963616F010049000000
      01000557494454480200020032000C4E756D65726F43617274616F0100490000
      000100055749445448020002001400064E7375446F6301004900000001000557
      49445448020002000F000E436F644175746F72697A6163616F01004900000001
      00055749445448020002000F000A56616C6F72427275746F0800040000000000
      0D56616C6F72446573636F6E746F08000400000000000C56616C6F724C697175
      69646F08000400000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'DataVenda'
        DataType = ftDateTime
      end
      item
        Name = 'TipoTransacao'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Descricao'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'NumeroCartao'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'NsuDoc'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'CodAutorizacao'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'ValorBruto'
        DataType = ftFloat
      end
      item
        Name = 'ValorDesconto'
        DataType = ftFloat
      end
      item
        Name = 'ValorLiquido'
        DataType = ftFloat
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 224
    Top = 224
    object cdsParcelasDataVenda: TDateTimeField
      DisplayWidth = 13
      FieldName = 'DataVenda'
    end
    object cdsParcelasTipoTransacao: TStringField
      DisplayWidth = 13
      FieldName = 'TipoTransacao'
      Size = 30
    end
    object cdsParcelasDescricao: TStringField
      DisplayWidth = 31
      FieldName = 'Descricao'
      Size = 50
    end
    object cdsParcelasNumeroCartao: TStringField
      DisplayWidth = 17
      FieldName = 'NumeroCartao'
    end
    object cdsParcelasNsuDoc: TStringField
      DisplayWidth = 11
      FieldName = 'NsuDoc'
      Size = 15
    end
    object cdsParcelasCodAutorizacao: TStringField
      DisplayLabel = 'Autoriza'#231#227'o'
      DisplayWidth = 12
      FieldName = 'CodAutorizacao'
      Size = 15
    end
    object cdsParcelasValorBruto: TFloatField
      DisplayWidth = 11
      FieldName = 'ValorBruto'
    end
    object cdsParcelasValorDesconto: TFloatField
      DisplayWidth = 11
      FieldName = 'ValorDesconto'
    end
    object cdsParcelasValorLiquido: TFloatField
      DisplayWidth = 12
      FieldName = 'ValorLiquido'
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
