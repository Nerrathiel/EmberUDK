class TestPawn extends UTPawn
      placeable;
//=============================================
// Mesh and Character Vars
//=============================================
var(NPC) SkeletalMeshComponent NPCMesh;
var() SkeletalMeshComponent SwordMesh;
var SkeletalMesh defaultMesh;
var MaterialInterface defaultMaterial0;
var AnimTree defaultAnimTree;
var array<AnimSet> defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;
var PhysicsAsset defaultPhysicsAsset;
var(NPC) class<AIController> NPCController;
//=================================
// Grappled Hooked
//=================================
var bool 		gHook;
var float 		gHookTimer;
var float 		dTime;
var vector 		gHookTarget;
var pawn 		playerPawn;
var vector 		grappleSocketLocation;

var byte isParryActive;
var pawn P;
var bool tParry,tHit,tDamage;
var float talkCounter;
var int talkCounterChooser;
//=============================================
// Weapon
//=============================================

var EmberVelocityPinch VelocityPinch;
var Sword Sword;
//=============================================
// Animation
//=============================================
var AnimNodePlayCustomAnim 	Attack1;
var AnimNodeSlot			AttackSlot[2];
var AnimNodeBlend			AttackBlend;
var AnimNodeBlendList IdleAnimNodeBlendList;
var AnimNodeBlendList RunAnimNodeBlendList;
var AnimNodeBlendList LeftStrafeAnimNodeBlendList;
var AnimNodeBlendList RightStrafeAnimNodeBlendList;
var bool 					defaultDelay;


var int followPlayer;
var float attackPlayerRange;
var int attackPlayer;




var struct AttackPacketStruct
{
  var name AnimName;
  var array<float> Mods;
}AttackPacket;

//For when the player takes damage
// event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
// {
// 	local float tHealth;
// 	GetALocalPlayerController().ClientMessage("tPawn Damage -" $Damage);
// 	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
// 	tHealth = Health - Damage;
// 	Health = FMax(tHealth, 0);
// 	GetALocalPlayerController().ClientMessage("tPawn tHealth -" $tHealth);

// 	WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
// 	if(Health==0)
// 	{
// 		GotoState('Dying');
// 	}
// }
event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int OldHealth;
local int i;
	if(Momentum.Z < 50) Momentum.Z = 50;
	// Velocity.Z *= 1.20;

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

	WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);

	tDamage = true;
	if(Health <= 0)
	{
		i = -1;
	TestPawnController(Instigator.Controller).TalkToPlayer("I'll be baaaAAAaaaaaaaAAAAck");	
	}
	
}

simulated function talkEverySecond()
{
	talkCounter = 0;

	if(tDamage || tParry || tHit)
	{
		// tDamage = false;
	talkCounterChooser ++;
	if(talkCounterChooser == 19)
	talkCounterChooser = 0;

	// i = 0;
switch(talkCounterChooser)
{
	case 0:
	TestPawnController(Instigator.Controller).TalkToPlayer("You're so fake that Barbie is more real than you");
	break;
	case 1:
TestPawnController(Instigator.Controller).TalkToPlayer("Your momma's so ugly she turned Medusa to stone");
	break;
	case 2:
TestPawnController(Instigator.Controller).TalkToPlayer("I called your boyfriend gay and he hit me with his purse");
	break;
	case 3:
TestPawnController(Instigator.Controller).TalkToPlayer("You couldn't hit water if you fell out of a boat");
	break;

	case 4:
TestPawnController(Instigator.Controller).TalkToPlayer("You are proof that God has a sense of humor.");
	break;

	case 5:
TestPawnController(Instigator.Controller).TalkToPlayer("You look like a before picture.");
	break;
	
	case 6:
TestPawnController(Instigator.Controller).TalkToPlayer("Shock me, say something intelligent.");
	break;
	case 7:
TestPawnController(Instigator.Controller).TalkToPlayer("If you were twice as smart, you'd still be stupid");
	break;
	case 8:
TestPawnController(Instigator.Controller).TalkToPlayer("I would ask how old you are, but I know you can't count that high.");
	break;
	case 9:
	TestPawnController(Instigator.Controller).TalkToPlayer(". Everyone who ever loved you was wrong.");
	break;
	case 10:
TestPawnController(Instigator.Controller).TalkToPlayer("Don't you need a license to be that ugly?");
	break;
	case 11:
TestPawnController(Instigator.Controller).TalkToPlayer("Who gave you permission to exist");
	break;
	case 12:
TestPawnController(Instigator.Controller).TalkToPlayer("Do everyone a favor and die");
	break;
	case 13:
TestPawnController(Instigator.Controller).TalkToPlayer("you'll never be the man your mother is");
	break;
	case 14:
TestPawnController(Instigator.Controller).TalkToPlayer("You're so ugly Hello Kitty said goodbye to you.");
	break;

	case 15:
	TestPawnController(Instigator.Controller).TalkToPlayer("If you had another brain, it would be lonely.");
	break;
	case 16:
TestPawnController(Instigator.Controller).TalkToPlayer("Are your parents siblings?");
	break;
	case 17:
TestPawnController(Instigator.Controller).TalkToPlayer("People like you are the reason I work out.");
	break;
	case 18:
TestPawnController(Instigator.Controller).TalkToPlayer("You're so fat you need cheat codes to play Wii Fit");
	break;

}
}

}
/*
Tick
  Per tick:
  check if hooked
  	if hooked, do hook function
  Get grappleSocketLocation for preperation of hook
*/

