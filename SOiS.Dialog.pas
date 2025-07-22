unit SOiS.Dialog;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.Types,
  System.Threading,
  FMX.Objects,
  FMX.Ani,
  FMX.Types,
  FMX.Effects,
  FMX.Forms,
  FMX.Layouts,
  FMX.Graphics,
  FMX.Controls,
  SOiS.Animator;

type
  IDialogAnimation = interface;

  IDialog = Interface
    ['{CAD5936B-62BA-43AD-ADFD-252442003A7F}']
    function GetCurtain: TRectangle;
    function GetStage: TRectangle;
    function GetContent: TLayout;
    function GetInvoker: TFmxObject;
    function GetInvokerBounds: TRectF;
    function Title(const Text: String): IDialog;
    function OnShow(AProc: TProc<IDialog>): IDialog;
    function OnClose(AProc: TProc<IDialog>): IDialog;
    function OnCurtainClick(AProc: TProc<IDialog>): IDialog;
    function Show(Animation: IDialogAnimation): IDialog;
    function Close: IDialog;

    property Curtain: TRectangle read GetCurtain;
    property Stage: TRectangle read GetStage;
    property Content: TLayout read GetContent;
    property Invoker: TFmxObject read GetInvoker;
    property InvokerBounds: TRectF read GetInvokerBounds;

  end;

  IDialogAnimation = interface
    ['{CC194A22-C6AC-498C-AAFA-C7A5FEF66B61}']
    function ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
    function CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
  end;

  TDAFade = class(TInterfacedObject, IDialogAnimation)
  private
    FEffect: Boolean;
    FGlow: TGlowEffect;
  public
    function ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
    function CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;

    constructor Create(AGlowEffect: Boolean=True);
  end;

  TDASlide = class(TInterfacedObject, IDialogAnimation)
  private
    FEffect: Boolean;
    FGlow: TGlowEffect;
  public
    function ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
    function CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;

    constructor Create(AGlowEffect: Boolean=True);
  end;

  TDAPopup = class(TInterfacedObject, IDialogAnimation)
  private
    FEffect: Boolean;
    FGlow: TGlowEffect;
  public
    function ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
    function CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;

    constructor Create(AGlowEffect: Boolean=True);
  end;

  TDialog = class(TComponent, IDialog)
  private
    FCurtain: TRectangle;
    FStage: TRectangle;
    FContentBKP: TLayout;
    FContent: TLayout;
    FTitle: String;
    FInvoker: TFmxObject;
    FInvokerBounds: TRectF;
    FTitleObj: TText;
    FAnimation: IDialogAnimation;
    FOnClose: TProc<IDialog>;
    FOnShow: TProc<IDialog>;
    FOnCurtainClick: TProc<IDialog>;
    function GetParentForm(Control: TFmxObject): TForm;
  strict private
    constructor Create(AInvoker: TFmxObject; AContent: TLayout); overload;
  protected
    function GetCurtain: TRectangle;
    function GetStage: TRectangle;
    function GetContent: TLayout;
    function GetInvoker: TFmxObject;
    function GetInvokerBounds: TRectF;
    procedure DoCurtainClick(Sender: TObject);
  public
    function Title(const Text: String): IDialog;
    function OnShow(AProc: TProc<IDialog>): IDialog;
    function OnClose(AProc: TProc<IDialog>): IDialog;
    function OnCurtainClick(AProc: TProc<IDialog>): IDialog;
    function Show(Animation: IDialogAnimation): IDialog;
    function Close: IDialog;

    class function New(AInvoker: TFmxObject; AContent: TLayout): IDialog; overload;

    property Curtain: TRectangle read GetCurtain;
    property Stage: TRectangle read GetStage;
    property Content: TLayout read GetContent;
    property Invoker: TFmxObject read GetInvoker;
    property InvokerBounds: TRectF read GetInvokerBounds;
  end;


implementation

{ TDASlide }

function TDASlide.CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
var
  LPosX: Single;
begin
  LPosX := ADialog.InvokerBounds.Left + ADialog.InvokerBounds.Width + 20;

  if FEffect then
    TSOAnimator.Animate(FGlow, 'Opacity', 0, 0.4).Start;

  TSOAnimator.Animate(ADialog.Stage, 'Position.X', LPosX, 0.5)
    .Delay(0.4)
    .AnimationType(TAnimationType.In)
    .Interpolation(TInterpolationType.Back)
    .Start;
  TSOAnimator.Animate(ADialog.Stage, 'Opacity', 0, 0.7)
    .Delay(0.6)
    .AnimationType(TAnimationType.Out)
    .Interpolation(TInterpolationType.cubic)
    .Start;
  TSOAnimator.Animate(ADialog.Curtain, 'Opacity', 0, 0.4)
    .Delay(1)
    .OnFinish(AFinish)
    .Start;

  Log.d(Format('[%s.Close] From %2.f To %2.f', [Self.ClassName, ADialog.Stage.Position.X, LPosX]));
