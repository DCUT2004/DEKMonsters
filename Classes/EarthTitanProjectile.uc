class EarthTitanProjectile extends Projectile;

var class<Projectile> ChildProjectileClass;
var config float DetonateRadius;
var float SpreadFactor;
var actor Glow;
var	xemitter trail;
var Pawn Target;

simulated function PostBeginPlay()
{
    local Rotator R;
    local PlayerController PC;
	
    if (!PhysicsVolume.bWaterVolume && Level.NetMode != NM_DedicatedServer) {
        PC = Level.GetLocalPlayerController();
        if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 6000)
            Trail = Spawn(class'EarthTitanProjectileTrail', self,, Location, R);
        Glow = Spawn(class'FlakGlow', self);
    }
	
	Velocity = Vector(Rotation) * Speed;  
    Super(Projectile).PostBeginPlay();
    R = Rotation;
    SetRotation(R);
	
	SetTimer(0.25, True);
	SetCollision(false,false,false);
}

simulated function Timer()
{
    local int i, j;
    local Projectile Child;
    local float Mag;
    local vector CurrentVelocity;
	local Controller C;

    CurrentVelocity = 0.85 * Velocity;
	
	C = Level.ControllerList;	
	while (C != None)
	{
		if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn == Target
		&& VSize(C.Pawn.Location - Self.Location) <= DetonateRadius && FastTrace(C.Pawn.Location, Self.Location))
		{
			for (i = -1; i < 1; i++)
			{
				for (j= -1; j < 1; j++)
				{
					if (Abs(i) + Abs(j) > 1)
						Mag = 0.7;
					else
						Mag = 1.0;
					Child = Spawn(ChildProjectileClass, self,, Location);
					if (Child != None)
					{
						Child.Velocity = CurrentVelocity;
						Child.Velocity.X += RandRange(0.3, 1.0) * Mag * i * SpreadFactor;
						Child.Velocity.Y += RandRange(0.3, 1.0) * Mag * j * SpreadFactor;
						Child.Velocity.Z = Child.Velocity.Z + SpreadFactor * (FRand() - 0.5);
						Child.InstigatorController = InstigatorController;
					}
				}
			}
			Destroy();
		}
		C = C.NextController;
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function SpawnEffects(vector HitLocation, vector HitNormal)
{
    local PlayerController PC;

    PlaySound(ImpactSound, SLOT_None, 0.3);
    if (EffectIsRelevant(Location, false))
	{
        PC = Level.GetLocalPlayerController();
        if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 3000)
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
        if (ExplosionDecal != None && Level.NetMode != NM_DedicatedServer)
            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
		Spawn(class'DEKMonsters208AA.EarthDebrisExplosion', Self,, HitLocation, rotator(-HitNormal));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator rot;
    local int i;
    local EarthTitanProjectileChild NewChunk;

	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			NewChunk = Spawn( class 'EarthTitanProjectileChild',, '', Start, rot);
		}
	}
    Destroy();
}

simulated function destroyed()
{
	if ( Trail != None ) 
		Trail.mRegen=False;
	if ( glow != None )
		Glow.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     ChildProjectileClass=Class'DEKMonsters208AA.EarthTitanProjectileChild'
     DetonateRadius=500.000000
     SpreadFactor=400.000000
     Speed=1140.000000
     Damage=200.000000
     DamageRadius=400.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'DEKRPG208AA.DamTypeHellfireSentinel'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     CullDistance=4000.000000
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     DrawScale=14.000000
     AmbientGlow=100
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
