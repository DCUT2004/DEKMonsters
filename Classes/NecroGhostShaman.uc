class NecroGhostShaman extends DEKMonster
	config(satoreMonsterPack);

var ColorModifier FadeOutSkin;
var vector TelepDest;
var		byte AChannel;
var float LastTelepoTime;
var bool bTeleporting;
var config float NerfRadius, DamageMultiplier, MaxDamageNerf;
var NecroGhostShamanTrail FX;

replication
{
	reliable if(Role==ROLE_Authority )
         bTeleporting;
}

simulated function PostBeginPlay()
{
	local MagicShieldInv Inv;
	
	Super.PostBeginPlay();
	FadeOutSkin= new class'ColorModifier';
	FadeOutSkin.Material=Skins[0];
	Skins[0]=FadeOutSkin;
	
	if (Instigator != None)
	{
		Inv = MagicShieldInv(Instigator.FindInventoryType(class'MagicShieldInv'));
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

	if ( bShotAnim )
		return;

	if ( Physics == PHYS_Swimming )
	{
		SetAnimAction('Swim_Tread');
		GiveShield();
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
		SetAnimAction('Swim_Tread');
		GiveShield();
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function GiveShield()
{
	local Monster M;
	local FriendlyMonsterInv Inv;
	local MagicShieldInv MInv;
	local Actor A;
	
	Inv = FriendlyMonsterInv(M.FindInventoryType(class'FriendlyMonsterInv'));
	MInv = MagicShieldInv(M.FindInventoryType(class'MagicShieldInv'));
	
	ForEach DynamicActors(class'Monster',M)
	{
		if (M != None && M.Health > 0 && VSize(Location - M.Location) <= default.NerfRadius)
		{
			if (Inv == None && MInv == None)
			{
				MInv = spawn(class'MagicShieldInv', M,,, rot(0,0,0));
				MInv.GiveTo(M);
			}
		}
	}
	if (FX == None)
	{
		FX = Spawn(class'NecroGhostShamantrail', Instigator,,Instigator.Location, Instigator.Rotation);
		FX.SetBase(Instigator);
	}
	
	if (rand(99) <= 15)
	{
		A = Instigator.spawn(class'NecroGhostShamanLight', Instigator,, Instigator.Location, Instigator.Rotation);
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
	
	A = spawn(class'NecroGhostVanishFX', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
		
	if (FX != None)
		DestroyEmitter();
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

simulated function DestroyEmitter()
{
	if (FX != None)
	{
		FX.Destroy();
		FX.Kill();
	}
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (rand(99) >= 33)
		Self.PlaySound(sound'DEKMonsters999X.MonsterSounds.NecroGhostDeathSound1',,500.00);
	else if (rand(99) >= 66)
		Self.PlaySound(sound'DEKMonsters999X.MonsterSounds.NecroGhostDeathSound2',,500.00);
	else
		Self.PlaySound(sound'DEKMonsters999X.MonsterSounds.NecroGhostDeathSound3',,500.00);
	if (FX != None)
		DestroyEmitter();
	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     AChannel=255
     NerfRadius=1400.000000
     MaxDamageNerf=0.500000
     bMeleeFighter=False
     DeathSound(0)=Sound'DEKMonsters999X.MonsterSounds.NecroGhostDeathSound1'
     DeathSound(1)=Sound'DEKMonsters999X.MonsterSounds.NecroGhostDeathSound2'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters999X.NecroGhostExpGibGroup'
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
     ControllerClass=Class'DEKRPG999X.DCMonsterController'
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
     Mesh=SkeletalMesh'XanRobots.EnigmaM'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     TransientSoundRadius=800.000000
}
