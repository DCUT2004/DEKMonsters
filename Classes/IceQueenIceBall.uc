class IceQueenIceBall extends IceBall;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         SpinParticles=True
         UniformSize=True
         FadeOutStartTime=0.320000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=0.132000,Max=0.900000))
         StartSizeRange=(X=(Min=12.500000,Max=12.500000),Y=(Min=17.500000,Max=17.500000),Z=(Min=17.500000,Max=17.500000))
         Texture=Texture'XEffectMat.Link.link_muz_blue'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         WarmupTicksPerSecond=20.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'DEKMonsters209B.IceQueenIceBall.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         SpinParticles=True
         UniformSize=True
         FadeOutStartTime=0.200000
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.300000))
         StartSpinRange=(X=(Min=0.154000,Max=0.913000))
         StartSizeRange=(X=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=2.000000
         Texture=Texture'EmitterTextures.SingleFrame.WaterDrop-04'
         LifetimeRange=(Min=0.400000,Max=0.400000)
         WarmupTicksPerSecond=20.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'DEKMonsters209B.IceQueenIceBall.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         ResetAfterChange=True
         AutoReset=True
         UniformSize=True
         FadeOutStartTime=0.300000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         DetailMode=DM_High
         StartSizeRange=(X=(Min=1.250000,Max=1.250000))
         Texture=Texture'EmitterTextures.SingleFrame.WaterDrop'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         StartVelocityRange=(X=(Min=-70.000000,Max=70.000000),Y=(Min=-70.000000,Max=70.000000),Z=(Min=-70.000000,Max=70.000000))
         VelocityScale(0)=(RelativeTime=1.000000,RelativeVelocity=(X=-1.000000,Y=-1.000000,Z=-1.000000))
         WarmupTicksPerSecond=50.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(2)=SpriteEmitter'DEKMonsters209B.IceQueenIceBall.SpriteEmitter2'

}
