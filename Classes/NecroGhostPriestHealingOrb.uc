class NecroGhostPriestHealingOrb extends Actor
	config(satoreMonsterPack);

var class<Emitter> OrbEffectClass;
var Emitter OrbEffect;
var config float HealInterval, OrbHealRadius;
var config int HealAmount;
var vector initialDir;

#exec obj load file=GeneralAmbience.uax

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		OrbEffect = Spawn(OrbEffectClass, Self);
		OrbEffect.SetBase(Self);
	}
    SetCollision(False, False, False);
	SetTimer(HealInterval, true);
}

simulated function Timer() 
{
	Heal();
	OrbEffect = Spawn(OrbEffectClass, Self);
	OrbEffect.SetBase(Self);
}

simulated function Heal()
{
	local Controller C;
	local FriendlyMonsterInv FInv;
	local NecroGhostPriestHealingMarker HealMarker;
	
	C = Level.ControllerList;	
	while (C != None)
	{
		if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.IsA('Monster') && VSize(C.Pawn.Location - Location) < OrbHealRadius)
		{
			if (!C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('NecroGhostPriest') && !C.Pawn.IsA('MissionCow'))
			{
				FInv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
				if (FInv == None)
				{
					C.Pawn.GiveHealth(HealAmount, C.Pawn.HealthMax);
					HealMarker = Spawn(class'NecroGhostPriestHealingMarker',C.Pawn,,C.Pawn.Location,C.Pawn.Rotation);
					if (HealMarker != None)
					{
						HealMarker.SetBase(C.Pawn);
						HealMarker.RemoteRole = ROLE_SimulatedProxy;
					}
				}
			}
		}
		C = C.NextController;
	}
}

simulated function Destroyed()
{
	if (OrbEffect != None)
		OrbEffect.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     OrbEffectClass=Class'DEKMonsters999X.NecroGhostPriestHealingOrbEffect'
     HealInterval=1.000000
     OrbHealRadius=900.000000
     HealAmount=10
     DrawType=DT_None
     Physics=PHYS_None
     AmbientSound=Sound'GeneralAmbience.texture32'
     LifeSpan=15.000000
     bFullVolume=True
     SoundVolume=232
     SoundRadius=900.000000
     TransientSoundVolume=1000.000000
}
