object FrameVisualAssets: TFrameVisualAssets
  Left = 0
  Top = 0
  Width = 900
  Height = 640
  TabOrder = 0
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 10
      Width = 200
      Height = 19
      Caption = 'Visual Asset Registry'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 34
      Width = 700
      Height = 15
      Caption = 'phosphor:// logical icons'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlControls: TPanel
    Left = 0
    Top = 64
    Width = 900
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblWeight: TLabel
      Left = 16
      Top = 14
      Width = 32
      Height = 15
      Caption = 'Peso'
    end
    object cmbWeight: TComboBox
      Left = 56
      Top = 10
      Width = 110
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbWeightChange
    end
    object lblSize: TLabel
      Left = 184
      Top = 14
      Width = 40
      Height = 15
      Caption = 'Tama'#241'o'
    end
    object cmbSize: TComboBox
      Left = 236
      Top = 10
      Width = 70
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cmbSizeChange
    end
    object btnResolveTwice: TButton
      Left = 328
      Top = 8
      Width = 140
      Height = 28
      Caption = 'Resolver x2'
      TabOrder = 2
      OnClick = btnResolveTwiceClick
    end
    object btnFallbackTest: TButton
      Left = 480
      Top = 8
      Width = 130
      Height = 28
      Caption = 'Probar fallback'
      TabOrder = 3
      OnClick = btnFallbackTestClick
    end
  end
  object pnlDiag: TPanel
    Left = 0
    Top = 480
    Width = 900
    Height = 160
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object memDiag: TMemo
      Left = 0
      Top = 0
      Width = 900
      Height = 160
      Align = alClient
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object scrollGallery: TScrollBox
    Left = 0
    Top = 108
    Width = 900
    Height = 372
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 3
  end
end
