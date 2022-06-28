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
     OrbEffectClass=Class'DEKMonsters209E.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters209E.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters209E.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters209E.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters209E.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters209E.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters209E.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters209E.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters209E.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters209E.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters209E.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters209E.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters209E.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters209E.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters209E.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters209E.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters209E.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters209E.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters209E.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters209E.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters209E.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters209E.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters209E.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters209E.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters209E.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters209E.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters209E.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters209E.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters209E.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters209E.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters209E.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters209E.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters209E.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters209E.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters209E.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters209E.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters209E.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters209E.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters209E.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters209E.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters209E.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters209E.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters209E.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters209E.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters209E.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters209E.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters209E.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters209E.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters209E.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters209E.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters209E.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters209E.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters209E.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters209E.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters209E.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters209E.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters209E.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters209E.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters209E.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters209E.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters209E.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters209E.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters209E.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters209E.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters209E.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters209E.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters209E.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters209E.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters209E.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters209E.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters209E.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters209E.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters209E.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters209E.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters209E.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters209E.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters209E.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters209E.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters209E.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters209E.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters209E.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters209E.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters209E.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters209E.BeamWarLord'
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
