
//=============================================
// Important Tags
//=============================================
//temp_fix_for_animation
// -- Temporary fix until animation is corrected
//TODO:
// -- Shit TODO

class EmberPawn extends UTPawn
placeable;

//=============================================
// Combo / Attack System Vars
//=============================================

var AttackFramework aFramework;
var GloriousGrapple GG;
var EmberDodge Dodge;
var GrappleRopeBlock testBlock;
var EmberVelocityPinch VelocityPinch;
var EmberChamberFlags ChamberFlags;
var EmberCosmetic_ItemList Cosmetic_ItemList;
var EmberModularPawn_Cosmetics ModularPawn_Cosmetics;


var byte SetUpCosmeticsStartupCheck;

var bool ParryEnabled;

var bool tempToggleForEffects;
// var SkeletalMeshComponent PlayerMeshComponent;
var decoSword LightDecoSword;
var decoSword MediumDecoSword;
var decoSword HeavyDecoSword;
var decoSword Helmet;
var AnimNodeSlot AnimSlot;
var bool SwordState;
var EmberPlayerController ePC;
// var() SkeletalMeshComponent SwordMesh;
var SkeletalMesh swordMesh;
var vector cameraOutLoc;
var array<ParticleSystemComponent> tetherBeam;
var array<GrappleRopeBlock> ropeBlockArray;

var array<SoundCue> huahs;
//=============================================
// Sprint System
//=============================================
var bool 			iLikeToSprint;
var bool 			tickToggle;
var float 			originalSpeed;

var float cameraCamZOffsetInterpolation;
var float cameraCamXOffsetMultiplierInterpolation;

//=============================================
// Jump/JetPack System
//=============================================
var bool 						jumpActive;
var bool 						verticalJumpActive;
var ParticleSystemComponent 	jumpEffects;
var rotator 					jumpRotation;
var vector 						jumpLocation;
var float 						gravityAccel;

var float 						JumpVelocityPinchTimer;

var vector 						movementVector;
var bool 						startSpaceMarineLanding;

var float 						JumpVelocityPinch_LandedTimer;


var bool debugConeBool;

//=============================================
// Foot/Kick System
//=============================================
var vector botFoot, oldBotFoot, botLeg, oldBotLeg;
var int  kickCounter;


//=============================================
// General Animations
//=============================================
var AnimNodeBlendList 	IdleAnimNodeBlendList;
var AnimNodeBlendList 	RunAnimNodeBlendList;
var AnimNodeBlendList 	LeftStrafeAnimNodeBlendList;
var AnimNodeBlendList 	RightStrafeAnimNodeBlendList;
var AnimNodeBlendList 	WalkAnimNodeBlendList;
var AnimNodeBlendList 	wLeftStrafeAnimNodeBlendList;
var AnimNodeBlendList 	wRightStrafeAnimNodeBlendList;
var AnimNodeBlendList 	FullBodyBlendList;
var AnimNodeBlendList 	JumpAttackSwitch;
var AnimNodeBlendList 	DashOverrideSwitch;
var int  				currentStance;
var bool 				idleBool, runBool;
var float 				idleBlendTime, runBlendTime;

//=============================================
// Attack 
//=============================================
var AnimNodeBlendList 		AttackGateNode;
var AnimNodeBlendList 		AttackBlendNode;
var AnimNodePlayCustomAnim 	EmberDash;
var AnimNodeSlot			AttackSlot[2];
var AnimNodeBlend			AttackBlend;
var byte 					blendAttackCounter;
var bool 					bAttackQueueing;
var bool 					bRightChambering;
var float 					iChamberingCounter;

var struct AttackPacketStruct
{
	var name AnimName;
	var array<float> Mods;
	var float tDur;
} AttackPacket;


var UDKSkelControl_Rotate 	SpineRotator;

var float 				animationQueueAndDirection;
var array<byte> savedByteDirection;
var float enableInaAudio;

//
//=============================================
// Weapon
//=============================================
var array<Sword> Sword;
var bool  tracerRecordBool;
// var bool swordBlockIsActive; //temp_fix_for_animation
//=============================================
// Camera
//=============================================
// var float width;
// var float height;
/*
===============================================
End Variables
===============================================
*/


// simulated event ReplicatedEvent(name VarName)
// {
//   DebugPrint("Rep Event Received - "@VarName);
//      if(VarName == 'RepMesh')
//      {
//       DebugPrint("RepMesh");
//           if(self.Pawn.Mesh.SkeletalMesh != RepMesh)
//           {
//             DebugPrint("Rep Mesh Change");
//                self.Pawn.Mesh.SetSkeletalMesh(RepMesh);
//           }
//      }
//      else
//      {
//           super.ReplicatedEvent(VarName);
//      }
// }
// replication
// {
//     if (bNetDirty)
//             RepMesh;
// }
//=============================================
// Utility Functions
//=============================================
/*
DebugPrint
	Easy way to print out debug messages
	If wanting to print variables, use: DebugPrint("var :" $var);
*/
function DebugPrint(string sMessage)
{
    GetALocalPlayerController().ClientMessage(sMessage);
}
// Not Needed, found out that there's an official code that does the same, even has same name >.<
// function bool isTimerActive(name tName)
// {
// 	return GetTimerCount(tName) != -1 ? true : false;
// }

//=============================================
// Null Functions
//=============================================

//Disables Landed Function, probably doesn't need disable
event Landed(vector HitNormal, Actor FloorActor);
simulated function TakeFallingDamage();
//Disables double directional dodge. Uncomment to renable.
function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross)
{
// 	local float VelocityZ;

// 	if ( Physics == PHYS_Falling )
// 	{
// 		TakeFallingDamage();
// 	}

// 	bDodging = true;
// 	bReadyToDoubleJump = (JumpBootCharge > 0);
// 	VelocityZ = Velocity.Z;
// 	Velocity = DodgeSpeed*Dir + (Velocity Dot Cross)*Cross ;

// 	if ( VelocityZ < -200 )
// 		Velocity.Z = VelocityZ + DodgeSpeedZ;
// 	else
// 		Velocity.Z = DodgeSpeedZ;

// //Edit here to control dodge distance
// 	Velocity.Z = 75;
// 	Velocity.X *= 4;
// 	Velocity.Y *= 4;

// 	CurrentDir = DoubleClickMove;
// 	SetPhysics(PHYS_Falling);
// 	SoundGroupClass.Static.PlayDodgeSound(self);
// 	return true;
}

//=============================================
// System Functions
//=============================================

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int OldHealth;

	Velocity.Z += 25;

	// Attached Bio glob instigator always gets kill credit
	if (AttachedProj != None && !AttachedProj.bDeleteMe && AttachedProj.InstigatorController != None)
	{
		EventInstigator = AttachedProj.InstigatorController;
	}

	// reduce rocket jumping
	if (EventInstigator == Controller)
	{
		momentum *= 0.6;
	}

	// accumulate damage taken in a single tick
	if ( AccumulationTime != WorldInfo.TimeSeconds )
	{
		AccumulateDamage = 0;
		AccumulationTime = WorldInfo.TimeSeconds;
	}
    OldHealth = Health;
	AccumulateDamage += Damage;
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	AccumulateDamage = AccumulateDamage + OldHealth - Health - Damage;

}
/*
PostBeginPlay
	The initial startup for the class
*/
simulated event PostBeginPlay()
{
	super.PostBeginPlay();

    //Add pawn to world info to be accessed from anywhere
   	EmberGameInfo(WorldInfo.Game).playerPawnWORLD = Self;

    aFramework = new class'EmberProject.AttackFramework';
    Dodge = new class'EmberProject.EmberDodge';
    GG = new class'EmberProject.GloriousGrapple';
    VelocityPinch = new class'EmberProject.EmberVelocityPinch';
    ChamberFlags = new class 'EmberProject.EmberChamberFlags';
    Cosmetic_ItemList = new class'EmberProject.EmberCosmetic_ItemList';
    ModularPawn_Cosmetics = new class'EmberProject.EmberModularPawn_Cosmetics';
    ModularPawn_Cosmetics.Initialize(self);
    Cosmetic_ItemList.InitiateCosmetics();
    Dodge.SetOwner(self);
    VelocityPinch.SetOwner(self);
    aFramework.InitFramework();

   	//1 second attach skele mesh
    SetTimer(0.2, false, 'WeaponAttach'); 
    // SetTimer(0.1, false, 'SetUpCosmetics');


// AttackFramework aFramework = new AttackFramework ();
//Temp delete m

}
function disableMoveInput(bool yn)
{
	ePC.IgnoreMoveInput(yn);
}
function disableLookInput(bool yn)
{
	ePC.IgnoreLookInput(yn);
}
simulated function bool DoDodge(array<byte> inputA)
{
	return Dodge.DoDodge(inputA);
}
simulated function SetUpCosmetics()
{
	local EmberCosmetic Cosmetic;
	local int i, x;
	if(SetUpCosmeticsStartupCheck == 1)
		return;
	SetUpCosmeticsStartupCheck = 1;
	DebugPrint("SetUpCosmetics");
	for(i = 0; i < Cosmetic_ItemList.CosmeticStruct.CosmeticItemList.length; i++)
	{
    Cosmetic = Spawn(class'EmberCosmetic', self);
    Cosmetic.Mesh.SetSkeletalMesh(Cosmetic_ItemList.CosmeticStruct.CosmeticItemList[i]);
    Cosmetic.Mesh.SetScale(Cosmetic_ItemList.CosmeticStruct.CosmeticItemScaleList[i]);
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Cosmetic.Mesh, Cosmetic_ItemList.CosmeticStruct.SocketLocationList[i]);
	}
	for(x = 0; x < Cosmetic_ItemList.CosmeticStruct.CapeItemList.length; x++)
	{
    Cosmetic = Spawn(class'EmberCosmetic', self);
    Cosmetic.Mesh.SetSkeletalMesh(Cosmetic_ItemList.CosmeticStruct.CapeItemList[x]);
    Cosmetic.Mesh.SetScale(Cosmetic_ItemList.CosmeticStruct.CosmeticItemScaleList[i]);
    Cosmetic_ItemList.SetCapeAttributes(Cosmetic.Mesh);
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Cosmetic.Mesh, Cosmetic_ItemList.CosmeticStruct.SocketLocationList[i]);
    i++;

	DebugPrint("SetUpCosmetics_Capes");
	}
