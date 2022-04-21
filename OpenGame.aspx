<%@ Page Language="C#" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="Description" content="99PLAY">
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
    <link href="css/media-main.css" rel="stylesheet" type="text/css">
    <link href="css/swiper.min.css" rel="stylesheet" type="text/css">
    <link href="css/vegas.css" rel="stylesheet" type="text/css">
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
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script>
    var c = new common();
    var GameCode;
    var CurrencyType;
    var LoginAccount;
    var Token;
    var WalletType;
    var TopWindow;
    var isPC;

    function RefreshGameLogin() {
        var postData = {
            GameCode: GameCode,
            Token: Token,
            CurrencyType: CurrencyType,
            LoginAccount: LoginAccount
        };
        c.callService("<%=Web.GPlatformURL %>/LoginBySID.aspx/RefreshGameLogin", postData, function (success, text) {
            if (success == true) {
                var obj = c.getJSON(text);

                if (obj.ResultCode == 0) {

                } else {
                    showMessageOK(mlp.getLanguageKey("遊戲提醒"), mlp.getLanguageKey("由於遊戲閒置，為保您的權益，確認後將會自動關閉視窗，請重新從大廳再次進入遊戲"), function () {
                        window.close();
                    });
                }
            }
        });

    }

    function UpdateGameLogin(cb) {
        var postData = {
            GameCode: GameCode,
            Token: Token,
            CurrencyType: CurrencyType,
            LoginAccount: LoginAccount
        };
        c.callService("<%=Web.GPlatformURL %>/LoginBySID.aspx/UpdateGameLogin", postData, function (success, text) {
            if (success == true) {
                var obj = c.getJSON(text);

                if (obj.ResultCode == 0) {
                    cb();
                } else {
                    showMessageOK(mlp.getLanguageKey("遊戲提醒"), mlp.getLanguageKey("由於遊戲閒置，為保您的權益，確認後將會自動關閉視窗，請重新從大廳再次進入遊戲"), function () {
                        window.close();
                    });
                }
            }
        });

    }

    function init() {
        isPC = navigator.platform && /Win|Mac|X11|Linux/.test(navigator.platform);


        var Type = c.getParameter("Type");

        if (Type == "0") {
            GameCode = c.getParameter("GameCode");
            CurrencyType = c.getParameter("CurrencyType");
            WalletType = c.getParameter("WalletType");
            LoginAccount = c.getParameter("LoginAccount");
            Token = c.getParameter("Token");
            var SID = c.getParameter("SID");
            var Lang = c.getParameter("Lang");
            var GameLobbyExist = c.getParameter("GameLobbyExist");

            var url = "<%=Web.GPlatformURL %>/LoginBySID.aspx?Token=" + Token
            + "&GameCode=" + GameCode
            + "&CurrencyType=" + CurrencyType
            + "&SID=" + SID + "&Lang=" + Lang + "&SrcUrl=" + location.origin;

            if (GameLobbyExist == "0") {
                //沒有遊戲大廳
                if (WalletType == "1" || GameCode=="AWCSexy" ||  GameCode=="SABA" || GameCode=="99Play") {
                    window.location.href = url;
                } else {
                    document.getElementById('targetFrame').src = url;

                    if (!isPC) {
                        //document.addEventListener("visibilitychange", function (e) {
                        //    if (document.visibilityState == "hidden") {
                        //        window.opener.API_LogoutGame(GameCode, CurrencyType);
                        //        showMessageOK("遊戲提醒", "由於遊戲閒置，為保您的權益，確認後將會自動關閉視窗，請重新從大廳再次進入遊戲", function () {
                        //            window.close();
                        //        })
                        //    }
                        //});

                        window.onpagehide = function (e) {
                            window.opener.API_LogoutGame(GameCode, CurrencyType);
                            return true;
                        };
                    } else {
                        document.getElementById('idBody').onbeforeunload = function (e) {
                            window.opener.API_LogoutGame(GameCode, CurrencyType);
                            return "";
                        };
                    }

                    UpdateGameLogin(function(){
                        setInterval(RefreshGameLogin, 30000);
                    });
                }
            } else {
                document.getElementById('targetFrame').src = url;
            }
        } else if (Type == "1") {
            var url = decodeURIComponent(c.getParameter("Url"));
            GameCode = c.getParameter("GameCode");
            CurrencyType = c.getParameter("CurrencyType");
            WalletType = c.getParameter("WalletType");
            LoginAccount = c.getParameter("LoginAccount");
            Token = c.getParameter("Token");
            if (WalletType == "1") {
                window.location.href = url;
            } else {
                document.getElementById('targetFrame').src = url;

                TopWindow = window.opener.opener;

                if (!isPC) {
                    //document.addEventListener("visibilitychange", function (e) {
                    //    if (document.visibilityState == "hidden") {
                    //        window.opener.API_LogoutGame(GameCode, CurrencyType);
                    //        showMessageOK("遊戲提醒", "由於遊戲閒置，為保您的權益，確認後將會自動關閉視窗，請重新從大廳再次進入遊戲", function () {
                    //            window.close();
                    //        })
                    //    }
                    //});

                    window.onpagehide = function (e) {
                        window.opener.API_LogoutGame(GameCode, CurrencyType);
                        return true;
                    };
                } else {
                    document.getElementById('idBody').onbeforeunload = function (e) {
                        TopWindow.API_LogoutGame(GameCode, CurrencyType);
                        return "";
                    };
                }

                UpdateGameLogin(function () {
                    setInterval(RefreshGameLogin, 30000);
                });
            }

        }
    }


    function MessageListener(e) {
        if (e.data.url) {
            let url = e.data.url;
            var GameWindow = window.open("OpenGame.aspx?Type=1"
                + "&WalletType=" + WalletType
                + "&Url=" + encodeURIComponent(url)
                + "&GameCode=" + GameCode
                + "&LoginAccount=" + LoginAccount
                + "&Token=" + Token
                + "&CurrencyType=" + CurrencyType);
        }
    };

    function ChildWindowLogoutGame() {
        window.opener.API_LogoutGame(GameCode, CurrencyType);
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

    function GWebEventNotify(eventName, isDisplay, o) {
        if (isDisplay) {
            if (eventName == "SetLanguage") {
                lang = o;
                mlp.loadLanguage(lang, function () { });
            }
        }
    }

    window.addEventListener("message", MessageListener, false);
    window.onload = init;
</script>

<body id="idBody">
    <iframe id="targetFrame" style="height: 100%; width: 100%"></iframe>
    
    <!-- 跳出確認框 -->
    <div id="idMessageBox" class="popup" style="display: none;">
        <div class="popupWrapper">
            <div class="popupHeader">
                <div class="popuptit"><span id="idMessageTitle"></span></div>
                <!--<div class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>-->
            </div>
            <!--  -->
            <div class="popupText">
                <span id="idMessageText"></span>
            </div>
            <div id="idMessageButtonOK" class="popupBtn_red"><span>OK</span></div>
            <div id="idMessageButtonCancel" class="popupBtn_redOL"><span>Cancel</span></div>
        </div>
    </div>
</body>
</html>
