class PetFireRazorfly extends FireRazorfly;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
