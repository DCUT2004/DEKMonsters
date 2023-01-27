class ElectricEel extends DCDevilFish
	config(satoreMonsterPack);

var config float ZapRange;
var class<xEmitter> ZapEmitterClass;
var config int ZapDamage;

simulated function PostBeginPlay()
{
	Super(DEKMonster).PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCDevilFish');
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function RangedAttack(Actor A)
{
	local float Dist;
	local float decision;
	local Pawn Victim;

	if ( bShotAnim )
		return;

	Dist=Vsize(Location-A.Location);
	if (Dist > ZapRange + CollisionRadius + A.CollisionRadius)
		return;
	bShotAnim = true;
	if (GetAnimSequence() == 'Grab1')
	{
		Victim = Pawn(A);
		if (Victim != None)
		{
			PlayAnim('ripper', 0.5 + 0.5 * FRand());
			PlaySound(sound'tear1fs',SLOT_Interact,,,500);
			ZapTarget(Victim);
			Disable('Bump');
		}
		return;
	}
	decision = FRand();
//	PlaySound(bite,SLOT_Interact,,,500);
	if (decision < 0.3)
	{
		Disable('Bump');
		SetAnimAction('Grab1');
		return;
	}

	Enable('Bump');
	//log("Start Melee Attack");
	if (decision < 0.55)
	{
		SetAnimAction('Bite1');
	}
	else if (decision < 0.8)
	{
 		SetAnimAction('Bite2');
 	}
 	else
 	{
 		SetAnimAction('Bite3');
 	}
 	Victim = Pawn(A);
	if (Victim != None)
		ZapTarget(Victim);
}

function ZapTarget(Pawn Victim)
{
	local xEmitter ZapEmitter;

	ZapEmitter = spawn(ZapEmitterClass,,,Location, rotator(Victim.Location - Location));
	if (ZapEmitter != None)
		ZapEmitter.mSpawnVecA = Victim.Location;
	Victim.TakeDamage(ZapDamage, Self, Victim.Location, Vect(5, 5, 5), Class'DamTypeElectricEel');
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
	ZapDamage=20
	ZapRange=300.0000
	Health=120
	AirSpeed=300.000000
	ScoringValue=4
	ControllerClass=Class'DEKMonsters999X.DCMonsterController'
	bCheckWater=False
	bCanFly=True
    ZapEmitterClass=Class'XEffects.LightningBolt'
}
