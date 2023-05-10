unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls;

type
  TMenuForm = class(TForm)
    OpenButton: TButton;
    NewButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NewButtonClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MenuForm: TMenuForm;

implementation

{$R *.dfm}

uses
    Main;

procedure TMenuForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    PaintForm.Enabled := True;
end;

procedure TMenuForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    MenuForm.Close();
end;

procedure TMenuForm.FormShow(Sender: TObject);
begin
    AlphaBlend := True;
    AlphaBlendValue := 100;
    Color := $000000;
    Height := PaintForm.Height;
    Width := PaintForm.Width;
end;

procedure TMenuForm.NewButtonClick(Sender: TObject);
begin
    Close();
end;

procedure TMenuForm.OpenButtonClick(Sender: TObject);
begin
    Close();
    PaintForm.OpenClick();
end;

end.