Simulated Event Tick(float DeltaTime)
{
	local rotator r;
	
	Super.Tick(DeltaTime);
// talkCounter += DeltaTime;
// if(talkCounter > 3)
	// talkEverySecond();
   		if(gHook)
   		{
	   		dTime = DeltaTime;
   			gHookTimer += DeltaTime;
   			grappleHooked(gHookTarget, playerPawn);
   		}
if(VelocityPinch.bApplyVelocityPinch)
	VelocityPinch.ApplyVelocityPinch(DeltaTime);

	Mesh.GetSocketWorldLocationAndRotation('GrappleSocket', grappleSocketLocation, r);
}

/*
grappleHooked
	if hooked, pull pawn towards player
	@TODO: Everything. Don't like how shitty this is
*/
function grappleHooked(vector target, pawn player)
{
	local vector hitLoc, hitNormal, endLoc;
	local float floaty2;
	endLoc = player.location;
	gHook = true;
	if(gHook == true && gHookTimer == 0.00)
	{
		// gHookTimer += 0.01;
		gHookTarget = target;
		playerPawn = player;
		Self.trace(hitLoc, hitNormal, endLoc, location );
		floaty2 = VSize(location - endLoc);

		 if(floaty2 <= 250) return;

		Velocity = target * 800;

		location.z > 50 ? Velocity.z : Velocity.z = 75;
		// location.z += 10;
		SetPhysics(Phys_Falling );
	}
	// else if(gHookTimer > 0.00 && gHookTimer < 0.5)
	if(gHook == true)
	{
		gHookTarget = target;
		location.z > 50 ? Velocity.z : Velocity.z = 75;

		Self.trace(hitLoc, hitNormal, endLoc, location );
		floaty2 = VSize(location - endLoc);

		//dTime ~ 0.0088
		Velocity = target * 800;// - (gHookTimer * 536.36));
		if(floaty2 <= 250)
		{
			Velocity.z = 0;
			Velocity.x = 0;
			Velocity.y = 0;
			gHookTimer = 0;
			gHook = false;
		}
		// Velocity.Z = 75;
		SetPhysics(Phys_Falling );
	}
}

/*
TakeDamage
	disable DmgType_Crushed, @renable in final?
*/
// event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
// 	{
// 		local Vector shotDir, ApplyImpulse,BloodMomentum;
// 		local class<UTDamageType> UTDamage;
// 		local UTEmit_HitEffect HitEffect;
	
// 	if(damageType == class'DmgType_Crushed')
// 		return;

// 		if ( class'UTGame'.Static.UseLowGore(WorldInfo) )
// 		{
// 			if ( !bGibbed )
// 			{
// 				UTDamage = class<UTDamageType>(DamageType);
// 				if (UTDamage != None && ShouldGib(UTDamage))
// 				{
// 					bTearOffGibs = true;
// 					bGibbed = true;
// 				}
// 			}
// 			return;
// 		}

