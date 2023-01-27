class DamTypeElectricEel extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'DEKMonsters999X.WeaponElectricEel'
     DeathString="%o was electrocuted by an Eel."
     FemaleSuicide="%o electrocuted herself."
     MaleSuicide="%o electrocuted himself."
     bDetonatesGoop=True
     bCauseConvulsions=True
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LightningHit'
     DamageOverlayTime=0.900000
     GibPerterbation=0.250000
     VehicleDamageScaling=0.850000
}
