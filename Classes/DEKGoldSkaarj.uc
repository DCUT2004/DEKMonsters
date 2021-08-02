//=============================================================================
// DEKGold. 3x HP, 0.7x Speed, 1.25x Score, 1.5x Mass
//=============================================================================

class DEKGoldSkaarj extends DCFireSkaarj;

var config float HeatDamageMultiplier;

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	RefNormal=normal(HitLocation-Location);
	if(Frand()>0.2)
		return true;
	else
		return false;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local FireInv Inv;
	
	if (DamageType == class'SMPDamTypeTitanRock' || DamageType == class'DamTypeTitanRock' || DamageType == class'DamTypeTechTitanRock'  || DamageType == class'DamTypeFruitCakeTitanRock' || DamageType == class'DamTypePumpkinTitan' || DamageType == class'DamTypeTitaniumTitanRock')
	{
		return;
		Momentum = vect(0,0,0);
	}
	if (Damage > 0 && instigatedBy != None && instigatedBy.IsA('Monster') && instigatedBy.Controller != None && !instigatedBy.Controller.SameTeamAs(Self.Controller))
	{
		Inv = FireInv(instigatedBy.FindInventoryType(class'FireInv'));
		if (Inv != None)
		{
			Damage *= class'ElementalConfigure'.default.FireOnIceDamageMultiplier;
		}
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

defaultproperties
{
     HeatDamageMultiplier=1.150000
     ScoringValue=13
     GibGroupClass=Class'DEKMonsters208AE.DEKGoldGibGroup'
     Health=600
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GoldMonsters.GoldMonFB'
     Skins(1)=None
     Mass=500.000000
}
