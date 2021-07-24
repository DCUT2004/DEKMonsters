class PetFireManta extends FireManta;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
