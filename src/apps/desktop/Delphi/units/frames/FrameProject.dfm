object FrameProject: TFrameProject
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
  object pnlProjectHeader: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblProjectName: TLabel
      Left = 16
      Top = 10
      Width = 120
      Height = 20
      Caption = 'Proyecto'
    end
    object lblProjectMeta: TLabel
      Left = 16
      Top = 36
      Width = 200
      Height = 15
      Caption = 'meta'
    end
  end
  object pcProject: TPageControl
    Left = 0
    Top = 64
    Width = 900
    Height = 536
    ActivePage = tsOverview
    Align = alClient
    TabOrder = 1
    object tsOverview: TTabSheet
      Caption = 'Resumen'
      object memOverview: TMemo
        Left = 0
        Top = 0
        Width = 892
        Height = 508
        Align = alClient
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsGit: TTabSheet
      Caption = 'Repositorio'
      object lblBranches: TLabel
        Left = 12
        Top = 8
        Width = 50
        Height = 15
        Caption = 'Ramas'
      end
      object lstBranches: TListBox
        Left = 12
        Top = 28
        Width = 200
        Height = 200
        ItemHeight = 15
        TabOrder = 0
      end
      object lblCommits: TLabel
        Left = 230
        Top = 8
        Width = 60
        Height = 15
        Caption = 'Commits'
      end
      object lstCommits: TListBox
        Left = 230
        Top = 28
        Width = 420
        Height = 200
        ItemHeight = 15
        TabOrder = 1
      end
      object lblPRs: TLabel
        Left = 12
        Top = 244
        Width = 80
        Height = 15
        Caption = 'Pull requests'
      end
      object lstPRs: TListBox
        Left = 12
        Top = 264
        Width = 638
        Height = 120
        ItemHeight = 15
        TabOrder = 2
      end
    end
    object tsTasks: TTabSheet
      Caption = 'Tareas'
      object lstTasks: TListBox
        Left = 0
        Top = 0
        Width = 892
        Height = 508
        Align = alClient
        BorderStyle = bsNone
        ItemHeight = 18
        TabOrder = 0
      end
    end
    object tsDocs: TTabSheet
      Caption = 'Documentaci'#243'n'
      object memDocs: TMemo
        Left = 0
        Top = 0
        Width = 892
        Height = 508
        Align = alClient
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsTerminal: TTabSheet
      Caption = 'Terminal'
      object memTerminal: TMemo
        Left = 0
        Top = 0
        Width = 892
        Height = 508
        Align = alClient
        BorderStyle = bsNone
        Color = 2105376
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12632256
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
end
