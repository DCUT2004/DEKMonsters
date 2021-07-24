class CosmicQueen extends DCQueen;

simulated function PostBeginPlay()
{
	GiveCosmicInv();
	Super.PostBeginPlay();
}

function GiveCosmicInv()
{
	local CosmicInv Inv;
	if (Instigator != None)
	{
		Inv = CosmicInv(Instigator.FindInventoryType(class'CosmicInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(Class'CosmicInv');
			Inv.GiveTo(Instigator);
		}
	}
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.Class == Class'MissionCow');
	else
		return ( P.class == class'Monster' );
}

defaultproperties
{
     FireSound=Sound'ONSBPSounds.Artillery.ShellIncoming1'
     AmmunitionClass=Class'DEKMonsters208AA.CosmicQueenAmmo'
     ScoringValue=20
     GibGroupClass=Class'DEKMonsters208AA.CosmicGibGroup'
     bCanFly=True
     GroundSpeed=1000.000000
     AirSpeed=1000.000000
     Health=480
     Mass=700.000000
}
