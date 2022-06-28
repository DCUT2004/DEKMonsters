class CosmicMercenaryRocket extends DEKMercuryMissile;

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
     SplashDamageType=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     HeadHitDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     DirectHitDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     PunchThroughDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     ThroughHeadDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     AirHeadHitDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     AirHitDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     AirPunchThroughDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     AirThroughHeadDamage=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     Speed=2000.000000
     MaxSpeed=2500.000000
     Damage=60.000000
     DamageRadius=120.000000
     MyDamageType=Class'DEKMonsters209D.DamTypeCosmicMercenary'
     StaticMesh=StaticMesh'AW-2k4XP.Weapons.ShockTankMuzzleFlash'
}