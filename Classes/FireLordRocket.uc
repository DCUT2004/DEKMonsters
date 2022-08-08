class FireLordRocket extends Projectile;

var	FireRocketTrail SmokeTrailE;
// camera shakes //
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view

var class<Emitter> ExplosionEffectClass;

var byte Team;

simulated function Destroyed()
{
	if ( SmokeTrailE != None )
		SmokeTrailE.mRegen = False;
	Super.Destroyed();
}

function BeginPlay()
{
	Super.BeginPlay();

	if (Instigator != None)
		Team = Instigator.GetTeamNum();
	SetTimer(0.5, true);
}

simulated function PostBeginPlay()
{
	local vector Dir;

	if ( bDeleteMe || IsInState('Dying') )
		return;

	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrailE = Spawn(class'FireRocketTrail',self,,Location - 40 * Dir, Rotation);
		SmokeTrailE.SetBase(self);
	}

	Super.PostBeginPlay();
}

event bool EncroachingOn( actor Other )
{
	if ( Other.bWorldGeometry )
		return true;

	return false;
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( Other != instigator )
		Explode(HitLocation,Vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);
}

simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
}

simulated function Landed( vector HitNormal )
{
	BlowUp(Location);
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	BlowUp(Location);
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local MissionInvBETA MissionInv;
	
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	
	if (Damage > 0 && InstigatedBy != None && InstigatedBy.Controller != None)
	{
		MissionInv = Class'MissionInvBETA'.static.GetMissionInv(InstigatedBy.Controller);
		if (MissionInv == None)
			return;
		if (!MissionInv.IsMissionActive("Disarmer"))
			return;
		MissionInv.TickMission(MissionInv.GetMissionIndex("Disarmer"), 1);
	}
	BlowUp(HitLocation);
}

simulated event FellOutOfWorld(eKillZType KillType)
{
	BlowUp(Location);
}

function BlowUp(vector HitLocation)
{
	local Emitter E;

    E = Spawn(ExplosionEffectClass,,, HitLocation - 100 * Normal(Velocity), Rot(0,16384,0));
	if ( Level.NetMode == NM_DedicatedServer )
	{
		E.LifeSpan = 0.7;
	}
	MakeNoise(1.0);
	SetPhysics(PHYS_None);
	bHidden = true;
    GotoState('Dying');
}

state Dying
{
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType) {}
	function Timer() {}

    function BeginState()
    {
		bHidden = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		ShakeView();
		InitialState = 'Dying';
		if ( SmokeTrailE != None )
			SmokeTrailE.Destroy();
		SetTimer(0, false);
    }

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }
Begin:
    PlaySound(sound'WeaponSounds.redeemer_explosionsound');
    HurtRadius(Damage, DamageRadius*0.500, MyDamageType, MomentumTransfer, Location);
    Sleep(0.5);
    HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
    Destroy();
}

defaultproperties
{
     ShakeRotMag=(Z=250.000000)
     ShakeRotRate=(Z=2500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(Z=10.000000)
     ShakeOffsetRate=(Z=200.000000)
     ShakeOffsetTime=10.000000
     ExplosionEffectClass=Class'DEKMonsters999X.FireLordRocketExplosion'
     Team=255
     Speed=1000.000000
     MaxSpeed=1000.000000
     Damage=60.000000
     DamageRadius=800.000000
     MomentumTransfer=15000.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeFireLord'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightBrightness=255.000000
     LightRadius=6.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     bDynamicLight=True
     bNetTemporary=False
     AmbientSound=Sound'WeaponSounds.Misc.redeemer_flight'
     LifeSpan=20.000000
     DrawScale=0.500000
     Skins(0)=Texture'DEKMonstersTexturesMaster208.FireMonsters.FireGib'
     AmbientGlow=96
     bUnlit=False
     SoundVolume=255
     SoundRadius=100.000000
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
     CollisionRadius=30.000000
     CollisionHeight=15.000000
     bProjTarget=True
     bFixedRotationDir=True
     RotationRate=(Roll=50000)
     DesiredRotation=(Roll=30000)
     ForceType=FT_DragAlong
     ForceRadius=100.000000
     ForceScale=5.000000
}
