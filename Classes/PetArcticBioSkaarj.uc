class PetArcticBioSkaarj extends ArcticBioSkaarj;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	
	SummonedMonster = True;
	Instigator = self;
}

defaultproperties
{
}
