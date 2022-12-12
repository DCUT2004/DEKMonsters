class NullWarlordRocket extends WarlordRocket;

var float MaxNullTime;
var config bool bDispellable, bStackable;

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	local StatusEffectManager StatusManager;
	local int NullLifespan;

	// freezes anything not a null warlord. Any side.
	
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if(C.Pawn == None)
		{
			C = NextC;
			break;
		}
		if (C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.Pawn.IsA('NullWarlord')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(C.Pawn))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(C.Pawn);
				if (StatusManager == None)
					return;
				NullLifespan = damageScale * MaxNullTime;
				StatusManager.AddStatusEffect(Class'StatusEffect_NullEntropy', -1, True, NullLifespan, bDispellable, bStackable);
			}
			if(C.Pawn == None)
			{
				C = NextC;
				break;
			}
		}

		C = NextC;
	}
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

defaultproperties
{
	bDispellable=True
	bStackable=False
     MaxNullTime=3.000000
     Damage=50.000000
     MyDamageType=Class'DEKMonsters999X.DamTypeNullWarlord'
     StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.NullRocketProj'
}