// var(ModularPawn) const SkeletalMeshComponent HeadSkeletalMesh;
// // Skeletal mesh which represents the torso. Child to the head skeletal mesh component.
// var(ModularPawn) const SkeletalMeshComponent TorsoSkeletalMesh;
// // Skeletal mesh which represents the arms. Child to the head skeletal mesh component.
// var(ModularPawn) const SkeletalMeshComponent ArmsSkeletalMesh;
// // Skeletal mesh which represents the thighs. Child to the head skeletal mesh component.
// var(ModularPawn) const SkeletalMeshComponent ThighsSkeletalMesh;
// // Skeletal mesh which represents the boots. Child to the head skeletal mesh component.
// var(ModularPawn) const SkeletalMeshComponent BootsSkeletalMesh;
// var(ModularPawn) const SkeletalMeshComponent HandsSkeletalMesh;
// var(ModularPawn) const SkeletalMeshComponent FeetSkeletalMesh;


	ModularPawn_Cosmetics.ParentModularItem.SetRBChannel(RBCC_Pawn);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Default,TRUE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Cloth,TRUE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Pawn,TRUE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_Vehicle,TRUE);
   // Mesh.SetRBCollidesWithChannel(RBCC_Untitled3,FALSE);
   ModularPawn_Cosmetics.ParentModularItem.SetRBCollidesWithChannel(RBCC_BlockingVolume,TRUE);
	// ModularPawn_Cosmetics.ParentModularItem.SetPhysicsAsset(PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics');
}

/*
WeaponAttach
	Attaches a skeleton mesh of the weapon in same place as weapon
	Used to detect collisions. atm WIP.
*/
simulated function WeaponAttach() 
{ 
           // DebugMessagePlayer("SocketName: " $ mesh.GetSocketByName( 'WeaponPoint' ) );
    // mesh.AttachComponentToSocket(SwordMesh, 'WeaponPoint');
    local Sword tSword;
    // local UTPlayerController PC;
  	// PC = UTPlayerController(Instigator.Controller);
	// EmberPlayerController(PC).resetMesh();
		
        tSword = Spawn(class'Sword', self);
		tSword.Mesh.SetSkeletalMesh(aFramework.lightSwordMesh);
		tSword.setDamage(aFramework.lightDamagePerTracer);
        Sword.AddItem(tSword);
        tSword = Spawn(class'Sword', self);
		tSword.Mesh.SetSkeletalMesh(aFramework.mediumSwordMesh);
		tSword.setDamage(aFramework.mediumDamagePerTracer);
		// tSword.setPhysicsAsset(2);
        Sword.AddItem(tSword);
        tSword = Spawn(class'Sword', self);
		tSword.Mesh.SetSkeletalMesh(aFramework.heavySwordMesh);
		tSword.setDamage(aFramework.heavyDamagePerTracer);
        Sword.AddItem(tSword);

        huahs.AddItem(SoundCue'EmberSounds.huahcue1');
        // huahs.AddItem(SoundNodeWave'EmberSounds.huah2');
        // huahs.AddItem(SoundNodeWave'EmberSounds.huah3');
        // huahs.AddItem(SoundNodeWave'EmberSounds.huah4');
        // LightDecoSword = Spawn(class'decoSword', self);
        MediumDecoSword = Spawn(class'decoSword', self);
        // Helmet = Spawn(class'decoSword', self);
        // HeavyDecoSword = Spawn(class'decoSword', self);
        // LightDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.gladius');
        MediumDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.ember_scabbard_katana');
        // Helmet.Mesh.SetSkeletalMesh(SkeletalMesh'Cosmetic.Headband');
    // Mesh.AttachComponentToSocket(Helmet.Mesh, 'Helmet');
        // HeavyDecoSword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.ember_weapon_heavy');
    //Sword.SetBase( actor NewBase, optional vector NewFloor, optional SkeletalMeshComponent SkelComp, optional name AttachName );
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[0].Mesh, 'WeaponPoint');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[0].CollisionComponent, 'WeaponPoint');
     // LightAttachComponent.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.gladius');
 // MediumAttachComponent.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.ember_weapon_katana');
 // HeavyAttachComponent.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.ember_weapon_heavy');
 
	MediumDecoSword.Mesh.AttachComponentToSocket(Sword[1].Mesh, 'KattanaSocket');
    MediumDecoSword.Mesh.AttachComponentToSocket(Sword[1].CollisionComponent, 'KattanaSocket');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[2].Mesh, 'HeavyAttach');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[2].CollisionComponent, 'HeavyAttach');

 //TODO:Add these back in
    // Mesh.AttachComponentToSocket(LightDecoSword.Mesh, 'LightAttach');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(MediumDecoSword.Mesh, 'BalanceAttach');
    // Mesh.AttachComponentToSocket(HeavyDecoSword.Mesh, 'HeavyAttach');
    LightDecoSword.Mesh.SetHidden(true);
    MediumDecoSword.Mesh.SetHidden(false);
    HeavyDecoSword.Mesh.SetHidden(false);

SetUpCosmetics();
overrideStanceChange();
    	// Sword.Mesh.GetSocketWorldLocationAndRotation('StartControl', jumpLocation, jumpRotation);
    	// jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue', vect(0,0,0), vect(0,0,0), self); 
    	// WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue', Sword.Mesh, 'EndControl', true, , );
		// Sword.Mesh.AttachComponentToSocket(jumpEffects, 'StartControl');
		// jumpEffects.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue');
		// jumpEffects.ActivateSystem(true);
//TODO:readd
	
		// setTrailEffects();
		SetupPlayerControllerReference();
		PostInitAnimTree(ModularPawn_Cosmetics.ParentModularItem);
}
simulated function SetupPlayerControllerReference()
{
		ePC = EmberPlayerController(Instigator.Controller);
	    GG.setInfo(Self,  ePC);
}
simulated function setTrailEffects()
{ 
//Declare a new Emitter
local UTEmitter SwordEmitter;      
local vector Loc;
local rotator Roter;    
 
//Lets Get the Intial Location Rotation
Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('StartControl', Loc, Roter);
 
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, Loc, Roter);
 
//Set it to the Socket
SwordEmitter.SetBase(self,, Sword[currentStance-1].Mesh, 'StartControl'); 
 
//Set the template
// SwordEmitter.SetTemplate(ParticleSystem'RainbowRibbonForSkelMeshes.RainbowSwordRibbon', false); 
SwordEmitter.SetTemplate(ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue', false); 

 
//Never End
SwordEmitter.LifeSpan = 0;

}

