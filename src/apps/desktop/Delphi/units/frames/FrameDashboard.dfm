object FrameDashboard: TFrameDashboard
  Left = 0
  Top = 0
  Width = 900
  Height = 700
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
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 10
      Width = 55
      Height = 25
      Caption = 'Home'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 38
      Width = 320
      Height = 15
      Caption = 'Workspace operativo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object scrollCards: TScrollBox
    Left = 0
    Top = 64
    Width = 900
    Height = 636
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    object pnlCardRecentChats: TPanel
      Left = 16
      Top = 16
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 0
      object lblCardRecentChats: TLabel
        Left = 12
        Top = 10
        Width = 140
        Height = 15
        Caption = 'Conversaciones recientes'
      end
      object lstRecentChats: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardProjects: TPanel
      Left = 312
      Top = 16
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 1
      object lblCardProjects: TLabel
        Left = 12
        Top = 10
        Width = 110
        Height = 15
        Caption = 'Proyectos recientes'
      end
      object lstProjects: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardNemo: TPanel
      Left = 608
      Top = 16
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 2
      object lblCardNemo: TLabel
        Left = 12
        Top = 10
        Width = 100
        Height = 15
        Caption = 'Documentos NEMO'
      end
      object lstNemo: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardModels: TPanel
      Left = 16
      Top = 212
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 3
      object lblCardModels: TLabel
        Left = 12
        Top = 10
        Width = 110
        Height = 15
        Caption = 'Modelos instalados'
      end
      object lstModels: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardAgents: TPanel
      Left = 312
      Top = 212
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 4
      object lblCardAgents: TLabel
        Left = 12
        Top = 10
        Width = 110
        Height = 15
        Caption = 'Agentes disponibles'
      end
      object lstAgents: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardSystem: TPanel
      Left = 608
      Top = 212
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 5
      object lblCardSystem: TLabel
        Left = 12
        Top = 10
        Width = 100
        Height = 15
        Caption = 'Estado del sistema'
      end
      object memSystem: TMemo
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 0
      end
    end
    object pnlCardActivity: TPanel
      Left = 16
      Top = 408
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 6
      object lblCardActivity: TLabel
        Left = 12
        Top = 10
        Width = 100
        Height = 15
        Caption = 'Actividad reciente'
      end
      object lstActivity: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardTasks: TPanel
      Left = 312
      Top = 408
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 7
      object lblCardTasks: TLabel
        Left = 12
        Top = 10
        Width = 100
        Height = 15
        Caption = 'Tareas pendientes'
      end
      object lstTasks: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 132
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardNews: TPanel
      Left = 608
      Top = 408
      Width = 280
      Height = 180
      BevelOuter = bvNone
      TabOrder = 8
      object lblCardNews: TLabel
        Left = 12
        Top = 10
        Width = 70
        Height = 15
        Caption = 'Noticias IA'
      end
      object lstNews: TListBox
        Left = 12
        Top = 32
        Width = 256
        Height = 100
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
    object pnlCardUpdates: TPanel
      Left = 16
      Top = 604
      Width = 872
      Height = 100
      BevelOuter = bvNone
      TabOrder = 9
      object lblCardUpdates: TLabel
        Left = 12
        Top = 10
        Width = 90
        Height = 15
        Caption = 'Actualizaciones'
      end
      object lstUpdates: TListBox
        Left = 12
        Top = 32
        Width = 848
        Height = 56
        BorderStyle = bsNone
        ItemHeight = 16
        TabOrder = 0
      end
    end
  end
end
