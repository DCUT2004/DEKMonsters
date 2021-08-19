class IceKrall extends DCKrall;

function PostBeginPlay()
{
	local IceInv Inv;
	
	if (Instigator != None)
	{
		Health *= class'ElementalConfigure'.default.IceHealthMultiplier;
		HealthMax *= class'ElementalConfigure'.default.IceHealthMultiplier;
		ScoringValue *= class'ElementalConfigure'.default.IceScoreMultiplier;
		GroundSpeed *= class'ElementalConfigure'.default.IceGroundSpeedMultiplier;
		AirSpeed *= class'ElementalConfigure'.default.IceAirSpeedMultiplier;
		WaterSpeed *= class'ElementalConfigure'.default.IceWaterSpeedMultiplier;
		Mass *= class'ElementalConfigure'.default.IceMassMultiplier;
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
	bSuperAggressive = (FRand() < 0.2);
	
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug');
	else
		return ( P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug');
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
     AmmunitionClass=Class'DEKMonsters208AH.IceKrallAmmo'
     GibGroupClass=Class'DEKMonsters208AH.IceGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.IceMonsters.IceKrallShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.IceMonsters.IceKrallShader'
}
