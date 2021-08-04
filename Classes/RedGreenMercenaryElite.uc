class RedGreenMercenaryElite extends DCMercenaryElite;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'MissionCow');
	else
		return ( P.class == class'DCMercenaryElite' || P.class == class'RedGreenMercenary' || P.class == class'RedGreenMercenaryElite');
}

defaultproperties
{
     RocketAmmoClass=Class'DEKMonsters208AF.RedGreenEliteMercenaryRocketAmmo'
}
