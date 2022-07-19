class EarthMercenaryRocket extends SMPMercRocket;

var xEmitter RealSmokeTrail;
var EarthSkaarjProjectileFX ProjectileFX;

simulated function PostBeginPlay()
{
	if (SmokeTrail != None)
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
	
	if ( Level.NetMode != NM_DedicatedServer)
	{
		RealSmokeTrail = Spawn(class'EarthProjectileTrail',self);
        ProjectileFX = Spawn(class'EarthSkaarjProjectileFX', self);
        ProjectileFX.SetBase(self);
	}
	if (Corona != None)
		Corona.Destroy();

	Dir = vector(Rotation);
	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	if (SmokeTrail != None)
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
	if (Corona != None)
		Corona.Destroy();
	Super(RocketProj).PostNetBeginPlay();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);	
	}
    if ( EffectIsRelevant(Location,false) )
		Spawn(class'DEKMonsters999X.EarthDebrisExplosion', Self,, HitLocation, rotator(-HitNormal));
    PlaySound(Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3');
	Destroy();
}

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;
	if (RealSmokeTrail != None)
		RealSmokeTrail.mRegen = False;
	if ( Corona != None )
		Corona.Destroy();
    if (ProjectileFX != None)
    {
		if ( bNoFX )
			ProjectileFX.Destroy();
		else
			ProjectileFX.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
     bSwitchToZeroCollision=True
     MyDamageType=Class'DEKMonsters999X.DamTypeEarthMercenaryRocket'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     MaxEffectDistance=7000.000000
     LightHue=90
     LightBrightness=100.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bHidden=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     Texture=Texture'XEffects.Skins.MuzFlashWhite_t'
     DrawScale=0.065000
     Skins(0)=Texture'XEffects.Skins.MuzFlashWhite_t'
     Style=STY_Translucent
     bAlwaysFaceCamera=True
     ForceRadius=40.000000
}
