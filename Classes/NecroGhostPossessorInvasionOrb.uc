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
     OrbEffectClass=Class'DEKMonsters208AH.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AH.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AH.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AH.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AH.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AH.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AH.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AH.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AH.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AH.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AH.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AH.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AH.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AH.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AH.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AH.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AH.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AH.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AH.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AH.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AH.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AH.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AH.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AH.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AH.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AH.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AH.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AH.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AH.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AH.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AH.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AH.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AH.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AH.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AH.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AH.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AH.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AH.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AH.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AH.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AH.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AH.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AH.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AH.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AH.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AH.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AH.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AH.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AH.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AH.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AH.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AH.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AH.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AH.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AH.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AH.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AH.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AH.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AH.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AH.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AH.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AH.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AH.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AH.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AH.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AH.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AH.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AH.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AH.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AH.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AH.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AH.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AH.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AH.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AH.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AH.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AH.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AH.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AH.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AH.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AH.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AH.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AH.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AH.BeamWarLord'
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
