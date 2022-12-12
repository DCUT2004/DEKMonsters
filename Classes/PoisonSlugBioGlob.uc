class PoisonSlugBioGlob extends BioGlob;

var vector Dir;
var config int MaxPoisonLifespan;
var config bool bDispellable, bStackable;
var config float BaseChance;

function AdjustSpeed()
{
	Velocity = Vector(Rotation) * Speed * 4;
	Velocity.Z += TossZ * 4;
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        Explode(Location,HitNormal);
    }

    simulated function HitWall( Vector HitNormal, Actor Wall )
    {
        Landed(HitNormal);
    }
}

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	local StatusEffectManager StatusManager;
	local int PoisonModifier, PoisonLifespan;

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
		if ( C.Pawn != None && C.Pawn.Health > 0 && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) )
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
						PoisonModifier = damageScale * MaxPoisonLifespan;
						PoisonLifespan = damageScale * MaxPoisonLifespan;
						StatusManager.AddStatusEffect(Class'StatusEffect_Poison', -(abs(PoisonModifier)), True, PoisonLifespan, bDispellable, bStackable);
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
	local vector start, bstart;
    local rotator rot;
    local int i;
    local PoisonSlugMiniBioGlob Glob;

	start = Location - 40 * Dir;
	bstart = Location + 80 * Dir;

	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

        for (i=0; i<6; i++)
		{
			rot = Rotation;
			rot.yaw += FRand()*32000-16000;
			rot.pitch += FRand()*32000-16000;
			rot.roll += FRand()*32000-16000;
			Glob = Spawn( class 'PoisonSlugMiniBioGlob',, '', Start, rot);
		}
	}
    Destroy();
}

defaultproperties
{
     MaxPoisonLifespan=4
	 bDispellable=True
	 bStackable=False
     BaseChance=33.000000
     TossZ=1.000000
     MyDamageType=Class'DEKMonsters999X.DamTypePoisonSlug'
     LightBrightness=80.000000
     DrawScale=5.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
