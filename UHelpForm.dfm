object frmHelp: TfrmHelp
  Left = 280
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1058#1077#1083#1077#1092#1086#1085#1085#1072#1103' '#1082#1085#1080#1075#1072
  ClientHeight = 226
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 16
    Top = 32
    Width = 86
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072
  end
  object lbl2: TLabel
    Left = 16
    Top = 72
    Width = 22
    Height = 13
    Caption = #1048#1084#1103
  end
  object lbl3: TLabel
    Left = 8
    Top = 112
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
  end
  object edtNumber: TEdit
    Left = 128
    Top = 24
    Width = 289
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object edtPersonName: TEdit
    Left = 128
    Top = 64
    Width = 289
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object edtAdress: TEdit
    Left = 128
    Top = 104
    Width = 289
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 80
    Top = 168
    Width = 105
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 248
    Top = 168
    Width = 115
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
