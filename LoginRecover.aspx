<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LoginRecover.aspx.cs" Inherits="LoginRecover" %>
<%
    GWebAPI.Auth.AuthAPI AuthAPI = new GWebAPI.Auth.AuthAPI();
    RecoverResult ResultObj = new RecoverResult();
    string Token = string.Empty;
    string NewToken = string.Empty;
    string NewRecoverToken = string.Empty;
    string SID = string.Empty;
    string MsgContent = string.Empty;
    string RecoverToken = string.Empty;

    RecoverToken = Request["RecoverToken"];
    Token = Request["Token"];

    if ((string.IsNullOrEmpty(RecoverToken) == false) && (string.IsNullOrEmpty(Token) == false))
    {
        GWebAPI.Auth.LoginResult LoginResult;
        dynamic postObject = null;
        dynamic Result = null;
        string SourceEncString;
        string CustomHeader;
        string WebApiURL = string.Empty;
        string GWebDate = string.Empty;

        // 檢查 Token 是否仍允許使用
        WebApiURL = Web.GWebApiUrl;

        postObject = new System.Dynamic.ExpandoObject();
        postObject.GUID = System.Guid.NewGuid().ToString();
        postObject.Token = Token;
        postObject.SID = "";

        Result = CodingControl.GetWebJSONContent(WebApiURL + "/RefreshSID", "POST", Newtonsoft.Json.JsonConvert.SerializeObject(postObject));
        if (Result.ResultCode != 0)
        {
            // 需要更新 Token
            GWebDate = System.DateTime.UtcNow.ToString("yyyyMMddHHmmss");
            SourceEncString = Web.CompanyCode + ":" + Web.ApiKey + ":" + GWebDate;

            // 重新建立 Token
            postObject = new System.Dynamic.ExpandoObject();
            postObject.GUID = System.Guid.NewGuid().ToString();
            postObject.Hash = CodingControl.GetMD5(SourceEncString, false);

            CustomHeader = "GWeb-CompanyCode: " + Web.CompanyCode + "\r\n" +
                           "GWeb-ApiKey: " + Web.ApiKey + "\r\n" +
                           "GWeb-Date: " + GWebDate;

            Result = CodingControl.GetWebJSONContent(WebApiURL + "/CreateServerToken", "POST", Newtonsoft.Json.JsonConvert.SerializeObject(postObject), CustomHeader);
            if (Result.ResultCode == 0)
            {
                NewToken = Result.Message;
            }
        }
        else
        {
            NewToken = Token;
        }

        if (string.IsNullOrEmpty(NewToken) == false)
        {
            // 嘗試恢復登入狀態
            LoginResult = AuthAPI.RecoverLogin(NewToken, RecoverToken, CodingControl.GetUserIP());
            if (LoginResult != null)
            {
                if (LoginResult.ResultCode == GWebAPI.Auth.enumResultCode.OK)
                {
                    SID = LoginResult.Message;

                    if (string.IsNullOrEmpty(LoginResult.RecoverToken) == false)
                    {
                        NewRecoverToken = LoginResult.RecoverToken;
                    }

                    ResultObj.ResultCode = RecoverResult.enumResultCode.OK;
                    ResultObj.Token = NewToken;
                    ResultObj.SID = SID;
                    ResultObj.RecoverToken = NewRecoverToken;
                }
                else
                {
                    ResultObj.ResultCode = RecoverResult.enumResultCode.ERR;
                    ResultObj.Message = "LoginExpire:" + LoginResult.Message;
                }
            }
            else
            {
                ResultObj.ResultCode = RecoverResult.enumResultCode.ERR;
                ResultObj.Message = "ServerError";
            }
        }
        else
        {
            ResultObj.ResultCode = RecoverResult.enumResultCode.ERR;
            ResultObj.Message = "ServerError";
        }
    }
    else
    {
        ResultObj.ResultCode = RecoverResult.enumResultCode.ERR;
        ResultObj.Message = "InvalidToken";
    }

    Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(ResultObj));
    Response.Flush();
    Response.End();
%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
</body>
</html>
