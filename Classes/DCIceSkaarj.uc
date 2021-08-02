class DCIceSkaarj extends IceSkaarj;

var bool SummonedMonster;

simulated function PostBeginPlay()
{
	local ComboInv ComboInv;
	Super.PostBeginPlay();
	
	ComboInv = ComboInv(Instigator.FindInventoryType(class'ComboInv'));
	if (ComboInv == None)
	{
		ComboInv = Instigator.Spawn(class'ComboInv');
		ComboInv.GiveTo(Instigator);
	}
	MyAmmo.ProjectileClass = class'DCIceSkaarjProjectile';
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCIceSkaarj');
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
     AmmunitionClass=Class'DEKMonsters208AE.DCIceSkaarjAmmo'
     ControllerClass=Class'DEKMonsters208AE.DCMonsterController'
     DodgeAnims(2)="DodgeR"
     DodgeAnims(3)="DodgeL"
}
