class PetFireSkaarj extends DCFireSkaarj;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
