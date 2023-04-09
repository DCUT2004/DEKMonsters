class DCAldebaran extends Aldebaran
	config(DEKMonsters);

var config float ScaleMultiplier;

simulated function PostBeginPlay()
{
	if (Instigator != None)
	{
		Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
		SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*ScaleMultiplier/2));
		SetDrawScale(Drawscale*ScaleMultiplier);
		SetCollisionSize(CollisionRadius*ScaleMultiplier, CollisionHeight*ScaleMultiplier);
	}
	Super.PostBeginPlay();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'Utility_Monster'.static.AdjustDamage(Damage, EventInstigator, Self, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
    NewHealth=750
	ScaleMultiplier=1.5000
    ControllerClass=Class'DEKRPG999X.DCMonsterController'
}
