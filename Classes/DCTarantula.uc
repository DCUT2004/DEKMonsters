class DCTarantula extends Tarantula
	config(DEKMonsters);

simulated function PostBeginPlay()
{
	Super(DEKMonster).PostBeginPlay();
}

defaultproperties
{
    ControllerClass=Class'DEKMonsters999X.DCMonsterController'
}