simulated function setDodgeEffect()
{
	local UTEmitter SwordEmitter;      
local vector Loc;
local rotator Roter;    
 
//Lets Get the Intial Location Rotation
ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('Dodge1', Loc, Roter);
 
//Spawn The Emitter In to The Pool
SwordEmitter = Spawn(class'UTEmitter', self,, Loc, rotator(vector(roter) << rot(0,-8192,0)));
 
//Set it to the Socket
SwordEmitter.SetBase(self,, Mesh, 'Dodge1'); 
 
//Set the template
SwordEmitter.SetTemplate(ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Exhaust', false); 
 
//Never End
SwordEmitter.LifeSpan = 3;
}

simulated function setDodgeStance(int index, float duration)
{	
	EmberDash.PlayCustomAnim('ember_medium_dash_forward',1.0, duration/3, 0, false);
	DashOverrideSwitch.SetActiveChild(index, 0);	
}
/* 
Tick
	Every ~0.088s, this function is called.
*/
Simulated Event Tick(float DeltaTime)
{
	// local UTPlayerController PC;
	Super.Tick(DeltaTime);
	GG.runsPerTick(deltatime);
	LeftRightClicksAndChambersManagement(DeltaTime);
	//for fps issues and keeping things properly up to date
	//specially for skeletal controllers

	GG.deltaTimeBoostMultiplier = deltatime * 40;
	
	//the value of 40 was acquired through my own hard work and testing,
	//this deltaTimeBoostMultiplier system is my own idea :) - grapple

	//=== TETHER ====
	if (ePC.isTethering) 
		{
			GG.tetherVelocity = velocity;
			GG.tetherCalcs();		//run calcs every tick tether is active
		}

	if(GG.tetherStatusForVel)
		{
			if(Physics == PHYS_Falling)
				velocity = GG.tetherVelocity;
			if(Physics == PHYS_Walking)
				GG.tetherStatusForVel = false;
		}
		if(Dodge.bDodging)
			Dodge.Count(DeltaTime);

if(VelocityPinch.bApplyVelocityPinch)
	VelocityPinch.ApplyVelocityPinch(DeltaTime);
if(bAttackQueueing)
{
	// DebugPrint("chambe active");
		AttackSlot[0].SetActorAnimEndNotification(true);
		AttackSlot[1].SetActorAnimEndNotification(true);
}

CheckIfEnableParry();

if(debugConeBool)
debugCone();
// Sword[1].findActors();
	// TODO: Move all this to a function
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Prevents Sprint Boost In Air, Remove This Section If Boost Is Required
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	// if(iLikeToSprint)
	// {
	// // 	if(Physics == PHYS_Falling)
	// // 	{
	// // 		if(tickToggle)
	// // 		{
	// // 			// GroundSpeed /= 2.0;
	// // 			GroundSpeed = originalSpeed;
	// // 			tickToggle = !tickToggle;	
	// // 		}
	// // //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // // Holding shift while in air will lower negative z velocity = Shitty glide
	// // //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // 	// 	if(velocity.z <= 0)
	// // 	// 	{
	// // 	// 		// gravity = WorldInfo.GetGravityZ();
	// // 	// 		// gravity*= 0.2;
	// // 	// 	// velocity.z -= (velocity.z * 0.6);
	// // 	// 	velocity.z = -350;
	// // 	// 	// DebugPrint("going south" $velocity.z);
	// // 	// }
	// // 	}
	// // 	else
	// // 	{
	// // 		if(!tickToggle)
	// // 		{
	// // 			originalSpeed = GroundSpeed;
	// // 			GroundSpeed *= 2.0;
	// // 			tickToggle = !tickToggle;	
	// // 		}
	// // 	}

	// 	if(Physics == PHYS_Falling)
	// 	{
	// 		if(tickToggle)
	// 		{
	// 			GroundSpeed *= 0.3;
	// 			// GroundSpeed = originalSpeed;
	// 			tickToggle = !tickToggle;	
	// 		}
	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// // Holding shift while in air will lower negative z velocity = Shitty glide
	// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// 	// 	if(velocity.z <= 0)
	// 	// 	{
	// 	// 		// gravity = WorldInfo.GetGravityZ();
	// 	// 		// gravity*= 0.2;
	// 	// 	// velocity.z -= (velocity.z * 0.6);
	// 	// 	velocity.z = -350;
	// 	// 	// DebugPrint("going south" $velocity.z);
	// 	// }
	// 	}
	// 	else
	// 	{
	// 		if(!tickToggle)
	// 		{
	// 			// originalSpeed = GroundSpeed;
	// 			GroundSpeed = originalSpeed;
	// 			tickToggle = !tickToggle;	
	// 		}
	// 	}
	// }

	// Probably not required
	// bReadyToDoubleJump = true;
 
	// if(jumpActive)
		JumpVelocityPinch(DeltaTime);


	// Probably can be removed
	// if(Physics == PHYS_Walking && jumpActive)
	// {
	// 	jumpActive = false;
	// 	jumpEffects.DeactivateSystem();
	// }

	animationControl();

} 
function CheckIfEnableParry()
{
	if(Sword[currentStance-1].aParry.EnableParryWhenStationary)
	{
	if(VSize(velocity) <= 20)
		ParryEnabled = true;
		else
		ParryEnabled = false;
	}
}
/*
HitBlue
	Shakes camera with slight blue tint
*/
simulated function HitBlue()
{
	Local CameraAnim ShakeDatBooty;
	local float shakeAmount;

  	ShakeDatBooty=CameraAnim'EmberCameraFX.BlueShake';
  	switch(currentStance)
  	{
  		case 1: shakeAmount = aFramework.lightCameraShake;
  		break;
  		case 2: shakeAmount = aFramework.mediumCameraShake;
  		break;
  		case 3: shakeAmount = aFramework.heavyCameraShake;
  		break;
  	}
  	ePC.ClientPlayCameraAnim(ShakeDatBooty, shakeAmount);
}
/*
HitRed
	Shakes camera with slight blue tint
*/
simulated function HitRed()
{
	Local CameraAnim ShakeDatBooty;
	local float shakeAmount;

  	ShakeDatBooty=CameraAnim'EmberCameraFX.RedShake';
  	switch(currentStance)
  	{
  		case 1: shakeAmount = aFramework.lightCameraShake;
  		break;
  		case 2: shakeAmount = aFramework.mediumCameraShake;
  		break;
  		case 3: shakeAmount = aFramework.heavyCameraShake;
  		break;
  	}
  	ePC.ClientPlayCameraAnim(ShakeDatBooty, shakeAmount);
}
/*
HitGreen
	Shakes camera with slight green tint
*/
simulated function HitGreen()
{
	Local CameraAnim ShakeDatBooty;
	local float shakeAmount;

  	ShakeDatBooty=CameraAnim'EmberCameraFX.GreenShake';
  	switch(currentStance)
  	{
  		case 1: shakeAmount = aFramework.lightCameraShake;
  		break;
  		case 2: shakeAmount = aFramework.mediumCameraShake;
  		break;
  		case 3: shakeAmount = aFramework.heavyCameraShake;
  		break;
  	}
  	ePC.ClientPlayCameraAnim(ShakeDatBooty, shakeAmount);
  }
/*
PostInitAnimTree
	Allows custom animations.
*/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// local SkeletalMeshComponent flam;
	// flam = SkeletalMeshComponent'ArtAnimation.Meshes.ember_weapon_heavy';
    //Setting up a reference to our animtree to play custom stuff.
    super.PostInitAnimTree(SkelComp);
    if ( SkelComp == ModularPawn_Cosmetics.ParentModularItem)
    {
        AnimSlot = AnimNodeSlot(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('TopHalfSlot'));
  		IdleAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('IdleAnimNodeBlendList'));
  		RunAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('RunAnimNodeBlendList'));
  		LeftStrafeAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('LeftStrafeAnimNodeBlendList'));
  		RightStrafeAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('RightStrafeAnimNodeBlendList'));  		
		WalkAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('WalkAnimNodeBlendList'));  		
		wLeftStrafeAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('wLeftStrafeAnimNodeBlendList'));  		
		wRightStrafeAnimNodeBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('wRightStrafeAnimNodeBlendList'));  
		FullBodyBlendList = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('FullBodyBlendList'));  		
		JumpAttackSwitch = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('JumpAttackSwitch'));  
		DashOverrideSwitch  = AnimNodeBlendList(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('DashOverrideSwitch'));  
  		EmberDash = AnimNodePlayCustomAnim(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('EmberDash'));
  		AttackSlot[0] = AnimNodeSlot(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('AttackSlot'));
  		AttackSlot[1] = AnimNodeSlot(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('AttackSlot2'));
  		// AttackSlot2 = AnimNodeSlot(HeadSkeletalMesh.FindAnimNode('AttackSlot2'));
  		AttackBlend = AnimNodeBlend(ModularPawn_Cosmetics.ParentModularItem.FindAnimNode('AttackBlend'));
  		SpineRotator = UDKSkelControl_Rotate( ModularPawn_Cosmetics.ParentModularItem.FindSkelControl('SpineRotator') );
  		SpineRotator.BoneRotationSpace=BCS_BoneSpace;
  		// AimNode = AnimNodeAimOffset(SkelComp.FindAnimNode('AimNode'));

  		// AttackGateNode = AnimNodeBlendList(Mesh.FindAnimNode('AttackGateNode'));
		// AttackBlendNode = AnimNodeBlendList(Mesh.FindAnimNode('AttackBlendNode'));
  		JumpAttackSwitch.SetActiveChild(1, 0.3);
    }
}

//=============================================
// Overrided Functions 
//=============================================
/* 
BecomeViewTarget
	Required for modified Third Person
*/
simulated event BecomeViewTarget( PlayerController PC )
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
      UTPC = UTPlayerController(PC);
      if (UTPC != None)
      {
         //set player controller to behind view and make mesh visible
         UTPC.SetBehindView(true);
         SetMeshVisibility(UTPC.bBehindView);
      }
   }
}

/*
CalcCamera
	Required for modified Third Person
 */

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;

   CamStart = Location;
   CurrentCamOffset = CamOffset;



   //Change multipliers here
   DesiredCameraZOffset = (Health > 0) ? 1 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
   CameraZOffset = (fDeltaTime < 0.2) ? DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset : DesiredCameraZOffset;
   
   // if ( Health <= 0 )
   // {
   //    CurrentCamOffset = vect(0,0,0);
   //    CurrentCamOffset.X = GetCollisionRadius();
   // }
//native static final function float FInterpTo (float Current, float Target, float DeltaTime, float InterpSpeed)
if(EmberGameInfo(WorldInfo.Game).pawnsActiveOnPlayer == 0)
{
   cameraCamZOffsetInterpolation = Lerp(cameraCamZOffsetInterpolation, 30, 2*fDeltaTime);
   cameraCamXOffsetMultiplierInterpolation = Lerp(cameraCamXOffsetMultiplierInterpolation, 3.7, 2*fDeltaTime);
}
else
{
cameraCamZOffsetInterpolation = Lerp(cameraCamZOffsetInterpolation, 0, 2*fDeltaTime);
   cameraCamXOffsetMultiplierInterpolation = Lerp(cameraCamXOffsetMultiplierInterpolation, 3.1, 2*fDeltaTime);
}
   CamStart.Z += CameraZOffset + cameraCamZOffsetInterpolation;
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
   //Change multipliers here
   CamDirX *= CurrentCameraScale * 2.2;

   if ( (Health <= 0) || bFeigningDeath )
   {
      // adjust camera position to make sure it's not clipping into world
      // @todo fixmesteve.  Note that you can still get clipping if FindSpot fails (happens rarely)
      FindSpot(GetCollisionExtent(),CamStart);
   }
   if (CurrentCameraScale < CameraScale)
   {
      CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + 10 * FMax(CameraScale - CurrentCameraScale, 0.5)*fDeltaTime);
   }
   else if (CurrentCameraScale > CameraScale)
   {
      CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - 10 * FMax(CameraScale - CurrentCameraScale, 0.9)*fDeltaTime);
   }
   if (CamDirX.Z > GetCollisionHeight())
   {
      CamDirX *= square(cos(out_CamRot.Pitch * 0.0000958738)); // 0.0000958738 = 2*PI/65536
   }
   //Change multipliers here
   out_CamLoc = CamStart - (CamDirX*CurrentCamOffset.X*cameraCamXOffsetMultiplierInterpolation) + CurrentCamOffset.Y*CamDirY*0.1 + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }
      cameraOutLoc = out_CamLoc;

   return true;
}   
// function getScreenWH(float nwidth, float nheight)
// {
// 	width = nwidth;
// 	height = nheight;
// }
/*
DoDoubleJump
	Jetpack main function
*/
// function DoDoubleJump( bool bUpdating )
// {
// 	// if ( !bIsCrouched && !bWantsToCrouch )
// 	// {
// 		if(jumpActive)
// 		{
// 			spaceMarineLanding();
// 			return;
// 		}
// 		if(!bUpdating)
// 		{
// 			// disableJetPack();
// 			disableJumpEffect(true);
// 			return;
// 		}
// 		if(verticalJumpActive)
// 			return;
// 		if ( !IsLocallyControlled() || AIController(Controller) != None )
// 		{
// 			MultiJumpRemaining -= 1;
// 		}
// 		Velocity.Z = JumpZ + (MultiJumpBoost);
// 		verticalJumpActive = true;
// 		UTInventoryManager(InvManager).OwnerEvent('MultiJump');
// 		SetPhysics(PHYS_Falling);
// 		BaseEyeHeight = DoubleJumpEyeHeight;
// 		if (!bUpdating)
// 		{
// 			SoundGroupClass.Static.PlayDoubleJumpSound(self);
// 		}

// 	if(!jumpActive)
// 	{

// 	Mesh.GetSocketWorldLocationAndRotation('BackPack', jumpLocation, jumpRotation);
// 	// jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail', jumpLocation, jumpRotation, self); 
// 	// 	Mesh.AttachComponentToSocket(jumpEffects, 'BackPack');

// 	jumpEffects = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment (ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketTrail', Mesh, 'BackPack', true,  , jumpRotation);
// 	SetTimer(0.05, true, 'disableJumpEffect');
// 	// SetTimer(0.1, true, 'extendJump');
// 	}
// 	// }
// }
//=============================================
// Debug Functions
//=============================================

/*
RecordTracers - Debug Function
	Plays an animation showing tracers.
	Can change duration that tracers start and end
	@TODO: Tracers end record
	@TODO: Auto save to a script file perhaps?
*/
exec function RecordTracers(name animation, float duration, float t1, float t2)
{
	ePC.RecordTracers(animation, duration, duration*t1, duration*t2);
}

