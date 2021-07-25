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
     OrbEffectClass=Class'DEKMonsters208AB.NecroGhostPossessorInvasionOrbEffect'
     SpawnInterval=10.000000
     LowWave=6
     MediumWave=12
     LowLevelMonsterClass(0)=Class'DEKMonsters208AB.DCPupae'
     LowLevelMonsterClass(1)=Class'DEKMonsters208AB.DCRazorFly'
     LowLevelMonsterClass(2)=Class'DEKMonsters208AB.DCManta'
     LowLevelMonsterClass(3)=Class'DEKMonsters208AB.DCKrall'
     LowLevelMonsterClass(4)=Class'DEKMonsters208AB.DCEliteKrall'
     LowLevelMonsterClass(5)=Class'DEKMonsters208AB.DCGasbag'
     LowLevelMonsterClass(6)=Class'DEKMonsters208AB.FireSkaarjPupae'
     LowLevelMonsterClass(7)=Class'DEKMonsters208AB.IceSkaarjPupae'
     LowLevelMonsterClass(8)=Class'DEKMonsters208AB.EarthSkaarjPupae'
     LowLevelMonsterClass(9)=Class'DEKMonsters208AB.FireRazorfly'
     LowLevelMonsterClass(10)=Class'DEKMonsters208AB.IceRazorFly'
     LowLevelMonsterClass(11)=Class'DEKMonsters208AB.EarthRazorfly'
     LowLevelMonsterClass(12)=Class'DEKMonsters208AB.FireManta'
     LowLevelMonsterClass(13)=Class'DEKMonsters208AB.IceManta'
     LowLevelMonsterClass(14)=Class'DEKMonsters208AB.EarthManta'
     LowLevelMonsterClass(15)=Class'DEKMonsters208AB.FireKrall'
     LowLevelMonsterClass(16)=Class'DEKMonsters208AB.IceKrall'
     LowLevelMonsterClass(17)=Class'DEKMonsters208AB.EarthKrall'
     LowLevelMonsterClass(18)=Class'DEKMonsters208AB.DCTentacle'
     LowLevelMonsterClass(19)=Class'DEKMonsters208AB.IceTentacle'
     LowLevelMonsterClass(20)=Class'DEKMonsters208AB.FireTentacle'
     LowLevelMonsterClass(21)=Class'DEKMonsters208AB.EarthTentacle'
     LowLevelMonsterClass(22)=Class'DEKMonsters208AB.NecroGhostExp'
     LowLevelMonsterClass(23)=Class'DEKMonsters208AB.NecroGhostMisfortune'
     LowLevelMonsterClass(24)=Class'DEKMonsters208AB.DCSlith'
     LowLevelMonsterClass(25)=Class'DEKMonsters208AB.DCBrute'
     LowLevelMonsterClass(26)=Class'DEKMonsters208AB.TechPupae'
     LowLevelMonsterClass(27)=Class'DEKMonsters208AB.TechRazorfly'
     MediumLevelMonsterClass(0)=Class'DEKMonsters208AB.DCSkaarj'
     MediumLevelMonsterClass(1)=Class'DEKMonsters208AB.DCIceSkaarj'
     MediumLevelMonsterClass(2)=Class'DEKMonsters208AB.DCFireSkaarj'
     MediumLevelMonsterClass(3)=Class'DEKMonsters208AB.DCSkaarjTrooper'
     MediumLevelMonsterClass(4)=Class'DEKMonsters208AB.DCSkaarjSniper'
     MediumLevelMonsterClass(5)=Class'DEKMonsters208AB.DCMercenary'
     MediumLevelMonsterClass(6)=Class'DEKMonsters208AB.DCMercenaryElite'
     MediumLevelMonsterClass(7)=Class'DEKMonsters208AB.DCBehemoth'
     MediumLevelMonsterClass(8)=Class'DEKMonsters208AB.FireKrall'
     MediumLevelMonsterClass(9)=Class'DEKMonsters208AB.IceKrall'
     MediumLevelMonsterClass(10)=Class'DEKMonsters208AB.EarthKrall'
     MediumLevelMonsterClass(11)=Class'DEKMonsters208AB.FireGasbag'
     MediumLevelMonsterClass(12)=Class'DEKMonsters208AB.IceGasbag'
     MediumLevelMonsterClass(13)=Class'DEKMonsters208AB.EarthGasbag'
     MediumLevelMonsterClass(14)=Class'DEKMonsters208AB.FireSlith'
     MediumLevelMonsterClass(15)=Class'DEKMonsters208AB.IceSlith'
     MediumLevelMonsterClass(16)=Class'DEKMonsters208AB.EarthSlith'
     MediumLevelMonsterClass(17)=Class'DEKMonsters208AB.TechKrall'
     MediumLevelMonsterClass(18)=Class'DEKMonsters208AB.TechBehemoth'
     MediumLevelMonsterClass(19)=Class'DEKMonsters208AB.TechSkaarj'
     MediumLevelMonsterClass(20)=Class'DEKMonsters208AB.IceBrute'
     MediumLevelMonsterClass(21)=Class'DEKMonsters208AB.FireBrute'
     MediumLevelMonsterClass(22)=Class'DEKMonsters208AB.EarthBrute'
     MediumLevelMonsterClass(23)=Class'DEKMonsters208AB.EarthBehemoth'
     MediumLevelMonsterClass(24)=Class'DEKMonsters208AB.CosmicKrall'
     MediumLevelMonsterClass(25)=Class'DEKMonsters208AB.IceSkaarjFreezing'
     MediumLevelMonsterClass(26)=Class'DEKMonsters208AB.EarthSkaarj'
     MediumLevelMonsterClass(27)=Class'DEKMonsters208AB.FireSkaarjSuperHeat'
     MediumLevelMonsterClass(28)=Class'DEKMonsters208AB.CosmicBrute'
     MediumLevelMonsterClass(29)=Class'DEKMonsters208AB.NecroSoulWraith'
     MediumLevelMonsterClass(30)=Class'DEKMonsters208AB.NecroAdrenWraith'
     HighLevelMonsterClass(0)=Class'DEKMonsters208AB.FireMercenary'
     HighLevelMonsterClass(1)=Class'DEKMonsters208AB.IceMercenary'
     HighLevelMonsterClass(2)=Class'DEKMonsters208AB.EarthMercenary'
     HighLevelMonsterClass(3)=Class'DEKMonsters208AB.EarthEliteMercenary'
     HighLevelMonsterClass(4)=Class'DEKMonsters208AB.CosmicSkaarj'
     HighLevelMonsterClass(5)=Class'DEKMonsters208AB.FireLord'
     HighLevelMonsterClass(6)=Class'DEKMonsters208AB.IceWarLord'
     HighLevelMonsterClass(7)=Class'DEKMonsters208AB.EarthWarlord'
     HighLevelMonsterClass(8)=Class'DEKMonsters208AB.FireSkaarjSniper'
     HighLevelMonsterClass(9)=Class'DEKMonsters208AB.IceSkaarjSniper'
     HighLevelMonsterClass(10)=Class'DEKMonsters208AB.EarthSkaarjSniper'
     HighLevelMonsterClass(11)=Class'DEKMonsters208AB.FireSkaarjTrooper'
     HighLevelMonsterClass(12)=Class'DEKMonsters208AB.EarthSkaarjTrooper'
     HighLevelMonsterClass(13)=Class'DEKMonsters208AB.IceSkaarjTrooper'
     HighLevelMonsterClass(14)=Class'DEKMonsters208AB.NecroPhantom'
     HighLevelMonsterClass(15)=Class'DEKMonsters208AB.NecroSorcerer'
     HighLevelMonsterClass(16)=Class'DEKMonsters208AB.ArcticBioSkaarj'
     HighLevelMonsterClass(17)=Class'DEKMonsters208AB.LavaBioSkaarj'
     HighLevelMonsterClass(18)=Class'DEKMonsters208AB.CosmicMercenary'
     HighLevelMonsterClass(19)=Class'DEKMonsters208AB.CosmicWarlord'
     HighLevelMonsterClass(20)=Class'DEKMonsters208AB.TechWarlord'
     HighLevelMonsterClass(21)=Class'DEKMonsters208AB.DCWarlord'
     HighLevelMonsterClass(22)=Class'DEKMonsters208AB.NullWarLord'
     HighLevelMonsterClass(23)=Class'DEKMonsters208AB.BeamWarLord'
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
