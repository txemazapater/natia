object FrameMarketplace: TFrameMarketplace
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
      Width = 90
      Height = 20
      Caption = 'Marketplace'
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 32
      Width = 200
      Height = 15
      Caption = 'subtitle'
    end
  end
  object pcMarket: TPageControl
    Left = 0
    Top = 56
    Width = 900
    Height = 544
    ActivePage = tsInstalled
    Align = alClient
    TabOrder = 1
    object tsInstalled: TTabSheet
      Caption = 'Instalados'
      object lstInstalled: TListView
        Left = 0
        Top = 0
        Width = 892
        Height = 516
        Align = alClient
        Columns = <
          item
            Caption = 'Plugin'
            Width = 280
          end
          item
            Caption = 'Versi'#243'n'
            Width = 120
          end
          item
            Caption = 'Categor'#237'a'
            Width = 160
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tsAvailable: TTabSheet
      Caption = 'Disponibles'
      object lstAvailable: TListView
        Left = 0
        Top = 0
        Width = 892
        Height = 516
        Align = alClient
        Columns = <
          item
            Caption = 'Plugin'
            Width = 280
          end
          item
            Caption = 'Versi'#243'n'
            Width = 120
          end
          item
            Caption = 'Categor'#237'a'
            Width = 160
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tsUpdates: TTabSheet
      Caption = 'Actualizaciones'
      object lstUpdates: TListView
        Left = 0
        Top = 0
        Width = 892
        Height = 516
        Align = alClient
        Columns = <
          item
            Caption = 'Plugin'
            Width = 280
          end
          item
            Caption = 'Cambio'
            Width = 200
          end
          item
            Caption = 'Estado'
            Width = 120
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
end
