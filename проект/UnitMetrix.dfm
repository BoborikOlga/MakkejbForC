object FormMetrix: TFormMetrix
  Left = 277
  Top = 105
  Align = alCustom
  BorderStyle = bsSingle
  Caption = #1052#1077#1090#1088#1080#1082#1072' '#1055#1088#1086#1075#1088#1072#1084#1084#1084#1085#1086#1075#1086' '#1082#1086#1076#1072' ('#1057#1080')'
  ClientHeight = 476
  ClientWidth = 829
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object PCMetrix: TPageControl
    Left = 0
    Top = 0
    Width = 825
    Height = 473
    ActivePage = TShCode
    TabOrder = 0
    object TShCode: TTabSheet
      Caption = #1050#1086#1076' ('#1057#1080')'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      object LCode: TLabel
        Left = 32
        Top = 16
        Width = 119
        Height = 15
        Caption = #1040#1085#1072#1083#1080#1079#1080#1088#1091#1077#1084#1099#1081' '#1082#1086#1076':'
        Color = clNavy
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LRowsCount: TLabel
        Left = 32
        Top = 408
        Width = 131
        Height = 17
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1088#1086#1082':'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object MemoCode: TMemo
        Left = 32
        Top = 40
        Width = 465
        Height = 353
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnKeyPress = MemoCodeKeyPress
      end
      object GBChekedAction: TGroupBox
        Left = 536
        Top = 32
        Width = 265
        Height = 361
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object BOpenCode: TButton
          Left = 56
          Top = 80
          Width = 161
          Height = 33
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BOpenCodeClick
        end
        object BCorrectCode: TButton
          Left = 56
          Top = 144
          Width = 161
          Height = 33
          Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1082#1086#1076
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = BCorrectCodeClick
        end
        object BMcMetrix: TButton
          Left = 56
          Top = 216
          Width = 161
          Height = 33
          Caption = #1052#1077#1090#1088#1080#1082#1072' '#1052#1072#1082#1082#1077#1081#1073#1072
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = BMakMetrixClick
        end
      end
      object EditRowsCount: TEdit
        Left = 184
        Top = 408
        Width = 201
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
    object TShMak: TTabSheet
      Caption = #1052#1077#1090#1088#1080#1082#1072' '#1052#1072#1082#1082#1077#1081#1073#1072
      ImageIndex = 1
      object LOperatorsMap: TLabel
        Left = 376
        Top = 8
        Width = 114
        Height = 19
        Caption = #1050#1072#1088#1090#1072' '#1086#1087#1077#1088#1072#1090#1086#1088#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LMc_CabeNumber: TLabel
        Left = 40
        Top = 192
        Width = 222
        Height = 19
        Caption = #1062#1080#1082#1083#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1095#1080#1089#1083#1086' '#1052#1072#1082#1082#1077#1081#1073#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LArcsCount: TLabel
        Left = 40
        Top = 64
        Width = 61
        Height = 16
        Caption = #1063#1080#1089#1083#1086' '#1076#1091#1075
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LTopsCount: TLabel
        Left = 40
        Top = 128
        Width = 84
        Height = 16
        Caption = #1063#1080#1089#1083#1086' '#1074#1077#1088#1096#1080#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Comic Sans MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object MemoMcCabe: TMemo
        Left = 376
        Top = 32
        Width = 345
        Height = 385
        Lines.Strings = (
          '')
        ReadOnly = True
        TabOrder = 0
      end
      object EditCiclomatic: TEdit
        Left = 40
        Top = 216
        Width = 177
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object EditArcsCount: TEdit
        Left = 40
        Top = 88
        Width = 121
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object EditTopsCount: TEdit
        Left = 40
        Top = 152
        Width = 121
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
    end
  end
  object OpenDlgCode: TOpenDialog
    Filter = #1090#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt|'#1082#1086#1076' '#1089#1080'|*.c'
    Left = 240
    Top = 32
  end
end
