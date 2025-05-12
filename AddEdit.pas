unit AddEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin;

type
  TFrmAddEditElement = class(TForm)
    PnExit: TPanel;
    PnEdit: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAddEditElement: TFrmAddEditElement;

implementation

{$R *.dfm}

end.
