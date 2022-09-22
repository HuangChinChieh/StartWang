<%@ Page Language="C#" %>
<%
    string Token;
    int RValue;
    Random R = new Random();
    bool LoginSuccess = true;
    string WebSID = null;
    string UserIP = CodingControl.GetUserIP();

    if (CodingControl.FormSubmit()) {
        string LoginGUID = Request["LoginGUID"];
        string LoginAccount = Request["LoginAccount"];
        string LoginPassword = Request["LoginPassword"];
        string ValidImg = Request["LoginValidateCode"];
        EWin.LoginResult LoginAPIResult;
        EWin.LoginAPI LoginAPI = new EWin.LoginAPI();

        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        LoginAPIResult = LoginAPI.UserLogin(Token, LoginGUID, LoginAccount, LoginPassword, EWinWeb.CompanyCode, ValidImg, CodingControl.GetUserIP());
        if (LoginAPIResult.ResultState == EWin.enumResultState.OK) {
            Response.SetCookie(new HttpCookie("RecoverToken", LoginAPIResult.RecoverToken) { Expires = System.DateTime.Parse("2038/12/31") });
            Response.SetCookie(new HttpCookie("SID", LoginAPIResult.SID));
            Response.SetCookie(new HttpCookie("CT", LoginAPIResult.CT));
            Response.SetCookie(new HttpCookie("LoginURL", LoginAPIResult.LoginURL));

            Response.Redirect("RefreshParent.aspx?index.aspx?LoginStatus=success");

        } else {
            Response.Redirect("RefreshParent.aspx?index.aspx?LoginStatus=fail&LoginErrMsg=" + LoginAPIResult.Message);
            //Response.Write(LoginAPIResult.Message);
        }
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0">
    <meta name="Description" content="eWin Gaming">
    <title>eWin Gaming</title>

    <!-- CSS -->
    <link href="css/mainStyle.css" rel="stylesheet" type="text/css">
    <link href="css/mediaLayout.css" rel="stylesheet" type="text/css">
    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="ico/apple-touch-icon-57-precomposed.png">
</head>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>

<body>
    <div id="idLoginWindow" class="mainCon" style="display: block;">
        <div class="loginCon">
            <div class="loginDiv">
                <form method="post">
                    <input type="hidden" name="LoginGUID" />
                    <div class="loginDivP1">
                        <img src="images/logoPorLASC.svg">
                    </div>
                    <!-- 未登入 控制出現請使用style="display: block;" -->
                  <%--  <div class="loginDivP2" id="idLoginPage1">
                        <input type="text" placeholder="請輸入帳號" language_replace="placeholder" id="LoginAccount" name="LoginAccount" class="blurBG">
                        <input type="password" placeholder="請輸入密碼" language_replace="placeholder" id="LoginPassword" name="LoginPassword" class="blurBG">
                        <div class="loginBtn blurBG" onclick="showValidateImage()"><span class="language_replace">確認</span></div>
                        <div class="moreHelpDiv">
                            <div class="registerBtn"><span class="language_replace">新會員註冊</span></div>
                            <div class="helpBtn"><span class="language_replace">忘記密碼?</span></div>
                        </div>
                    </div>--%>
                    <!-- 未登入 控制出現請使用style="display: block;" -->
                  <%--  <div class="loginDivP3" id="idLoginPage2" style="display: none;">
                        <div class="ValidImg">
                            <img id="idImgValidateImage">
                            <div class="refreshBtn" onclick="createValidateImage()"></div>
                        </div>
                        <input type="text" placeholder="請輸入上方驗證碼" language_replace="placeholder" id="ValidImg" name="ValidImg">
                        <button type="submit" class="loginBtn"><span class="language_replace">登入</span></button>
                        <div class="loginBtn"><span class="language_replace">取消</span></div>
                    </div>--%>
                </form>
            </div>
        </div>
    </div>
    <div class="mainFooter">
    </div>

</body>
</html>
