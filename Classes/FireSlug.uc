class FireSlug extends PoisonSlug;

var int HeatLifespan;
var int HeatModifier;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
	else
		return ( P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
}

function PostBeginPlay()
{
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
	
	Super.PostBeginPlay();
}

function BurnTarget(Actor Victim, class<DamageType> DamageType)
{
	local Pawn P;
	local StatusEffectManager VictimStatusManager;

	if (DamageType == class'DamTypeSuperHeat' )
		return;

	P = Pawn(Victim);
	
	if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		VictimStatusManager = Class'StatusEffectManager'.static.GetStatusEffectmanager(P);
		if (VictimStatusManager == None)
			return;
		VictimStatusManager.AddStatusEffect(Class'StatusEffect_Burn', -(abs(HeatModifier)), True, HeatLifespan, bDispellable, bStackable);
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

		BurnTarget(Controller.Target, class'MeleeDamage');

		return super.MeleeDamageTarget(hitdamage, pushdir);
	}
	return false;
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	//These local variables are just for bio spawning
    local int i;
    local FireSlugMiniBioGlob Glob;
    local rotator rot;
    local vector start;

    AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;

    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
	if(PhysicsVolume.bWaterVolume)
		PlayAnim('Dead2',1.2,0.05);
	else
	{
		SetPhysics(PHYS_Falling);
		PlayAnim('Dead1',1.2,0.05);
	}

    //When killed, Slug ejects two goops of bio.
    if ( Role == ROLE_Authority )
	{
        for (i=0; i<2; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'FireSlugMiniBioGlob',, '', Start, rot);
		}
	}
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
	bDispellable=False
	bStackable=True
     HeatLifespan=4
     HeatModifier=2
     AmmunitionClass=Class'DEKMonsters999X.FireSlugAmmo'
     GibGroupClass=Class'DEKMonsters999X.FireGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.FireMonsters.FireSlithShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.FireMonsters.FireSlithShader'
}
