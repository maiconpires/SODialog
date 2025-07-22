# SODialog
A universal dialog creator that allows you to create a "popup" from a TLayout, TRectangle, TScrollBox, etc.
## ⚡️ Library Import
```delphi
uses SOiS.Dialog;
```

## ⚡️ Variable Declaration
```delphi
var
  D: IDialog;
```

## ⚡️ Show Event
```delphi
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
      end)
      .OnCurtainClick(procedure (Dialog: IDialog) begin
        Dialog.Close;
        D := nil;
      end)
      .Show(TDASlide.Create(False));
```

## ⚡️ Close Event
```delphi
if D <> nil then begin
  D.Close;
  D := nil;
end;
```
