unit u_json;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,   System.Classes, Vcl.Graphics, generics.collections, System.JSON, Vcl.Controls,
  System.IOUtils, Vcl.Forms, Vcl.Dialogs;

type
  TSettingItem = record
    image_file_name: string;
    FilePath: string;
    memory_image: TMemoryStream;
    Is_path_valid: Boolean;
    _tip: string;
  end;

  TConfig = record
    Left: Integer;
    Top: Integer;
    nodesize: Integer;
    Shortcut: string;
    translator: string;
    debug: string;
    web3d:string;
    layout: string;
    style: string;
    definestart:string;
  end;

  TExclusion = record
    Value: string;
  end;

  TMySettings = record
    Settings: TDictionary<string, TSettingItem>;
    Config: TConfig;
    Exclusion: TExclusion;
  end;

var
  g_jsonobj: TJSONObject;

function load_json_from_file(const FileName: string): TJSONObject;

procedure parse_json(JSONObj: TJSONObject; var MySettings: TMySettings);

procedure set_nodesize_value(var MySettings: TMySettings; NewIHValue: Integer);

function get_json_value(const Section, Key: string): string;

procedure set_json_value(const Section, Key, Value: string);

procedure del_json_value(const Section, Key: string);

procedure add_or_update(const SettingsJSON: TJSONObject; const Key, imagefilename, Path, tooltip: string);

procedure SaveJSONToFile(const FileName: string; const JSONObject: TJSONObject);

implementation

function get_json_value(const Section, Key: string): string;
var
  SectionObj: TJSONObject;
begin
  Result := '';
  if Assigned(g_jsonobj) then
  begin
    SectionObj := g_jsonobj.GetValue(Section) as TJSONObject;
    if Assigned(SectionObj) and SectionObj.TryGetValue(Key, Result) then
      Exit;
  end;
end;

procedure set_json_value(const Section, Key, Value: string);
var
  SectionObj: TJSONObject;
begin
  if Assigned(g_jsonobj) then
  begin
    SectionObj := g_jsonobj.GetValue(Section) as TJSONObject;
    if not Assigned(SectionObj) then
    begin
      SectionObj := TJSONObject.Create;
      g_jsonobj.AddPair(Section, SectionObj);
    end;
    SectionObj.RemovePair(Key).Free;
    SectionObj.AddPair(Key, TJSONString.Create(Value));
  end;
end;

procedure del_json_value(const Section, Key: string);
var
  SectionObj: TJSONObject;
begin
  if Assigned(g_jsonobj) then
  begin
    SectionObj := g_jsonobj.GetValue(Section) as TJSONObject;
    if not Assigned(SectionObj) then
    begin
      Exit;
    end;
    SectionObj.RemovePair(Key).Free;

  end;
end;

procedure add_or_update(const SettingsJSON: TJSONObject; const Key, imagefilename, Path, tooltip: string);
var
  SettingObj: TJSONObject;
begin
  SettingObj := TJSONObject.Create;
  SettingObj.AddPair('imagefilename', imagefilename);
  SettingObj.AddPair('path', Path);
  SettingObj.AddPair('tooltip', tooltip);

  SettingsJSON.AddPair(Key, SettingObj);
end;

procedure Update_config_Value(var MySettings: TMySettings; NewIHValue: Integer; field: string);
begin
  // ���� MySettings ��¼�е� ih ֵ
  MySettings.Config.nodesize := NewIHValue;

  // ���� JSONObj �е� ih ֵ
  if Assigned(g_jsonobj) then
  begin
    g_jsonobj.GetValue<TJSONObject>('config').RemovePair(field).Free;
    g_jsonobj.GetValue<TJSONObject>('config').AddPair(field, TJSONNumber.Create(NewIHValue));
  end;
end;

procedure set_nodesize_value(var MySettings: TMySettings; NewIHValue: Integer);
begin

  Update_config_Value(MySettings, NewIHValue, 'nodesize');
end;

procedure SaveJSONToFile(const FileName: string; const JSONObject: TJSONObject);
var
  JSONString: string;
begin
  JSONString := JSONObject.ToJSON;
  TFile.WriteAllText(FileName, JSONString, TEncoding.UTF8);
end;

function load_json_from_file(const FileName: string): TJSONObject;
var
  JSONString: TStringList;
  JSONValue: TJSONValue;
begin
  JSONString := TStringList.Create;
  try
    JSONString.LoadFromFile(FileName);
    JSONValue := TJSONObject.ParseJSONValue(JSONString.Text);
    if not Assigned(JSONValue) or not (JSONValue is TJSONObject) then
      raise Exception.Create('Invalid JSON file');
    Result := TJSONObject(JSONValue);
  finally
    JSONString.Free;
  end;
end;

procedure parse_json(JSONObj: TJSONObject; var MySettings: TMySettings);
var
  SettingsObj, ConfigObj, ExclusionObj: TJSONObject;
  Pair: TJSONPair;

  Key: string;
  SettingItem: TSettingItem;
begin
  MySettings.Settings := TDictionary<string, TSettingItem>.Create;

  SettingsObj := JSONObj.GetValue('settings') as TJSONObject;
  if Assigned(SettingsObj) then
  begin
    try
      for Pair in SettingsObj do
      begin
        Key := Pair.JsonString.Value;
        with SettingItem do
        begin
          image_file_name := SettingsObj.GetValue(Key).GetValue<string>('imagefilename');

          FilePath := SettingsObj.GetValue(Key).GetValue<string>('path');
          _tip := SettingsObj.GetValue(Key).GetValue<string>('tooltip');
          Is_path_valid := true;
          memory_image := nil;

        end;
        MySettings.Settings.TryAdd(Key, SettingItem);
      end;
    except

    end;
  end;

  // Parse config
  ConfigObj := JSONObj.GetValue('config') as TJSONObject;
  if Assigned(ConfigObj) then
  begin
    with MySettings.Config do
    begin
      Left := ConfigObj.GetValue('left').Value.ToInteger;
      Top := ConfigObj.GetValue('top').Value.ToInteger;
      nodesize := ConfigObj.GetValue('nodesize').Value.ToInteger;
      Shortcut := ConfigObj.GetValue('shortcut').Value;
      translator := ConfigObj.GetValue('translator').Value;
      definestart:=  ConfigObj.GetValue('definestart').Value;
      debug := ConfigObj.GetValue('debug').Value;
      web3d:=ConfigObj.GetValue('debug').Value;
      layout := ConfigObj.GetValue('layout').Value;
      style := ConfigObj.GetValue('style').Value;
    end;
  end;

  // Parse exclusion
  ExclusionObj := JSONObj.GetValue('exclusion') as TJSONObject;
  if Assigned(ExclusionObj) then
  begin
    MySettings.Exclusion.Value := ExclusionObj.GetValue('value').Value;
  end;

end;

end.

