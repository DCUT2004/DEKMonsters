class TechQueen extends DCQueen
	config(satoreMonsterPack);

var	config	int					DamageMin,DamageMax;
var		int					NumArcs;
var		float				HeadShotRadius;
var		float				HeadShotDamageMult,SecDamageMult;
var		class<DamageType>	DamageType,DamageTypeHeadShot;
var		class<xEmitter>		HitEmitterClass;
var		class<xEmitter>		SecHitEmitterClass;
var		float				SecTraceDist;
var		float 				TraceRange;
var 	float 				LastAttackTime;
var		bool				bShootLeft;
var config float 			NetworkRadius;
var 	xEmitter 			NetworkChain;

var config int MonsterHealth,Score;

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

function vector GetFireStart(vector X, vector Y, vector Z)
{
	if (bShootLeft)
		return Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z + 0.2 * CollisionRadius * Y;
	else
		return Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z - 0.2 * CollisionRadius * Y;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'MissionCow');
	else
		return ( P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechTitan' || P.Class == class'TechWarlord' || P.Class == class'TechQueen');
}

function SpawnChildren()
{
	return;
}

function SpawnShot()
{
	local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
    local Actor Other, mainArcHitTarget;
    local int Damage, ReflectNum, arcsRemaining;
    local bool bDoReflect;
    local xEmitter hitEmitter;
    local class<xEmitter> tmpHitEmitClass;
    local float tmpTraceRange, dist;
    local vector arcEnd, mainArcHit;
    local vector Start;
	local rotator Dir;
	
	if (row == 0)
		MakeNoise(1.0);
		
	if (bShootLeft)
		bShootLeft = False;

	LastAttackTime=Level.TimeSeconds;

    GetAxes(Rotation,X,Y,Z);
	Start = GetFireStart(X,Y,Z);

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

	Dir = Controller.AdjustAim(SavedFireProperties,Start,600);

    arcEnd=GetFireStart(X,Y,Z);
    arcsRemaining = NumArcs;
	PlayOwnedSound(Sound'WeaponSounds.LightningGunChargeUp', SLOT_Misc,,,,1.1,false);


    tmpHitEmitClass = HitEmitterClass;
    tmpTraceRange = TraceRange;

    ReflectNum = 0;
    while (true)
    {

        bDoReflect = false;
        X = Vector(Dir);
        End = Start + tmpTraceRange * X;
        Other = Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
            {
                bDoReflect = true;
            }
            else if ( Other != mainArcHitTarget )
            {
                if ( !Other.bWorldGeometry )
                {
                    Damage = (DamageMin + Rand(DamageMax - DamageMin));// * DamageAtten;
					if ( (Pawn(Other) != None) && (arcsRemaining == NumArcs)
						&& Other.GetClosestBone( HitLocation, X, dist, 'head', HeadShotRadius ) == 'head' )
                        Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, X, DamageTypeHeadShot);
                    else
                    {
						if ( arcsRemaining < NumArcs )
							Damage *= SecDamageMult;
                        Other.TakeDamage(Damage, Instigator, HitLocation, X, DamageType);
					}
                }
                else
					HitLocation = HitLocation + 2.0 * HitNormal;
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Normal(Start - End);
        }
        hitEmitter = Spawn(tmpHitEmitClass,,, HitLocation, Rotator(HitNormal));
        if ( hitEmitter != None )
			hitEmitter.mSpawnVecA = arcEnd;

        if( arcsRemaining == NumArcs )
        {
            mainArcHit = HitLocation + (HitNormal * 2.0);
            if ( Other != None && !Other.bWorldGeometry )
                mainArcHitTarget = Other;
        }

        if (bDoReflect && ++ReflectNum < 4)
        {
            Start = HitLocation;
            Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else if ( arcsRemaining > 0 )
        {
            arcsRemaining--;

            Start = mainArcHit;
            Dir = Rotator(VRand());
            tmpHitEmitClass = SecHitEmitterClass;
            tmpTraceRange = SecTraceDist;
            arcEnd = mainArcHit;
        }
        else
        {
            break;
        }
	}

	bShootLeft = True;
	SpawnLeftShot();
}

