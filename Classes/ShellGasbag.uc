class ShellGasBag extends DCGasBag;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' );
	else
		return ( P.class == class'ShellGasBag' );
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters999X.ShellGasBagAmmo'
     AirSpeed=530.000000
     Skins(0)=Texture'DEKMonstersTexturesMaster208.GenericMonsters.ShellGasBag1'
     Skins(1)=Texture'DEKMonstersTexturesMaster208.GenericMonsters.ShellGasBag2'
}
