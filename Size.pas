unit Size;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Main, Vcl.NumberBox;

type
  TSizeForm = class(TForm)
    Button1: TButton;
    LabelWidth: TLabel;
    LabelHeight: TLabel;
    EditWidth: TNumberBox;
    EditHeight: TNumberBox;
    Label1: TLabel;
    RadioButtonCanvas: TRadioButton;
    RadioButtonPic: TRadioButton;
    ButtonCncl: TButton;
    procedure Button1Click(Sender: TObject);
    procedure EditHeightChange(Sender: TObject);
    procedure EditWidthChange(Sender: TObject);
    procedure Resize(W, H : Integer);
    procedure ButtonCnclClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    procedure CheckEdit;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SizeForm: TSizeForm;

implementation

{$R *.dfm}

procedure TSizeForm.Button1Click(Sender: TObject);
begin
    Resize(StrToInt(EditWidth.Text), StrToInt(EditHeight.Text));
    PaintForm.Enabled := True;
    PaintForm.FSave := False;
    Close;
end;

procedure TSizeForm.ButtonCnclClick(Sender: TObject);
begin
    PaintForm.Enabled := True;
    Close;
end;

procedure TSizeForm.CheckEdit;
begin
    if (EditWidth.Text ='') or (EditHeight.Text ='') then
        Button1.Enabled := False
    else
        Button1.Enabled := True;
end;

procedure TSizeForm.EditHeightChange(Sender: TObject);
begin
    CheckEdit;
end;

procedure TSizeForm.EditWidthChange(Sender: TObject);
begin
    CheckEdit;
end;

procedure TSizeForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
    If Msg.CharCode = 27 then
    begin
        ButtonCnclClick(ButtonCncl);
    end;

    If Msg.CharCode = 12 then
    begin
        Button1Click(Button1);
    end;
end;

procedure TSizeForm.Resize(W, H: Integer);
var
    Tmp : TBitmap;
begin
    try
        Tmp := TBitmap.Create();
        Tmp.Assign(PaintForm.Image);
        with PaintForm do
        begin
            Scrollbox.ClientHeight := H + SM_CYVSCROLL;
            Scrollbox.ClientWidth := W + SM_CYVSCROLL;
            Canva.ClientHeight := H;
            Canva.ClientWidth := W;
            CanvasSize.Width := W;
            CanvasSize.Height := H;
            ClientHeight := Scrollbox.Height + Panel.Height + SM_CYVSCROLL;
            ClientWidth := Scrollbox.Width + SM_CYVSCROLL;
            Image := TBitmap.Create(CanvasSize.Width, CanvasSize.Height);
            if RadioButtonCanvas.Checked then
                Image.Canvas.CopyRect(Tmp.Canvas.ClipRect, Tmp.Canvas, Tmp.Canvas.ClipRect)
            else
                Image.Canvas.StretchDraw(Image.Canvas.ClipRect, Tmp);
            FSave := False;
            ClearStack;
        end;
    finally
        Tmp.Free;
    end;
end;

end.
