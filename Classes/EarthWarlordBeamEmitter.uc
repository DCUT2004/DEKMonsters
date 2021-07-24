class EarthWarlordBeamEmitter extends ShockBeamEffect;

var() float MaxLength;
var vector HitLocation;

replication
{
	reliable if (bNetInitial)
		HitLocation;
}

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
	return;
}

simulated function SpawnEffects()
{
	return;
}

//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     mSizeRange(0)=48.000000
     mSizeRange(1)=96.000000
     Texture=Texture'DEKMonstersTexturesMaster208.EarthMonsters.ShockBeamTexGREEN'
     Skins(0)=Texture'DEKMonstersTexturesMaster208.EarthMonsters.ShockBeamTexGREEN'
}
