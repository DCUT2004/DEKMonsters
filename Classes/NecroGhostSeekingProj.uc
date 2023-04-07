class NecroGhostSeekingProj extends SeekingRocketProj
     config(satoreMonsterPack);

var Emitter OrbFX;
var Class<Emitter> OrbFXClass;
var config Class<StatusEffectData> StatusEffectClass;
var config int StatusModifier, StatusLifespan;
var config bool bDispellable, bStackable;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();
		
	OrbFX = Spawn(OrbFXClass, Self);
	if (OrbFX != None)
		OrbFX.SetBase(self);
	Dir = vector(Rotation);
	Velocity = speed * Dir;
	SetCollision(False,False,False);
     SetTimer(0.1, true);
}

simulated function Timer()
{
     local vector ForceDir;
     local float VelMag;
     local float SeekingDistance;
     local Pawn P;
     local StatusEffectManager StatusManager;
	
	P = Pawn(Seeking);
	
	if (P == None || P.Health <= 0)
	{
		Destroy();
          return;
	}

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	ForceDir = Normal(P.Location - Location);
	VelMag = VSize(Velocity);
	ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
	Velocity =  VelMag * ForceDir;
	Acceleration += 5 * ForceDir;

	// Update rocket so it faces in the direction its going.
	SetRotation(rotator(Velocity));

     SeekingDistance = VSize(P.Location - Location);
     if(SeekingDistance < 50)
     {
          StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(P);
          if (StatusManager != None)
               StatusManager.AddStatusEffect(StatusEffectClass, -(abs(StatusModifier)), True, StatusLifespan, bDispellable, bStackable);			
          Destroy();
     }
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	return;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated function Destroyed()
{
	if (OrbFX != None)
	{
		if (bNoFX)
			OrbFX.Destroy();
		else
			OrbFX.Kill();
	}

	Super.Destroyed();
}

defaultproperties
{
     Speed=300.000000
     MaxSpeed=300.000000
     DrawType=DT_Sprite
     AmbientSound=Sound'GeneralAmbience.firefx11'
     LifeSpan=7.000000
     DrawScale=0.080000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bCollideWorld=False
     bDynamicLight=True
}
