class DEKMonster extends Monster;

var StatusEffectInventory StatusManager;

simulated function PostBeginPlay()
{
     Super.PostBeginPlay();
     StatusManager = Class'DEKMonsterUtility'.static.SpawnStatusEffectInventory(Self);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'DEKMonsterUtility'.static.AdjustDamage(Damage, EventInstigator, Self, StatusManager, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
}
