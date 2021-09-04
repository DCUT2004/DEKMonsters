class Princess extends DCQueen;

//Princess can't spawn pupae
function SpawnChildren() {}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'Princess' );
}

defaultproperties
{
     MaxChildren=0
     AmmunitionClass=Class'DEKMonsters209A.PrincessAmmo'
}
