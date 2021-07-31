class EarthPrincess extends EarthQueen;

var bool SummonedMonster;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	CheckController();
	if (Controller != None)
		GroundSpeed = GroundSpeed * (1 + 0.1 * MonsterController(Controller).Skill);
}

function CheckController()
{
	if (Instigator.ControllerClass == class'DEKFriendlyMonsterController')
		SummonedMonster = true;
	else
		SummonedMonster = false;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if (SummonedMonster)
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	else
		Super.Died(Killer, damageType, HitLocation);
}

function SpawnShot()
{
	local vector X,Y,Z, projStart;

	if(Controller==none)
		return;
	GetAxes(Rotation,X,Y,Z);

	if (row == 0)
		MakeNoise(1.0);

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z + 0.2 * CollisionRadius * Y;
	spawn(class'DEKMonsters208AD.EarthQueenThorn',self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));

	projStart = Location + 1 * CollisionRadius * X + ( 0.7 - 0.2 * row) * CollisionHeight * Z - 0.2 * CollisionRadius * Y;
	spawn(class'DEKMonsters208AD.EarthQueenThorn',self,,projStart,Controller.AdjustAim(SavedFireProperties,projStart,600));
	row++;
}

defaultproperties
{
     EggChance=0
     MaxEggs=0
}
