class DCAldebaran extends Aldebaran
	config(DEKMonsters);

var config float ScaleMultiplier;

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

defaultproperties
{
    NewHealth=850
	ScaleMultiplier=1.5000
    ControllerClass=Class'DEKMonsters209E.DCMonsterController'
}
