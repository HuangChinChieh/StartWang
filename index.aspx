<%@ Page Language="C#" %>

<%
    string Page = Request["Page"];
    string Token = string.Empty;

    Token = Request["Token"];
    if (string.IsNullOrEmpty(Token)) {
        if (string.IsNullOrEmpty(Page) == false)
            Response.Redirect("Init.aspx?Page=" + Server.UrlEncode(Page));
        else
            Response.Redirect("Init.aspx");
    }
%>
<!doctype html>
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
    <link href="css/12onefont/12onefont.css" rel="stylesheet" type="text/css">


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
    <style>
        iframe {
            width: 1px;
            min-width: 100%;
        }
    </style>
</head>
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/qcode-decoder.min.js"></script>
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/jquery.signalR-2.3.0.min.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/GWebHubAPI.js"></script>
<!-- Swiper JS -->
<script src="/Scripts/swiper.min.js"></script>
<script src="/Scripts/jquery.mkinfinite.js"></script>
<script src="/Scripts/vegas.min.js"></script>
<!-- Background Image Swiper-->
<script>
    $(function () {
        $("body").vegas({
            timer: false,
            animation: 'kenburns',
            overlay: true,
            delay: 8000,
            animationDuration: 80000,
            overlay: 'images/overlay-2.png',
            slides: [
                { src: "images/background/01.png" },
                { src: "images/background/02.png" },
                { src: "images/background/03.png" },
                { src: "images/background/04.png" }
            ]
        });
    });