end;

constructor TDASlide.Create(AGlowEffect: Boolean);
begin
  inherited Create;

  FEffect := AGlowEffect;
end;

function TDASlide.ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
var
  LPosX: Single;
  procedure Prepare;
  begin
    With ADialog do begin
      LPosX := InvokerBounds.Left + (InvokerBounds.Width/2 - Stage.Width/2);
      Curtain.Opacity := 0.01;
      Curtain.Visible := True;
      Content.Visible := True;
      Stage.Opacity := 1;
      Stage.Align := TAlignLayout.None;
      Stage.Position.X := InvokerBounds.Left + InvokerBounds.Width + 20;
      Stage.Position.Y := InvokerBounds.Top + (InvokerBounds.Height/2 - Stage.Height/2);
      Stage.Opacity := 0.01;
      Stage.Visible := True;

      if FEffect then begin
        FGlow := TGlowEffect.Create(Stage);
        FGlow.Softness := 3;
        FGlow.Opacity  := 0;
        FGlow.GlowColor := TalphaColors.Gray;
        FGlow.Parent := Stage;
        FGlow.Enabled := true;
      end;
    end;
  end;
begin
  Prepare;

  TSOAnimator.Animate(ADialog.Curtain, 'opacity', 0.8, 0.4).Start;

  TSOAnimator.Animate(ADialog.Stage, 'Position.X', LPosX, 0.5)
      .Delay(0.5)
      .AnimationType(TAnimationType.Out)
      .Interpolation(TInterpolationType.Back)
      .Start;

  TSOAnimator.Animate(ADialog.Stage, 'opacity', 1, 0.7)
      .Delay(0.5)
      .AnimationType(TAnimationType.Out)
      .Interpolation(TInterpolationType.cubic)
      .OnFinish(AFinish)
      .Start;

  if FEffect then
    TSOAnimator.Animate(FGlow, 'opacity', 0.8, 2)
        .Delay(2)
        .AnimationType(TAnimationType.Out)
        .Interpolation(TInterpolationType.Bounce)
        .Start;

  Log.d(Format('[%s.Show] From %2.f To %2.f', [Self.ClassName, ADialog.Stage.Position.X, LPosX]));
end;

{ TDAPopup }

function TDAPopup.CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
begin
  if FEffect then
    TSOAnimator.Animate(FGlow, 'Opacity', 0, 0.4).Start;

  TSOAnimator.Animate(ADialog.Stage, 'Scale.x', 0, 0.7)
    .Delay(0.4)
    .AnimationType(TAnimationType.Out)
    .Interpolation(TInterpolationType.Bounce)
    .OnProcess(procedure (Obj: TFmxObject) begin
      ADialog.Stage.Scale.Y := ADialog.Stage.Scale.X;
      ADialog.Stage.Position.X := ADialog.InvokerBounds.Left + (ADialog.InvokerBounds.Width/2 - (ADialog.Stage.Width*ADialog.Stage.Scale.X) /2);
      ADialog.Stage.Position.Y := ADialog.InvokerBounds.Top + (ADialog.InvokerBounds.Height/2 - (ADialog.Stage.Height*ADialog.Stage.Scale.X) /2);
    end)
    .Start;

  TSOAnimator.Animate(ADialog.Curtain, 'Opacity', 0, 0.4)
    .Delay(0.7)
    .OnFinish(AFinish)
    .Start;

  Log.d(Format('[%s.Close] From %2.f To %2.f', [Self.ClassName, ADialog.Stage.Scale.X, 0.0]));
end;

constructor TDAPopup.Create(AGlowEffect: Boolean);
begin
  inherited Create;
  FEffect := AGlowEffect;
end;

function TDAPopup.ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
  procedure Prepare;
  begin
    with ADialog do begin
      Curtain.Opacity := 0.01;
      Content.Visible := True;
      Stage.Position.X := InvokerBounds.Left + (InvokerBounds.Width/2 - (Stage.Width*0.01) /2);
      Stage.Position.Y := InvokerBounds.Top + (InvokerBounds.Height/2 - (Stage.Height*0.01) /2);
      Stage.Scale.X := 0.01;
      Stage.Scale.Y := 0.01;
    end;

    if FEffect then begin
      FGlow := TGlowEffect.Create(ADialog.Stage);
      FGlow.Softness := 3;
      FGlow.Opacity  := 0;
      FGlow.GlowColor := TalphaColors.Gray;
      FGlow.Parent := ADialog.Stage;
      FGlow.Enabled := true;
    end;
  end;
