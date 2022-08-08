// BlastKrall - Krall firing yellow link primaries
class BlastKrall extends DCKrall;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'BlastKrall' );
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters999X.BlastKrallAmmo'
     ScoringValue=7
     Health=130
     Skins(0)=Texture'XEffectMat.goop.SlimeSkin'
     Skins(1)=Texture'XEffectMat.goop.SlimeSkin'
}
