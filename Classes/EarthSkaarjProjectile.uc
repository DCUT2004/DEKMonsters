class EarthSkaarjProjectile extends Projectile;

var EarthSkaarjProjectileFX ProjectileFX;

simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    if( Pawn(Owner) != None )
        Instigator = Pawn( Owner );
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
	{
        ProjectileFX = Spawn(class'EarthSkaarjProjectileFX', self);
        ProjectileFX.SetBase(self);
	}

	Velocity = Speed * Vector(Rotation); 
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	
	Super.PostNetBeginPlay();
	
	if ( Level.NetMode == NM_DedicatedServer )
		return;
		
	PC = Level.GetLocalPlayerController();
	if ( (Instigator != None) && (PC == Instigator.Controller) )
		return;
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	else if ( (PC == None) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 3000) )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
}

simulated function Destroyed()
{
    if (ProjectileFX != None)
    {
		if ( bNoFX )
			ProjectileFX.Destroy();
		else
			ProjectileFX.Kill();
	}
	
	Super.Destroyed();
}

simulated function DestroyTrails()
{
    if (ProjectileFX != None)
        ProjectileFX.Destroy();
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

	if (Other == Instigator) return;
    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        DestroyTrails();
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
		Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local PlayerController PC;
	
   	PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
    {
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'DEKMonsters208AB.EarthDebrisExplosion', Self,, HitLocation, rotator(-HitNormal));
	}
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }
	SetCollisionSize(0.0, 0.0);
	Destroy();
}

defaultproperties
{
     Speed=900.000000
     MaxSpeed=900.000000
     bSwitchToZeroCollision=True
     Damage=45.000000
     DamageRadius=200.000000
     MomentumTransfer=70000.000000
     MyDamageType=Class'DEKMonsters208AB.DamTypeEarthSkaarj'
     ImpactSound=Sound'WeaponSounds.ShockRifle.ShockRifleExplosion'
     MaxEffectDistance=7000.000000
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=90
     LightBrightness=100.000000
     LightRadius=5.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bHidden=True
     bDynamicLight=True
     bOnlyDirtyReplication=True
     AmbientSound=Sound'WeaponSounds.ShockRifle.ShockRifleProjectile'
     LifeSpan=10.000000
     Texture=Texture'XEffects.Skins.MuzFlashWhite_t'
     DrawScale=0.065000
     Skins(0)=Texture'XEffects.Skins.MuzFlashWhite_t'
     Style=STY_Translucent
     FluidSurfaceShootStrengthMod=8.000000
     SoundVolume=255
     SoundRadius=60.000000
     bProjTarget=True
     bAlwaysFaceCamera=True
     ForceType=FT_Constant
     ForceRadius=40.000000
     ForceScale=5.000000
}
