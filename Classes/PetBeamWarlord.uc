class PetBeamWarlord extends BeamWarlord;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
