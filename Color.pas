unit Color;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Main,
  Vcl.StdCtrls, Vcl.NumberBox, Vcl.Imaging.pngimage, System.ImageList,
  Vcl.ImgList;

type
  TColorForm = class(TForm)
    LShape: TShape;
    RShape: TShape;
    RLabel: TLabel;
    GLabel: TLabel;
    BLabel: TLabel;
    Button1: TButton;
    EditLR: TNumberBox;
    EditLG: TNumberBox;
    EditLB: TNumberBox;
    EditRR: TNumberBox;
    EditRG: TNumberBox;
    EditRB: TNumberBox;
    ColorImage: TImage;
    ButtonCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ColorImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ColorImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Define;
    procedure SetColor(FirstObj, SecondObj, ThirdObj, FourthObj : TObject);
    procedure EditLBChange(Sender: TObject);
    procedure EditLGChange(Sender: TObject);
    procedure EditLRChange(Sender: TObject);
    procedure EditRRChange(Sender: TObject);
    procedure EditRGChange(Sender: TObject);
    procedure EditRBChange(Sender: TObject);
    procedure ColorImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    FClick: Boolean;
    Png: TPNGObject;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColorForm: TColorForm;

implementation

{$R *.dfm}

procedure TColorForm.SetColor(FirstObj, SecondObj, ThirdObj, FourthObj : TObject);
begin
    (FirstObj as TShape).Brush.Color := RGB(
    StrToInt((SecondObj as TNumberBox).Text),
    StrToInt((ThirdObj as TNumberBox).Text),
    StrToInt((FourthObj as TNumberBox).Text)
    );
end;

procedure TColorForm.Define;
begin
    EditLR.Text := IntToStr(GetRValue(LShape.Brush.Color));
    EditLG.Text := IntToStr(GetGValue(LShape.Brush.Color));
    EditLB.Text := IntToStr(GetBValue(LShape.Brush.Color));

    EditRR.Text := IntToStr(GetRValue(RShape.Brush.Color));
    EditRG.Text := IntToStr(GetGValue(RShape.Brush.Color));
    EditRB.Text := IntToStr(GetBValue(RShape.Brush.Color));
end;

procedure TColorForm.EditLBChange(Sender: TObject);
begin
    if EditLB.Text <> '' then
        SetColor(LShape, EditLR, EditLG, EditLB);
end;

procedure TColorForm.EditLGChange(Sender: TObject);
begin
    if EditLG.Text <> '' then
        SetColor(LShape, EditLR, EditLG, EditLB);
end;

procedure TColorForm.EditLRChange(Sender: TObject);
begin
    if EditLR.Text <> '' then
        SetColor(LShape, EditLR, EditLG, EditLB);
end;

procedure TColorForm.EditRBChange(Sender: TObject);
begin
    if EditRB.Text <> '' then
        SetColor(RShape, EditRR, EditRG, EditRB);
end;

procedure TColorForm.EditRGChange(Sender: TObject);
begin
    if EditRG.Text <> '' then
        SetColor(RShape, EditRR, EditRG, EditRB);
end;

procedure TColorForm.EditRRChange(Sender: TObject);
begin
    if EditRR.Text <> '' then
        SetColor(RShape, EditRR, EditRG, EditRB);
end;

procedure TColorForm.Button1Click(Sender: TObject);
begin
    PaintForm.LShape.Brush.Color := ColorForm.LShape.Brush.Color;
    PaintForm.RShape.Brush.Color := ColorForm.RShape.Brush.Color;
    PaintForm.Enabled := True;
    Close();
end;

procedure TColorForm.ButtonCancelClick(Sender: TObject);
begin
    PaintForm.Enabled := True;
    Close;
end;

procedure TColorForm.ColorImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    FCLick := True;
    if (Shift = [ssLeft]) then
    begin
       ColorForm.LShape.Brush.Color := ColorImage.Picture.Bitmap.Canvas.Pixels[X, Y];
    end;
    if (Shift = [ssRight]) then
    begin
       ColorForm.RShape.Brush.Color := ColorImage.Picture.Bitmap.Canvas.Pixels[X, Y];
    end;
    Define;
end;

procedure TColorForm.ColorImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if FCLick then
    begin
    if (Shift = [ssLeft]) then
    begin
       ColorForm.LShape.Brush.Color := ColorImage.Picture.Bitmap.Canvas.Pixels[X, Y];
    end;
    if (Shift = [ssRight]) then
    begin
        ColorForm.RShape.Brush.Color := ColorImage.Picture.Bitmap.Canvas.Pixels[X, Y];
    end;
    Define;
    end;
end;

procedure TColorForm.ColorImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    FClick := False;
end;

procedure TColorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    PaintForm.Enabled := True;
end;

procedure TColorForm.FormCreate(Sender: TObject);
begin
    ColorImage.Transparent := True;
    ColorImage.Picture.Bitmap.TransparentColor := clBlack;
    if FileExists('color.bmp') then
    begin
        ColorImage.Picture.Bitmap.LoadFromFile('color.bmp');
    end
    else
    begin
        MessageBox(Application.Handle,
          PChar('Ошибка загрузки ресурсов.'), PChar('Ошибка'), MB_OK);
        Application.Terminate;
    end;
end;
procedure TColorForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
    If Msg.CharCode = 27 then
    begin
        ButtonCancelClick(ButtonCancel);
    end;

    If Msg.CharCode = 12 then
    begin
        Button1Click(Button1);
    end;
end;

end.
