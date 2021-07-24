class PetIceSkaarj extends DCIceSkaarj;

var RPGRules RPGRules;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
}