/*
tethermod - Debug Function
	Used to modify grapple at runtime
	Usage:
		'tethermod 0 0 0'
			Outputs current tether values
		'tethermod X 0 0'
			Changes goingTowardsHighVelModifier modifier
		'tethermod 0 X 0'
			Changes goingTowardsLowVelModifier modifier
		'tethermod 0 0 X'
			Changes goingAwayVelModifier modifier
	Can change multiple modifiers at the same time
*/
exec function tethermod(float a = 0, float b = 0, float c = 0, float D = 0)
{
	if(a == 0 && b == 0 && c == 0 && d == 0)
	{
		DebugPrint ("goingTowardsHigh -"@GG.goingTowardsHighVelModifier);
		DebugPrint("goingTowardsLow -"@GG.goingTowardsLowVelModifier);
		DebugPrint("goingAway -"@GG.goingAwayVelModifier);
		DebugPrint("tetherlength -"@GG.tetherlength);
		return;
	}
	GG.goingTowardsHighVelModifier = (a != 0) ? a : GG.goingTowardsHighVelModifier;
	GG.goingTowardsLowVelModifier = (b != 0) ? b : GG.goingTowardsLowVelModifier;
	GG.goingAwayVelModifier = (c != 0) ? c : GG.goingAwayVelModifier;
	GG.tetherlength = (d != 0) ? d : GG.tetherlength;
}

	// b != 0 ? goingTowardsLowVelModifier = b : ;
	// c != 0 ? goingAwayVelModifier = c : ;
//=============================================
// Custom Functions
//=============================================

simulated function doAttackQueue()
{
	local byte currentStringCounter;
	// EmberDash.PlayCustomAnim('ember_jerkoff_block',1.0, 0.3, 0, true);
	// Sword[currentStance-1].GoToState('Blocking');
// bAttackQueueing = true;
	iChamberingCounter = 0;
	aFramework.CurrentAttackString++;
	if(aFramework.CurrentAttackString > aFramework.MaxAttacksThatCanBeStringed)
		return;

	currentStringCounter = aFramework.CurrentAttackString;

	ClearTimer('AttackEnd');
	AttackEnd();
	aFramework.CurrentAttackString = currentStringCounter;
	ChamberFlags.resetLeftChamberFlags();
	ChamberFlags.setLeftChamberFlag(0);
	ChamberFlags.setLeftChamberFlag(2);
// if(GetTimeLeftOnAttack() == 0)
// {
	doAttack(ePC.verticalShift);
// }

}
simulated function stopAttackQueue()
{
	// EmberDash.PlayCustomAnimByDuration('ember_jerkoff_block',0.1, 0.1, 0.3, false);
    // Sword[currentStance-1].SetInitialState();
    // swordBlockIsActive = false;//temp_fix_for_animation
	// Sword.rotate(0,0,16384); //temp_fix_for_animation
DebugPrint("stopAttackQueue");
bAttackQueueing = false;
	ChamberFlags.removeLeftChamberFlag(0);

		AttackSlot[0].SetActorAnimEndNotification(false);
		AttackSlot[1].SetActorAnimEndNotification(false);
if(ChamberFlags.CheckLeftFlag(1))
{
DebugPrint("LChamber End");
			iChamberingCounter = 0;
			Sword[currentStance-1].GoToState('Attacking');
            Sword[currentStance-1].setTracerDelay(0,(AttackPacket.Mods[2] - AttackPacket.Mods[6]));
			SetTimer((AttackPacket.Mods[0] - AttackPacket.Mods[6]), false, 'AttackEnd');	
			VelocityPinch.ApplyVelocityPinch(,0,(AttackPacket.Mods[2] - AttackPacket.Mods[6])  * 1.1);
			AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=true;
			AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=true;
}
	// EmberDash.PlayCustomAnim('ember_jerkoff_block',-1.0, 0.3, 0, false);
}
simulated function doChamber()
{
	bRightChambering = true;
	iChamberingCounter = 0;
	ChamberFlags.resetRightChamberFlags();
	ChamberFlags.setRightChamberFlag(0);
	ClearTimer('AttackEnd');
	AttackEnd();
	// if(GetTimeLeftOnAttack() < 0.5)
	// {
	doAttack(ePC.verticalShift);
	// }
}
simulated function stopChamber()

{
	ChamberFlags.removeRightChamberFlag(0);
	// if(iChamberingCounter >= AttackPacket.Mods[6])
	if(ChamberFlags.CheckRightFlag(1))
	{
			Sword[currentStance-1].GoToState('Attacking');
            Sword[currentStance-1].setTracerDelay(0,AttackPacket.Mods[2] - AttackPacket.Mods[6]);
			SetTimer(AttackPacket.Mods[0] - AttackPacket.Mods[6], false, 'AttackEnd');	
			VelocityPinch.ApplyVelocityPinch(,0,(AttackPacket.Mods[2] - AttackPacket.Mods[6])  * 1.1);
	AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=true;
	AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=true;
		AttackSlot[0].SetActorAnimEndNotification(false);
		AttackSlot[1].SetActorAnimEndNotification(false);
	}
}

simulated function LeftRightClicksAndChambersManagement(float DeltaTime)
{
	
if(ChamberFlags.CheckLeftFlag(0))
{
	iChamberingCounter += DeltaTime;
	if(iChamberingCounter >= AttackPacket.Mods[6])
		{
			if(!ChamberFlags.CheckLeftFlag(1))
			{
			ChamberFlags.setLeftChamberFlag(1);
			ClearTimer('AttackEnd');
            Sword[currentStance-1].setTracerDelay(0,0);
			Sword[currentStance-1].SetInitialState();
			VelocityPinch.ApplyVelocityPinch(,0,0);
			AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=false;
			AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=false;
			}
		}
}

if(ChamberFlags.CheckRightFlag(0))
{
	iChamberingCounter += DeltaTime;
	if(iChamberingCounter >= AttackPacket.Mods[6])
		{
		ChamberFlags.setRightChamberFlag(1);
			 
	AttackSlot[0].GetCustomAnimNodeSeq().bPlaying=false;
	AttackSlot[1].GetCustomAnimNodeSeq().bPlaying=false;
		}
}
else if(!ChamberFlags.CheckRightFlag(0) && iChamberingCounter > 0 && !ChamberFlags.CheckLeftFlag(2))
{

	iChamberingCounter += DeltaTime;
	//If rightclick was released before windup... procede to windup time and then blend to idle
	if(iChamberingCounter >= AttackPacket.Mods[6] && !ChamberFlags.CheckRightFlag(1))
		{
			DebugPrint("Chamber End");
			iChamberingCounter = 0;
			AttackEnd();
			AttackSlot[0].StopCustomAnim(0.4);
			AttackSlot[1].StopCustomAnim(0.4);
		}
}
}

/*
GetTimeLeftOnAttack
	Returns time left on attack timer
*/
simulated function float GetTimeLeftOnAttack()
{
	 return (GetTimerRate('AttackEnd') - GetTimerCount('AttackEnd'));
}
/*
doAttack
	Detects if player is moving left or right from playercontroler (PlayerInput)
	Determines which attack to use.
	Queues Attacks
*/
// function doAttack( float strafeDirection)
// {
// 	local float timerCounter;
// 	local float queueCounter;
// // 	local vector jumpLocation;
// // 	local rotator jumpRotation;

// // 	Mesh.GetSocketWorldLocationAndRotation('BackPack', jumpLocation, jumpRotation);

// // 	DebugPrint("l - "@Rotation - jumpRotation);
// // 	DebugPrint("l - "@jumpRotation - Rotation);
// // return;
// 	queueCounter = 0.25;

// 	timerCounter = GetTimeLeftOnAttack();
// 	DebugPrint("attack Requested");
// 	if(timerCounter > queueCounter)
// 	{
// 	DebugPrint("attack Denied");
// 	return;
// 	}
// 	if(timerCounter < queueCounter && timerCounter > 0)
// 	{
// 	DebugPrint("attack Queued");
// 	animationQueueAndDirection = (strafeDirection == 0) ? 1337.0 : strafeDirection;
// 	// animationQueueAndDirection = strafeDirection;
// 	return;
// 	}
// 	if(strafeDirection > 0)
// 		rightAttack();
// 	else if(strafeDirection < 0)
// 		leftAttack();
// 	else
// 		forwardAttack();
// }

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
			DebugPrint("OnAnimEnd");
			// VelocityPinch.ApplyVelocityPinch(,,true);
   			ClearTimer('AttackEnd');
            Sword[currentStance-1].resetTracers();
			// if(ChamberFlags.CheckLeftFlag(0))
			// {
			// 	PC = UTPlayerController(Instigator.Controller);
			// 	doAttack(EmberPlayerController(PC).verticalShift);
			// 	return;
			// }
			if(aFramework.CurrentAttackString <= 2)
			EmberGameInfo(WorldInfo.Game).AttackPacket.isActive = true;
            AttackBlend.setBlendTarget(1, 0.5);
            Sword[currentStance-1].setKnockback(AttackPacket.Mods[5]); 
			if(!ChamberFlags.CheckRightFlag(0))
            Sword[currentStance-1].setTracerDelay(AttackPacket.Mods[1],AttackPacket.Mods[2]);
			SetTimer(AttackPacket.Mods[0], false, 'AttackEnd');	
            AttackSlot[1].PlayCustomAnimByDuration(AttackPacket.AnimName, AttackPacket.Mods[0], AttackPacket.Mods[3], AttackPacket.Mods[4]);
            VelocityPinch.ApplyVelocityPinch(,AttackPacket.Mods[1],AttackPacket.Mods[2] * 1.1);
}
simulated function forcedAnimEnd()
{
	DebugPrint("forcedAnimEnd");
		ClearTimer('AttackEnd');
			AttackBlend.setBlendTarget(0, 0.2);    
			if(aFramework.CurrentAttackString <= 2)
			EmberGameInfo(WorldInfo.Game).AttackPacket.isActive = true;

			if(!ChamberFlags.CheckRightFlag(0))
			{
			Sword[currentStance-1].GoToState('Attacking');
            Sword[currentStance-1].setTracerDelay(AttackPacket.Mods[1],AttackPacket.Mods[2]);
			SetTimer(AttackPacket.Mods[0], false, 'AttackEnd');	
			if(aFramework.TestLockAnim[0] == AttackPacket.AnimName)
			SetTimer(AttackPacket.Mods[1], false, 'AttackLock');	
			VelocityPinch.ApplyVelocityPinch(,AttackPacket.Mods[1],AttackPacket.Mods[2] * 1.1);
			}
            Sword[currentStance-1].setKnockback(AttackPacket.Mods[5]);
            AttackSlot[0].PlayCustomAnimByDuration(AttackPacket.AnimName, AttackPacket.Mods[0], AttackPacket.Mods[3], AttackPacket.Mods[4]);
}
simulated function  forcedAnimEndByParry()
{
	local int i;

	DebugPrint("ember Pawn forced anim end by parry");

    ClearTimer('attackStop');
    AttackBlend.setBlendTarget(1, 0); 
	SetTimer(0.5, false, 'attackStop');

	i = Rand(Sword[currentStance-1].aParry.ParryNames.length);

	AttackSlot[1].PlayCustomAnimByDuration(Sword[currentStance-1].aParry.ParryNames[i],Sword[currentStance-1].aParry.ParryMods[i], 0, 0, false);
}

