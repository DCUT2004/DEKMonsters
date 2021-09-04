class DamTypeTechSkaarj extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}
	

defaultproperties
{
     WeaponClass=Class'DEKMonsters209A.WeaponTechSkaarj'
     DeathString="The Tech Skaarj's nanites turned %o into mush."
     bArmorStops=False
     bDetonatesGoop=True
     bDelayedDamage=True
     DamageOverlayMaterial=Shader'DEKMonstersTexturesMaster208.TechMonsters.TechShader'
     DeathOverlayMaterial=Shader'DEKMonstersTexturesMaster208.TechMonsters.TechShader'
     DamageOverlayTime=0.800000
     VehicleDamageScaling=1.500000
}
