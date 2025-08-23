class IncrementTCP extends TcpLink;

var string PendingData;
var string UniqueID;
// For some misterous unkown reason, this variables is not been saved on the object
var string Quantity;
var string Show;
var KFPlayerController Player;

function SetUniqueID(string ID)
{
    UniqueID = ID;
}

function SetQuantity(string quantity, string show)
{
    Quantity = quantity;
    Show = show;

    Log("[PTE-IncrementTCP] Quantity Set: " $ Quantity);
    Log("[PTE-IncrementTCP] Show Set: " $ Show);
}

function SetPlayer(KFPlayerController player) 
{
    Player = player;
}

event Resolved(IpAddr Addr)
{
    Addr.Port = 8000;
    BindPort();
    Open(Addr);
}

event Opened()
{
    local string Body, Request, CRLF;

    Log("[PTE-IncrementTCP] TCP Opened");

    CRLF = Chr(13) $ Chr(10);
    Body = "{";
    Body $= "\"uniqueid\": \"" $ UniqueID $ "\",";
    // For some godly reason this not work
    //Body $= "\"quantity\": \"" $ Quantity $ "\"";
    Body $= "\"quantity\": \"100000000000000000\"";
    Body $= "}";

    Request = "PUT /increment HTTP/1.1" $ CRLF;
    Request $= "Host: 127.0.0.1:8000" $ CRLF;
    Request $= "Content-Type: application/json" $ CRLF;
    Request $= "From: killingfloor" $ CRLF;
    Request $= "Content-Length: " $ Len(Body) $ CRLF;
    Request $= CRLF;
    Request $= Body;

    Log(Request);

    SendText(Request);
}

event ReceivedText(string Text)
{
    local int NewLineIndex;
    local string FirstLine;
    
    NewLineIndex = InStr(Text, "\n");
    
    if (NewLineIndex > 0)
        FirstLine = Left(Text, NewLineIndex-1);
    else
        FirstLine = Text;
    
    Log("[PTE-IncrementTCP] Text Received: " $ FirstLine);

    // Also not work
    // Player.ClientMessage("[PTE] You received: " $ Show $ " PTE");
}

event Closed()
{
    Log("[PTE-IncrementTCP] TCP Connection closed!");
}