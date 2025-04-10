class TitaniumTitanBoulder extends DCTitanBoulder;

function SpawnChunks(int num)
{
	local int    NumChunks,i;
	local TitaniumTitanSmallRock   TempRock;
	local float pscale;

	if ( DrawScale < 2 + FRand()*2 )
		return;
	if(Level.Game.IsA('Invasion') && DrawScale < 4 + FRand()*2)
		return;


	NumChunks = 1+Rand(num);
	pscale = sqrt(0.52/NumChunks);
	if ( pscale * DrawScale < 1 )
	{
		NumChunks *= pscale * DrawScale;
		pscale = 1/DrawScale;
	}
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempRock = Spawn(class'TitaniumTitanSmallRock');
		if (TempRock != None )
			TempRock.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}

defaultproperties
{
     MyDamageType=Class'DEKMonsters999X.DamTypeTitaniumTitanRock'
     Skins(0)=FinalBlend'satoreMonsterPackv120.SMPMetalSkaarj.MetalSkinFinal'
     Skins(1)=FinalBlend'satoreMonsterPackv120.SMPMetalSkaarj.MetalSkinFinal'
}
