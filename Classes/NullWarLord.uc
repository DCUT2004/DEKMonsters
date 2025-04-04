class NullWarLord extends DCWarLord;

var config float MaxNullTime;

function FireProjectile()
{	
	local vector FireStart,X,Y,Z;
	local rotator ProjRot;
	local NullWarlordRocket NWR;
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
		ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,600);
		if ( bRocketDir )
			ProjRot.Yaw += 3072; 
		else
			ProjRot.Yaw -= 3072; 
		bRocketDir = !bRocketDir;
		NWR = Spawn(class'NullWarlordRocket',,,FireStart,ProjRot);
		if (NWR != None)
		{
			NWR.MaxNullTime = MaxNullTime;
			NWR.Seeking = Controller.Enemy;
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield');
	else
		return ( P.class == class'NullWarlord' );
}

defaultproperties
{
     MaxNullTime=3.000000
     AmmunitionClass=Class'DEKMonsters999X.NullWarlordAmmo'
     Skins(0)=Shader'DEKMonstersTexturesMaster208.GenericMonsters.DarkWarlordShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.GenericMonsters.DarkWarlordShader'
}
