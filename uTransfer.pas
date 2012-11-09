unit uTransfer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls,
  Vcl.Mask, JvExMask, JvToolEdit, System.IOUtils, System.Types,
  Vcl.Forms, Vcl.Dialogs, MetropolisUI.Tile, CnCommon, System.Win.Registry,
  JvBaseDlg, JvSelectDirectory, ShellAPI;

type
  TfrmTransfer = class(TForm)
    edtWowAccountPath: TJvDirectoryEdit;
    lbledtNewRealm: TLabeledEdit;
    btnReplaceSubmit: TButton;
    lblWowAccountLabel: TLabel;
    cbbAccountsList: TComboBox;
    lblAccontList: TLabel;
    cbbOriginRealm: TComboBox;
    lblOriginAccount: TLabel;
    cbbOriginCharacter: TComboBox;
    lblOriginCharacter: TLabel;
    lbledtNewCharacterName: TLabeledEdit;

    procedure FormCreate(Sender: TObject);
    procedure btnReplaceSubmitClick(Sender: TObject);
    procedure cbbAccountsListClick(Sender: TObject);
    procedure cbbOriginCharacterClick(Sender: TObject);
    procedure cbbOriginRealmClick(Sender: TObject);
    procedure edtWowAccountPathBeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure edtWowAccountPathExit(Sender: TObject);
    procedure lbledtNewCharacterNameExit(Sender: TObject);
    procedure lbledtNewRealmExit(Sender: TObject);
    procedure lbledtNewCharacterNameChange(Sender: TObject);

  private
    { Private declarations }
    sWowPath: string; // Wow安装路径
    sSelectedAccount: string; // 选择的帐号
    sOriginRealm, sOriginCharacter: string;
    sNewRealm, sNewCharacter: string;

    function _CopyFile(const sName, dName: string): Boolean;
    function GetWowPath: string;
    function ValidWowPath(sWowInstallPath: string): Boolean;
    procedure UpdateLuaConfigure(sPath: string);
    procedure UpdateAccountList;
    procedure UpdateOriginRealmsList;
    procedure UpdateOriginCharactersList;
  public
    { Public declarations }
  end;

var
  frmTransfer: TfrmTransfer;

implementation

{$R *.dfm}

// 复制文件或者目录
function TfrmTransfer._CopyFile(const sName, dName: string): Boolean;
var
  s1, s2: string;
  lpFileOp: TSHFileOpStruct;
begin
  s1 := PChar(sName) + #0#0;
  s2 := PChar(dName) + #0#0;
  with lpFileOp do
  begin
    Wnd := Application.Handle;
    wFunc := FO_COPY;
    pFrom := PChar(s1);
    pTo := PChar(s2);
    fFlags := 0;
    fAnyOperationsAborted := True;
  end;

  try
    Result := SHFileOperation(lpFileOp) = 0;
  except
    Result := False;
  end;
end;

{ -------------------------------------------------------------------------------
  过程名:    TfrmTransfer.GetWowPath
  作者:      wolftankk
  日期:      2012.11.09
  说明:	     获取Wow路径
  参数:      无
  返回值:    string
  ------------------------------------------------------------------------------- }
function TfrmTransfer.GetWowPath: string;
var
  Reg: TRegistry;
begin
  Result := EmptyStr;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SOFTWARE\Blizzard Entertainment\World of Warcraft', False)
    then
      Result := IncludeTrailingPathDelimiter
        (Trim(Reg.ReadString('InstallPath')));
    Reg.CloseKey;
  finally
    FreeAndNil(Reg);
  end;
end;

{ -------------------------------------------------------------------------------
  过程名:    TfrmTransfer.ValidWowPath
  作者:      wolftankk
  日期:      2012.11.09
  说明:	     验证WOW安装路径是否有效
  参数:      sWowInstallPath: string
  返回值:    Boolean
  ------------------------------------------------------------------------------- }
function TfrmTransfer.ValidWowPath(sWowInstallPath: string): Boolean;
begin
  Result := False;
  if DirectoryExists(sWowInstallPath) and
    FileExists(LinkPath(sWowInstallPath, 'Wow.exe')) then
  begin
    Result := True;
  end;
end;

{ -------------------------------------------------------------------------------
  过程名:    TfrmTransfer.UpdateAccountList
  作者:      wolftankk
  日期:      2012.11.09
  说明:	     获取WoW目录下所有帐号信息
  参数:      无
  返回值:    begin
  ------------------------------------------------------------------------------- }
