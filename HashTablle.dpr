program HashTablle;

uses
  Forms,
  FMain in 'FMain.pas' {FormMain},
  UInfo in 'UInfo.pas',
  UHashTable in 'UHashTable.pas',
  UHashTableGUI in 'UHashTableGUI.pas',
  UHelpForm in 'UHelpForm.pas' {frmHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
