{
Пакет             Simple Game Engine 1
Файл              sgeJoystickList.pas
Версия            1.3
Создан            10.03.2019
Автор             Творческий человек  (accuratealx@gmail.com)
Описание          Класс хранилища подключённых джойстиков
}

unit sgeJoystickList;

{$mode objfpc}{$H+}

interface

uses
  sgeJoystick;


type
  TsgeJoystickList = class
  private
    FJoyArray: array of TsgeJoystick;

    function  GetCount: Byte;
    procedure Add(Joystick: TsgeJoystick);
    procedure Delete(Index: Byte);
    function  GetJoystick(Index: Byte): TsgeJoystick;
  public
    destructor  Destroy; override;

    procedure Clear;
    procedure Scan;
    procedure Reset;
    procedure Process;

    property Count: Byte read GetCount;
    property Joystick[Index: Byte]: TsgeJoystick read GetJoystick;
  end;




implementation

uses
  sgeTypes, sgeConst,
  MMSystem, SysUtils;


const
  _UNITNAME = 'sgeJoystickList';



function TsgeJoystickList.GetCount: Byte;
begin
  Result := Length(FJoyArray);
end;


procedure TsgeJoystickList.Add(Joystick: TsgeJoystick);
var
  c: Integer;
begin
  c := GetCount;
  SetLength(FJoyArray, c + 1);
  FJoyArray[c] := Joystick;
end;


procedure TsgeJoystickList.Delete(Index: Byte);
var
  i, c: Integer;
begin
  c := GetCount - 1;
  if Index > c then Exit;

  FJoyArray[Index].Free;

  for i := Index to c - 1 do
    FJoyArray[i] := FJoyArray[i + 1];

  SetLength(FJoyArray, c);
end;


function TsgeJoystickList.GetJoystick(Index: Byte): TsgeJoystick;
begin
  if Index > GetCount - 1 then
    raise EsgeException.Create(_UNITNAME, Err_IndexOutOfBounds, IntToStr(Index));

  Result := FJoyArray[Index];
end;


destructor TsgeJoystickList.Destroy;
begin
  Clear;
end;


procedure TsgeJoystickList.Clear;
var
  i, c: Integer;
begin
  c := GetCount - 1;
  for i := 0 to c do
    FJoyArray[i].Free;

  SetLength(FJoyArray, 0);
end;


procedure TsgeJoystickList.Scan;
var
  i, c: Integer;
  J: TsgeJoystick;
begin
  Clear;

  c := joyGetNumDevs - 1;
  for i := 0 to c do
    try
      J := TsgeJoystick.Create(i);
      Add(J);
    except
    end;
end;


procedure TsgeJoystickList.Reset;
var
  i, c: Integer;
begin
  c := GetCount - 1;
  for i := 0 to c do
    FJoyArray[i].Reset;
end;


procedure TsgeJoystickList.Process;
var
  i: Integer;
begin
  i := 0;

  while i < Length(FJoyArray) do
    begin

    try
      FJoyArray[i].Process;
    except
      Delete(i);
      Dec(i);
    end;

    Inc(i);
    end;
end;




end.