procedure TfrmTransfer.UpdateAccountList;
var
  sAccountsPath: string;
  lAccountsList: TStringDynArray;
  sAccountPath: string;
  sAccount: string;
begin
  sAccountsPath := LinkPath(sWowPath, 'WTF\Account');
  cbbAccountsList.Items.Clear;
  lAccountsList := TDirectory.GetDirectories(sAccountsPath);
  for sAccountPath in lAccountsList do
  begin
    sAccount := sAccountPath.Substring(sAccountsPath.Length + 1);
    cbbAccountsList.Items.Add(sAccount);
  end;
  if cbbAccountsList.Items.Count > 0 then
  begin
    cbbAccountsList.ItemIndex := 0;
    sSelectedAccount := LinkPath(sAccountsPath, cbbAccountsList.Items[0]);
  end;
end;


procedure TfrmTransfer.UpdateOriginRealmsList;
var
  sRealmPath: string;
  sRealm: string;
  aRealmsList: TStringDynArray;
begin
  cbbOriginRealm.Items.Clear;
  cbbOriginCharacter.Items.Clear;
  if (not SameText(sSelectedAccount, EmptyStr)) then
  begin
    aRealmsList := TDirectory.GetDirectories(sSelectedAccount);
    for sRealmPath in aRealmsList do
    begin
      sRealm := sRealmPath.Substring(sSelectedAccount.Length + 1);
      if (not SameText(sRealm, 'SavedVariables')) then
      begin
        cbbOriginRealm.Items.Add(sRealm)
      end;
    end;

    if (cbbOriginRealm.Items.Count > 0) then
    begin
      cbbOriginRealm.ItemIndex := 0;
      sOriginRealm := cbbOriginRealm.Items[0];
      UpdateOriginCharactersList;
    end;
  end;
end;

procedure TfrmTransfer.UpdateOriginCharactersList;
var
  sPath: string;
  aCharactersList: TStringDynArray;
  sCharacterPath, sCharacter: string;
begin
  cbbOriginCharacter.Items.Clear;
  if (not SameText(sOriginRealm, EmptyStr)) then
  begin
    sPath := LinkPath(LinkPath(LinkPath(sWowPath, 'WTF\Account'),
      sSelectedAccount), sOriginRealm);
    aCharactersList := TDirectory.GetDirectories(sPath);
    for sCharacterPath in aCharactersList do
    begin
      sCharacter := sCharacterPath.Substring(sPath.Length + 1);
      cbbOriginCharacter.Items.Add(sCharacter);
    end;

    if (cbbOriginCharacter.Items.Count > 0) then
    begin
      cbbOriginCharacter.ItemIndex := 0;
      sOriginCharacter := cbbOriginCharacter.Items[0];

      lbledtNewCharacterName.Text := sOriginCharacter;
      sNewCharacter := sOriginCharacter;
    end;
  end;
end;

// 界面部分处理
procedure TfrmTransfer.FormCreate(Sender: TObject);
begin
  sWowPath := GetWowPath;
  edtWowAccountPath.Directory := sWowPath;
  if (ValidWowPath(sWowPath)) then
  begin
    // 获得所有帐号列表
    UpdateAccountList();
    // 获得所有服务器列表
    UpdateOriginRealmsList();
  end;
end;

procedure TfrmTransfer.edtWowAccountPathBeforeDialog(Sender: TObject;
  var AName: string; var AAction: Boolean);
begin
  edtWowAccountPath.InitialDir := AName;
end;

// 选择wow路径
procedure TfrmTransfer.edtWowAccountPathExit(Sender: TObject);
begin
  cbbAccountsList.Items.Clear;
  if ValidWowPath(edtWowAccountPath.Text) then
  begin
    sWowPath := edtWowAccountPath.Text;
    UpdateAccountList;
  end
  else
    ShowMessage('请指定WoW安装路径');

end;

// 选择帐号
procedure TfrmTransfer.cbbAccountsListClick(Sender: TObject);
begin
  sSelectedAccount := LinkPath(LinkPath(sWowPath, 'WTF\Account'),
    cbbAccountsList.Text);
  UpdateOriginRealmsList;
end;

procedure TfrmTransfer.cbbOriginRealmClick(Sender: TObject);
begin
  sOriginRealm := cbbOriginRealm.Text;
  UpdateOriginCharactersList;
end;

