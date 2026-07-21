object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'NATIA'
  ClientHeight = 820
  ClientWidth = 1400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object pnlChrome: TPanel
    Left = 0
    Top = 0
    Width = 1400
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblBrand: TLabel
      Left = 16
      Top = 10
      Width = 55
      Height = 21
      Caption = 'NATIA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblChromeTitle: TLabel
      Left = 80
      Top = 14
      Width = 160
      Height = 15
      Caption = 'Workspace'
    end
    object lblConnection: TLabel
      Left = 1188
      Top = 14
      Width = 70
      Height = 15
      Caption = 'Local Ready'
    end
    object shpConnection: TShape
      Left = 1170
      Top = 16
      Width = 12
      Height = 12
      Shape = stCircle
    end
    object lblAvatar: TLabel
      Left = 1288
      Top = 10
      Width = 28
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = 'TZ'
    end
    object lblSync: TLabel
      Left = 1040
      Top = 42
      Width = 70
      Height = 15
      Caption = 'Sync'
    end
    object btnNew: TSpeedButton
      Left = 16
      Top = 40
      Width = 56
      Height = 24
      Caption = 'Nuevo'
    end
    object btnSave: TSpeedButton
      Left = 76
      Top = 40
      Width = 64
      Height = 24
      Caption = 'Guardar'
    end
    object btnRun: TSpeedButton
      Left = 144
      Top = 40
      Width = 64
      Height = 24
      Caption = 'Ejecutar'
    end
    object edtGlobalSearch: TEdit
      Left = 280
      Top = 10
      Width = 320
      Height = 23
      TabOrder = 0
      TextHint = 'Buscar...'
    end
    object cmbProvider: TComboBox
      Left = 620
      Top = 10
      Width = 130
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object cmbModel: TComboBox
      Left = 760
      Top = 10
      Width = 140
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object cmbActiveAgent: TComboBox
      Left = 910
      Top = 10
      Width = 120
      Height = 23
      Style = csDropDownList
      TabOrder = 3
    end
    object btnQuickSettings: TSpeedButton
      Left = 1328
      Top = 8
      Width = 32
      Height = 28
      Caption = '...'
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 72
    Width = 1400
    Height = 720
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlNav: TPanel
      Left = 0
      Top = 0
      Width = 56
      Height = 720
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object btnNavToggle: TSpeedButton
        Left = 4
        Top = 6
        Width = 48
        Height = 28
        Caption = #171
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        OnClick = btnNavToggleClick
      end
      object btnNavHome: TSpeedButton
        Tag = 0
        Left = 4
        Top = 40
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Down = True
        Caption = 'Ho'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavWorkspace: TSpeedButton
        Tag = 1
        Left = 4
        Top = 76
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Ws'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavChats: TSpeedButton
        Tag = 2
        Left = 4
        Top = 112
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Ch'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavNemo: TSpeedButton
        Tag = 3
        Left = 4
        Top = 148
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Ne'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavProjects: TSpeedButton
        Tag = 4
        Left = 4
        Top = 184
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Pr'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavAgents: TSpeedButton
        Tag = 5
        Left = 4
        Top = 220
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Ag'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavTools: TSpeedButton
        Tag = 6
        Left = 4
        Top = 256
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'To'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavExtensions: TSpeedButton
        Tag = 7
        Left = 4
        Top = 292
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Ex'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavTasks: TSpeedButton
        Tag = 8
        Left = 4
        Top = 328
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Tk'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavNotifications: TSpeedButton
        Tag = 9
        Left = 4
        Top = 364
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'No'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavMarketplace: TSpeedButton
        Tag = 10
        Left = 4
        Top = 400
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Mk'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavDevices: TSpeedButton
        Tag = 11
        Left = 4
        Top = 436
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Dv'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavRemote: TSpeedButton
        Tag = 12
        Left = 4
        Top = 472
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Rm'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavAutomations: TSpeedButton
        Tag = 13
        Left = 4
        Top = 508
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Au'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNavClick
      end
      object btnNavSettings: TSpeedButton
        Tag = 14
        Left = 4
        Top = 640
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Se'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Anchors = [akLeft, akBottom]
        OnClick = btnNavClick
      end
      object btnNavHelp: TSpeedButton
        Tag = 15
        Left = 4
        Top = 676
        Width = 48
        Height = 36
        AllowAllUp = True
        GroupIndex = 1
        Caption = '?'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Anchors = [akLeft, akBottom]
        OnClick = btnNavClick
      end
    end
    object splNav: TSplitter
      Left = 56
      Top = 0
      Width = 4
      Height = 720
      Align = alLeft
      Color = clSilver
      ParentColor = False
    end
    object pnlExplorer: TPanel
      Left = 60
      Top = 0
      Width = 240
      Height = 720
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object lblExplorer: TLabel
        Left = 12
        Top = 10
        Width = 60
        Height = 15
        Caption = 'Explorer'
      end
      object treeExplorer: TTreeView
        Left = 0
        Top = 32
        Width = 240
        Height = 688
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Indent = 19
        ReadOnly = True
        TabOrder = 0
      end
    end
    object splExplorer: TSplitter
      Left = 300
      Top = 0
      Width = 4
      Height = 720
      Align = alLeft
    end
    object pnlCenter: TPanel
      Left = 304
      Top = 0
      Width = 836
      Height = 720
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object pnlWorkspaceChrome: TPanel
        Left = 0
        Top = 0
        Width = 836
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object pcWorkspaceTabs: TPageControl
          Left = 0
          Top = 0
          Width = 836
          Height = 28
          ActivePage = tsTabHome
          Align = alClient
          Style = tsButtons
          TabHeight = 24
          TabOrder = 0
          OnChange = pcWorkspaceTabsChange
          object tsTabHome: TTabSheet
            Caption = 'Home'
          end
          object tsTabChat: TTabSheet
            Caption = 'Chat'
          end
          object tsTabNemo: TTabSheet
            Caption = 'NEMO'
          end
          object tsTabProject: TTabSheet
            Caption = 'NATIA Core'
          end
        end
      end
      object pnlWorkspaceHost: TPanel
        Left = 0
        Top = 28
        Width = 836
        Height = 512
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        inline frameDashboard: TFrameDashboard
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameChat: TFrameChat
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameNemo: TFrameNemo
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameProject: TFrameProject
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameTools: TFrameTools
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameMarketplace: TFrameMarketplace
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameDevices: TFrameDevices
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
        inline frameAutomations: TFrameAutomations
          Left = 0
          Top = 0
          Width = 836
          Height = 512
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          Visible = False
          ExplicitWidth = 836
          ExplicitHeight = 512
        end
      end
      object splConsole: TSplitter
        Left = 0
        Top = 540
        Width = 836
        Height = 4
        Cursor = crVSplit
        Align = alBottom
      end
      object pnlConsole: TPanel
        Left = 0
        Top = 544
        Width = 836
        Height = 176
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object pcConsole: TPageControl
          Left = 0
          Top = 0
          Width = 836
          Height = 176
          ActivePage = tsTerminal
          Align = alClient
          TabOrder = 0
          object tsTerminal: TTabSheet
            Caption = 'Terminal'
            object memTerminal: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
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
          object tsPowerShell: TTabSheet
            Caption = 'PowerShell'
            object memPowerShell: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
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
          object tsLogs: TTabSheet
            Caption = 'Logs'
            object memLogs: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object tsOutput: TTabSheet
            Caption = 'Output'
            object memOutput: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object tsDebug: TTabSheet
            Caption = 'Debug'
            object memDebug: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object tsMCP: TTabSheet
            Caption = 'MCP'
            object memMCP: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object tsDocker: TTabSheet
            Caption = 'Docker'
            object memDocker: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object tsSQL: TTabSheet
            Caption = 'SQL'
            object memSQL: TMemo
              Left = 0
              Top = 0
              Width = 828
              Height = 148
              Align = alClient
              BorderStyle = bsNone
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
      end
    end
    object splInspector: TSplitter
      Left = 1140
      Top = 0
      Width = 4
      Height = 720
      Align = alRight
    end
    object pnlInspector: TPanel
      Left = 1144
      Top = 0
      Width = 256
      Height = 720
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 3
      object lblInspector: TLabel
        Left = 12
        Top = 10
        Width = 55
        Height = 15
        Caption = 'Inspector'
      end
      object pcInspector: TPageControl
        Left = 0
        Top = 32
        Width = 256
        Height = 688
        ActivePage = tsProps
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        object tsProps: TTabSheet
          Caption = 'Props'
          object memProps: TMemo
            Left = 0
            Top = 0
            Width = 248
            Height = 660
            Align = alClient
            BorderStyle = bsNone
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object tsActivity: TTabSheet
          Caption = 'Actividad'
          object lstActivity: TListBox
            Left = 0
            Top = 0
            Width = 248
            Height = 660
            Align = alClient
            BorderStyle = bsNone
            ItemHeight = 15
            TabOrder = 0
          end
        end
        object tsTimeline: TTabSheet
          Caption = 'Timeline'
          object memTimeline: TMemo
            Left = 0
            Top = 0
            Width = 248
            Height = 660
            Align = alClient
            BorderStyle = bsNone
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object tsAgent: TTabSheet
          Caption = 'Agente'
          object memAgent: TMemo
            Left = 0
            Top = 0
            Width = 248
            Height = 660
            Align = alClient
            BorderStyle = bsNone
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object tsModel: TTabSheet
          Caption = 'Modelo'
          object memModel: TMemo
            Left = 0
            Top = 0
            Width = 248
            Height = 660
            Align = alClient
            BorderStyle = bsNone
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object tsStats: TTabSheet
          Caption = 'Stats'
          object memStats: TMemo
            Left = 0
            Top = 0
            Width = 248
            Height = 660
            Align = alClient
            BorderStyle = bsNone
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
    end
  end
  object pnlStatus: TPanel
    Left = 0
    Top = 792
    Width = 1400
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblStatusModel: TLabel
      Left = 12
      Top = 6
      Width = 120
      Height = 15
      Caption = 'Modelo'
    end
    object lblStatusProvider: TLabel
      Left = 150
      Top = 6
      Width = 100
      Height = 15
      Caption = 'Proveedor'
    end
    object lblStatusCPU: TLabel
      Left = 280
      Top = 6
      Width = 50
      Height = 15
      Caption = 'CPU'
    end
    object lblStatusMem: TLabel
      Left = 350
      Top = 6
      Width = 60
      Height = 15
      Caption = 'Mem'
    end
    object lblStatusGPU: TLabel
      Left = 430
      Top = 6
      Width = 50
      Height = 15
      Caption = 'GPU'
    end
    object lblStatusConn: TLabel
      Left = 510
      Top = 6
      Width = 80
      Height = 15
      Caption = 'Conexi'#243'n'
    end
    object lblStatusTasks: TLabel
      Left = 620
      Top = 6
      Width = 60
      Height = 15
      Caption = 'Tareas'
    end
    object lblStatusAgents: TLabel
      Left = 700
      Top = 6
      Width = 70
      Height = 15
      Caption = 'Agentes'
    end
    object lblStatusNemo: TLabel
      Left = 790
      Top = 6
      Width = 70
      Height = 15
      Caption = 'NEMO'
    end
    object lblStatusNotify: TLabel
      Left = 880
      Top = 6
      Width = 60
      Height = 15
      Caption = 'Notif'
    end
    object lblStatusTime: TLabel
      Left = 1280
      Top = 6
      Width = 50
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '00:00:00'
    end
    object lblStatusUser: TLabel
      Left = 1180
      Top = 6
      Width = 70
      Height = 15
      Anchors = [akTop, akRight]
      Caption = 'Usuario'
    end
  end
  object mmMain: TMainMenu
    Left = 48
    Top = 16
    object miFile: TMenuItem
      Caption = '&Archivo'
      object miFileNew: TMenuItem
        Caption = '&Nuevo'
      end
      object miFileOpen: TMenuItem
        Caption = '&Abrir...'
      end
      object miFileSep1: TMenuItem
        Caption = '-'
      end
      object miFileExit: TMenuItem
        Caption = '&Salir'
        OnClick = miFileExitClick
      end
    end
    object miEdit: TMenuItem
      Caption = '&Editar'
    end
    object miView: TMenuItem
      Caption = '&Ver'
      object miViewExplorer: TMenuItem
        Caption = 'Explorer'
        Checked = True
        OnClick = miViewExplorerClick
      end
      object miViewInspector: TMenuItem
        Caption = 'Inspector'
        Checked = True
        OnClick = miViewInspectorClick
      end
      object miViewConsole: TMenuItem
        Caption = 'Consola'
        Checked = True
        OnClick = miViewConsoleClick
      end
      object miViewNav: TMenuItem
        Caption = 'Navegaci'#243'n'
        Checked = True
        OnClick = miViewNavClick
      end
    end
    object miWorkspace: TMenuItem
      Caption = '&Workspace'
    end
    object miTools: TMenuItem
      Caption = '&Herramientas'
    end
    object miHelp: TMenuItem
      Caption = 'A&yuda'
      object miHelpAbout: TMenuItem
        Caption = '&Acerca de NATIA...'
        OnClick = miHelpAboutClick
      end
    end
  end
  object tmrClock: TTimer
    Interval = 1000
    OnTimer = tmrClockTimer
    Left = 120
    Top = 16
  end
end