simulated function doAttack( array<byte> byteDirection)
{

	local float timerCounter;
	local float queueCounter;
	local int totalKeyFlag;
	if(enableInaAudio == 1)
	PlaySound(huahs[0]);
	// PlaySound(Sword[currentStance-1].SwordSounds[0]);
	totalKeyFlag = 0;
	savedByteDirection[0] = byteDirection[0];
	savedByteDirection[1] = byteDirection[1];
	savedByteDirection[2] = byteDirection[2];
	savedByteDirection[3] = byteDirection[3];

	
	if((savedByteDirection[0] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[1] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[2] ^ 1) == 0 ) totalKeyFlag++;
	if((savedByteDirection[3] ^ 1) == 0 ) totalKeyFlag++;
	// queueCounter = 0.55;
	// queueCounter = 5.55;

	FlushPersistentDebugLines();
	timerCounter = GetTimeLeftOnAttack();
	DebugPrint("attack Requested"@GetTimeLeftOnAttack());
	// if(timerCounter > queueCounter)
		// {
		// DebugPrint("attack Denied");
		// return;
		// }
		// ClearTimer('AttackEnd');
		if(timerCounter > 0.5)
		{
			DebugPrint("b Queue");
		
		AttackSlot[0].SetActorAnimEndNotification(true);
		AttackSlot[1].SetActorAnimEndNotification(true);
		}

	// blendAttackCounter = (blendAttackCounter > 1) ? 0 : blendAttackCounter;
	// DebugPrint("blendAttackCounter"@blendAttackCounter);

// 	if(tempBalanceString != 1)
// {
// 	if(timerCounter < queueCounter && timerCounter > 0)
// 		{
// 		DebugPrint("attack Queued");
// 		savedByteDirection[4] = 1;
// 		return;
// 		}
// }
// else if (tempBalanceString == 1)
// {
// 	tempBalanceString = 0;
// }
//If you jump, it'll still do attack as if you were on ground
JumpAttackSwitch.SetActiveChild(0, 0.3);

		switch(totalKeyFlag)
		{
			//no keys pressed
			case 0:
				forwardAttack();
			break;

			//one key pressed 
			case 1:
				if((savedByteDirection[0] ^ 1) == 0 ) forwardAttack(); //W
				if((savedByteDirection[1] ^ 1) == 0 ) leftAttack(); //A
				if((savedByteDirection[2] ^ 1) == 0 ) backAttack(); //S
				if((savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //D
			break;

			//two keys pressed 
			case 2:
				if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) forwardLeftAttack(); //W+A
				else if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) forwardRightAttack(); //W+D
				else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) backLeftAttack(); //S+A
				else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) backRightAttack(); //S+D

				// if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) leftAttack(); //W+A
				// else if((savedByteDirection[0] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //W+D
				// else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[1] ^ 1) == 0 ) leftAttack(); //S+A
				// else if((savedByteDirection[2] ^ 1) == 0 && (savedByteDirection[3] ^ 1) == 0 ) rightAttack(); //S+D

				//for keys W + S and A + D
				else forwardAttack();

			break;

			//3-4 keys pressed
			case 3:
			case 4:
				forwardAttack();
			break;
		}

}
exec function setTracers(int tracers)
{
	Sword[currentStance-1].setTracers(tracers);
}

// function rightAttackEnd()
// {
// 	DebugPrint("dun -");
// 	//forwardEmberDash.StopCustomAnim(0);
//     Sword.SetInitialState();
//     Sword.resetTracers();
//     animationControl();
// }
simulated function copyToAttackStruct(name animName, array<float> mods)
{
	local int i;
	AttackPacket.AnimName = animName;
	EmberGameInfo(WorldInfo.Game).AttackPacket.AnimName = animName;
	for(i = 0; i < mods.length; i++)
	{
		AttackPacket.Mods[i] = mods[i];
		EmberGameInfo(WorldInfo.Game).AttackPacket.Mods[i] = mods[i];
	}
}

simulated function EndPreAttack()
{
	if(GetTimeLeftOnAttack() <= 0.5)
		forcedAnimEnd();
}

/*
forwardAttack
	Flushes existing debug lines
	Starts playing forward attack animation
	Sets timer for end attack animation
	Sets tracer delay
*/
simulated function forwardAttack()
{
	DebugPrint("fwd -");

	switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightForwardString1,aFramework.lightForwardString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumForwardString1, aFramework.mediumForwardString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavyForwardString1, aFramework.heavyForwardString1Mods);
		break;
	}
	EndPreAttack();
}
simulated function BackAttack()
{
	DebugPrint("fwd -");

	switch(currentStance) 
	{
		case 1:
			copyToAttackStruct(aFramework.lightBackString1, aFramework.lightBackString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumBackString1, aFramework.mediumBackString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavyBackString1, aFramework.heavyBackString1Mods);
		break;
	}
	EndPreAttack();
}
simulated function backLeftAttack()
{
		switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightbackLeftString1, aFramework.lightbackLeftString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumbackLeftString1, aFramework.mediumbackLeftString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavybackLeftString1, aFramework.heavybackLeftString1Mods);
		break;
	}
	EndPreAttack();
}

simulated function backRightAttack()
{
		switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightBackRightString1, aFramework.lightbackRightString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumbackRightString1, aFramework.mediumbackRightString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavybackRightString1, aFramework.heavybackRightString1Mods);
		break;
	}
	EndPreAttack();
}
simulated function forwardLeftAttack()
{
		switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightForwardLeftString1, aFramework.lightForwardLeftString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumForwardLeftString1, aFramework.mediumForwardLeftString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavyForwardLeftString1, aFramework.heavyForwardLeftString1Mods);
		break;
	}
	EndPreAttack();
}

simulated function forwardRightAttack()
{
		switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightForwardRightString1, aFramework.lightForwardRightString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumForwardRightString1, aFramework.mediumForwardRightString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavyForwardRightString1, aFramework.heavyForwardRightString1Mods);
		break;
	}
	EndPreAttack();
}
/*
rightAttack
	Flushes existing debug lines
	Starts playing rightAttack attack animation
	Sets timer for end attack animation
	Sets tracer delay
	@TODO: Detect if timer is active, if so do not do another attack
*/
simulated function rightAttack()
{
	switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightRightString1, aFramework.lightRightString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumRightString1, aFramework.mediumRightString1Mods);
		break;

		case 3:
			copyToAttackStruct(aFramework.heavyRightString1, aFramework.heavyRightString1Mods);
		break;
	}
	EndPreAttack();
}
/*
leftAttack
	Flushes existing debug lines
	Starts playing left attack animation
	Sets timer for end attack animation
	Sets tracer delay
	@TODO: Detect if timer is active, if so do not do another attack
*/
simulated function leftAttack()
{
//ember_temp_left_attack
	// FlushPersistentDebugLines();
	DebugPrint("left -");

	switch(currentStance)
	{
		case 1:
			copyToAttackStruct(aFramework.lightLeftString1, aFramework.lightLeftString1Mods);
		break;

		case 2:
			copyToAttackStruct(aFramework.mediumLeftString1, aFramework.mediumLeftString1Mods);
		break;

		case 3:
		// Sword.Attack2.PlayCustomAnimByDuration('ember_flammard_tracer', 2, 0.3, 0, true);
			copyToAttackStruct(aFramework.heavyLeftString1, aFramework.heavyLeftString1Mods);
		break;
	}	
	EndPreAttack();
}
simulated function AttackLock()
{
	disableMoveInput(true);
	// disableLookInput(true);
}
/*
AttackEnd
	Resets sword, tracers, and idle stance at end of forward attack
	@TODO: Make perhaps only one attack end animation funcion
*/
simulated function AttackEnd()
{
	DebugPrint("dun -");
EmberGameInfo(WorldInfo.Game).AttackPacket.isActive = false;
	// VelocityPinch.ApplyVelocityPinch(,,true);
//when you jump, now shows jump anim

	ChamberFlags.removeLeftChamberFlag(2);
	JumpAttackSwitch.SetActiveChild(1, 0.3);
	//forwardEmberDash.StopCustomAnim(0);
	// Sword.rotate(0,0,49152);
    Sword[currentStance-1].SetInitialState();
    Sword[currentStance-1].resetTracers();
	disableMoveInput(false);
	// disableLookInput(false);

    // Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
    // Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');

    animationControl();
    aFramework.CurrentAttackString = 0;

    if(savedByteDirection[4] == 1)
    {
    	savedByteDirection[4] = 0;
    	doAttack(savedByteDirection);
    }

	// forwardEmberDash.SetActiveChild(0);
}
/*
SwordGotHit
	Temporary animation for 'parries'
*/
simulated function SwordGotHit()
{
	forcedAnimEndByParry();
}
/*
animationControl
	When player is idle, pick only one of the random idle animations w/ 0.25 blend
*/
simulated function animationControl()
{
	if(Vsize(Velocity) == 0) 
	{ 
		//Idle
		if(idleBool == false)
		{
		idleBool = true;
		runBool = false;
		 if (IdleAnimNodeBlendList.BlendTimeToGo <= 0.f)
  			{
  				//Pick a random idle animation
    			// IdleAnimNodeBlendList.SetActiveChild(Rand(IdleAnimNodeBlendList.Children.Length), 0.25f);
				IdleAnimNodeBlendList.SetActiveChild(currentStance-1, idleBlendTime);
    			//Set sword orientation temp_fix_for_animation
				// Sword.rotate(0,0,16384);
    			// Sword.Rotation() Rotation=(Pitch=000 ,Yaw=0, Roll=16384 )
  			}
  			FullBodyBlendList.SetActiveChild(1,idleBlendTime);//Use Full Body Blending
  		}
	}
	else
	{
		if( runBool == false)
		{ 
		idleBool = false;
		runBool = true;
		 if (RunAnimNodeBlendList.BlendTimeToGo <= 0.f)
  			{ 
  				//Pick a random idle animation
    			// IdleAnimNodeBlendList.SetActiveChild(Rand(IdleAnimNodeBlendList.Children.Length), 0.25f);
				RunAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				WalkAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				wRightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
				wLeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
    			//Set sword orientation temp_fix_for_animation
				// Sword.rotate(0,0,16384);
    			// Sword.Rotation() Rotation=(Pitch=000 ,Yaw=0, Roll=16384 )
  			}
  			FullBodyBlendList.SetActiveChild(0,idleBlendTime);//Split body blending at spine
  		}
    	//Set sword orientation, temp_fix_for_animation
		// Sword.rotate(0,0,49152);

	}

	// if(swordBlockIsActive)//temp_fix_for_animation
		// Sword.rotate(0,0,49152);
}
/*
tetherBeamProjectile
	Launches a projectile specified by EmberProjectile.uc
	Upon hitting a target, executes tetherLocationHit
*/  
simulated function tetherBeamProjectile()
{
	local projectile P;
	local vector newLoc;
	local rotator rotat;
	// newLoc = Location;
	//@TODO: if EmberProjectile already exists when launch, delete previous instance and initiate new
	ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('GrappleSocket', newLoc, rotat);
	P = Spawn(class'EmberProjectile',self,,newLoc);
	newLoc = normal(Vector( ePC.Rotation)) * 50;
	EmberProjectile(p).setProjectileOwner(self);
	p.Init(newLoc);
}
/*
tetherLocationHit
	returns hit and location of tetherBeamProjectile
*/
simulated function tetherLocationHit(vector hit, vector lol, actor Other)
{
	GG.tetherLocationHit(hit, lol, Other);
	// projectileHitVector=hit;
	// projectileHitLocation=lol;
	// enemyPawn = Other;
	// enemyPawnToggle = (enemyPawn != none) ? true : false;
	// createTether();
}
simulated function debugCone()
{   local Vector HitLocation, HitNormal;
   local Vector Start, End, Block;
   local rotator bRotate;
   local traceHitInfo hitInfo;
   local Actor hitActor;
        // local float tVel;
        local float fDistance;
        local vector lVect;
        local int i;
          local float tCount;
	// local vector v1, v2, swordLoc;
	// local rotator swordRot;
	// Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('EndControl', swordLoc, swordRot);
	// v1 = normal(vector(swordRot)) << rot(0,-8192,0);
	// v2 = normal(vector(swordRot)) << rot(0,8192,0);
	// DrawDebugLine(swordLoc, (v1 * 50)+swordLoc, 0, 0, -1, true);
	// DrawDebugLine(swordLoc, (v2 * 50)+swordLoc, -1, 0, -1, true);
	Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('EndControl', End);
	Sword[currentStance-1].Mesh.GetSocketWorldLocationAndRotation('StartControl', Start);
	    hitActor = Trace(HitLocation, HitNormal,Start, End, true, , hitInfo); 
        DrawDebugLine( Start, End, -1,125,-1, true);
        DebugPrint("bHits -"@hitInfo.Material);
        DebugPrint("bHits -"@hitInfo.PhysMaterial );
        DebugPrint("bHits -"@hitInfo.Item);
        DebugPrint("bHits -"@hitInfo.LevelIndex );
        // if(hitInfo.BoneName == 'sword_blade')
        DebugPrint("bHits -"@hitInfo.BoneName );
        DebugPrint("bHits -"@hitInfo.HitComponent );
        DebugPrint("bHits -"@hitActor);
        DebugPrint("----");
}
/*
increaseTether
*/
function increaseTether() 
{
	// if (tetherlength > tetherMaxLength) return;
	// tetherlength += 70;
}
/*
decreaseTether
*/
function decreaseTether() 
{
	// if (tetherlength <= 300) {
	// 	tetherlength = 300;
	// 	return;
	// }
	// tetherlength -= 70;
}
/*
detachTether
*/
simulated function detachTether() 
{
	GG.detachTether();
	// curTargetWall = none;

	// enemyPawn = enemyPawnToggle ? enemyPawn : none;

	// //beam
	// if(tetherBeam != none){
	// 	tetherBeam.SetHidden(true);
	// 	tetherBeam.DeactivateSystem();
	// 	tetherBeam = none;
	// }
	// 	if(tetherBeam2 != none){
	// 	tetherBeam2.SetHidden(true);
	// 	tetherBeam2.DeactivateSystem();
	// 	tetherBeam2 = none;
	// }
	
	// // SetPhysics(PHYS_Walking);
 //        //state
	//  EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering = false;

	// //make sure to restore normal pawn animation playing
	// //see last section of tutorial
	//TetheringAnimOnly = false;
}

