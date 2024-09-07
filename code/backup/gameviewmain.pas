{ Main view, where most of the application logic takes place.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameViewMain;

interface

uses Classes,
  CastleVectors, CastleComponentSerialize,
  CastleUIControls, CastleControls, CastleKeysMouse, CastleScene, CastleTransform;

type
  { Main view, where most of the application logic takes place. }

  { TViewMain }

  TViewMain = class(TCastleView)
  private
    BodyBola: TCastleRigidBody;
    BodyPlayer: TCastleRigidBody;
    procedure PlayerColision(const CollisionDetails: TPhysicsCollisionDetails);
    procedure PlayerCollisionExit(const CollisionDetails:
      TPhysicsCollisionDetails);
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    LabelFps: TCastleLabel;
    bola: TCastleSphere;
    player: TCastleBox;


  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: single; var HandleInput: boolean); override;
    function Press(const Event: TInputPressRelease): boolean; override;
  end;

var
  ViewMain: TViewMain;

implementation

uses SysUtils, CastleLog;

  { TViewMain ----------------------------------------------------------------- }

procedure TViewMain.PlayerColision(const CollisionDetails: TPhysicsCollisionDetails);
begin
  BodyPlayer.LinearVelocity := BodyPlayer.LinearVelocity * -1;
end;

procedure TViewMain.PlayerCollisionExit(
  const CollisionDetails: TPhysicsCollisionDetails);
begin
  BodyPlayer.LinearVelocity := Vector3(0, 0, 0);
end;

constructor TViewMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmain.castle-user-interface';
end;

procedure TViewMain.Start;
begin
  inherited;
  BodyBola := Bola.FindBehavior(TCastleRigidBody) as TCastleRigidBody;
  BodyPlayer := Player.FindBehavior(TCastleRigidBody) as TCastleRigidBody;
  BodyPlayer.OnCollisionEnter := @PlayerColision;
  BodyPlayer.OnCollisionExit := @PlayerCollisionExit;
  //  BodyPlayer.OnCollisionStay:=@PlayerColision;
end;

procedure TViewMain.Update(const SecondsPassed: single; var HandleInput: boolean);
begin
  inherited;
  { This virtual method is executed every frame (many times per second). }
  Assert(LabelFps <> nil,
    'If you remove LabelFps from the design, remember to remove also the assignment "LabelFps.Caption := ..." from code');
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;

end;

function TViewMain.Press(const Event: TInputPressRelease): boolean;
begin
  Result := inherited;
  if Result then Exit; // allow the ancestor to handle keys

  { This virtual method is executed when user presses
    a key, a mouse button, or touches a touch-screen.

    Note that each UI control has also events like OnPress and OnClick.
    These events can be used to handle the "press", if it should do something
    specific when used in that UI control.
    The TViewMain.Press method should be used to handle keys
    not handled in children controls.
  }

  // Use this to handle keys:
  {
  if Event.IsKey(keyXxx) then
  begin
    // DoSomething;
    Exit(true); // key was handled
  end;
  }
  if Event.IsKey(keySpace) then
  begin

    //  BodyBola.ApplyImpulse(Vector3(10, 100, 0), Bola.WorldTranslation);
    BodyBola.LinearVelocity := Vector3(300, 300, 0);
    BodyBola.AngularVelocity := Vector3(0, 150, 0);
    Exit(True);
  end;
  if Event.IsKey(keyArrowLeft) then
  begin

    if BodyPlayer.LinearVelocity.x > 0 then
    begin
      BodyPlayer.LinearVelocity := Vector3(0, 0, 0);
    end
    else
    begin
      if BodyPlayer.LinearVelocity.x < -200 then
      begin
        BodyPlayer.LinearVelocity := Vector3(-150, 0, 0);
      end
      else
      begin
        BodyPlayer.LinearVelocity := Vector3(-300, 0, 0);
      end;
    end;
    WritelnLog(BodyPlayer.LinearVelocity.ToString);
    Exit(True);
  end;

  if Event.IsKey(keyArrowRight) then
  begin
    if BodyPlayer.LinearVelocity.x < 0 then
    begin
      BodyPlayer.LinearVelocity := Vector3(0, 0, 0);
    end
    else
    begin
      if BodyPlayer.LinearVelocity.X < 200 then
        BodyPlayer.LinearVelocity := Vector3(150, 0, 0)
      else
        BodyPlayer.LinearVelocity := Vector3(300, 0, 0);
    end;
    WritelnLog(BodyPlayer.LinearVelocity.ToString);
    Exit(True);
  end;
end;

end.
