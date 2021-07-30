class GiantWarbunny extends DCNaliRabbit
	config(satoreMonsterPack);
	
var RPGRules Rules;
var config int XPForKill;
var config bool bOnlyHumansCanDamage;
var config class<Actor> ChargerClass;
var config int NumGemDrop;

function PostBeginPlay()
{
	CheckRPGRules();
	super.PostBeginPlay();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'GiantWarbunny'  || P.class == class'GiantShockBunny' || P.Class == Class'GiantRageBunny' || P.Class == Class'GiantPoisonBunny' || P.Class == Class'GiantIceBunny' || P.Class == Class'GiantCosmicBunny');
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, vector momentum, class<DamageType> damageType)
{
    local Controller C,MC;
    //local BunnyGhostUltimaCharger BunnyUltima;
	
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent' || DamageType == class'DamTypeLightningTurretMinibolt' || DamageType == class'DamTypeLightningTurretProj' || DamageType == class'DamTypeGiantCosmicBunny' || DamageType == class'DamTypeGiantCosmicBunnyLightning' || DamageType == class'DamTypeGiantShockBunny' || DamageType == class'DamTypeGiantRageBunny' || DamageType == class'DamTypeDronePlasma' || DamageType == class'DamTypeUltima' || DamageType == class'DamTypeLingeringSpirit')
		return;
	if(instigatedBy.IsA('Monster') || instigatedBy.IsA('Vehicle'))
		return;
		
	if (bOnlyHumansCanDamage)
	{
		if (instigatedBy.PlayerReplicationInfo.bBot)
			return;
	}

    C = Level.ControllerList;
    while (C != None)
    {
        if (C.Pawn != None && C.Pawn.IsA('Monster'))
        {
            MC = C;
        }
        C = C.NextController;
    }
	
	if (instigatedBy != None && instigatedBy.Controller != None)
	{
		instigatedBy.Controller.Adrenaline = 0; //reset adrenaline back to 0 to avoid globing on wave 17.
	
		DropPickups(Instigator.Controller, InstigatedBy.Controller, class'DEKRPG208AC.GemExperiencePickupGold', None, NumGemDrop);
    
		Spawn(ChargerClass, MC,,Location);
		gibbedBy(instigatedBy);
	}
}

static function DropPickups(Controller Killed, Controller Killer, class<Pickup> PickupType, Inventory Inv, int Num)
{
    local Pickup pickupObj;
	local vector tossdir, X, Y, Z;
    local int i;

    for(i=0; i < Num; i++)
    {
        // This chain of events based on the way that weapon pickups are dropped when a pawn dies
	    // See Pawn.Died()

    	// Find out which direction the new pickup should be thrown

    	// Get a vector indicating direction the dying pawn was looking

        tossdir = Vector(Killed.Pawn.GetViewRotation());

    	// Adding coordinates to the directional vector

        tossdir = tossdir *	((Killed.Pawn.Velocity Dot tossdir) + 100) + Vect(0,0,200);

        // Change the velocity a bit for multiple drops

        tossdir.X += i*Rand(200);
        tossdir.Y += i*Rand(200);
        tossdir.Z += i*Rand(200);


    	Killed.Pawn.GetAxes(Killed.Pawn.Rotation, X,Y,Z);

	    // Set the pickup's location to a realistic position outside of the dying pawn's collision cylinder

        pickupObj = Killer.spawn(PickupType,,,(Killed.Pawn.Location + 0.8 * Killed.Pawn.CollisionRadius * X + -0.5 * Killed.Pawn.CollisionRadius * Y),);

        if(pickupObj == None)
        {
            Log("Pinata2k4 spawn failure");
            return;
        }

		// Now apply the throwing velocity to the position of the pickup
	    pickupObj.velocity = tossdir;

        pickupObj.InitDroppedPickupFor(Inv);
    }
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if ((XPForKill > 0) && (Rules != None))
	{
		Rules.ShareExperience(RPGStatsInv(Killer.Pawn.FindInventoryType(class'RPGStatsInv')), XPForKill);
	}
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     XPForKill=30
     bOnlyHumansCanDamage=True
     ChargerClass=Class'DEKMonsters208AC.BunnyGhostUltimaCharger'
     NumGemDrop=2
     Footstep(0)=None
     Footstep(1)=None
     GroundSpeed=150.000000
     AccelRate=562.500000
     JumpZ=75.000000
     ControllerClass=Class'DEKMonsters208AC.DCMonsterController'
     DrawScale=6.000000
     CollisionRadius=50.000000
     CollisionHeight=93.500000
}
