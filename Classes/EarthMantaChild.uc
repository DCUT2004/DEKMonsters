class EarthMantaChild extends EarthManta;

simulated function PreBeginPlay()
{
	SummonedMonster = True;
	Super.PreBeginPlay();
}

defaultproperties
{
}
