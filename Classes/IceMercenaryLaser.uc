class IceMercenaryLaser extends ONSAttackCraftPlasmaProjectileBlue;

var config int FreezeModifier, FreezeLifespan;
var config bool bDispellable, bStackable;
var config float BaseChance;
var sound FreezeSound;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Vector X, RefNormal, RefDir;
	local Pawn P;
	local StatusEffectManager StatusManager;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
	
    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
	if ( Role == ROLE_Authority )
	{
		Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);

		P = Pawn(Other);
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(P))
		{
			if(rand(100) < int(BaseChance))
			{
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(P);
				if (StatusManager != None)
					StatusManager.AddStatusEffect(Class'StatusEffect_Speed', -(abs(FreezeModifier)), True, FreezeLifespan, bDispellable, bStackable);
			}
			Explode(Location, vect(0,0,1));				
		}
	}	
}

defaultproperties
{
	 bDispellable=True
	 bStackable=False
	 FreezeModifier=4
	 FreezeLifespan=4.00
     BaseChance=25.000000
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     HitEffectClass=Class'DEKRPG999X.FreezeHitEffect'
     PlasmaEffectClass=Class'DEKMonsters999X.IceMercenaryPlasmaEffect'
     Speed=2000.000000
     MaxSpeed=2000.000000
	 Damage=18
     DamageRadius=100.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeIceMercenary'
     ExplosionDecal=None
}