// 		// When playing death anim, we keep track of how long since we took that kind of damage.
// 		if(DeathAnimDamageType != None)
// 		{
// 			if(DamageType == DeathAnimDamageType)
// 			{
// 				TimeLastTookDeathAnimDamage = WorldInfo.TimeSeconds;
// 			}
// 		}

// 		if (!bGibbed && (InstigatedBy != None || EffectIsRelevant(Location, true, 0)))
// 		{
// 			UTDamage = class<UTDamageType>(DamageType);

// 			// accumulate damage taken in a single tick
// 			if ( AccumulationTime != WorldInfo.TimeSeconds )
// 			{
// 				AccumulateDamage = 0;
// 				AccumulationTime = WorldInfo.TimeSeconds;
// 			}
// 			AccumulateDamage += Damage;

// 			Health -= Damage;
// 			if ( UTDamage != None )
// 			{
// 				if ( ShouldGib(UTDamage) )
// 				{
// 					if ( bHideOnListenServer || (WorldInfo.NetMode == NM_DedicatedServer) )
// 					{
// 						bTearOffGibs = true;
// 						bGibbed = true;
// 						return;
// 					}
// 					SpawnGibs(UTDamage, HitLocation);
// 				}
// 				else if ( !bHideOnListenServer && (WorldInfo.NetMode != NM_DedicatedServer) )
// 				{
// 					CheckHitInfo( HitInfo, Mesh, Normal(Momentum), HitLocation );
// 					UTDamage.Static.SpawnHitEffect(self, Damage, Momentum, HitInfo.BoneName, HitLocation);

// 					if ( UTDamage.default.bCausesBlood && !class'UTGame'.Static.UseLowGore(WorldInfo)
// 						&& ((PlayerController(Controller) == None) || (WorldInfo.NetMode != NM_Standalone)) )
// 					{
// 						BloodMomentum = Momentum;
// 						if ( BloodMomentum.Z > 0 )
// 							BloodMomentum.Z *= 0.5;
// 						HitEffect = Spawn(GetFamilyInfo().default.BloodEmitterClass,self,, HitLocation, rotator(BloodMomentum));
// 						HitEffect.AttachTo(Self,HitInfo.BoneName);
// 					}

// 					if ( (UTDamage.default.DamageOverlayTime > 0) && (UTDamage.default.DamageBodyMatColor != class'UTDamageType'.default.DamageBodyMatColor) )
// 					{
// 						SetBodyMatColor(UTDamage.default.DamageBodyMatColor, UTDamage.default.DamageOverlayTime);
// 					}

// 					if( (Physics != PHYS_RigidBody) || (Momentum == vect(0,0,0)) || (HitInfo.BoneName == '') )
// 						return;

// 					shotDir = Normal(Momentum);
// 					ApplyImpulse = (DamageType.Default.KDamageImpulse * shotDir);

// 					if( UTDamage.Default.bThrowRagdoll && (Velocity.Z > -10) )
// 					{
// 						ApplyImpulse += Vect(0,0,1)*DamageType.default.KDeathUpKick;
// 					}
// 					// AddImpulse() will only wake up the body for the bone we hit, so force the others to wake up
// 					Mesh.WakeRigidBody();
// 					Mesh.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName, true);
// 				}
// 			}
// 		}

// 	WorldInfo.Game.Broadcast(self,Name$": Health:"@Health);
// 	Health = FMax(Health, 0);	
// 	if(Health==0)
// 	{
// 		GotoState('Dying');
// 	}
// }
/*
PostInitAnimTree
	Allows custom animations.
*/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    //Setting up a reference to our animtree to play custom stuff.
    super.PostInitAnimTree(SkelComp);
    if ( SkelComp == Mesh)
    {
  		IdleAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('IdleAnimNodeBlendList'));
  		RunAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('RunAnimNodeBlendList'));
  		LeftStrafeAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('LeftStrafeAnimNodeBlendList'));
  		RightStrafeAnimNodeBlendList = AnimNodeBlendList(Mesh.FindAnimNode('RightStrafeAnimNodeBlendList'));  
  		Attack1 = AnimNodePlayCustomAnim(Mesh.FindAnimNode('CustomAttack'));
  		AttackSlot[0] = AnimNodeSlot(Mesh.FindAnimNode('AttackSlot'));
  		AttackSlot[1] = AnimNodeSlot(Mesh.FindAnimNode('AttackSlot2'));
  		// AttackSlot2 = AnimNodeSlot(Mesh.FindAnimNode('AttackSlot2'));
  		AttackBlend = AnimNodeBlend(Mesh.FindAnimNode('AttackBlend'));
  		overrideStanceChange();
    }

}

