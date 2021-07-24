class PetFireSkaarjSuperHeat extends FireSkaarjSuperHeat;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'FireSkaarjSuperHeatProjectile';
}

defaultproperties
{
}
