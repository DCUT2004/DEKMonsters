class PetTechQueen extends TechQueen;

simulated function PostBeginPlay()
{
	Super(SMPQueen).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

function SpawnChildren()
{
	return;
}

defaultproperties
{
}
