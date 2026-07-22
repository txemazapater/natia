object FrameAutomations: TFrameAutomations
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
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 8
      Width = 120
      Height = 20
      Caption = 'Automatizaciones'
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 32
      Width = 200
      Height = 15
      Caption = 'subtitle'
    end
  end
  object pnlFlows: TPanel
    Left = 0
    Top = 56
    Width = 200
    Height = 544
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object lblFlows: TLabel
      Left = 12
      Top = 12
      Width = 40
      Height = 15
      Caption = 'Flujos'
    end
    object lstFlows: TListBox
      Left = 0
      Top = 36
      Width = 200
      Height = 508
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      ItemHeight = 18
      TabOrder = 0
    end
  end
  object pnlCanvas: TPanel
    Left = 200
    Top = 56
    Width = 700
    Height = 544
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblCanvasHint: TLabel
      Left = 16
      Top = 12
      Width = 300
      Height = 15
      Caption = 'Lienzo'
    end
    object shpTrigger: TShape
      Left = 40
      Top = 80
      Width = 110
      Height = 64
    end
    object lblTrigger: TLabel
      Left = 52
      Top = 96
      Width = 80
      Height = 32
      Alignment = taCenter
      AutoSize = False
      Caption = 'Trigger'
    end
    object shpLine1: TShape
      Left = 150
      Top = 108
      Width = 40
      Height = 4
    end
    object shpAgent: TShape
      Left = 200
      Top = 80
      Width = 110
      Height = 64
    end
    object lblAgent: TLabel
      Left = 212
      Top = 96
      Width = 80
      Height = 32
      Alignment = taCenter
      AutoSize = False
      Caption = 'Agente'
    end
    object shpLine2: TShape
      Left = 310
      Top = 108
      Width = 40
      Height = 4
    end
    object shpNemo: TShape
      Left = 360
      Top = 80
      Width = 110
      Height = 64
    end
    object lblNemo: TLabel
      Left = 372
      Top = 96
      Width = 80
      Height = 32
      Alignment = taCenter
      AutoSize = False
      Caption = 'NEMO'
    end
    object shpLine3: TShape
      Left = 470
      Top = 108
      Width = 40
      Height = 4
    end
    object shpNotify: TShape
      Left = 520
      Top = 80
      Width = 110
      Height = 64
    end
    object lblNotify: TLabel
      Left = 532
      Top = 96
      Width = 80
      Height = 32
      Alignment = taCenter
      AutoSize = False
      Caption = 'Notify'
    end
  end
end
