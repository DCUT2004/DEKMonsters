class EarthQueen extends SMPQueen
	config(satoreMonsterPack);

var config int EggChance, MaxEggs;
var int EggCount;
var EarthQueenShield eShield;

simulated function PostBeginPlay()
{
	local EarthInv Inv;
	
	if (Instigator != None)
	{
		Health *= class'ElementalConfigure'.default.EarthBossHealthMultiplier;
		HealthMax *= class'ElementalConfigure'.default.EarthBossHealthMultiplier;
		ScoringValue *= class'ElementalConfigure'.default.EarthScoreMultiplier;
		GroundSpeed *= class'ElementalConfigure'.default.EarthGroundSpeedMultiplier;
		AirSpeed *= class'ElementalConfigure'.default.EarthAirSpeedMultiplier;
		WaterSpeed *= class'ElementalConfigure'.default.EarthWaterSpeedMultiplier;
		Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
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
	
	EggCount = 0;
	
	QueenFadeOutSkin= new class'ColorModifier';
	QueenFadeOutSkin.Material=Skins[0];
	Skins[0]=QueenFadeOutSkin;
	
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'EarthBrute' || P.Class == class'EarthGasbagChild' || P.Class == class'EarthSkaarjPupaeChild' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthWarlord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarj' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthBehemoth' || P.Class == class'EarthEliteKrall' || P.Class == class'EarthEliteMercenary');
}

function RangedAttack(Actor A)
{
	local float decision;
	local EarthHealerInv Inv;
	
	if ( bShotAnim )
		return;
	Inv = EarthHealerInv(Instigator.FindInventoryType(class'EarthHealerInv'));
	if (Inv == None)
	{
		Inv = Instigator.Spawn(class'EarthHealerInv', Instigator);
		Inv.GiveTo(Instigator);
		if (Inv != None)
			Inv.SetHealAmount(default.ScoringValue);
	}
	
	decision = FRand();
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		if (decision < 0.4)
		{
			PlaySound(Stab, SLOT_Interact);
 			SetAnimAction('Stab');
 		}
		else if (decision < 0.7)
		{
			PlaySound(Claw, SLOT_Interact);
			SetAnimAction('Claw');
		}
		else
		{
			PlaySound(Claw, SLOT_Interact);
			SetAnimAction('Gouge');
		}

	}
	else if (!Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetAnimAction(MovementAnims[0]);
		bShotAnim = true;
		return;

	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
		bJustScreamed = false;
	}
	else if (!bJustScreamed && (decision < 0.15) )
		Scream();
	else if ( (eShield != None) && (decision < 0.5)
		&& (((A.Location - Location) dot (eShield.Location - Location)) > 0) )
		Scream();
	else if((decision < 0.8 && eShield != None ) || decision < 0.4)
	{
		if ( eShield != None )
			eShield.Destroy();
		row = 0;
		bJustScreamed = false;
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
	}
	else if(eShield==none && (decision < 0.9))
	{
		SetAnimAction('Shield');
	}
	else if(!IsInState('Teleporting') && (decision < 0.6))
	{
		SetAnimAction('Meditate');
		GotoState('Teleporting');
	}
	else
	{
		if ( eShield != None )
			eShield.Destroy();
		row = 0;
		bJustScreamed = false;
		SetAnimAction('Shoot1');
		PlaySound(Shoot, SLOT_Interact);
	}
		
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function SpawnShield()
{
	if(eShield!=none)
		eShield.Destroy();

	eShield = Spawn(class'EarthQueenShield',,,Location);
	if(eShield!=none)
	{
		eShield.SetDrawScale(eShield.DrawScale*(drawscale/default.DrawScale));
	    eShield.AimedOffset.X=CollisionRadius;
		eShield.AimedOffset.Y=CollisionRadius;
		eShield.SetCollisionSize(CollisionRadius*1.2,CollisionHeight*1.2);
	}
}

function SpawnChildren()
{
	return;
}

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	local Vector HitDir;
	local Vector FaceDir;
	FaceDir=vector(Rotation);
	HitDir = Normal(Location-HitLocation+ Vect(0,0,8));
	RefNormal=FaceDir;
	if ( FaceDir dot HitDir < -0.26 && eShield!=none) // 68 degree protection arc
	{
		eShield.Flash(Damage);

		return true;
	}
	return false;
}

function SpawnShot()
{
	local vector X,Y,Z, projStart;
	local EarthQueenEgg Egg;

	if(Controller==none)
		return;
	GetAxes(Rotation,X,Y,Z);

	if (row == 0)
		MakeNoise(1.0);

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z + 0.2 * CollisionRadius * Y;
	if (Rand(99) <= EggChance && EggCount < MaxEggs)
	{
		Egg = spawn(class'EarthQueenEgg' ,self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));
		if (Egg != None)
		{
			Egg.Parent = Self;
			EggCount++;
		}
	}
	else
		spawn(class'DEKMonsters209B.EarthQueenThorn',self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z - 0.2 * CollisionRadius * Y;
	if (Rand(99) <= EggChance && EggCount < MaxEggs)
	{
		Egg = spawn(class'EarthQueenEgg' ,self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));
		if (Egg != None)
		{
			Egg.Parent = Self;
			EggCount++;
		}
	}
	else
		spawn(class'DEKMonsters209B.EarthQueenThorn',self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));
	row++;
}

state Teleporting
{
	function Tick(float DeltaTime)
	{
		if(AChannel<20)
		{
            if (ROLE == ROLE_Authority)
				Teleport();
			GotoState('');
		}
		global.Tick(DeltaTime);
	}


	function RangedAttack(Actor A)
	{
		return;
	}
	function BeginState()
	{
		if(Controller.Enemy==none)
		{
			GotoState('');
			return;
		}
		bTeleporting=true;
		Acceleration = Vect(0,0,0);
		bUnlit = true;
		AChannel=255;
		Spawn(class'SMPQueenTeleportEffect',,,Location);
	}

	function EndState()
	{
        bTeleporting=false;
		bUnlit = true;
		AChannel=255;

		LastTelepoTime=Level.TimeSeconds;
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

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;

	HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;
	LifeSpan = RagdollLifeSpan;
    if(eShield!=none)
    	eShield.Destroy();
    GotoState('Dying');

	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);

	PlayAnim('OutCold',0.7, 0.1);
}

simulated function Destroyed()
{
    if(eShield!=none)
    	eShield.Destroy();
    super.Destroyed();
}

defaultproperties
{
     EggChance=10
     MaxEggs=5
     GibGroupClass=Class'DEKMonsters209B.EarthGibGroup'
     ControllerClass=Class'DEKMonsters209B.DCMonsterController'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Queen_Earth-Shader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.EarthMonsters.Queen_Earth-Shader'
}
