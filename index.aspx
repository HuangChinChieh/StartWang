<%@ Page Language="C#" %>

<%
    string Token;
    int RValue;
    Random R = new Random();
    string Lang = "";
    string SID = string.Empty;
    string CT = string.Empty;
    string LoginURL = string.Empty;
    string CompanyCode = System.Configuration.ConfigurationManager.AppSettings["CompanyCode"];
    int RegisterType = 0;
    int RegisterParentPersonCode = 0;
    string LoginStatus = Request["LoginStatus"];
    string LoginErrMsg = Request["LoginErrMsg"];
    string Bulletin = string.Empty;
    string FileData = string.Empty;
    string isModify = "0";
    string[] stringSeparators = new string[] { "&&_" };
    string[] Separators;
    int AllowLobby = 0;
    int AllowMemberCenter = 0;
    string b = Request["b"];
    string c = Request["c"];
    string cSub = Request["cSub"];
    string AllowAksoDeposit = EWinWeb.AllowAksoDeposit;
    string AllowAksoWithDrawal = EWinWeb.AllowAksoWithDrawal;

    try {
        if (System.IO.File.Exists(Server.MapPath("/App_Data/Bulletin.txt"))) {
            FileData = System.IO.File.ReadAllText(Server.MapPath("/App_Data/Bulletin.txt"));
            if (string.IsNullOrEmpty(FileData) == false) {
                Separators = FileData.Split(stringSeparators, StringSplitOptions.None);
                Bulletin = Separators[0];
                Bulletin = Bulletin.Replace("\r", "<br />").Replace("\n", string.Empty);
                if (Separators.Length > 1) {
                    isModify = Separators[1];
                }

                if (isModify == "1") {
                    Response.Redirect("maintenance.html");
                }
            }
        }
    } catch (Exception ex) { };


    if (string.IsNullOrEmpty(Request["SID"]) == false)
        SID = Request["SID"];

    if (string.IsNullOrEmpty(Request["CT"]) == false)
        CT = Request["CT"];

    if (string.IsNullOrEmpty(Request["LoginURL"]) == false)
        LoginURL = Request["LoginURL"];


    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());


    dynamic CompanySite = lobbyAPI.GetCompanySite(Token, Guid.NewGuid().ToString());
    AllowLobby = CompanySite.Company.AllowLobby;
    RegisterType = CompanySite.RegisterType;
    RegisterParentPersonCode = CompanySite.RegisterParentPersonCode;
    AllowMemberCenter = CompanySite.Company.AllowMemberCenter;
    
    if (string.IsNullOrEmpty(Request["Lang"])) {
        string userLang = CodingControl.GetDefaultLanguage();

        if (userLang.ToUpper() == "zh-TW".ToUpper()) { Lang = "CHT"; } else if (userLang.ToUpper() == "zh-HK".ToUpper()) { Lang = "CHT"; } else if (userLang.ToUpper() == "zh-MO".ToUpper()) { Lang = "CHT"; } else if (userLang.ToUpper() == "zh-CHT".ToUpper()) { Lang = "CHT"; } else if (userLang.ToUpper() == "zh-CHS".ToUpper()) { Lang = "CHS"; } else if (userLang.ToUpper() == "zh-SG".ToUpper()) { Lang = "CHS"; } else if (userLang.ToUpper() == "zh-CN".ToUpper()) { Lang = "CHS"; } else if (userLang.ToUpper() == "zh".ToUpper()) { Lang = "CHS"; } else if (userLang.ToUpper() == "en-US".ToUpper()) { Lang = "ENG"; } else if (userLang.ToUpper() == "en-CA".ToUpper()) { Lang = "ENG"; } else if (userLang.ToUpper() == "en-PH".ToUpper()) { Lang = "ENG"; } else if (userLang.ToUpper() == "en".ToUpper()) { Lang = "ENG"; } else if (userLang.ToUpper() == "ko-KR".ToUpper()) { Lang = "KOR"; } else if (userLang.ToUpper() == "ko-KP".ToUpper()) { Lang = "KOR"; } else if (userLang.ToUpper() == "ko".ToUpper()) { Lang = "KOR"; } else if (userLang.ToUpper() == "ja".ToUpper()) { Lang = "JPN"; } else { Lang = "ENG"; }
    } else {
        Lang = "CHT";
    }
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0">
    <title>星旺娛樂城</title>
    <meta name="Description" content="與知名網絡遊戲品牌合作，值得信賴，隨時可以玩。現在就註冊網站開始玩吧！">

    <meta property="og:title" content="星旺娛樂城" />
    <meta property="og:description" content="與知名網絡遊戲品牌合作，值得信賴，隨時可以玩。現在就註冊網站開始玩吧！" />
    <meta property="og:site_name" content="星旺娛樂城" />
    <meta property="og:Keyword" content="星旺娛樂城" />
    <meta property="og:description" content="與知名網絡遊戲品牌合作，值得信賴，隨時可以玩。現在就註冊網站開始玩吧！" />
   
    <!-- <meta property="og:url" content="https://casino-maharaja.com/" /> -->
    <!--日文圖片-->
    <meta property="og:image" content="http://new12one.dev4.mts.idv.tw/images/ic_192.png" />
    <!--英文圖片-->
   
    <!-- Share image -->
    <link rel="image_src" href="http://new12one.dev4.mts.idv.tw/images/ic_192.png">

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
    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="ico/apple-touch-icon-57-precomposed.png">
    <style>
        /*iframe {
            width: 1px;
            min-width: 100%;
        }*/
    </style>
