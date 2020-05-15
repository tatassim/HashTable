unit UInfo;

interface
uses SysUtils, Grids, Classes;
type
  TKey = string[255];
  TInfo = record
    Number: string[255];
    PersonName: string[255];
    Adress: string[255];
  end;

function HashF(key: TKey): integer;
function IsEqualKey(k1, k2: TKey): boolean;
procedure SaveInfo(var f: TextFile; info: TInfo);
function LoadInfo(var f: TextFile; var info: TInfo): boolean;
procedure ShowTitle(SG: TStringGrid);
procedure ShowInfo(info: TInfo; Row: TStrings);

implementation

function HashF(key: TKey): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to length(key) do
  begin
    Result := Result + ord(key[i]);
  end;
end;

function IsEqualKey(k1, k2: TKey): boolean;
begin
  Result := k1 = k2;
end;

procedure SaveInfo(var f: TextFile; info: TInfo);
begin
  with info do
  begin
    writeln(f, 'Номер: ' + Number);
    writeln(f, 'Имя: ' + PersonName);
    writeln(f, 'Адрес: ' + Adress);
    writeln(f);
  end;
end;

function TryLoadStr(var f: TextFile; var str: string): boolean;
var
  tmp: string;
  position: Integer;
begin
  result := not eof(f);
  if Result then
  begin
    readln(f, tmp);
    position := Pos(':', tmp);
    if position > 0 then
      str := Copy(tmp, position + 2, length(tmp) - position + 1)
    else
      Result := false;
  end;
end;

function TryLoadInfo(var f: TextFile; var info: TInfo): boolean;
var
  tmp: string;
  ANumber, APersonName, AAdress: string;
begin
  Result := TryLoadStr(f, ANumber) and TryLoadStr(f, APersonName) and
    TryLoadStr(f, AAdress);
  readln(f, tmp);
  Result := Result and (tmp = '');
  if Result then
    with info do
    begin
      Number := ANumber;
      PersonName := APersonName;
      Adress := AAdress;
    end;
end;

function LoadInfo(var f: TextFile; var info: TInfo): boolean;
begin
  Result := TryLoadInfo(f, info);
end;

procedure ShowTitle(SG: TStringGrid);
begin
  with SG do
  begin
    RowCount := 2;
    FixedRows := 1;
    ColCount := 3;
    FixedCols := 0;
    ColWidths[0] := Width div 13;
    ColWidths[1] := ColWidths[0] + Width div 7;
    ColWidths[2] := ColWidths[1];
    Cells[0, 0] := 'Номер телефона';
    Cells[1, 0] := 'Имя';
    Cells[2, 0] := 'Адрес';
    Rows[1].Clear;
  end;
end;

procedure ShowInfo(info: TInfo; Row: TStrings);
begin
  Row[0] := info.Number;
  Row[1] := info.PersonName;
  Row[2] := info.Adress;
end;

end.

