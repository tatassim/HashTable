unit UHelpForm;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UInfo;

type
  TfrmHelp = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    edtNumber: TEdit;
    edtPersonName: TEdit;
    edtAdress: TEdit;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    info: TInfo;
    IsView: boolean;
    procedure SetParams(AInfo: TInfo; AIsView: Boolean);

  end;

implementation

{$R *.dfm}

{ TfrmHelp }

procedure TfrmHelp.btnOKClick(Sender: TObject);
begin
  if IsView then
    ModalResult := mrOk
  else
  begin
    if trim(edtNumber.Text) = '' then
    begin
      MessageDlg('Номер телефона не может быть пустым ', mtError, [mbOk], 0);
      edtNumber.SetFocus;
      exit
    end;
    /////
    if trim(edtPersonName.Text) = '' then
    begin
      MessageDlg('У номера телефона должен быть хозяин ', mtError, [mbOk],
        0);
      edtPersonName.SetFocus;
      exit
    end;
    if trim(edtAdress.Text) = '' then
    begin
      MessageDlg('У человека не может отсутствовать адрес', mtError, [mbOk], 0);
      edtAdress.SetFocus;
      exit
    end;
    info.Number := trim(edtNumber.Text);
    info.PersonName := trim(edtPersonName.Text);
    info.Adress := trim(edtAdress.Text);
    ModalResult := mrOk
  end;
end;

procedure TfrmHelp.SetParams(AInfo: TInfo; AIsView: Boolean);
begin
  IsView := AIsView;
  if IsView then
  begin
    info := AInfo;
    edtNumber.Text := info.Number;
    edtPersonName.Text := info.PersonName;
    edtAdress.Text := info.Adress;
  end;
  edtNumber.ReadOnly := IsView;
  edtPersonName.ReadOnly := IsView;
  edtAdress.ReadOnly := IsView;
  btnCancel.Visible := not IsView;
  if IsView then
    btnOK.Left := 160
  else
    btnOK.Left := 96;
end;

end.

