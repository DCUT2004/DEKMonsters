class PetSoulWraith extends NecroSoulWraith;

simulated function PostBeginPlay()
{
	Super(NecroSoulWraith).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