function SpawnLeftShot()
{
	local Vector X,Y,Z, End, HitLocation, HitNormal, RefNormal;
    local Actor Other, mainArcHitTarget;
    local int Damage, ReflectNum, arcsRemaining;
    local bool bDoReflect;
    local xEmitter hitEmitter;
    local class<xEmitter> tmpHitEmitClass;
    local float tmpTraceRange, dist;
    local vector arcEnd, mainArcHit;
    local vector Start;
	local rotator Dir;
	
	if (row == 0)
		MakeNoise(1.0);
		
	if (bShootLeft == False)
		return;

	LastAttackTime=Level.TimeSeconds;

    GetAxes(Rotation,X,Y,Z);
	Start = GetFireStart(X,Y,Z);

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

	Dir = Controller.AdjustAim(SavedFireProperties,Start,600);

    arcEnd=GetFireStart(X,Y,Z);
    arcsRemaining = NumArcs;
	PlayOwnedSound(Sound'WeaponSounds.LightningGunChargeUp', SLOT_Misc,,,,1.1,false);


    tmpHitEmitClass = HitEmitterClass;
    tmpTraceRange = TraceRange;

    ReflectNum = 0;
    while (true)
    {

        bDoReflect = false;
        X = Vector(Dir);
        End = Start + tmpTraceRange * X;
        Other = Trace(HitLocation, HitNormal, End, Start, true);

        if ( Other != None && (Other != Instigator || ReflectNum > 0) )
        {
            if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
            {
                bDoReflect = true;
            }
            else if ( Other != mainArcHitTarget )
            {
                if ( !Other.bWorldGeometry )
                {
                    Damage = (DamageMin + Rand(DamageMax - DamageMin));// * DamageAtten;
					if ( (Pawn(Other) != None) && (arcsRemaining == NumArcs)
						&& Other.GetClosestBone( HitLocation, X, dist, 'head', HeadShotRadius ) == 'head' )
                        Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, X, DamageTypeHeadShot);
                    else
                    {
						if ( arcsRemaining < NumArcs )
							Damage *= SecDamageMult;
                        Other.TakeDamage(Damage, Instigator, HitLocation, X, DamageType);
					}
                }
                else
					HitLocation = HitLocation + 2.0 * HitNormal;
            }
        }
        else
        {
            HitLocation = End;
            HitNormal = Normal(Start - End);
        }
        hitEmitter = Spawn(tmpHitEmitClass,,, HitLocation, Rotator(HitNormal));
        if ( hitEmitter != None )
			hitEmitter.mSpawnVecA = arcEnd;

        if( arcsRemaining == NumArcs )
        {
            mainArcHit = HitLocation + (HitNormal * 2.0);
            if ( Other != None && !Other.bWorldGeometry )
                mainArcHitTarget = Other;
        }

        if (bDoReflect && ++ReflectNum < 4)
        {
            Start = HitLocation;
            Dir = Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
        }
        else if ( arcsRemaining > 0 )
        {
            arcsRemaining--;

            Start = mainArcHit;
            Dir = Rotator(VRand());
            tmpHitEmitClass = SecHitEmitterClass;
            tmpTraceRange = SecTraceDist;
            arcEnd = mainArcHit;
        }
        else
        {
            break;
        }
	}

	bShootLeft = False;
	row++;
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
     DamageMin=55
     DamageMax=65
     NumArcs=4
     HeadShotRadius=8.000000
     HeadShotDamageMult=2.000000
     SecDamageMult=0.500000
     DamageType=Class'DEKMonsters209A.DamTypeTechQueen'
     DamageTypeHeadShot=Class'DEKMonsters209A.DamTypeTechQueen'
     HitEmitterClass=Class'DEKRPG209A.RedBoltEmitter'
     SecHitEmitterClass=Class'DEKMonsters209A.RedBoltChild'
     SecTraceDist=300.000000
     TraceRange=3000.000000
     MaxChildren=0
     ScoringValue=16
     GibGroupClass=Class'DEKMonsters209A.DEKTechGibGroup'
     Health=1200
     ControllerClass=Class'DEKMonsters209A.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
}
