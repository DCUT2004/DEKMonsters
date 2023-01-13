class TechSkaarj extends DCIceSkaarj
	config(satoreMonsterPack);


event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'TechSkaarjProjectile';
	class'TechInv'.static.GiveTechInv(Instigator);
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

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters999X.TechSkaarjAmmo'
     ScoringValue=8
     GibGroupClass=Class'DEKMonsters999X.DEKTechGibGroup'
     GroundSpeed=600.000000
     WaterSpeed=100.000000
     AirSpeed=600.000000
     AccelRate=900.000000
     Health=200
     ControllerClass=Class'DEKMonsters999X.TechMonsterController'
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkF"
     MovementAnims(2)="WalkF"
     MovementAnims(3)="WalkF"
     SwimAnims(0)="WalkF"
     SwimAnims(1)="WalkF"
     SwimAnims(2)="WalkF"
     SwimAnims(3)="WalkF"
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Mass=80.000000
     Buoyancy=80.000000
}
