//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================

class DEKGhostNali extends DCNali;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
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
     ScoringValue=2
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters999X.DEKGhostGibGroup'
     bCanFly=True
     AirSpeed=300.000000
     AccelRate=400.000000
     Health=200
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
     Mass=50.000000
}
