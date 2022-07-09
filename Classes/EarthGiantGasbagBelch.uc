class EarthGiantGasbagBelch extends EarthGasbagBelch;

simulated function PostBeginPlay()
{
	super(EarthGasbagBelch).PostBeginPlay();
	if (SmokeTrail != None)
		SmokeTrail.SetDrawScale(SmokeTrail.DrawScale*2.5);
}

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	if (SmokeTrail != None)
		SmokeTrail.SetDrawScale(SmokeTrail.DrawScale*2.5);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);

	A=spawn(class'EarthFlashExplosion',,,HitLocation + HitNormal*16 );
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		A=Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}
    if ( EffectIsRelevant(Location,false) )
		Spawn(class'DEKMonsters209F.EarthDebrisExplosion', Self,, HitLocation, rotator(-HitNormal));

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     Damage=50.000000
     DamageRadius=230.000000
     MyDamageType=Class'DEKMonsters209F.DamTypeEarthGiantGasbag'
     DrawScale=0.600000
}
