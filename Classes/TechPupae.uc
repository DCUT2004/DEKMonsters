class TechPupae extends DCPupae
	config(satoreMonsterPack);

var byte row;
var config float NetworkRadius;
var xEmitter NetworkChain;

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
		return ( P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechTitan' || P.Class == class'TechWarlord' || P.Class == class'TechQueen' || P.Class == class'SkaarjPupae' || P.Class == class'DCPupae' || P.Class == class'PoisonPupae' || P.Class == class'IceSkaarjPupae' || P.Class == class'FireSkaarjPupae');
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

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Y + 0.4 * CollisionHeight * Z;
}

function SpawnShot()
{
	local vector X,Y,Z, projStart;

	if(Controller==none)
		return;
	GetAxes(Rotation,X,Y,Z);

	if (row == 0)
		MakeNoise(1.0);
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

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z + 0.2 * CollisionRadius * Y;
	spawn(MyAmmo.ProjectileClass ,self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z - 0.2 * CollisionRadius * Y;
	spawn(MyAmmo.ProjectileClass ,self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));
	row++;
}

function RangedAttack(Actor A)
{
	local float Dist;

	if ( bShotAnim )
		return;

	Dist = VSize(A.Location - Location);
	if ( Dist > 350 )
		return;
	bShotAnim = true;
	PlaySound(ChallengeSound[Rand(4)], SLOT_Interact);
	if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
  		if ( FRand() < 0.5 )
  			SetAnimAction('Bite');
  		else
  			SetAnimAction('Stab');
		MeleeDamageTarget(8, vect(0,0,0));
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		return;
	}

	bLunging = false;
	Enable('Bump');
	SetAnimAction('Lunge');
	Velocity = 500 * Normal(A.Location + A.CollisionHeight * vect(0,0,0.75) - Location);
	if ( dist > CollisionRadius + A.CollisionRadius + 35 )
		Velocity.Z += 0.7 * dist;
	SetPhysics(PHYS_Falling);

    FireProjectile();
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	Super.PlayTakeHit(HitLocation, Damage, DamageType);
	FireProjectile();
	FireProjectile();

	return;
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
	 NetworkRadius=1000.0000
     AmmunitionClass=Class'DEKMonsters999X.TechPupaeAmmo'
     ScoringValue=3
     GibGroupClass=Class'DEKMonsters999X.DEKTechGibGroup'
     MeleeRange=90.000000
     GroundSpeed=500.000000
     Health=120
     ControllerClass=Class'DEKMonsters999X.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Buoyancy=80.000000
}
