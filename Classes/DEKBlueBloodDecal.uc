class DEKBlueBloodDecal extends xScorch;

var texture Splats[3];

simulated function BeginPlay()
{
	if ( !Level.bDropDetail && (FRand() < 0.5) )
    ProjTexture = splats[Rand(3)];
	Super.BeginPlay();
}

defaultproperties
{
     Splats(0)=Texture'DEKMonstersTexturesMaster208.GhostMonsters.BloodSplat1B'
     Splats(1)=Texture'DEKMonstersTexturesMaster208.GhostMonsters.BloodSplat2B'
     Splats(2)=Texture'DEKMonstersTexturesMaster208.GhostMonsters.BloodSplat3B'
     ProjTexture=Texture'DEKMonstersTexturesMaster208.GhostMonsters.BloodSplat1B'
     FOV=6
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=6.000000
     DrawScale=0.650000
}
