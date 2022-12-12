class PetGiantPoisonPupae extends GiantPoisonPupae;

simulated function PostBeginPlay()
{
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
