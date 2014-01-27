class TestPawnController extends GameAIController;

var Pawn thePlayer; //variable to hold the target pawn
var float startTheClock;
var bool noPlayerSeen;

simulated private function DebugPrint(string sMessage)
{
    GetALocalPlayerController().ClientMessage(sMessage);
}

simulated event PostBeginPlay()
{
  super.PostBeginPlay();

}

 event SeePlayer(Pawn SeenPlayer) //bot sees player
{
          if (thePlayer ==none && TestPawn(pawn).followPlayer == 1) //if we didnt already see a player
          {
    thePlayer = SeenPlayer; //make the pawn the target
    Focus = SeenPlayer;
    startTheClock = 0;
    GoToState('Follow'); // trigger the movement code
                // TestPawn(pawn).doAttack ('ember_attack_forward', 1.0, 0.65, 0) ;
                    GetALocalPlayerController().ClientMessage("sMessage");
          }

}

state Follow
{
      Simulated Event Tick(float DeltaTime)
    {
      Super.Tick(DeltaTime);
      startTheClock += DeltaTime;
      prepareTheAttack();
    }
Begin:

    if (thePlayer != None && TestPawn(pawn).followPlayer == 1)  // If we seen a player
    {
      if(VSize(pawn.location - thePlayer.location) > 200)
      MoveTo(thePlayer.Location); // Move directly to the players location
      GoToState('Looking'); //when we get there
    }

}

state Looking
{
Begin:

  if (thePlayer != None && TestPawn(pawn).followPlayer == 1)  // If we seen a player
    {
      noPlayerSeen = false;
      Focus = thePlayer;
    if(VSize(pawn.location - thePlayer.location) > 200)
    MoveTo(thePlayer.Location); // Move directly to the players location
    GoToState('Follow');  // when we get there
    }
    else
      noPlayerSeen = true;

}
 
function prepareTheAttack()
{
  local float timeToAttack;
      timeToAttack = 1.00;
      Focus = thePlayer;
      // DebugPrint("prep");
    if(VSize(pawn.location - thePlayer.location) <= TestPawn(pawn).attackPlayerRange && startTheClock >= timeToAttack && !noPlayerSeen && TestPawn(pawn).attackPlayer == 1)
    {
      startTheClock = 0;
      TestPawn(pawn).doAttack ('ember_medium_forward', 1.5, 0.55, 1.0) ;
    }
}
//================================
// Console Vars
//================================

function float ModifiedDebugPrint(string sMessage, float variable)
{
  DebugPrint(sMessage @ string(variable));
  return variable;
}
defaultproperties
{
noPlayerSeen = true;
}
                