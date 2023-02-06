class DCChildGasbag extends SMPChildGasbag;

var DCGiantGasBag ParentBagE;
var StatusEffectInventory StatusManager;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	StatusManager = class'DEKMonsterUtility'.static.SpawnStatusEffectInventory(Instigator);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'DCGasbag' || P.Class == class'DCGiantGasbag');
}

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentBag=DCGiantGasBag(Owner);
	if(ParentBag==none)
		Destroy();
	Super.PreBeginPlay();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'DEKMonsterUtility'.static.AdjustDamage(Damage, EventInstigator, Self, StatusManager, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

simulated function Destroyed()
{
	if ( ParentBagE != None )
		ParentBagE.numChildren--;
	Super.Destroyed();
	Spawn(class'RocketSmokeRing');
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'RocketSmokeRing');
	Destroy();
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters999X.DCGasbagAmmo'
     ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
