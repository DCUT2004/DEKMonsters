class EarthProjectileTrail extends xEmitter;

//#exec OBJ LOAD File=NatureTrail.utx

defaultproperties
{
     mStartParticles=0
     mMaxParticles=150
     mLifeRange(0)=1.250000
     mLifeRange(1)=1.250000
     mRegenRange(0)=90.000000
     mRegenRange(1)=90.000000
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=0.000000
     mMassRange(0)=-0.030000
     mMassRange(1)=-0.010000
     mRandOrient=True
     mSpinRange(0)=-75.000000
     mSpinRange(1)=75.000000
     mSizeRange(0)=15.000000
     mSizeRange(1)=20.000000
     mGrowthRate=6.000000
     mAttenFunc=ATF_ExpInOut
     mRandTextures=True
     CullDistance=10000.000000
     Physics=PHYS_Trailer
     Skins(0)=Texture'DEKMonstersTexturesMaster208.EarthMonsters.SSLotsaMoreLeafFLOWERS'
     Style=STY_Alpha
}
