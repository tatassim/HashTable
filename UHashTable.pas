unit UHashTable;

interface

uses UInfo, SysUtils, Grids;

type
  TInfoFile = file of TInfo;
  TAddResult = (arOk, arNonUniqueKey, arError);
  TCellState = (csFree, csFull, csDel);
  TCell = record
    info: TInfo;
    state: TCellState;
  end;
  TTable = array of TCell;

  { THashTable }

  THashTable = class
  private
    FTable: TTable;
    FCount: integer;
    FC, FD: integer;
    FSize: integer;
  protected
    function HashFunc(key: TKey): integer;
    function NextCell(a0: integer; var i: integer): integer;
    function IndexOf(key: TKey): integer;
    function GetNewSize(size: integer): integer;
  public
    constructor Create(AC: integer; AD: Integer; ASize: integer);
    destructor Destroy; override;
    procedure Clear;
    function IsEmpty: Boolean;
    function Add(info: TInfo): TAddResult;
    function Find(key: TKey; var info: TInfo): Boolean;
    function Delete(key: TKey): Boolean;
    procedure Rehashing;
    procedure PrintToGrid(SG: TStringGrid);
    procedure SaveToFile(FileName: string);
    procedure SaveToBinFile(FileName: string);
    function LoadFromFile(FileName: string): Boolean;
    function LoadFromBinFile(FileName: string): Boolean;
    property Count: Integer read FCount;
  end;

implementation

{ THashTable }

function THashTable.Add(info: TInfo): TAddResult;
var
  a0, a: integer;
  i, d: Integer;
  Found, Stop, ok: Boolean;
begin
  a0 := HashFunc(info.Number);
  a := a0;
  i := 0;
  Stop := False;
  Found := False;
  ok := false;
  d := -1;
  repeat
    case FTable[a].state of
      csFree:
        begin
          Stop := true;
        end;
      csDel:
        begin
          if d = -1 then
            d := a;
          a := NextCell(a0, i);
        end;
      csFull:
        begin
          if IsEqualKey(info.Number, FTable[a].info.Number) then
            ok := true
          else
            a := NextCell(a0, i);
        end;
    end;
  until (ok or stop or (i = FSize));
  if ok then
    result := arNonUniqueKey
  else if not stop  and (d=-1) then
    result := arError
  else
  begin
    result := arOk;
    if d <> -1 then
      a := d;
    FTable[a].info := info;
    FTable[a].state := csFull;
    inc(FCount);
  end;
  if not stop then
  begin
    Rehashing;
    result := Add(info);
  end;
end;

procedure THashTable.Clear;
var
  i: integer;
begin
  for i := 0 to FSize - 1 do
    FTable[i].state := csFree;
  FCount := 0;
end;

constructor THashTable.Create(AC: integer; AD: Integer; ASize: integer);
var
  i: integer;
begin
  Clear;
  FC := AC;
  FD := AD;
  FSize := ASize;
  SetLength(FTable, FSize);
end;

function THashTable.Delete(key: TKey): Boolean;
var
  a: integer;
begin
  a := IndexOf(key);
  Result := a >= 0;
  if Result then
  begin
    FTable[a].state := csDel;
    Dec(FCount);
  end;
end;

procedure THashTable.Rehashing;
var
  i, j, NewSize: integer;
  FMas: array of TInfo;
begin
  NewSize := GetNewSize(FSize);
  SetLength(FMas, FCount);
  j := 0;
  for i := 0 to FSize - 1 do
    if FTable[i].State = csFull then
    begin
      FMas[j] := FTable[i].info;
      inc(j);
    end;
  SetLength(FTable, NewSize);
  FSize := NewSize;
  for i := 0 to Length(FMas) - 1 do
    Add(FMas[i]);
  Finalize(FMas);
end;

destructor THashTable.Destroy;
begin
  Clear;
  Finalize(FTable);
  inherited;
end;

function THashTable.Find(key: TKey; var info: TInfo): Boolean;
var
  a: Integer;
begin
  a := IndexOf(key);
  Result := a >= 0;
  if Result then
    info := FTable[a].info;
end;

function THashTable.HashFunc(key: TKey): integer;
begin
  Result := HashF(key) mod FSize;
end;

function THashTable.IndexOf(key: TKey): integer;
var
  a0, a: integer;
  Stop, Found: Boolean;
  i: Integer;
  c: Integer;

begin
  a0 := HashFunc(key);
  c := HashFunc(key);
  a := a0;
  i := 0;
  Stop := false;
  Found := false;
  repeat
    case FTable[a].state of
      csFree: Stop := True;
      csDel: a := NextCell(a0, i);
      csFull:
        if IsEqualKey(key, FTable[a].info.Number) then
          Found := true
        else
          a := NextCell(a0, i);
    end;
  until Stop or Found or (i = FSize);
  if Found then
    Result := a
  else
    Result := -1;
end;

function THashTable.GetNewSize(size: integer): integer;
begin
  if FSize > 64 then
    Result := FSize + FSize div 4
  else if FSize > 8 then
    Result := FSize + 16
  else
    Result := FSize + 4;
end;

function THashTable.IsEmpty: Boolean;
begin
  Result := FCount = 0;
end;

function THashTable.LoadFromBinFile(FileName: string): Boolean;
var
  f: TInfoFile;
  info: TInfo;
begin
  Clear;
  AssignFile(f, FileName);
  Reset(f);
  Result := true;
  while not Eof(f) and Result do
  begin
    read(f, info);
    Result := Add(info) = arOk;
  end;
  CloseFile(f);
end;

function THashTable.LoadFromFile(FileName: string): Boolean;
var
  f: TextFile;
  info: TInfo;
begin
  Clear;
  AssignFile(f, FileName);
  Reset(f);
  Result := true;
  while not Eof(f) and Result do
    if LoadInfo(f, info) then
      Result := Add(info) = arOk
    else
      Result := False;
  CloseFile(f);
end;

function THashTable.NextCell(a0: integer; var i: integer): integer;
var c: integer;
begin
  Inc(i);
  Result := (a0 + c*i) mod FSize;
end;

procedure THashTable.PrintToGrid(SG: TStringGrid);
var
  i: integer;
  j: Integer;
begin
  if FCount = 0 then
  begin
    SG.RowCount := 2;
    SG.Rows[1].Clear;
  end
  else
    SG.RowCount := FCount + 1;
  j := 0;
  if FCount > 0 then
    for i := 0 to FSize - 1 do
      if FTable[i].state = csFull then
      begin
        Inc(j);
        ShowInfo(FTable[i].info, SG.Rows[j]);
      end;
end;

procedure THashTable.SaveToBinFile(FileName: string);
var
  f: file of TInfo;
  i: Integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);
  if FCount > 0 then
    for i := 0 to FSize - 1 do
      if FTable[i].state = csFull then
        write(f, FTable[i].info);
  CloseFile(f);
end;

procedure THashTable.SaveToFile(FileName: string);
var
  f: TextFile;
  i: Integer;
begin
  AssignFile(f, FileName);
  Rewrite(f);
  if FCount > 0 then
    for i := 0 to FSize - 1 do
      if FTable[i].state = csFull then
        SaveInfo(f, FTable[i].info);
  CloseFile(f);
end;

end.

