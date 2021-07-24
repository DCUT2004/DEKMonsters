class PetLavaBioSkaarj extends LavaBioSkaarj;

simulated function PostBeginPlay()
{
	super(LavaBioSkaarj).PostBeginPlay();
	SummonedMonster = True;
	Instigator = self;
	MyAmmo.ProjectileClass = class'LavaBioSkaarjGlob';
}

defaultproperties
{
}
