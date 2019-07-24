object frmtest: Tfrmtest
  Left = 0
  Top = 0
  ClientHeight = 243
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnTest: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = 'btnTest'
    TabOrder = 0
    OnClick = btnTestClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.cue'
    Filter = 'cue|*.cue'
    Left = 48
    Top = 88
  end
end
