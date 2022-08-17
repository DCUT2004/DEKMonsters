class DCKrall extends Krall;

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
		return ( P.class == class'DCKrall');
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
     AmmunitionClass=Class'DEKMonsters999X.DCKrallAmmo'
     ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
