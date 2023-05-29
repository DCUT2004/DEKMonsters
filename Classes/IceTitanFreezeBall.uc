class IceTitanFreezeBall extends IceSkaarjFreezingProjectile;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (IceBallEffect != None)
		IceBallEffect.Destroy();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        IceBallEffect = Spawn(class'DEKRPG999X.IceballEffect', self);
		if (IceBallEffect != None)
        	IceBallEffect.SetBase(self);
	}
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if (Other == Instigator || Other == Owner) return;

    if ( !Other.IsA('Projectile') || Other.bProjTarget )
		Explode(HitLocation, Normal(HitLocation-Other.Location));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_None, 0.3);
    if (EffectIsRelevant(Location, false))
	{
        if (ExplosionDecal != None && Level.NetMode != NM_DedicatedServer)
            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
		Spawn(class'DEKRPG999X.RuneBlizzardEffect', Self,, HitLocation, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
	BaseChance=50.000000
	MaxFreezeLifespan=4.000000
	bDispellable=True
	bStackable=False
	Damage=100.000000
	DamageRadius=350.000000
	MomentumTransfer=1000.000000
	MyDamageType=Class'DEKMonsters999X.DamTypeIceTitan'
	AmbientSound=None
	ImpactSound=Sound'ONSVehicleSounds-S.Explosions.VehicleExplosion03'
}