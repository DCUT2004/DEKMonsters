class CosmicMercenary extends DCMercenary;

#exec  AUDIO IMPORT NAME="PlasmaTurretFire" FILE="Sounds\PlasmaTurretFire.WAV" GROUP="MonsterSounds"

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
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'Monster' );
}

simulated function SprayTarget()
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
		PlaySound(Sound'DEKMonsters999X.MonsterSounds.PlasmaTurretFire');
	}
}

function SpawnRocket()
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
		PlaySound(Sound'DEKMonsters999X.MonsterSounds.PlasmaTurretFire');
	}
}

defaultproperties
{
     RocketAmmoClass=Class'DEKMonsters999X.CosmicMercenaryAmmo'
     AmmunitionClass=Class'DEKMonsters999X.CosmicMercenaryAmmo'
     ScoringValue=10
     GibGroupClass=Class'DEKMonsters999X.CosmicGibGroup'
     GroundSpeed=685.000000
     AirSpeed=600.000000
     AccelRate=1100.000000
     Health=108
     Skins(0)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicSkaarj'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicSkaarj'
}
