class FireGiantRazorFly extends DCGiantRazorfly;

var int HeatLifespan;
var int HeatModifier;
var RPGRules RPGRules;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
	else
		return ( P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
}

simulated function PostBeginPlay()
{
	Local GameRules G;
	local FireInv Inv;
	
	if (Instigator != None)
	{
		Health *= class'ElementalConfigure'.default.FireHealthMultiplier;
		HealthMax *= class'ElementalConfigure'.default.FireHealthMultiplier;
		ScoringValue *= class'ElementalConfigure'.default.FireScoreMultiplier;
		GroundSpeed *= class'ElementalConfigure'.default.FireGroundSpeedMultiplier;
		AirSpeed *= class'ElementalConfigure'.default.FireAirSpeedMultiplier;
		WaterSpeed *= class'ElementalConfigure'.default.FireWaterSpeedMultiplier;
		Mass *= class'ElementalConfigure'.default.FireMassMultiplier;
		SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*class'ElementalConfigure'.default.FireDrawscaleMultiplier/2));
		SetDrawScale(Drawscale*class'ElementalConfigure'.default.FireDrawscaleMultiplier);
		SetCollisionSize(CollisionRadius*class'ElementalConfigure'.default.FireDrawscaleMultiplier, CollisionHeight*class'ElementalConfigure'.default.FireDrawscaleMultiplier);
		
		Inv = FireInv(Instigator.FindInventoryType(class'FireInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(class'FireInv');
			Inv.GiveTo(Instigator);
		}
	}
	
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}
	
	Super.PostBeginPlay();
}

function PoisonTarget(Actor Victim, class<DamageType> DamageType)
{
	local SuperHeatInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	if (DamageType == class'DamTypeSuperHeat' )
		return;

	P = Pawn(Victim);
	
	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
			Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
			if (Inv == None)
			{
				Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
				Inv.Modifier = HeatModifier;
				Inv.LifeSpan = HeatLifespan;
				Inv.RPGRules = RPGRules;
				Inv.GiveTo(P);
			}
			else
			{
				Inv.Modifier = max(HeatModifier,Inv.Modifier);
				Inv.LifeSpan = max(HeatLifespan,Inv.LifeSpan);
			}
			if (Inv == class'FreezeInv')
				return;
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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local EarthInv Inv;
	
	if (Damage > 0 && instigatedBy != None && instigatedBy.IsA('Monster') && instigatedBy.Controller != None && !instigatedBy.Controller.SameTeamAs(Self.Controller))
	{
		Inv = EarthInv(instigatedBy.FindInventoryType(class'EarthInv'));
		if (Inv != None)
		{
			Damage *= class'ElementalConfigure'.default.EarthOnFireDamageMultiplier;
		}
	}
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

defaultproperties
{
     HeatLifespan=4
     HeatModifier=2
     GibGroupClass=Class'DEKMonsters209E.FireGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.FireMonsters.FireRazorFlyShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.FireMonsters.FireRazorFlyShader'
}
