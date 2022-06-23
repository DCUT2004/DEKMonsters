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
     OrbEffectClass=Class'DEKMonsters209C.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters209C.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters209C.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters209C.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters209C.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters209C.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters209C.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters209C.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters209C.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters209C.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters209C.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters209C.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters209C.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters209C.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters209C.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters209C.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters209C.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters209C.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters209C.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters209C.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters209C.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters209C.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters209C.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters209C.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters209C.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters209C.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters209C.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters209C.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters209C.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters209C.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters209C.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters209C.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters209C.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters209C.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters209C.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters209C.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters209C.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters209C.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters209C.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters209C.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters209C.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters209C.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters209C.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters209C.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters209C.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters209C.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters209C.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters209C.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters209C.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters209C.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters209C.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters209C.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters209C.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters209C.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters209C.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters209C.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters209C.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters209C.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters209C.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters209C.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters209C.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters209C.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters209C.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters209C.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters209C.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters209C.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters209C.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters209C.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters209C.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters209C.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters209C.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters209C.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters209C.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters209C.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters209C.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters209C.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters209C.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters209C.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters209C.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters209C.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters209C.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters209C.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters209C.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters209C.BeamWarLord'
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
