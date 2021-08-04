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
     OrbEffectClass=Class'DEKMonsters208AF.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AF.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AF.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AF.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AF.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AF.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AF.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AF.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AF.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AF.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AF.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AF.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AF.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AF.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AF.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AF.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AF.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AF.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AF.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AF.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AF.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AF.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AF.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AF.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AF.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AF.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AF.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AF.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AF.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AF.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AF.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AF.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AF.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AF.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AF.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AF.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AF.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AF.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AF.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AF.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AF.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AF.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AF.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AF.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AF.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AF.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AF.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AF.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AF.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AF.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AF.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AF.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AF.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AF.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AF.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AF.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AF.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AF.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AF.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AF.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AF.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AF.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AF.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AF.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AF.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AF.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AF.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AF.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AF.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AF.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AF.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AF.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AF.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AF.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AF.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AF.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AF.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AF.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AF.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AF.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AF.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AF.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AF.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AF.BeamWarLord'
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
