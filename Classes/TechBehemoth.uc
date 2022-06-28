class TechBehemoth extends DCBehemoth
	config(satoreMonsterPack);

var bool bStuckEnemy;
var Actor StuckEnemy;
var float SpreadAngle;
var int MinProjectiles;
var int MaxProjectiles;
var float MaxHoldTime;
var float LastFireTime;
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
	return ( P.class == class'Monster');
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

function NotifyStuckEnemy(Actor A)
{
	StuckEnemy=A;
	bStuckEnemy=true;
}

function Fire( optional float F )
{
	local Actor BestTarget;
	local float bestAim, bestDist;
	local vector FireDir, X,Y,Z;

	if (bStuckEnemy)
	{
		if (StuckEnemy == None || Pawn(StuckEnemy) == None || Pawn(StuckEnemy).Health<=0)
			bStuckEnemy=false;
	}
	if (bStuckEnemy)
	{
		RangedAttack(StuckEnemy);
	}
	else
	{
		bestAim = 0.90;
		GetAxes(Controller.Rotation,X,Y,Z);
		FireDir = X;
		BestTarget = Controller.PickTarget(bestAim, bestDist, FireDir, GetFireStart(X,Y,Z), 6000); 
		RangedAttack(BestTarget);
	}
}

function FireProjectile()
{	
	local vector X,Y,Z, projStart;
	local int i, NumProjectiles;
	local vector GunDir, RightDir, FireDir;
	local float SpreadAngleRad, FireAngleRad; // Radians
	local TechBehemothWebLeader Leader;
	local TechBehemothWeb P;

	if(Controller==none)
		return;
	GetAxes(Rotation,X,Y,Z);

	projStart = GetFireStart(X,Y,Z);

	// Defines plane in which projectiles will start travelling in.
	GunDir = vector(Controller.AdjustAim(SavedFireProperties,projStart,600));
	RightDir = normal( GunDir Cross vect(0,0,1) );

	NumProjectiles = MinProjectiles + (MaxProjectiles - MinProjectiles) * (FMin(Level.TimeSeconds - LastFireTime, MaxHoldTime) / MaxHoldTime);
	SpreadAngleRad = SpreadAngle * (Pi/180.0);
	
	PlaySound(FireSound,SLOT_Interact);

	// Spawn all the projectiles
	for(i=0; i<NumProjectiles; i++)
	{
		FireAngleRad = (-0.5 * SpreadAngleRad * (NumProjectiles - 1)) + (i * SpreadAngleRad); // So shots are centered around FireAngle of zero.
		FireDir = (Cos(FireAngleRad) * GunDir) + (Sin(FireAngleRad) * RightDir);

		if(i == 0)
		{
			Leader = spawn(class'TechBehemothWebLeader', self, , projStart, rotator(FireDir));

			if(Leader != None)
			{
				Leader.Projectiles.Length = NumProjectiles;
				Leader.ProjTeam = Controller.GetTeamNum();

				Leader.Projectiles[0] = Leader;
				Leader.ProjNumber = 0;
				Leader.Leader = Leader;
			}
		}
		else
		{
			P = spawn(class'TechBehemothWeb', self, , projStart, rotator(FireDir));

			if(P != None && Leader != None)
			{
				Leader.Projectiles[i] = P;
				P.ProjNumber = i;
				P.Leader = Leader;
			}
		}
	}

	LastFireTime = Level.TimeSeconds;
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
     SpreadAngle=10.000000
     MinProjectiles=3
     MaxProjectiles=7
     MaxHoldTime=4.000000
     AmmunitionClass=Class'DEKMonsters209E.TechBehemothAmmo'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters209E.DEKTechGibGroup'
     Health=360
     ControllerClass=Class'DEKMonsters209E.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Mass=80.000000
     Buoyancy=80.000000
}
