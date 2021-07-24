class PetIceSkaarjPupae extends IceSkaarjPupae;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
