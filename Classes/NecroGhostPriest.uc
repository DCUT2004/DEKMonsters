class NecroGhostPriest extends Monster
	config(satoreMonsterPack);

var ColorModifier FadeOutSkin;
var vector TelepDest;
var		byte AChannel;
var float LastTelepoTime;
var bool bTeleporting;
var NecroGhostPriestHealingOrb Orb;
var config float HealRadius, TargetRadius;
var config int HealAmount;
var NecroGhostPriestProj Curse;

replication
{
	reliable if(Role==ROLE_Authority )
         bTeleporting;
}

simulated function PostBeginPlay()
{
	local MagicShieldInv Inv;
	local ComboInv ComboInv;
	
	Super.PostBeginPlay();
	FadeOutSkin= new class'ColorModifier';
	FadeOutSkin.Material=Skins[0];
	Skins[0]=FadeOutSkin;
	
	if (Instigator != None)
	{
		Inv = MagicShieldInv(Instigator.FindInventoryType(class'MagicShieldInv'));
		ComboInv = ComboInv(Instigator.FindInventoryType(class'ComboInv'));
		if (ComboInv == None)
		{
			ComboInv = Instigator.Spawn(class'ComboInv');
			ComboInv.GiveTo(Instigator);
		}
		if (Inv == None)
		{
			Inv = spawn(class'MagicShieldInv');
			Inv.GiveTo(Instigator);
		}
	}
}

simulated function Destroyed()
{
	FadeOutSkin=none;
	super.Destroyed();
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'Monster');
}

function RangedAttack(Actor A)
{
	local float decision;
	local Pawn P;
	
	Super.RangedAttack(A);

	decision = FRand();
	
	P = Pawn(A);

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Swim_Tread');		
		//DoHealing();
		if (P != None && Curse == None)
		{
			MisfortuneCurse(P);
		}
	}
	else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('gesture_point');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'mn_hit10', SLOT_Talk); 
	}
	else if(VSize(A.Location-Location)>7000 && (decision < 0.70))
	{
		SetAnimAction('Swim_Tread');
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
		GotoState('Teleporting');
	}
	else
	{
		if (Orb == None)
			SpawnHealingOrb();
		else if (P != None && Curse == None)
		{
			MisfortuneCurse(P);
		}
		else
		{
			//DoHealing();
			SetAnimAction('Swim_Tread');
		}
	}

	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function MisfortuneCurse(Pawn P)
{
	Curse = Spawn(class'NecroGhostPriestProj',,, Self.Location, Self.Rotation);
	if (Curse != None)
		Curse.Seeking = P;
}

