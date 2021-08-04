class EarthGasbagBelch extends Projectile;

var	xEmitter SmokeTrail;
var vector Dir;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if ( !Level.bDropDetail )
			spawn(class'NecroGhostPossessorVanishFX',,,Location, Rotation );
		SmokeTrail = Spawn(class'EarthGasbagFlames',self);
	}
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	Super.PostBeginPlay();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) ) 
		Explode(HitLocation,Vect(0,0,1));
}

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal) 
{
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
	spawn(class'EarthFlashExplosion',,,HitLocation + HitNormal*16 );
    if ( EffectIsRelevant(Location,false) )
		Spawn(class'DEKMonsters208AF.EarthDebrisExplosion', Self,, HitLocation, rotator(-HitNormal));
 	
	BlowUp(HitLocation);
	Destroy(); 
}

simulated function Destroyed() 
{
	if ( SmokeTrail != None )
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
	Super.Destroyed();
}

defaultproperties
{
     Speed=650.000000
     MaxSpeed=650.000000
     Damage=45.000000
     DamageRadius=140.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKMonsters208AF.DamTypeEarthGasbag'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=90
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_Sprite
     bHidden=True
     bDynamicLight=True
     AmbientSound=Sound'WeaponSounds.RocketLauncher.RocketLauncherProjectile'
     LifeSpan=6.000000
     Texture=Texture'XEffectMat.Link.link_muz_green'
     DrawScale=0.300000
     AmbientGlow=96
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_Constant
     ForceRadius=100.000000
     ForceScale=5.000000
}
