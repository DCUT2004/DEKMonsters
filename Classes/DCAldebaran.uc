class DCAldebaran extends Aldebaran
	config(DEKMonsters);

var config float ScaleMultiplier;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	Mass *= class'ElementalConfigure'.default.BossMassMultiplier;
	SetLocation(Instigator.Location+vect(0,0,1)*(Instigator.CollisionHeight*ScaleMultiplier/2));
	SetDrawScale(Drawscale*ScaleMultiplier);
	SetCollisionSize(CollisionRadius*ScaleMultiplier, CollisionHeight*ScaleMultiplier);
}

defaultproperties
{
    NewHealth=850
	ScaleMultiplier=1.5000
}
