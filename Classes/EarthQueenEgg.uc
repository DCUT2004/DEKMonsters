class EarthQueenEgg extends UntargetedProjectile
	config(satoreMonsterPack);

var config float HatchInterval;
var()   Sound   ExplodeSound;
var bool bMinePlanted;
var bool bCanHitOwner;
var class<xEmitter> HitEffectClass;
var float LastSparkTime;
var Actor IgnoreActor; //don't stick to this actor
var EarthQueen Parent;
var actor Glow;

var config Array< class<Monster> > Children;

replication
{
	reliable if (bNetDirty && Role == ROLE_Authority)
		IgnoreActor;
}

simulated function PostBeginPlay()
{
    local Rotator r;

	Super.PostBeginPlay();
	
	if (PhysicsVolume.bWaterVolume)
		Velocity = 0.6*Velocity;

	bCanHitOwner = false;
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ;
	
	if ( !PhysicsVolume.bWaterVolume && (Level.NetMode != NM_DedicatedServer) )
	{
		Glow = Spawn(class'EarthQueenEggGlow', self);
		Glow.SetBase(Self);
	}
}

simulated function Landed( vector HitNormal )
{
	SetTimer(HatchInterval, False);
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if (Pawn(Other) != None)
		return;
    if (!bMinePlanted && !bPendingDelete && Base == None && Other != IgnoreActor && (!Other.bWorldGeometry && Other.Class != Class))
	{
			Stick(Other, HitLocation);
	}
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if (Vehicle(Wall) != None && !bMinePlanted)
    {
        Touch(Wall);
        return;
    }

    else if ( !bMinePlanted )
    {
		bBounce = False;
		SetPhysics(PHYS_None);
		bCollideWorld = False;
		bMinePlanted = true;
	}
}

simulated function Stick(actor HitActor, vector HitLocation)
{
    bBounce = False;
    LastTouched = HitActor;
    SetPhysics(PHYS_None);
    SetBase(HitActor);
    if (Base == None)
    {
    	UnStick();
    	return;
    }
    bCollideWorld = False;
    bProjTarget = true;
	
	SetTimer(HatchInterval, False);
}

simulated function Timer()
{
	Hatch(Self.Location);
}

simulated function Hatch(vector Location)
{
	local int i;
	local Monster M;
	
	i = Rand(default.Children.Length);
	M = Spawn(default.Children[i],,, Location);
	if (M != None)
	{
		PlaySound(Sound'ONSVehicleSounds-S.PowerNode.PwrNodeStartBuild03',,2.1*TransientSoundVolume);
	}
	Explode(Self.Location, vect(0,0,0));
}

simulated function UnStick()
{
	Velocity = vect(0,0,0);
	IgnoreActor = Base;
	SetBase(None);
	SetPhysics(PHYS_Falling);
	bCollideWorld = true;
	bProjTarget = false;
	LastTouched = None;
}

simulated function tick ( float DeltaTime)
{
	if (Parent == None || Parent.Health <= 0)
		Explode(Self.Location, vect(0,0,0));
	super.tick(DeltaTime);
}

simulated function BaseChange()
{
	if (!bPendingDelete && Physics == PHYS_None && Base == None)
		UnStick();
}

simulated function PawnBaseDied()
{
	Explode(Self.Location, vect(0,0,0));
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if ( Damage > 0 && InstigatedBy != None && (Instigator != InstigatedBy || DamageType != MyDamageType) && (Instigator == None || Instigator == InstigatedBy || InstigatedBy.GetTeamNum() != Instigator.GetTeamNum()) )
	{
		Explode(HitLocation, vect(0,0,0));
		if (Parent != None)
			Parent.EggCount--;
		if (Parent.EggCount < 0 )
			Parent.EggCount = 0;
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    PlaySound(ExplodeSound, SLOT_Misc);
	Destroy();
}

simulated function destroyed()
{
	if ( glow != None )
		Glow.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     HatchInterval=7.000000
     ExplodeSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     Children(0)=Class'DEKMonsters208AB.EarthSkaarjPupaeChild'
     Children(1)=Class'DEKMonsters208AB.EarthRazorflyChild'
     Children(2)=Class'DEKMonsters208AB.EarthMantaChild'
     Speed=1200.000000
     TossZ=225.000000
     bSwitchToZeroCollision=True
     MomentumTransfer=100.000000
     MyDamageType=Class'DEKMonsters208AB.DamTypeTechQueen'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.AcidBlob'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     LifeSpan=0.000000
     DrawScale=4.000000
     Skins(0)=Texture'FireEngine.Liquids.water02go'
     CollisionRadius=20.000000
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
