class RedGreenBrute extends DCBrute;


function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'MissionCow');
	else
		return (  P.class == class'DCBrute' || P.class == class'RedGreenBrute');
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters999X.RedGreenBruteAmmo'
}
