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
     OrbEffectClass=Class'DEKMonsters208AE.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AE.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AE.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AE.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AE.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AE.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AE.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AE.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AE.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AE.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AE.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AE.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AE.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AE.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AE.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AE.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AE.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AE.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AE.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AE.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AE.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AE.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AE.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AE.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AE.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AE.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AE.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AE.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AE.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AE.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AE.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AE.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AE.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AE.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AE.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AE.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AE.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AE.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AE.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AE.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AE.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AE.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AE.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AE.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AE.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AE.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AE.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AE.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AE.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AE.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AE.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AE.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AE.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AE.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AE.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AE.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AE.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AE.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AE.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AE.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AE.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AE.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AE.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AE.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AE.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AE.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AE.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AE.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AE.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AE.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AE.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AE.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AE.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AE.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AE.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AE.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AE.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AE.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AE.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AE.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AE.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AE.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AE.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AE.BeamWarLord'
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