</script>
<script>
    var c = new common();
    var ui = new uiControl();
    var pHubClient;
    var mlp;
    var t1 = null;
    var qr = new QCodeDecoder();
    var lang = "CHS";
    var page = "<%=Page%>";
    var IsTestSite = "<%=Web.IsTestSite%>";
    var needCheckLogin = false;
    var GWebUrl = "<%=Web.GWebURL %>";
    var GWebInfo = {
        Token: "<%=Token%>",
        SID: null,
        GWebUrl: "<%=Web.GWebURL%>",
        DomainURL: null,
        MarqueeText: null,
        UserLogined: false,
        UserRecoverable: false,
        UserInfo: null,
        InAppMode: false,
        DeviceId: null,
        NotifyToken: null,
        DeviceName: null,
        PushType: 0,
        DeviceType: 0,
        GPSLon: null,
        GPSLat: null,
        APPVersion: null,
        CurrencyType: null,
        PCBannerDocumentNumber: null,
        MobileBannerDocumentNumber: null
    };

    function API_GetLang() {
        return lang;
    }

    function API_ShowMessage(title, msg, cbOK, cbCancel) {
        return showMessage(title, msg, cbOK, cbCancel);
    }

    function API_ShowMessageOK(title, msg, cbOK) {
        return showMessageOK(title, msg, cbOK);
    }

    function API_RefreshUserInfo(cb) {
        checkUserLogin(GWebInfo.SID, function (logined) {
            updateBaseInfo();

            notifyWindowEvent("LoginState", logined);

            if (cb != null)
                cb();
        });
    }

    function API_OpenQRCodeScanner(fileInput, cb) {
        if (GWebInfo.InAppMode) {
            AppBridge.openQRCode(function (result) {
                if (cb)
                    cb(result);
            });
        } else {
            if (fileInput != null) {
                if (fileInput.files != null) {
                    if (fileInput.files.length > 0) {
                        var fr = new FileReader();
                        var userImageFile = fileInput.files[0];

                        fr.onload = function () {
                            qr.decodeFromImage(fr.result, function (err, res) {
                                if (cb) {
                                    if (err) {
                                        cb(null);
                                    } else {
                                        cb(res);
                                    }
                                }
                            });
                        }

                        fr.readAsDataURL(userImageFile);
                    }
                }
            }
        }
    }

    function API_ShowCurrencyWindow() {
        var piList;
        var ddList = [];
        var title = mlp.getLanguageKey("可選幣別");
        piList = API_ListCurrencyType();
        for (var i = 0; i < piList.length; i++) {
            var c = piList[i];
            var item = {
                name: c.CurrencyType,
                desc: new BigNumber(c.PointValue).toFormat(),
                value: c.CurrencyType
            };

            ddList[ddList.length] = item;
        }

        API_ShowDropdownWindow(title, ddList, GWebInfo.CurrencyType, function (v) {
            API_SetCurrencyType(v);
            updateBaseInfo();
        }, null);
    }

    function API_ShowDropdownWindow(title, item, defaultValue, cbConfirm, cbCancel) {
        var divDropdownBox = document.getElementById("divDropdownBox");
        var divDropdownTitle = document.getElementById("divDropdownTitle");
        var divDropdownCancel = document.getElementById("divDropdownCancel");

        if (divDropdownBox != null) {
            var divDropdownList = document.getElementById("divDropdownList");

            c.setElementText("divDropdownTitle", null, title);

            c.clearChildren(divDropdownList);
            if (item != null) {
                // name, value, desc
                for (var i = 0; i < item.length; i++) {
                    var eachItem = item[i];
                    var itemValue;
                    var template = c.getTemplate("templateDropdownItem");
                    var inputRadio = c.getFirstClassElement(template, "inputRadio");

                    if (eachItem.value != null)
                        itemValue = eachItem.value;
                    else
                        itemValue = eachItem.name;

                    if (itemValue == defaultValue)
                        inputRadio.checked = true;
                    else
                        inputRadio.checked = false;

                    c.setClassText(template, "title", null, eachItem.name);
                    c.setClassText(template, "desc", null, eachItem.desc);

                    template.setAttribute("ItemValue", itemValue);

                    inputRadio.setAttribute("ItemValue", itemValue);
                    inputRadio.onclick = function () {
                        var v = this.getAttribute("ItemValue");

                        divDropdownBox.style.display = "none";

                        if (cbConfirm != null) {
                            cbConfirm(v);
                        }
                    };

                    divDropdownList.appendChild(template);
                }
            }

            divDropdownCancel.onclick = function () {
                divDropdownBox.style.display = "none";

                if (cbCancel != null) {
                    cbCancel();
                }
            }

            divDropdownBox.style.display = "block";
        }
    }

    function API_Logout() {
        let favoriteGamesStr = window.localStorage.getItem("FavoriteGames");
        GWebInfo.UserInfo = null;
        GWebInfo.UserLogined = false;
        window.localStorage.clear();
        window.sessionStorage.clear();
        if (favoriteGamesStr) {
            window.localStorage.setItem("FavoriteGames", favoriteGamesStr);
        }
        window.location.href = "Refresh.aspx?Init.aspx";
    }

    function API_GetWebInfo() {
        return GWebInfo;
    }

    function API_SetCurrencyType(c) {
        var pi = API_GetCurrencyType(c);

        if (pi != null) {
            GWebInfo.CurrencyType = c;
            window.localStorage.setItem("CurrencyType", c);

            notifyWindowEvent("SetCurrencyType", c);
        }

        //updateWalletList();
        updateBaseInfo();
    }

    function API_ListCurrencyType() {
        var pi = null;

        if (GWebInfo.UserLogined == true) {
            if (GWebInfo.UserInfo != null) {
                if (GWebInfo.UserInfo.PointInfo != null) {
                    pi = GWebInfo.UserInfo.PointInfo;
                }
            }
        }

        return pi;
    }

    function API_GetCurrencyType(c) {
        var pi = null;

        if (c != null) {
            if (GWebInfo.UserLogined == true) {
                if (GWebInfo.UserInfo != null) {
                    if (GWebInfo.UserInfo.PointInfo != null) {
                        for (var i = 0; i < GWebInfo.UserInfo.PointInfo.length; i++) {
                            var walletInfo = GWebInfo.UserInfo.PointInfo[i];

                            if (walletInfo.CurrencyType.toUpperCase() == c.toUpperCase()) {
                                pi = walletInfo;
                                break;
                            }
                        }
                    }
                }
            }
        }

        return pi;
    }

    function API_GetSelCurrencyType() {
        return API_GetCurrencyType(document.getElementById("idCurrencyType").innerText);
    }

    function API_GetGWebHubAPI(newInst) {
        var retValue;


        if (newInst == true) {
            retValue = new GWebHubAPI(GWebInfo.GWebUrl, GWebInfo.Token);
        } else {
            retValue = pHubClient;
        }

        return retValue;
    }

    function API_ShowMask(text, scope, cbClick) {
        var PageMain = document.getElementById("PageMain");
        var fullScope = false;

        if (scope != null) {
            if ((scope == true) || (scope == "f") || (scope == "full"))
                fullScope = true;
        }

        if (fullScope == false)
            ui.showMask(PageMain, text, cbClick);
        else
            ui.showMask(null, text, cbClick);
    }

    function API_HideMask() {
        ui.hideMask();
    }

    function API_LoadPage(url) {
        var IFramePage = document.getElementById("IFramePage");
        var iFrame = document.createElement("IFRAME");

        iFrame.scrolling = "auto";
        iFrame.border = "0";
        iFrame.frameBorder = "0";
        iFrame.marginWidth = "0";
        iFrame.marginHeight = "0";
        iFrame.src = url;

        c.clearChildren(IFramePage);
        IFramePage.appendChild(iFrame);

        //mobile remove
        document.getElementById("dropdownDiv").classList.remove("dropdownDiv-down");
    }

    function API_OpenGame(GameCode, GameLobbyExist, WalletType) {
        var PointInfo = API_GetSelCurrencyType();

        if (PointInfo.PointValue > 0) {
            var gameWindow = window.open("OpenGame.aspx?Type=0&Token=" + GWebInfo.Token + "&GameCode=" + GameCode + "&CurrencyType=" + PointInfo.CurrencyType + "&SID=" + GWebInfo.SID + "&Lang=" + lang + "&GameLobbyExist=" + GameLobbyExist + "&WalletType=" + WalletType + "&LoginAccount=" + GWebInfo.UserInfo.LoginAccount);
            //gameWindow.GameCode = GameCode;
            //gameWindow.CurrencyType = PointInfo.CurrencyType;
            //gameWindow.onbeforeunload = function () {
            //    API_LogoutGame(this.GameCode, this.CurrencyType);
            //    return "test";
            //};
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("提醒"), mlp.getLanguageKey("餘額不足進行遊戲，請至充值提款進行充值。"), null);
        }
    }

    function API_OpenPayment(Url) {
        var paymentWindow = window.open("OpenPayment.aspx?Url=" + encodeURIComponent(Url));
    }

    function API_LogoutGame(GameCode, CurrencyType) {
        var common = window.top.c;
        var postData = {
            GameCode: GameCode,
            Token: GWebInfo.Token,
            SID: GWebInfo.SID,
            CurrencyType: CurrencyType
        };
        common.callService("<%=Web.GPlatformURL %>/LoginBySID.aspx/LogoutBySID", postData, function (success, text) {
            if (success == true) {
                var obj = c.getJSON(text);

                if (obj.ResultCode == 0) {

                }
            }
        });

    }

    //function notifyWindowEvent(eventName, o) {
    //    var iFrameList = document.getElementsByTagName("IFRAME");

    //    for (i = 0; i < iFrameList.length; i++) {
    //        var divInnerFrame = iFrameList[i];

    //        if (divInnerFrame) {
    //            if (divInnerFrame.contentWindow) {
    //                if (divInnerFrame.contentWindow.GWebEventNotify) {
    //                    try { divInnerFrame.contentWindow.GWebEventNotify(eventName, true, o); }
    //                    catch (ex) { }
    //                }
    //            }
    //        }
    //    }
    //}

    function notifyWindowEvent(eventName, o) {
        var IFramePage = document.getElementById("IFramePage");

        if (IFramePage != null) {
            if (IFramePage.children.length > 0) {
                for (var _i = 0; _i < IFramePage.children.length; _i++) {
                    var el = IFramePage.children[_i];

                    if (el != null) {
                        if (el.tagName.toUpperCase() == "IFRAME".toUpperCase()) {
                            if (el.contentWindow) {
                                if (el.contentWindow.EWinEventNotify) {
                                    var isDisplay = false;

                                    if ((el.style.display.toUpperCase() == "block".toUpperCase()) ||
                                        (el.style.display.toUpperCase() == "inline".toUpperCase()) ||
                                        (el.style.display.toUpperCase() == "inline-block".toUpperCase()))
                                        isDisplay = true;

                                    try { el.contentWindow.EWinEventNotify(eventName, isDisplay, o); }
                                    catch (ex) { }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function userRecover(cb) {
        function getCookie(cname) {
            var name = cname + "=";
            var decodedCookie = decodeURIComponent(document.cookie);
            var ca = decodedCookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }

        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toUTCString();
            document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        }

        var recoverToken = getCookie("RecoverToken");

        if ((recoverToken != null) && (recoverToken != "")) {
            var postData;

            API_ShowMask(mlp.getLanguageKey("登入復原中"), "full");
            postData = encodeURI("Token=" + GWebInfo.Token + "&RecoverToken=" + recoverToken);
            c.callService("/LoginRecover.aspx?" + postData, null, function (success, o) {
                API_HideMask();

                if (success) {
                    var obj = c.getJSON(o);

                    if (obj.ResultCode == 0) {
                        GWebInfo.Token = obj.Token;
                        GWebInfo.SID = obj.SID;

                        pHubClient.SetToken(obj.Token);

                        setCookie("RecoverToken", obj.RecoverToken, 365);

                        API_RefreshUserInfo(function () {
                            updateBaseInfo();

                            if (cb)
                                cb(true);
                        });
                    } else {
                        GWebInfo.UserLogined = false;

                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請重新登入。") + obj.Message, function () {
                            //API_LoadMainPage("Login");
                            API_Logout();
                        });

                        if (cb)
                            cb(false);
                    }
                } else {
                    if (o == "Timeout") {
                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("服務器異常, 請稍後再嘗試一次"));
                    } else {
                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }

                    if (cb)
                        cb(false);
                }
            });
        }
    }

    function showMessage(title, msg, cbOK, cbCancel) {
        var idMessageBox = document.getElementById("idMessageBox");
        var idMessageTitle = document.getElementById("idMessageTitle");
        var idMessageText = document.getElementById("idMessageText");
        var idMessageWrapper = document.getElementById("idMessageWrapper");

        var tempBtns = idMessageBox.getElementsByClassName("tempMessageBtn")
        while (tempBtns.length > 0) {
            tempBtns[0].remove();
        }


        var idMessageButtonOK = document.createElement("div");
        idMessageButtonOK.innerHTML = "<span>OK</span>"
        idMessageButtonOK.classList.add("popupBtn_red")
        idMessageButtonOK.classList.add("tempMessageBtn")

        var idMessageButtonCancel = document.createElement("div");
        idMessageButtonCancel.innerHTML = "<span>Cancel</span>"
        idMessageButtonCancel.classList.add("popupBtn_redOL")
        idMessageButtonCancel.classList.add("tempMessageBtn")

        idMessageWrapper.appendChild(idMessageButtonOK);
        idMessageWrapper.appendChild(idMessageButtonCancel);

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
        var idMessageWrapper = document.getElementById("idMessageWrapper");


        var tempBtns = idMessageBox.getElementsByClassName("tempMessageBtn")
        while (tempBtns.length > 0) {
            tempBtns[0].remove();
        }

        var idMessageButtonOK = document.createElement("div");
        idMessageButtonOK.innerHTML = "<span>OK</span>"
        idMessageButtonOK.classList.add("popupBtn_red")
        idMessageButtonOK.classList.add("tempMessageBtn")



        idMessageWrapper.appendChild(idMessageButtonOK);


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

        idMessageBox.style.display = "block";
    }

    function checkUserLogin(SID, cb) {
        var guid = Math.uuid();

        pHubClient.GetUserInfo(SID, guid, function (success, o) {
            if (success) {
                if (o.ResultCode == 0) {
                    GWebInfo.SID = SID;
                    GWebInfo.UserLogined = true;
                    GWebInfo.UserInfo = o;

                    if (GWebInfo.UserInfo.Company != null) {
                        GWebInfo.DomainURL = GWebInfo.UserInfo.Company.DomainURL;
                        GWebInfo.MarqueeText = GWebInfo.UserInfo.Company.MarqueeText;
                        GWebInfo.PCBannerDocumentNumber = GWebInfo.UserInfo.Company.PCBannerDocumentNumber;
                        GWebInfo.MobileBannerDocumentNumber = GWebInfo.UserInfo.Company.MobileBannerDocumentNumber;


                    }

                    if ((GWebInfo.CurrencyType == null) || (GWebInfo.CurrencyType == "")) {
                        if (GWebInfo.UserInfo.PointInfo != null) {
                            if (GWebInfo.UserInfo.PointInfo.length > 0) {
                                GWebInfo.CurrencyType = GWebInfo.UserInfo.PointInfo[0].CurrencyType;
                            }
                        }
                    }

                    if (cb)
                        cb(true);
                } else {
                    if ((o.Message == "InvalidSID") || (o.Message == "InvalidToken")) {
                        // login fail
                        GWebInfo.UserLogined = false;
                    } else {
                        GWebInfo.UserLogined = false;

                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o.Message);
                    }

                    if (cb)
                        cb(false);
                }
            }
        });
    }

    function updateBaseInfo() {
        var idUserNotLogin = document.getElementById("idUserNotLogin");
        var idUserLogined = document.getElementById("idUserLogined");
        var idHeaderCon = document.getElementById("header-con");

        if (GWebInfo.UserLogined) {
            var pi;

            pi = API_GetCurrencyType(GWebInfo.CurrencyType);

            idUserNotLogin.style.display = "none";
            idUserNotLogin.classList.remove("NotLogin");
            idUserLogined.style.display = "block";
            idHeaderCon.classList.add("login");

            c.setElementText("idUserLevel", null, GWebInfo.UserInfo.UserLevel);
            //c.setElementText("idRealName", null, GWebInfo.UserInfo.RealName);
            c.setElementText("idNickName", null, GWebInfo.UserInfo.NickName);

            if (pi != null) {
                var idCurrencyType = document.getElementById("idCurrencyType");
                var idBalance = document.getElementById("idBalance");

                idCurrencyType.innerText = pi.CurrencyType;
                idBalance.innerText = "$" + new BigNumber(pi.PointValue).toFormat();
            }

        } else {
            idUserNotLogin.style.display = "block";
            idUserNotLogin.classList.add("NotLogin");
            idUserLogined.style.display = "none";
        }


    }

    function init() {
        GWebInfo.SID = window.localStorage.getItem("SID");
        if (window.localStorage.getItem("CurrencyType") != null)
            GWebInfo.CurrencyType = window.localStorage.getItem("CurrencyType");

        if (window.localStorage.getItem("Lang") != null)
            lang = window.localStorage.getItem("Lang");


        //語系介面初始化 
        //----start----
        setLangIcon(lang);
        var opts = document.getElementsByName("button-langExchange");
        for (var i = 0; i < opts.length; i++) {
            var opt = opts[i];

            if (opt.dataset.lang == lang) {
                opt.checked = true;
                break;
            }
        }

        //----end----


        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            pHubClient = new GWebHubAPI(GWebInfo.GWebUrl, GWebInfo.Token);

            // 設定 SignalR 事件
            // handleReceiveMsg: 收到伺服器傳回訊息
            // handleConnected: 連線完成
            // handleReconnected: 重新連線完成
            // handleReconnecting: 重新連線中
            // handleDisconnect: 斷線
            pHubClient.handleReceiveMsg(function (o) {
            });

            pHubClient.handleConnected(function () {
                needCheckLogin = true;
                pHubClient.RefreshSID(GWebInfo.SID, Math.uuid());

                if ((page != null) && (page != ""))
                    API_LoadPage(page);
                else
                    API_LoadPage("home.aspx");

                if (t1 != null) {
                    window.clearInterval(t1);
                }

                t1 = window.setInterval(function () {
                    // refresh SID and Token;
                    var guid = Math.uuid();

                    if (pHubClient.state() == 1) {
                        pHubClient.RefreshSID(GWebInfo.SID, guid, function (success, o) {
                            //console.log("RefreshSID:" + guid);
                            if (success == true) {
                                if (o.ResultCode == 0) {
                                    needCheckLogin = true;
                                    //needCheckLogin = true;
                                } else {
                                    if ((GWebInfo.SID != null) && (GWebInfo.SID != "")) {
                                        needCheckLogin = true;
                                    }
                                }
                            }
                        });
                    }
                }, 10000);
            });

            pHubClient.handleReconnected(function () {
            });

            pHubClient.handleReconnecting(function () {
            });

            pHubClient.handleDisconnect(function () {
            });

            pHubClient.handleStateChange(function (newState, oldState) {
                switch (pHubClient.state()) {
                    case 0:
                        break;
                    case 1:
                        API_HideMask();
                        break;
                    case 2:
                        API_ShowMask(mlp.getLanguageKey("重新連線中..."), "full");
                        break;
                    case 4:
                        API_ShowMask(mlp.getLanguageKey("服務器連線中斷"), "full");
                        break;
                }
            });

            pHubClient.initializeConnection();

            if (IsTestSite != "True") {
                var tryitBtn = document.getElementById("tryitBtn");
                tryitBtn.style.display = "none";
            }

            window.setInterval(function () {
                if (needCheckLogin == true) {
                    needCheckLogin = false;

                    if ((GWebInfo.SID != null) && (GWebInfo.SID != "")) {
                        checkUserLogin(GWebInfo.SID, function (success) {
                            if (success == true) {
                                updateBaseInfo();
                            } else {
                                userRecover();
                            }
                        });
                    } else {
                        updateBaseInfo();
                    }
                }
            }, 500);
        });

        //API_ShowMessageOK("錯誤", "請輸入登入帳號");
        //API_ShowDropdownWindow("測試", [{ name: "a1", desc: "1", value: "1" }, { name: "a2", desc: "2", value: "2" }], "2", function (v) { alert(v); }, null);

        resize();
        setInterval(function () {
            resize();
        }, 500);

        window.localStorage.setItem("Lang", lang);
    }

    function resize() {
        var IFramePage = document.getElementById("IFramePage");
        var idFrameContent = null;

        // resize iframe
        if (IFramePage != null) {
            if (IFramePage.children.length > 0) {
                for (var i = 0; i < IFramePage.children.length; i++) {
                    var el = IFramePage.children[i];

                    if (el.tagName.toUpperCase() == "IFRAME") {
                        idFrameContent = el;
                        break;
                    }
                }
            }
        }

        if (idFrameContent != null) {
            idFrameContent.width = document.body.scrollWidth;

            if (idFrameContent.contentWindow != null) {
                var iframeDocument = null;

                try {
                    iframeDocument = idFrameContent.contentWindow.document;
                } catch (ex) {
                }

                if (iframeDocument != null) {
                    if (iframeDocument.body != null) {
                        idFrameContent.height = iframeDocument.body.scrollHeight;
                    }
                }
            }
        }
    }

    function openSelLanguage() {
        document.getElementById("idSelLang").style.display = "block";
    }

    function closeSelLanguage() {
        document.getElementById("idSelLang").style.display = "none";
    }

    function confirmSelLanguage() {
        var opts = document.getElementsByName("button-langExchange");
        var selLang;
        for (var i = 0; i < opts.length; i++) {
            var opt = opts[i];

            if (opt.checked) {
                selLang = opt.dataset.lang;
                break;
            }
        }

        selectLanguage(selLang);
        document.getElementById("idSelLang").style.display = "none";
    }

    function setLangIcon() {
        var switchLangs = document.getElementsByClassName("SwitchLang");

        for (var i = 0; i < switchLangs.length; i++) {
            var switchLang = switchLangs[i];
            switchLang.className = "";
            switchLang.classList.add("btn");
            switchLang.classList.add("btn-icon-round");
            switchLang.classList.add("SwitchLang");

            switch (lang) {
                case "CHT":
                    switchLang.classList.add("ico-before-flag-hk");
                    break;
                case "CHS":
                    switchLang.classList.add("ico-before-flag-cn");
                    break;
                case "JPN":
                    switchLang.classList.add("ico-before-flag-jp");
                    break;
                case "EN":
                    switchLang.classList.add("ico-before-flag-en");
                    break;
                case "KOR":
                    switchLang.classList.add("ico-before-flag-kr");
                    break;
                case "VN":
                    switchLang.classList.add("ico-before-flag-vn");
                    break;
                case "IND":
                    switchLang.classList.add("ico-before-flag-in");
                    break;
            }
        }
    }

    function selectLanguage(selLang) {
        lang = selLang
        mlp.loadLanguage(lang, function () {
            setLangIcon();
            notifyWindowEvent("SetLanguage", lang);
            window.localStorage.setItem("Lang", lang);
        });
    }

    function dropdownFunction() {
        var elementdiv = document.getElementById("dropdownDiv");
        var elementbtn = document.getElementById("dropdownDiv-btn");
        elementdiv.classList.toggle("dropdownDiv-down");
        elementbtn.classList.toggle("dropdownDiv-btn-press");
    }

    window.onload = init;
</script>
<script>
    function CreateLoginValidateCode() {
        c.callService("CreateAuthCode.aspx", null, function (success, text) {
            if (success == true) {
                var o = c.getJSON(text);

                if (o.ResultCode == 0) {
                    var idValidImage = document.getElementById("idLoginValidImage");
                    var idFormUserLogin = document.getElementById("idFormUserLogin");

                    idFormUserLogin.LoginGUID.value = o.LoginGUID;

                    if (idValidImage != null) {
                        idValidImage.src = o.ImageContent;
                        idValidImage.style.display = "block";
                    }
                } else {
                    API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (text == "Timeout") {
                    API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("網路異常, 請再嘗試一次"));
                } else {
                    alert(text);
                }
            }
        });
    }

    function btnConfirmLogout() {
        API_ShowMessage(mlp.getLanguageKey("登出"), mlp.getLanguageKey("確定要登出?"), function () {
            API_Logout();
        })
    }

    function onBtnMemberCenter() {
        if (GWebInfo.UserLogined) {
            API_LoadPage("memberCenter.aspx");
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"));
        }
    }

    function onBtnHistory() {
        if (GWebInfo.UserLogined) {
            API_LoadPage("history.aspx");
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"));
        }
    }

    function onBtnChat() {
        if (GWebInfo.UserLogined) {
            window.open("ChatMain.aspx?Token=" + GWebInfo.Token + "&SID=" + GWebInfo.SID + "&Acc=" + GWebInfo.UserInfo.LoginAccount);
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"));
        }
    }


    function onBtnPaymentDeposit() {
        if (GWebInfo.UserLogined) {
            //window.open(GWebUrl + "/API/Payment/GpayDeposit.aspx?Token=" + GWebInfo.Token + "&SID=" + GWebInfo.SID, "_blank");
            API_LoadPage("mywallet.aspx");
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"));
        }
    }

    function onBtnUserRegisterShow() {
        API_LoadPage("register.aspx");
    }

    function onBtnLoginStep2() {
        var form = document.getElementById("idFormUserLogin");
        var allowSubmit = true;

        if (form.LoginAccount.value == "") {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入帳號"));
            allowSubmit = false;
        } else if (form.LoginPassword.value == "") {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入密碼"));
            allowSubmit = false;
        } else if (form.LoginValidateCode.value == "") {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入圖片驗證碼"));
            allowSubmit = false;
        }

        if (allowSubmit) {
            form.action = "UserLogin.aspx";
            form.submit();
        }
    }

    function onBtnLoginStep1() {
        var form = document.getElementById("idFormUserLogin");

        if (form.LoginAccount.value == "") {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入帳號"));
        } else if (form.LoginPassword.value == "") {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入密碼"));
        } else {
            var idUserLoginStep1 = document.getElementById("idUserLoginStep1");
            var idUserLoginStep2 = document.getElementById("idUserLoginStep2");

            CreateLoginValidateCode();

            idUserLoginStep1.style.display = "none";
            idUserLoginStep2.style.display = "block";
        }
    }

    function onBtnLoginShow() {
        var idLoginBox = document.getElementById("idLoginBox");

        idLoginBox.style.display = "block";
    }

    function onBtnLoginHide() {
        var idLoginBox = document.getElementById("idLoginBox");

        idLoginBox.style.display = "none";
    }

    function onBtnTryIt() {
        var p = API_GetGWebHubAPI();

        if (p != null) {
            p.UserTryItLogin(Math.uuid(), function (success, o) {
                if (success) {
                    if (o.ResultCode == 0) {
                        var expires = new Date('31 Dec 2038 00:00:00 PDT').toUTCString();

                        document.cookie = "DeviceGUID=" + o.DeviceGUID + ";" + expires + ";path=/";
                        document.cookie = "RecoverToken=" + o.RecoverToken + ";" + expires + ";path=/";

                        window.localStorage.setItem("SID", o.SID);
                        window.location.reload();
                    } else {
                        API_ShowMessageOK(mlp.getLanguageKey(""), mlp.getLanguageKey("目前試玩次數已額滿，請稍後在試"));
                    }
                } else {
                    if (o == "Timeout") {
                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    } else {
                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }
            });
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                window.top.location.href = "index.aspx";
            });
        }
    }

    function openServiceChat() {
        var idChatDivE = document.getElementById("idChatDiv");
        var idChatFrameParent = document.getElementById("idChatFrameParent");
        var idChatFrame = document.createElement("IFRAME");

        if (idChatDivE.classList.contains("show")) {
            idChatDivE.classList.remove("show");
            idChatFrameParent.style.display = "none";
        }
        else {
            //<iframe id="idChatFrame" name="idChatFrame" class="ChatFrame" border="0" frameborder="0" marginwidth="0" marginheight="0" allowtransparency="no" scrolling="no"></iframe>
            if (idChatDivE.getAttribute("isLoad") != "1") {
                idChatDivE.setAttribute("isLoad", "1");
                idChatFrame.id = "idChatFrame";
                idChatFrame.name = "idChatFrame";
                idChatFrame.className = "ChatFrame";
                idChatFrame.border = "0";
                idChatFrame.frameBorder = "0";
                idChatFrame.marginWidth = "0";
                idChatFrame.marginHeight = "0";
                idChatFrame.allowTransparency = "no";
                idChatFrame.scrolling = "no";

                idChatFrameParent.appendChild(idChatFrame);

                //idChatFrame.src = EWinWebInfo.EWinUrl + "/Game/ChatMain.aspx?SID=" + EWinWebInfo.SID + "&Acc=" + EWinWebInfo.UserInfo.LoginAccount;
                //alert(EWinWebInfo.LoginURL);
                idChatFrame.src = EWinWebInfo.LoginURL + "?CT=" + encodeURIComponent(EWinWebInfo.CT) + "&Lang=" + EWinWebInfo.Lang + "&Action=Chat";

            }

            idChatFrameParent.style.display = "";
            c.addClassName(idChatDivE, "show");

        }

    }

    // 存款
    function openPaymentDeposit(dt) {
        var retPage = "";
        //dt = 0: 四方/1=區塊鏈/2=銀行轉帳/3=代理
        switch (dt) {
            case 0:
                window.open(EWinWebInfo.EWinUrl + "/Payment/VPay/VPayDeposit.aspx?SID=" + EWinWebInfo.SID, "_blank");
                break;
            case 1:
                //openBitCoinAddress();
                break;
            case 2:
                retPage = "iType=BackCardIN&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + selectedCurrency;
                API_LoadPage("/Payment/BankCard/BankCard_In.aspx?" + retPage);
                break;
                case 4:
                 window.open("/Payment/Wallet_GCASH_PHP.aspx?SID=" + EWinWebInfo.SID + "&CurrencyType=" + selectedCurrency , "_blank");
                break;

        }
    }

    // 提款
    function openPaymentWithdrawal(wt) {
        //wt = 0: 四方/1=區塊鏈
        switch (wt) {
            case 0:
                window.open(EWinWebInfo.EWinUrl + "/Payment/GPay/GPayWithdraw.aspx?SID=" + EWinWebInfo.SID);
                break;
            case 1:
                //openBitCoinAddress();
                break;
            case 2:
                retPage = "iType=BackCardOut&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + selectedCurrency;
          
                API_LoadPage("/Payment/BankCard/BankCard_Out.aspx?" + retPage);
                break;
            case 3:
                openParentOut();
                break;


        }
    }
