class CosmicQueenBlast extends PROJ_Sentinel_Mercury;

simulated function Explode(vector HitLocation, vector HitNormal)
{
   if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    if ( EffectIsRelevant(Location,false) )
		Spawn(class'ShockComboFlash',,, HitLocation, rotator(HitNormal));
    PlaySound(Sound'WeaponSounds.ShockRifle.ShockComboFire');
	Destroy();
}

defaultproperties
{
     Damage=33.000000
     DamageRadius=200.000000
     MyDamageType=Class'DEKMonsters208AH.DamTypeCosmicQueen'
}
