class DCBehemoth extends Behemoth;

var bool SummonedMonster;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' );
	else
		return ( P.class == class'DCBehemoth');
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'Utility_Monster'.static.AdjustDamage(Damage, EventInstigator, Self, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters999X.DCBehemothAmmo'
     ControllerClass=Class'DEKRPG999X.DCMonsterController'
}
