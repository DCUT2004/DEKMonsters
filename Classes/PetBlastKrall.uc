class PetBlastKrall extends BlastKrall;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	bSuperAggressive = (FRand() < 0.2);
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
