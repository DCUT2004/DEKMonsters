class LaserBehemoth extends DCBehemoth;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetInvisibility(30.0);
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	SetInvisibility(0.0);
	if ( Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
	{
		SetAnimAction('WalkFire');
		bShotAnim = true;
		return;
	}
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		PlaySound(sound'pwhip1br',SLOT_Talk);
		SetAnimAction(MeleeAttack[Rand(4)]);
	}	
	else if ( Controller.InLatentExecution(501) ) // LATENT_MOVETO
	{
		SetInvisibility(30.0);
		return;
	}
	else
	{
		SetAnimAction('StillFire');
	}

	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
	bShotAnim = true;
}

function SpawnLeftShot()
{
	Super.SpawnLeftShot();
	SetInvisibility(60.0);
}

function SpawnRightShot()
{
	Super.SpawnRightShot();
	SetInvisibility(60.0);
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == Class'MissionCow');
	else
		return ( P.class == class'LaserBehemoth' );
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters209B.LaserBehemothAmmo'
     ScoringValue=7
     Health=240
}
