class TechSlith extends DCSlith
	config(satoreMonsterPack);

simulated function PostBeginPlay()
{
	GiveTechInv();
	Super.PostBeginPlay();
}

function GiveTechInv()
{
	local TechInv Inv;
	if (Instigator != None)
	{
		Inv = TechInv(Instigator.FindInventoryType(class'TechInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(Class'TechInv');
			Inv.GiveTo(Instigator);
		}
	}
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechTitan' || P.Class == class'TechWarlord' || P.Class == class'TechQueen');
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local int OldHealth, HealthTaken, TakePercent;


	// increase damage if a block or vehicle
	If ( (Controller.target != None) && Pawn(Controller.target) != None  && Pawn(Controller.target).Health > 0)
	{
	    OldHealth = Pawn(Controller.target).Health;
        TakePercent = 0;
	    if (DruidBlock(Controller.target) != None)
	    {
            hitdamage *= 16;        // if invasion damage to block will get reduced to 40%
            TakePercent = 30;
		}
		else if (vehicle(Controller.target) != None)
		{
            hitdamage *= 4;
            TakePercent = 15;
		}
	}

	if (super.MeleeDamageTarget(hitdamage, pushdir))
	{
	    // hit it
	    if (Controller.target == None || Pawn(Controller.target).Health <= 0)
	        HealthTaken = OldHealth;
		else
		    HealthTaken = OldHealth - Pawn(Controller.target).Health;
		if (HealthTaken < 0)
		    HealthTaken = 0;
		// now take some health back
		if (HealthTaken > 0)
		{
			HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
			GiveHealth(HealthTaken, HealthMax);
		}

		return true;
	}

	return false;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	//Check to see if other tech monsters are nearby when taking damage
	//If there are other nearby tech monsters, divide the damage by the number of tech monsters and distribute the damage equally
	//Otherwise, just take the normal damage
	
	if (class'TechInv'.static.SpreadDamage(Instigator, Damage, instigatedBy, hitlocation, momentum, damageType) == false)
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local TechSlithMine M;
	
	foreach DynamicActors(class'TechSlithMine', M)
	{
		if (M != None && M.Instigator == Instigator && M.InstigatorController == Instigator.Controller)
			M.BlowUp(M.Location);
	}
	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     MonsterName="Tech Slith"
     AmmunitionClass=Class'DEKMonsters999X.TechSlithAmmo'
     ScoringValue=8
     GibGroupClass=Class'DEKMonsters999X.DEKTechGibGroup'
     GroundSpeed=400.000000
     WaterSpeed=100.000000
     AirSpeed=400.000000
     AccelRate=700.000000
     Health=225
     ControllerClass=Class'DEKMonsters999X.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Mass=80.000000
     Buoyancy=80.000000
}
