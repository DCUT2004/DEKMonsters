class CosmicWarlord extends DCWarlord;

#exec  AUDIO IMPORT NAME="CosmicWarlordFire" FILE="Sounds\CosmicWarlordFire.WAV" GROUP="MonsterSounds"

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

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);
		FireStart = GetFireStart(X,Y,Z);
		if ( !SavedFireProperties.bInitialized )
		{
			SavedFireProperties.AmmoClass = MyAmmo.Class;
			SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
			SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
			SavedFireProperties.MaxRange = MyAmmo.MaxRange;
			SavedFireProperties.bTossed = MyAmmo.bTossed;
			SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
			SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
			SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
			SavedFireProperties.bInitialized = true;
		}

		Spawn(MyAmmo.ProjectileClass,,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,600));
		PlaySound(FireSound,SLOT_Interact);
	}
}

defaultproperties
{
     FireSound=Sound'DEKMonsters208AJ.MonsterSounds.CosmicWarlordFire'
     AmmunitionClass=Class'DEKMonsters208AJ.CosmicWarlordAmmo'
     ScoringValue=12
     GibGroupClass=Class'DEKMonsters208AJ.CosmicGibGroup'
     GroundSpeed=700.000000
     AirSpeed=800.000000
     AccelRate=600.000000
     Health=300
     Skins(0)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicWarlord'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicWarlord'
     Mass=100.000000
}
