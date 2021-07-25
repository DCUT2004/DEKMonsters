class CosmicQueenBlast extends DEKMercuryMissile;

simulated function PostNetBeginPlay()
{
	local rotator DirRot;
	
	if (Role < ROLE_Authority && Direction != -1)
	{
		// adjust direction of flight accordingly to prevent replication-related inaccuracies
		DirRot.Yaw = Direction & 0xffff;
		DirRot.Pitch = Direction >> 16;
		Acceleration = AccelRate * vector(DirRot);
		Velocity = VSize(Velocity) * vector(DirRot);
	}
	SetOverlayMaterial(UDamageOverlay, LifeSpan, true);
	if (Trail != None)
	{
		Trail.Emitters[0].ColorScale = UDamageThrusterColorScale;
		Trail.Emitters[2].ColorScale = UDamageThrusterColorScale;
	}
	if (Team < ArrayCount(TrailLineColor))
	{
		Trail.Emitters[1].ColorMultiplierRange = TrailLineColor[Team];
		Trail.Emitters[1].Disabled = false;
	}
	if (bFakeDestroyed && Level.NetMode == NM_Client)
	{
		bFakeDestroyed = False;
		TornOff();
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
   if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
		
	ProcessContact(False, Trace(HitLocation, HitNormal, HitLocation + 10 * HitNormal, HitLocation - 10 * HitNormal, True), HitLocation, HitNormal);

    if ( EffectIsRelevant(Location,false) )
		Spawn(class'ShockComboFlash',,, HitLocation, rotator(HitNormal));
    PlaySound(Sound'WeaponSounds.ShockRifle.ShockComboFire');
	Destroy();
}

defaultproperties
{
     SplashDamageType=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     HeadHitDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     DirectHitDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     PunchThroughDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     ThroughHeadDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     AirHeadHitDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     AirHitDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     AirPunchThroughDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     AirThroughHeadDamage=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     Damage=33.000000
     DamageRadius=200.000000
     MyDamageType=Class'DEKMonsters208AB.DamTypeCosmicQueen'
     StaticMesh=StaticMesh'VMWeaponsSM.PlayerWeaponsGroup.VMGrenade'
     Skins(0)=Texture'VMWeaponsTX.PlayerWeaponsGroup.GrenadeTex'
}
