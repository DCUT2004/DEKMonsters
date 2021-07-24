class PetEarthSkaarj extends EarthSkaarj;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'EarthSkaarjProjectile';
}

defaultproperties
{
}
