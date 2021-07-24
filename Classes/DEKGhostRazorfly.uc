//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================

class DEKGhostRazorFly extends DCRazorFly;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

defaultproperties
{
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208AA.DEKGhostGibGroup'
     AirSpeed=330.000000
     Health=70
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
}
