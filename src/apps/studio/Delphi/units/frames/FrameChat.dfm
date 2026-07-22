object FrameChat: TFrameChat
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
  object pnlChatLeft: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 600
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lblConversations: TLabel
      Left = 12
      Top = 12
      Width = 100
      Height = 15
      Caption = 'Conversaciones'
    end
    object lstConversations: TListBox
      Left = 0
      Top = 36
      Width = 220
      Height = 564
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      ItemHeight = 18
      TabOrder = 0
    end
  end
  object pnlChatMain: TPanel
    Left = 220
    Top = 0
    Width = 680
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlChatHeader: TPanel
      Left = 0
      Top = 0
      Width = 680
      Height = 72
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblChatTitle: TLabel
        Left = 16
        Top = 10
        Width = 120
        Height = 18
        Caption = 'Chat'
      end
      object lblChatMeta: TLabel
        Left = 16
        Top = 32
        Width = 200
        Height = 15
        Caption = 'meta'
      end
      object cmbAgent: TComboBox
        Left = 400
        Top = 12
        Width = 120
        Height = 23
        Style = csDropDownList
        TabOrder = 0
      end
      object cmbContext: TComboBox
        Left = 530
        Top = 12
        Width = 130
        Height = 23
        Style = csDropDownList
        TabOrder = 1
      end
      object pnlQuickActions: TPanel
        Left = 8
        Top = 48
        Width = 400
        Height = 24
        BevelOuter = bvNone
        TabOrder = 2
        object btnQASummarize: TButton
          Left = 0
          Top = 0
          Width = 80
          Height = 22
          Caption = 'Resumir'
          TabOrder = 0
        end
        object btnQAPromote: TButton
          Left = 88
          Top = 0
          Width = 120
          Height = 22
          Caption = 'Promover'
          TabOrder = 1
        end
        object btnQAExport: TButton
          Left = 216
          Top = 0
          Width = 80
          Height = 22
          Caption = 'Exportar'
          TabOrder = 2
        end
      end
    end
    object memTranscript: TMemo
      Left = 0
      Top = 72
      Width = 680
      Height = 360
      Align = alClient
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object pnlComposer: TPanel
      Left = 0
      Top = 432
      Width = 680
      Height = 168
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object memPrompt: TMemo
        Left = 12
        Top = 8
        Width = 656
        Height = 88
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object btnSend: TButton
        Left = 580
        Top = 104
        Width = 88
        Height = 28
        Anchors = [akTop, akRight]
        Caption = 'Enviar'
        TabOrder = 1
      end
      object btnAttach: TButton
        Left = 12
        Top = 104
        Width = 88
        Height = 28
        Caption = 'Adjuntar'
        TabOrder = 2
      end
      object btnTools: TButton
        Left = 108
        Top = 104
        Width = 100
        Height = 28
        Caption = 'Herramientas'
        TabOrder = 3
      end
      object lblTokens: TLabel
        Left = 12
        Top = 140
        Width = 120
        Height = 15
        Caption = 'Tokens'
      end
      object lblLatency: TLabel
        Left = 220
        Top = 140
        Width = 120
        Height = 15
        Caption = 'Latency'
      end
    end
  end
end
