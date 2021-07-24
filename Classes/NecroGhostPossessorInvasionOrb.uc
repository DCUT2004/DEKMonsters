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
     OrbEffectClass=Class'DEKMonsters208AA.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AA.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AA.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AA.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AA.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AA.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AA.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AA.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AA.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AA.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AA.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AA.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AA.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AA.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AA.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AA.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AA.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AA.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AA.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AA.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AA.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AA.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AA.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AA.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AA.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AA.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AA.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AA.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AA.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AA.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AA.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AA.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AA.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AA.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AA.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AA.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AA.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AA.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AA.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AA.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AA.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AA.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AA.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AA.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AA.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AA.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AA.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AA.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AA.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AA.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AA.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AA.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AA.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AA.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AA.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AA.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AA.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AA.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AA.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AA.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AA.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AA.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AA.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AA.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AA.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AA.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AA.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AA.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AA.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AA.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AA.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AA.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AA.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AA.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AA.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AA.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AA.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AA.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AA.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AA.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AA.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AA.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AA.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AA.BeamWarLord'
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
