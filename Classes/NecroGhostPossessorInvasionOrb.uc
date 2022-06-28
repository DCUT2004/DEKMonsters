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
     OrbEffectClass=Class'DEKMonsters209D.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters209D.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters209D.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters209D.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters209D.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters209D.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters209D.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters209D.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters209D.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters209D.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters209D.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters209D.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters209D.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters209D.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters209D.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters209D.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters209D.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters209D.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters209D.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters209D.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters209D.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters209D.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters209D.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters209D.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters209D.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters209D.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters209D.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters209D.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters209D.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters209D.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters209D.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters209D.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters209D.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters209D.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters209D.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters209D.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters209D.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters209D.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters209D.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters209D.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters209D.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters209D.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters209D.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters209D.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters209D.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters209D.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters209D.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters209D.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters209D.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters209D.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters209D.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters209D.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters209D.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters209D.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters209D.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters209D.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters209D.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters209D.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters209D.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters209D.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters209D.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters209D.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters209D.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters209D.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters209D.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters209D.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters209D.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters209D.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters209D.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters209D.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters209D.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters209D.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters209D.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters209D.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters209D.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters209D.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters209D.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters209D.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters209D.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters209D.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters209D.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters209D.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters209D.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters209D.BeamWarLord'
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
