class NecroGhostPossessorInvasionOrb extends UntargetedProjectile
	config(satoreMonsterPack);

#exec obj load file=GeneralAmbience.uax

var class<Emitter> OrbEffectClass;
var Emitter OrbEffect;
var config float SpawnInterval;
var Pawn GhostPossessor;
var config int LowWave, MediumWave;

var config Array < class < Monster > > LowLevelMonsterClass, MediumLevelMonsterClass, HighLevelMonsterClass;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		OrbEffect = Spawn(OrbEffectClass, Self);
		OrbEffect.SetBase(Self);
	}
	SetTimer(SpawnInterval, true);
	AmbientSound.BaseRadius = 5000.000;
}

function Timer() 
{
	SpawnMonster();
}

simulated function SpawnMonster()
{
	local class<Monster> MClass;
	local Monster M;
	local NecroGhostPossessorMonsterInv Inv;
	
	if (!Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 1)
		return;
	
	if (Invasion(Level.Game) != None)
	{
		if (Invasion(Level.Game).WaveNum <= LowWave)
		{
			MClass = LowLevelMonsterClass[Rand(LowLevelMonsterClass.Length)];
			M = Spawn(MClass,,,Location);
			if (M != None)
			{
				Invasion(Level.Game).NumMonsters++;
				Spawn(class'NecroGhostPossessorDeres',M,,M.Location);
				Spawn(class'NecroGhostPossessorDeresEffect',M,,M.Location);
				Inv = M.Spawn(class'NecroGhostPossessorMonsterInv');
				Inv.GiveTo(M);				
			}
		}
		else if (Invasion(Level.Game).WaveNum <= MediumWave)
		{
			MClass = MediumLevelMonsterClass[Rand(MediumLevelMonsterClass.Length)];
			M = Spawn(MClass,,,Location);
			if (M != None)
			{
				Invasion(Level.Game).NumMonsters++;
				Spawn(class'NecroGhostPossessorDeres',M,,M.Location);
				Spawn(class'NecroGhostPossessorDeresEffect',M,,M.Location);
				Inv = M.Spawn(class'NecroGhostPossessorMonsterInv');
				Inv.GiveTo(M);				
			}
		}
		else
		{
			MClass = HighLevelMonsterClass[Rand(HighLevelMonsterClass.Length)];
			M = Spawn(MClass,,,Location);
			if (M != None)
			{
				Invasion(Level.Game).NumMonsters++;
				Spawn(class'NecroGhostPossessorDeres',M,,M.Location);
				Spawn(class'NecroGhostPossessorDeresEffect',M,,M.Location);
				Inv = M.Spawn(class'NecroGhostPossessorMonsterInv');
				Inv.GiveTo(M);				
			}
		}
	}
	else
		return;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	return;
	//do nothing.
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'ONSVehicleSounds-S.Explosions.VehicleExplosion02',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
	}
}

simulated function DestroyTrails()
{
	if (OrbEffect != None)
		OrbEffect.Destroy();
}

simulated function Destroyed()
{
	if (OrbEffect != None)
	{
		if (bNoFX)
			OrbEffect.Destroy();
		else
			OrbEffect.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
     OrbEffectClass=Class'DEKMonsters208AG.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AG.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AG.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AG.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AG.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AG.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AG.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AG.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AG.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AG.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AG.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AG.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AG.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AG.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AG.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AG.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AG.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AG.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AG.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AG.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AG.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AG.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AG.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AG.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AG.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AG.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AG.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AG.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AG.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AG.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AG.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AG.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AG.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AG.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AG.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AG.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AG.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AG.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AG.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AG.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AG.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AG.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AG.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AG.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AG.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AG.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AG.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AG.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AG.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AG.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AG.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AG.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AG.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AG.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AG.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AG.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AG.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AG.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AG.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AG.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AG.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AG.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AG.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AG.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AG.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AG.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AG.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AG.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AG.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AG.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AG.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AG.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AG.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AG.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AG.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AG.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AG.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AG.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AG.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AG.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AG.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AG.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AG.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AG.BeamWarLord'
     MaxSpeed=0.000000
     TossZ=0.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=90
     LightBrightness=100.000000
     LightRadius=10.000000
     DrawType=DT_None
     bDynamicLight=True
     Physics=PHYS_Flying
     AmbientSound=Sound'GeneralAmbience.aliendrone2'
     LifeSpan=30.000000
     bFullVolume=True
     SoundVolume=232
     TransientSoundVolume=1000.000000
}
