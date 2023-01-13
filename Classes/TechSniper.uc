class TechSniper extends DCSkaarjSniper
	config(satoreMonsterPack);

function PostBeginPlay()
{
	super.PostBeginPlay();
	class'TechInv'.static.GiveTechInv(Instigator);
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local int OldHealth, HealthTaken, TakePercent;


	// increase damage if a block or vehicle
	class'TechMonsterController'.static.AdjustTechMeleeDamage(Controller.target, hitdamage, TakePercent, OldHealth);

	if (super.MeleeDamageTarget(hitdamage, pushdir))
	{
	    // hit it
	    if (Controller.target == None || Pawn(Controller.target).Health <= 0)
	        HealthTaken = OldHealth;
		else
		    HealthTaken = OldHealth - Pawn(Controller.target).Health;
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
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     DamageMin=35
     DamageMax=45
     NumArcs=8
     DamageType=Class'DEKMonsters999X.DamTypeTechSniper'
     DamageTypeHeadShot=Class'DEKMonsters999X.DamTypeTechSniperHeadShot'
     HitEmitterClass=Class'DEKRPG999X.RedBoltEmitter'
     SecHitEmitterClass=Class'DEKMonsters999X.RedBoltChild'
     ScoringValue=12
     GibGroupClass=Class'DEKMonsters999X.DEKTechGibGroup'
     Health=300
     ControllerClass=Class'DEKMonsters999X.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
}
