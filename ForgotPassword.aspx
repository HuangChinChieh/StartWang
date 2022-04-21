<%@ Page Language="C#" %>
<%
    string PCode = Request["PCode"];

%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="Description" content="12one">
    <title>12万娱乐城</title>
    <!-- Favicon and touch icons -->

    <link rel="shortcut icon" href="/images/12wlogo.png">
    <link rel="icon" sizes="192" href="/images/12wlogo.png">
    <link rel="apple-touch-icon" sizes="32x32" href="/images/ic_192.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/images/ic_192.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/images/ic_192.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/images/ic_192.png">
    <link rel="apple-touch-icon-precomposed" href="/images/ic_192.png">

    <!-- CSS -->
    <link href="css/layout.css" rel="stylesheet" type="text/css">
    <link href="css/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="css/99playfont/99fonts.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="ico/apple-touch-icon-57-precomposed.png">
</head>
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script>
    var c = new common();
    //var LobbyAPIUrl = "<%=EWinWeb.EWinUrl %>" + "/API/LobbyAPI.asmx";
    var apiURL = "/ForgotPassword.aspx";
    var mlp;
    var lang;
    var EWinWebInfo;
    var p;
    var isSent = false;
    var postObj;

    function BackHome() {
        parent.top.API_Home();
    }

    function SendMail() {
        var GUID = Math.uuid();
        var ValidateType = 0;
        var EMail = document.getElementById("idEMail").value;
        var LoginAccount = document.getElementById("idLoginAccount").value;
        var ContactPhonePrefix = '';
        var ContactPhoneNumber = '';
        var GUID = Math.uuid();
        if (EMail != "") {
            if (validateEmail(EMail)) {
                if (isSent)
                    return;

                p.SetUserMail(GUID, 0, 1, EMail, ContactPhonePrefix, ContactPhoneNumber, "", LoginAccount, function (success, o) {
                    if (success) {
                        if (o.Result == 0) {
                            isSent = true;
                            startCountDown(60);
                            alert(mlp.getLanguageKey("已寄送認證碼"));
                        } else {
                            alert(mlp.getLanguageKey("帳號與信箱不符"));
                        }
                    } else {
                        alert(mlp.getLanguageKey("網路錯誤:") + o);
                    }
                });
            }
            else {
                alert(mlp.getLanguageKey("錯誤, 請輸入信箱"));
            }
        }
        else {
            alert(mlp.getLanguageKey("錯誤, 請輸入信箱"));
        }
    }

    function SetNewPassword(validCode, newPassword) {
        var GUID = Math.uuid();
        var ValidateType = 0;
        var EMail = document.getElementById("idEMail").value;
        var ContactPhonePrefix = '';
        var ContactPhoneNumber = '';
        var ValidateCode = validCode;
        var NewPassword = newPassword;

        p.SetUserPasswordByValidateCode(GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber, ValidateCode, NewPassword, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    alert(mlp.getLanguageKey("已成功修改密碼！"));
                    location.reload();
                }
                else {
                    alert(mlp.getLanguageKey("Email或驗證碼錯誤！"));
                }
            } else {
                alert(mlp.getLanguageKey("網路錯誤:") + o);
            }
        });
    }

    function formSubmitCheck() {
        let EMail = document.getElementById("idEMail");
        let ValidCode = document.getElementById("idValidCode");
        let Password = document.getElementById("idNewPassword");
        let retValue = false;

        if (ValidCode.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入認證碼"));
        else if (Password.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入新密碼"));
        else if (Password.value.length != 4)
            alert(mlp.getLanguageKey("請輸入4位數密碼"));
        else if (EMail.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入信箱"));
        else
            retValue = true;

        if (retValue) {
            SetNewPassword(ValidCode.value, Password.value);
        }
    }

    function SetBtnSend() {
        let BtnSend = document.getElementById("btnSend");
        BtnSend.innerText = mlp.getLanguageKey("發送認證信");
        isSent = false;
    }

    function startCountDown(duration) {

        let secondsRemaining = duration;
        let min = 0;
        let sec = 0;

        let countInterval = setInterval(function () {
            let BtnSend = document.getElementById("btnSend");

            min = parseInt(secondsRemaining / 60);
            sec = parseInt(secondsRemaining % 60);
            BtnSend.innerText = sec + "s"

            secondsRemaining = secondsRemaining - 1;
            if (secondsRemaining < 0) {
                clearInterval(countInterval);
                SetBtnSend();
            };

        }, 1000);
    }

    function validateEmail(email) {
        const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                break;
            case "BalanceChange":
                break;
            case "SetLanguage":
                var lang = param;

                mlp.loadLanguage(lang);
                break;
        }
    }

    function init() {
        lang = window.top.API_GetLang();
        EWinWebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {

        });
    }

    window.onload = init;
</script>

<body>
    <!-- HTML START -->
    <div class="wrapper">
        <!-- 註冊頁 -->
            <input type="hidden" name="Lang" value="" />
            <div id="idUserRegister" class="popupFrame">
                <div class="popupWrapper">
                    <div class="popupHeader">
                        <div class="popuptit"><span class="language_replace">忘記密碼</span></div>
                    </div>
                    <div id="idForgotPasswordStep1">
                        <div>
                           <input id="idLoginAccount" type="text" language_replace="placeholder" placeholder="帳號" name="LoginAccount">
                           <input id="idEMail" type="text" language_replace="placeholder" placeholder="信箱" name="EMail">
                           <div class="popupBtn_red" onclick="SendMail()"><span id="btnSend" class="language_replace">發送認證信</span></div>
                           <input id="idValidCode" type="text" language_replace="placeholder" placeholder="請輸入認證碼">
                           <input id="idNewPassword" type="password" language_replace="placeholder" maxlength="4" placeholder="請輸入新密碼">
                           <div class="popupBtn_red" onclick="formSubmitCheck()"><span class="language_replace">確認</span></div>
                        </div>
                    </div>
                </div>
            </div>
    </div>

    <!-- HTML END -->
</body>
</html>
