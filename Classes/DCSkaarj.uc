class DCSkaarj extends Skaarj;

var bool SummonedMonster;

simulated function PostBeginPlay()
{
	local ComboInv ComboInv;
	
	Super.PostBeginPlay();
	
	if (Instigator != None)
	{
		ComboInv = ComboInv(Instigator.FindInventoryType(class'ComboInv'));
		if (ComboInv == None)
		{
			ComboInv = Instigator.Spawn(class'ComboInv');
			ComboInv.GiveTo(Instigator);
		}
	}
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCSkaarj');
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
     AmmunitionClass=Class'DEKMonsters209F.DCSkaarjAmmo'
     ControllerClass=Class'DEKMonsters209F.DCMonsterController'
     DodgeAnims(2)="DodgeR"
     DodgeAnims(3)="DodgeL"
}
