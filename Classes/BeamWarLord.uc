class BeamWarLord extends DCWarlord;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.Class == Class'MissionCow');
	else
		return ( P.class == class'BeamWarlord' );
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
     FireSound=SoundGroup'WeaponSounds.ShockRifle.ShockRifleAltFire'
     AmmunitionClass=Class'DEKMonsters209F.BeamWarlordAmmo'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.GenericMonsters.BeamWarlordShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.GenericMonsters.BeamWarlordShader'
}
