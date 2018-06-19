object Form1: TForm1
  Left = 541
  Top = 177
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'OCR'
  ClientHeight = 410
  ClientWidth = 182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgBlurred: TImage
    Left = 1
    Top = 1
    Width = 120
    Height = 150
    Proportional = True
    OnMouseDown = ImageMouseDown
    OnMouseMove = ImageMouseMove
  end
  object Shape: TShape
    Left = 0
    Top = 0
    Width = 182
    Height = 227
    HelpType = htKeyword
  end
  object Image: TImage
    Left = 1
    Top = 1
    Width = 180
    Height = 225
    Proportional = True
    OnMouseDown = ImageMouseDown
    OnMouseMove = ImageMouseMove
  end
  object imgSmall: TImage
    Left = 130
    Top = 239
    Width = 36
    Height = 45
    Hint = #1578#1589#1608#1740#1585' '#1705#1608#1670#1705' '#1588#1583#1607
    ParentShowHint = False
    ShowHint = True
    Visible = False
  end
  object imgSmall2: TImage
    Left = 88
    Top = 239
    Width = 36
    Height = 45
    Hint = #1581#1585#1601' '#1608' '#1606#1602#1591#1607' '#1607#1575#1740' '#1580#1583#1575' '#1588#1583#1607
    ParentShowHint = False
    ShowHint = True
    Stretch = True
    Visible = False
  end
  object imgSmall3: TImage
    Left = 172
    Top = 239
    Width = 15
    Height = 15
    Hint = #1578#1589#1608#1740#1585' '#1576#1585#1575#1740' '#1588#1576#1705#1607' '#1593#1589#1576#1740
    ParentShowHint = False
    ShowHint = True
    Visible = False
  end
  object imgCut: TImage
    Left = 88
    Top = 290
    Width = 99
    Height = 89
    AutoSize = True
    Proportional = True
    Visible = False
  end
  object lblRecognized: TLabel
    Left = 46
    Top = 386
    Width = 128
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = #1581#1585#1601' '#1578#1588#1582#1740#1589' '#1583#1575#1583#1607' '#1588#1583#1607':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
  end
  object lblRecognized2: TLabel
    Left = 28
    Top = 387
    Width = 12
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '    '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
  end
  object btnClear: TButton
    Left = 49
    Top = 264
    Width = 75
    Height = 25
    Caption = #1662#1575#1705' '#1705#1585#1583#1606
    TabOrder = 0
    OnClick = btnClearClick
  end
  object btnNormalize: TButton
    Left = 49
    Top = 233
    Width = 75
    Height = 25
    HelpType = htKeyword
    Caption = #1578#1588#1582#1740#1589' '#1581#1585#1601
    TabOrder = 1
    OnClick = btnNormalizeClick
  end
  object btnSaveChar: TButton
    Left = 49
    Top = 295
    Width = 75
    Height = 25
    Hint = 
      #1584#1582#1740#1585#1607#8207#1740' '#1581#1585#1601' '#1583#1585' '#1605#1608#1575#1602#1593' '#1570#1605#1608#1586#1588' '#1588#1576#1705#1607#8207#1740' '#1593#1589#1576#1740' '#1575#1587#1578#1601#1575#1583#1607' '#1605#1740#8207#1588#1608#1583'. '#1575#1586' '#1705#1604#1740#1705' '#1705 +
      #1585#1583#1606' '#1585#1608#1740' '#1570#1606' '#1582#1608#1583#1583#1575#1585#1740' '#1601#1585#1605#1575#1740#1740#1583'.'
    Caption = #1584#1582#1740#1585#1607#8207#1740' '#1581#1585#1601
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnSaveCharClick
  end
  object opennvazn: TButton
    Left = 81
    Top = 326
    Width = 43
    Height = 25
    Hint = 
      #1740#1575#1583#1711#1740#1585#1740' '#1576#1585#1575#1740' '#1605#1608#1575#1602#1593' '#1570#1605#1608#1586#1588' '#1588#1576#1705#1607#8207#1740' '#1593#1589#1576#1740' '#1575#1587#1578'. '#1575#1586' '#1705#1604#1740#1705' '#1705#1585#1583#1606' '#1585#1608#1740' '#1570#1606' '#1582#1608 +
      #1583#1583#1575#1585#1740' '#1601#1585#1605#1575#1740#1740#1583'.'
    Caption = #1740#1575#1583#1711#1740#1585#1740
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = opennvaznClick
  end
  object edtChar: TEdit
    Left = 49
    Top = 328
    Width = 26
    Height = 21
    Hint = #1705#1575#1585#1575#1705#1578#1585' '#1576#1585#1575#1740' '#1584#1582#1740#1585#1607' '#1587#1575#1586#1740' '#1583#1585' '#1588#1576#1705#1607#8207#1740' '#1593#1589#1576#1740
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 386
    Width = 182
    Height = 24
    Align = alBottom
    Max = 1000
    Style = pbstMarquee
    Step = 1
    TabOrder = 5
    Visible = False
    ExplicitTop = 421
    ExplicitWidth = 187
  end
  object Button1: TButton
    Left = 49
    Top = 355
    Width = 75
    Height = 25
    Caption = #1583#1585#1576#1575#1585#1607
    TabOrder = 6
    OnClick = Button1Click
  end
end
