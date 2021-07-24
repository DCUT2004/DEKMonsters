class PetSkaarjSniper extends DCSkaarjSniper;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