procedure TfrmTransfer.cbbOriginCharacterClick(Sender: TObject);
begin
  sOriginCharacter := cbbOriginCharacter.Text;

  sNewCharacter := sOriginCharacter;
  lbledtNewCharacterName.Text := sOriginCharacter;
end;

procedure TfrmTransfer.lbledtNewRealmExit(Sender: TObject);
begin
  sNewRealm := lbledtNewRealm.Text;
  if (SameText(sNewRealm, EmptyStr)) then
  begin
    ShowMessage('请输入新的服务器');
    Exit;
  end;
end;

procedure TfrmTransfer.lbledtNewCharacterNameChange(Sender: TObject);
begin
  sNewCharacter := lbledtNewCharacterName.Text;
end;

procedure TfrmTransfer.lbledtNewCharacterNameExit(Sender: TObject);
begin
  sNewCharacter := lbledtNewCharacterName.Text;
  if (SameText(sNewCharacter, EmptyStr)) then
  begin
    ShowMessage('请输入新的角色名');
    Exit;
  end;
end;

procedure TfrmTransfer.btnReplaceSubmitClick(Sender: TObject);
var
  sFullAccountPath: string;
  sGlobalSavedVariablesPath:string;

  sOriginRealmPath, sNewRealmPath: string;
  sOriginCharacterPath, sNewCharacterPath: string;
begin
  // 验证!
  if (SameText(sOriginRealm, EmptyStr)) then
  begin
    ShowMessage('请选择源服务器');
    Exit;
  end;

  if (SameText(sOriginCharacter, EmptyStr)) then
  begin
    ShowMessage('请选择源角色');
    Exit;
  end;

  if (SameText(sNewRealm, EmptyStr)) then
  begin
    ShowMessage('请输入目标服务器');
    Exit;
  end;

  if (SameText(sNewCharacter, EmptyStr)) then
  begin
    ShowMessage('请输入新角色名');
    Exit;
  end;

  Application.NormalizeTopMosts;
  if (Application.MessageBox('你确认开始迁移吗?', '确认框', MB_OKCANCEL) = 1) then
  begin
    sFullAccountPath := LinkPath(LinkPath(sWowPath, 'WTF/Account'),
      sSelectedAccount);

    sGlobalSavedVariablesPath:=LinkPath(sFullAccountPath, 'SavedVariables');

    sOriginRealmPath := LinkPath(sFullAccountPath, sOriginRealm);
    sNewRealmPath := LinkPath(sFullAccountPath, sNewRealm);

    sOriginCharacterPath := LinkPath(sOriginRealmPath, sOriginCharacter);
    sNewCharacterPath := LinkPath(sNewRealmPath, sNewCharacter);

    if (not SameText(sOriginRealmPath, sNewRealm)) then
    begin
      _CopyFile(sOriginRealmPath, sNewRealmPath);
    end;

    if (not SameText(sOriginCharacter, sNewCharacter)) then
    begin
      _CopyFile(sOriginCharacterPath, sNewCharacterPath);
    end;

    // 修改配置
    UpdateLuaConfigure(sNewCharacterPath);
    //备份
    _CopyFile(sGlobalSavedVariablesPath, LinkPath(sFullAccountPath, 'SavedVariables_backup'));
    UpdateLuaConfigure(sGlobalSavedVariablesPath);
  end;
  Application.RestoreTopMosts;

end;

procedure TfrmTransfer.UpdateLuaConfigure(sPath: string);
var
  FilesList: TStringDynArray;
  FileHandler: TStringList;
  sFile:string;
  i:Integer;
begin
  FilesList := TDirectory.GetFiles(sPath, '*.lua',
    TSearchOption.soAllDirectories);
  FileHandler := TStringList.Create;
  try
    for sFile in FilesList do
    begin
      FileHandler.LoadFromFile(sFile, TEncoding.UTF8);
      for i:=0 to FileHandler.Count - 1 do
      begin
        if (Pos(sOriginRealm, FileHandler[i]) > 0) or (Pos(sOriginCharacter, FileHandler[i]) > 0) then
        begin
          FileHandler[i]:=StringReplace(FileHandler[i], sOriginRealm, sNewRealm, [rfReplaceAll, rfIgnoreCase]);
          FileHandler[i]:=StringReplace(FileHandler[i], sOriginCharacter, sNewCharacter, [rfReplaceAll, rfIgnoreCase])
        end
      end;
      FileHandler.SaveToFile(sFile, TEncoding.UTF8);
    end;
  finally
    FreeAndNil(FileHandler);
  end;
end;

end.
