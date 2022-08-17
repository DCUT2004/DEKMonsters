class DCMercenaryElite extends SMPMercenaryElite;

var bool SummonedMonster;

simulated function PostBeginPlay()
{
	Super(DEKMonster).PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCMercenaryElite');
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
     MyDamageType=Class'DEKMonsters999X.DamTypeEliteMercenaryAmmo'
     RocketAmmoClass=Class'DEKMonsters999X.EliteMercenaryRocketAmmo'
}
