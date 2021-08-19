//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================
class DEKGhostMercenary extends DCMercenaryElite;

var config int GhostChance;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

function SpawnRocket()
{
	if (GhostChance > rand(99))
	{
		SetCollision(False,False,False);
		bCollideWorld = True;
		SetInvisibility(60.0);
	}
	else
	{
		SetCollision(True,True,True);
		bCollideWorld = True;
		SetInvisibility(0.0);
	}
	Super(SMPMercenary).SpawnRocket();
}

defaultproperties
{
     GhostChance=60
     ScoringValue=11
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208AH.DEKGhostGibGroup'
     bCanFly=True
     GroundSpeed=425.000000
     AccelRate=400.000000
     Health=480
     ControllerClass=Class'DEKMonsters208AH.DCMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
     Mass=75.000000
}
