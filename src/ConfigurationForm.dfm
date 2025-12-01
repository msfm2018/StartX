object CfgForm: TCfgForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 569
  ClientWidth = 820
  Color = 16382715
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  TextHeight = 19
  object pnl_right: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 569
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object p1: TPanel
      Left = 0
      Top = 0
      Width = 820
      Height = 569
      Align = alClient
      BevelEdges = []
      BevelOuter = bvNone
      Caption = 'Talk'
      Color = clWhitesmoke
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 751
        Height = 569
        Align = alLeft
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnMouseEnter = ScrollBox1MouseEnter
        OnMouseLeave = ScrollBox1MouseLeave
      end
    end
    object pinfo: TPanel
      Left = 0
      Top = 0
      Width = 820
      Height = 569
      Align = alClient
      BevelEdges = []
      BevelOuter = bvNone
      Color = clWhitesmoke
      ParentBackground = False
      TabOrder = 1
      OnMouseDown = FormMouseDown
      DesignSize = (
        820
        569)
      object Label2: TLabel
        Left = 757
        Top = 3
        Width = 44
        Height = 29
        Cursor = crHandPoint
        Alignment = taCenter
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = #20851#38381
        Color = 31743
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = False
        OnClick = Label2Click
      end
      object ListView1: TListView
        Left = 1
        Top = 40
        Width = 818
        Height = 389
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWhitesmoke
        Columns = <>
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        RowSelect = True
        ParentFont = False
        ShowColumnHeaders = False
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = ListView1DblClick
        OnResize = ListView1Resize
      end
      object pbottom: TPanel
        Left = 0
        Top = 429
        Width = 820
        Height = 123
        Align = alBottom
        BevelEdges = [beTop]
        BevelOuter = bvNone
        Color = clSilver
        Padding.Left = 10
        Padding.Top = 10
        Padding.Right = 10
        Padding.Bottom = 10
        ParentBackground = False
        TabOrder = 2
        OnMouseDown = FormMouseDown
        object ComboBox1: TComboBox
          Left = 628
          Top = 44
          Width = 81
          Height = 22
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = #22270#26631#26679#24335'1'
          Items.Strings = (
            #22270#26631#26679#24335'1'
            #22270#26631#26679#24335'2')
        end
        object filedit: TLabeledEdit
          Left = 81
          Top = 78
          Width = 541
          Height = 22
          Hint = #21452#20987#28155#21152
          EditLabel.Width = 56
          EditLabel.Height = 22
          EditLabel.Caption = #25991#20214#36335#24452
          EditLabel.OnDblClick = fileditSubLabelDblClick
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = ''
          OnDblClick = fileditSubLabelDblClick
        end
        object imgEdit1: TLabeledEdit
          Left = 81
          Top = 11
          Width = 541
          Height = 22
          Hint = #21452#20987#28155#21152
          EditLabel.Width = 56
          EditLabel.Height = 22
          EditLabel.Caption = #36873#25321#22270#26631
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = ''
          OnDblClick = imgEdit1DblClick
        end
        object text_edit: TLabeledEdit
          Left = 81
          Top = 44
          Width = 208
          Height = 22
          Hint = #21452#20987#28155#21152
          EditLabel.Width = 56
          EditLabel.Height = 22
          EditLabel.Caption = #25991#23383#22270#26631
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          MaxLength = 16
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = ''
        end
        object tip: TLabeledEdit
          Left = 368
          Top = 44
          Width = 254
          Height = 22
          EditLabel.Width = 56
          EditLabel.Height = 22
          EditLabel.Caption = #25552#31034#25991#23383
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          LabelPosition = lpLeft
          ParentFont = False
          TabOrder = 4
          Text = ''
          TextHint = #26080
        end
        object CheckBox1: TCheckBox
          Left = 628
          Top = 14
          Width = 97
          Height = 17
          Caption = #36873#25321#22270#26631
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = CheckBox1Click
        end
        object Button1: TButton
          Left = 628
          Top = 75
          Width = 75
          Height = 25
          Caption = #28155#21152
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = Button1Click
        end
      end
      object p2: TPanel
        Left = 0
        Top = 552
        Width = 820
        Height = 17
        Align = alBottom
        BevelEdges = []
        BevelOuter = bvNone
        Color = clSilver
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -56
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        object Image2: TImage
          Left = 806
          Top = 0
          Width = 14
          Height = 17
          Cursor = crSizeNWSE
          Align = alRight
          AutoSize = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D494844520000000E0000
            000D080600000099DC5F7F000001394944415478DA63FCFFFF3F032960D9B265
            FF8F1F3FCEC0488AC6E52B57FF3F77E63483858505F11A419A0E1E38C0E0E1E9
            C110E0E7CB4894C659B366FD3F06749EB9B11E43664E2123488CA046909F0E1D
            3ECAA0AA24CD505C5A05D6B461D3E6FF78352E5AB8F0FF3EA0F38CF4B519F20A
            4A18614E3E76E4106E1B41366DDFBE83C1CADC10EEBCB56BD7FD3F71E20483AE
            8E36768D204DBB76EF46F1132C70EC6CAD19A2A2A23003071410E7CE5F64D052
            57843B0FECCF4387185495E5E0FE44D108B349574B15AE006CD3FEBD0C72B212
            0C55D50D60B1BD7BF72202079622B4D495509C070A086545398682A25278881E
            3D7C186223CCD3A014111C1C841210868606603F81C4B66EDBF6FFE489E30C2A
            CA2A0C8C4B972E05DBE4E0E008D7043275EFEE430CA6263A0C71F1F170E76DD8
            B001286602160300FA16C9E9B10252C70000000049454E44AE426082}
          OnMouseDown = Image2MouseDown
          ExplicitLeft = 736
        end
      end
    end
  end
end
