class NecroGhostMisfortuneInv extends Inventory;

var Pawn PawnOwner;
var bool stopped;
var config float MisfortuneRadius;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(0.1, true);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	PawnOwner = Other;
	
	if (PawnOwner != None)
	{
		WardInv = ComboWardInv(PawnOwner.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
				PlayerController(PawnOwner.Controller).ClientPlaySound(Sound'DEKRPG208AF.ComboSounds.Ward');
			Destroy();
			return;
		}
		
		if (PawnOwner.Weapon != None && PawnOwner.Weapon.IsA('RW_MagicalWard'))
		{
			W = RW_MagicalWard(PawnOwner.Weapon);
			if (Rand(100) <= W.Modifier*W.ChanceToWardPerModifier)
			{
				MWInv = MagicalWardProtectionInv(PawnOwner.FindInventoryType(class'MagicalWardProtectionInv'));
				if (MWInv == None)
				{
					MWInv = PawnOwner.Spawn(Class'MagicalWardProtectionInv');
					MWInv.GiveTo(PawnOwner);
				}
				else
				{
					MWInv.Lifespan = MWInv.default.Lifespan;
					MWInv.ProtectionMultiplier -= MWInv.ProtectionPerWardMultiplier;
					if (MWInv.ProtectionMultiplier < MWInv.MaxProtectionMultiplier)
						MWInv.ProtectionMultiplier = MWInv.MaxProtectionMultiplier;
				}
				if (PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
					PlayerController(PawnOwner.Controller).ClientPlaySound(Sound'DEKRPG208AF.ComboSounds.Ward');
				Destroy();
				return;
			}
		}
	}
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local Pickup P;
	local Actor A;
	
	if(!stopped)
	{
		if (PawnOwner != None)
		{
			PawnOwner.ReceiveLocalizedMessage(class'NecroGhostMisfortuneMessage');
		}
		if (Role == ROLE_Authority)
		{
			if (PawnOwner == None || PawnOwner.Health <= 0)
			{
				Destroy();
				return;
			}
			
			if(!class'RW_Freeze'.static.canTriggerPhysics(PawnOwner))
			{
				stopEffect();
				return;
			}
			if (PawnOwner != None)
			{
				foreach PawnOwner.CollidingActors(class'Pickup', P, MisfortuneRadius)
				if ( P.ReadyToPickup(0) && WeaponLocker(P) == None )
				{
					A = spawn(class'RocketExplosion',,, P.Location);
					if (A != None)
					{
						A.RemoteRole = ROLE_SimulatedProxy;
						A.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
					}
					if (!P.bDropped && WeaponPickup(P) != None && WeaponPickup(P).bWeaponStay && P.RespawnTime != 0.0)
						P.GotoState('Sleeping');
					else
						P.SetRespawn();
				}
			}
		}
	}
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

simulated function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     MisfortuneRadius=300.000000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     LifeSpan=15.000000
}
