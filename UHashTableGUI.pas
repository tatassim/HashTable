unit UHashTableGUI;

interface
uses UHashTable, UInfo, Grids, StdCtrls, Dialogs, SysUtils, Controls;
type
  THashTableGUI = class(THashTable)
  private
    FModified: Boolean;
    FFileName: string;
    FIsTxt: boolean;
    FStringGrid: TStringGrid;
  protected
    procedure SetModified(value: boolean);
  public
    constructor Create(ASG: TStringGrid; AC, AD: integer; ASize: integer);
    function Load(AFileName: string; AIsTxt: Boolean): boolean;
    procedure Save(AFileName: string; AIsTxt: Boolean);
    procedure Clear;
    function Add(info: TInfo): boolean;
    function Delete(key: TKey): boolean;

    property FileName: string read FFileName;
    property Modified: Boolean read FModified write SetModified;
    property IsTxt: Boolean read FIsTxt write FIsTxt;
  end;

implementation

{ THashTableGUI }

function THashTableGUI.Add(info: TInfo): boolean;
begin
  Result := true;
  if inherited Add(info) = arOk then
    Modified := True
  else
    Result := false;
end;

procedure THashTableGUI.Clear;
begin
  if not IsEmpty then
  begin
    inherited;
    Modified := true;
  end;
end;

constructor THashTableGUI.Create(ASG: TStringGrid; AC, AD: Integer; ASize:
  integer);
begin
  FStringGrid := ASG;
  inherited Create(AC, AD, ASize);
  FFileName := '';
  FModified := false;
  ShowTitle(FStringGrid);
end;

function THashTableGUI.Delete(key: TKey): boolean;
begin
  Result := inherited Delete(key);
  Modified := Result or Modified;
end;

function THashTableGUI.Load(AFileName: string; AIsTxt: Boolean): boolean;
begin
  FIsTxt := AIsTxt;
  FFileName := AFileName;
  if FIsTxt then
    Result := LoadFromFile(AFileName)
  else
    Result := LoadFromBinFile(AFileName);
  FModified := False;
  PrintToGrid(FStringGrid);
end;

procedure THashTableGUI.Save(AFileName: string; AIsTxt: Boolean);
begin
  FIsTxt := AIsTxt;
  FFileName := AFileName;
  if FIsTxt then
    SaveToFile(AFileName)
  else
    SaveToBinFile(AFileName);
  FModified := false;
end;

procedure THashTableGUI.SetModified(value: boolean);
begin
  FModified := value;
  if FModified then
    PrintToGrid(FStringGrid);
end;

end.

