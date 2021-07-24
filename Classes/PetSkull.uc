class PetSkull extends NecroSkull;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
	PlayAnim('Chase');
}

defaultproperties
{
}