/*
PostBeginPlay
*/
simulated function PostBeginPlay()
{
	 //  if(NPCController != none)
  // {
  //   // set the existing ControllerClass to our new NPCController class
  //   ControllerClass = NPCController;
  // }  
	super.PostBeginPlay();

	SetPhysics(PHYS_Walking); // wake the physics up

	
	// set up @collision @detection based on mesh's PhysicsAsset
	// CylinderComponent.SetActorCollision(false, false); // disable cylinder collision
	// Mesh.SetActorCollision(true, true); // enable PhysicsAsset collision
	// Mesh.SetTraceBlocking(true, true); // block traces (i.e. anything touching mesh)
	// SetTimer(0.5, true, 'BrainTimer');
	SetTimer(0.1, false, 'WeaponAttach');

VelocityPinch = new class 'EmberProject.EmberVelocityPinch';
VelocityPinch.SetOwner(self);

}

function HitRed()
{
  	CustomTimeDilation = 0.02f;
  	SetTimer(0.002, false, 'enableAnimations');
}

function HitBlue()
{
  	CustomTimeDilation = 0.02f;
  	SetTimer(0.002, false, 'enableAnimations');
}

function HitGreen()
{
  	// CustomTimeDilation = 0.02f;
  	// SetTimer(0.002, false, 'enableAnimations');
}

simulated function enableAnimations()
{
  	CustomTimeDilation = 1.0f;
}

function sword GetSword()
{
	return Sword;
}
/*
WeaponAttach
	Attachs Sword.uc to pawn
*/
function WeaponAttach()
{
	 Sword = Spawn(class'Sword', self);
	 Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
		Sword.setDamage(15);
		AttackPacket.Mods.AddItem(0);
		AttackPacket.Mods.AddItem(0);
		AttackPacket.Mods.AddItem(0);
		AttackPacket.Mods.AddItem(0);
		AttackPacket.Mods.AddItem(0);
		AttackPacket.Mods.AddItem(2);
	 // Sword.Mesh.SetSkeletalMesh(SkeletalMesh'ArtAnimation.Meshes.flammard');  
}


/*
Dying
	Queued Deletion
*/
//override so that the corpse will stay.
//^ not made by @Inathero
simulated State Dying
{
ignores OnAnimEnd, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, StartFeignDeathRecoveryAnim, ForceRagdoll, FellOutOfWorld;
	exec simulated function FeignDeath();
	reliable server function ServerFeignDeath();
	event bool EncroachingOn(Actor Other)
	{
		// don't abort moves in ragdoll
		// return false;
		return true;
	}

	event Timer()
	{
		local PlayerController PC;
		// local bool bBehindAllPlayers;
		local vector ViewLocation;
		local rotator ViewRotation;
		Destroy();

		// let the dead bodies stay if the game is over
		if (WorldInfo.GRI != None && WorldInfo.GRI.bMatchIsOver)
		{
			LifeSpan = 0.0;
			return;
		}
		EmberGameInfo(WorldInfo.Game).pawnsActiveOnPlayer--;
		//commenting off Destroy so that the bodies will stay
		//if ( !PlayerCanSeeMe() )
		//{
		//	Destroy();
		//	return;
		//}
		// go away if not viewtarget
		//@todo FIXMESTEVE - use drop detail, get rid of backup visibility check
		//bBehindAllPlayers = true;
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			if ( (PC.ViewTarget == self) || (PC.ViewTarget == Base) )
			{
				if ( LifeSpan < 3.5 )
					LifeSpan = 3.5;
				SetTimer(2.0, false);
				return;
			}

			PC.GetPlayerViewPoint( ViewLocation, ViewRotation );
			if ( ((Location - ViewLocation) dot vector(ViewRotation) > 0) )
			{
				// bBehindAllPlayers = false;
				break;
			}
		}
		//if ( bBehindAllPlayers )
		//{
		//	Destroy();
		//	return;
		//}
		SetTimer(2.0, false);
	}
}
/*
SwordGotHit
	Pending parry animation
	@TODO: Allow this function to be available only
	when pawn is doing an attack. Otherwise swords act
	as perma block mode.
*/
function SwordGotHit()
{
	local int i;
	if(isParryActive == 0)
	{
		isParryActive = 1;

    GetALocalPlayerController().ClientMessage("TestPawn - Sword Hit");
    Sword.SetInitialState();
    Sword.attackIsActive = false;
    AttackSlot[0].StopCustomAnim(0.01);
    ClearTimer('attackStop');
    AttackBlend.setBlendTarget(1, 0); 
    tParry = true;
 	
	i = Rand(Sword.aParry.ParryNames.length);

	SetTimer(Sword.aParry.ParryMods[i], false, 'attackStop');
	AttackSlot[0].PlayCustomAnimByDuration(Sword.aParry.ParryNames[i],Sword.aParry.ParryMods[i], 0, 0, false);
	}
}
function damageDone(float tDamage)
{
	local int i;
tHit = true;
// SeePlayer
	// if(Health < 150)
		// Health += tDamage / 2;
}

