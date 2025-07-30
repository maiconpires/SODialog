unit Example.Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SOiS.Dialog,
  FMX.Edit, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox;

type
  TForm1 = class(TForm)
    lstDescricoes: TListBox;
    btnDialog1: TButton;
    Dialog1: TRectangle;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    edtDescricao1: TEdit;
    btnOk1: TButton;
    btnCancel1: TButton;
    btnDialog2: TButton;
    Dialog2: TRectangle;
    btnCancel2: TButton;
    btnOk2: TButton;
    edtDescricao2: TEdit;
    Label2: TLabel;
    btnDialog3: TButton;
    procedure btnDialog1Click(Sender: TObject);
    procedure btnOk1Click(Sender: TObject);
    procedure btnCancel1Click(Sender: TObject);
    procedure btnOk2Click(Sender: TObject);
    procedure btnCancel2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDialog3Click(Sender: TObject);
    procedure btnDialog2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  D: IDialog;

implementation

{$R *.fmx}

procedure TForm1.btnCancel1Click(Sender: TObject);
begin
  if D <> nil then begin
    Showmessage('Cancel Click');
    edtDescricao1.Text := EmptyStr;
    D.Close;
  end;
end;

procedure TForm1.btnCancel2Click(Sender: TObject);
begin
  if D <> nil then begin
    Showmessage('Cancel Click');
    edtDescricao2.Text := EmptyStr;
    D.Close;
  end;
end;

procedure TForm1.btnOk1Click(Sender: TObject);
begin
  if D <> nil then begin
    D.Close;
  end;
end;

procedure TForm1.btnOk2Click(Sender: TObject);
begin
  if D <> nil then begin
    D.Close;
  end;
end;

procedure TForm1.btnDialog1Click(Sender: TObject);
begin
  D := TDialog
        .New(lstDescricoes, TLayout(Dialog1))
        .Title('Dialog 1')
        .OnShow(procedure (Dialog: IDialog) begin
          btnOk1.Default := True;
          btnCancel1.Cancel := True;
          edtDescricao1.SetFocus;
        end)
        .OnClose(procedure (Dialog: IDialog) begin
          if not edtDescricao1.Text.Trim.IsEmpty then
            lstDescricoes.Items.Add(edtDescricao1.Text);
          edtDescricao1.Text := EmptyStr;
          btnOk1.Default := False;
          btnCancel1.Cancel := False;
          D := nil;
        end)
        .OnCurtainClick(procedure (Dialog: IDialog) begin
          Dialog.Close;
          D := nil;
        end)
        .Show(TDASlide.Create(False));
end;

procedure TForm1.btnDialog2Click(Sender: TObject);
begin
  D := TDialog
        .New(lstDescricoes, TLayout(Dialog2))
        .Title('Dialog 2')
        .OnShow(procedure (Dialog: IDialog) begin
          edtDescricao2.SetFocus;
        end)
        .OnClose(procedure (Dialog: IDialog) begin
          if not edtDescricao2.Text.Trim.IsEmpty then begin
            lstDescricoes.Items.Add(edtDescricao2.Text);
            edtDescricao2.Text := EmptyStr;
          end;
          D := nil;
        end)
        .OnCurtainClick(procedure (Dialog: IDialog) begin
          Dialog.Close;
          D := nil;
        end)
        .Show(TDAPopup.Create(False));
end;

procedure TForm1.btnDialog3Click(Sender: TObject);
begin
  D := TDialog
        .New(Form1, TLayout(Dialog1))
        .Title('Dialog 2')
        .OnShow(procedure (Dialog: IDialog) begin
          btnOk1.Default := True;
          btnCancel1.Cancel := True;
          edtDescricao1.SetFocus;
        end)
        .OnClose(procedure (Dialog: IDialog) begin
          if not edtDescricao1.Text.Trim.IsEmpty then
            lstDescricoes.Items.Add(edtDescricao1.Text);
          edtDescricao1.Text := EmptyStr;
          btnOk1.Default := False;
          btnCancel1.Cancel := False;
          D := nil;
        end)
        .OnCurtainClick(procedure (Dialog: IDialog) begin
          Dialog.Close;
          D := nil;
        end)
        .Show(TDAFade.Create(False));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Dialog1.Visible := False;
  Dialog2.Visible := False;
end;

end.
