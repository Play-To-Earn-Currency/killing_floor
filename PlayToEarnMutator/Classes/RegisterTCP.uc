class RegisterTCP extends TcpLink;

var string PendingData;
var string UniqueID;

function SetUniqueID(string ID)
{
    UniqueID = ID;
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

    Log("[PTE-RegisterTCP] TCP Opened");

    CRLF = Chr(13) $ Chr(10);
    Body = "{\"uniqueid\": \"" $ UniqueID $ "\"}";

    Request = "POST /register HTTP/1.1" $ CRLF;
    Request $= "Host: 127.0.0.1:8000" $ CRLF;
    Request $= "Content-Type: application/json" $ CRLF;
    Request $= "From: killingfloor" $ CRLF;
    Request $= "Content-Length: " $ Len(Body) $ CRLF;
    Request $= CRLF;
    Request $= Body;

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
    
    //Log("[PTE-RegisterTCP] Text Received: " $ FirstLine);
}

event Closed()
{
    Log("[PTE-RegisterTCP] TCP Connection closed!");
}