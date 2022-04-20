<%@ Page Language="C#"%>
<%
    GWebAPI.Auth.AuthAPI AuthAPI = new GWebAPI.Auth.AuthAPI();
    string Token = string.Empty;
    string RefreshToken = string.Empty;
    string LoginGUID = string.Empty;
    string LoginAccount = string.Empty;
    string LoginPassword = string.Empty;
    string LoginValidateCode = string.Empty;
    string SID = string.Empty;
    int MsgCode = 0;
    string MsgContent = string.Empty;
    string DeviceGUID;

    if (Request.Cookies["DeviceGUID"] != null)
    {
        DeviceGUID = Request.Cookies["DeviceGUID"].Value;
    }
    else
    {
        // create guid
        DeviceGUID = System.Guid.NewGuid().ToString();

        Response.SetCookie(new HttpCookie("DeviceGUID", DeviceGUID) { Expires = System.DateTime.Parse("2038/12/31") });
    }

    if (CodingControl.FormSubmit())
    {
        GWebAPI.Auth.LoginResult LoginResult;
        dynamic postObject = null;
        dynamic Result = null;
        string SourceEncString;
        string CustomHeader;
        string WebApiURL = string.Empty;
        string GWebDate = string.Empty;

        WebApiURL = Web.GWebApiUrl;

        Token = Request["Token"];
        LoginGUID = Request["LoginGUID"];
        LoginValidateCode = Request["LoginValidateCode"];
        LoginAccount = Request["LoginAccount"];
        LoginPassword = Request["LoginPassword"];

        postObject = new System.Dynamic.ExpandoObject();
        postObject.GUID = System.Guid.NewGuid().ToString();
        postObject.Token = Token;
        postObject.SID = "";

        Result = CodingControl.GetWebJSONContent(WebApiURL + "/RefreshSID", "POST", Newtonsoft.Json.JsonConvert.SerializeObject(postObject));
        //判斷原有 SID 是否還有效
        if (Result.ResultCode != 0)
        {
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
                RefreshToken = Result.Message;

                Response.SetCookie(new HttpCookie("Token", RefreshToken));
            }
        }
        else
        {
            RefreshToken = Token;
        }

        LoginResult = AuthAPI.UserLogin(RefreshToken, LoginGUID, GWebAPI.Auth.enumDeviceType.PC, DeviceGUID, LoginAccount, LoginPassword, LoginValidateCode, Request.UserAgent, CodingControl.GetUserIP());
        if (LoginResult != null)
        {
            if (LoginResult.ResultCode == GWebAPI.Auth.enumResultCode.OK)
            {
                MsgCode = 0;
                SID = LoginResult.Message;

                if (string.IsNullOrEmpty(LoginResult.RecoverToken) == false)
                {
                    Response.SetCookie(new HttpCookie("RecoverToken", LoginResult.RecoverToken) { Expires = System.DateTime.Parse("2038/12/31") });
                }
            }
            else
            {
                MsgCode = 1;
                MsgContent = LoginResult.Message;
            }
        }
        else
        {
            MsgCode = 1;
            MsgContent = "服務器異常, 請稍後再嘗試一次";
        }
    }
%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="css/layout.css" rel="stylesheet" type="text/css">
    <link href="css/media-main.css" rel="stylesheet" type="text/css">
    <link href="css/swiper.min.css" rel="stylesheet" type="text/css">
    <link href="css/vegas.css" rel="stylesheet" type="text/css">
    <link href="css/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="css/99playfont/99fonts.css" rel="stylesheet" type="text/css">
</head>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript">
    var msgCode = <%=MsgCode%>;
    var msgContent = "<%=CodingControl.JSEncodeString(MsgContent)%>";
    var SID = "<%=CodingControl.JSEncodeString(SID)%>";
    var mlp;
    var lang;

    function API_ShowMessage(title, msg, cbOK, cbCancel) {
        return showMessage(title, msg, cbOK, cbCancel);
    }

    function API_ShowMessageOK(title, msg, cbOK) {
        return showMessageOK(title, msg, cbOK);
    }

    function showMessage(title, msg, cbOK, cbCancel) {
        var idMessageBox = document.getElementById("idMessageBox");
        var idMessageTitle = document.getElementById("idMessageTitle");
        var idMessageText = document.getElementById("idMessageText");
        var idMessageButtonOK = document.getElementById("idMessageButtonOK");
        var idMessageButtonCancel = document.getElementById("idMessageButtonCancel");

        var funcOK = function () {
            idMessageBox.style.display = "none";

            if (cbOK != null)
                cbOK();
        }

        var funcCancel = function () {
            idMessageBox.style.display = "none";

            if (cbCancel != null)
                cbCancel();
        }

        if (idMessageTitle != null)
            idMessageTitle.innerHTML = title;

        if (idMessageText != null)
            idMessageText.innerHTML = msg;

        if (idMessageButtonOK != null) {
            idMessageButtonOK.style.display = "block";
            idMessageButtonOK.onclick = funcOK;
        }

        if (idMessageButtonCancel != null) {
            idMessageButtonCancel.style.display = "block";
            idMessageButtonCancel.onclick = funcCancel;
        }


        idMessageBox.style.display = "block";
    }

    function showMessageOK(title, msg, cbOK) {
        var idMessageBox = document.getElementById("idMessageBox");
        var idMessageTitle = document.getElementById("idMessageTitle");
        var idMessageText = document.getElementById("idMessageText");
        var idMessageButtonOK = document.getElementById("idMessageButtonOK");
        var idMessageButtonCancel = document.getElementById("idMessageButtonCancel");

        var funcOK = function () {
            idMessageBox.style.display = "none";

            if (cbOK != null)
                cbOK();
        }

        if (idMessageTitle != null)
            idMessageTitle.innerHTML = title;

        if (idMessageText != null)
            idMessageText.innerHTML = msg;

        if (idMessageButtonOK != null) {
            idMessageButtonOK.style.display = "block";
            idMessageButtonOK.onclick = funcOK;
        }

        if (idMessageButtonCancel != null) {
            idMessageButtonCancel.style.display = "none";
        }


        idMessageBox.style.display = "block";
    }

    function init() {
        lang = window.localStorage.getItem("Lang");

        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            switch (msgCode) {
                case 0:
                    // success login
                    window.localStorage.setItem("SID", SID);
                    window.location.href = "index.aspx";

                    break;
                case 1:
                    API_ShowMessageOK(mlp.getLanguageKey("登入失敗"), mlp.getLanguageKey(msgContent), function () {
                        window.location.href = "index.aspx";
                    });
                    break;
            }
        });
    }

    function GWebEventNotify(eventName, isDisplay, o) {
        if (isDisplay) {
            if (eventName == "SetLanguage") {
                lang = o;
                mlp.loadLanguage(lang, function () { });
            }
        }
    }

    window.onload = init;
</script>
<body>
    <div id="idMessageBox" class="popup" style="display: none;">
        <div class="popupWrapper">
            <div class="popupHeader">
                <div class="popuptit"><span id="idMessageTitle">[Title]</span></div>
                <!--<div class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>-->
            </div>
            <!--  -->
            <div class="popupText">
                <span id="idMessageText">[Msg]</span>
            </div>
            <div id="idMessageButtonOK" class="popupBtn_red"><span>OK</span></div>
            <div id="idMessageButtonCancel" class="popupBtn_redOL"><span>Cancel</span></div>
        </div>
    </div>
</body>
</html>
