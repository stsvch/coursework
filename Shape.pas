unit Shape;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Main, Vcl.ExtCtrls,
  Vcl.ToolWin, Vcl.ComCtrls;

type
  TShapeForm = class(TForm)
    SaveButton: TButton;
    ComboBoxBrush: TComboBox;
    ColorListBoxBrush: TColorListBox;
    ComboBoxPen: TComboBox;
    ColorListBoxPen: TColorListBox;
    LabelPen: TLabel;
    LabelBrush: TLabel;
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShapeForm: TShapeForm;

implementation

{$R *.dfm}

procedure TShapeForm.SaveButtonClick(Sender: TObject);
var
    Brush, Pen : Integer;
begin
    Brush := ComboboxBrush.ItemIndex;
    with PaintForm.ShapeBrush do
    begin
        Color := ColorListboxBrush.Selected;
        case Brush of
            0:
            Style := bsClear;
            1:
            Style := bsSolid;
            2:
            Style := bsBDiagonal;
            3:
            Style := bsVertical;
            4:
            Style := bsHorizontal;
            5:
            Style := bsCross;
        end;
    end;
    Pen := ComboboxPen.ItemIndex;
    with PaintForm.ShapePen do
    begin
        Color := ColorListboxPen.Selected;
        case Pen of
            0:
            Style := psSolid;
            1:
            Style := psClear;
        end;
    end;
    PaintForm.Enabled := True;
    Close();
end;

end.
