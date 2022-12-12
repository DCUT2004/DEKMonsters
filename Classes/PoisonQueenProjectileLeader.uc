class PoisonQueenProjectileLeader extends ONSRVWebProjectileLeader;

var config int NullLifespan;
var config bool bDispellable, bStackable;

simulated function ProcessTouch(actor Other, vector HitLocation)
{
	local StatusEffectManager StatusManager;
	local Pawn P;

	//Don't hit the queen that fired me, or the queens shield
	if (Owner != None && (Other == Owner || Other.Owner == Owner) )
		return;

	// If we hit some stuff - just blow up straight away.
	if( Other.IsA('Projectile') || Other.bBlockProjectiles )
	{
		if(Role == ROLE_Authority)
			Leader.DetonateWeb();
	}
	else
	{
		StuckActor = Other;
		if ( (Level.NetMode != NM_Client) && (StuckActor != None) && (Vehicle(StuckActor) != None)
			&& (Bot(Pawn(StuckActor).Controller) != None) && (Level.Game.GameDifficulty > 4 + 2 * FRand()) )
		{
			//about to blow up, so bot will bail
			Vehicle(StuckActor).VehicleLostTime = Level.TimeSeconds + 10;
			Vehicle(StuckActor).KDriverLeave(false);
		}
		StuckNormal = normal(HitLocation - Other.Location);
		GotoState('Stuck');

		// ok, so let's see if we null entropy them
		if ( Role == ROLE_Authority )
		{
			// now see if we can freeze em
			P = Pawn(Other);
			if (P != None && vehicle(P) == None && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(P))
			{
				if (PoisonQueen(Owner) != None && PoisonQueen(Owner).SameSpeciesAs(P))
					return;		// queens immune to their own null entropy
				if (Leader != None && P.Controller != None && Leader.ProjTeam == P.Controller.GetTeamNum())
					return;		// same team so dont null entropy
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(P);
				if (StatusManager == None)
					return;
				if (StatusManager.AddStatusEffect(Class'StatusEffect_NullEntropy', -1, True, NullLifespan, bDispellable, bStackable))
					if (PoisonQueen(Owner) != None)
						PoisonQueen(Owner).NotifyStuckEnemy(P);				
			}
		}
	}
}

defaultproperties
{
	NullLifespan=3
	bDispellable=True
	bStackable=False
     Damage=15.000000
     MomentumTransfer=0.000000
}
