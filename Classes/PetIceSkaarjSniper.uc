class PetIceSkaarjSniper extends IceSkaarjSniper;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
