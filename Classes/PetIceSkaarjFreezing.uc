class PetIceSkaarjFreezing extends IceSkaarjFreezing;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'IceSkaarjFreezingProjectile';
}

defaultproperties
{
}
