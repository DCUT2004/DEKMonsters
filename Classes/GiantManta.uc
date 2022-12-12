class GiantManta extends DCManta
	config(satoreMonsterPack);

var Sound KnockbackSound;
var config int KnockbackModifier, KnockbackLifespan;
var config bool bDispellable, bStackable;

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'GiantManta' );
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
		
	if ( Location.Z - A.Location.Z + A.CollisionHeight <= 0 )
		return;
	if ( VSize(A.Location - Location) > MeleeRange + CollisionRadius + A.CollisionRadius - FMax(0, 0.7 * A.Velocity Dot Normal(A.Location - Location)) )
		return;
	bShotAnim = true;
	Acceleration = AccelRate * Normal(A.Location - Location + vect(0,0,0.8) * A.CollisionHeight);
	AddVelocity( 300*Normal(A.Location - Location) );
	Enable('Bump');
	bStinging = true;
	if (FRand() < 0.5)
	{
		SetAnimAction('Sting');
		PlaySound(sound'whip1m', SLOT_Interact);	 		
	}
	else
	{
 		SetAnimAction('Whip');
 		PlaySound(sound'sting1m', SLOT_Interact); 
 	}	
 }
 
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local int OldHealth, HealthTaken, TakePercent;


	// increase damage if a block or vehicle
	If ( (Controller.target != None) && Pawn(Controller.target) != None  && Pawn(Controller.target).Health > 0)
	{
	    OldHealth = Pawn(Controller.target).Health;
        TakePercent = 0;
	    if (DruidBlock(Controller.target) != None)
	    {
            hitdamage *= 16;        // if invasion damage to block will get reduced to 40%
            TakePercent = 30;
		}
		else if (vehicle(Controller.target) != None)
		{
            hitdamage *= 4;
            TakePercent = 15;
		}
	}

	if (super.MeleeDamageTarget(hitdamage, pushdir))
	{
	    // hit it
	    if (Controller.target == None || Pawn(Controller.target).Health <= 0)
	        HealthTaken = OldHealth;
		else
		    HealthTaken = OldHealth - Pawn(Controller.target).Health;
		if (HealthTaken < 0)
		    HealthTaken = 0;
		// now take some health back
		if (HealthTaken > 0)
		{
			HealthTaken = max((HealthTaken * TakePercent)/100.0, 1);
			GiveHealth(HealthTaken, HealthMax);
		}

		return true;
	}

	return false;
}

singular function Bump(actor Other)
{
	local name Anim;
	local float frame,rate;
	
	if ( bShotAnim && bStinging )
	{
		bStinging = false;
		GetAnimParams(0, Anim,frame,rate);
		if ( (Anim == 'Whip') || (Anim == 'Sting') )
		{
			MeleeDamageTarget(40, (10000.0 * Normal(Controller.Target.Location - Location)));
			GiantMantaKnockBack(Controller.Target,(10000.0 * Normal(Controller.Target.Location - Location)) );
		}
		Velocity *= -0.5;
		Acceleration *= -1;
		if (Acceleration.Z < 0)
			Acceleration.Z *= -1;
	}		
	Super.Bump(Other);
}

function GiantMantaKnockBack(Actor Victim, vector Momentum)
{
	local Pawn P;
	local StatusEffectManager StatusManager;
	Local Vector newLocation;

	P = Pawn(Victim);
	if(P == None || !class'DEKRPGWeapon'.static.NullCanTriggerPhysics(P))
		return;

	StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(P);
	if (StatusManager == None)
		return;

	StatusManager.AddStatusEffect(Class'StatusEffect_Momentum', -(abs(KnockbackModifier)), True, KnockbackLifespan, bDispellable, bStackable);
	
	// if they're not walking, falling, or hovering, 
	// the momentum won't affect them correctly, so make them hover.
	// this effect will end when the KnockbackInv expires.
	if(P.Physics != PHYS_Walking && P.Physics != PHYS_Falling && P.Physics != PHYS_Hovering)
		P.SetPhysics(PHYS_Hovering);

	// if they're walking, I need to bump them up 
	// in the air a bit or they won't be knocked back 
	// on no momentum weapons.
	if(P.Physics == PHYS_Walking)
	{
		newLocation = P.Location;
		newLocation.z += 10;
		P.SetLocation(newLocation);
	}
	// The manta normally attacks from slightly above. So lets change the momentum slightly
	if (Momentum.z < 0)
		Momentum.Z = 0.0;

	if (P.Mass > 0)
		Momentum = Momentum*(100.0/P.Mass);
	P.AddVelocity( Momentum );

	// if they dont notice they are flying through the air, dont tell them - so comment out
	//if(PlayerController(P.Controller) != None)
 	//	PlayerController(P.Controller).ReceiveLocalizedMessage(class'KnockbackConditionMessage', 0); 
	P.PlaySound(KnockbackSound,,1.5 * Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	//Check to see if other tech monsters are nearby when taking damage
	//If there are other nearby tech monsters, divide the damage by the number of tech monsters and distribute the damage equally
	//Otherwise, just take the normal damage
	
	if (class'TechInv'.static.SpreadDamage(Instigator, Damage, instigatedBy, hitlocation, momentum, damageType) == false)
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

}

defaultproperties
{
	KnockbackModifier=4
	KnockbackLifespan=2
	bDispellable=False
	bStackable=True
     KnockbackSound=Sound'WeaponSounds.Misc.ballgun_launch'
     GibGroupClass=Class'DEKMonsters999X.DEKTechGibGroup'
     MeleeRange=350.000000
     WaterSpeed=400.000000
     AirSpeed=800.000000
     AccelRate=500.000000
     Health=250
     ControllerClass=Class'DEKMonsters999X.TechMonsterController'
     DrawScale=2.500000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     CollisionRadius=65.000000
     CollisionHeight=32.000000
     Mass=250.000000
     RotationRate=(Pitch=10000,Yaw=48000,Roll=10000)
}
