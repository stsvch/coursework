object MenuForm: TMenuForm
  Left = 0
  Top = 0
  Align = alCustom
  AlphaBlendValue = 10
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  ClientHeight = 541
  ClientWidth = 636
  Color = clInfoText
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OpenButton: TButton
    Left = 248
    Top = 168
    Width = 161
    Height = 57
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1088#1086#1077#1082#1090
    TabOrder = 0
    OnClick = OpenButtonClick
  end
  object NewButton: TButton
    Left = 248
    Top = 320
    Width = 161
    Height = 57
    Caption = #1053#1086#1074#1099#1081' '#1087#1088#1086#1077#1082#1090
    TabOrder = 1
    OnClick = NewButtonClick
  end
end
