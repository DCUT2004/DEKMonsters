class DCGnat extends DCRazorfly
	config(UT2004RPG);

var config int BiteDamage;

function RangedAttack(Actor A)
{
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		bShotAnim = true;
		PlayAnim('Shoot1');
		if ( MeleeDamageTarget(BiteDamage, (15000.0 * Normal(A.Location - Location))) )
			PlaySound(sound'injur1rf', SLOT_Talk);
			
		Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
		Controller.Destination.Z = Location.Z + 70;
		Velocity = AirSpeed * normal(Controller.Destination - Location);
		Controller.GotoState('TacticalMove', 'DoMove');
	}
}

defaultproperties
{
	 BiteDamage=10
     ControllerClass=Class'DEKRPG999X.DCMonsterController'
     HealthMax=20.000000
     Health=20
     AirSpeed=2000.000000
     AccelRate=2000.000000
     DrawScale=0.500000
     CollisionRadius=9.000000
     CollisionHeight=5.500000
}
