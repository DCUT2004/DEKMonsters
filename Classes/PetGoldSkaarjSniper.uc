class PetGoldSkaarjSniper extends DEKGoldSkaarjSniper;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
