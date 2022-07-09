//=============================================================================
// DEK Fire. 3x HP, 1.1x Speed, 2.0x Score, 0.75x Mass
//=============================================================================

class FireNaliFighter extends DCNaliFighter config(satoreMonsterPack);

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
	else
		return ( P.class == class'FireBrute' || P.Class == class'FireChildGasbag' || P.Class == class'FireGasbag' || P.Class == class'FireGiantGasbag' || P.Class == class'FireKrall' || P.Class == class'FireLord' || P.Class == class'FireManta' || P.Class == class'FireMercenary' || P.Class == class'FireNali' || P.Class == class'FireNaliFighter' || P.Class == class'FireRazorfly' || P.Class == class'FireSkaarjPupae' || P.Class == class'FireSkaarjSniper' || P.Class == class'FireSkaarjSuperHeat' || P.Class == class'FireSlith' || P.Class == class'FireSlug');
}

function PostBeginPlay()
{
	Health *= class'ElementalConfigure'.default.FireHealthMultiplier;
	HealthMax *= class'ElementalConfigure'.default.FireHealthMultiplier;
	ScoringValue *= class'ElementalConfigure'.default.FireScoreMultiplier;
	GroundSpeed *= class'ElementalConfigure'.default.FireGroundSpeedMultiplier;
	AirSpeed *= class'ElementalConfigure'.default.FireAirSpeedMultiplier;
	WaterSpeed *= class'ElementalConfigure'.default.FireWaterSpeedMultiplier;
	Mass *= class'ElementalConfigure'.default.FireMassMultiplier;
	SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*class'ElementalConfigure'.default.FireDrawscaleMultiplier/2));
	SetDrawScale(Drawscale*class'ElementalConfigure'.default.FireDrawscaleMultiplier);
	SetCollisionSize(CollisionRadius*class'ElementalConfigure'.default.FireDrawscaleMultiplier, CollisionHeight*class'ElementalConfigure'.default.FireDrawscaleMultiplier);
	
	Instigator = self;
	
	Super.PostBeginPlay();

}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     WeaponClassName(0)="XWeapons.RocketLauncher"
     WeaponClassName(1)="XWeapons.ShockRifle"
     WeaponClassName(2)="Onslaught.ONSMineLayer"
     WeaponClassName(3)="Onslaught.ONSGrenadeLauncher"
     WeaponClassName(4)="DEKMonsters209F.DEKINIREdeemer"
     WeaponClassName(5)="XWeapons.MiniGun"
     WeaponClassName(6)="XWeapons.BioRifle"
     WeaponClassName(7)="XWeapons.ShieldGun"
     GibGroupClass=Class'DEKMonsters209F.FireGibGroup'
     Skins(0)=Texture'DEKMonstersTexturesMaster208.FireMonsters.FireNali'
     Skins(1)=Texture'DEKMonstersTexturesMaster208.FireMonsters.FireNali'
}
