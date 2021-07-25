class CosmicTitan extends DCTitan;

simulated function PostBeginPlay()
{
	GiveCosmicInv();
	Super.PostBeginPlay();
}

function GiveCosmicInv()
{
	local CosmicInv Inv;
	if (Instigator != None)
	{
		Inv = CosmicInv(Instigator.FindInventoryType(class'CosmicInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(Class'CosmicInv');
			Inv.GiveTo(Instigator);
		}
	}
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying); 
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.Class == Class'MissionCow');
	else
		return (  P.class == class'DCTitan' || P.class == class'DCStoneTitan' || P.class == class'CosmicTitan' || P.class == class'TechTitan' || P.Class == class'TitaniumTitan' || P.Class == class'FruitCakeTitan' || P.Class == class'HalloweenTitan');
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
		Proj=Spawn(class'CosmicTitanBlast',,,FireStart,FireRotation);
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
}

defaultproperties
{
     AmmunitionClass=Class'DEKMonsters208AB.CosmicTitanAmmo'
     ScoringValue=15
     GibGroupClass=Class'DEKMonsters208AB.CosmicGibGroup'
     bCanFly=True
     GroundSpeed=900.000000
     AirSpeed=600.000000
     AccelRate=600.000000
     Health=540
     Skins(0)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicTitan'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicTitan'
}
