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
     OrbEffectClass=Class'DEKMonsters208AD.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AD.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AD.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AD.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AD.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AD.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AD.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AD.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AD.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AD.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AD.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AD.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AD.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AD.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AD.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AD.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AD.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AD.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AD.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AD.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AD.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AD.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AD.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AD.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AD.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AD.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AD.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AD.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AD.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AD.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AD.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AD.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AD.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AD.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AD.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AD.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AD.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AD.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AD.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AD.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AD.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AD.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AD.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AD.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AD.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AD.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AD.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AD.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AD.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AD.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AD.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AD.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AD.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AD.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AD.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AD.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AD.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AD.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AD.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AD.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AD.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AD.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AD.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AD.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AD.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AD.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AD.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AD.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AD.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AD.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AD.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AD.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AD.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AD.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AD.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AD.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AD.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AD.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AD.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AD.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AD.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AD.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AD.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AD.BeamWarLord'
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
