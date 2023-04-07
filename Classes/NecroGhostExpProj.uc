class NecroGhostExpProj extends SeekingRocketProj
	config(satoreMonsterPack);

var Emitter OrbFX;
var config int ModifierDecrease;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();
		
	OrbFX = Spawn(class'NecroGhostExpProjEffect',self);
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
	local RPGWeapon W;
	local Pawn P;
	
	P = Pawn(Seeking);

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	
	if (P == None || P.Health <= 0)
	{
		return;
		Destroy();
	}
	ForceDir = Normal(P.Location - Location);
	
	VelMag = VSize(Velocity);

	ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
	Velocity =  VelMag * ForceDir;
	Acceleration += 5 * ForceDir;

	// Update rocket so it faces in the direction its going.
	SetRotation(rotator(Velocity));

	if (P != None)
	{
		SeekingDistance = VSize(P.Location - Location);
		if(SeekingDistance < 50)
		{
			if (P.Weapon != None && P.Weapon.IsA('RPGWeapon'))
			{
				W = RPGWeapon(P.Weapon);
				if (W != None)
				{
					if (W.Modifier > W.MinModifier)
					{
						W.Modifier -= ModifierDecrease;
						if (W.Modifier < W.MinModifier)
							W.Modifier = W.MinModifier;
						W.Identify();
					}
				}
			}
			Destroy();
		}
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
	 ModifierDecrease=1
     Speed=300.000000
     MaxSpeed=300.000000
     DrawType=DT_Sprite
     AmbientSound=Sound'GeneralAmbience.firefx11'
     LifeSpan=7.000000
     DrawScale=0.080000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bCollideWorld=False
}
