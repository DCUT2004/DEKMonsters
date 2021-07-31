class EarthTitan extends DCTitan
	config(satoreMonsterPack);

var Pawn Target;

function PostBeginPlay()
{
	local EarthInv Inv;
	
	Health *= class'ElementalConfigure'.default.EarthHealthMultiplier;
	HealthMax *= class'ElementalConfigure'.default.EarthHealthMultiplier;
	ScoringValue *= class'ElementalConfigure'.default.EarthScoreMultiplier;
	GroundSpeed *= class'ElementalConfigure'.default.EarthGroundSpeedMultiplier;
	AirSpeed *= class'ElementalConfigure'.default.EarthAirSpeedMultiplier;
	WaterSpeed *= class'ElementalConfigure'.default.EarthWaterSpeedMultiplier;
	Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
	SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*class'ElementalConfigure'.default.EarthDrawscaleMultiplier/2));
	SetDrawScale(Drawscale*class'ElementalConfigure'.default.EarthDrawscaleMultiplier);
	SetCollisionSize(CollisionRadius*class'ElementalConfigure'.default.EarthDrawscaleMultiplier, CollisionHeight*class'ElementalConfigure'.default.EarthDrawscaleMultiplier);
	
	if (Instigator != None)
	{
		Inv = EarthInv(Instigator.FindInventoryType(class'EarthInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(class'EarthInv');
			Inv.GiveTo(Instigator);
		}
	}
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.Class == class'Missioncow' || P.class == class'EarthBrute' || P.Class == class'EarthGasbagChild' || P.Class == class'EarthSkaarjPupaeChild' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthWarlord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarj' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthBehemoth' || P.Class == class'EarthEliteKrall' || P.Class == class'EarthEliteMercenary');
	else
		return ( P.class == class'EarthBrute' || P.Class == class'EarthGasbagChild' || P.Class == class'EarthSkaarjPupaeChild' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthWarlord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarj' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthBehemoth' || P.Class == class'EarthEliteKrall' || P.Class == class'EarthEliteMercenary');
}

function RangedAttack(Actor A)
{
	local EarthHealerInv Inv;
	local float decision;
	
	decision = FRand();
	
	if (Pawn(A) != None)
		Target = Pawn(A);
	
	if (Instigator != None && Instigator.Controller != None)
	{
		Inv = EarthHealerInv(Instigator.FindInventoryType(class'EarthHealerInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(class'EarthHealerInv', Instigator);
			Inv.GiveTo(Instigator);
			if (Inv != None)
				Inv.SetHealAmount(default.ScoringValue);
		}
	}
	Super.RangedAttack(A);
}

function SpawnRock()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local EarthTitanProjectile Proj;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 1.2*CollisionRadius * X + 0.4 * CollisionHeight * Z;
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

	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	if (FRand() < 0.4)
	{
		Proj=Spawn(class'EarthTitanProjectile',,,FireStart,FireRotation);
		if(Proj!=none && Target != None)
		{
			Proj.Target = Target;
		}
		return;
	}

	Proj=Spawn(class'EarthTitanProjectile',,,FireStart,FireRotation);
	if(Proj != none && Target != None)
	{
		Proj.Target = Target;
	}
	FireStart=Location + 1.2*CollisionRadius * X -40*Y+ 0.4 * CollisionHeight * Z;
	Proj=Spawn(class'EarthTitanProjectile',,,FireStart,FireRotation);
	if(Proj!=none && Target != None)
	{
		Proj.Target = Target;
	}
	bStomped=false;
	ThrowCount++;
	if(ThrowCount>=2)
	{
		bThrowed=true;
		ThrowCount=0;
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local IceInv Inv;
	
	if (Damage > 0 && instigatedBy != None && instigatedBy.IsA('Monster') && instigatedBy.Controller != None && !instigatedBy.Controller.SameTeamAs(Self.Controller))
	{
		Inv = IceInv(instigatedBy.FindInventoryType(class'IceInv'));
		if (Inv != None)
		{
			Damage *= class'ElementalConfigure'.default.IceOnEarthDamageMultiplier;
		}
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters208AD.EarthTitanAmmo'
     GibGroupClass=Class'DEKMonsters208AD.EarthGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Titan_Earth-Shader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Titan_Earth-Shader'
}
