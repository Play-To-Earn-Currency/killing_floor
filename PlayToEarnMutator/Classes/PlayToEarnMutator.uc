class PlayToEarnMutator extends Mutator    
    config(PlayToEarnMutator);

var config string pte_database_ip;
var config string pte_earn_per_wave_end;
var config string pte_earn_per_wave_end_show;
var bool LastWaveInProgress;

event PostBeginPlay()
{
    Log("[PTE] Version: 0.1");
    Log("[PTE-Config] pte_database_ip is: " $ pte_database_ip);
    Log("[PTE-Config] pte_earn_per_wave_end is: " $ pte_earn_per_wave_end);
    Log("[PTE-Config] pte_earn_per_wave_end_show is: " $ pte_earn_per_wave_end_show);
}

function ModifyPlayer(Pawn Other)
{
    local KFPlayerReplicationInfo KFPRI;
    local RegisterTCP registerClient;

    Super.ModifyPlayer(Other);

    if (KFHumanPawn(Other) != None)
    {
        Log("[PTE-Mutator] Joined the Server: " $ Other.PlayerReplicationInfo.PlayerName);

        KFPRI = KFPlayerReplicationInfo(Other.PlayerReplicationInfo);
        if (KFPRI != None)
        {
            Log("===== Player Info Start =====");
            Log("PlayerName: " $ KFPRI.PlayerName);
            Log("PlayerID: " $ KFPRI.PlayerID);
            Log("Team: " $ KFPRI.Team);
            Log("Score: " $ KFPRI.Score);
            Log("Kills: " $ KFPRI.Kills);
            Log("Deaths: " $ KFPRI.Deaths);
            Log("ReadyToPlay: " $ KFPRI.bReadyToPlay);
            Log("WaitingPlayer: " $ KFPRI.bWaitingPlayer);
            Log("OnlySpectator: " $ KFPRI.bOnlySpectator);
            Log("SilentAdmin: " $ KFPRI.bSilentAdmin);
            Log("Admin: " $ KFPRI.bAdmin);
            Log("OutOfLives: " $ KFPRI.bOutOfLives);
            Log("GoalsScored: " $ KFPRI.GoalsScored);
            Log("ActiveChannel: " $ KFPRI.ActiveChannel);
            Log("NetUpdateTime: " $ KFPRI.NetUpdateTime);
            Log("SteamStatsAndAchievements: " $ KFPRI.SteamStatsAndAchievements);

            if (KFPRI.SteamStatsAndAchievements != None)
            {
                Log("SteamID: " $ KFPRI.SteamStatsAndAchievements.GetSteamUserID());
                registerClient = Spawn(class'RegisterTCP');
                registerClient.SetUniqueID(KFPRI.SteamStatsAndAchievements.GetSteamUserID());
                registerClient.Resolve(pte_database_ip);
            }

            Log("===== Player Info End =====");
        }
    }
}

event Tick(float DeltaTime)
{
    local KFGameReplicationInfo KFGRI;
    local Controller C;
    local KFPlayerController PC;
    local KFPlayerReplicationInfo KFPRI;
    local KFHumanPawn Pawn;
    local IncrementTCP incrementClient;

    KFGRI = KFGameReplicationInfo(Level.Game.GameReplicationInfo);
    if (KFGRI == None)
        return;
    
    // Detect wave end
    if (!KFGRI.bWaveInProgress && LastWaveInProgress)
    {
        Log("[PTE-Mutator] Wave is over!");

        // Check alive players
        C = Level.ControllerList;
        while (C != None)
        {
            PC = KFPlayerController(C); // Cast for KFPlayerController
            if (PC != None)
            {
                KFPRI = KFPlayerReplicationInfo(PC.PlayerReplicationInfo);
                if (KFPRI != None)
                {
                    Pawn = KFHumanPawn(PC.Pawn);
                    if (Pawn != None && Pawn.Health > 0)
                    {
                        Log("[PTE-Mutator] Player alive: " $ KFPRI.PlayerName);

                        if (KFPRI.SteamStatsAndAchievements != None)
                        {
                            Log("[PTE-Increment] SteamID: " $ KFPRI.SteamStatsAndAchievements.GetSteamUserID());
                            incrementClient = Spawn(class'IncrementTCP');
                            incrementClient.SetUniqueID(KFPRI.SteamStatsAndAchievements.GetSteamUserID());
                            incrementClient.SetQuantity(pte_earn_per_wave_end, pte_earn_per_wave_end_show);
                            incrementClient.SetPlayer(PC);
                            incrementClient.Resolve(pte_database_ip);
                        }
                    } else {
                        Log("[PTE-Mutator] Player dead: " $ KFPRI.PlayerName);
                    }
                }
            }

            C = C.NextController;
        }
        Level.Game.Broadcast(None, "[PTE] Alive players earned: 0.1 PTE");
    }

    LastWaveInProgress = KFGRI.bWaveInProgress;
}

defaultproperties
{
    GroupName="KFPlayToEarnMutator"
    FriendlyName="Play To Earn Mutator"
    Description="Basic template for play to earn"
}