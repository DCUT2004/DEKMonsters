class DCFireSkaarj extends FireSkaarj;

var bool SummonedMonster;

simulated function PostBeginPlay()
{
	Super(DEKMonster).PostBeginPlay();
	MyAmmo.ProjectileClass = class'DCFireSkaarjProjectile';
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCFireSkaarj');
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
     AmmunitionClass=Class'DEKMonsters999X.DCFireSkaarjAmmo'
     ControllerClass=Class'DEKMonsters999X.DCMonsterController'
     DodgeAnims(2)="DodgeR"
     DodgeAnims(3)="DodgeL"
}
