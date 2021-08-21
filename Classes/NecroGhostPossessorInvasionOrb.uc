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
     OrbEffectClass=Class'DEKMonsters208AJ.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AJ.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AJ.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AJ.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AJ.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AJ.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AJ.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AJ.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AJ.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AJ.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AJ.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AJ.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AJ.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AJ.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AJ.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AJ.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AJ.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AJ.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AJ.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AJ.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AJ.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AJ.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AJ.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AJ.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AJ.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AJ.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AJ.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AJ.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AJ.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AJ.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AJ.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AJ.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AJ.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AJ.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AJ.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AJ.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AJ.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AJ.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AJ.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AJ.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AJ.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AJ.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AJ.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AJ.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AJ.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AJ.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AJ.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AJ.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AJ.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AJ.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AJ.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AJ.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AJ.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AJ.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AJ.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AJ.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AJ.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AJ.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AJ.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AJ.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AJ.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AJ.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AJ.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AJ.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AJ.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AJ.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AJ.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AJ.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AJ.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AJ.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AJ.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AJ.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AJ.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AJ.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AJ.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AJ.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AJ.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AJ.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AJ.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AJ.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AJ.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AJ.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AJ.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AJ.BeamWarLord'
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
