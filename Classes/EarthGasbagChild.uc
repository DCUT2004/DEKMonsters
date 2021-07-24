class EarthGasbagChild extends EarthGasbag;

var EarthGiantGasbag ParentBag;
var() byte
	PunchDamage,	// Basic damage done by each punch.
	PoundDamage;	// Basic damage done by pound.

simulated function PreBeginPlay()
{
//	Log(Owner);
	ParentBag=EarthGiantGasbag(Owner);
	if(ParentBag==none)
		Destroy();
	Super.PreBeginPlay();
}

//function bool SameSpeciesAs(Pawn P)
//{
//	if (SummonedMonster)
//		return ( P.class == class'HealerNali' || P.class == class'HealerNaliAdren' || P.class == class'HealerNaliShield' || P.class == class'EarthBrute' || P.Class == class'EarthChildGasbag' || P.Class == class'EarthChildSkaarjPupae' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthLord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthNali' || P.Class == class'EarthNaliFighter' || P.Class == class'EarthQueen' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarjSuperHeat' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthTitan');
//	else
//		return ( P.class == class'EarthBrute' || P.Class == class'EarthChildGasbag' || P.Class == class'EarthChildSkaarjPupae' || P.Class == class'EarthGasbag' || P.Class == class'EarthGiantGasbag' || P.Class == class'EarthKrall' || P.Class == class'EarthLord' || P.Class == class'EarthManta' || P.Class == class'EarthMercenary' || P.Class == class'EarthNali' || P.Class == class'EarthNaliFighter' || P.Class == class'EarthQueen' || P.Class == class'EarthRazorfly' || P.Class == class'EarthSkaarjPupae' || P.Class == class'EarthSkaarjSniper' || P.Class == class'EarthSkaarjSuperHeat' || P.Class == class'EarthSlith' || P.Class == class'EarthSlug' || P.Class == class'EarthTitan');
//}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(ParentBag==none || ParentBag.Controller==none || ParentBag.Controller.Enemy==self)
	{
		Destroy();
		return;
	}
	if(ParentBag.Controller!=none && Controller!=none && Health>=0)
	{
		Controller.Enemy=ParentBag.Controller.Enemy;
		Controller.Target=ParentBag.Controller.Target;
	}
}

function PunchDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(PunchDamage, (39000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

function PoundDamageTarget()
{
	if(Controller==none || Controller.Target==none) return;
	if (MeleeDamageTarget(PoundDamage, (24000 * Normal(Controller.Target.Location - Location))))
		PlaySound(sound'Hit1g', SLOT_Interact);
}

simulated function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Spawn(class'RocketSmokeRing');
	Destroy();
}

simulated function Destroyed()
{
	if ( ParentBag != None )
		ParentBag.numChildren--;
	Super.Destroyed();
	Spawn(class'RocketSmokeRing');
}

defaultproperties
{
     PunchDamage=25
     PoundDamage=35
}
