object frmTransfer: TfrmTransfer
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36801#31227#21161#25163
  ClientHeight = 248
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object lblWowAccountLabel: TLabel
    Left = 24
    Top = 25
    Width = 56
    Height = 17
    Caption = 'WoW'#36335#24452
  end
  object lblAccontList: TLabel
    Left = 32
    Top = 68
    Width = 48
    Height = 17
    Caption = #36873#25321#24080#21495
  end
  object lblOriginAccount: TLabel
    Left = 20
    Top = 111
    Width = 60
    Height = 17
    Caption = #36873#25321#26381#21153#22120
  end
  object lblOriginCharacter: TLabel
    Left = 258
    Top = 111
    Width = 48
    Height = 17
    Caption = #36873#25321#35282#33394
  end
  object edtWowAccountPath: TJvDirectoryEdit
    Left = 90
    Top = 23
    Width = 375
    Height = 24
    OnBeforeDialog = edtWowAccountPathBeforeDialog
    DialogKind = dkWin32
    DialogText = #35831#25351#23450'WoW'#36335#24452
    AutoCompleteOptions = [acoAutoSuggest, acoAutoAppend, acoUseTab, acoUpDownKeyDropsList, acoRTLReading]
    Flat = False
    ParentFlat = False
    DialogOptionsWin32 = [odOnlyDirectory, odStatusAvailable, odNewDialogStyle]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = ''
    OnExit = edtWowAccountPathExit
  end
  object lbledtNewRealm: TLabeledEdit
    Left = 90
    Top = 151
    Width = 116
    Height = 24
    EditLabel.Width = 60
    EditLabel.Height = 17
    EditLabel.Caption = #26032#26381#21153#22120#21517
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    LabelPosition = lpLeft
    LabelSpacing = 10
    ParentFont = False
    TabOrder = 1
    OnExit = lbledtNewRealmExit
  end
  object btnReplaceSubmit: TButton
    Left = 189
    Top = 192
    Width = 109
    Height = 33
    Caption = #36801#31227
    TabOrder = 2
    OnClick = btnReplaceSubmitClick
  end
  object cbbAccountsList: TComboBox
    Left = 90
    Top = 65
    Width = 116
    Height = 25
    Style = csDropDownList
    TabOrder = 3
    OnClick = cbbAccountsListClick
    Items.Strings = (
      #27979#35797'1'
      #27979#35797'2'
      #27979#35797'3')
  end
  object cbbOriginRealm: TComboBox
    Left = 90
    Top = 108
    Width = 116
    Height = 25
    Style = csDropDownList
    TabOrder = 4
    OnClick = cbbOriginRealmClick
  end
  object cbbOriginCharacter: TComboBox
    Left = 317
    Top = 108
    Width = 145
    Height = 25
    Style = csDropDownList
    TabOrder = 5
    OnClick = cbbOriginCharacterClick
  end
  object lbledtNewCharacterName: TLabeledEdit
    Left = 317
    Top = 150
    Width = 145
    Height = 25
    EditLabel.Width = 48
    EditLabel.Height = 17
    EditLabel.Caption = #26032#35282#33394#21517
    LabelPosition = lpLeft
    LabelSpacing = 10
    TabOrder = 6
    OnChange = lbledtNewCharacterNameChange
    OnExit = lbledtNewCharacterNameExit
  end
end
