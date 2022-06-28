class NecroGhostExp extends Monster
	config(satoreMonsterPack);

var() config float MinXPDamage, MaxXPDamage;
var ColorModifier FadeOutSkin;
var vector TelepDest;
var		byte AChannel;
var float LastTelepoTime;
var bool bTeleporting;
var RPGRules Rules;
var config int MinimumLevel, MinimumExp;
var config float TargetRadius;
var xEmitter Chain;
var Pawn Enemy;
var() config float RangedAttackInterval;
var() float LastRangedAttackTime;
var NecroGhostExpProj Curse;

#exec  AUDIO IMPORT NAME="NecroGhostDeathSound1" FILE="Sounds\NecroGhostDeathSound1.WAV" GROUP="MonsterSounds"
#exec  AUDIO IMPORT NAME="NecroGhostDeathSound2" FILE="Sounds\NecroGhostDeathSound2.WAV" GROUP="MonsterSounds"
#exec  AUDIO IMPORT NAME="NecroGhostDeathSound3" FILE="Sounds\NecroGhostDeathSound3.WAV" GROUP="MonsterSounds"

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
	CheckRPGRules();
	
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

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
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
	local RPGStatsInv Inv;
	
	Super.RangedAttack(A);
	
	Enemy = Pawn(A);
	if (Enemy != None)
		Inv = RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv'));

	if ( Physics == PHYS_Swimming )
	{
		if (Inv != None && Rules != None && Level.TimeSeconds - LastRangedAttackTime > RangedAttackInterval)
		{
			LastRangedAttackTime = Level.TimeSeconds;
			SetAnimAction('Swim_Tread');
			SuckEXP(Enemy);
		}
		if (Enemy != None && Curse == None)
		{
			MisfortuneCurse(Enemy);
		}
		SetAnimAction('Swim_Tread');
	}
	else if ( VSize(Enemy.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction('gesture_point');
		if ( MeleeDamageTarget(45, (45000.0 * Normal(Controller.Target.Location - Location))) )
			PlaySound(sound'mn_hit10', SLOT_Talk); 
	}
	else if(VSize(Enemy.Location-Location) > TargetRadius)
	{
		SetAnimAction('Swim_Tread');
		PlaySound(sound'BWeaponSpawn1', SLOT_Interface);
		GotoState('Teleporting');
	}
	else if(VSize(Enemy.Location-Location) <= TargetRadius)
	{
		if (Inv != None && Rules != None && Level.TimeSeconds - LastRangedAttackTime > RangedAttackInterval)
		{
			LastRangedAttackTime = Level.TimeSeconds;
			SetAnimAction('Swim_Tread');
			if (!Enemy.IsA('Vehicle') && !Enemy.IsA('Monster'))
				SuckEXP(Enemy);
		if (Enemy != None && Curse == None)
		{
			MisfortuneCurse(Enemy);
		}
		}
		else
			SetAnimAction('Swim_Tread');		
	}
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function MisfortuneCurse(Pawn P)
{
	Curse = Spawn(class'NecroGhostExpProj',,, Self.Location, Self.Rotation);
	if (Curse != None)
		Curse.Seeking = P;
}

simulated function SuckEXP(Pawn Enemy)
{
	local float XPDamage;
	local RPGStatsInv Inv;
	local Actor A;
	local NecroInv NInv;
	
	if (Enemy == None || Enemy.Health <= 0  || Rules == None)
		return;
		
	if (Enemy != None && Enemy.Health > 0)
	{
		if (Enemy.IsA('Monster') || Enemy.IsA('Vehicle'))
			return;		//targeting pet, which doesn't have XP!
		NInv = NecroInv(Enemy.FindInventoryType(class'NecroInv'));
		if (NInv != None)
			return;
			
		XPDamage = (default.MinXPDamage + Rand(default.MaxXPDamage - default.MinXPDamage));
		Inv = RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv'));

		if (Inv != None && Rules != None && Inv.DataObject.Level > default.MinimumLevel && Inv.DataObject.Experience > default.MinimumExp)
		{
				Rules.ShareExperience(RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv')), XPDamage);
		}
		if (Chain == None && Instigator != None && Enemy != None && FastTrace(Instigator.Location, Enemy.Location))
		{
			Chain = Spawn(class'NecroGhostExpChain',Instigator,,Instigator.Location,rotator(Instigator.Location - Enemy.Location));
		}
		if (Chain != None && Instigator != None)
			Chain.SetBase(Instigator);
		if (rand(99) <= 15)
		{
			A = Instigator.spawn(class'NecroGhostExpLight', Instigator,, Instigator.Location, Instigator.Rotation);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
			}
		}
		Self.PlaySound(sound'ONSBPSounds.ShockTank.ShieldOff',,800.00);
		Enemy.PlaySound(sound'ONSBPSounds.ShockTank.ShieldOff',,800.00);
		PlaySound(sound'tortureloop3', SLOT_Interact);
	}
}

simulated function bool IsViewingAt( vector A, rotator ARot, vector B )
{
	Return ((Normal(B-A) Dot vector(ARot))>0);
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

	if(Chain != None && Instigator != None && Enemy != None)
	{
		if (VSize(Instigator.Location - Enemy.Location) > TargetRadius || !FastTrace(Instigator.Location, Enemy.Location))
			Chain.Destroy();
		else
		{
			Chain.mSpawnVecA = Enemy.Location;
			Chain.SetRotation(rotator(Enemy.Location - Instigator.Location));
		}
	}
	if (Chain != None && Enemy == None)
		Chain.Destroy();


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
	
	A = spawn(class'NecroGhostExpVanishFX', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
		
	if (Chain != None)
		Chain.Destroy();
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
		Self.PlaySound(sound'DEKMonsters209D.MonsterSounds.NecroGhostDeathSound1',,500.00);
	else if (rand(99) >= 66)
		Self.PlaySound(sound'DEKMonsters209D.MonsterSounds.NecroGhostDeathSound2',,500.00);
	else
		Self.PlaySound(sound'DEKMonsters209D.MonsterSounds.NecroGhostDeathSound3',,500.00);
	if (Chain != None)
		Chain.Destroy();
	Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     MinXPDamage=-5.000000
     MaxXPDamage=-10.000000
	 RangedAttackInterval=1.200000
     AChannel=255
     MinimumLevel=60
     MinimumExp=5
     TargetRadius=2000.000000
     bMeleeFighter=False
     DeathSound(0)=Sound'DEKMonsters209D.MonsterSounds.NecroGhostDeathSound1'
     DeathSound(1)=Sound'DEKMonsters209D.MonsterSounds.NecroGhostDeathSound2'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters209D.NecroGhostExpGibGroup'
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
     ControllerClass=Class'DEKMonsters209D.DCMonsterController'
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
     Mesh=SkeletalMesh'XanRobots.XanF02'
     Skins(0)=FinalBlend'DEKRPGTexturesMaster209B.fX.SphereInvFB'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster209B.fX.SphereInvFB'
     TransientSoundRadius=800.000000
}
