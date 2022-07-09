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
     OrbEffectClass=Class'DEKMonsters209F.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters209F.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters209F.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters209F.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters209F.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters209F.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters209F.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters209F.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters209F.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters209F.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters209F.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters209F.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters209F.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters209F.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters209F.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters209F.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters209F.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters209F.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters209F.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters209F.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters209F.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters209F.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters209F.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters209F.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters209F.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters209F.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters209F.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters209F.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters209F.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters209F.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters209F.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters209F.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters209F.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters209F.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters209F.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters209F.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters209F.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters209F.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters209F.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters209F.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters209F.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters209F.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters209F.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters209F.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters209F.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters209F.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters209F.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters209F.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters209F.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters209F.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters209F.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters209F.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters209F.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters209F.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters209F.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters209F.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters209F.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters209F.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters209F.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters209F.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters209F.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters209F.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters209F.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters209F.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters209F.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters209F.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters209F.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters209F.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters209F.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters209F.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters209F.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters209F.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters209F.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters209F.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters209F.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters209F.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters209F.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters209F.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters209F.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters209F.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters209F.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters209F.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters209F.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters209F.BeamWarLord'
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
