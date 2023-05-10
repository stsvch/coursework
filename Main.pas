unit Main;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils,
    System.Classes, Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs,Math,
    Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, Vcl.Buttons, Vcl.ColorGrd, Stack,
    Vcl.ComCtrls, Vcl.ExtDlgs, Vcl.NumberBox, Vcl.Samples.Spin, JPEG, PNGImage,
    System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan;

Type
    TMPoint = Record
        X1, X2, Y1, Y2: Integer;
    End;

Const
    ANGLE = (pi/2);

type
    TPaintForm = class(TForm)
    Panel: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    ToolsPanel: TPanel;
    ButtonBrush: TSpeedButton;
    ButtonPencil: TSpeedButton;
    ButtonPipette: TSpeedButton;
    ButtonEraser: TSpeedButton;
    ButtonOval: TSpeedButton;
    ButtonRectangle: TSpeedButton;
    Edit1: TMenuItem;
    Clear: TMenuItem;
    ButtonPaintcan: TSpeedButton;
    ButtonHand: TSpeedButton;
    ScrollBox: TScrollBox;
    Canva: TPaintBox;
    Resize: TMenuItem;
    ButtonLine: TSpeedButton;
    ButtonBlur: TSpeedButton;
    GroupBoxColor: TGroupBox;
    LShape: TShape;
    RShape: TShape;
    ColorGrid: TColorGrid;
    ColorButton: TButton;
    ButtonDrag: TSpeedButton;
    OpenPicDialog: TOpenPictureDialog;
    SavePicDialog: TSavePictureDialog;
    ButtonDelete: TSpeedButton;
    PopupMenu: TPopupMenu;
    Cut: TMenuItem;
    ButtonHighlight: TSpeedButton;
    Rotate: TMenuItem;
    Rotate90: TMenuItem;
    Rotate180: TMenuItem;
    Rotate270: TMenuItem;
    ForwardButton: TSpeedButton;
    BackButton: TSpeedButton;
    SizeBox: TComboBox;
    TrackBar: TTrackBar;
    ButtonDarker: TSpeedButton;
    ButtonLighter: TSpeedButton;
    EditPercent: TSpinEdit;
    N1: TMenuItem;
    Back: TMenuItem;
    Forwardd: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure CanvaMouseDown(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
    procedure CanvaMouseMove(Sender: TObject; Shift: TShiftState;
          X, Y: Integer);
    procedure CanvaMouseUp(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SizeBoxChange(Sender: TObject);
    procedure SizeBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SizeBoxKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
    procedure ColorButtonClick();
    procedure ColorGridChange(Sender: TObject);
    procedure ClearClick();
    procedure BackButtonClick();
    procedure ForwardButtonClick();
    procedure CheckStack;
    procedure ImageToBMP(FilePath: String);
    procedure BMPToImage(FilePath: String);
    procedure CanvaPaint(Sender: TObject);
    procedure OpenClick();
    procedure SaveClick();
    procedure TrackBarChange(Sender: TObject);
    procedure SprayPaint(X, Y : Integer; Color : TColor);
    procedure CopyAndPush();
    procedure Init();
    procedure ResizeClick();
    procedure DrawLine(Color : TColor);
    procedure DrawPencil(Color : TColor);
    procedure Blur(X, Y : Integer);
    procedure Erase();
    procedure DrawOval();
    procedure DrawRectangle();
    procedure SelectSquare;
    procedure DefineRectangle();
    procedure Delete();
    procedure CutClick(Sender: TObject);
    procedure CopyBmp;
    procedure RotateBitmap(Rads: Single);
    procedure Rotate90Click(Sender: TObject);
    procedure Rotate180Click(Sender: TObject);
    procedure Rotate270Click(Sender: TObject);
    procedure SaveAsClick();
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BrushPainting(Color : TColor);
    function ButtonIsPressed(): Boolean;
    procedure Darker(X, Y : Integer);
    procedure Lighter(X, Y : Integer);
    procedure InsertRotatedImage(I : Integer);
    procedure EditPercentChange(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure JPEGtoBMP(const FileName: TFileName);
    procedure BmpToPng(const FileName : TFileName);
    procedure SavePng(const FileName : TFileName);
    procedure SaveJpeg(const FileName : TFileName);
    procedure N1Click();
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure CreateTempImg();
    procedure ClearStack;
    private
        TempImg : TBitmap;
        Percent : Integer;
        Bmp : TBitmap;
        BmpSize : TRect;
        FStart : Boolean;
        FDrag : Boolean;
        FSelect : Boolean;
        FDelete : Boolean;
        FCopy : Boolean;
        IsSave : Boolean;
        MPoint: TMPoint;
        BtmPoint : TPoint;
        Size: Integer;
        MClick: Boolean;
        BackImageStack: TIStack;
        ForwardImageStack: TIStack;
        { Private declarations }
    public
        { Public declarations }
        Image : TBitmap;
        Path : String;
        CanvasSize : TSize;
        ShapeBrush : TBrush;
        ShapePen : TPen;
        FSave : Boolean;
    end;

var
    PaintForm: TPaintForm;

implementation

uses
    Menu, Color, Shape, Size, About;

{$R *.dfm}

procedure TPaintForm.BMPToImage(FilePath: String) ;
var
    Bitmap: TBitmap;
begin
    try
        Bitmap:= TBitmap.Create;
        Bitmap.LoadFromFile(FilePath);
        SizeForm.Resize(Bitmap.Width, Bitmap.Height);
        Image.Canvas.Draw(0, 0, Bitmap)
    finally
        Bitmap.Free;
    end;
end;

procedure TPaintForm.BrushPainting(Color: TColor);
begin
    Image.Canvas.Brush.Color := Color;
    Image.Canvas.FloodFill(MPoint.X1, MPoint.Y1, Image.Canvas.Pixels[MPoint.X1, MPoint.Y1], fssurface);
end;

function TPaintForm.ButtonIsPressed: Boolean;
begin
    if (ButtonPencil.Down) or (ButtonOval.Down) or (ButtonBrush.Down)
        or (ButtonRectangle.Down) or (ButtonLine.Down) or (ButtonPaintcan.Down)
        or (ButtonEraser.Down) or (ButtonBlur.Down)
        or (ButtonDarker.Down) or (ButtonLighter.Down)then
        result := True
    else
        result := False;
end;

procedure TPaintForm.ImageToBMP(FilePath: String);
var
    Bitmap: TBitmap;
    Dest: TRect;
begin
    Bitmap := TBitmap.Create;
    try
        with Bitmap do
        begin
            Width := CanvasSize.Width;
            Height := CanvasSize.Height;
            Dest:= Rect(0, 0, Width, Height);
        end;
        Bitmap.Canvas.StretchDraw(Dest, Image);
        Bitmap.SaveToFile(FilePath) ;
    finally
        Bitmap.Free;
    end;
end;

procedure TPaintForm.CheckStack;
begin
    if BackImageStack.Size < 1 then
    begin
        BackButton.Enabled := False;
        Back.Enabled := False;
    end
    else
    begin
        BackButton.Enabled := True;
        Back.Enabled := True;
    end;
    if ForwardImageStack.Size < 1 then
    begin
        ForwardButton.Enabled := False;
        Forwardd.Enabled := False;
    end
    Else
    begin
        ForwardButton.Enabled := True;
        Forwardd.Enabled := True;
    end;
end;

procedure TPaintForm.SaveClick();
var
    Str : String;
begin
    if Path = '' then
    begin
        SaveAsClick();
    end
    else
    begin
        FSave := True;
        Str := ExtractFileExt(Path);
        if Str = '.bmp' then
            ImageToBMP(Path);
        if Str = '.png' then
            SavePng(Path);
        if Str = '.jpeg' then
            SaveJpeg(Path);
    end;
end;

procedure TPaintForm.SaveJpeg(const FileName: TFileName);
var
    Jpeg: TJPEGImage;
begin
    try
        Jpeg := TJPEGImage.create;
        Jpeg.Assign(Image);
        Jpeg.SaveToFile(FileName);
    finally
        Jpeg.Free;
    end;
end;

procedure TPaintForm.SavePng(const FileName: TFileName);
var
    Png: TPNGObject;
begin
    try
        Png := TPNGObject.create;
        Png.Assign(Image);
        Png.SaveToFile(FileName);
    finally
        Png.Free;
    end;
end;

procedure TPaintForm.SaveAsClick();
var
    Str : String;
    I : Integer;
begin
    if SavePicDialog.Execute then
    begin
        I := SavePicDialog.FilterIndex;
        case I of
        1: Str:= '.bmp';
        2: Str:= '.png';
        3: Str:= '.jpeg';
        end;
        FSave := True;
        SavePicDialog.DefaultExt := Str;
        Path := SavePicDialog.FileName;
        if Str = '.bmp' then
            ImageToBMP(SavePicDialog.FileName);
        if Str = '.png' then
            SavePng(SavePicDialog.FileName);
        if Str = '.jpeg' then
            SaveJpeg(SavePicDialog.FileName)
        else
            ImageToBMP(SavePicDialog.FileName);
           // MessageBox(Application.Handle, PChar('Данный формат файла не поддерживается'), PChar('Ошибка'), MB_OK);
    end;
end;

procedure TPaintForm.SelectSquare;
begin
    with Canva do
    begin
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := clSkyBlue;
        Canvas.Brush.Style := bsClear;
        Canvas.Rectangle(MPoint.X1 * TrackBar.Position, MPoint.Y1 * TrackBar.Position, MPoint.X2 * TrackBar.Position, MPoint.Y2 * TrackBar.Position);
    end;
    FSelect := True;
end;

procedure TPaintForm.SizeBoxChange(Sender: TObject);
begin
    try
        if SizeBox.Text = '' then
            SizeBox.Text := '1';
        if SizeBox.Text <>'' then
            Size := StrToInt(SizeBox.Text);
    except
        MessageDlg('Проверьте корректность данных!', MtError, [MbOk], 0);
        SizeBox.Text := '1';
    end;
end;

procedure TPaintForm.SizeBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Shift = [ssShift]) and (Key = VK_INSERT) then
        Abort;
end;

procedure TPaintForm.SizeBoxKeyPress(Sender: TObject; var Key: Char);
begin
    if Not(Key in ['0'..'9', #08]) then
        Key := #0;
    if (SizeBox.Text = '') and Not(Key in ['1'..'9'])then
        Key := #0;
end;

procedure TPaintForm.CopyAndPush;
var
    Img : TBitmap;
begin
    Img := TBitmap.Create(CanvasSize.Width, CanvasSize.Height);
    Img.Canvas.CopyRect(Image.Canvas.ClipRect, Image.Canvas, Image.Canvas.ClipRect);
    BackImageStack.Push(Img);
end;

procedure TPaintForm.CopyBmp;
begin
    Bmp := TBitmap.Create(BmpSize.Width,BmpSize.Height);
    Bmp.Canvas.CopyRect(Bmp.Canvas.ClipRect, Image.Canvas, BmpSize);
end;

procedure TPaintForm.CreateTempImg;
begin
    TempImg := TBitmap.Create();
    TempImg.Assign(Image);
    Image.Canvas.Brush.Style := bsClear;
    Image.Canvas.Pen.Width := 1;
    Image.Canvas.Pen.Color := clSkyBlue;
    Image.Canvas.Rectangle(BmpSize);
end;

procedure TPaintForm.TrackBarChange(Sender: TObject);
begin
    Canva.ClientHeight := CanvasSize.Height * TrackBar.Position;
    Canva.ClientWidth := CanvasSize.Width * TrackBar.Position;
    Canva.Canvas.StretchDraw(Canva.ClientRect, Image);
end;

procedure TPaintForm.BackButtonClick();
var
    Img: TBitmap;
begin
    Img := TBitmap.Create(CanvasSize.Width, CanvasSize.Height);
    Img.Canvas.CopyRect(Image.Canvas.ClipRect, Image.Canvas, Image.Canvas.ClipRect);
    ForwardImageStack.Push(Img);
    Image.Canvas.CopyRect(Image.Canvas.ClipRect, BackImageStack.Pop.Canvas, Image.Canvas.ClipRect);
    CanvaPaint(Canva);
    CheckStack;
end;

procedure TPaintForm.ColorButtonClick();
begin
    ColorForm.LShape.Brush.Color := Self.LShape.Brush.Color;
    ColorForm.RShape.Brush.Color := Self.RShape.Brush.Color;
    ColorForm.Define;
    ColorForm.Show();
    Enabled := False;
end;

procedure TPaintForm.ColorGridChange(Sender: TObject);
begin
    RShape.Brush.Color := ColorGrid.BackgroundColor;
    LShape.Brush.Color := ColorGrid.ForegroundColor;
end;

procedure TPaintForm.Init();
begin
    PopupMenu.AutoPopup := False;
    BackImageStack := TIStack.Create;
    ForwardImageStack := TIStack.Create;
    Image := TBitmap.Create(CanvasSize.Width, CanvasSize.Height);
    BackButton.Enabled := False;
    ForwardButton.Enabled := False;
end;

procedure TPaintForm.InsertRotatedImage(I: Integer);
begin
    FSave := False;
    Delete;
    RotateBitmap(I * ANGLE);
    Image.Canvas.Draw(BmpSize.Left, BmpSize.Top, Bmp);
    PopupMenu.AutoPopup := False;
end;

procedure TPaintForm.Lighter(X, Y : Integer);
var
    R, G, B : Byte;
    I, J, Temp : Integer;
begin
    Temp := Round(Size/2);
    Dec(X, Temp);
    Dec(Y, Temp);
    for I := 0 to Size do
    begin
        for J := 0 to Size do
        begin
            if sqr(I - Temp)+sqr(J - Temp) < sqr(Temp) - 1 then
            begin
                R := GetRValue(Image.Canvas.Pixels[X + I, Y + J]);
                G := GetGValue(Image.Canvas.Pixels[X + I, Y + J]);
                B := GetBValue(Image.Canvas.Pixels[X + I, Y + J]);

                R := R + Muldiv(255 - R,Percent,2500);
                G := G + Muldiv(255 - G,Percent,2500);
                B := B + Muldiv(255 - B,Percent,2500);
                Image.Canvas.Pixels[X + I, Y + J] := RGB(R, G, B);
            end;
        end;
    end;
end;

procedure TPaintForm.N1Click();
begin
    Enabled := False;
    AboutForm.Show;
end;

procedure TPaintForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
    WND: HWND;
    lpCaption, lpText: PChar;
    Tip: Integer;
Begin
    if Not(FSave) then
    begin
        WND := Self.Handle;
        lpCaption := 'Выход';
        lpText := 'В программу были внесены изменения. Сохранить их?';
        Tip := MB_YESNOCANCEL + MB_ICONQUESTION+ MB_APPLMODAL;
        case MessageBox(WND, lpText, lpCaption, Tip) Of
            IDYES :
            begin
                SaveClick();
                CanClose := True;
            end;
            IDNO : CanClose := True;
            IDCANCEL : CanClose := False;
        end
    end;
End;

procedure TPaintForm.FormCreate(Sender: TObject);
begin
    Application.OnHelp := OnHelp;
    EditPercent.Visible := False;
    Percent := StrToInt(EditPercent.Text);
    Path := '';
    FSave := True;
    FDelete := False;
    Scrollbox.ClientHeight := Canva.Height + SM_CYVSCROLL;
    Scrollbox.ClientWidth := Canva.Width + SM_CYVSCROLL;
    PaintForm.ClientHeight := Scrollbox.Height + Panel.Height + SM_CYVSCROLL;
    PaintForm.ClientWidth := Scrollbox.Width + SM_CYVSCROLL;
    RShape.Brush.Color := ColorGrid.BackgroundColor;
    LShape.Brush.Color := ColorGrid.ForegroundColor;
    CanvasSize.Width := Canva.ClientWidth;
    CanvasSize.Height := Canva.ClientHeight;
    ShapeBrush := TBrush.Create;
    ShapePen := TPen.Create;
    Init;
end;

procedure TPaintForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
    If Msg.CharCode = 112 then
    begin
        ButtonClick(N1);
        Handled := True;
    end;
end;

procedure TPaintForm.FormShow(Sender: TObject);
begin
    Enabled := False;
    MenuForm.Show();
end;

procedure TPaintForm.DrawRectangle();
Begin
    Image.Canvas.CopyRect(Canva.ClientRect, BackImageStack.Top.Canvas, Canva.ClientRect);
    Image.Canvas.Pen.Style := ShapePen.Style;
    Image.Canvas.Pen.Color := ShapePen.Color;
    Image.Canvas.Pen.Width := Size;
    Image.Canvas.Brush.Style := PaintForm.ShapeBrush.Style;
    if Image.Canvas.Brush.Style <> bsClear then
        Image.Canvas.Brush.Color := PaintForm.ShapeBrush.Color;
    Image.Canvas.Rectangle(MPoint.X1, MPoint.Y1, MPoint.X2, MPoint.Y2);
End;

procedure TPaintForm.ButtonClick(Sender: TObject);
var
    I : Integer;
begin
    if TempImg <> nil then
    begin
        if FCopy then
        begin
            Image.Assign(TempImg);
            TempImg.Free;
            FCopy := False;
        end;
    end;

    I := TButton(Sender).Tag;
    if (I = 11) or (I = 12) then
        EditPercent.Visible := True
    else
        EditPercent.Visible := False;
    if I <> 10 then
        PopupMenu.AutoPopup := False;
    case I of
    7:
    begin
        Enabled:=False;
        ShapeForm.Show();
    end;
    8:
    begin
        Enabled:=False;
        ShapeForm.Show();
    end;
    14:
    begin
        FStart := True;
        FDrag := False;
        FSelect := False;
    end;
    15:
    begin
        FSelect := False;
        FCopy := False;
    end;
    16: BackButtonClick;
    17: ForwardButtonClick;
    18: ColorButtonClick;
    19: ClearClick;
    20: ResizeClick;
    21: OpenClick;
    22: SaveClick;
    23: SaveAsClick;
    24: N1Click;
    end;
end;

procedure TPaintForm.SprayPaint(X, Y : Integer; Color : TColor);
var
    X1, Y1, I, Temp : Integer;
begin
    Temp := Round(Size/2);
    for I := 0 to Size do
    begin
        X1 := RandomRange(-Temp, Temp);
        Y1 := RandomRange(-Temp, Temp);
        if sqr(X1) + sqr(Y1) < sqr(Temp) - 1 then
            Image.Canvas.Pixels[X + X1, Y + Y1] := Color;
    end;
end;

procedure TPaintForm.DrawOval();
Begin
    Image.Canvas.CopyRect(Canva.ClientRect, BackImageStack.Top.Canvas, Canva.ClientRect);
    Image.Canvas.Pen.Style := ShapePen.Style;
    Image.Canvas.Pen.Color := ShapePen.Color;
    Image.Canvas.Pen.Width := Size;
    Image.Canvas.Brush.Style := ShapeBrush.Style;
    if Image.Canvas.Brush.Style <> bsClear then
        Image.Canvas.Brush.Color := ShapeBrush.Color;
    Image.Canvas.Ellipse(MPoint.X1, MPoint.Y1, MPoint.X2, MPoint.Y2);
End;

procedure TPaintForm.ForwardButtonClick();
var
    Img : TBitmap;
begin
    Img := TBitmap.Create(CanvasSize.Width, CanvasSize.Height);
    Img.Canvas.CopyRect(Image.Canvas.ClipRect, Image.Canvas, Image.Canvas.ClipRect);
    BackImageStack.Push(Img);
    Image.Canvas.StretchDraw(Image.Canvas.ClipRect, ForwardImageStack.Pop);
    CanvaPaint(Canva);
    CheckStack;
end;

procedure TPaintForm.Blur(X, Y : Integer);
var
    X1, Y1, Temp : Integer;
    I, J : Integer;
    R, G, B, D : Integer;
    RPix: Array of Array of Byte;
    GPix: Array of Array of Byte;
    BPix: Array of Array of Byte;
begin
    Temp := Round(Size/2);
    SetLength(RPix, Size, Size);
    SetLength(GPix, Size, Size);
    SetLength(BPix, Size, Size);
    if (X > Temp) and (Y > Temp) then
    begin
        Dec(X, Temp);
        Dec(Y, Temp);
    end;
    D := 2;
    for Y1 := Low(RPix) to High(RPix) do
    begin
        for X1 := Low(RPix) to High(RPix) do
        begin
            RPix[X1,Y1] := GetRValue(Image.Canvas.Pixels[X +X1,Y + Y1]);
            GPix[X1,Y1] := GetGValue(Image.Canvas.Pixels[X +X1,Y + Y1]);
            BPix[X1,Y1] := GetBValue(Image.Canvas.Pixels[X +X1,Y + Y1]);
        end;
    end;
    for Y1 := D to High(RPix) - D do
    begin
        for X1 := D to High(RPix) - D do
        begin
            if sqr(X1 - Temp) + sqr(Y1 - Temp) <= sqr(Temp) -1 then
            begin
                R := 0;
                G := 0;
                B := 0;
                for I := -D to D do
                    for J := -D to D do
                    begin
                        R := R + RPix[X1 + I, Y1 + J];
                        G := G + GPix[X1 + I, Y1 + J];
                        B := B + BPix[X1 + I, Y1 + J];
                    end;
                R := Round(R / sqr(2 * d + 1));
                G := Round(G / sqr(2 * d + 1));
                B := Round(B / sqr(2 * d + 1));
                Image.Canvas.Pixels[X + X1,Y + Y1] := RGB(R, G, B);
            end;
        end;
    end;
end;

procedure TPaintForm.CanvaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   Img : TBitmap;
   Dest : TRect;
begin
    if ButtonIsPressed then
    begin
        FSave := False;
        ForwardImageStack.Clear;
        CopyAndPush;
        CheckStack;
    end;
    Image.Canvas.MoveTo(Round(X / TrackBar.Position), Round(Y / TrackBar.Position));
    MClick := True;
    MPoint.X1 := Round(X / TrackBar.Position);
    MPoint.Y1 := Round(Y / TrackBar.Position);

    if (ButtonPipette.Down) and (Shift = [ssLeft]) then
    begin
        PaintForm.LShape.Brush.Color :=
          Canva.Canvas.Pixels[X, Y];
    end;

    if (ButtonPipette.Down) and (Shift = [ssRight]) then
    begin
        PaintForm.RShape.Brush.Color :=
          Canva.Canvas.Pixels[X, Y];
    end;

    if (ButtonBrush.Down) and (Shift = [ssLeft]) then
    begin
        BrushPainting(LShape.Brush.Color);
    end;

    if (ButtonBrush.Down) and (Shift = [ssRight]) then
    begin
        BrushPainting(RShape.Brush.Color);
    end;

    if FDrag and (ButtonDrag.Down) and (MClick) then
    begin
        Image.Assign(TempImg);
        TempImg.Free;
        Delete;
        CopyAndPush;
    end;

    if (ButtonHighlight.Down) and (FCopy) then
    begin
        Image.Assign(TempImg);
        TempImg.Free;
        FCopy := False;
    end;
    if FCopy then
        FCopy := False;
   CanvaMouseMove(Sender,Shift,X,Y);
end;

procedure TPaintForm.DrawPencil(Color : TColor);
Begin
    Image.Canvas.Pen.Style := psSolid;
    Image.Canvas.Pen.Color := Color;
    Image.Canvas.Pen.Width := Size;
    Image.Canvas.LineTo(MPoint.X2, MPoint.Y2);
End;

procedure TPaintForm.EditPercentChange(Sender: TObject);
begin
    Percent := StrToInt(EditPercent.Text);
end;

procedure TPaintForm.Erase();
Begin
    Image.Canvas.Pen.Color := clWhite;
    Image.Canvas.Pen.Width := Size;
    Image.Canvas.LineTo(MPoint.X2, MPoint.Y2);
End;

procedure TPaintForm.Darker(X, Y : Integer);
var
    R, G, B : Byte;
    I, J, Temp : Integer;
begin
    Temp := Round(Size/2);
    Dec(X, Temp);
    Dec(Y, Temp);
    for I := 0 to Size do
    begin
        for J := 0 to Size do
        begin
            if sqr(I - Temp)+sqr(J - Temp) < sqr(Temp) - 1 then
            begin
                R := GetRValue(Image.Canvas.Pixels[X + I, Y + J]);
                G := GetGValue(Image.Canvas.Pixels[X + I, Y + J]);
                B := GetBValue(Image.Canvas.Pixels[X + I, Y + J]);
                R := R - Muldiv(R, Percent, 5000);
                G := G - Muldiv(G, Percent, 5000);
                B := B - Muldiv(B, Percent, 5000);
                Image.Canvas.Pixels[X + I, Y + J] := RGB(R, G, B);
            end;
        end;
    end;
end;

procedure TPaintForm.DefineRectangle;
begin
    if (MPoint.X1 > MPoint.X2) and (MPoint.Y1 < MPoint.Y2) then
    begin
        BmpSize.Create(MPoint.X2, MPoint.Y1, MPoint.X1, MPoint.Y2);
    end
    else if (MPoint.X1 < MPoint.X2) and (MPoint.Y1 > MPoint.Y2) then
    begin
        BmpSize.Create(MPoint.X1, MPoint.Y2, MPoint.X2, MPoint.Y1);
    end
    else if (MPoint.X1 > MPoint.X2) and (MPoint.Y1 > MPoint.Y2) then
    begin
        BmpSize.Create(MPoint.X2, MPoint.Y2, MPoint.X1, MPoint.Y1);
    end
    else
    begin
        BmpSize.Create(MPoint.X1, MPoint.Y1, MPoint.X2, MPoint.Y2);
    end;
end;

procedure TPaintForm.Delete();
begin
    FSave := False;
    CopyAndPush;
    With Image do
    begin
        Canvas.Brush.Color := clWhite;
        Canvas.Brush.Style := bsSolid;
        Canvas.FillRect(BmpSize);
    end;
    CheckStack;
end;

procedure TPaintForm.DrawLine(Color : TColor);
begin
    Image.Canvas.StretchDraw(Image.Canvas.ClipRect, BackImageStack.Top);
    Image.Canvas.Pen.Color := Color;
    Image.Canvas.Pen.Width := Size;
    Image.Canvas.MoveTo(Round(MPoint.X1), MPoint.Y1);
    Image.Canvas.LineTo(MPoint.X2, MPoint.Y2);
end;

procedure TPaintForm.CanvaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
    Temp, TempX, TempY : Integer;
begin
    CanvaPaint(Sender);
    if MClick then
    begin
        MPoint.X2 := Round(X/TrackBar.Position);
        MPoint.Y2 := Round(Y/TrackBar.Position);
    end;
    if (ButtonBlur.Down) and (MClick) then
    begin
        Blur(MPoint.X2, MPoint.Y2);
    end;
    if (ButtonHand.Down) and (MClick) then
    begin
        ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position + (MPoint.x1 - Round(x/TrackBar.Position));
        ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + (MPoint.y1 - Round(y/TrackBar.Position));
    end;
    if (ButtonPaintcan.Down) and (Shift = [ssLeft]) then
    begin
        SprayPaint(Round(X/TrackBar.Position), Round(Y/TrackBar.Position), LShape.Brush.Color);
    end;
    if (ButtonPaintcan.Down) and (Shift = [ssRight]) then
    begin
        SprayPaint(Round(X/TrackBar.Position), Round(Y/TrackBar.Position), RShape.Brush.Color);
    end;
    if (ButtonPipette.Down) and (Shift = [ssLeft]) then
    begin
        PaintForm.LShape.Brush.Color :=
          Canva.Canvas.Pixels[X, Y];
    end;
    if (ButtonPipette.Down) and (Shift = [ssRight]) then
    begin
        PaintForm.RShape.Brush.Color :=
          Canva.Canvas.Pixels[X, Y];
    end;
    if (Shift = [ssLeft]) and (ButtonPencil.Down) then
    begin
        DrawPencil(LShape.Brush.Color);
    end;
    if (Shift = [ssRight]) and (ButtonPencil.Down) then
    begin
        DrawPencil(RShape.Brush.Color);
    end;
    if (MClick) and (ButtonEraser.Down) then
    begin
        Erase();
    end;
    if (MClick) and (ButtonRectangle.Down) then
    begin
        DrawRectangle();
    end;
    if (MClick) and (ButtonOval.Down) then
    begin
        DrawOval();
    end;
    if (MClick) and (ButtonLine.Down) and (Shift = [ssRight]) then
    begin
        DrawLine(RShape.Brush.Color);
    end;
    if (MClick) and (ButtonLine.Down) and (Shift = [ssLeft]) then
    begin
        DrawLine(LShape.Brush.Color);
    end;
    if (MClick) and (ButtonDrag.Down) and (FStart) then
    begin
        SelectSquare;
    end;
    if FDrag and (ButtonDrag.Down) and (MClick) then
    begin
        Image.Canvas.StretchDraw(Image.Canvas.ClipRect, BackImageStack.Top);
        Image.Canvas.Draw(MPoint.X2, MPoint.Y2, Bmp);
    end;
    if ((ButtonDelete.Down) )and (MClick) and (Shift = [ssLeft]) then
    begin
        SelectSquare;
    end;
    if ((ButtonHighlight.Down) )and (MClick) and (Shift = [ssLeft]) then
    begin
        SelectSquare;
    end;
    if ((ButtonLighter.Down) )and (MClick) then
    begin
        Lighter(MPoint.X2, MPoint.Y2);
    end;
    if ((ButtonDarker.Down) )and (MClick) then
    begin
        Darker(MPoint.X2, MPoint.Y2);
    end;
end;

procedure TPaintForm.CanvaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    MPoint.X2 := Round(X/TrackBar.Position);
    MPoint.Y2 := Round(Y/TrackBar.Position);
    MClick := False;

    if FDrag and ButtonDrag.Down then
    begin
        Bmp.Free;
        FDrag := False;
        FStart := True;
        BackImageStack.Pop;
    end;

    if FSelect and ButtonHighlight.Down then
    begin
        DefineRectangle;
        CopyBmp;
        FSelect := False;
        PopupMenu.AutoPopup := True;
        FCopy := True;
        CreateTempImg;
    end;

    if FSelect and ButtonDrag.Down then
    begin
        DefineRectangle;
        CopyBmp;
        FSelect := False;
        FDrag := True;
        FStart := False;
        FCopy := True;
        CreateTempImg;
    end;

    if FSelect and ButtonDelete.Down then
    begin
        DefineRectangle;
        CopyBmp;
        FSelect := False;
        Delete;
    end;
end;

procedure TPaintForm.CanvaPaint(Sender: TObject);
begin
    Canva.Canvas.StretchDraw(Canva.ClientRect, Image);
end;

procedure TPaintForm.CutClick(Sender: TObject);
begin
    FDelete := True;
    Delete;
    PopupMenu.AutoPopup := False;
    FSave := False;
end;

procedure TPaintForm.ClearClick();
begin
    BackImageStack.Free;
    ForwardImageStack.Free;
    BackImageStack := TIStack.Create;
    Image.Canvas.Brush.Style := bsClear;
    Image.Canvas.Brush.Color := clWhite;
    Image.Canvas.FillRect(Canva.ClientRect);
    CanvaPaint(Canva);
    ForwardImageStack := TIStack.Create;
    CheckStack;
end;

procedure TPaintForm.ClearStack;
begin
    BackImageStack.Free;
    ForwardImageStack.Free;
    BackImageStack := TIStack.Create;
    ForwardImageStack := TIStack.Create;
    CheckStack;
end;

procedure TPaintForm.OpenClick();
var
    Str : String;
begin
    if OpenPicDialog.Execute then
    begin
        SizeForm.RadioButtonCanvas.Checked := True;
        Path := OpenPicDialog.FileName;
        ClearClick();
        Str := ExtractFileExt(Path);
        if Str = '.bmp' then
            BMPToImage(Path)
        else if (Str = '.jpeg') then
            JPEGtoBMP(Path)
        else if Str = '.png' then
            BmpToPng(Path)
        else
            MessageBox(Application.Handle, PChar('Данный формат файла не поддерживается'), PChar('Ошибка'), MB_OK);
    end;

end;

procedure TPaintForm.ResizeClick();
begin
    Enabled := False;
    SizeForm.EditWidth.Text := IntToStr(Canva.ClientWidth);
    SizeForm.EditHeight.Text := IntToStr(Canva.ClientHeight);
    SizeForm.Show;
end;

procedure TPaintForm.Rotate180Click(Sender: TObject);
begin
    InsertRotatedImage(2);
end;

procedure TPaintForm.Rotate270Click(Sender: TObject);
begin
    InsertRotatedImage(3)
end;

procedure TPaintForm.Rotate90Click(Sender: TObject);
begin
    InsertRotatedImage(1);
end;

procedure TPaintForm.RotateBitmap(Rads: Single);
var
    C: Single;
    S: Single;
    Tmp: TBitmap;
    OffsetX: Single;
    OffsetY: Single;
    Points: array[0..2] of TPoint;
begin
    C := Cos(Rads);
    S := Sin(Rads);
    try
        Tmp := TBitmap.Create;
        Tmp.Width := Round(Bmp.Width * Abs(C) + Bmp.Height * Abs(S)) - 1;
        Tmp.Height := Round(Bmp.Width * Abs(S) + Bmp.Height * Abs(C)) - 1;
        OffsetX := (Tmp.Width - Bmp.Width * C + Bmp.Height * S) / 2;
        OffsetY := (Tmp.Height - Bmp.Width * S - Bmp.Height * C) / 2;
        Points[0].X := Round(OffsetX);
        Points[0].Y := Round(OffsetY);
        Points[1].X := Round(OffsetX + Bmp.Width * C);
        Points[1].Y := Round(OffsetY + Bmp.Width * S);
        Points[2].X := Round(OffsetX - Bmp.Height * S);
        Points[2].Y := Round(OffsetY + Bmp.Height * C);
        PlgBlt(Tmp.Canvas.Handle, Points, Bmp.Canvas.Handle, 0, 0, Bmp.Width,
        Bmp.Height, 0, 0, 0);
        Bmp.Assign(Tmp);
    finally
        Tmp.Free;
    end;
end;

procedure TPaintForm.JPEGtoBMP(const FileName: TFileName);
var
    Jpeg: TJPEGImage;
begin
    Jpeg := TJPEGImage.Create;
    try
        Jpeg.CompressionQuality := 100;
        Jpeg.LoadFromFile(FileName);
        SizeForm.Resize(Jpeg.Width, Jpeg.Height);
        Image.Canvas.Draw(0, 0, Jpeg)
    finally
        Jpeg.Free
    end;
end;

procedure TPaintForm.BmpToPng(const FileName : TFileName);
var
    Png: TPNGObject;
begin
    Png := TPNGObject.Create;
    try
        Png.LoadFromFile(FileName);
        SizeForm.Resize(Png.Width, Png.Height);
        with Image do
        begin
            Canvas.Draw(0, 0, Png);
        end;
    finally
        Png.Free;
    end;
end;
end.
