unit ConfigurationForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Math,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.ShellAPI, Vcl.ComCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, utils, u_json, System.IniFiles, Winapi.Dwmapi,
  Vcl.Imaging.pngimage, System.JSON, System.Generics.Collections, Vcl.Menus,
  ImgButton, winapi.UxTheme, ImgPanel, Vcl.Mask, System.Hash, System.ImageList,
  Vcl.ImgList, Vcl.Imaging.jpeg;

type
  TCfgForm = class(TForm)
    imgEdit1: TLabeledEdit;
    text_edit: TLabeledEdit;
    tip: TLabeledEdit;
    filedit: TLabeledEdit;
    ComboBox1: TComboBox;
    pinfo: TPanel;
    ScrollBox1: TScrollBox;
    pbottom: TPanel;
    CheckBox1: TCheckBox;
    ListView1: TListView;
    pnl_right: TPanel;
    p1: TPanel;
    p2: TPanel;
    Image2: TImage;
    Button1: TButton;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure imgEdit1DblClick(Sender: TObject);
    procedure rbtxtClick(Sender: TObject);
    procedure rbimgClick(Sender: TObject);
    procedure fileditSubLabelDblClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseEnter(Sender: TObject);
    procedure ScrollBox1MouseLeave(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1Resize(Sender: TObject);
    procedure btnorg_panelClick(Sender: TObject);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Label2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    file_map: TDictionary<string, string>;
    procedure AddFileInfoToJson(const Key, ImageFileName, FilePath, ToolTip: string);
    procedure ClearInputs;
    procedure PanelMouseEnter(Sender: TObject);
    procedure PanelMouseLeave(Sender: TObject);

    procedure PanelDblClick(Sender: TObject);
    procedure Buttoaction_translatoradd(Sender: TObject);
    procedure AdjustLastColumnWidth;
    procedure translateDblClick(Sender: TObject);
    procedure org_board_state;

  public
    FShadowAlpha: Byte; // 阴影透明度 (0-255)
    FShadowColor: TColor; // 阴影颜色


    close1: TImgButton;
  end;

  TStartMenuApp = record
    Name: string;
    Path: string;
  end;

var
  xchange: Boolean = false;
  FRoundWindow: Boolean = true;
  FShadowForm: tform;

var
  App: TStartMenuApp;

const
  PANEL_HEIGHT = 60;
  ICON_SIZE = 32;

implementation

{$R *.dfm}

uses
  core, System.UITypes, ApplicationMain;
     // 悬浮变色按钮



function SaveAppIconAsPng(const FilePath: string): string;
var
  Icon: TIcon;
  Bitmap: TBitmap;
  Png: TPngImage;
begin
  Icon := TIcon.Create;
  Bitmap := TBitmap.Create;
  Png := TPngImage.Create;
  try
    // 获取应
    Icon.Handle := ExtractIcon(HInstance, PChar(FilePath), 0);
    // 将图标转换为位图
    Bitmap.Width := Icon.Width;
    Bitmap.Height := Icon.Height;
    Bitmap.Canvas.Draw(0, 0, Icon);

    // 将位图转换为 PNG
    Png.Assign(Bitmap);

    // 保存为 PNG 文件
    result := ExtractFilePath(ParamStr(0)) + 'img\' + ChangeFileExt(ExtractFileName(FilePath), '.png');
    Png.SaveToFile(result);

  finally
    Icon.Free;
    Bitmap.Free;
    Png.Free;
  end;
end;

procedure TCfgForm.PanelDblClick(Sender: TObject);
var
  key1, key2: string;
  Hash, imgpath: string;
begin
  key1 := SaveAppIconAsPng(TImgPanel(Sender).extendB);

  key2 := TImgPanel(Sender).extendb;

  if (key1 <> '') and (key2 <> '') then
  begin
    g_core.utils.CopyFileToFolder(key1, ExtractFilePath(ParamStr(0)) + 'img');

    Hash := THashMD5.GetHashString(ExtractFileName(key1));
    imgpath := key1;

    if file_map.TryAdd(Hash, Format('%s,%s,%s', [ExtractFileName(key1), imgpath, TImgPanel(Sender).extendA])) then
    begin
      AddFileInfoToJson(Hash, ExtractFileName(key1), key2, TImgPanel(Sender).extendA);

      with ListView1.Items.Add do
      begin
        Caption := ExtractFileName(key1);  // 文件名
        SubItems.Add(Trim(TImgPanel(Sender).extendA));  // 工具提示
      end;

      ClearInputs;
    end;

    var p: timage;
    if not g_core.ImageCache.TryGetValue(ExtractFileName(key1), p) then
    begin
      p := TImage.Create(nil);
      p.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'img\' + ExtractFileName(key1));
      g_core.ImageCache.Add(ExtractFileName(key1), p);

    end

  end;

end;

procedure TCfgForm.translateDblClick(Sender: TObject);
begin
  if Sender is tlabel then
    TImgPanel(TLabel(Sender).Parent).OnDblClick(TLabel(Sender).Parent)
  else if Sender is TImage then
    TImgPanel(TImage(Sender).Parent).OnDblClick(TLabel(Sender).Parent);
end;

procedure TCfgForm.PanelMouseEnter(Sender: TObject);
begin
  (Sender as TImgPanel).color := $f5f5f5;

end;

procedure TCfgForm.PanelMouseLeave(Sender: TObject);
begin

  (Sender as TImgPanel).color := clBtnFace;

end;

procedure TCfgForm.Buttoaction_translatoradd(Sender: TObject);
var
  key1, key2, Hash, imgpath: string;
  utf8Text, ansi_path: PAnsiChar;
begin
  if CheckBox1.Checked then
  begin
    key1 := Trim(imgEdit1.Text);
    key2 := Trim(filedit.Text);
    if (key1 <> '') and (key2 <> '') then
    begin
      g_core.utils.CopyFileToFolder(key1, ExtractFilePath(ParamStr(0)) + 'img');

      Hash := THashMD5.GetHashString(ExtractFileName(key1));
      imgpath := ExtractFilePath(ParamStr(0)) + 'img\' + ExtractFileName(key1);

      if file_map.TryAdd(Hash, Format('%s,%s,%s', [ExtractFileName(key1), imgpath, Trim(tip.Text)])) then
      begin
        AddFileInfoToJson(Hash, ExtractFileName(key1), key2, tip.Text);


        // 使用 ListView 添加数据
        with ListView1.Items.Add do
        begin
          Caption := ExtractFileName(key1);  // 文件名
          SubItems.Add(Trim(tip.Text));       // 工具提示
        end;

        ClearInputs;
      end;

      var p: timage;
      if not g_core.ImageCache.TryGetValue(ExtractFileName(key1), p) then
      begin
        p := TImage.Create(nil);
        p.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'img\' + ExtractFileName(key1));
        g_core.ImageCache.Add(ExtractFileName(key1), p);

      end

    end;
  end
  else
  begin
    if (Trim(text_edit.Text) <> '') and (Trim(filedit.Text) <> '') then
    begin
      imgpath := ExtractFilePath(ParamStr(0)) + 'img\' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.png';

      utf8Text := PAnsiChar(UTF8Encode(Trim(text_edit.Text)));

      ansi_path := PAnsiChar(UTF8Encode(imgpath));
      if ComboBox1.Text = '图标样式1' then
        write_png_with_text(ansi_path, utf8Text, 2)
      else
        write_png_with_text(ansi_path, utf8Text, 1);

      key1 := ExtractFileName(imgpath);
      Hash := THashMD5.GetHashString(key1);

      if file_map.TryAdd(Hash, Format('%s,%s,%s', [key1, imgpath, Trim(tip.Text)])) then
      begin
        AddFileInfoToJson(Hash, key1, Trim(filedit.Text), tip.Text);

         // 使用 ListView 添加数据
        with ListView1.Items.Add do
        begin
          Caption := key1;  // 文件名
          SubItems.Add(Trim(tip.Text));  // 工具提示
        end;

        ClearInputs;
      end;

      var p: timage;
      if not g_core.ImageCache.TryGetValue(key1, p) then
      begin
        p := TImage.Create(nil);
        p.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'img\' + key1);
        g_core.ImageCache.Add(key1, p);

      end

    end;
  end;

end;

procedure TCfgForm.Button1Click(Sender: TObject);
begin
  Buttoaction_translatoradd(self);
end;

procedure TCfgForm.AddFileInfoToJson(const Key, ImageFileName, FilePath, ToolTip: string);
begin
  add_json(Key, ImageFileName, FilePath, ToolTip, True, nil);
end;

procedure TCfgForm.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    text_edit.Enabled := false;
    imgEdit1.Enabled := True;
  end
  else
  begin
    text_edit.Enabled := True;
    imgEdit1.Enabled := false;
  end;
end;

procedure TCfgForm.ClearInputs;
begin
  imgEdit1.Text := '';
  text_edit.Text := '';
  tip.Text := '';
  filedit.Text := '';
  xchange := True;
end;

procedure TCfgForm.fileditSubLabelDblClick(Sender: TObject);
var
  OpenDlg: TFileOpenDialog;
begin
  OpenDlg := TFileOpenDialog.Create(nil);
  try
    if OpenDlg.Execute then
    begin
      filedit.Text := OpenDlg.FileName;
    end;
  finally
    OpenDlg.Free;
  end;
end;

procedure TCfgForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form1.node_rebuilder(Screen.WorkAreaHeight);
  FreeAndNil(close1);
  g_core.nodes.is_configuring := false;
  file_map.Free;
end;

procedure EnableAcrylicOrMica(AHandle: HWND);
var
  accent: DWORD;
//  gradientColor: DWORD;
begin
  // Windows 11 Mica（优先）
  if (Win32MajorVersion >= 10) and (Win32BuildNumber >= 22000) then
  begin
    // Mica 效果（Win11 最佳）
    DwmSetWindowAttribute(AHandle, 38, PWideChar(2), SizeOf(Integer)); // DWMWA_SYSTEMBACKDROP_TYPE = 38
    Exit;
  end;

  // Windows 10 Acrylic（回退）
  accent := 2; // 2 = DWMA_USE_IMMERSIVE_DARK, 3 = Acrylic
  var gradientColor := $1E1E1E or ($99 shl 24); // ABGR 格式：99=60%透明，1E1E1E=深灰
  DwmSetWindowAttribute(AHandle, 19, @accent, SizeOf(accent));        // DWMWA_USE_IMMERSIVE_DARK
  DwmSetWindowAttribute(AHandle, 20, @gradientColor, SizeOf(gradientColor)); // DWMWA_BORDER_COLOR 等其实是 Acrylic
end;

procedure TCfgForm.FormCreate(Sender: TObject);
begin
  BorderStyle := bsNone;           // 必须先去掉边框
  EnableAcrylicOrMica(Handle);     // 一行搞定毛玻璃






end;

procedure TCfgForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  SendMessage(handle, WM_SYSCOMMAND, SC_MOVE + HTCaption, 0);
end;

procedure TCfgForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta < 0 then
    ScrollBox1.Perform(WM_VSCROLL, SB_LINEDOWN, 0)
  else
    ScrollBox1.Perform(WM_VSCROLL, SB_LINEUP, 0);
  if ActiveControl is TComboBox then
    if not TComboBox(ActiveControl).DroppedDown then
      Handled := True;
end;

procedure TCfgForm.AdjustLastColumnWidth;
var
  TotalWidth: Integer;
  ColCount: Integer;
  UsedWidth: Integer;
begin
  // 获取 ListView 的总宽度
  TotalWidth := ListView1.ClientWidth;

  // 获取列数（假设 ListView 至少有两列）
  ColCount := ListView1.Columns.Count;

  if ColCount > 1 then
  begin
    // 计算除最后一列外所有列的宽度
    UsedWidth := 360;

    ListView1.Columns[0].Width := UsedWidth;
    // 设置最后一列的宽度为剩余的空间
    ListView1.Columns[ColCount - 1].Width := TotalWidth - UsedWidth;
  end;
end;

procedure TCfgForm.btnorg_panelClick(Sender: TObject);
begin
  org_board_state();
end;

procedure TCfgForm.org_board_state;
begin
  p1.Visible := false;

  pbottom.Visible := true;
end;

procedure TCfgForm.Label2Click(Sender: TObject);
begin
  close();
end;

procedure TCfgForm.FormShow(Sender: TObject);
var
  v: TSettingItem;
  tmp_key: string;
begin

  ListView1.Items.Clear;

  // 设置 ListView 的列
  ListView1.Columns.Clear;
  ListView1.Columns.Add;  // 第一列：文件名
  ListView1.Columns.Add;  // 第二列：工具提示







  AdjustLastColumnWidth();

  EnableNonClientDpiScaling(Handle);

  filedit.Text := '';
  file_map := TDictionary<string, string>.Create;

  for tmp_key in g_core.json.Settings.keys do
  begin

    if g_core.json.Settings.TryGetValue(tmp_key, v) then
      if (v.Is_path_valid) then
      begin
        file_map.TryAdd(tmp_key, v.image_file_name + ',' + v.FilePath + ',' + v._tip);

        with ListView1.Items.Add do
        begin
          Caption := v.image_file_name; // 文件名
          SubItems.Add(v._tip);      // 工具提示
        end;
      end;
  end;

  xchange := false;

  text_edit.Text := '';
  tip.Text := '无';
  imgEdit1.Text := '';

  SetWindowCornerPreference(Handle);

  org_board_state();
end;

procedure TCfgForm.Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F008, 0);
end;

