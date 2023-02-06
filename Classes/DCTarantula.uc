class DCTarantula extends Tarantula
	config(DEKMonsters);

var StatusEffectInventory StatusManager;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	StatusManager = class'DEKMonsterUtility'.static.SpawnStatusEffectInventory(Instigator);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'DEKMonsterUtility'.static.AdjustDamage(Damage, EventInstigator, Self, StatusManager, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
    ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
