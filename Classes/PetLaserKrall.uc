class PetLaserKrall extends LaserKrall;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	bSuperAggressive = (FRand() < 0.5);
	SetInvisibility(30.0);
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
