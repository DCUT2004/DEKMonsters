class IceKrallProj extends Projectile;

var config int FreezeModifier, FreezeLifespan;
var config bool bDispellable, bStackable;
var config int BaseChance;
var xEmitter Trail;
var texture TrailTex;
var class<Emitter> ExplosionEffectClass;
var	xEmitter SmokeTrail;
var Sound FreezeSound;

simulated function Destroyed()
{
	if ( SmokeTrail != None )
		SmokeTrail.mRegen = False;

	if (Trail != None)
		Trail.Destroy();
	Super.Destroyed();
}


simulated function PostBeginPlay()
{


    local Rotator R;

	Super.PostBeginPlay();

    if ( EffectIsRelevant(vect(0,0,0),false) )
    {
		Trail = Spawn(class'LinkProjEffect',self);
		if ( Trail != None ) 
			Trail.Skins[0] = TrailTex;
	}
	
	Velocity = Speed * Vector(Rotation);

    R = Rotation;
    R.Roll = Rand(65536);
    SetRotation(R);
    
	if ( Level.bDropDetail || Level.DetailMode == DM_Low )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}

 if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'IceKrallTrailSmoke',self);
		
	}
} 

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Vector X, RefNormal, RefDir;
	local Pawn P;
	local StatusEffectManager StatusManager;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
	
    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
	if ( Role == ROLE_Authority )
	{
		Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);

		P = Pawn(Other);
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(P))
		{
			if(rand(100) < (BaseChance))
			{
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(P);
				if (StatusManager != None)
					StatusManager.AddStatusEffect(Class'StatusEffect_Speed', -(abs(FreezeModifier)), True, FreezeLifespan, bDispellable, bStackable);
			}
			Explode(Location, vect(0,0,1));				
		}
	}	
}

defaultproperties
{
	 BaseChance=25
	 bDispellable=True
	 bStackable=False
	 FreezeModifier=4
	 FreezeLifespan=4.00
     ExplosionEffectClass=Class'Onslaught.ONSPlasmaHitBlue'
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     Speed=1500.000000
     MaxSpeed=4000.000000
     Damage=60.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeIceKrall'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=140
     LightBrightness=255.000000
     LightRadius=1.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
     bDynamicLight=True
     AmbientSound=SoundGroup'WeaponSounds.ShieldGun.ShieldNoise'
     LifeSpan=3.000000
     DrawScale3D=(X=5.295000,Y=1.530000,Z=1.530000)
     PrePivot=(X=10.000000)
     Skins(0)=Texture'DEKMonstersTexturesMaster208.IceMonsters.blueice'
     AmbientGlow=200
     Style=STY_Translucent
     SoundVolume=255
     SoundRadius=100.000000
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     ForceType=FT_Constant
     ForceRadius=30.000000
     ForceScale=7.000000
}
