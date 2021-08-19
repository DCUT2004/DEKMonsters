class CosmicSkaarj extends DCSkaarj;

simulated function PostBeginPlay()
{
	if (Instigator != None)
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
     AmmunitionClass=Class'DEKMonsters208AH.CosmicSkaarjAmmo'
     ScoringValue=9
     GibGroupClass=Class'DEKMonsters208AH.CosmicGibGroup'
     bCanFly=True
     GroundSpeed=500.000000
     AirSpeed=600.000000
     AccelRate=600.000000
     Health=90
     Skins(0)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicSkaarj'
     Mass=100.000000
}
