class EarthHealerInv extends Inventory;

var config float HealInterval, HealRadius, HealMultiplier, RadiusMultiplier;
var config int HealAmount, MaxHealAmount;

var config float DefenseRadius, MinDefenseInterval, DefenseIntervalMultiplier;
var config int DefenseThreshold;

var EarthMonsterHealFX SelfHealFX;
var class<xEmitter> HitEmitterClass;
var int DefenseCounter;

function PostBeginPlay()
{
	DefenseCounter = 0;
	SetTimer(HealInterval, true);
	
	Super.PostBeginPlay();
}

function SetHealAmount(float ScoringValue)
{
	HealAmount *= 1 + (ScoringValue*default.HealMultiplier);
	if (HealAmount > default.MaxHealAmount)
		HealAmount = default.MaxHealAmount;
	HealRadius *= 1 + (ScoringValue*RadiusMultiplier);
	DefenseThreshold = Max(MinDefenseInterval, ScoringValue*default.DefenseIntervalMultiplier);
	//Log("Heal Amount Set: " $ HealAmount @ " health, " $ HealRadius @ " radius. Scoring Value: " $ ScoringValue);
}

function Timer()
{
	local Controller C;
	local FriendlyMonsterInv Inv;
	local EarthHealFX FX;
	local Projectile P;
	local xEmitter HitEmitter;
	local Projectile ClosestP;
	local Projectile BestGuidedP;
	local Projectile BestP;
	local int ClosestPdist;
	local int BestGuidedPdist;
	
	if (Instigator == None || Instigator.Health <= 0 || Instigator.Controller == None)
	{
		Destroy();
		return;
	}
	
	C = Level.ControllerList;	
	while (C != None)
	{
		if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.Health < C.Pawn.HealthMax && C.Pawn != Instigator && C.Pawn.IsA('Monster')
		&& VSize(C.Pawn.Location - Instigator.Location) <= HealRadius && FastTrace(C.Pawn.Location, Instigator.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('Missioncow'))
		{
			Inv = FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv'));
			if ((Inv == None && DEKFriendlyMonsterController(Instigator.Controller) == None) || (Inv != None && DEKFriendlyMonsterController(Instigator.Controller) != None))
			{
				C.Pawn.GiveHealth(HealAmount, C.Pawn.default.HealthMax);
				FX = C.Pawn.Spawn(class'EarthHealFX',C.Pawn,,C.Pawn.Location);
				if (FX != None)
				{
					FX.SetBase(C.Pawn);
					FX.RemoteRole = ROLE_SimulatedProxy;
				}
				if (SelfHealFX == None)
				{
					SelfHealFX = Instigator.Spawn(class'EarthMonsterHealFX',Instigator,,Instigator.Location);
					if (SelfHealFX != None)
					{
						SelfHealFX.SetBase(Instigator);
						SelfHealFX.RemoteRole = ROLE_SimulatedProxy;
					}
				}
			}
		}
		C = C.NextController;
	}
	
	DefenseCounter++;
	if (DefenseCounter >= DefenseThreshold)
	{
		// look for projectiles in range
		ClosestP = None;
		BestGuidedP = None;
		ClosestPdist = DefenseRadius+1;
		BestGuidedPdist = DefenseRadius+1;
		ForEach DynamicActors(class'Projectile',P)
		{
			if (P != None && FastTrace(P.Location, Instigator.Location) && TranslocatorBeacon(P) == None && UntargetedProjectile(P) == None && UntargetedSeekerProjectile(P) == None && VSize(Instigator.Location - P.Location) <= DefenseRadius)
			{
				if (P.InstigatorController != None && P.Instigator != None && (!P.Instigator.IsA('Monster') || FriendlyMonsterInv(P.Instigator.FindInventoryType(class'FriendlyMonsterInv')) != None) )
				{
					if ( BestGuidedPdist > VSize(Instigator.Location - P.Location) && P.bNetTemporary == false && !P.bDeleteMe)
					{
						BestGuidedP = P;
						BestGuidedPdist = VSize(Instigator.Location - P.Location);
					}
					if ( ClosestPdist > VSize(Instigator.Location - P.Location) && !P.bDeleteMe)
					{
						ClosestP = P;
						ClosestPdist = VSize(Instigator.Location - P.Location);
					}

				}
			}
		}
		if (BestGuidedP != None)
			BestP = BestGuidedP;
		else
			BestP = ClosestP;

		if (BestP != None && !BestP.bDeleteMe)
		{
			HitEmitter = spawn(HitEmitterClass,,, Instigator.Location, rotator(BestP.Location - Instigator.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = BestP.Location;

			BestP.NetUpdateTime = Level.TimeSeconds - 1;
			BestP.bHidden = true;
			if (BestP.Physics != PHYS_None)	// to stop attacking an exploding redeemer
			{
				// destroy it
				BestP.Lifespan=0.0100;
				//BestP.Explode(BestP.Location,vect(0,0,0));
			}
		}
		DefenseCounter = 0;
	}
}

simulated function Destroyed()
{
	if (SelfHealFX != None)
	{
		SelfHealFX.Kill();
		SelfHealFX.Destroy();
	}
	Super.Destroyed();
}

defaultproperties
{
     HealInterval=1.000000
     HealRadius=600.000000
     HealMultiplier=0.150000
     RadiusMultiplier=0.030000
     HealAmount=5
     MaxHealAmount=30
     DefenseRadius=600.000000
     MinDefenseInterval=3.000000
     DefenseIntervalMultiplier=0.850000
     HitEmitterClass=Class'DEKRPG208AA.DefenseBoltEmitter'
}
