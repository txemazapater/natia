object FrameTools: TFrameTools
  Left = 0
  Top = 0
  Width = 980
  Height = 720
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
    Width = 980
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 8
      Width = 100
      Height = 20
      Caption = 'Herramientas'
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 32
      Width = 200
      Height = 15
      Caption = 'subtitle'
    end
  end
  object scrollTools: TScrollBox
    Left = 0
    Top = 56
    Width = 980
    Height = 664
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    object pnlDocker: TPanel
      Left = 16
      Top = 16
      Width = 220
      Height = 120
      TabOrder = 0
      object lblDocker: TLabel
        Left = 10
        Top = 8
        Width = 40
        Height = 15
        Caption = 'Docker'
      end
      object memDocker: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlGitHub: TPanel
      Left = 252
      Top = 16
      Width = 220
      Height = 120
      TabOrder = 1
      object lblGitHub: TLabel
        Left = 10
        Top = 8
        Width = 40
        Height = 15
        Caption = 'GitHub'
      end
      object memGitHub: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlSQL: TPanel
      Left = 488
      Top = 16
      Width = 220
      Height = 120
      TabOrder = 2
      object lblSQL: TLabel
        Left = 10
        Top = 8
        Width = 20
        Height = 15
        Caption = 'SQL'
      end
      object memSQL: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlOdoo: TPanel
      Left = 724
      Top = 16
      Width = 220
      Height = 120
      TabOrder = 3
      object lblOdoo: TLabel
        Left = 10
        Top = 8
        Width = 30
        Height = 15
        Caption = 'Odoo'
      end
      object memOdoo: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlGLPI: TPanel
      Left = 16
      Top = 152
      Width = 220
      Height = 120
      TabOrder = 4
      object lblGLPI: TLabel
        Left = 10
        Top = 8
        Width = 30
        Height = 15
        Caption = 'GLPI'
      end
      object memGLPI: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlPowerShell: TPanel
      Left = 252
      Top = 152
      Width = 220
      Height = 120
      TabOrder = 5
      object lblPowerShell: TLabel
        Left = 10
        Top = 8
        Width = 70
        Height = 15
        Caption = 'PowerShell'
      end
      object memPowerShell: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlPython: TPanel
      Left = 488
      Top = 152
      Width = 220
      Height = 120
      TabOrder = 6
      object lblPython: TLabel
        Left = 10
        Top = 8
        Width = 40
        Height = 15
        Caption = 'Python'
      end
      object memPython: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlMCP: TPanel
      Left = 724
      Top = 152
      Width = 220
      Height = 120
      TabOrder = 7
      object lblMCP: TLabel
        Left = 10
        Top = 8
        Width = 30
        Height = 15
        Caption = 'MCP'
      end
      object memMCP: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlOllama: TPanel
      Left = 16
      Top = 288
      Width = 220
      Height = 120
      TabOrder = 8
      object lblOllama: TLabel
        Left = 10
        Top = 8
        Width = 40
        Height = 15
        Caption = 'Ollama'
      end
      object memOllama: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlOpenAI: TPanel
      Left = 252
      Top = 288
      Width = 220
      Height = 120
      TabOrder = 9
      object lblOpenAI: TLabel
        Left = 10
        Top = 8
        Width = 40
        Height = 15
        Caption = 'OpenAI'
      end
      object memOpenAI: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlAzure: TPanel
      Left = 488
      Top = 288
      Width = 220
      Height = 120
      TabOrder = 10
      object lblAzure: TLabel
        Left = 10
        Top = 8
        Width = 30
        Height = 15
        Caption = 'Azure'
      end
      object memAzure: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlHA: TPanel
      Left = 724
      Top = 288
      Width = 220
      Height = 120
      TabOrder = 11
      object lblHA: TLabel
        Left = 10
        Top = 8
        Width = 90
        Height = 15
        Caption = 'Home Assistant'
      end
      object memHA: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnlNodeRED: TPanel
      Left = 16
      Top = 424
      Width = 220
      Height = 120
      TabOrder = 12
      object lblNodeRED: TLabel
        Left = 10
        Top = 8
        Width = 55
        Height = 15
        Caption = 'Node-RED'
      end
      object memNodeRED: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
    object pnln8n: TPanel
      Left = 252
      Top = 424
      Width = 220
      Height = 120
      TabOrder = 13
      object lbln8n: TLabel
        Left = 10
        Top = 8
        Width = 20
        Height = 15
        Caption = 'n8n'
      end
      object memn8n: TMemo
        Left = 8
        Top = 28
        Width = 200
        Height = 80
        TabOrder = 0
      end
    end
  end
end
