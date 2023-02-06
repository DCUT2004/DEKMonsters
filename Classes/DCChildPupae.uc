class DCChildPupae extends SMPChildPupae;

var DCQueen ParentQueenE;
var StatusEffectInventory StatusManager;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	StatusManager = class'DEKMonsterUtility'.static.SpawnStatusEffectInventory(Instigator);
}

function bool SameSpeciesAs(Pawn P)
{
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
	if(EventInstigator.IsA('DCQueen'))
		Destroy();
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'RocketSmokeRing');
	Destroy();
}

simulated function Destroyed()
{
	if ( ParentQueenE != None )
		ParentQueenE.numChildren--;
	Super.Destroyed();
	Spawn(class'RocketSmokeRing');
}

defaultproperties
{
     ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
