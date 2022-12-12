class IceMercRocket extends SMPMercRocket;

var float MaxFreezeLifespan;
var config bool bDispellable, bStackable;
var config float BaseChance;
var Sound FreezeSound;
var	xEmitter RealSmokeTrail;

simulated function Destroyed()
{
	if ( RealSmokeTrail != None )
		RealSmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
	
	if (Corona != None)
		Corona.Destroy();
		
	if ( Level.NetMode != NM_DedicatedServer)
	{
		RealSmokeTrail = Spawn(class'IceKrallTrailSmoke',self);
	}

	Dir = vector(Rotation);
	Velocity = speed * Dir;
	if (PhysicsVolume.bWaterVolume)
	{
		bHitWater = True;
		Velocity=0.6*Velocity;
	}
}

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	local StatusEffectManager StatusManager;
	local int FreezeModifier, FreezeLifespan;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if(C.Pawn == None)
		{
			C = NextC;
			break;
		}
		if ( C.Pawn != None && C.Pawn.Health > 0 && IceInv(C.Pawn.FindInventoryType(Class'IceInv')) == None && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(C.Pawn))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(100) < int(BaseChance))
				{
					StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(C.Pawn);
					if (StatusManager != None)
					{
						FreezeModifier = damageScale * MaxFreezeLifespan;
						FreezeLifespan = damageScale * MaxFreezeLifespan;
						StatusManager.AddStatusEffect(Class'StatusEffect_Speed', -(abs(FreezeModifier)), True, FreezeLifespan, bDispellable, bStackable);
					}
				}
			}
			if(C.Pawn == None)
			{
				C = NextC;
				break;
			}
		}
		C = NextC;
	}
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'BlueGoopSmokeLarge',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	Spawn(class'IceRocketExplosion',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
//		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
//			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
     MaxFreezeLifespan=3.000000
	 bDispellable=True
	 bStackable=False
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     MyDamageType=Class'DEKMonsters999X.DamTypeIceMercenary'
     ExplosionDecal=None
     LightHue=120
     StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.IceRocketProj'
     Skins(0)=Texture'DEKMonstersTexturesMaster208.IceMonsters.IceGib'
}
