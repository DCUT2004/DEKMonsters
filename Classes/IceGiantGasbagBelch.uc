class IceGiantGasBagBelch extends SMPGiantGasbagBelch;

var float MaxFreezeLifespan;
var config bool bDispellable, bStackable;
var config float BaseChance;
var Sound FreezeSound;
var	xEmitter RealSmokeTrail;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if ( !Level.bDropDetail )
			spawn(class'RocketSmokeRing',,,Location, Rotation );
		RealSmokeTrail = Spawn(class'IceBelchFrostGiant',self);
	}
	
	if (SmokeTrail != None)
	{
		SmokeTrail.mRegen = False;
		SmokeTrail.Destroy();
	}
		
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
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

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;
	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);

	A=spawn(class'FlakExplosion',,,HitLocation + HitNormal*16 );
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}
	A=spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		A=Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	if(A!=none)
	{
		A.SetDrawScale(A.DrawScale*2);
		A=none;
	}

	BlowUp(HitLocation);
	Destroy();
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

simulated function Destroyed() 
{
	if ( RealSmokeTrail != None )
		RealSmokeTrail.mRegen = False;
	Super.Destroyed();
}

defaultproperties
{
     MaxFreezeLifespan=3.000000
	 bDispellable=True
	 bStackable=False
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     MyDamageType=Class'DEKMonsters999X.DamTypeIceGiantGasbag'
     Texture=Texture'XEffectMat.Link.link_muz_blue'
}
