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
     OrbEffectClass=Class'DEKMonsters209A.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters209A.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters209A.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters209A.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters209A.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters209A.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters209A.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters209A.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters209A.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters209A.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters209A.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters209A.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters209A.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters209A.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters209A.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters209A.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters209A.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters209A.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters209A.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters209A.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters209A.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters209A.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters209A.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters209A.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters209A.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters209A.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters209A.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters209A.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters209A.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters209A.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters209A.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters209A.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters209A.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters209A.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters209A.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters209A.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters209A.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters209A.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters209A.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters209A.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters209A.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters209A.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters209A.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters209A.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters209A.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters209A.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters209A.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters209A.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters209A.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters209A.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters209A.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters209A.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters209A.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters209A.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters209A.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters209A.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters209A.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters209A.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters209A.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters209A.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters209A.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters209A.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters209A.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters209A.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters209A.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters209A.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters209A.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters209A.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters209A.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters209A.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters209A.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters209A.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters209A.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters209A.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters209A.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters209A.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters209A.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters209A.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters209A.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters209A.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters209A.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters209A.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters209A.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters209A.BeamWarLord'
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
