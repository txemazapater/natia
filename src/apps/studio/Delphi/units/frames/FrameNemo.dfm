object FrameNemo: TFrameNemo
  Left = 0
  Top = 0
  Width = 900
  Height = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlNemoTree: TPanel
    Left = 0
    Top = 0
    Width = 240
    Height = 600
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lblNemoTree: TLabel
      Left = 12
      Top = 10
      Width = 120
      Height = 15
      Caption = 'NEMO'
    end
    object edtSearch: TEdit
      Left = 12
      Top = 32
      Width = 216
      Height = 23
      TabOrder = 0
    end
    object treeNemo: TTreeView
      Left = 0
      Top = 64
      Width = 240
      Height = 536
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Indent = 19
      ReadOnly = True
      TabOrder = 1
    end
  end
  object pnlNemoDoc: TPanel
    Left = 240
    Top = 0
    Width = 460
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblDocTitle: TLabel
      Left = 16
      Top = 12
      Width = 200
      Height = 18
      Caption = 'Documento'
    end
    object lblDocMeta: TLabel
      Left = 16
      Top = 36
      Width = 200
      Height = 15
      Caption = 'meta'
    end
    object memDoc: TMemo
      Left = 0
      Top = 60
      Width = 460
      Height = 540
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlNemoMeta: TPanel
    Left = 700
    Top = 0
    Width = 200
    Height = 600
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object lblTags: TLabel
      Left = 12
      Top = 12
      Width = 50
      Height = 15
      Caption = 'Etiquetas'
    end
    object lstTags: TListBox
      Left = 8
      Top = 32
      Width = 184
      Height = 80
      BorderStyle = bsNone
      ItemHeight = 15
      TabOrder = 0
    end
    object lblLinks: TLabel
      Left = 12
      Top = 124
      Width = 60
      Height = 15
      Caption = 'Relaciones'
    end
    object lstLinks: TListBox
      Left = 8
      Top = 144
      Width = 184
      Height = 160
      BorderStyle = bsNone
      ItemHeight = 15
      TabOrder = 1
    end
    object lblRecent: TLabel
      Left = 12
      Top = 320
      Width = 80
      Height = 15
      Caption = 'Recientes'
    end
    object lstRecent: TListBox
      Left = 8
      Top = 340
      Width = 184
      Height = 120
      BorderStyle = bsNone
      ItemHeight = 15
      TabOrder = 2
    end
  end
end
