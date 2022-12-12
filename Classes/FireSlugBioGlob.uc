class FireSlugBioGlob extends BioGlob;

var vector Dir;
var float MaxHeatLifeSpan;
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
	local int HeatModifier, HeatLifespan;

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
		if ( C.Pawn != None && C.Pawn.Health > 0 && FireInv(C.Pawn.FindInventoryType(Class'FireInv')) == None && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) )
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
						HeatModifier = damageScale * MaxHeatLifespan;
						HeatLifespan = damageScale * MaxHeatLifespan;
						StatusManager.AddStatusEffect(Class'StatusEffect_Burn', -(abs(HeatModifier)), True, HeatLifespan, bDispellable, bStackable);
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
    local FireSlugMiniBioGlob Glob;

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
			Glob = Spawn( class 'FireSlugMiniBioGlob',, '', Start, rot);
		}
	}
    Destroy();
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'RedGoopSmoke');
        Spawn(class'RedGoopSparks');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super(Projectile).Destroyed();
}

defaultproperties
{
	 bDispellable=True
	 bStackable=False
     MaxHeatLifespan=4.000000
     BaseChance=25.000000
     TossZ=1.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeFireSlug'
     LightHue=30
     LightSaturation=15
     DrawScale=5.000000
     Skins(0)=Texture'DEKMonstersTexturesMaster208.FireMonsters.FireGib'
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
