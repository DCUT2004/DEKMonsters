class PetFireSkaarjTrooper extends FireSkaarjTrooper;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'FireSkaarjTrooperProjectile';
}

defaultproperties
{
}
