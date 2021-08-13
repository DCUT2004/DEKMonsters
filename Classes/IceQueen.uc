class IceQueen extends SMPQueen
	config(satoreMonsterPack);

var bool bRocketDir;
var int IceLifespan;
var int IceModifier;

function PostBeginPlay()
{
	local IceInv Inv;
	
	if (Instigator != None)
	{
		Health *= class'ElementalConfigure'.default.IceBossHealthMultiplier;
		HealthMax *= class'ElementalConfigure'.default.IceBossHealthMultiplier;
		ScoringValue *= class'ElementalConfigure'.default.IceScoreMultiplier;
		GroundSpeed *= class'ElementalConfigure'.default.IceGroundSpeedMultiplier;
		AirSpeed *= class'ElementalConfigure'.default.IceAirSpeedMultiplier;
		WaterSpeed *= class'ElementalConfigure'.default.IceWaterSpeedMultiplier;
		Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
		SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*class'ElementalConfigure'.default.IceDrawscaleMultiplier/2));
		SetDrawScale(Drawscale*class'ElementalConfigure'.default.IceDrawscaleMultiplier);
		SetCollisionSize(CollisionRadius*class'ElementalConfigure'.default.IceDrawscaleMultiplier, CollisionHeight*class'ElementalConfigure'.default.IceDrawscaleMultiplier);
		
		Inv = IceInv(Instigator.FindInventoryType(class'IceInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(class'IceInv');
			Inv.GiveTo(Instigator);
		}
	}
	Super(SMPQueen).PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug');
}

function SpawnChildren()
{
	local NavigationPoint N;
	local IceChildSkaarjPupae P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'IceChildSkaarjPupae' ,self,,N.Location);
		    if(P!=none)
		    {
		    	P.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

function PoisonTarget(Actor Victim, class<DamageType> DamageType)
{
	local FreezeInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	P = Pawn(Victim);
	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
			Inv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
			if (Inv == None)
			{
				Inv = spawn(class'FreezeInv', P,,, rot(0,0,0));
				Inv.Modifier = IceModifier;
				Inv.LifeSpan = IceLifespan;
				Inv.GiveTo(P);
			}
			else
			{
				Inv.Modifier = max(IceModifier,Inv.Modifier);
				Inv.LifeSpan = max(IceLifespan,Inv.LifeSpan);
			}
		}
		else
			return;
	}
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	
	// check if still in melee range
	if ( (Controller.Target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z) 
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{	
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;

		// hee hee  got a hit. Poison the dude
		PoisonTarget(Controller.Target, class'MeleeDamage');

		return super.MeleeDamageTarget(hitdamage, pushdir);
	}
	return false;
}

function SpawnShot()
{
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;
	local IceQueenSeekingProjectile S;
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

		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,1000);

		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		S = Spawn(class'IceQueenSeekingProjectile',,,FireStart,ProjRot);
		if (S != None)
			S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);

		if ( bRocketDir )
			ProjRot.Yaw += 3072;
		else
			ProjRot.Yaw -= 3072;
		bRocketDir = !bRocketDir;
		S = Spawn(class'IceQueenSeekingProjectile',,,FireStart,ProjRot);
		if (S != None)
			S.Seeking = Controller.Enemy;
		PlaySound(FireSound,SLOT_Interact);
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local FireInv Inv;
	
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
     IceLifespan=3
     IceModifier=3
     AmmunitionClass=Class'DEKMonsters208AG.IceQueenAmmo'
     GibGroupClass=Class'DEKMonsters208AG.IceGibGroup'
     ControllerClass=Class'DEKMonsters208AG.DCMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.IceMonsters.IceQueenFinalBlend'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.IceMonsters.IceQueenFinalBlend'
}
