class DCNaliCow extends SMPNaliCow;

var bool SummonedMonster;

simulated function PostNetBeginPlay()
{
	Instigator = self;
	Super.PostNetBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'DCNaliCow');
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
}