</script>
<body>
    <!-- HTML START -->
    <div class="wrapper">
        <!-- wrapper -->
        <div class="header-con" id="header-con">
            <div class="header">
                <!--  未登入版頭 -->
                <div id="idUserNotLogin" class="header-tit_none">
                    <div class="header-tit-con">
                        <div class="box btnTypeA loginBrn_div">
                            <!-- 
                            請在"語系" 的 button 加入 每個語系 的對應 class：
                            
                                1.簡體中文：ico-before-flag-cn
                                2.繁體中文：ico-before-flag-hk
                                3.日文：ico-before-flag-jp
                                4.英文：ico-before-flag-en
                                5.韓文：ico-before-flag-kr
                                6.越南文：ico-before-flag-vn
                                7.印度文：ico-before-flag-in
                         -->
                            <button onclick="openSelLanguage()" type="button" class="btn btn-icon-round ico-before-flag-hk SwitchLang" role="button" data-toggle="modal" data-target="">語系</button>
                            <%--<button type="button" class="btn btn-customerservice btn-icon-round icon-service" id="" role="button" data-toggle="modal" data-target="" onclick="">客服</button>--%>
                            <button type="button" class="box btn btn-gradient-golden" id="tryitBtn" role="button" data-toggle="modal" data-target="" onclick="onBtnTryIt();"><i class="icon icon12one-ico-poker icon-large" aria-hidden="true"></i><span class="language_replace">搶先試玩</span></button>
                            <button type="button" class="box btn btn-default" id="loginBtn" role="button" data-toggle="modal" data-target="#idLoginImage" onclick="onBtnLoginShow();"><i class="fa fa-sign-out fa-1x" aria-hidden="true"></i><span class="language_replace">登入</span></button>
                            <button type="button" class="btn btn-info" id="signinBtn" role="button" data-toggle="modal" data-target="#myModal" onclick="onBtnUserRegisterShow();"><i class="fa fa-address-card fa-1x" aria-hidden="true"></i><span class="language_replace">註冊</span></button>
                        </div>
                    </div>
                </div>
                <!--  已登入版頭 -->
                <div id="idUserLogined" class="header-tit" style="display: none;">
                    <div class="header-tit-info">
                        <div id="idUserLevel" class="user-level">VIP 9</div>
                        <div id="idNickName" class="user-ID">SeanYu888 </div>
                    </div>
                    <div class="header-tit-point-wrapper">
                        <div class="header-tit-point">
                            <div class="header-tit-point-bg">
                                <div id="idCurrencyType" class="box user-pointType">[Cur]</div>
                                <div id="idBalance" class="box user-pointV">[Balance]</div>
                                <div onclick="API_ShowCurrencyWindow('可選幣別');" class="box user-pointTypeSwitch"><a class="language_replace">切換</a></div>
                            </div>
                        </div>
                    </div>

                    <!-- Header 右上角 -->
                    <div class="header-tit-user-login-wrapper">

                        <!-- 
                            請在"語系" 的 button 加入 每個語系 的對應 class：
                            
                                1.簡體中文：ico-before-flag-cn
                                2.繁體中文：ico-before-flag-hk
                                3.日文：ico-before-flag-jp
                                4.英文：ico-before-flag-en
                                5.韓文：ico-before-flag-kr
                                6.越南文：ico-before-flag-vn
                                7.印度文：ico-before-flag-in
                         -->
                        <button onclick="openSelLanguage()" type="button" class="btn btn-icon-round ico-before-flag-hk SwitchLang" role="button" data-toggle="modal" data-target="">語系</button>
                        <button type="button" class="btn btn-customerservice btn-icon-round icon-service language_replace" id="" role="button" data-toggle="modal" data-target="" onclick="onBtnChat()">客服</button>


                        <div onclick="btnConfirmLogout();" class="box btn-logout btnTypeA">
                            <button class="btn-default"><i class="fa fa-sign-out fa-1x" aria-hidden="true"></i><span class="language_replace">登出</span></button>
                        </div>
                        <!--<div class="box user-email"><a><span class="fa fa-envelope" aria-hidden="true"></span> 信箱<i>10</i></a></div>-->
                    </div>

                </div>
                <div class="header-nav clearfix">
                    <div class="box header-nav-logo">
                        <img src="images/logo.png" alt="99play_logo">
                    </div>
                    <div class="box header-nav-menu" id="dropdownDiv">
                        <div onclick="dropdownFunction()" id="dropdownDiv-btn" class="dropdown-btn"><a class="fa fa-bars" aria-hidden="true"></a></div>
                        <ol>
                            <li><a onclick="API_LoadPage('home.aspx')"><span class="fa fa-home" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">回首頁</div>
                            </a></li>
                            <li><a onclick="API_LoadPage('gameLobby.aspx')"><span class="icon icon-icon-poker" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">遊戲大廳</div>
                            </a></li>
                            <li><a onclick="openPaymentDeposit(2);"><span class="icon icon-icon-topup" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">充值</div>
                            </a></li>
                            <li><a onclick="openPaymentWithdrawal(2);"><span class="icon icon-icon-topup" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">取款</div>
                            </a></li>
                            <li><a onclick="onBtnHistory();"><span class="icon icon-icon-map" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">紀錄查詢</div>
                            </a></li>
                            <%--<li><a><span class="icon icon-icon-priceoff" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">最新優惠</div>
                            </a></li>
                            <li><a><span class="icon icon-icon-map" aria-hidden="true"></span>
                                <br>
                                新手教學</a></li>--%>
                            <li><a onclick="onBtnMemberCenter();"><span class="icon icon-icon-logo" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">會員中心</div>
                            </a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <!-- Content -->
        <div id="IFramePage" class="DivContent">
            <iframe id="idFrameContent" scrolling="auto" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
        </div>
        <!-- 頁尾 -->
        <div class="main-footer">.</div>



    </div>
    <!-- wrapper END -->

    <!-- 跳出視窗 -->
    <!-- 登入頁 -->
    <div id="idLoginBox" class="popup" style="display: none;">
        <form method="post" id="idFormUserLogin">
            <input type="hidden" name="LoginGUID" value="" />
            <div class="popupWrapper">
                <div class="popupHeader">
                    <div class="popuptit"><span class="language_replace">會員登入</span></div>
                    <div onclick="onBtnLoginHide()" class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>
                </div>
                <!-- 第一步 -->
                <div id="idUserLoginStep1" class="">
                    <input type="text" language_replace="placeholder" placeholder="輸入帳號" name="LoginAccount">
                    <input type="password" language_replace="placeholder" placeholder="輸入密碼" name="LoginPassword">
                    <div onclick="onBtnLoginStep1();" class="popupBtn_red"><span class="language_replace">登入</span></div>
                    <div class="popupBtn_redOL"><span class="language_replace">忘記密碼</span></div>
                </div>
                <!-- 第二步 -->
                <div id="idUserLoginStep2" class="" style="display: none;">
                    <div class="ValidateDiv">
                        <div class="ValidateImg">
                            <img id="idLoginValidImage" style="display: none" alt="" />
                            <div class="popupBtn_reF"><span class="fa fa-refresh fa-1x"></span></div>
                        </div>
                        <input type="text" name="LoginValidateCode" language_replace="placeholder" placeholder="輸入驗證碼" autocomplete="off">
                    </div>
                    <div onclick="onBtnLoginStep2();" class="popupBtn_red"><span class="language_replace">確認</span></div>
                </div>
            </div>
        </form>
    </div>
    <!-- 註冊頁 -->
    <div id="idUserRegister" class="popup" style="display: none;">
        <form method="post" id="idFormRegister">
            <input type="hidden" name="LoginGUID" value="" />
            <div class="popupWrapper">
                <div class="popupHeader">
                    <div class="popuptit"><span class="language_replace">會員註冊</span></div>
                    <div class="popupBtn_close" onclick="onBtnUserRegisterClose()"><span class="fa fa-close fa-1x"></span></div>
                </div>
                <!-- 第一步 -->
                <div id="idUserRegStep1">
                    <input type="text" class="" language_replace="placeholder" placeholder="輸入帳號" id="idNewAccount">
                    <input type="password" class="" language_replace="placeholder" placeholder="輸入密碼" id="idNewPassword">
                    <input type="password" class="" language_replace="placeholder" placeholder="確認密碼" id="idNewPassword2">
                    <div class="popupBtn_red" onclick="onBtnUserRegisterStep1()"><span class="language_replace">註冊</span></div>
                </div>
                <!-- 第二步 -->
                <div id="idUserRegStep2" style="display: none">
                    <div class="ValidateDiv">
                        <div class="ValidateImg">
                            <img id="idRegValidImage" style="display: none" />
                            <div class="popupBtn_reF"><span class="fa fa-refresh fa-1x"></span></div>
                        </div>
                        <input type="text" name="LoginValidateCode" language_replace="placeholder" placeholder="輸入驗證碼" autocomplete="off">
                    </div>
                    <div class="popupBtn_red" onclick="onBtnUserRegisterStep2()"><span class="language_replace">確認</span></div>
                </div>
            </div>
        </form>
    </div>
    <!-- 跳出訊息 -->
    <div class="popup" style="display: none;">
        <div class="popupWrapper">
            <div class="popupHeader">
                <div class="popuptit"><span class="language_replace">通知</span></div>
                <div class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>
            </div>
            <!--  -->
            <div class="popupText">
                <span class="language_replace">系統訊息</span>
            </div>
        </div>
    </div>
    <!-- 跳出確認框 -->
    <div id="idMessageBox" class="popup" style="display: none;">
        <div id="idMessageWrapper" class="popupWrapper">
            <div class="popupHeader">
                <div class="popuptit"><span id="idMessageTitle">[Title]</span></div>
                <!--<div class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>-->
            </div>
            <!--  -->
            <div class="popupText">
                <span id="idMessageText">[Msg]</span>
            </div>
            <div id="idMessageButtonOK" class="popupBtn_red tempMessageBtn"><span>OK</span></div>
            <div id="idMessageButtonCancel" class="popupBtn_redOL tempMessageBtn"><span>Cancel</span></div>
        </div>
    </div>
    <!-- 跳出選項視窗 -->
    <div id="divDropdownBox" class="popup" style="display: none;">
        <div class="popupWrapper">
            <div class="popupHeader">
                <div class="popuptit"><span id="divDropdownTitle">[Title]</span></div>
                <div id="divDropdownCancel" class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>
            </div>
            <!-- 下拉選單樣式 -->
            <div id="idTemplateDropdownBox" style="display: none">
                <div id="templateDropdownItem">
                    <div class="radioBoxDiv">
                        <label>
                            <input class="inputRadio" type="radio" name="select" data-value="#" checked />
                            <!--div class="radioBoxBtn">
                                <div class="radioBoxicon title">[Title]</div>
                                <div class="radioBoxText desc">[Desc]</div>
                            </!--div-->
                            <div class="radioBoxBtn">
                                <div class="radioBoxicon"></div>
                                <div class="radioBoxText">
                                    <span class="title">[Title]</span>
                                    <span class="desc">[Desc]</span>
                                </div>
                            </div>

                        </label>
                    </div>
                </div>
            </div>
            <div id="divDropdownList" class="selectCon">
                <!--
                   <div class="radioBoxDiv">
                        <label>
                            <input class="inputRadio" type="radio" name="select" onclick="#" data-value="#" />
                            <div class="radioBoxBtn">
                                <div class="radioBoxicon"></div>
                                <div class="radioBoxText"><span>CNY</span></div>
                            </div>
                        </label>
                    </div>
                   <div class="radioBoxDiv">
                        <label>
                            <input class="inputRadio" type="radio" name="select" onclick="#" data-value="#" />
                            <div class="radioBoxBtn">
                                <div class="radioBoxicon"></div>
                                <div class="radioBoxText"><span>CNY</span></div>
                            </div>
                        </label>
                    </div>
                -->
            </div>
        </div>
    </div>
    <!-- 跳出語言視窗 -->
    <div id="idSelLang" class="popup" style="display: none;">
        <div class="popupWrapper">
            <div class="popupHeader">
                <div class="popuptit"><span class="language_replace">選擇語系</span></div>
                <div onclick="closeSelLanguage()" class="popupBtn_close"><span class="fa fa-close fa-1x"></span></div>
            </div>
            <!--  -->
            <div class="popupText">
                <div class="form-group popup-lang">
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="CHS" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">简体中文</span></span>
                            </div>
                        </label>
                    </div>
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="CHT" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">繁體中文</span></span>
                            </div>
                        </label>
                    </div>
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="EN" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">English</span></span>
                            </div>
                        </label>
                    </div>
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="JPN" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">にほんご</span></span>
                            </div>
                        </label>
                    </div>
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="KOR" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">한국어</span></span>
                            </div>
                        </label>
                    </div>
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="VN" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">Việt Ngữ</span></span>
                            </div>
                        </label>
                    </div>
                    <div class="custom-control custom-radioValue-button custom-control-inline">
                        <label class="custom-label">
                            <input type="radio" data-lang="IND" name="button-langExchange" class="custom-control-input-hidden">
                            <div class="custom-input radio-button">
                                <span class="iconCheck"><span class="language_replace">भारतीय</span></span>
                            </div>
                        </label>
                    </div>
                </div>

                <div onclick="confirmSelLanguage()" class="popupBtn_red"><span>OK</span></div>
            </div>
        </div>
    </div>



    <!-- HTML END -->
    <!-- Initialize Swiper -->
    <%--<script src="/Scripts/index_marquee.js"></script>--%>
    <script>
        var swiper = new Swiper('.swiper-container', {
            slidesPerView: 1,
            spaceBetween: 30,
            loop: true,
            autoplay: {
                delay: 8000,
                disableOnInteraction: false,
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
        });
    </script>
</body>
</html>
