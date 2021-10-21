class EarthSlugBioGlob extends BioGlob;

var vector Dir;

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

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start, bstart;
    local rotator rot;
    local int i;
    local EarthSlugMiniBioGlob Glob;

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
			Glob = Spawn( class 'EarthSlugMiniBioGlob',, '', Start, rot);
		}
	}
    Destroy();
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'BrownGoopSmoke');
        Spawn(class'BrownGoopSparks');
    }
	if ( Fear != None )
		Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    Super(Projectile).Destroyed();
}

defaultproperties
{
     TossZ=1.000000
     MyDamageType=Class'DEKMonsters209B.DamTypeEarthSlug'
     LightHue=90
     bDynamicLight=False
     DrawScale=5.000000
     Skins(0)=Texture'FireEngine.Liquids.water04go'
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