begin
  Prepare;

  TSOAnimator.Animate(ADialog.Curtain, 'Opacity', 0.8, 0.4).Start;

  TSOAnimator.Animate(ADialog.Stage, 'Scale.x', 1, 0.5)
    .Delay(0.4)
    .AnimationType(TAnimationType.Out)
    .Interpolation(TInterpolationType.Back)
    .OnFinish(AFinish)
    .OnProcess(procedure (Obj: TFmxObject) begin
      ADialog.Stage.Scale.Y := ADialog.Stage.Scale.X;
      ADialog.Stage.Position.X := ADialog.InvokerBounds.Left + (ADialog.InvokerBounds.Width/2 - (ADialog.Stage.Width*ADialog.Stage.Scale.X) /2);
      ADialog.Stage.Position.Y := ADialog.InvokerBounds.Top + (ADialog.InvokerBounds.Height/2 - (ADialog.Stage.Height*ADialog.Stage.Scale.X) /2);
    end)
    .Start;

  if FEffect then
    TSOAnimator.Animate(FGlow, 'opacity', 0.8, 2)
        .Delay(2)
        .AnimationType(TAnimationType.Out)
        .Interpolation(TInterpolationType.Bounce)
        .Start;

  Log.d(Format('[%s.Show] From %2.f To %2.f', [Self.ClassName, ADialog.Stage.Scale.X, 1.0]));
end;

{ TDialog }

function TDialog.Close: IDialog;
var
  Ani: TSOAnimator;
  Form: TForm;
begin
  Result := Self;

  if Self.FOnClose<>nil then
    Self.FOnClose(self);

  FAnimation.CloseAnimation(self,
    procedure (Obj: TFmxObject) begin
      FStage.Visible   := False;
      FCurtain.Visible := False;

      with FContent do begin
        Align      := FContentBKP.Align;
        Parent     := FContentBKP.Parent;
        Position.X := FContentBKP.Position.X;
        Position.Y := FContentBKP.Position.Y;
        Height     := FContentBKP.Height;
        Width      := FContentBKP.Width;
        Visible    := FContentBKP.Visible;
      end;
      FContentBKP.Free;
      FContentBKP := nil;
      Abort;
    end);

end;

function TDialog.GetCurtain: TRectangle;
begin
  Result := FCurtain;
end;

constructor TDialog.Create(AInvoker: TFmxObject; AContent: TLayout);
var
  LBounds: TRectF;
  LParent: TFmxObject;
  procedure Prepare;
  begin
    if FInvoker is TForm then  LParent := FInvoker
    else                       LParent := FInvoker.Parent;

    FCurtain.Parent:=LParent;
    FCurtain.BoundsRect := InvokerBounds;

    FCurtain.Fill.Color := TAlphacolors.Black;
    FCurtain.OnClick := DoCurtainClick;

    FStage.Parent := LParent;
    FStage.Fill.Color := TAlphaColors.White;
    FStage.Stroke.Kind := TBrushKind.None;
    FStage.XRadius:=3;
    FStage.YRadius:=3;
    FStage.Width := FContent.Width + 10;
    FStage.Height := FContent.Height +10;

    FContent.Parent := FStage;
    FContent.Align := TAlignLayout.Center; // por causa da margem
  end;
begin
  if AContent = nil then raise Exception.Create(Format('[%s] View could not be NIL.',[UpperCase(Name)]));

  if AInvoker is TForm then begin
    LBounds := TRectF.Create(0, 0, TForm(AInvoker).Width, TForm(AInvoker).Height);
  end;

  if AInvoker is TControl then begin
    LBounds := TControl(AInvoker).BoundsRect;
  end;

  inherited Create(Application.MainForm);

  FInvokerBounds := LBounds;
  FInvoker := AInvoker;
  FCurtain := TRectangle.Create(Self);
  FStage := TRectangle.Create(Self);
  FContent := AContent;

  TFmxObject(FContentBKP) := FContent.Clone(FContent.Owner);
  FContentBKP.Parent := FContent.Parent;
  FContentBKP.Align := FContent.Align;

  Prepare;

  Log.d(Format('[%s] Create', [AInvoker.Classname]));
end;

procedure TDialog.DoCurtainClick(Sender: TObject);
begin
  if Assigned(FOnCurtainClick) then
    FOnCurtainClick(self);
end;

function TDialog.GetInvoker: TFmxObject;
begin
  Result := FInvoker;
end;

function TDialog.GetInvokerBounds: TRectF;
begin
  Result := FInvokerBounds;
end;

function TDialog.GetParentForm(Control: TFmxObject): TForm;
begin
  Result := nil;
  while Assigned(Control) do
  begin
    if Control is TForm then
    begin
      Result := TForm(Control);
      Exit;
    end;
    Control := Control.Parent;
  end;
