class NecroGhostPossessorInvasionOrb extends Projectile
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
     OrbEffectClass=Class'DEKMonsters999X.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters999X.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters999X.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters999X.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters999X.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters999X.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters999X.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters999X.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters999X.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters999X.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters999X.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters999X.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters999X.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters999X.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters999X.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters999X.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters999X.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters999X.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters999X.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters999X.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters999X.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters999X.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters999X.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters999X.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters999X.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters999X.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters999X.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters999X.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters999X.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters999X.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters999X.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters999X.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters999X.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters999X.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters999X.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters999X.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters999X.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters999X.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters999X.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters999X.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters999X.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters999X.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters999X.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters999X.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters999X.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters999X.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters999X.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters999X.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters999X.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters999X.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters999X.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters999X.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters999X.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters999X.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters999X.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters999X.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters999X.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters999X.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters999X.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters999X.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters999X.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters999X.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters999X.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters999X.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters999X.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters999X.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters999X.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters999X.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters999X.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters999X.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters999X.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters999X.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters999X.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters999X.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters999X.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters999X.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters999X.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters999X.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters999X.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters999X.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters999X.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters999X.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters999X.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters999X.BeamWarLord'
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
