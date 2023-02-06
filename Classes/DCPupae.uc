class DCPupae extends SkaarjPupae;

var bool SummonedMonster;
var StatusEffectInventory StatusManager;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	StatusManager = class'DEKMonsterUtility'.static.SpawnStatusEffectInventory(Instigator);
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCPupae' || P.class == class'DCChildPupae' || P.class == class'DCQueen');
}

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;
	
	if ( bShotAnim && bLunging )
	{
		bLunging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( Controller != None && Controller.Target != None && Anim == 'Lunge' )
			MeleeDamageTarget(12, (20000.0 * Normal(Controller.Target.Location - Location)));
	}		
	Super.Bump(Other);
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'DEKMonsterUtility'.static.AdjustDamage(Damage, EventInstigator, Self, StatusManager, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