end;

function TDialog.GetContent: TLayout;
begin
  Result := FContent;
end;

function TDialog.OnClose(AProc: TProc<IDialog>): IDialog;
begin
  Result := Self;
  FOnClose := AProc;
end;

function TDialog.OnCurtainClick(AProc: TProc<IDialog>): IDialog;
begin
  Result := Self;
  FOnCurtainClick := AProc;
end;

function TDialog.OnShow(AProc: TProc<IDialog>): IDialog;
begin
  Result := Self;
  FOnShow := AProc;
end;

function TDialog.Show(Animation: IDialogAnimation): IDialog;
var
  ani: TAnimation;
begin
  Result := Self;
  FAnimation := Animation;

  FAnimation.ShowAnimation(self, procedure (Obj: TFmxObject) begin
    if Self.FOnShow<>nil then
       Self.FOnShow(self);
  end);
end;

function TDialog.GetStage: TRectangle;
begin
  Result := FStage;
end;

class function TDialog.New(AInvoker: TFmxObject; AContent: TLayout): IDialog;
begin
  Result := Create(AInvoker, AContent);
end;

function TDialog.Title(const Text: String): IDialog;
begin
  Result := Self;

  if Assigned(FTitleObj) then
     FreeAndNil(FTitleObj);
  if Text <> EmptyStr then begin
    FTitleObj := TText.Create(FStage);
    FTitleObj.Parent := FStage;
    FTitleObj.TextSettings.WordWrap := False;
    FTitleObj.AutoSize := True;
    FTitleObj.TextSettings.Font.Size := 14;
    FTitleObj.TextSettings.Font.Style := [TFontStyle.fsBold];
    FTitleObj.TextSettings.FontColor := TAlphaColors.White;
    FTitleObj.Text := Text;
    FTitleObj.Opacity := 0.9;
    FTitleObj.Position.X := 0;
    FTitleObj.Position.Y := -FTitleObj.Height-5;
  end

end;
{ TDAFade }

function TDAFade.CloseAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
begin
  if FEffect then
    TSOAnimator.Animate(FGlow, 'Opacity', 0, 0.3).Start;

  TSOAnimator.Animate(ADialog.Stage, 'Opacity', 0, 0.5)
    .Delay(0.2)
    .AnimationType(TAnimationType.Out)
    .Interpolation(TInterpolationType.cubic)
    .Start;
  TSOAnimator.Animate(ADialog.Curtain, 'Opacity', 0, 0.4)
    .Delay(0.3)
    .OnFinish(AFinish)
    .Start;

  Log.d(Format('[%s.Close] (OPACITY) From %2.f To %2.f', [Self.ClassName, 1.0, 0.0]));

end;

constructor TDAFade.Create(AGlowEffect: Boolean);
begin
  FEffect := AGlowEffect;
end;

function TDAFade.ShowAnimation(ADialog: IDialog; AFinish: TProc<TFmxObject>): TAnimator;
  procedure Prepare;
  begin
    With ADialog do begin
      Curtain.Opacity := 0.01;
      Curtain.Visible := True;
      Content.Visible := True;
      Stage.Opacity := 1;
      Stage.Align := TAlignLayout.None;
      Stage.Position.X := InvokerBounds.Left + (InvokerBounds.Width/2 - Stage.Width/2);
      Stage.Position.Y := InvokerBounds.Top + (InvokerBounds.Height/2 - Stage.Height/2);
      Stage.Opacity := 0.01;
      Stage.Visible := True;

      if FEffect then begin
        FGlow := TGlowEffect.Create(Stage);
        FGlow.Softness := 3;
        FGlow.Opacity  := 0;
        FGlow.GlowColor := TalphaColors.Gray;
        FGlow.Parent := Stage;
        FGlow.Enabled := true;
      end;
    end;
  end;
begin
  Prepare;

  TSOAnimator.Animate(ADialog.Curtain, 'opacity', 0.8, 0.5).Start;

  TSOAnimator.Animate(ADialog.Stage, 'opacity', 1, 0.5)
      .Delay(0.4)
      .AnimationType(TAnimationType.Out)
      .Interpolation(TInterpolationType.cubic)
      .OnFinish(AFinish)
      .Start;

  if FEffect then
    TSOAnimator.Animate(FGlow, 'opacity', 0.8, 2)
        .Delay(1)
        .AnimationType(TAnimationType.Out)
        .Interpolation(TInterpolationType.Bounce)
        .Start;

  Log.d(Format('[%s.Show] (OPACITY) From %2.f To %2.f', [Self.ClassName, 0.01, 1.0]));
end;

end.
