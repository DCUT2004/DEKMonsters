class NecroGhostExpProj extends NecroGhostSeekingProj
	config(satoreMonsterPack);

var config int ModifierDecrease;

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;
    local float SeekingDistance;
	local RPGWeapon W;
	local Pawn P;
	
	P = Pawn(Seeking);
	if (P == None || P.Health <= 0)
	{
		Destroy();
		return;
	}

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	ForceDir = Normal(P.Location - Location);
	VelMag = VSize(Velocity);
	ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
	Velocity =  VelMag * ForceDir;
	Acceleration += 5 * ForceDir;

	// Update rocket so it faces in the direction its going.
	SetRotation(rotator(Velocity));


	SeekingDistance = VSize(P.Location - Location);
	if(SeekingDistance < 50)
	{
		if (P.Weapon != None && P.Weapon.IsA('RPGWeapon'))
		{
			W = RPGWeapon(P.Weapon);
			if (W != None)
			{
				if (W.Modifier > W.MinModifier)
				{
					W.Modifier -= ModifierDecrease;
					if (W.Modifier < W.MinModifier)
						W.Modifier = W.MinModifier;
					W.Identify();
				}
			}
		}
		Destroy();
	}
}

defaultproperties
{
	OrbFXClass=Class'DEKMonsters999X.NecroGhostExpProjEffect'
	ModifierDecrease=1
}