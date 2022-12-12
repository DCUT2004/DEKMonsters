class FireTentacleProj extends DCTentacleProjectile;

var config int HeatModifier, HeatLifespan;
var config bool bDispellable, bStackable;
var config float BaseChance;

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
					StatusManager.AddStatusEffect(Class'StatusEffect_Burn', -(abs(HeatModifier)), True, HeatLifespan, bDispellable, bStackable);
			}
			Explode(Location, vect(0,0,1));				
		}
	}	
}

defaultproperties
{
	 bDispellable=True
	 bStackable=False
	 HeatModifier=4
     HeatLifespan=4
     BaseChance=25.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeFireTentacle'
     Skins(0)=Texture'DEKMonstersTexturesMaster208.FireMonsters.FireGib'
}
