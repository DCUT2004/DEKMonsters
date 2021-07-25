class DamTypeEarthWarlordBeam extends WeaponDamageType
	abstract;


static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictimHealth)
{
	HitEffects[0] = class'HitSmoke';
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     WeaponClass=Class'DEKMonsters208AB.WeaponEarthWarlord'
     DeathString="%o was evaporated by an Earth Warlord."
     bDetonatesGoop=True
     bSkeletize=True
     GibModifier=0.000000
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
     DamageOverlayTime=1.000000
}
