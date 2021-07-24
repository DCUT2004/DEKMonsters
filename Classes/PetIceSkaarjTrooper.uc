class PetIceSkaarjTrooper extends IceSkaarjTrooper;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'IceSkaarjTrooperProjectile';
}

defaultproperties
{
}
