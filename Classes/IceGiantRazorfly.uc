class IceGiantRazorfly extends DCGiantRazorfly;

var int IceLifespan;
var int IceModifier;
var Sound FreezeSound;
var config bool bDispellable, bStackable;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug');
	else
		return ( P.class == class'IceBrute' || P.Class == class'IceChildGasbag' || P.Class == class'IceGasbag' || P.Class == class'IceGiantGasbag' || P.Class == class'IceKrall' || P.Class == class'IceWarlord' || P.Class == class'IceManta' || P.Class == class'IceMercenary' || P.Class == class'IceNali' || P.Class == class'IceNaliFighter' || P.Class == class'IceRazorfly' || P.Class == class'IceSkaarjPupae' || P.Class == class'IceSkaarjSniper' || P.Class == class'IceSkaarjFreezing' || P.Class == class'IceSlith' || P.Class == class'IceSlug');
}

simulated function PostBeginPlay()
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
	
	Super.PostBeginPlay();
}

function FreezeTarget(Actor Victim, class<DamageType> DamageType)
{
	local Pawn P;
	local StatusEffectManager VictimStatusManager;

	P = Pawn(Victim);
	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		VictimStatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(P);
		if (VictimStatusManager == None)
			return;
		VictimStatusManager.AddStatusEffect(Class'StatusEffect_Speed', -(abs(IceModifier)), True, IceLifespan, bDispellable, bStackable);
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
		FreezeTarget(Controller.Target, class'MeleeDamage');

		return super.MeleeDamageTarget(hitdamage, pushdir);
	}
	return false;
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
	bDispellable=False
	bStackable=True
     IceLifespan=3
     IceModifier=1
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     GibGroupClass=Class'DEKMonsters999X.IceGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.IceMonsters.IceRazorFlyShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.IceMonsters.IceRazorFlyShader'
}
