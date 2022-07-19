class PetPhantom extends NecroPhantom;

simulated function PostBeginPlay()
{
	Super(NecroPhantom).PostBeginPlay();
	Instigator = self;
	SummonedMonster = True;
}

defaultproperties
{
     ProjectileClass(0)=Class'DEKMonsters999X.NecroPhantomPetProjectile'
}
