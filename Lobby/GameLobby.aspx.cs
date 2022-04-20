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

public partial class GameLobby : System.Web.UI.Page
{
    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static EWin.CompanyGameCodeResult GetCompanyGameCode(string GUID)
    //{
    //    string Token;
    //    int RValue;
    //    Random R = new Random();

    //    RValue = R.Next(100000, 9999999);
    //    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

    //    EWin.LobbyAPI lobbyAPI = new EWin.LobbyAPI();
    //    EWin.CompanyGameCodeResult RetValue = null;

    //    RetValue = lobbyAPI.GetCompanyGameCode(Token, GUID);

    //    return RetValue;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static EWin.UserInfoResult GetUserInfo(string SID, string GUID)
    //{
    //    string Token;
    //    int RValue;
    //    Random R = new Random();

    //    RValue = R.Next(100000, 9999999);
    //    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

    //    EWin.LobbyAPI lobbyAPI = new EWin.LobbyAPI();
    //    EWin.UserInfoResult RetValue = null;

    //    RetValue = lobbyAPI.GetUserInfo(Token, SID, GUID);

    //    return RetValue;
    //}

}
