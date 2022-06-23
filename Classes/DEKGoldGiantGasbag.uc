//=============================================================================
// DEKGold. 3x HP, 0.7x Speed, 1.5x Score, 1.5x Mass
//=============================================================================

class DEKGoldGiantGasbag extends DCGiantGasbag;

var config float HeatDamageMultiplier;

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	RefNormal=normal(HitLocation-Location);
	if(Frand()>0.2)
		return true;
	else
		return false;
}

function SpawnBelch()
{
	local DEKGoldChildGasbag G;
	local vector X,Y,Z, FireStart;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 0.5 * CollisionRadius * X - 0.3 * CollisionHeight * Z;
	if ( (numChildren >= MaxChildren) || (FRand() > 0.2) ||(DrawScale==1) )
	{
		if ( Controller != None )
		{
			if ( !SavedFireProperties.bInitialized )
			{
				SavedFireProperties.AmmoClass = MyAmmo.Class;
				SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
				SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
				SavedFireProperties.MaxRange = MyAmmo.MaxRange;
				SavedFireProperties.bTossed = MyAmmo.bTossed;
				SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
				SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
				SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
				SavedFireProperties.bInitialized = true;
			}
			Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
			PlaySound(FireSound,SLOT_Interact);
		}

	}
	else
	{
		G = spawn(class 'DEKGoldChildGasbag',self,,FireStart + (0.6 * CollisionRadius + class'SMPGiantGasbag'.Default.CollisionRadius) * X);
		if ( G != None )
		{
			G.ParentBag = self;
			numChildren++;
		}
	}
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
     ScoringValue=16
     GibGroupClass=Class'DEKMonsters209C.DEKGoldGibGroup'
     AirSpeed=231.000000
     Health=1800
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GoldMonsters.GoldMonFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.GoldMonsters.GoldMonFB'
     Mass=180.000000
}
