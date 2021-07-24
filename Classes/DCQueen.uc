class DCQueen extends SMPQueen;

var bool SummonedMonster;

simulated function PostBeginPlay()
{
	local ComboInv ComboInv;
	Super(SMPMonster).PostBeginPlay();
	
	ComboInv = ComboInv(Instigator.FindInventoryType(class'ComboInv'));
	if (ComboInv == None)
	{
		ComboInv = Instigator.Spawn(class'ComboInv');
		ComboInv.GiveTo(Instigator);
	}
	
	if (Controller != None)
		GroundSpeed = GroundSpeed * (1 + 0.1 * MonsterController(Controller).Skill);
	QueenFadeOutSkin= new class'ColorModifier';
	QueenFadeOutSkin.Material=Skins[0];
	Skins[0]=QueenFadeOutSkin;
}

function bool SameSpeciesAs(Pawn P)
{
	if (SummonedMonster)
		return ( P.class == class'HealerNali');
	else
		return ( P.class == class'DCQueen' ||  P.class == class'DCPupae' ||  P.class == class'DCChildPupae');
}

function SpawnChildren()
{
	local NavigationPoint N;
	local DCChildPupae P;

	For ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if(numChildren>=MaxChildren)
			return;
		else if(vsize(N.Location-Location)<2000 && FastTrace(N.Location,Location))
		{
			P=spawn(class 'DCChildPupae' ,self,,N.Location);
		    if(P!=none)
		    {
		    	P.LifeSpan=20+Rand(10);
				numChildren++;
			}
		}

	}

}

defaultproperties
{
}
