class EarthWarlord extends DCWarlord
	config(satoreMonsterPack);

var config float TraceThickness, TraceRange, OuterTraceOffset, DamageMin, DamageMax, DamageMomentum;
var() config float BeamInterval;
var() float LastBeamTime;

var class<DamageType> BeamDamageType;

#exec  AUDIO IMPORT NAME="EarthWarlordFire" FILE="Sounds\EarthWarlordFire.WAV" GROUP="MonsterSounds"

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
	
	Health *= class'ElementalConfigure'.default.EarthBossHealthMultiplier;
	HealthMax *= class'ElementalConfigure'.default.EarthBossHealthMultiplier;
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
	if (Level.TimeSeconds - LastBeamTime > BeamInterval)
	{
		LastBeamTime = Level.TimeSeconds;
		FireBeam();
	}
	
	Super.RangedAttack(A);
}

function FireProjectile()
{
	return;
}

function FireBeam()
{	
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;

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
		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		TraceFire(FireStart, ProjRot);
		PlaySound(FireSound,SLOT_Interact);
	if ( Physics == PHYS_Flying )
		SetAnimAction('FlyFire');
	else
		SetAnimAction('Fire');
	}
}

function TraceFire(Vector Start, Rotator Dir)
{
	local vector X, Y, Z, HitLocation, HitNormal, ImpactNormal, RefNormal;
	local vector TraceStart, TraceEnd;
	local float Dist, TraceDist, Damage;
	local Actor Other;
	local int i, j;
	local array<DEKOdinThickTraceHelper.THitInfo> Hits;

	GetAxes(Dir + rot(0,0,1000), X, Y, Z);

	for (i = -1; i <= 1 && TraceDist < TraceRange; ++i)
	{
		for (j = -1; j <= 1; j++)
		{
			if (Abs(i) + Abs(j) >= 1)
			{
				TraceStart = Start + OuterTraceOffset * (i * Y + j * Z) / Sqrt(Max(i * i + j * j, 1));
				TraceEnd = TraceStart + TraceRange * X;
				Other = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false);
				if (Other == None)
				{
					TraceDist = TraceRange;
					ImpactNormal = vect(0,0,0);
					break;
				}
				Dist = VSize(HitLocation - TraceStart);
				if (Dist > TraceDist)
				{
					TraceDist = Dist;
					ImpactNormal = HitNormal;
				}
			}
		}
	}

	TraceStart = Start;
	TraceEnd = Start + TraceDist * X;

	Hits = class'DEKOdinThickTraceHelper'.static.TraceHits(Self, TraceStart, TraceEnd, TraceThickness);
	for (i = 0; i < Hits.Length; i++)
	{
		Other = Hits[i].HitActor;

		if (Other.bBlockProjectiles || ONSPowerCoreShield(Other) != None)
			break;

		if (Other != Self && Other != Instigator && (Other.bWorldGeometry || Other.bProjTarget || Other.bBlockActors))
		{
			Damage = RandRange(DamageMin, DamageMax);
			if (Other.TraceThisActor(HitLocation, HitNormal, TraceEnd, TraceStart))
			{
				// grazing shot, reduce damage
				Damage *= 0.5;
			}
			if (ONSPowerCore(Other) == None && ONSPowerNodeEnergySphere(Other) == None)  // Sweet Hackaliciousness
				Other.TakeDamage(Damage, Instigator, HitLocation, DamageMomentum*X, BeamDamageType);
			HitNormal = vect(0,0,0);
			HitNormal = Hits[i].Hitnormal;
			if (Pawn(Other) != None && Pawn(Other).Weapon != None && Pawn(Other).Weapon.CheckReflect(HitLocation, RefNormal, (DamageMin + DamageMax) / 3))
			{
				// successfully blocked by shieldgun, apply reduced damage but increased DamageMomentum
				Other.TakeDamage(Damage * 0.3, Instigator, HitLocation, 1.5 * DamageMomentum * Normal(HitLocation - Start), BeamDamageType);
			}
			else
			{
				Other.TakeDamage(Damage, Instigator, HitLocation, DamageMomentum * Normal(HitLocation - Start), BeamDamageType);
			}
		}
	}
	SpawnBeamEffect(Start, Dir, TraceEnd, ImpactNormal, int(TraceDist) + 50);

	NetUpdateTime = Level.TimeSeconds - 1;
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int TraceDistance)
{
	local EarthWarlordBeamEmitter Beam;

	Beam = Spawn(class'EarthWarlordBeamEmitter', None,, Start, Dir);
	Beam.AimAt(HitLocation, HitNormal);
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
	 BeamInterval=1.50000
     TraceThickness=30.000000
     TraceRange=20000.000000
     OuterTraceOffset=35.000000
     DamageMin=20.000000
     DamageMax=30.000000
     DamageMomentum=10000.000000
     BeamDamageType=Class'DEKMonsters208AE.DamTypeEarthWarlordBeam'
     FireSound=Sound'DEKMonsters208AE.MonsterSounds.EarthWarlordFire'
     GibGroupClass=Class'DEKMonsters208AE.EarthGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Warlord_Earth-Shader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Warlord_Earth-Shader'
}
