class PetEarthSkaarjTrooper extends EarthSkaarjTrooper;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'EarthSkaarjTrooperProjectile';
}

defaultproperties
{
}
