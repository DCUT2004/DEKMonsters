class DEKGoldBloodDecal extends xScorch;

var texture Splats[3];

simulated function BeginPlay()
{
	if ( !Level.bDropDetail && (FRand() < 0.5) )
    ProjTexture = splats[Rand(3)];
	Super.BeginPlay();
}

defaultproperties
{
     Splats(0)=Texture'DEKMonstersTexturesMaster208.GoldMonsters.GoldSplat1'
     Splats(1)=Texture'DEKMonstersTexturesMaster208.GoldMonsters.GoldSplat2'
     Splats(2)=Texture'DEKMonstersTexturesMaster208.GoldMonsters.GoldSplat3'
     ProjTexture=Texture'DEKMonstersTexturesMaster208.GoldMonsters.GoldSplat2'
     FOV=6
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=6.000000
     DrawScale=0.650000
}
