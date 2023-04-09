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
	local int x;
	
	for (x = 0 ; x < Class'DEKRPG999X.Utility_Monster'.default.BunnyIgnoredDamTypes.Length; x++)
		if (ClassIsChildOf(DamageType, Class'DEKRPG999X.Utility_Monster'.default.BunnyIgnoredDamTypes[x]))
			return;

	if(instigatedBy.IsA('Monster') || instigatedBy.IsA('Vehicle'))
		return;
		
	if (bOnlyHumansCanDamage && instigatedBy.PlayerReplicationInfo.bBot)
			return;
	
	if (instigatedBy != None && instigatedBy.Controller != None)
	{
		instigatedBy.Controller.Adrenaline = 0; //reset adrenaline back to 0 to avoid globing on wave 17.
		Class'DEKRPG999X.AbilityLuckyStrike'.static.DropPickups(Instigator.Controller, InstigatedBy.Controller, class'DEKRPG999X.GemExperiencePickupGold', None, NumGemDrop);
		Spawn(ChargerClass,,,Location);
		gibbedBy(instigatedBy);
	}
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (XPForKill > 0 && Rules != None)
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
	ChargerClass=Class'DEKMonsters999X.BunnyGhostUltimaCharger'
	NumGemDrop=2
	Footstep(0)=None
	Footstep(1)=None
	GroundSpeed=150.000000
	AccelRate=562.500000
	JumpZ=75.000000
	ControllerClass=Class'DEKRPG999X.DCMonsterController'
	DrawScale=6.000000
	CollisionRadius=50.000000
	CollisionHeight=93.500000
}
