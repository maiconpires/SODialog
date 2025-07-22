unit SOiS.Animator;

interface

uses
  FMX.Ani,
  FMX.Types,
  FMX.StdCtrls,
  System.SysUtils;

type
  TSOAnimator = class(TFloatAnimation)
  private
    FTerminate: Boolean;
    FOnFinish: TProc<TFmxObject>;
    FOnProgress: TProc<TFmxObject>;

    procedure DoFinish(Sender: TObject);
    procedure DoProcess(Sender: TObject);
  public
    function OnFinish(const AProc: TProc<TFmxObject>): TSOAnimator;
    function OnProcess(const AProc: TProc<TFmxObject>): TSOAnimator;
    function AutoReverse(const AValue: Boolean): TSOAnimator;
    function Delay(const AValue: Single): TSOAnimator;
    function Interpolation(const AValue: TInterpolationType): TSOAnimator;
    function AnimationType(const AValue: TAnimationType): TSOAnimator;
    function Loop(const AValue: Boolean): TSOAnimator;
    function StartValue(const AValue: Single): TSOAnimator;
    function StartFromCurrent(const AValue: Boolean): TSOAnimator;
    function Inverse(const AValue: Boolean): TSOAnimator;
    function FreeOnTerminate(const AValue: Boolean): TSOAnimator; overload;
    function FreeOnTerminate: Boolean; overload;
    function Start: TSOAnimator;
    function Stop: TSOAnimator;
    constructor Animate(const AObject: TFmxObject; const AProperty: String; const AValue: Single; const ADuration: Single);
  end;

implementation

{ TSOAnimator }

constructor TSOAnimator.Animate(const AObject: TFmxObject;
  const AProperty: String; const AValue, ADuration: Single);
begin
  inherited Create(AObject);

  inherited OnFinish := DoFinish;
  inherited OnProcess:= DoProcess;
  inherited StartFromCurrent := True;

  FTerminate       := True;
  PropertyName     := AProperty;
  StopValue        := AValue;
  Duration         := ADuration;
  Parent           := AObject;
end;

function TSOAnimator.AnimationType(const AValue: TAnimationType): TSOAnimator;
begin
  Result := Self;
  inherited AnimationType := AValue;
end;

function TSOAnimator.AutoReverse(const AValue: Boolean): TSOAnimator;
begin
  Result := Self;
  inherited AutoReverse := AValue;
end;

function TSOAnimator.Delay(const AValue: Single): TSOAnimator;
begin
  Result := Self;
  inherited Delay:=AValue;
end;

procedure TSOAnimator.DoFinish(Sender: TObject);
begin
  if Assigned(FOnFinish) then
    FOnFinish(FParent);

  if FTerminate then begin
    Self.Free;
    Self := nil;
  end;
end;

procedure TSOAnimator.DoProcess(Sender: TObject);
begin
  if Assigned(FOnProgress) then
    FOnProgress(FParent);
end;

function TSOAnimator.FreeOnTerminate: Boolean;
begin
  Result := Fterminate;
end;

function TSOAnimator.FreeOnTerminate(const AValue: Boolean): TSOAnimator;
begin
  Result := Self;
  FTerminate := AValue;
end;

function TSOAnimator.Interpolation(
  const AValue: TInterpolationType): TSOAnimator;
begin
  Result := Self;
  inherited Interpolation := AValue;
end;

function TSOAnimator.Loop(const AValue: Boolean): TSOAnimator;
begin
  Result := Self;
  inherited Loop := AValue;
end;

function TSOAnimator.OnFinish(const AProc: TProc<TFmxObject>): TSOAnimator;
begin
  Result := Self;
  FOnFinish := AProc;
end;

function TSOAnimator.OnProcess(const AProc: TProc<TFmxObject>): TSOAnimator;
begin
  Result := Self;
  FOnProgress := AProc;
end;

function TSOAnimator.Inverse(const AValue: Boolean): TSOAnimator;
begin
  Result := Self;
  inherited Inverse := AValue;
end;

function TSOAnimator.Start: TSOAnimator;
begin
  Result := Self;
//  inherited Start;
  inherited Enabled := True;
end;

function TSOAnimator.StartFromCurrent(const AValue: Boolean): TSOAnimator;
begin
  Result := Self;
  inherited StartFromCurrent := AValue;
end;

function TSOAnimator.StartValue(const AValue: Single): TSOAnimator;
begin
  Result := Self;
  inherited StartFromCurrent := False;
  inherited StartValue := AValue;
end;

function TSOAnimator.Stop: TSOAnimator;
begin
  Result := Self;
  inherited Stop;
end;

end.
