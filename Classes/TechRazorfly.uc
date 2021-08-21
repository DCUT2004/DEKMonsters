class TechRazorfly extends DCRazorfly
	config(satoreMonsterPack);

var config float GoopIntervalTime;
var float LastGoopTime;
var config float NetworkRadius;
var xEmitter NetworkChain;

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
		return ( P.class == class'HealerNali' || P.class == class'MissionCow');
	else
		return ( P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechQueen' || P.Class == class'TechTitan' || P.Class == class'TechWarlord' || P.Class == class'Razorfly' || P.Class == class'DCRazorfly');
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
            hitdamage *= 5;        // if invasion damage to block will get reduced to 40%
            TakePercent = 30;
		}
		else if (vehicle(Controller.target) != None)
		{
            hitdamage *= 5;
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
	
	local Controller C, NextC;
	local Array < Pawn > TechMonsters;
	local int x;
	local int NetworkDamage;
	
	if (Instigator == None || instigatedBy == None)
		return;
	
	if (damageType != Class'DamTypeSharedDamage' && (instigatedBy != None && instigatedBy.Weapon != None && ((RPGWeapon(instigatedBy.Weapon) != None && !RPGWeapon(instigatedBy.Weapon).IsA('RW_Waterfall')) || RPGWeapon(instigatedBy.Weapon) == None)) )
	{
		TechMonsters.Length = 0;
		TechMonsters.Insert(0, 1);	//Insert 1 Monster element at index 0
		TechMonsters[0] = Instigator;
		x = 1;
		
		C = Level.ControllerList;
		
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None && C.Pawn != Instigator &&  C.Pawn.GetTeamNum() == Instigator.GetTeamNum() && TechInv(C.Pawn.FindInventoryType(Class'TechInv')) != None && VSize(C.Pawn.Location - Instigator.Location) <= NetworkRadius && FastTrace(C.Pawn.Location, Instigator.Location))
			{
				TechMonsters[x] = C.Pawn;
				x++;
			}
			C = NextC;
		}
		
		if (TechMonsters.Length > 1)	//We have an additional tech monster besides Instigator that we can split the damage with
		{
			NetworkDamage = Damage/TechMonsters.Length;
			if (NetworkDamage < 1)
				NetworkDamage = 1;
			for (x = 0; x < TechMonsters.Length; x++)
			{
				TechMonsters[x].TakeDamage(NetworkDamage, instigatedBy, TechMonsters[x].Location, Vect(0,0,0), Class'DamTypeSharedDamage');

				NetworkChain = Spawn(class'TechNetworkChain',Instigator,,Instigator.Location,rotator(Instigator.Location - TechMonsters[x].Location));
				if (NetworkChain != None)
				{
					NetworkChain.mSpawnVecA = TechMonsters[x].Location;
					NetworkChain.SetRotation(rotator(TechMonsters[x].Location - Instigator.Location));
					NetworkChain.SetBase(Instigator);
				}
			}
		}
		else	//Otherwise the array has 1 or fewer elements.
			Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
	else
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
}

defaultproperties
{
	 NetworkRadius=1000.0000
     GoopIntervalTime=1.000000
     AmmunitionClass=Class'DEKMonsters208AJ.TechPupaeAmmo'
     ScoringValue=4
     GibGroupClass=Class'DEKMonsters208AJ.DEKTechGibGroup'
     MeleeRange=90.000000
     AirSpeed=700.000000
     AccelRate=1500.000000
     Health=70
     ControllerClass=Class'DEKMonsters208AJ.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Mass=80.000000
     Buoyancy=80.000000
}
