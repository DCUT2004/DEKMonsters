class PetFireKrall extends FireKrall;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'FireKrallBolt';
}

defaultproperties
{
}
