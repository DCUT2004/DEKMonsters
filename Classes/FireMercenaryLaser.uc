//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FireMercenaryLaser extends ONSAttackCraftPlasmaProjectileRed;

var float HeatLifeSpan;
var config float BaseChance;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Vector X, RefNormal, RefDir;
	local SuperHeatInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

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
		// now see if we can freeze em
		P = Pawn(Other);
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(P))
		{
			MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
			if (MInv == None)
			{
				if(rand(99) < int(BaseChance))
				{
					Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
					if (Inv == None)
					{
						Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
						Inv.Modifier = 2;
						Inv.LifeSpan = 3.0;
						Inv.GiveTo(P);
					}
				}
				Explode(Location, vect(0,0,1));				
			}
			else
				Explode(Location, vect(0,0,1));
		}
	}	
}

defaultproperties
{
     HeatLifespan=3.000000
     BaseChance=25.000000
     HitEffectClass=Class'DEKRPG999X.HeatHitEffect'
     PlasmaEffectClass=Class'DEKMonsters999X.FireMercenaryPlasmaEffect'
     Speed=2000.000000
     MaxSpeed=2000.000000
	 Damage=18
     DamageRadius=100.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeFireMercenary'
}