/*
createTether
	How it works:
		Starts trace a little infront of character, to target point
		If the target point is an actor, cancel function //TODO: player grappling
		else, clear old tethers and prepare for tethering
		Save wall actor and wall hit location
		Create tether length
		Create tether particle
		Set particle start and end points
*/
// function createTether() 
// {
// 	local vector hitLoc;
// 	local vector tVar;
// 	local vector hitNormal;
// 	local actor wall;
// 	local vector startTraceLoc;
// 	local vector endLoc;
// 	// local float floaty;
// 	local int isPawn;
// 	//~~~ Trace ~~~

// 	vc = normal(Vector( EmberGameInfo(WorldInfo.Game).playerControllerWORLD.Rotation)) * 50;
// 	//vc = Owner.Rotation;
	
// 	Mesh.GetSocketWorldLocationAndRotation('HeadShotGoreSocket', tVar, r);
// 	//pawn location + 100 in direction of player camera

// 	hitLoc = location;
// 	hitLoc.z += 10;
// 	startTraceLoc = tVar + vc ;
// 	// startTraceLoc = Location + vc ;
	 
// 	endLoc =startTraceLoc + tetherMaxLength * vc;
// 	// endLoc.z += 1500;

// 	//trace only to tether's max length
// 	wall = Self.trace(hitLoc, hitNormal, 
// 				endLoc, 
// 				startTraceLoc
// 			);
// 	// DrawDebugLine(endLoc, startTraceLoc, -1, 0, -1, true);


// 	// if(!Wall.isa('Actor')) return; //Change this later for grappling opponents
// 	// Wall.isa('Actor') ? DebugPrint("Actor : " $Wall) : ;
// 	// InStr(wall, "TestPawn") > 0? DebugPrint("gud") : ;
// 	isPawn = InStr(wall, "TestPawn");
// 	// DebugPrint("p = " $isPawn);
// 	// floaty = VSize(location - wall.location);
// 	// DebugPrint("distance -"@floaty);
// 	if(isPawn >= 0)
// 	{
// 		endLoc = normal(location - wall.location);
// 		TestPawn(wall).grappleHooked(endLoc, self);
// 		// endLoc *= 500;
// 		// wall.velocity = endLoc;
// 	}
// 	//~~~~~~~~~~~~~~~
// 	// Tether Success
// 	//~~~~~~~~~~~~~~~
// 	//Clear any old tether
// 	detachTether();
	

// 	enemyPawnToggle = enemyPawnToggle ? false : false;
// 	//state
// 	 EmberGameInfo(WorldInfo.Game).playerControllerWORLD.isTethering = true;
	
// 	curTargetWall = Wall;
// 	//wallHitLoc = hitLoc;
// 	wallhitloc = projectileHitVector;
	
// 	//get length of tether from starting
// 	//position of object and wall
// 	// tetherlength = vsize(hitLoc - Location) * 0.75;
// 	// if (tetherlength > 1000) 
// 		// tetherlength = 1000;

// 	tetherlength = vsize(hitLoc - Location) * 0.75;
// 	// if (tetherlength > 500) 
// 		// tetherlength = 500;
// 	//~~~
	
// 	//~~~ Beam UPK Asset Download ~~~ 
// 	//I provide you with the beam resource to use here:
// 	//requires Nov 2012 UDK
// 	//Rama Tether Beam Package [Download] For You
// 	tetherBeam = WorldInfo.MyEmitterPool.SpawnEmitter(

// 		//change name to match your imported version 
// 		//of my package download above
// 		//In UDK: select asset and right click “copy full path”
// 		//paste below
// 		ParticleSystem'RamaTetherBeam.tetherBeam2', //Visual System
// 		Location + vect(0, 0, 32) + vc * 48, 
// 		// Location,
// 		rotator(HitNormal));

// 	tetherBeam2 = WorldInfo.MyEmitterPool.SpawnEmitter(

// 		//change name to match your imported version 
// 		//of my package download above
// 		//In UDK: select asset and right click “copy full path”
// 		//paste below
// 		ParticleSystem'RamaTetherBeam.tetherBeam2', //Visual System
// 		Location + vect(0, 0, 32) + vc * 48, 
// 		// Location,
// 		rotator(HitNormal));

// 	tetherBeam.SetHidden(false);
// 	tetherBeam.ActivateSystem(true);
	
// 	//Beam Source Point
// 	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', tVar, r);
// 	tetherBeam.SetVectorParameter('TetherSource', tVar);
	
// 	//Beam End
// 	//tetherBeam.SetVectorParameter('TetherEnd', hitLoc);	
// 	if(enemyPawn != none)
// 	tetherBeam.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
// 	else
// 	tetherBeam.SetVectorParameter('TetherEnd', projectileHitLocation);	
	


// 	tetherBeam2.SetHidden(false);
// 	tetherBeam2.ActivateSystem(true);
	
// 	//Beam Source Point
// 	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket2', tVar, r);
// 	// tetherBeam2.SetVectorParameter('TetherSource', tVar);
// 	tetherBeam2.SetVectorParameter('TetherSource', tVar);
	
	
// 	//Beam End
// 	if(enemyPawn != none)
// 	tetherBeam2.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
// 	else
// 	tetherBeam2.SetVectorParameter('TetherEnd', projectileHitLocation);	
// }

/*
startSprint
	Saves original ground speed, and modifies it
	Also modifies current velocity to do instant transition
*/
// function startSprint()
// {
// 	iLikeToSprint = true;
// 	tickToggle = true;
// 	originalSpeed = GroundSpeed;
// 	//Sprint Speed
// 	//GroundSpeed *= 2.0;
// 	GroundSpeed *= 0.3;

// 	//Does instant transition to max sprint speed
// 	if(Physics != PHYS_Falling)
// 		// velocity *= 2.0;
// 		velocity *= 0.3;
// }

// /*
// endSprint
// */
// function endSprint()
// {
// 	iLikeToSprint = false;
// 	// GroundSpeed /= 2.0;
// 	GroundSpeed = originalSpeed;
// }

