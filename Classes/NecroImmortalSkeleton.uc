class NecroImmortalSkeleton extends NecroMortalSkeleton;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	// Can't hurt it. It's immortal!
}

defaultproperties
{
     ClawDamage=35
     Skins(0)=Shader'DEKMonstersTexturesMaster208.NecroMonsters.SkeletonShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.NecroMonsters.SkeletonShader'
}
