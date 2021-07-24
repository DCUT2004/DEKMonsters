class EarthSkaarjPupaeChild extends EarthSkaarjPupae;

simulated function PreBeginPlay()
{
	SummonedMonster = True;
	Super.PreBeginPlay();
}

defaultproperties
{
}
