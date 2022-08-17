class DEKMonster extends Monster;

simulated function PostBeginPlay()
{
	local StatusEffectInventory StatusInv;
	
	Super.PostBeginPlay();
	if (Instigator != None)
	{
		StatusInv = StatusEffectInventory(Instigator.FindInventoryType(Class'StatusEffectInventory'));
		if (StatusInv == None)
		{
			StatusInv = Instigator.Spawn(Class'StatusEffectInventory', Instigator);
			StatusInv.GiveTo(Instigator);
		}
	}
	
}

defaultproperties
{
}
