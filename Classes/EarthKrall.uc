class EarthKrall extends DCKrall;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.Class == class'Missioncow' || P.class == class'EarthBrute' || P.Class == class'EarthGasbagChild' || P.Class == class'EarthSkaarjPupaeChild' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthWarlord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' ||  P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarj' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthBehemoth' || P.Class == class'EarthEliteKrall' || P.Class == class'EarthEliteMercenary');
	else
		return ( P.class == class'EarthBrute' || P.Class == class'EarthGasbagChild' || P.Class == class'EarthSkaarjPupaeChild' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthWarlord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' ||  P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarj' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthBehemoth' || P.Class == class'EarthEliteKrall' || P.Class == class'EarthEliteMercenary');
}

function PostBeginPlay()
{
	local EarthInv Inv;
	
	if (Instigator != None)
	{
		Health *= class'ElementalConfigure'.default.EarthHealthMultiplier;
		HealthMax *= class'ElementalConfigure'.default.EarthHealthMultiplier;
		ScoringValue *= class'ElementalConfigure'.default.EarthScoreMultiplier;
		GroundSpeed *= class'ElementalConfigure'.default.EarthGroundSpeedMultiplier;
		AirSpeed *= class'ElementalConfigure'.default.EarthAirSpeedMultiplier;
		WaterSpeed *= class'ElementalConfigure'.default.EarthWaterSpeedMultiplier;
		Mass *= class'ElementalConfigure'.default.EarthMassMultiplier;
		SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*class'ElementalConfigure'.default.EarthDrawscaleMultiplier/2));
		SetDrawScale(Drawscale*class'ElementalConfigure'.default.EarthDrawscaleMultiplier);
		SetCollisionSize(CollisionRadius*class'ElementalConfigure'.default.EarthDrawscaleMultiplier, CollisionHeight*class'ElementalConfigure'.default.EarthDrawscaleMultiplier);
		
		Inv = EarthInv(Instigator.FindInventoryType(class'EarthInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(class'EarthInv');
			Inv.GiveTo(Instigator);
		}
	}
	
	Super.PostBeginPlay();
}

function RangedAttack(Actor A)
{
	local EarthHealerInv Inv;
	
	Inv = EarthHealerInv(Instigator.FindInventoryType(class'EarthHealerInv'));
	if (Inv == None)
	{
		Inv = Instigator.Spawn(class'EarthHealerInv', Instigator);
		Inv.GiveTo(Instigator);
		if (Inv != None)
			Inv.SetHealAmount(default.ScoringValue);
	}
	
	Super.RangedAttack(A);
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
     AmmunitionClass=Class'DEKMonsters209D.EarthKrallAmmo'
     GibGroupClass=Class'DEKMonsters209D.EarthGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Krall_Earth-Shader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Krall_Earth-Shader'
}