procedure TCfgForm.imgEdit1DblClick(Sender: TObject);
var
  OpenDlg: TFileOpenDialog;
  FileType: TFileTypeItem;
begin
  SendToBack();
  OpenDlg := TFileOpenDialog.Create(nil);
  FileType := OpenDlg.FileTypes.Add();
  OpenDlg.Title := '选择 PNG 文件';
  FileType.DisplayName := 'PNG';
  FileType.FileMask := '*.png*';
  OpenDlg.DefaultFolder := GetCurrentDir; // 设置默认文件夹


  OpenDlg.DefaultExtension := 'png'; // 设置默认扩展名

  try
    if OpenDlg.Execute then
    begin
      ImgEdit1.Text := OpenDlg.FileName;
    end;

  finally
    OpenDlg.Free;
    BringToFront;
  end;
end;

procedure TCfgForm.ListView1DblClick(Sender: TObject);
var
  selectedItem: TListItem;
  key1, Hash: string;
begin
  selectedItem := ListView1.Selected;
  if selectedItem = nil then
    Exit;

  key1 := selectedItem.Caption;
  Hash := THashMD5.GetHashString(key1);

  for var Key in file_map.Keys do
  begin
    if Key = Hash then
    begin
      ListView1.Items.Delete(selectedItem.Index);  // 删除该项

      file_map.Remove(Key);

      remove_json(Key);
      del_json_value('settings', Key);
      Break;
    end;
  end;

end;

procedure TCfgForm.ListView1Resize(Sender: TObject);
begin
  AdjustLastColumnWidth();
end;

procedure TCfgForm.rbimgClick(Sender: TObject);
begin
  text_edit.Enabled := false;
  imgEdit1.Enabled := True;

end;

procedure TCfgForm.rbtxtClick(Sender: TObject);
begin
  text_edit.Enabled := True;
  imgEdit1.Enabled := false;

end;

procedure TCfgForm.ScrollBox1MouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandPoint;
end;

procedure TCfgForm.ScrollBox1MouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

end.