</head>
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/qcode-decoder.min.js"></script>
<script type="text/javascript" src="/Scripts/jquery.min.1.7.js"></script>
<script type="text/javascript" src="/Scripts/LobbyAPI.js"></script>
<script type="text/javascript" src="/Scripts/PaymentAPI.js"></script>
<!-- Swiper JS -->
<script src="Scripts/GameCodeBridge.js"></script>
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
    var lang = "<%=Lang%>";
    var page = "<%=Page%>";
    var LoginStatus = "<%=LoginStatus%>";
    var LoginErrMsg = "<%=LoginErrMsg%>";
    var CompanyCode = "<%=CompanyCode%>";
    var needCheckLogin = false;
    var lastWalletList = null; // 記錄最後一次同步的錢包, 用來分析是否錢包有變動
    var ID = 0;
    var hasBulletin = <%=(string.IsNullOrEmpty(Bulletin) ? "false" : "true")%>;
    var postObj = null;
    var apiURL = "/index.aspx";
    var lobbyClient;
    var paymentClient;
    var GCB;
    var CompanyGameCategoryCodes = ["All"];
    var gameWindow;
    var Favos = [];
    var EWinWebInfo = {
        EWinUrl: "<%=EWinWeb.EWinUrl %>",
        EWinGameUrl: "<%=EWinWeb.EWinGameUrl %>",
        MainCurrencyType: "<%=EWinWeb.MainCurrencyType %>",
        RegisterCurrencyType: "<%=EWinWeb.RegisterCurrencyType %>",
        Token: "",
        SID: "<%=SID%>",
        CT: "<%=CT%>",
        LoginURL: "<%=LoginURL%>",
        UserLogined: false,
        Lang: "<%=Lang%>",
        SiteInfo: null,
        UserInfo: null,
        RegisterType: "<%=RegisterType%>",
        RegisterParentPersonCode: "<%=RegisterParentPersonCode%>",
        DeviceType: getOS(),
        IsOpenGame: false,
    }
    var SiteInfo;
    var selectedCurrency = '';

    function API_GetGCB() {
        return GCB;
    }

    function API_GetLang() {
        return lang;
    }

    function API_GetWebInfo() {
        return EWinWebInfo;
    }

    function API_GetLang() {
        return EWinWebInfo.Lang;
    }

    function API_GetLobbyAPI() {
        return lobbyClient;
    }

    function API_GetPaymentAPI() {
        return paymentClient;
    }

    function API_ShowMessage(title, msg, cbOK, cbCancel) {
        return showMessage(title, msg, cbOK, cbCancel);
    }

    function API_ShowMessageOK(title, msg, cbOK) {
        return showMessageOK(title, msg, cbOK);
    }

    function API_RefreshUserInfo(cb) {
        checkUserLogin(EWinWebInfo.SID, function (logined) {
            updateBaseInfo();

            notifyWindowEvent("LoginState", logined);

            if (cb != null)
                cb();
        });
    }

    function API_OpenQRCodeScanner(fileInput, cb) {
        if (EWinWebInfo.InAppMode) {
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

        API_ShowDropdownWindow(title, ddList, EWinWebInfo.CurrencyType, function (v) {
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
        EWinWebInfo.UserInfo = null;
        EWinWebInfo.UserLogined = false;
        EWinWebInfo.CT = "";
        window.localStorage.clear();
        window.sessionStorage.clear();
        delCookie("RecoverToken");
        delCookie("SID");
        delCookie("CT");
        if (favoriteGamesStr) {
            window.localStorage.setItem("FavoriteGames", favoriteGamesStr);
        }
        window.location.href = "Refresh.aspx?index.aspx";
    }

    //刪除cookie
    function delCookie(name) {
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

        var exp = new Date();
        exp.setTime(exp.getTime() - 1);
        var cval = getCookie("RecoverToken");
        if (cval != null) document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
    }

    function API_Home() {
        API_LoadPage('home.aspx');
    }

    function API_Lobby() {
        API_LoadPage("Lobby/GameLobby.aspx?b=<%=b%>&c=<%=c%>&cSub=<%=cSub%>");
    }

    function queryInfoData() {
        var GUID = Math.uuid();
        lobbyClient.GetInfoData2(GUID, ID, function (success, reps) {
            if (success) {
                if (reps.Result == 0) {
                    var o = JSON.parse(reps.Message);
                    for (var i = 0; i < o.length; i++) {
                        if (o[i].InfoID > 0) {
                            var t = c.getTemplate("templateToast");
                            var guid = Math.uuid();

                            t.id = guid;
                            c.setClassText(t, "ToastItemTime", null, o[i].InfoDate);
                            c.setClassText(t, "ToastName", null, o[i].InfoAccount);
                            c.setClassText(t, "ToastAmount", null, c.toCurrency(o[i].InfoAmount));
                            t.classList.add("toast");
                            t.getElementsByClassName("ToastItemCloseBtn")[0].setAttribute("guid", guid);
                            t.getElementsByClassName("ToastItemCloseBtn")[0].onclick = function () {
                                var toast = document.getElementById(this.getAttribute("guid"));
                                toast.parentNode.removeChild(toast);
                            }
                            document.getElementById("ToasterDiv").appendChild(t);

                            if (ID == 0) {
                                ID = o[i].InfoID;
                            }

                            if (o[i].InfoID > ID) {
                                ID = o[i].InfoID;
                            }

                            window.setTimeout(function () {
                                for (var i = 0; i < document.getElementsByClassName("toast").length; i++) {
                                    if (document.getElementsByClassName("toast")[i].style.opacity == 0) {
                                        var toast = document.getElementsByClassName("toast")[i];
                                        toast.parentNode.removeChild(toast);
                                    }
                                }

                            }, 15000)
                        }
                        else {
                            if (o[0].InfoID == 0) {
                                ID = 0;
                            }
                        }
                    }
                }
            }
        });
    }

    function API_SetCurrencyType(c) {
        var pi = API_GetCurrencyType(c);

        if (pi != null) {
            EWinWebInfo.CurrencyType = c;
            selectedCurrency = c;
            window.localStorage.setItem("CurrencyType", c);

            notifyWindowEvent("SetCurrencyType", c);
        }

        //updateWalletList();
        updateBaseInfo();
    }

    function API_ListCurrencyType() {
        var pi = null;

        if (EWinWebInfo.UserLogined == true) {
            if (EWinWebInfo.UserInfo != null) {
                if (EWinWebInfo.UserInfo.WalletList != null) {
                    pi = EWinWebInfo.UserInfo.WalletList;
                }
            }
        }

        return pi;
    }

    function API_GetCurrencyType(c) {
        var pi = null;

        if (c != null) {
            if (EWinWebInfo.UserLogined == true) {
                if (EWinWebInfo.UserInfo != null) {
                    if (EWinWebInfo.UserInfo.WalletList != null) {
                        for (var i = 0; i < EWinWebInfo.UserInfo.WalletList.length; i++) {
                            var walletInfo = EWinWebInfo.UserInfo.WalletList[i];

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
        var IFramePage = document.getElementById("idFrameContent");

        if (IFramePage != null) {
            if (IFramePage.tagName.toUpperCase() == "IFRAME".toUpperCase()) {
                IFramePage.src = url;
                IFramePage.onload = null;
            }
        }

        //mobile remove
        document.getElementById("dropdownDiv").classList.remove("dropdownDiv-down");
    }

    function API_OpenGame(GameCode, GameLobbyExist, WalletType) {
        var PointInfo = API_GetSelCurrencyType();

        if (PointInfo.PointValue > 0) {
            var gameWindow = window.open("OpenGame.aspx?Type=0&Token=" + EWinWebInfo.Token + "&GameCode=" + GameCode + "&CurrencyType=" + PointInfo.CurrencyType + "&SID=" + EWinWebInfo.SID + "&Lang=" + lang + "&GameLobbyExist=" + GameLobbyExist + "&WalletType=" + WalletType + "&LoginAccount=" + EWinWebInfo.UserInfo.LoginAccount + "&CT=" + EWinWebInfo.CT);
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
            Token: EWinWebInfo.Token,
            SID: EWinWebInfo.SID,
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

    function API_SetLogin(_SID, cb) {
        var sourceLogined = EWinWebInfo.UserLogined;
        //var btnlogin = document.getElementById("BtnLogin");
        //btnlogin.style.display = "none";
        checkUserLogin(_SID, function (logined) {
            var raiseCurrencyChange = false;

            updateBaseInfo();

            // check wallet
            if ((lastWalletList != null) && (EWinWebInfo.UserInfo != null)) {
                if (EWinWebInfo.UserInfo.WalletList != null) {
                    if (lastWalletList.length == EWinWebInfo.UserInfo.WalletList.length) {
                        for (var i = 0; i < lastWalletList.length; i++) {
                            var eachWallet = lastWalletList[i];

                            for (var j = 0; j < EWinWebInfo.UserInfo.WalletList.length; j++) {
                                var runtimeWallet = EWinWebInfo.UserInfo.WalletList[j];

                                if (runtimeWallet.CurrencyType == eachWallet.CurrencyType) {
                                    if (runtimeWallet.PointValue != eachWallet.PointValue) {
                                        raiseCurrencyChange = true;
                                        break;
                                    }
                                }
                            }

                            if (raiseCurrencyChange)
                                break;
                        }
                    } else {
                        raiseCurrencyChange = true;
                    }

                    lastWalletList = EWinWebInfo.UserInfo.WalletList;
                }
            }

            if (logined) {
                window.localStorage.setItem("SID", _SID);


                if (cb)
                    cb(true);
            } else {
                window.localStorage.setItem("SID", "");

                if (cb)
                    cb(false);
            }

            if (sourceLogined == logined)
                notifyWindowEvent("LoginState", logined);

            if (raiseCurrencyChange)
                notifyWindowEvent("BalanceChange", logined);

        });
    }

    function API_OpenGame(GameBrand, GameName, LangName) {
        openGame(GameBrand, GameName, LangName);
    }

    function API_GetGameLang(lang, GameCode, cb) {
        GCB.GetByGameCode(GameCode, (GameCodeItem) => {
            var langText = null;

            if (GameCodeItem) {
                langText = GameCodeItem.Language.find(x => x.LanguageCode == lang) ? GameCodeItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";
            }

            cb(langText);
        })
    }

     function API_RefreshPersonalFavo(gameCode, isAdded) {
        if (!isAdded) {
            var index = Favos.indexOf(gameCode);

            if (index > -1) {
                Favos.splice(index, 1);
            }
        } else if (isAdded) {
            var index = Favos.indexOf(gameCode);

            if (index == -1) {
                Favos.push(gameCode);
            }
        }

        //lobbyClient.SetUserAccountProperty(EWinWebInfo.SID, Math.uuid(), "Favo", JSON.stringify(Favos), function (success, o) {
        //    if (success) {
        //        if (o.Result == 0) {
        //        }
        //    }
        //});

        notifyWindowEvent("RefreshPersonalFavo", { GameCode: gameCode, IsAdded: isAdded });
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
            postData = encodeURI("RecoverToken=" + recoverToken);
            c.callService("/LoginRecover.aspx?" + postData, null, function (success, o) {
                API_HideMask();

                if (success) {
                    var obj = c.getJSON(o);

                    if (obj.Result == 0) {
                        EWinWebInfo.SID = obj.SID;

                        //pHubClient.SetToken(obj.Token);

                        setCookie("RecoverToken", obj.RecoverToken, 365);

                        API_RefreshUserInfo(function () {
                            updateBaseInfo();

                            if (cb)
                                cb(true);
                        });
                    } else {
                        EWinWebInfo.UserLogined = false;

                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請重新登入。") + mlp.getLanguageKey(obj.Message), function () {
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
        let data = {
            SID: SID,
            GUID: Math.uuid()
        }

        lobbyClient.GetUserInfo(data, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    EWinWebInfo.SID = SID;
                    EWinWebInfo.UserLogined = true;
                    EWinWebInfo.UserInfo = o;

                    if (cb) {
                        cb(true);
                    }
                } else {
                    if (o.Message == "InvalidSID") {
                        // login fail
                        EWinWebInfo.UserLogined = false;
                    } else {
                        EWinWebInfo.UserLogined = false;

                        API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
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

        if (EWinWebInfo.UserLogined) {

            idUserNotLogin.style.display = "none";
            idUserNotLogin.classList.remove("NotLogin");
            idUserLogined.style.display = "block";
            idHeaderCon.classList.add("login");

            c.setElementText("idUserLevel", null, EWinWebInfo.UserInfo.UserLevel);
            c.setElementText("idNickName", null, EWinWebInfo.UserInfo.LoginAccount);

            var idCurrencyType = document.getElementById("idCurrencyType");
            var idBalance = document.getElementById("idBalance");

            if (selectedCurrency == '') {
                idCurrencyType.innerText = EWinWebInfo.UserInfo.WalletList[0].CurrencyType;
                idBalance.innerText = new BigNumber(EWinWebInfo.UserInfo.WalletList[0].PointValue).toFixed(2);
                selectedCurrency = EWinWebInfo.UserInfo.WalletList[0].CurrencyType;
            } else {
                var indexWalletList = EWinWebInfo.UserInfo.WalletList.findIndex(function (d) { return d.CurrencyType == selectedCurrency });
                idCurrencyType.innerText = EWinWebInfo.UserInfo.WalletList[indexWalletList].CurrencyType;
                idBalance.innerText = new BigNumber(EWinWebInfo.UserInfo.WalletList[indexWalletList].PointValue).toFixed(2);
                selectedCurrency = EWinWebInfo.UserInfo.WalletList[indexWalletList].CurrencyType;
            }
        } else {
            idUserNotLogin.style.display = "block";
            idUserNotLogin.classList.add("NotLogin");
            idUserLogined.style.display = "none";
        }


    }

    function init() {
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

        GCB = new GameCodeBridge("/API/LobbyAPI.asmx", 30,
            {
                GameCode: "EWin.EWinGaming",
                GameBrand: "EWin",
                GameStatus: 0,
                GameID: 0,
                GameName: "EWinGaming",
                GameCategoryCode: "Live",
                GameCategorySubCode: "Baccarat",
                GameAccountingCode: null,
                AllowDemoPlay: 1,
                RTPInfo: "",
                IsHot: 1,
                IsNew: 1,
                SortIndex: 99,
                Tags: [],
                Language: [{
                    LanguageCode: "JPN",
                    DisplayText: "EWinゲーミング"
                },
                {
                    LanguageCode: "CHT",
                    DisplayText: "真人百家樂(eWIN)"
                }],
                RTP: null
            },
            () => {
                notifyWindowEvent("GameLoadEnd", null);
            }
        );
        appendGameFrame();
        getCompanyGameCategoryCode();

        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            lobbyClient = new LobbyAPI("/API/LobbyAPI.asmx");
            paymentClient = new PaymentAPI("/API/PaymentAPI.asmx");


            if (LoginErrMsg != "" && LoginErrMsg != null) {
                showMessageOK('', mlp.getLanguageKey(LoginErrMsg));
            }

            if (EWinWebInfo.CT != "" && EWinWebInfo.CT != null) {
                initLobbyClient();

                checkUserLogin(EWinWebInfo.SID, function (success) {
                    if (success == true) {
                        updateBaseInfo();
                    } else {
                        userRecover();
                    }
                });
            }
            else {
                API_Home();
            }
            
        });

        //API_ShowMessageOK("錯誤", "請輸入登入帳號");
        //API_ShowDropdownWindow("測試", [{ name: "a1", desc: "1", value: "1" }, { name: "a2", desc: "2", value: "2" }], "2", function (v) { alert(v); }, null);

        resize();
        setInterval(function () {
            resize();
        }, 500);

        window.setInterval(function () {
            if (needCheckLogin == true) {
                needCheckLogin = false;

                if (EWinWebInfo.CT != "" && EWinWebInfo.CT != null) {
                    checkUserLogin(EWinWebInfo.SID, function (success) {
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

        window.localStorage.setItem("Lang", lang);
    }

    function initLobbyClient() {
        //lobbyClient = new LobbyHubAPI(CT);

        // 設定 SignalR 事件
        // handleReceiveMsg: 收到伺服器傳回訊息
        // handleConnected: 連線完成
        // handleReconnected: 重新連線完成
        // handleReconnecting: 重新連線中
        // handleDisconnect: 斷線

        if (LoginStatus == "success") {
            //是否允許大廳
            if (EWinWebInfo.SiteInfo != null) {
                if (EWinWebInfo.SiteInfo.Company.AllowLobby == 1) {
           
                }
                else {
                    API_Home();
                }
            }
            else {
                API_Home();
            }
        }
        else {
            API_Home();
        }

        window.setTimeout(function () {
            postObj = {
                GUID: Math.uuid()
            }

            lobbyClient.GetCompanySite(postObj, function (success, o) {
                if (success) {
                    if (o.Result == 0) {
                        //SiteInfo = o;
                        EWinWebInfo.SiteInfo = o;
                        if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                            API_SetLogin(EWinWebInfo.SID, function (logined) {
                                if (logined == false) {
                                    userRecover();
                                }
                            });
                        } else {
                            updateBaseInfo();
                        }
                        API_HideMask();
                        //if (cb)
                        //    cb(true);
                    } else {
                        if (o.Message == "InvalidSID") {
                            // login fail
                            EWinWebInfo.UserLogined = false;
                        } else {
                            EWinWebInfo.UserLogined = false;

                            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                        }
                    }
                }
                else {
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("服務器異常, 請稍後再嘗試一次"), function () {
                        window.location.href = "index.aspx"
                    });
                }
            });
        }, 500);

        window.setInterval(function () {
            // refresh SID and Token;
            var guid = Math.uuid();

            if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                postObj = {
                    SID: EWinWebInfo.SID,
                    GUID: Math.uuid()
                }
                lobbyClient.KeepSID(postObj, function (success, o) {
                    if (success == true) {
                        if (o.Result == 0) {
                            needCheckLogin = true;
                        } else {
                            if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                                needCheckLogin = true;
                            }
                        }
                    }
                });
            }
        }, 10000);

        window.setInterval(function () {
            if (needCheckLogin == true) {
                needCheckLogin = false;

                if ((EWinWebInfo.SID != null) && (EWinWebInfo.SID != "")) {
                    API_SetLogin(EWinWebInfo.SID, function (logined) {
                        if (logined == false) {
                            userRecover();
                        }
                    });
                } else {
                    updateBaseInfo();
                }
            }
        }, 1000);

        queryInfoData();
        setInterval(queryInfoData, 20000);

        if (hasBulletin == true) {
            document.getElementById("popupBulletin").style.display = "block";
        }

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

                //if (iframeDocument != null) {
                //    if (iframeDocument.body != null) {
                //        idFrameContent.height = iframeDocument.body.scrollHeight;
                //    }
                //}
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

    function CreateLoginValidateCode() {
        var now = new Date();
        iURL = "/GetValidateImage.aspx?time=" + now.getTime();
        c.callService(iURL, null, function (success, text) {
            if (success == true) {
                var o = c.getJSON(text);

                if (o.Result == 0) {
                    var idValidImage = document.getElementById("idLoginValidImage");
                    var idFormUserLogin = document.getElementById("idFormUserLogin");

                    idFormUserLogin.LoginGUID.value = o.LoginGUID;

                    if (idValidImage != null) {
                        idValidImage.src = o.Image;
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
        if (EWinWebInfo.UserLogined) {
            API_LoadPage("memberCenter.aspx");
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            });
        }
    }

    function onBtnHistory() {
        if (EWinWebInfo.UserLogined) {
            API_LoadPage("history.aspx");
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            });
        }
    }

    function onBtnChat() {
        if (EWinWebInfo.UserLogined) {
            window.open("ChatMain.aspx?Token=" + EWinWebInfo.Token + "&SID=" + EWinWebInfo.SID + "&Acc=" + EWinWebInfo.UserInfo.LoginAccount);
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            });
        }
    }

    function onBtnPaymentDeposit() {
        if (EWinWebInfo.UserLogined) {
            //window.open(GWebUrl + "/API/Payment/GpayDeposit.aspx?Token=" + EWinWebInfo.Token + "&SID=" + EWinWebInfo.SID, "_blank");
            API_LoadPage("mywallet.aspx");
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            });
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

    function onForgotPassword() {
        onBtnLoginHide();
        API_LoadPage("ForgotPassword.aspx");
    }

    // 存款
    function openPaymentDeposit(dt) {
        
        if (EWinWebInfo.UserLogined) {
            var retPage = "";
            //dt = 0: 四方/1=區塊鏈/2=銀行轉帳/3=代理
            switch (dt) {
                case 0:
                   //API_ShowMessageOK(mlp.getLanguageKey(""), mlp.getLanguageKey("功能未開啟"));
                    API_LoadPage("/Payment/EPay/EPayDeposite.aspx");
                    break;
                case 1:
                    //openBitCoinAddress();
                    break;
                case 2:
                    retPage = "iType=BackCardIN&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + selectedCurrency;
                    API_LoadPage("/Payment/BankCard/BankCard_In.aspx?" + retPage);
                    break;
                case 4:
                    window.open("/Payment/Wallet_GCASH_PHP.aspx?SID=" + EWinWebInfo.SID + "&CurrencyType=" + selectedCurrency, "_blank");
                    break;

            }
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            });
        }

    }

    // 提款
    function openPaymentWithdrawal(wt) {
        if (EWinWebInfo.UserLogined) {
            switch (wt) {
                case 0:
                    //API_ShowMessageOK(mlp.getLanguageKey(""), mlp.getLanguageKey("功能未開啟"));
                    API_LoadPage("/Payment/EPay/EPayWithdraw.aspx");
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
        } else {
            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            });
        }
        //wt = 0: 四方/1=區塊鏈
    }

    function getOS() {
        var os = function () {
            var ua = navigator.userAgent,
                isWindowsPhone = /(?:Windows Phone)/.test(ua),
                isSymbian = /(?:SymbianOS)/.test(ua) || isWindowsPhone,
                isAndroid = /(?:Android)/.test(ua),
                isFireFox = /(?:Firefox)/.test(ua),
                isChrome = /(?:Chrome|CriOS)/.test(ua),
                isTablet = /(?:iPad|PlayBook)/.test(ua) || (isAndroid && !/(?:Mobile)/.test(ua)) || (isFireFox && /(?:Tablet)/.test(ua)),
                isPhone = /(?:iPhone)/.test(ua) && !isTablet,
                isPc = !isPhone && !isAndroid && !isSymbian;
            return {
                isTablet: isTablet,
                isPhone: isPhone,
                isAndroid: isAndroid,
                isPc: isPc
            };
        }();

        if (os.isAndroid || os.isPhone) {
            return 1;
        } else if (os.isTablet) {
            return 1;
        } else if (os.isPc) {
            return 0;
        }
    };

    function getCompanyGameCategoryCode() {
        GCB.GetGameCategoryCode((categoryCodeItem) => {
            if (CompanyGameCategoryCodes.indexOf(categoryCodeItem.GameCategoryCode) < 0) {
                CompanyGameCategoryCodes.push(categoryCodeItem.GameCategoryCode);
            }
        }, () => {
                notifyWindowEvent("GetGameCategoryCodeDone");
        })
    }

    function openGame(gameBrand, gameName) {
        //先關閉Game彈出視窗(如果存在)
        if (gameWindow) {
            gameWindow.close();
        }

        if (!EWinWebInfo.UserLogined) {

            API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                onBtnLoginShow();
            }, null);

        } else {
            EWinWebInfo.IsOpenGame = true;
            GCB.AddPlayed(gameBrand + "." + gameName, function (success) {
                if (success) {
                    //API_RefreshPersonalPlayed(gameBrand + "." + gameName, true);
                }
            });

            if (gameBrand.toUpperCase() == "EWin".toUpperCase() || gameBrand.toUpperCase() == "YS".toUpperCase()) {
                window.open(EWinWebInfo.EWinUrl + "/Game/Login.aspx?SID=" + EWinWebInfo.SID + "&Lang=" + EWinWebInfo.Lang + "&CT=" + encodeURIComponent(EWinWebInfo.CT))
            } else {
                if (EWinWebInfo.DeviceType == 1) {
                    gameWindow = window.open("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&CT=" + EWinWebInfo.CT + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + selectedCurrency + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.StartWangUrl%>/CloseGame.aspx", "StartWang Game");
                } else {
                    GameLoadPage("/OpenGame.aspx?SID=" + EWinWebInfo.SID + "&CT=" + EWinWebInfo.CT + "&Lang=" + EWinWebInfo.Lang + "&CurrencyType=" + selectedCurrency + "&GameBrand=" + gameBrand + "&GameName=" + gameName + "&HomeUrl=" + "<%=EWinWeb.StartWangUrl%>/CloseGame.aspx");
                }
            }
        }
    }

    function GameLoadPage(url) {
        var IFramePage = document.getElementById("GameIFramePage");

        if (IFramePage != null) {
            $('#divGameFrame').css('display', 'flex');

            if (IFramePage.tagName.toUpperCase() == "IFRAME".toUpperCase()) {
                //API_LoadingStart();

                //setTimeout(function () {
                //    API_LoadingEnd(1);
                //}, 10000);

                IFramePage.src = url;
                //IFramePage.onload = function () {
                //    API_LoadingEnd(1);
                //}
            }
        }
    }

    function CloseGameFrame() {
        //滿版遊戲介面
        $('#divGameFrame').css('display', 'none');
        //滿版遊戲介面 end
        appendGameFrame();
    }

    function appendGameFrame() {
        $("#divGameFrame").children().remove();
        let vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0);
        let vh = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0);

        let w = vh * 16 / 9;

        if (w > vw) {
            w = vw - 110;
        } else if (Math.abs(vw - w) < 110) {
            w = vw - 110;
        }

        // class="divGameFrame"
        let tmp = `<div class="divGameFrameWrapper">
            <div class="btn-wrapper">
                <div class="btn btn-game-close" onclick="CloseGameFrame()"><span class="fa fa-close fa-1x"></span></div>
            </div>
            <iframe id="GameIFramePage" style="width:${w}px;height:${vh}px;" name="mainiframe" sandbox="allow-same-origin allow-scripts allow-popups allow-forms allow-pointer-lock"></iframe>
        </div>`;
        $("#divGameFrame").append(tmp);
    }

    function notifyWindowEvent(eventName, o) {
        var IFramePage = document.getElementById("idFrameContent");

        if (IFramePage != null) {
            isDisplay = true;

            if (IFramePage.contentWindow && IFramePage.contentWindow.EWinEventNotify) {
                try {
                    IFramePage.contentWindow.EWinEventNotify(eventName, isDisplay, o)
                } catch (e) {

                }
            }
        }
    }

    window.onload = init;
</script>
<body>
    <!-- HTML START -->
    <!-- LOADER -->
    
    <div class="loader-container" style="display: block;">
        <div class="loader-box">
            

            <div class="loader-spinner">
                <!-- <span class="loader"></span>
                <div class="loader-logo"></div> -->
                <div class="sk-fading-circle">
                    <div class="loader-logo"></div>
                    <div class="sk-circle1 sk-circle"></div>
                    <div class="sk-circle2 sk-circle"></div>
                    <div class="sk-circle3 sk-circle"></div>
                    <div class="sk-circle4 sk-circle"></div>
                    <div class="sk-circle5 sk-circle"></div>
                    <div class="sk-circle6 sk-circle"></div>
                    <div class="sk-circle7 sk-circle"></div>
                    <div class="sk-circle8 sk-circle"></div>
                    <div class="sk-circle9 sk-circle"></div>
                    <div class="sk-circle10 sk-circle"></div>
                    <div class="sk-circle11 sk-circle"></div>
                    <div class="sk-circle12 sk-circle"></div>
                </div>
                <%--<div class="loader-text language_replace">正在加載...</div>--%>
            </div>
        </div>
        <div class="loader-backdrop is-show"></div>
    </div>
    <div class="wrapper">
        <!-- wrapper -->
        <div class="header-con" id="header-con">
            <div class="header">
                <!--  未登入版頭 -->
                <div id="idUserNotLogin" class="header-tit_none">
                    <div class="header-tit-con">
                        <div class="box btnTypeA loginBrn_div">
                            <%--<button onclick="openSelLanguage()" type="button" class="btn btn-icon-round ico-before-flag-hk SwitchLang" role="button" data-toggle="modal" data-target="">語系</button>
                            <button type="button" class="btn btn-customerservice btn-icon-round icon-service" id="" role="button" data-toggle="modal" data-target="" onclick="">客服</button>--%>
                            <%--<button type="button" class="box btn btn-gradient-golden" id="tryitBtn" role="button" data-toggle="modal" data-target="" onclick="onBtnTryIt();"><i class="icon icon12one-ico-poker icon-large" aria-hidden="true"></i><span class="language_replace">搶先試玩</span></button>--%>
                            <button type="button" class="box btn btn-default" id="loginBtn" role="button" data-toggle="modal" data-target="#idLoginImage" onclick="onBtnLoginShow();"><i class="fa fa-sign-out fa-1x" aria-hidden="true"></i><span class="language_replace">登入</span></button>
                            <button type="button" class="btn btn-info" id="signinBtn" role="button" data-toggle="modal" data-target="#myModal" onclick="onBtnUserRegisterShow();"><i class="fa fa-address-card fa-1x" aria-hidden="true"></i><span class="language_replace">註冊</span></button>
                        </div>
                    </div>
                </div>
                <!--  已登入版頭 -->
                <div id="idUserLogined" class="header-tit" style="display: none;">
                    <div class="header-tit-info">
                        <div id="idUserLevel" class="user-level" style="display: none">VIP 9</div>
                        <div id="idNickName" class="user-ID" style="margin-top: 15px">SeanYu888 </div>
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
                        <%--<button onclick="openSelLanguage()" type="button" class="btn btn-icon-round ico-before-flag-hk SwitchLang" role="button" data-toggle="modal" data-target="" >語系</button>
                       <button type="button" class="btn btn-customerservice btn-icon-round icon-service language_replace" id="" role="button" data-toggle="modal" data-target="" onclick="onBtnChat()">客服</button>--%>


                        <div onclick="btnConfirmLogout();" class="box btn-logout btnTypeA">
                            <button class="btn-default"><i class="fa fa-sign-out fa-1x" aria-hidden="true"></i><span class="language_replace">登出</span></button>
                        </div>
                        <!--<div class="box user-email"><a><span class="fa fa-envelope" aria-hidden="true"></span> 信箱<i>10</i></a></div>-->
                    </div>

                </div>
                <div class="header-nav clearfix">
                    <div class="box header-nav-logo">
                        <img src="images/logo.png" alt="99play_logo" onclick="API_LoadPage('home.aspx')" style="cursor: pointer">
                    </div>
                    <div class="box header-nav-menu" id="dropdownDiv">
                        <div onclick="dropdownFunction()" id="dropdownDiv-btn" class="dropdown-btn"><a class="fa fa-bars" aria-hidden="true"></a></div>
                        <ol>
                            <li><a onclick="API_LoadPage('home.aspx')"><span class="fa fa-home" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">回首頁</div>
                            </a></li>
                            <%--<li><a onclick=" API_Home()"><span class="icon icon-icon-poker" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">遊戲大廳</div>
                            </a></li>--%>
                            <li><a onclick="openPaymentDeposit(0);"><span class="icon icon-icon-topup" aria-hidden="true"></span>
                                <br>
                                <div class="language_replace">充值</div>
                            </a></li>
                            <li><a onclick="openPaymentWithdrawal(0);"><span class="icon icon-icon-topup" aria-hidden="true"></span>
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
        <!-- 滿版遊戲介面 -->
        <div id="divGameFrame" class="divGameFrameBody">
            <div class="divGameFrameWrapper">
                <div class="btn-wrapper">
                    <div class="btn btn-game-close" onclick="CloseGameFrame()"><span class="fa fa-close fa-1x"></span></div>
                </div>
                <iframe id="GameIFramePage" class="divGameFrame" name="mainiframe" sandbox="allow-same-origin allow-scripts allow-popups allow-forms allow-pointer-lock"></iframe>
            </div>
        </div>

        <!-- Content -->
        <%--    <div id="IFramePage" class="DivContent">
            <iframe id="idFrameContent" class="idFrameContent" scrolling="auto" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
        </div>--%>
        <div id="IFramePage" class="DivContent" style="">
            <iframe id="idFrameContent" class="idFrameContent"></iframe>
        </div>
        <!-- 頁尾 -->
        <%-- <div class="main-footer">.</div>--%>
    </div>
    <!-- wrapper END -->
    <!-- 滿版遊戲介面 end-->
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
                    <div onclick="onForgotPassword();" class="popupBtn_redOL"><span class="language_replace">忘記密碼</span></div>
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
