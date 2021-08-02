//=============================================================================
// DEK Fire. 3x HP, 1.1x Speed, 2.0x Score, 0.75x Mass
//=============================================================================

class FireNali extends DCNali;

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
     GibGroupClass=Class'DEKMonsters208AE.FireGibGroup'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.FireMonsters.FireNaliShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.FireMonsters.FireNaliShader'
}