simulated function createTetherBeam(vector v1, rotator r1)
{
	local ParticleSystemComponent newBeam;
	newBeam = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'RamaTetherBeam.tetherBeam2', v1,r1);
	newBeam.SetHidden(false);
	newBeam.ActivateSystem(true);
	tetherBeam.AddItem(newBeam);
}
simulated function updateBeamEnd(vector projectileHitLocation, int index)
{
	tetherBeam[index].SetVectorParameter('TetherEnd', projectileHitLocation);
}
simulated function updateBeamSource(vector tVar, int index)
{
	tetherBeam[index].SetVectorParameter('TetherSource', tVar);
}
simulated function vector getBeamEnd(int index)
{
	local vector projectileHitLocation;
	tetherBeam[index].GetVectorParameter('TetherEnd', projectileHitLocation);
	return projectileHitLocation;
}
simulated function vector getBeamSource(int index)
{
	local vector tVar;
	tetherBeam[index].GetVectorParameter('TetherSource', tVar);
	return tVar;
}

simulated function array<ParticleSystemComponent> getTetherBeams()
{
	return tetherBeam;
}

simulated function deactivateAllTetherBeams()
{
	local int i;

	for(i=0; i < tetherBeam.length; i++)
	{
		if(tetherBeam[i] != none)
			{
				tetherBeam[i].SetHidden(true);
				tetherBeam[i].DeactivateSystem();
				tetherBeam[i] = none;
			}
	}
tetherBeam.length = 0;
}

simulated function deactivateTetherBeam(int index)
{
	if(index >= tetherBeam.length)
	return;

		if(tetherBeam[index] != none)
			{
				tetherBeam[index].SetHidden(true);
				tetherBeam[index].DeactivateSystem();
				tetherBeam[index] = none;
			}
			tetherBeam.remove(index,1);
}
 
simulated function GrappleRopeBlock createRopeBlock()
{
  	ropeBlockArray.AddItem(Spawn(class'GrappleRopeBlock', self));	
  	return ropeBlockArray[ropeBlockArray.length-1];
}

simulated function array<GrappleRopeBlock> getRopeBlocks()
{
	return RopeBlockArray;
}
simulated function deleteBlock(GrappleRopeBlock block)
{
	local GrappleRopeBlock g;
	g = RopeBlockArray[RopeBlockArray.Find(block)];
	RopeBlockArray.RemoveItem(block);
	g.Destroy();
	return;
}
// Destroy
//~~~~~~~~~~~~~~~~~~~~~~~~~~
//Rama's Tether System Calcs
//~~~~~~~~~~~~~~~~~~~~~~~~~~

//these calcs run every tick while tether is active
//so the code is optimized to reduce
//variable memory allocation and deallocation
//I use global vars vc and vc2 as variables to store different
//info I need for my tether algorithm

//the other vars are also global since they are assigned values
//in other tether functions
//and their values should NOT be recalculated every tick

simulated function tetherCalcs() {
	GG.tetherCalcs();
// 	local int idunnowhatimdoing;
// 	//~~~~~~~~~~~~~~~~~
// 	//Beam Source Point
// 	//~~~~~~~~~~~~~~~~~
// 	//get position of source point on skeletal mesh

// 	//set this to be any socket you want or create your own socket
// 	//using skeletal mesh editor in UDK

// 	//dual weapon point is left hand 
// 	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', vc, r);
	
//     	    	// DrawDebugLine(vc, curTargetWall.Location, -1, 0, -1, true);
// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	//adjust for Skeletal Mesh Socket Rendered/Actual Location tick delay

// 	//there is a tick delay between the actual socket position
// 	//and the rendered socket position
// 	//I encountered this issue when working skeletal controllers
// 	//my solution is to just manually adjust the actual socket position
// 	//to match the screen rendered position
// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	//if falling, lower tether source faster
// 	if (vc.z - prevTetherSourcePos.z < 0) {
// 		vc.z -= 8 * deltaTimeBoostMultiplier;
// 	}
	
// 	//raising up, raise tether beam faster
// 	else {
// 		vc.z += 8 * deltaTimeBoostMultiplier;
// 	}
	
// 	//deltaTimeBoostMultipler neutralizes effects of 
// 	//fluctuating frame rate / time dilation

// 	//update beam based on on skeletal mesh socket
// 	tetherBeam.SetVectorParameter('TetherSource', vc);
// 	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket2', vc2, r);
// 	tetherBeam2.SetVectorParameter('TetherSource', vc);
	
// 	//save prev tick pos to see change in position
// 	prevTetherSourcePos = vc;
	

// 	if(enemyPawn != none)
// 	{
// 		DebugPrint("tcalc - "@TestPawn(enemyPawn).grappleSocketLocation);
// 	tetherBeam.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
// 		tetherBeam2.SetVectorParameter('TetherEnd', TestPawn(enemyPawn).grappleSocketLocation);	
// }
	
// 	//~~~~~~~~~~~~~~~~~~~
// 	//Actual Tether Constraint

// 	//I dont use a RB_Constraint
// 	//I control the allowed position
// 	//of the pawn through code
// 	//and use velocity adjustments every tick
// 	//to make it look fluid

// 	//setting PHYS_Falling + velocity adjustments every tick 
// 	//is what makes this work
// 	//and look really good with in-game physics
// 	//~~~~~~~~~~~~~~~~~~~
	
// 	//vector between player and tether loc
// 	//curTargetWall was given its value in createTether()
// 	vc = Location - projectileHitLocation;
	
// 	//dist between pawn and tether location
// 	//see Vsize(vc) below (got rid of unnecessary var)
	
// 	idunnowhatimdoing = tetherlength * 0.4;
//         //is the pawn moving beyond allowed current tether length?
//         //if so apply corrective force to push pawn back within range

// 	if (Vsize(vc) > tetherlength - idunnowhatimdoing) {
		
//                 //determine whether to remove all standard pawn
// 	        //animations and just use the Victory animation
// 	        //I use this to make animations look smooth while my Tether System
//                 //is applying changes to pawn velocity (otherwise strange anims play)

//                 //this also results in pawn looking like it is actively initiating the
//                 //change in velocity through some Willful Action
//                // TetheringAnimOnly = true;
		
//                 SetPhysics(PHYS_Falling);
		
// 		//direction of tether = normal of distance between
// 		//pawn and tether attach point
// 		vc2 = normal(vc);
		
// 		//moving in same direction as tether?

// 		//absolute value of size difference between
// 		//normalized velocity and tether direction
// 		//if > 1 it means pawn is moving in same direction as tether
// 		if(abs(vsize(Normal(velocity) - vc2)) > 1){
		
// 		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 		//limit max velocity applied to pawn in direction of tether
// 		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// 		//50 controls how much the pawn moves around while attached to tether
// 		//could turn into a variable and control for greater refinement of
// 		//this game mechanic

// 		//1200 is the max velocity the tether system is allowed to force the
// 		//pawn to move at, adjust to your preferences
// 		//could also be made into a variable
// 		// DebugPrint("v - " $velocity.z);
// 		// if(vsize(velocity) < 2500){
// 			// velocity -= vc2 * 300;
// 		// }
// 		if(Vsize(vc) > 1500)
// 		{
// 			velocity -= vc2 * (Vsize(vc) * goingTowardsHighVelModifier);
// 		}
// 		else
// 		{
// 			velocity -= vc2 * goingTowardsLowVelModifier;	
// 		}

// 		// DebugPrint("length"@Vsize(vc));
// 		}
		
// 		//not moving in direction of pawn
// 		//apply as much velocity as needed to prevent falling
// 		//allows sudden direction changes
// 		// else {
// 			// if(velocity.z > 1200) //Usually caused by gravity boost from jetpack
// 				// velocity -= vc2 * (95 * (Velocity.z * 0.4)) ;
// 			else
// 			{
// 				// DebugPrint("going away");
// 				velocity -= vc2 * goingAwayVelModifier;
// 			}
// 		// }
// 		// if(tetherlength > 1000)
// 			// velocity -= vc2 * (tetherlength * 0.15);
// 		// if(location.z <= 75){
// 		// 	ll = location;
// 		// 	ll.z = 76;
// 		// 	EmberGameInfo(WorldInfo.Game).playerControllerWORLD.SetLocation(ll);
// 		// 	// setLocation
// 		// 	// Velocity.z *= -2;
// 		// }
// 	}
// 	else {
// 		//allow all regular ut pawn animations
//                 //since player velocity is not being actively changed 
//                 //by Rama Tether System
//                 //TetheringAnimOnly = false;




// 	}
// 	/*
// 	//if the target point of tether is attached to moving object

// 	if (tetheredToMovingWall) {
// 		//beam end point
// 		tetherBeam.SetVectorParameter('TetherEnd', 					
// 		curTargetWall.Location);
// 	}
// 	*/
}

/*
AddDefaultInventory
	Queued for Deletion
*/
function AddDefaultInventory()
{
    //Add the sword as default
    // InvManager.DiscardInventory();
    // InvManager.CreateInventory(class'Custom_Sword'); //InvManager is the pawn's InventoryManager
}
/*
SetSwordState
	true = hand, false = nowhere
*/
exec function SetSwordState(bool inHand)
{
    //setting our sword state.
    SwordState = inHand; 
}
/*
GetSwordState
*/
simulated function bool GetSwordState()
{
    //getting our sword state.
    return SwordState;   
}
/*
PlayAttack
	Play animation at speed
*/
exec function PlayAttack(name AnimationName, float AnimationSpeed)
{
    //The function we use to play our anims
    //Below goes, (anim name, anim speed, blend in time, blend out time, loop, override all anims)
    AnimSlot.PlayCustomAnim( AnimationName, AnimationSpeed, 0.00, 0.00, false, true);
}


simulated function JumpVelocityPinch(float fDeltaTime)
{

//TODO: Velocity keeps capping at 320, need to find a logarithmic approach

 if(physics == PHYS_Falling) //we are in the air
 	jumpActive = true;

  		if(physics == PHYS_Walking && jumpActive) //When we land after being in the air
  		{
  			JumpVelocityPinch_LandedTimer=fDeltaTime; //set the timer to something else
  			jumpActive = false; //disable toggle so we don't activate this again
  			AccelRate *= 0.3;
  			Velocity *= 0.60;
  		}

  		if(JumpVelocityPinch_LandedTimer != 0) //if the timer isn't 0
  		{
  			JumpVelocityPinch_LandedTimer += fDeltaTime; //increase timer by tick ammount
  			// if( JumpVelocityPinch_LandedTimer <= 0.5 ) //while it's less than half a second
  				// if(VSize(Velocity) > 320) //and if velocity is greater than 320 (440 is max speed when walking)
  				// AccelRate *= 1.05; //multiply itself by 0.8
  		}

  		if(JumpVelocityPinch_LandedTimer > 0.5) //if timer has gone past 0.5 seconds
  		{
  			JumpVelocityPinch_LandedTimer = 0; //set it to 0.
  			AccelRate=2048.0;
  		}
}

