unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfrmtest = class(TForm)
    btnTest: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnTestClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmtest: Tfrmtest;

implementation

{$R *.dfm}

uses cue_unit;

procedure Tfrmtest.btnTestClick(Sender: TObject);
var cue:RCue;
begin
 opendialog1.InitialDir:= ExtractFilePath(application.Exename);
 if not opendialog1.execute then exit;

 if Readcue(opendialog1.filename, cue) then
 begin
   showmessage(cue.cuedatei+#13+inttostr(high(cue.entrys)+1)+' Einträge gelesen!');
 end;

end;

end.
