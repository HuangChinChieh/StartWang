using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Collections;

public partial class Wallet_BitCoin : System.Web.UI.Page
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static GameAPI.APIResult ETHBitCoinTx(string CT, string GUID, string WalletPassword, string ToAddress, string CurrencyType, decimal Amount)
    {
        string Token;
        int RValue;
        Random R = new Random();

        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        GameAPI.GameAPI gameAPI = new GameAPI.GameAPI();
        GameAPI.APIResult RetValue = null;

        RetValue = gameAPI.ETHBitCoinTx(CT, GUID, WalletPassword, ToAddress, CurrencyType, Amount);

        return RetValue;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static EWin.Lobby.APIResult SetWalletPassword(string SID, string GUID, string LoginPassword, string NewWalletPassword)
    {
        string Token;
        int RValue;
        Random R = new Random();

        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.SetWalletPassword(Token, SID, GUID, LoginPassword, NewWalletPassword);

        return RetValue;
    }

    
}
