class Fenrir extends Regulus
	config(DEKMonsters);

var config float ScaleMultiplier;
var config float VampireMultiplier;

simulated function PostBeginPlay()
{
	local ComboInv ComboInv;
	
	Super.PostBeginPlay();
	
	if (Instigator != None)
	{
		Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
		SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*ScaleMultiplier/2));
		SetDrawScale(Drawscale*ScaleMultiplier);
		SetCollisionSize(CollisionRadius*ScaleMultiplier, CollisionHeight*ScaleMultiplier);
		
		ComboInv = ComboInv(Instigator.FindInventoryType(class'ComboInv'));
		if (ComboInv == None)
		{
			ComboInv = Instigator.Spawn(class'ComboInv');
			ComboInv.GiveTo(Instigator);
		}
	}
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
	{
		return;
	}

	Target = A;

	if(VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction(MeleeAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		//Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
	
	// check if still in melee range
	If ( (Controller.target != None) && (VSize(Controller.Target.Location - Location) <= MeleeRange * 1.4 + Controller.Target.CollisionRadius + CollisionRadius)
		&& ((Physics == PHYS_Flying) || (Physics == PHYS_Swimming) || (Abs(Location.Z - Controller.Target.Location.Z) 
			<= FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight))) )
	{	
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
		if ( HitActor != None )
			return false;
		Controller.Target.TakeDamage(hitdamage, self,HitLocation, pushdir, class'MeleeDamage');
		Instigator.GiveHealth(hitdamage*VampireMultiplier, Instigator.HealthMax);
		return true;
	}
	return false;
}

function FireProjectile()
{
	return;	//Melee only
}

defaultproperties
{
	VampireMultiplier=1.500000
    bMeleeFighter=True
    MeleeDamage=40
    MeleeRange=290.000000
	ScaleMultiplier=1.5000
	NewHealth=450
    GroundSpeed=980.000000
    ControllerClass=Class'DEKMonsters209D.DCMonsterController'
}
