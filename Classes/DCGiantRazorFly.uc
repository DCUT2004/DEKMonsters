class DCGiantRazorFly extends SMPGiantRazorFly;

var bool SummonedMonster;
#exec  AUDIO IMPORT NAME="BuzzingWings" FILE="Sounds\BuzzingWings.WAV" GROUP="MonsterSounds"

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim('Fly');
}


simulated function PostNetBeginPlay()
{
	AmbientSound.BaseRadius=5000.00;
	Super.PostNetBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCGiantRazorFly');
}

function RangedAttack(Actor A)
{
	if ( A != None && VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		bShotAnim = true;
		PlayAnim('Shoot1');
		if ( MeleeDamageTarget(50, (15000.0 * Normal(A.Location - Location))) )
			PlaySound(sound'injur1rf', SLOT_Talk);
		
		if (Controller != None)
		{
			Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
			Controller.Destination.Z = Location.Z + 70;
			Velocity = AirSpeed * normal(Controller.Destination - Location);
			Controller.GotoState('TacticalMove', 'DoMove');
		}
	}
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Damage = class'Utility_Monster'.static.AdjustDamage(Damage, EventInstigator, Self, HitLocation, Momentum, DamageType);
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
     ScoringValue=7
     ControllerClass=Class'DEKRPG999X.DCMonsterController'
     AmbientSound=Sound'DEKMonsters999X.MonsterSounds.BuzzingWings'
}