function forcedAnimEnd()
{
	// (1.3, 0.5, 0.7, 0.3, 0.5)
}
/*
doAttack
	Used for attack tests
*/
function doAttack (name animName, array<float> mods)
{
	 // Sword = Spawn(class'Sword', self);
	 // Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');

  local int i;
  AttackPacket.AnimName = animName;
  for(i = 0; i < mods.length; i++)
    AttackPacket.Mods[i] = mods[i];

	// FlushPersistentDebugLines();

            AttackBlend.setBlendTarget(1, 0.5);
            Sword.setKnockback(AttackPacket.Mods[5]); 
            Sword.setTracerDelay(AttackPacket.Mods[1],AttackPacket.Mods[2]);
			// SetTimer(AttackPacket.Mods[0], false, 'AttackEnd');	
            AttackSlot[0].PlayCustomAnimByDuration(AttackPacket.AnimName, AttackPacket.Mods[0], AttackPacket.Mods[3], AttackPacket.Mods[4]);
            VelocityPinch.ApplyVelocityPinch(,AttackPacket.Mods[1],AttackPacket.Mods[2] * 1.1);

			// AttackBlend.setBlendTarget(0, 0.2);    
            // Sword.setTracerDelay(t1,t2);
            // VelocityPinch.ApplyVelocityPinch(, t1, t2);
            // Sword.setKnockback(knockback);
            // AttackSlot[0].PlayCustomAnimByDuration(animation, duration,0.3,0.5);
    // Sword.GoToState('AttackingNoTracers');
    Sword.GoToState('Attacking');
	SetTimer(AttackPacket.Mods[0], false, 'attackStop');
}
/*
GetTimeLeftOnAttack
	Returns time left on attack timer
*/
function float GetTimeLeftOnAttack()
{
	 return (GetTimerRate('attackStop') - GetTimerCount('attackStop'));
}
/*
attackStop
	reset Sword status
*/
function attackStop()
{
	// Sword.rotate(0,0,49152);
	if(isParryActive == 1)
		isParryActive = 0;
    Sword.SetInitialState();
    Sword.resetTracers();
	// Attack1.PlayCustomAnimByDuration('ember_idle_2',1.0, 0.2, 0, false);
}
/*
doAttackRecording
	Used for tracer recording
*/

function doAttackRecording (name animation, float duration, float t1, float t2) 
{
	 Sword = Spawn(class'Sword', self);
	 Mesh.AttachComponentToSocket(Sword.Mesh, 'WeaponPoint');
	Attack1.PlayCustomAnimByDuration(animation,duration, 0.5, 0, false);
	Sword.setTracerDelay(t1,t2);
    Sword.GoToState('Attacking');
	SetTimer(duration, false, 'AttackRecordingFinished');
}
/*
AttackRecordingFinished
	Delete this pawn instance
*/
function AttackRecordingFinished()
{
		Sword.Destroy();
		Destroy();
}
/*
SetCharacterClassFromInfo
	Used to set info for pawn
*/
simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
// Mesh.SetSkeletalMesh(defaultMesh);
// Mesh.SetMaterial(0,defaultMaterial0);
// Mesh.SetPhysicsAsset(defaultPhysicsAsset);
// Mesh.AnimSets=defaultAnimSet;
}

