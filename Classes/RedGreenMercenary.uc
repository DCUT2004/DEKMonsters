class RedGreenMercenary extends DCMercenary;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'MissionCow');
	else
		return ( P.class == class'DCMercenary' || P.class == class'RedGreenMercenary');
}

defaultproperties
{
     RocketAmmoClass=Class'DEKMonsters208AC.RedGreenMercenaryRocketAmmo'
}