/*
DoKick
	Does a tracer for ~ 2.5 seconds from left foot to left knee
*/
simulated function DoKick()
{
	kickCounter++;
	if(kickCounter < 20)
		SetTimer(0.1, false, 'DoKick');

		ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('L_JB', botFoot); 
		ModularPawn_Cosmetics.ParentModularItem.GetSocketWorldLocationAndRotation('L_Knee', botLeg); 

			// if(oldBotLeg == vect(0,0,0))
	  //       	DrawDebugLine(botFoot, oldBotFoot, -1, 0, -1, true);
   //      	else
   //  	    	DrawDebugLine(botLeg, oldBotLeg, -1, 0, -1, true);

    	    	DrawDebugLine(botLeg, botFoot, -1, 0, -1, true);
}

//===============================
// Stances Functions
//===============================
simulated function LightStance()
{
	if(GetTimeLeftOnAttack() > 0)
		return;

	// swordMesh=SkeletalMesh'ArtAnimation.Meshes.gladius';
	// Mesh.DetachComponent(Sword[currentStance-1].mesh);
    // Mesh.DetachComponent(Sword[currentStance-1].CollisionComponent);
	// Sword.Mesh.SetSkeletalMesh(swordMesh);
switch(currentStance)
{
	case 2:
	MediumDecoSword.Mesh.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'KattanaSocket');
    MediumDecoSword.Mesh.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'KattanaSocket');
	break;

	case 3:
	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'HeavyAttach');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'HeavyAttach');
	break;
}
	currentStance = 1;

	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'WeaponPoint');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'WeaponPoint');
    // LightDecoSword.Mesh.SetHidden(true);
    // HeavyDecoSword.Mesh.SetHidden(false);
    // MediumDecoSword.Mesh.SetHidden(false);
	overrideStanceChange();
}
simulated function BalanceStance()
{
	if(GetTimeLeftOnAttack() > 0)
		return;

	// currentStance = 2;
	// swordMesh=SkeletalMesh'ArtAnimation.Meshes.ember_weapon_katana';
	// Mesh.DetachComponent(Sword.mesh);
 //    Mesh.DetachComponent(Sword.CollisionComponent);
	// Sword.Mesh.SetSkeletalMesh(swordMesh);
	//     Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
 //    Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint');
 //    // LightDecoSword.Mesh.SetHidden(false);
 //    // HeavyDecoSword.Mesh.SetHidden(false);
 //    // MediumDecoSword.Mesh.SetHidden(true);

 switch(currentStance)
{
	case 1:
	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'LightAttach');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'LightAttach');
	break;

	case 3:
	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'HeavyAttach');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'HeavyAttach');
	break;
}
	currentStance = 2;
	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'WeaponPoint');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'WeaponPoint');
    // LightDecoSword.Mesh.SetHidden(true);
    // HeavyDecoSword.Mesh.SetHidden(false);
    // MediumDecoSword.Mesh.SetHidden(false);
    // Sword[currentStance-1].tempSoundBool=true;
    if(!tempToggleForEffects)
    {
    		setTrailEffects();
    		setTrailEffects();
    		setTrailEffects();
tempToggleForEffects = true;

    	}
	overrideStanceChange();
	
}
simulated function HeavyStance()
{
	if(GetTimeLeftOnAttack() > 0)
		return;

//  	currentStance = 3;
// 	swordMesh=SkeletalMesh'ArtAnimation.Meshes.ember_weapon_heavy';  
// 	Mesh.DetachComponent(Sword.mesh);  
//     Mesh.DetachComponent(Sword.CollisionComponent);
// 	Sword.Mesh.SetSkeletalMesh(swordMesh);
// 	Sword.getAnim();
// 	    Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint'); 
//     Mesh.AttachComponentToSocket(Sword.CollisionComponent, 'WeaponPoint'); 
//     LightDecoSword.Mesh.SetHidden(false);
//     HeavyDecoSword.Mesh.SetHidden(true);
//     MediumDecoSword.Mesh.SetHidden(false);
// overrideStanceChange();
 switch(currentStance)
{
	case 1:
	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'LightAttach');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'LightAttach');
	break;

	case 2:
	MediumDecoSword.Mesh.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'KattanaSocket');
    MediumDecoSword.Mesh.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'KattanaSocket');
	break;
}
	currentStance = 3;

	ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].Mesh, 'WeaponPoint');
    ModularPawn_Cosmetics.ParentModularItem.AttachComponentToSocket(Sword[currentStance-1].CollisionComponent, 'WeaponPoint');
    // LightDecoSword.Mesh.SetHidden(true);
    // HeavyDecoSword.Mesh.SetHidden(false);
    // MediumDecoSword.Mesh.SetHidden(false);
	overrideStanceChange();

}
simulated function SheatheWeapon()
{
	ModularPawn_Cosmetics.ParentModularItem.DetachComponent(Sword[currentStance-1].mesh);
    ModularPawn_Cosmetics.ParentModularItem.DetachComponent(Sword[currentStance-1].CollisionComponent);
} 
simulated function overrideStanceChange()
{
	IdleAnimNodeBlendList.SetActiveChild(currentStance-1, idleBlendTime);
	RunAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	WalkAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	wRightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	wLeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, runBlendTime);
	// Sword[currentStance-1].setStance(currentStance);
}
//===============================
// Console Vars
//===============================

// exec function ep_sword_stance_damages(float l = 0 ,float m = 0, float h = 0)
// {
// 	if(l == 0 && m == 0 && h == 0)
// 	{
// 		DebugPrint("light -"@)
// 	}
// 	if(distance == -3949212)
// 		DebugPrint("Distance till sword block 'parries' opponent. Current Value -"@Sword[currentStance-1].blockDistance);
// 	else
//   		Sword[currentStance-1].blockDistance = distance;
// }
exec function ep_sword_block_distance(float distance = -3949212)
{
	if(distance == -3949212)
		DebugPrint("Distance till sword block 'parries' opponent. Current Value -"@Sword[currentStance-1].blockDistance);
	else
  		Sword[currentStance-1].blockDistance = distance;
}
exec function ep_sword_block_cone(float coneDotProductAngle = -3949212)
{
	if(coneDotProductAngle == -3949212)
		DebugPrint("DotProductAngle for active block. 0.5 is ~45 degrees. 0 is 90 degrees. Current Value -"@Sword[currentStance-1].blockCone);
	else
  		Sword[currentStance-1].blockCone = coneDotProductAngle;
}
exec function ep_player_anim_run_blend_time(float runBlendTimeMod = -3949212)
{
	if(runBlendTimeMod == -3949212)
		DebugPrint("Blend time (in seconds) between run animations. Current Value -"@runBlendTime);
	else
  		runBlendTime = runBlendTimeMod;
} 
exec function ep_player_anim_idle_blend_time(float idleBlendTimeMod = -3949212)
{
	if(idleBlendTimeMod == -3949212) 
		DebugPrint("Blend time (in seconds) between idle animations. Current Value -"@idleBlendTime);
	else
  		idleBlendTime = idleBlendTimeMod; 
}
exec function ep_player_gravity_scaling(float GravityScale = -3949212)
{
	if(GravityScale == -3949212) 
		DebugPrint("Lower values = lower gravity, higher = higher gravity. Current Value -"@CustomGravityScaling);
	else
  		CustomGravityScaling = GravityScale;
}
exec function ep_player_jump_boost(float JumpBoost = -3949212)
{ 
	JumpZ = (JumpBoost == -3949212) ? ModifiedDebugPrint("The boost player gets when jumping. Current Value -", JumpZ) : JumpBoost;
}
exec function ep_player_audio_Inathero(float enableAudio_One_or_Zero = -3949212)
{ 
	enableInaAudio = (enableAudio_One_or_Zero == -3949212) ? ModifiedDebugPrint("Inathero's op audio. 1 = on, 0 = off. Current - ", enableInaAudio) : enableAudio_One_or_Zero;
}
exec function ep_chamber(float t)
{
	AttackPacket.tDur = t;
}

// exec function ep_player_decoSword_light(int Var1 = -3949212, int Var2 = -3949212, int Var3 = -3949212)
// { 
// 	local int v1, v2, v3;
// 	if(Var1 == -3949212 && Var2 == -3949212 && Var3 == -3949212)
// 	{
// 		DebugPrint("Rotates Light DecoSword. Uses the weird bit angle system. 360 degrees = 65536");
// 		DebugPrint("pitch:"@LightDecoSword.Rotation.pitch);
// 		DebugPrint("yaw:"@LightDecoSword.Rotation.Yaw);
// 		DebugPrint("roll:"@LightDecoSword.Rotation.Roll);
// 	}
// 	else
// 	{
// 		v1 = (Var1 == -3949212) ? LightDecoSword.Rotation.pitch : Var1;
// 		v2 = (Var2 == -3949212) ? LightDecoSword.Rotation.Yaw : Var2;
// 		v3 = (Var3 == -3949212) ? LightDecoSword.Rotation.Roll : Var3;
// 		LightDecoSword.rotate(v1, v2, v3);
// 	}
// 	// -180,45,-180
// }
function float ModifiedDebugPrint(string sMessage, float variable)
{
	DebugPrint(sMessage @ string(variable));
	return variable;
}
function attachReset()
{
	  local SkeletalMeshComponent ToBeAttachedItem;
ToBeAttachedItem = new class'SkeletalMeshComponent';
ToBeAttachedItem.SetSkeletalMesh(SkeletalMesh'ModularPawn.Meshes.ember_head_01');
ToBeAttachedItem.SetParentAnimComponent(Mesh);
AttachComponent(ToBeAttachedItem);
}
defaultproperties
{
	cameraCamZOffsetInterpolation=30
	cameraCamXOffsetMultiplierInterpolation=3.7
	blendAttackCounter=0;
	savedByteDirection=(0,0,0,0,0); 
	debugConeBool=false;
	enableInaAudio = 0;
    GroundSpeed=400.0;
//SkeletalMesh'ArtAnimation.Meshes.ember_player'
//=============================================
// End Combo / Attack System Vars
//=============================================

	idleBlendTime=0.15f
	runBlendTime=0.15f
	bCanStrafe=false
	SwordState = false
	MultiJumpBoost=1622.0
	CustomGravityScaling = 1.8//1.6
	JumpZ=750//JumpZ=750 //default-322.0
    bCollideActors=True
    bBlockActors=True
    currentStance = 1;

 // Remove normal defined skeletal mesh
  Components.Remove(WPawnSkeletalMeshComponent)


	Begin Object Name=CollisionCylinder
		CollisionRadius=0025.00000
		CollisionHeight=0047.5.00000
	End Object
   	Components.Add(CollisionCylinder)

	CollisionComponent=CollisionCylinder
}