class DCAldebaran extends Aldebaran
	config(DEKMonsters);

var config float ScaleMultiplier;

simulated function PostBeginPlay()
{
	Super(DEKMonster).PostBeginPlay();
	
	if (Instigator != None)
	{
		Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
		SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*ScaleMultiplier/2));
		SetDrawScale(Drawscale*ScaleMultiplier);
		SetCollisionSize(CollisionRadius*ScaleMultiplier, CollisionHeight*ScaleMultiplier);
	}
}

defaultproperties
{
    NewHealth=750
	ScaleMultiplier=1.5000
    ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
