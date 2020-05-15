unit FMain;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UHashTable, UInfo, ActnList, Menus, Grids, ImgList, ComCtrls,
  ToolWin, UHashTableGUI, UHelpForm;

type

  { TFormMain }

  TFormMain = class(TForm)
    Menu: TMainMenu;
    NFind: TMenuItem;
    NFile: TMenuItem;
    NEdit: TMenuItem;
    NNew: TMenuItem;
    NOpen: TMenuItem;
    NSave: TMenuItem;
    NSaveAs: TMenuItem;
    NClose: TMenuItem;
    NSeparator: TMenuItem;
    NExit: TMenuItem;
    NAdd: TMenuItem;
    NDelete: TMenuItem;
    NClear: TMenuItem;
    actList: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actClose: TAction;
    actExit: TAction;
    actAdd: TAction;
    actDelete: TAction;
    actClear: TAction;
    actFind: TAction;
    SGMain: TStringGrid;
    imgList: TImageList;
    tlbMain: TToolBar;
    btnOpen: TToolButton;
    btnNew: TToolButton;
    btnSave: TToolButton;
    btnClose: TToolButton;
    btnExit: TToolButton;
    btn6: TToolButton;
    btnAdd: TToolButton;
    btnDelete: TToolButton;
    btnClear: TToolButton;
    btnFind: TToolButton;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    procedure actFindExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure MyIdle(sender: TObject; var Done: Boolean);
  public
    { Public declarations }
    HashTable: THashTableGUI;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.actNewExecute(Sender: TObject);
begin
  if HashTable <> nil then
    actClose.Execute;
  if HashTable = nil then
    HashTable := THashTableGUI.Create(SGMain, 5, 6, 10);
end;

procedure TFormMain.actFindExecute(Sender: TObject);
var
  number: string;
  SearchedInfo: TInfo;
begin
  if Dialogs.InputQuery('Поиск человека по номеру', 'Введите номер', number)
    then
    if HashTable.Find(number, SearchedInfo) then
      with TfrmHelp.Create(nil) do
        try
          SetParams(SearchedInfo, true);
          ShowModal;
        finally
          Free;
        end
    else
      ShowMessage('Запись не найдена');
end;

procedure TFormMain.MyIdle(sender: TObject; var Done: Boolean);
var
  HashTableExists, RecordsPresent: Boolean;
begin
  HashTableExists := HashTable <> nil;
  RecordsPresent := HashTableExists and not HashTable.IsEmpty;

  SGMain.Visible := HashTableExists;
  actSave.Enabled := HashTableExists;
  actSaveAs.Enabled := HashTableExists;
  actClose.Enabled := HashTableExists;
  actAdd.Enabled := HashTableExists;
  actDelete.Enabled := RecordsPresent;
  actClear.Enabled := RecordsPresent;
  actFind.Enabled := RecordsPresent;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  HashTable := nil;
  Application.OnIdle := MyIdle;
  dlgOpen.InitialDir := ExtractFilePath(Application.ExeName);
  dlgSave.InitialDir := ExtractFilePath(Application.ExeName);
end;

procedure TFormMain.actOpenExecute(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    if HashTable <> nil then
      actClose.Execute;
    if HashTable = nil then
    begin
      HashTable := THashTableGUI.Create(SGMain, 5, 6, 10);
      if not HashTable.Load(dlgOpen.FileName, dlgOpen.filterIndex = 1) then
        ShowMessage('Ошибка при загрузке файла');
    end;
  end;
end;

procedure TFormMain.actSaveExecute(Sender: TObject);
begin
  if HashTable.FileName = '' then
    actSaveAs.Execute
  else
    HashTable.Save(HashTable.FileName, HashTable.IsTxt)
end;

procedure TFormMain.actSaveAsExecute(Sender: TObject);
begin
  dlgSave.FileName := HashTable.FileName;
  if dlgSave.Execute then
    HashTable.Save(dlgSave.FileName, dlgSave.FilterIndex = 1);
end;

procedure TFormMain.actCloseExecute(Sender: TObject);
var
  CanClose: Boolean;
begin
  CanClose := true;
  if (HashTable <> nil) and HashTable.Modified then
    case MessageDlg('Сохранить изменения?', mtConfirmation, [mbYes, mbNo,
      mbCancel], 0) of
      mrCancel: CanClose := False;
      mrYes:
        begin
          actSave.Execute;
          CanClose := not HashTable.Modified;
        end;
    end;
  if CanClose then
    FreeAndNil(HashTable);
end;

procedure TFormMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.actAddExecute(Sender: TObject);
begin
  with TfrmHelp.Create(nil) do
    try
      SetParams(info, false);
      if ShowModal = mrOk then
        HashTable.Add(Info);
    finally
      Free;
    end;
end;

procedure TFormMain.actDeleteExecute(Sender: TObject);
var
  number: string;
begin
  if Dialogs.InputQuery('Удаление записи', 'Введите номер телефона', number) then
    if HashTable.Delete(number) then
      ShowMessage('Запись удалена')
    else
      ShowMessage('Запись не найдена')
end;

procedure TFormMain.actClearExecute(Sender: TObject);
begin
  if MessageDlg('Вы действительно хотите очистить таблицу?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    HashTable.Clear;
end;

procedure TFormMain.actRunExecute(Sender: TObject);
var
  number: string;
  SearchedInfo: TInfo;
begin
  if Dialogs.InputQuery('Поиск человека по номеру', 'Введите номер', number)
    then
    if HashTable.Find(number, SearchedInfo) then
      with TfrmHelp.Create(nil) do
        try
          SetParams(SearchedInfo, true);
          ShowModal;
        finally
          Free;
        end
    else
      ShowMessage('Запись не найдена');
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  with SGMain do
  begin
    ColWidths[0] := Width div 13;
    ColWidths[1] := ColWidths[0] + Width div 7;
    ColWidths[2] := ColWidths[1];
    ColWidths[3] := ColWidths[0] * 6 + width div 58;
  end;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if HashTable <> nil then
    actClose.Execute;
  CanClose := HashTable = nil;
end;





end.

