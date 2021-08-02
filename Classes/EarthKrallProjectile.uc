class EarthKrallProjectile extends Projectile;

var xEmitter Trail;

simulated function PostBeginPlay()
{
    local Rotator R;

	Super.PostBeginPlay();
	
	Trail = Spawn(class'EarthProjectileTrail',self);
	
	Velocity = Speed * Vector(Rotation);

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
} 

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);	
	}
    if ( EffectIsRelevant(Location,false) )
		Spawn(class'DEKMonsters208AE.EarthDebrisExplosion', Self,, HitLocation, rotator(-HitNormal));
    PlaySound(Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3');
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
        	Trail.mRegen = False;

	Super.Destroyed();
}

defaultproperties
{
     Speed=1500.000000
     MaxSpeed=1500.000000
     Damage=20.000000
     DamageRadius=120.000000
     MomentumTransfer=25000.000000
     MyDamageType=Class'DEKMonsters208AE.DamTypeKrall'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=90
     LightBrightness=100.000000
     LightRadius=5.000000
     DrawType=DT_Sprite
     bDynamicLight=True
     LifeSpan=7.000000
     Texture=Texture'XEffects.Skins.LBBT'
     DrawScale=0.200000
     Style=STY_Translucent
}
