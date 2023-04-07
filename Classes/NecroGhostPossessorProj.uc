class NecroGhostPossessorProj extends NecroGhostSeekingProj
	config(satoreMonsterPack);

defaultproperties
{
	OrbFXClass=Class'NecroGhostPossessorProjEffect'
	StatusEffectClass=Class'DEKRPG999X.StatusEffect_DamageReduction'
	bDispellable=False
	bStackable=True
	StatusLifespan=10
	StatusModifier=3
	LightHue=90
	//LightSaturation=60
	LightBrightness=10.000000
}
