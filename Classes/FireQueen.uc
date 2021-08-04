class FireQueen extends DCQueen
	config(satoreMonsterPack);

var bool bRocketDir;
var int HeatLifespan;
var int HeatModifier;
var FireQueenShield eShield;

var ColorModifier FireQueenFadeOutSkin;

function PostBeginPlay()
{
	local FireInv Inv;
	
	if (Instigator != None)
	{
		Health *= class'ElementalConfigure'.default.FireBossHealthMultiplier;
		HealthMax *= class'ElementalConfigure'.default.FireBossHealthMultiplier;
		ScoringValue *= class'ElementalConfigure'.default.FireScoreMultiplier;
		GroundSpeed *= class'ElementalConfigure'.default.FireGroundSpeedMultiplier;
		AirSpeed *= class'ElementalConfigure'.default.FireAirSpeedMultiplier;
		WaterSpeed *= class'ElementalConfigure'.default.FireWaterSpeedMultiplier;
		Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
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
	
    FireQueenFadeOutSkin= new class'ColorModifier';
	FirequeenFadeOutSkin.Material=Skins[0];
	Skins[0]=FireQueenFadeOutSkin;
	
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
	else
		return ( P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
}

function RangedAttack(Actor A)
{
	local float decision;

	if ( bShotAnim )
		return;
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

function SpawnChildren()
{
	local NavigationPoint N;
	local FireChildSkaarjPupae P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'FireChildSkaarjPupae' ,self,,N.Location);
		    if(P!=none)
		    {
		    	P.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}

}

simulated function Destroyed()
{
	FireQueenFadeOutSkin=none;
    if(eShield!=none)
    	eShield.Destroy();
    super.Destroyed();
}

function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.5 * CollisionRadius * (X+Z-Y);
}

simulated function Tick(float DeltaTime)
{
	if(bTeleporting)
	{
		AChannel-=300 *DeltaTime;
	}
	else
		AChannel=255;
	if (FireQueenFadeOutSkin != None)
		FireQueenFadeOutSkin.Color.A=AChannel;

	if(MonsterController(Controller)!=none && Controller.Enemy==none)
	{
		if(MonsterController(Controller).FindNewEnemy())
		{
			SetAnimAction('Meditate');
			GotoState('Teleporting');
			bJustScreamed = false;
	    }
	}


	super.Tick(DeltaTime);
}

function SpawnShield()
{
//	log("SpawneShield");
	//New eShield
	if(eShield!=none)
		eShield.Destroy();

	eShield = Spawn(class'FireQueenShield',,,Location);
	if(eShield!=none)
	{
		eShield.SetDrawScale(eShield.DrawScale*(drawscale/default.DrawScale));
	    eShield.AimedOffset.X=CollisionRadius;
		eShield.AimedOffset.Y=CollisionRadius;
		eShield.SetCollisionSize(CollisionRadius*1.2,CollisionHeight*1.2);
	}
//	eShield.SetBase(self);

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

function SpawnShot()
{
		local vector FireStart,X,Y,Z;
        local rotator ProjRot;
		local FireQueenSeekingProjectile S;
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
			S = Spawn(class'FireQueenSeekingProjectile',,,FireStart,ProjRot);
	        S.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);

			if ( bRocketDir )
				ProjRot.Yaw += 3072;
			else
				ProjRot.Yaw -= 3072;
			bRocketDir = !bRocketDir;
			S = Spawn(class'FireQueenSeekingProjectile',,,FireStart,ProjRot);
	        S.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);
        }
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
     AmmunitionClass=Class'DEKMonsters208AF.FireQueenAmmo'
     GibGroupClass=Class'DEKMonsters208AF.FireGibGroup'
     ControllerClass=Class'DEKMonsters208AF.DCMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.FireMonsters.FireQueenFinalBlend'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.FireMonsters.FireQueenFinalBlend'
}
