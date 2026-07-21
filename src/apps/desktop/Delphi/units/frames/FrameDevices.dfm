object FrameDevices: TFrameDevices
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
      Caption = 'Device Manager'
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 32
      Width = 200
      Height = 15
      Caption = 'subtitle'
    end
  end
  object lstDevices: TListView
    Left = 0
    Top = 56
    Width = 620
    Height = 544
    Align = alClient
    Columns = <
      item
        Caption = 'Dispositivo'
        Width = 160
      end
      item
        Caption = 'Tipo'
        Width = 100
      end
      item
        Caption = 'Estado'
        Width = 90
      end
      item
        Caption = 'Notas'
        Width = 220
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object pnlDetail: TPanel
    Left = 620
    Top = 56
    Width = 280
    Height = 544
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object lblDetailTitle: TLabel
      Left = 12
      Top = 12
      Width = 100
      Height = 15
      Caption = 'Detalle'
    end
    object memDetail: TMemo
      Left = 8
      Top = 36
      Width = 264
      Height = 400
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
