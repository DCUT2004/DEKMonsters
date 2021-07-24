class IcePrincess extends IceQueen;

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

//Princess can't spawn pupae
function SpawnChildren() {}

defaultproperties
{
     MaxChildren=0
}
