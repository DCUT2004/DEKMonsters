class PetIceKrall extends IceKrall;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'IceKrallProj';
}

defaultproperties
{
}