//Zombie shit
// simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
// {
//  `Log("Bump");

//      Super.Bump( Other, OtherComp, HitNormal );

// 	if ( (Other == None) || Other.bStatic )
// 		return;

//   P = Pawn(Other); //the pawn we might have bumped into

// 	if ( P != None)  //if we hit a pawn
// 	{
//             if (P.Health >1) //as long as pawns health is more than 1
// 	   {
//              P.Health --; // eat brains! mmmmm
//            }
//         }
// }
/*
goToIdleMotherfucker
	Temporary animation for 'parries'
*/
function goToIdleMotherfucker()
{
Sword.SetInitialState();
Attack1.PlayCustomAnimByDuration('ember_idle_2',0.1, 0.2, 0, false);
}
function overrideStanceChange()
{
	local int currentStance;
	currentStance = 2;
	IdleAnimNodeBlendList.SetActiveChild(currentStance-1, 0.15); 
	RunAnimNodeBlendList.SetActiveChild(currentStance-1, 0.15);
	RightStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, 0.15);
	LeftStrafeAnimNodeBlendList.SetActiveChild(currentStance-1, 0.15);
}
DefaultProperties
{
  followPlayer = 1;
  attackPlayer = 1;
  attackPlayerRange = 150;
  isParryActive=0;
  // GroundSpeed=300.0;
defaultMesh=SkeletalMesh'ArtAnimation.Meshes.ember_base'
defaultAnimTree=AnimTree'ArtAnimation.Armature_Tree'
defaultAnimSet(0)=AnimSet'ArtAnimation.AnimSets.Armature'
defaultPhysicsAsset=PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics'
	
      bCollideActors=True
      bBlockActors=True
	bPushesRigidBodies=true
	bStatic=False
	bMovable=True
	bAvoidLedges=true
	bStopAtLedges=true
	LedgeCheckThreshold=0.5f
	Health = 100
	
	Begin Object Name=CollisionCylinder
	// // 	// CollisionRadius=+00102.00000
	// // 	// CollisionHeight=+00102.800000
		CollisionRadius=15.125
		CollisionHeight=42
	End Object
   Components.Add(CollisionCylinder)

   	//Setup default NPC mesh
    Begin Object Class=SkeletalmeshComponent Name=NPCMesh0
// SkeletalMesh=SkeletalMesh'ArtAnimation.Meshes.ember_base'

SkeletalMesh=SkeletalMesh'ArtAnimation.Meshes.ember_player'
AnimtreeTemplate=AnimTree'ArtAnimation.Armature_Tree'
AnimSets(0)=AnimSet'ArtAnimation.AnimSets.Armature'
PhysicsAsset=PhysicsAsset'ArtAnimation.Meshes.ember_player_Physics'
		LightEnvironment=MyLightEnvironment
		BlockRigidBody=TRUE
		MinDistFactorForKinematicUpdate=0.0
		bChartDistanceFactor=true
		bHasPhysicsAssetInstance=true
		bEnableFullAnimWeightBodies=true
		CastShadow=true
		Scale=1.0
		BlockZeroExtent=true
		PhysicsWeight=1.0
    End Object
   Mesh=NPCMesh0
   Components.Add(NPCMesh0)


// Begin Object Class=SkeletalmeshComponent Name=MyWeaponSkeletalMesh
//     CastShadow=true
//     bCastDynamicShadow=true
//     bOwnerNoSee=false
//     // LightEnvironment=MyLightEnvironment;
//         SkeletalMesh=SkeletalMesh'GDC_Materials.Meshes.SK_ExportSword2'
//         BlockNonZeroExtent=true
//         BlockZeroExtent=true
//         BlockActors =true
//         CollideActors=true
//     // Scale=1.2
//   End Object
//   SwordMesh=MyWeaponSkeletalMesh

// 	Components.Add(MyWeaponSkeletalMesh)
	CollisionComponent=CollisionCylinder
	RagdollLifespan=180.0
	// bRunPhysicsWithNoController=true
	ControllerClass=class'TestPawnController'
}