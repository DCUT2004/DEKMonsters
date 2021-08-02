class TechSkaarj extends DCIceSkaarj;

var int numChildren;
var() int MaxChildren;
var config float ProtectionMultiplier;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	MyAmmo.ProjectileClass = class'TechSkaarjProjectile';
	GiveTechInv();
}

function GiveTechInv()
{
	local TechInv Inv;
	if (Instigator != None)
	{
		Inv = TechInv(Instigator.FindInventoryType(class'TechInv'));
		if (Inv == None)
		{
			Inv = Instigator.Spawn(Class'TechInv');
			Inv.GiveTo(Instigator);
		}
	}
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali' || P.class == class'MissionCow');
	else
		return ( P.class == class'TechBehemoth' || P.Class == class'TechPupae' || P.Class == class'TechRazorfly' || P.Class == class'TechSkaarj' || P.Class == class'TechSlith' || P.Class == class'TechSlug' || P.Class == class'TechTitan' || P.Class == class'TechWarlord' || P.Class == class'TechQueen');
}

function SpawnChildren() //we're not going to actually spawn children. Just a hack for the Tech Skaarj mine
{
	local NavigationPoint N;
	local SMPChildPupae P;

	if(numChildren>=MaxChildren)
		return;
	else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
	{
		P=spawn(class 'SMPChildPupae' ,self,,N.Location);
		   if(P!=none)
		   {
		    P.LifeSpan=20+Rand(10);
			numChildren++;
			}
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

defaultproperties
{
     ProtectionMultiplier=0.500000
     AmmunitionClass=Class'DEKMonsters208AE.TechSkaarjAmmo'
     ScoringValue=8
     GibGroupClass=Class'DEKMonsters208AE.DEKTechGibGroup'
     GroundSpeed=600.000000
     WaterSpeed=100.000000
     AirSpeed=600.000000
     AccelRate=900.000000
     Health=200
     ControllerClass=Class'DEKMonsters208AE.TechMonsterController'
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkF"
     MovementAnims(2)="WalkF"
     MovementAnims(3)="WalkF"
     SwimAnims(0)="WalkF"
     SwimAnims(1)="WalkF"
     SwimAnims(2)="WalkF"
     SwimAnims(3)="WalkF"
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
     Mass=80.000000
     Buoyancy=80.000000
}
