//=============================================================================
// DEKGhost. 2x HP, 1.1x Speed, 1.25x Score, 0.5x Mass
//=============================================================================

class DEKGhostTitan extends DCTitan;

var config int GhostChance;

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType)
{
	Momentum = vect(0,0,0);		// its a ghost - you can't knock it back
	Super.TakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, damageType);
}

function Stomp()
{
}

function FootStep()
{
}

function SpawnRock()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local Projectile   Proj;

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + 1.2*CollisionRadius * X + 0.4 * CollisionHeight * Z;
	if ( !SavedFireProperties.bInitialized )
	{
		SavedFireProperties.AmmoClass = MyAmmo.Class;
		SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
		SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
		SavedFireProperties.MaxRange = MyAmmo.MaxRange;
		SavedFireProperties.bTossed = MyAmmo.bTossed;
		SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
		SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
		SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
		SavedFireProperties.bInitialized = true;
	}

	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	if (FRand() < 0.4)
	{
		Proj=Spawn(class'TitanBoulder',,,FireStart,FireRotation);
		if(Proj!=none)
		{
			Proj.SetPhysics(PHYS_Projectile);
			Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
			Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
			Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
		}
		return;
	}

	Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
	if(Proj!=none)
	{
		Proj.SetPhysics(PHYS_Projectile);
		Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
	}
	FireStart=Location + 1.2*CollisionRadius * X -40*Y+ 0.4 * CollisionHeight * Z;
	Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
	if(Proj!=none)
	{
		Proj.SetPhysics(PHYS_Projectile);
		Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
		Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
		Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
	}
	bStomped=false;
	ThrowCount++;
	if(ThrowCount>=2)
	{
		bThrowed=true;
		ThrowCount=0;
	}
	
	if (GhostChance > rand(99))
	{
		SetCollision(False,False,False);
		bCollideWorld = True;
		SetInvisibility(60.0);
	}
	else
	{
		SetCollision(True,True,True);
		bCollideWorld = True;
		SetInvisibility(0.0);
	}
}

defaultproperties
{
     GhostChance=60
     ScoringValue=27
     InvisMaterial=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     GibGroupClass=Class'DEKMonsters208AA.DEKGhostGibGroup'
     bCanFly=True
     GroundSpeed=550.000000
     AirSpeed=300.000000
     AccelRate=400.000000
     Health=2500
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.shadeFB'
     Mass=1500.000000
}
