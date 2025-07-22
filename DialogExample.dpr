program DialogExample;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  System.StartUpCopy,
  FMX.Forms,
  Example.Form in 'Example.Form.pas' {Form1},
  SOiS.Animator in 'SOiS.Animator.pas',
  SOiS.Dialog in 'SOiS.Dialog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
