class GiantPoisonBunnyCharger extends Actor;

var xEmitter ChargeEmitter;
var AvoidMarker Fear;
var Controller InstigatorController;
var float ChargeTime;
var float PoisonLifespan;
var config int PoisonModifier;
var config bool bDispellable, bStackable;
var float DamageRadius;

function DoDamage(float Radius)
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;
	local StatusEffectManager StatusManager;

	if (Instigator == None && InstigatorController != None)
		Instigator = InstigatorController.Pawn;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) )
		{
			dir = C.Pawn.Location - Location;
			dist = FMax(1,VSize(dir));
			damageScale = 1 - FMax(0,dist/Radius);

			if(!C.Pawn.isA('Vehicle') && (C.Pawn.FindInventoryType(class'PoisonBlastInv') == None))
			{
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(C.Pawn);
				if (StatusManager != None)
					StatusManager.AddStatusEffect(Class'StatusEffect_Poison', -(abs(PoisonModifier)), True, PoisonLifespan, bDispellable, bStackable);
			}
		}

		C = NextC;
	}
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
		ChargeEmitter = spawn(class'PoisonBlastChargeEmitter');

	if (Role == ROLE_Authority)
		InstigatorController = Controller(Owner);

	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();

	Super.Destroyed();
}

auto state Charging
{
Begin:
	Fear = spawn(class'AvoidMarker');
	Fear.SetCollisionSize(DamageRadius, 200);
	Fear.StartleBots();

	Sleep(ChargeTime);
	spawn(class'GiantPoisonBunnyChargerExplosion');
	bHidden = true; //for netplay - makes it irrelevant
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();
	MakeNoise(1.0);
	PlaySound(sound'WeaponSounds.redeemer_explosionsound');
	DoDamage(DamageRadius);

	if (Fear != None)
		Fear.Destroy();
	Destroy();
}

defaultproperties
{
     ChargeTime=3.000000
     PoisonLifespan=5.000000
	 PoisonModifier=4
	 bDispellable=True
	 bStackable=False
     DamageRadius=1000.000000
     DrawType=DT_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
