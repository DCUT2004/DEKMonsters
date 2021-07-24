class PetIceGasbag extends IceGasbag;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
