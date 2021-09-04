class TechSniper extends DCSkaarjSniper
	config(satoreMonsterPack);

var config float NetworkRadius;
var xEmitter NetworkChain;

function PostBeginPlay()
{
	super.PostBeginPlay();
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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	//Check to see if other tech monsters are nearby when taking damage
	//If there are other nearby tech monsters, divide the damage by the number of tech monsters and distribute the damage equally
	//Otherwise, just take the normal damage
	
	local Controller C, NextC;
	local Array < Pawn > TechMonsters;
	local int x;
	local int NetworkDamage;
	
	if (Instigator == None || instigatedBy == None)
		return;
	
	if (damageType != Class'DamTypeSharedDamage' && (instigatedBy != None && instigatedBy.Weapon != None && ((RPGWeapon(instigatedBy.Weapon) != None && !RPGWeapon(instigatedBy.Weapon).IsA('RW_Waterfall')) || RPGWeapon(instigatedBy.Weapon) == None)) )
	{
		TechMonsters.Length = 0;
		TechMonsters.Insert(0, 1);	//Insert 1 Monster element at index 0
		TechMonsters[0] = Instigator;
		x = 1;
		
		C = Level.ControllerList;
		
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None && C.Pawn != Instigator &&  C.Pawn.GetTeamNum() == Instigator.GetTeamNum() && TechInv(C.Pawn.FindInventoryType(Class'TechInv')) != None && VSize(C.Pawn.Location - Instigator.Location) <= NetworkRadius && FastTrace(C.Pawn.Location, Instigator.Location))
			{
				TechMonsters[x] = C.Pawn;
				x++;
			}
			C = NextC;
		}
		
		if (TechMonsters.Length > 1)	//We have an additional tech monster besides Instigator that we can split the damage with
		{
			NetworkDamage = Damage/TechMonsters.Length;
			if (NetworkDamage < 1)
				NetworkDamage = 1;
			for (x = 0; x < TechMonsters.Length; x++)
			{
				TechMonsters[x].TakeDamage(NetworkDamage, instigatedBy, TechMonsters[x].Location, Vect(0,0,0), Class'DamTypeSharedDamage');

				NetworkChain = Spawn(class'TechNetworkChain',Instigator,,Instigator.Location,rotator(Instigator.Location - TechMonsters[x].Location));
				if (NetworkChain != None)
				{
					NetworkChain.mSpawnVecA = TechMonsters[x].Location;
					NetworkChain.SetRotation(rotator(TechMonsters[x].Location - Instigator.Location));
					NetworkChain.SetBase(Instigator);
				}
			}
		}
		else	//Otherwise the array has 1 or fewer elements.
			Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
	else
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
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
	 NetworkRadius=1000.0000
     DamageMin=35
     DamageMax=45
     NumArcs=8
     DamageType=Class'DEKMonsters209A.DamTypeTechSniper'
     DamageTypeHeadShot=Class'DEKMonsters209A.DamTypeTechSniperHeadShot'
     HitEmitterClass=Class'DEKRPG209A.RedBoltEmitter'
     SecHitEmitterClass=Class'DEKMonsters209A.RedBoltChild'
     ScoringValue=12
     GibGroupClass=Class'DEKMonsters209A.DEKTechGibGroup'
     Health=300
     ControllerClass=Class'DEKMonsters209A.TechMonsterController'
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.TechMonsters.TechProjFB'
}