function SpawnHealingOrb()
{
	local Actor A;
	local FriendlyMonsterInv Inv;
	local Controller C, BestC;
	local int LeastHealth;
	
	C = Level.ControllerList;
	BestC = None;
	LeastHealth = 5000;
	
	
	while (C != None)
	{
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.Pawn.IsA('Monster')
		     && VSize(C.Pawn.Location - Instigator.Location) < TargetRadius && FastTrace(C.Pawn.Location, Instigator.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.bCanFly)
		{
			Inv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
			if (Inv == None && C.Pawn.Health < LeastHealth)
			{
				LeastHealth = C.Pawn.Health;
				BestC = C;
			}
		}
		C = C.NextController;
	}
	
	if ((LeastHealth > 0) && (BestC != None) && (BestC.Pawn != None))
		Orb = Spawn(class'NecroGhostPriestHealingOrb',Instigator,,BestC.Pawn.Location);
	else
		Orb = Spawn(class'NecroGhostPriestHealingOrb',Instigator,,Instigator.Location);
	GotoState('Teleporting');
	
	if (rand(99) <= 15)
	{
		A = Instigator.spawn(class'NecroGhostPriestLight', Instigator,, Instigator.Location, Instigator.Rotation);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

function DoHealing()
{
	local FriendlyMonsterInv FInv;
	local Monster M;
	local Actor A;
	
	ForEach DynamicActors(class'Monster',M)
	{
		if ( M != None && M != Instigator && M.Health > 0
		&& VSize(M.Location - Instigator.Location) < HealRadius && FastTrace(M.Location,Instigator.Location))
		{
			FInv = FriendlyMonsterInv(M.FindInventoryType(class'FriendlyMonsterInv'));
			if (FInv == None && !M.IsA('HealerNali') && !M.IsA('MissionCow') && !M.IsA('NecroGhostPriest'))
			{
				M.GiveHealth(HealAmount, M.default.HealthMax);
				M.Spawn(class'HealerNaliHealthFX',M,, M.Location, M.Rotation);
			}
		}
	}
	
	if (rand(99) <= 15)
	{
		A = Instigator.spawn(class'NecroGhostPriestLight', Instigator,, Instigator.Location, Instigator.Rotation);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

function Teleport()
{
		local rotator EnemyRot;

		if ( Role == ROLE_Authority )
			ChooseDestination();
		SetLocation(TelepDest+vect(0,0,1)*CollisionHeight/2);
		AChannel=0;
		if(Controller.Enemy!=none)
			EnemyRot = rotator(Controller.Enemy.Location - Location);
		EnemyRot.Pitch = 0;
		setRotation(EnemyRot);
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
}

function ChooseDestination()
{
	local NavigationPoint N;
	local vector ViewPoint, Best;
	local float rating, newrating;
	local Actor jActor;
	Best = Location;
	TelepDest = Location;
	rating = 0;
	if(Controller.Enemy==none)
		return;
	for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
			newrating = 0;

			ViewPoint = N.Location +vect(0,0,1)*CollisionHeight/2;
			if (FastTrace( Controller.Enemy.Location,ViewPoint))
				newrating += 20000;
			newrating -= VSize(N.Location - Controller.Enemy.Location) + 1000 * FRand();
			foreach N.VisibleCollidingActors(class'Actor',jActor,CollisionRadius,ViewPoint)
				newrating -= 30000;
			if ( newrating > rating )
			{
				rating = newrating;
				Best = N.Location;
			}
   	}
	TelepDest = Best;
}

simulated function Tick(float DeltaTime)
{	
	if(bTeleporting)
	{
		AChannel-=300 *DeltaTime;
	}
	else
		AChannel=255;
	FadeOutSkin.Color.A=AChannel;

	if(MonsterController(Controller)!=none && Controller.Enemy==none)
	{
		if(MonsterController(Controller).FindNewEnemy())
		{
			SetAnimAction('Swim_Tread');
			GotoState('Teleporting');
	    }
	}
	super.Tick(DeltaTime);
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
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
	}

	function EndState()
	{
        bTeleporting=false;
		bUnlit = false;
		AChannel=255;

		LastTelepoTime=Level.TimeSeconds;
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local Actor A;
	
	AmbientSound = None;
    bCanTeleport = false; 
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
		
	HitDamageType = DamageType;
    TakeHitLocation = HitLoc;
	LifeSpan = 0.1000;

    GotoState('Dying');
		
	Velocity += TearOffMomentum;
    BaseEyeHeight = Default.BaseEyeHeight;
    SetPhysics(PHYS_Falling);	
	
	A = spawn(class'NecroGhostPriestVanishFX', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
}

function PlayVictory()
{
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
	SetAnimAction('Swim_Tread');
	Controller.Destination = Location;
	Controller.GotoState('TacticalMove','WaitForAnim');
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (rand(99) >= 33)
		Self.PlaySound(sound'DEKMonsters208AD.MonsterSounds.NecroGhostDeathSound1',,500.00);
	else if (rand(99) >= 66)
		Self.PlaySound(sound'DEKMonsters208AD.MonsterSounds.NecroGhostDeathSound2',,500.00);
	else
		Self.PlaySound(sound'DEKMonsters208AD.MonsterSounds.NecroGhostDeathSound3',,500.00);
		
	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     AChannel=255
     HealRadius=1200.000000
     TargetRadius=2000.000000
     HealAmount=15
     bMeleeFighter=False
     DeathSound(0)=Sound'DEKMonsters208AD.MonsterSounds.NecroGhostDeathSound1'
     DeathSound(1)=Sound'DEKMonsters208AD.MonsterSounds.NecroGhostDeathSound2'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters208AD.NecroGhostExpGibGroup'
     WallDodgeAnims(0)="Swim_Tread"
     WallDodgeAnims(1)="Swim_Tread"
     WallDodgeAnims(2)="Swim_Tread"
     WallDodgeAnims(3)="Swim_Tread"
     FireHeavyRapidAnim="Swim_Tread"
     FireHeavyBurstAnim="Swim_Tread"
     FireRifleRapidAnim="Swim_Tread"
     FireRifleBurstAnim="Swim_Tread"
     bCanFly=True
     MeleeRange=10.000000
     AirSpeed=800.000000
     AccelRate=800.000000
     Health=200
     ControllerClass=Class'DEKMonsters208AD.DCMonsterController'
     MovementAnims(0)="Swim_Tread"
     MovementAnims(1)="Swim_Tread"
     MovementAnims(2)="Swim_Tread"
     MovementAnims(3)="Swim_Tread"
     SwimAnims(0)="Swim_Tread"
     SwimAnims(1)="Swim_Tread"
     SwimAnims(2)="Swim_Tread"
     SwimAnims(3)="Swim_Tread"
     CrouchAnims(0)="Swim_Tread"
     CrouchAnims(1)="Swim_Tread"
     CrouchAnims(2)="Swim_Tread"
     CrouchAnims(3)="Swim_Tread"
     WalkAnims(0)="Swim_Tread"
     WalkAnims(1)="Swim_Tread"
     WalkAnims(2)="Swim_Tread"
     WalkAnims(3)="Swim_Tread"
     AirAnims(0)="Swim_Tread"
     AirAnims(1)="Swim_Tread"
     AirAnims(2)="Swim_Tread"
     AirAnims(3)="Swim_Tread"
     TakeoffAnims(0)="Swim_Tread"
     TakeoffAnims(1)="Swim_Tread"
     TakeoffAnims(2)="Swim_Tread"
     TakeoffAnims(3)="Swim_Tread"
     LandAnims(0)="Swim_Tread"
     LandAnims(1)="Swim_Tread"
     LandAnims(2)="Swim_Tread"
     LandAnims(3)="Swim_Tread"
     DoubleJumpAnims(0)="Swim_Tread"
     DoubleJumpAnims(1)="Swim_Tread"
     DoubleJumpAnims(2)="Swim_Tread"
     DoubleJumpAnims(3)="Swim_Tread"
     DodgeAnims(0)="Swim_Tread"
     DodgeAnims(1)="Swim_Tread"
     DodgeAnims(2)="Swim_Tread"
     DodgeAnims(3)="Swim_Tread"
     AirStillAnim="Swim_Tread"
     TakeoffStillAnim="Swim_Tread"
     CrouchTurnRightAnim="Swim_Tread"
     CrouchTurnLeftAnim="Swim_Tread"
     IdleCrouchAnim="Swim_Tread"
     IdleSwimAnim="Swim_Tread"
     IdleChatAnim="Swim_Tread"
     Mesh=SkeletalMesh'NewNightmare.Ophelia'
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_1'
     Skins(1)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_1'
     TransientSoundRadius=800.000000
}
