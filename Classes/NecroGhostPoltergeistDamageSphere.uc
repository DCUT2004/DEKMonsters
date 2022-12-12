class NecroGhostPoltergeistDamageSphere extends UntargetedProjectile
	config(satoreMonsterPack);

var class<Emitter> SphereEffectClass;
var Emitter SphereEffect;
var config float CheckInterval, DamageSphereRadius;
var config int DamageBonusLifespan, DamageBonusModifier;
var config bool bStackable, bDispellable;
var vector initialDir;

#exec obj load file=GeneralAmbience.uax

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		SphereEffect = Spawn(SphereEffectClass, Self);
		SphereEffect.SetBase(Self);
	}
	Velocity = Vector(Rotation) * Speed;
	SetTimer(CheckInterval, true);
}

simulated function PostNetBeginPlay() 
 {
  	SetTimer(CheckInterval, true);
  	Super.PostNetBeginPlay();
}

simulated function Timer() 
{
	DamageBoost();
	SphereEffect = Spawn(SphereEffectClass, Self);
	SphereEffect.SetBase(Self);
}

simulated function DamageBoost()
{
	local Controller C, NextC;
	local FriendlyMonsterInv FInv;
	local NecroGhostPoltergeistDamageMarker DamageMarker;
	local StatusEffectManager StatusManager;
	
	C = Level.ControllerList;	
	while (C != None)
	{
		NextC = C.NextController;
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.Pawn.IsA('Monster')
		&& VSize(C.Pawn.Location - Location) < DamageSphereRadius)
		{
			if (!C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
			{
				FInv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
				if (FInv == None)
				{
					StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(C.Pawn);
					if (StatusManager != None)
						StatusManager.AddStatusEffect(Class'StatusEffect_DamageBonus', DamageBonusModifier, True, DamageBonusLifespan, bDispellable, bStackable);

					DamageMarker = Spawn(class'NecroGhostPoltergeistDamageMarker',C.Pawn,,C.Pawn.Location,C.Pawn.Rotation);
					if (DamageMarker != None)
					{
						DamageMarker.SetBase(C.Pawn);
						DamageMarker.RemoteRole = ROLE_SimulatedProxy;
					}
				}
			}
		}
		C = NextC;
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
 //do nothing.
}

simulated function DestroyTrails()
{
	if (SphereEffect != None)
		SphereEffect.Destroy();
}

simulated function Destroyed()
{
	if (SphereEffect != None)
	{
		if (bNoFX)
			SphereEffect.Destroy();
		else
			SphereEffect.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
     SphereEffectClass=Class'DEKMonsters999X.NecroGhostPoltergeistDamageSphereEffect'
     CheckInterval=1.000000
     DamageSphereRadius=900.000000
	 bDispellable=False
	 bStackable=False
	 DamageBonusModifier=3
     DamageBonusLifespan=10
     MaxSpeed=0.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=135
     LightSaturation=105
     LightBrightness=100.000000
     LightRadius=10.000000
     DrawType=DT_None
     bDynamicLight=True
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.texture32'
     LifeSpan=15.000000
     bFullVolume=True
     SoundVolume=232
     TransientSoundVolume=1000.000000
}
