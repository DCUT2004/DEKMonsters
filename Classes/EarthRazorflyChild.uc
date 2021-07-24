class EarthRazorflyChild extends EarthRazorfly;

simulated function PreBeginPlay()
{
	SummonedMonster = True;
	Super.PreBeginPlay();
}

defaultproperties
{
}
