class TechRazorfly extends DCRazorfly
	config(satoreMonsterPack);

var config float GoopIntervalTime;
var float LastGoopTime;

simulated function PostBeginPlay()
{
	class'TechInv'.static.GiveTechInv(Instigator);
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechQueen' || P.Class == class'TechTitan' || P.Class == class'TechWarlord' || P.Class == class'Razorfly' || P.Class == class'DCRazorfly');
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

function SpawnBelch()
{
	FireProjectile();
}

function RangedAttack(Actor A)
{
	Super.RangedAttack(A);
	
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if ( MeleeDamageTarget(10, (15000.0 * Normal(A.Location - Location))) )
			PlaySound(sound'injur1rf', SLOT_Talk);

		Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
		Controller.Destination.Z = Location.Z + 70;
		Velocity = AirSpeed * normal(Controller.Destination - Location);
		Controller.GotoState('TacticalMove', 'DoMove');
	}
	else if( Level.TimeSeconds - LastGoopTime > GoopIntervalTime)
	{
		bShotAnim = true;
		FireProjectile();
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	
	LastGoopTime = Level.TimeSeconds;
	
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
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
	}
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
     GoopIntervalTime=1.000000
     AmmunitionClass=Class'DEKMonsters999X.TechPupaeAmmo'
     ScoringValue=4
     GibGroupClass=Class'DEKMonsters999X.DEKTechGibGroup'
     MeleeRange=90.000000
     AirSpeed=700.000000
     AccelRate=1500.000000
     Health=70
     ControllerClass=Class'DEKMonsters999X.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Mass=80.000000
     Buoyancy=80.000000
}
