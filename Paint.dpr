program Paint;

uses
  Vcl.Forms,
  Main in 'Main.pas' {PaintForm},
  Menu in 'Menu.pas' {MenuForm},
  Vcl.Themes,
  Vcl.Styles,
  Color in 'Color.pas' {ColorForm},
  Stack in 'Stack.pas',
  Shape in 'Shape.pas' {ShapeForm},
  Size in 'Size.pas' {SizeForm},
  About in 'About.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPaintForm, PaintForm);
  Application.CreateForm(TMenuForm, MenuForm);
  Application.CreateForm(TColorForm, ColorForm);
  Application.CreateForm(TShapeForm, ShapeForm);
  Application.CreateForm(TSizeForm, SizeForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
