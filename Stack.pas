unit Stack;

interface

Uses
    Vcl.Graphics;

type
    TElement = integer;
    TNodePointer = ^TNode;
    TNode = record
        Data: TBitmap;
        Next: TNodePointer;
    end;

Type
    TIStack = class(TObject)
        Private
        FHead: TNodePointer;
        FSize : Integer;
        procedure PopFront();
        Public
        constructor Create();
        destructor Destroy;
        procedure Push(Data : TBitmap);
        procedure Clear;
        function Pop : TBitmap;
        function Top : TBitmap;
        function HeadIsNil():boolean;
        property Size : Integer read FSize;
  end;

implementation

{ TStack }

procedure TIStack.PopFront;
var
    Temp: TNodePointer;
begin
    Temp := FHead;
    While(Temp^.Next <> nil) do
        Temp := Temp^.Next;
    Temp := nil;
    Dispose(Temp);
    Dec(Self.FSize);
end;

procedure TIStack.Push(Data : TBitmap);
var
    Temp: TNodePointer;
begin
    if Self.FSize > 4 then
        Self.PopFront;
    Inc(Self.FSize);
    New(Temp);
    Temp^.Data := Data;
    Temp^.Next := nil;
    if (FHead = nil) then
      FHead := Temp
    else
      Temp^.Next := FHead;
      FHead := Temp;
end;

constructor TIStack.Create;
begin
    FHead := nil;
    FSize := 0;
end;

destructor TIStack.Destroy;
begin
    while not HeadIsNil do
      Pop;
end;

function TIStack.Pop : TBitmap;
var
    Temp: TNodePointer;
begin
    if (FHead <> nil) and (FHead.Next <> nil)then
    begin
        Dec(Self.FSize);
        Temp:= FHead;
        FHead:= FHead^.Next;
        result:= Temp^.Data;
        Dispose(Temp);
    end
    else if (FHead <> nil) then
    begin
        Dec(Self.FSize);
        result:= FHead^.Data;
        FHead := nil;
    end
    else
        result := nil;
end;

function TIStack.Top: TBitmap;
begin
    result := FHead^.Data;
end;

function TIStack.HeadIsNil: Boolean;
begin
    result := FHead = nil;
end;

procedure TIStack.Clear;
begin
    while FSize <> 0 do
    begin
        Pop;
    end;
end;
end.
