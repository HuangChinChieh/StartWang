<%@ Page Language="C#" CodeFile="GameLobby.aspx.cs" Inherits="GameLobby" %>

<%
    int RValue;
    Random R = new Random();
    string Token;
    string[] MobileDeviceAgent = new string[] { "iphone", "ipad", "ipod", "android" };
    bool isMobile = false;
    string GameCodeListStr = string.Empty;
    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
    string b = Request["b"];
    string c = Request["c"];
    string cSub = Request["cSub"];

    foreach (string eachKey in MobileDeviceAgent) {
        if (Request.UserAgent.ToUpper().IndexOf(eachKey.ToUpper()) != -1) {
            isMobile = true;
            break;
        }
    }

    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

    dynamic GameCodeList = lobbyAPI.GetCompanyGameCode(Token, Guid.NewGuid().ToString());
    GameCodeListStr = Newtonsoft.Json.JsonConvert.SerializeObject(GameCodeList);

%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="Description" content="eWin Gaming">
    <title>VIP CLUB</title>

    <!-- CSS -->
    <link href="css/layout.css?20200706" rel="stylesheet" type="text/css">
    <link href="css/svgfont/styles.css?20200706" rel="stylesheet" type="text/css">
    <link href="css/styles_lang.css?20200706" rel="stylesheet" type="text/css">
    <link href="css/gameLobby.css" rel="stylesheet" type="text/css">
    <link href="css/gameLobbyMedia.css" rel="stylesheet" type="text/css">
    <!-- 轉帳CSS -->
    <link href="css/wallet_crypto.css" rel="stylesheet" type="text/css">
    <!-- _customization -->
    <link href="/_customization/css/mainAdj.css?25" rel="stylesheet" />
    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="ico/apple-touch-icon-57-precomposed.png">
</head>
<script type="text/javascript">
    function NavSwitch() {
        var lobWrapper = document.getElementById("lob_wrapper");
        lobWrapper.classList.toggle("lob_NavSwitch");
    }
</script>
<script type="text/javascript" src="../Scripts/Common.js"></script>
<script type="text/javascript" src="../Scripts/UIControl.js"></script>
<script type="text/javascript" src="../Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="../Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="../Scripts/bignumber.min.js"></script>
<script type="text/javascript">
    var ui = new uiControl();
    var c = new common();
    var apiURL = "/Lobby/GameLobby.aspx";
    var mlp;
    var sumask;
    var Webinfo;
    var lang;
    var p;
    var postObj;
    var nowCateg = "All";
    var nowGameType = "brand";
    var GameCodeList = <%=GameCodeListStr%>;
    var GameHistoryArr = new Array();
    var GameMyFavorArr = new Array();
 var defaultB = "<%=b%>";
    var defaultC = "<%=c%>";
    var defaultCsub = "<%=cSub%>";
    var directShow = false;

    var GameHistoryInfo = function () {
        this.gameBrand = "";
        this.gameName = "";
        this.imgSrc = "";
        this.AllowDemoPlay = 0;
    }

    var LobbyGameList = {
        CategoryList: [{
            Categ: "All",
            CategBrandList: []
        }],
        GameBrandList: [],
        GameList: [],
        CategorySubList: [{
            Categ: "All",
            CategSubList: []
        }],
        CategorySubBrandList: []
    }



    function API_SlideUpMaskEnable() {
        if (sumask != null)
            sumask.Enable();
    }

    function API_SlideUpMaskDisable(v) {
        var idEntryMask = document.getElementById("idEntryMask");

        if (sumask != null)
            sumask.Disable(v);

        if (idEntryMask != null)
            idEntryMask.style.display = "none";
    }

    function API_OpenGameCode(gameBrand, gameName, isDemo) {
        var iGameHistoryInfo = new GameHistoryInfo();
        var gameExist = false;
        var historyIndex = 0;
        var DemoPlay = 0

        if (isDemo == true) {
            DemoPlay = 1;
        }

        if (!WebInfo.UserLogined) {
            parent.top.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                parent.top.API_Home();
            });
        } else {

            if (gameBrand == 'EWin') {

                window.open(WebInfo.EWinUrl + "/Game/Login.aspx?SID=" + WebInfo.SID + "&Lang=" + WebInfo.Lang + "&CT=" + encodeURIComponent(WebInfo.CT))
            }
            else
                window.open(WebInfo.EWinUrl + "/API/GamePlatformAPI/" + gameBrand + "/UserLogin.aspx?SID=" + WebInfo.SID + "&Language=" + WebInfo.Lang + "&CurrencyType=" + window.parent.selectedCurrency + "&GameName=" + gameName + "&DemoPlay=" + DemoPlay, "_blank");
        }

        //history
        for (var i = 0; i < GameHistoryArr.length; i++) {
            if (GameHistoryArr[i].gameBrand == gameBrand) {
                if (GameHistoryArr[i].gameName == gameName) {
                    gameExist = true;
                    historyIndex = i;
                    break;
                }
            }
        }

        if (gameExist == false) {
            if (GameHistoryArr.length >= 5) {
                GameHistoryArr.splice(0, 1);
            }

            iGameHistoryInfo.gameName = gameName;
            iGameHistoryInfo.gameBrand = gameBrand;
            iGameHistoryInfo.imgSrc = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameBrand + "/PC/" + WebInfo.Lang + "/" + gameName + ".png";
            iGameHistoryInfo.AllowDemoPlay = DemoPlay;
            GameHistoryArr.push(iGameHistoryInfo);

        }
        else {
            GameHistoryArr.push(GameHistoryArr[historyIndex]);
            GameHistoryArr.splice(historyIndex, 1);
        }

        setGameHistory();
    }

    function API_GetWallet(ct) {
        var pi;

        if (WebInfo.UserInfo != null) {
            if (WebInfo.UserInfo.WalletList != null) {
                if ((ct != null) && (ct != "")) {
                    for (var i = 0; i < WebInfo.UserInfo.WalletList.length; i++) {
                        var eachPi = WebInfo.UserInfo.WalletList[i];

                        if (eachPi.CurrencyType.toUpperCase() == ct.toUpperCase()) {
                            pi = eachPi;
                            break;
                        }
                    }
                } else {
                    pi = WebInfo.UserInfo.WalletList;
                }
            }
        }

        return pi;
    }

    function API_ShowWallet(title, bShowCashWallet, bShowCreditWallet, cb) {
        var divTableMain = document.getElementById("lob_wrapper");
        var walletDialog = c.getTemplate("idTemplateWallet");
        var btnClose = c.getFirstClassElement(walletDialog, "TL_NavMenu_BtnClose");
        var CreditWallet = c.getFirstClassElement(walletDialog, "CreditWallet");
        var CashWallet = c.getFirstClassElement(walletDialog, "CashWallet");
        var divCashWallet = c.getFirstClassElement(walletDialog, "CashWallet");
        var divCashWalletPoint = c.getFirstClassElement(walletDialog, "CashWalletPoint");
        var divCreditWallet = c.getFirstClassElement(walletDialog, "CreditWallet");
        var divCreditWalletPoint = c.getFirstClassElement(walletDialog, "CreditWalletPoint");
        var cashWallet = [];
        var creditWallet = [];

        function CloseWallet() {
            walletDialog.className = "TL_gameSetlistPopUpHidden";
            divTableMain.removeChild(walletDialog);
            document.body.style.position = "relative";
        }

        if (btnClose != null) {
            btnClose.onclick = function () {
                CloseWallet();
            };
        }

        if (bShowCashWallet == false)
            CashWallet.style.display = "none";

        if (bShowCreditWallet == false)
            CreditWallet.style.display = "none";

        c.setClassText(walletDialog, "Title", null, title);

        walletDialog.className = "TL_gameSetlistPopUpShow";


        if (WebInfo.UserInfo != null) {
            if (WebInfo.UserInfo.WalletList != null) {
                for (var i = 0; i < WebInfo.UserInfo.WalletList.length; i++) {
                    var pi = WebInfo.UserInfo.WalletList[i];

                    if ((pi.ValueType == 0) || (pi.ValueType == 2)) {
                        // 現金或區塊鏈貨幣
                        cashWallet[cashWallet.length] = pi;
                    } else if (pi.ValueType == 1) {
                        // 信用
                        creditWallet[creditWallet.length] = pi;
                    }
                }
            }
        }


        // 處理現金錢包列表
        if (cashWallet.length > 0) {
            var removeList = [];

            divCashWallet.style.display = "inline";

            // 尋找刪除
            for (var i = 0; i < divCashWalletPoint.children.length; i++) {
                var el = divCashWalletPoint.children[i];
                var foundInList = false;

                if (el.hasAttribute("CurrencyType")) {
                    var ct = el.getAttribute("CurrencyType");

                    if (ct.toUpperCase() == WebInfo.CurrencyType.toUpperCase()) {
                        el.classList.add("locActive");
                    } else {
                        el.classList.remove("locActive");
                    }

                    for (var j = 0; j < cashWallet.length; j++) {
                        var pi = cashWallet[j];

                        if (ct.toUpperCase() == pi.CurrencyType.toUpperCase()) {
                            c.setClassText(el, "PointValue", null, NumberTranslate(pi.PointValue));

                            foundInList = true;
                            break;
                        }
                    }
                }

                if (foundInList == false) {
                    removeList[removeList.length] = el;
                }
            }

            if (removeList.length > 0) {
                for (var i = 0; i < removeList.length; i++) {
                    try { divCashWalletPoint.removeChild(removeList[i]); }
                    catch (ex) { }
                }
            }

            // 尋找新增
            for (var i = 0; i < cashWallet.length; i++) {
                var pi = cashWallet[i];
                var foundInList = false;

                for (var j = 0; j < divCashWalletPoint.children.length; j++) {
                    var el = divCashWalletPoint.children[j];

                    if (el.hasAttribute("CurrencyType")) {
                        var ct = el.getAttribute("CurrencyType");

                        if (ct.toUpperCase() == pi.CurrencyType.toUpperCase()) {
                            foundInList = true;
                            break;
                        }
                    }
                }

                if (foundInList == false) {
                    var div = document.createElement("div");

                    if (pi.CurrencyType.toUpperCase() == WebInfo.CurrencyType.toUpperCase()) {
                        div.className = "TL_gameSet_list_op locActive";
                    } else {
                        div.className = "TL_gameSet_list_op";
                    }

                    div.setAttribute("CurrencyType", pi.CurrencyType);
                    div.innerHTML = "<span>" + pi.CurrencyType + "</span><span class=\"PointValue\">" + NumberTranslate(pi.PointValue) + "</span><i class=\"icon icon-ico-selected\"></i>";
                    div.onclick = function () {
                        var el = this;

                        if (el.hasAttribute("CurrencyType")) {
                            var ct = el.getAttribute("CurrencyType");

                            if (cb)
                                cb(ct);

                            CloseWallet();
                        }
                    }

                    divCashWalletPoint.appendChild(div);
                }
            }
        } else {
            divCashWallet.style.display = "none";
        }


        // 處理信用錢包列表
        if (creditWallet.length > 0) {
            var removeList = [];

            divCreditWallet.style.display = "inline";

            // 尋找刪除
            for (var i = 0; i < divCreditWalletPoint.children.length; i++) {
                var el = divCreditWalletPoint.children[i];
                var foundInList = false;

                if (el.hasAttribute("CurrencyType")) {
                    var ct = el.getAttribute("CurrencyType");

                    if (ct.toUpperCase() == WebInfo.CurrencyType.toUpperCase()) {
                        el.classList.add("locActive");
                    } else {
                        el.classList.remove("locActive");
                    }

                    for (var j = 0; j < creditWallet.length; j++) {
                        var pi = creditWallet[j];

                        if (ct.toUpperCase() == pi.CurrencyType.toUpperCase()) {
                            c.setClassText(el, "PointValue", null, NumberTranslate(pi.PointValue));

                            foundInList = true;
                            break;
                        }
                    }
                }

                if (foundInList == false) {
                    removeList[removeList.length] = el;
                }
            }

            if (removeList.length > 0) {
                for (var i = 0; i < removeList.length; i++) {
                    try { divCreditWalletPoint.removeChild(removeList[i]); }
                    catch (ex) { }
                }
            }

            // 尋找新增
            for (var i = 0; i < creditWallet.length; i++) {
                var pi = creditWallet[i];
                var foundInList = false;

                for (var j = 0; j < divCreditWalletPoint.children.length; j++) {
                    var el = divCreditWalletPoint.children[j];

                    if (el.hasAttribute("CurrencyType")) {
                        var ct = el.getAttribute("CurrencyType");

                        if (ct.toUpperCase() == pi.CurrencyType.toUpperCase()) {
                            foundInList = true;
                            break;
                        }
                    }
                }

                if (foundInList == false) {
                    var div = document.createElement("div");

                    if (pi.CurrencyType.toUpperCase() == WebInfo.CurrencyType.toUpperCase()) {
                        div.className = "TL_gameSet_list_op locActive";
                    } else {
                        div.className = "TL_gameSet_list_op";
                    }

                    div.setAttribute("CurrencyType", pi.CurrencyType);
                    div.innerHTML = "<span>" + pi.CurrencyType + "</span><span class=\"PointValue\">" + NumberTranslate(pi.PointValue) + "</span><i class=\"icon icon-ico-selected\"></i>";
                    div.onclick = function () {
                        var el = this;

                        if (el.hasAttribute("CurrencyType")) {
                            var ct = el.getAttribute("CurrencyType");

                            if (cb)
                                cb(ct);

                            CloseWallet();
                        }
                    }

                    divCreditWalletPoint.appendChild(div);
                }
            }
        } else {
            divCreditWallet.style.display = "none";
        }


        divTableMain.appendChild(walletDialog);
    }

    function API_ShowDropdownWindow(title, item, defaultValue, cbConfirm, cbCancel) {
        var idSelectBox = document.getElementById("idSelectBox");
        var divDropdownTitle = document.getElementById("idSelectBox_Title");
        var idSelectBoxCancel = document.getElementById("idSelectBoxCancel");

        if (idSelectBox != null) {
            var idSelectBoxList = document.getElementById("idSelectBoxList");

            c.setElementText("idSelectBox_Title", null, title);

            c.clearChildren(idSelectBoxList);
            if (item != null) {
                // name, value, desc
                for (var i = 0; i < item.length; i++) {
                    var eachItem = item[i];
                    var itemValue;
                    var template = c.getTemplate("idSelectBoxTemplate");
                    var textEl = c.getFirstClassElement(template, "SelectBoxText");

                    if (eachItem.value != null)
                        itemValue = eachItem.value;
                    else
                        itemValue = eachItem.name;

                    if (eachItem.value == defaultValue)
                        template.classList.add("locActive");

                    textEl.innerHTML = eachItem.name;
                    template.setAttribute("ItemValue", itemValue);

                    template.onclick = function () {
                        var v = this.getAttribute("ItemValue");

                        idSelectBox.className = "TL_gameSetlistPopUpHidden";

                        if (cbConfirm != null) {
                            cbConfirm(v);
                        }
                    };

                    idSelectBoxList.appendChild(template);
                }
            }

            idSelectBoxCancel.onclick = function () {
                idSelectBox.className = "TL_gameSetlistPopUpHidden";

                if (cbCancel != null) {
                    cbCancel();
                }
            }

            idSelectBox.className = "TL_gameSetlistPopUpShow";
        }
    }

    function showWalletUI() {
        window.parent.API_ShowWallet(mlp.getLanguageKey("切換幣別"), true, true, function (ct) {
            setCurrencyType(ct);
        });
    }

    function loginRecover() {
        window.location.href = "LoginRecover.aspx";
    }

    function setCurrencyType(c) {
        var pi = API_GetWallet(c);

        if (pi != null) {
            WebInfo.CurrencyType = pi.CurrencyType;
        } else {
            WebInfo.CurrencyType = null;
        }

        currencyType = WebInfo.CurrencyType;
        window.localStorage.setItem("CurrencyType", WebInfo.CurrencyType);

        updateBaseInfo();
    }

    // 設定顯示單位
    function setUnitType(c) {
        var unitType0 = document.getElementById("unitType0");
        var unitType1 = document.getElementById("unitType1");

        switch (c) {
            case 0:
                unitType0.className = "div_inline rm_display_sbox_active";
                unitType1.className = "div_inline rm_display_sbox";

                WebInfo.DisplayUnit = c;

                break;
            case 1:
                unitType0.className = "div_inline rm_display_sbox";
                unitType1.className = "div_inline rm_display_sbox_active";

                WebInfo.DisplayUnit = c;

                break;
        }

        window.localStorage.setItem("DisplayUnit", WebInfo.DisplayUnit);

        updateBaseInfo();
    }

    function getUserInfo(cb) {

        postObj = {
            SID: WebInfo.SID,
            GUID: Math.uuid()
        }

        c.callService(apiURL + "/GetUserInfo", postObj, function (success, content) {

            if (success) {
                var o = c.getJSON(content);

                if (o.Result == 0) {
                    WebInfo.UserInfo = o;



                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("獲取個人資料錯誤:") + mlp.getLanguageKey(o.Message));
                }
            } else {
                var o = c.getJSON(content);

                if (o == "Timeout")
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        alert(o);
            }

            if (cb)
                cb(success);
        });
    }

    function getCompanyGameCode(cb) {

        postObj = {
            GUID: Math.uuid()
        }

        c.callService(apiURL + "/GetCompanyGameCode", postObj, function (success, content) {
            if (success) {
                var o = c.getJSON(content);

                if (o.Result == 0) {
                    initGameCode(o);
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("獲取遊戲資料錯誤:") + mlp.getLanguageKey(o.Message));
                }
            } else {
                var o = c.getJSON(content);

                if (o == "Timeout")
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        alert(o);
            }

            if (cb)
                cb(success);
        });
    }

    function initGameCode(o) {
        //WebInfo.GameCodeList = o.GameCodeList;
        o.GameCodeList.forEach(e => {
            if (LobbyGameList.CategoryList[0].CategBrandList.find(eb => eb == e.BrandCode) == undefined)
                LobbyGameList.CategoryList[0].CategBrandList.push(e.BrandCode);

            if (LobbyGameList.CategoryList.find(eb => eb.Categ == e.GameCategoryCode) == undefined) {
                let data = {
                    Categ: e.GameCategoryCode,
                    CategBrandList: [
                        e.BrandCode
                    ]
                }
                LobbyGameList.CategoryList.push(data);
            }
            else {
                LobbyGameList.CategoryList.forEach(cl => {
                    if (cl.Categ == e.GameCategoryCode) {
                        if (cl.CategBrandList.find(cbl => cbl == e.BrandCode) == undefined)
                            cl.CategBrandList.push(e.BrandCode)
                    }
                })
            }

            if (LobbyGameList.GameBrandList.find(eb => eb.BrandCode == e.BrandCode) == undefined) {
                let Brand = {
                    BrandCode: e.BrandCode,
                    BrandCateg: [e.GameCategoryCode]
                }
                LobbyGameList.GameBrandList.push(Brand);
            }
            else {
                LobbyGameList.GameBrandList.forEach(eb => {
                    if (eb.BrandCode == e.BrandCode) {
                        if (eb.BrandCateg.find(eb => eb == e.GameCategoryCode) == undefined) {
                            eb.BrandCateg.push(e.GameCategoryCode);
                        }
                    }
                })
            }

            if (LobbyGameList.GameList.find(eb => eb.GameBrand == e.BrandCode) == undefined) {
                let GameData = {
                    GameBrand: e.BrandCode,
                    GameBrandList: [{
                        GameCateg: e.GameCategoryCode,
                        List: [{
                            GameName: e.GameName,
                            GameCode: e.GameCode,
                            GameCategSub: e.GameCategorySubCode,
                            Description: e.GameName,
                            IsNew: e.IsNew,
                            IsHot: e.IsHot,
                            AllowDemoPlay: e.AllowDemoPlay
                        }]
                    }
                    ]
                }
                LobbyGameList.GameList.push(GameData);
            }
            else {
                LobbyGameList.GameList.forEach(eg => {

                    if (eg.GameBrand == e.BrandCode) {
                        if (eg.GameBrandList.find(eb => eb.GameCateg == e.GameCategoryCode) == undefined) {
                            let data = {
                                GameCateg: e.GameCategoryCode,
                                List: [{
                                    GameName: e.GameName,
                                    GameCode: e.GameCode,
                                    GameCategSub: e.GameCategorySubCode,
                                    Description: e.GameName,
                                    IsNew: e.IsNew,
                                    IsHot: e.IsHot,
                                    AllowDemoPlay: e.AllowDemoPlay
                                }]
                            }
                            eg.GameBrandList.push(data);
                        }
                        else {
                            eg.GameBrandList.forEach(ebl => {
                                if (ebl.GameCateg == e.GameCategoryCode) {
                                    let data = {
                                        GameName: e.GameName,
                                        GameCode: e.GameCode,
                                        GameCategSub: e.GameCategorySubCode,
                                        Description: e.GameName,
                                        IsNew: e.IsNew,
                                        IsHot: e.IsHot,
                                        AllowDemoPlay: e.AllowDemoPlay
                                    }
                                    ebl.List.push(data);
                                }
                            })
                        }
                    }

                })
            }

            if (LobbyGameList.CategorySubList[0].CategSubList.find(eb => eb == e.GameCategorySubCode) == undefined)
                LobbyGameList.CategorySubList[0].CategSubList.push(e.GameCategorySubCode);

            if (LobbyGameList.CategorySubList.find(eb => eb.Categ == e.GameCategoryCode) == undefined) {
                let data = {
                    Categ: e.GameCategoryCode,
                    CategSubList: [
                        e.GameCategorySubCode
                    ]
                }
                LobbyGameList.CategorySubList.push(data);
            }
            else {
                LobbyGameList.CategorySubList.forEach(cl => {
                    if (cl.Categ == e.GameCategoryCode) {
                        if (cl.CategSubList.find(cbl => cbl == e.GameCategorySubCode) == undefined)
                            cl.CategSubList.push(e.GameCategorySubCode)
                    }
                })
            }

            if (LobbyGameList.CategorySubBrandList.find(eb => eb.Categ == e.GameCategoryCode && eb.Brand == e.BrandCode) == undefined) {
                let data = {
                    Categ: e.GameCategoryCode,
                    Brand: e.BrandCode,
                    CategSubList: [
                        e.GameCategorySubCode
                    ]
                }
                LobbyGameList.CategorySubBrandList.push(data);
            }
            else {
                LobbyGameList.CategorySubBrandList.forEach(cl => {
                    if (cl.Categ == e.GameCategoryCode && cl.Brand == e.BrandCode) {
                        if (cl.CategSubList.find(cbl => cbl == e.GameCategorySubCode) == undefined)
                            cl.CategSubList.push(e.GameCategorySubCode)
                    }
                })
            }
        });



        updateGameCateg(LobbyGameList.CategoryList);
        updateGameBrand(LobbyGameList.GameBrandList);

    }

    function updateGameCateg(o) {
        var idCategList = document.getElementById("id_GameCategoryList");
        o.forEach(e => {


            let tempCateg = c.getTemplate("templateCategoryItem");
            let BIcon
            /*
                        <div class="lob_gameBrandDiv">
                        <!-- 電腦版圖片 -->
                        <div class="lob_gameBrandImg">
                            <img class="BrandIcon" src="images/logo.png">
                        </div>
                        <!-- 品牌名 -->
                        <div class="lob_gameBrandName"><span class="language_replace BrandName">Ewin百家樂</span></div>
                    </div>
                     */

            let Categ = e.Categ;
            tempCateg.setAttribute("data-Categ", Categ);
            tempCateg.getElementsByClassName("lob_gameTypeName")[0].classList.add("language_replace");

            if (Categ == "All") {
                tempCateg.classList.add("lobActive");

                c.setClassText(tempCateg, "lob_gameTypeName", null, "全部");
            }
            else
                c.setClassText(tempCateg, "lob_gameTypeName", null, Categ);

            BIcon = c.getFirstClassElement(tempCateg, "gameTypeIcon");
            if (BIcon != null) {
                BIcon.src = WebInfo.EWinUrl + "/Lobby/images/lobby/icon_gametype_" + Categ + ".svg";
                //BIcon.src = "images/" + BrandCode+"/PC/" + BrandCode+".png";
            }

            tempCateg.onclick = new Function("changeGameCateg(this,'" + Categ + "')");

            idCategList.appendChild(tempCateg);
        })
    }

    function updateGameCategSub(o, brandCode) {
        var idCategSubList = document.getElementById("id_GameSubBtnList");
        var idCategSubList2 = document.getElementById("id_GameSubBtnList2");

        switch (nowGameType) {
            case "brand":
                idCategSubList2.innerHTML = "";

                o.forEach(e => {
                    var setFirstIcon = true;

                    if (e.Categ == nowCateg) {
                        if (e.Brand == brandCode) {
                            var tempCategSub = c.getTemplate("TemplateGameCategorySubBtn2");
                            tempCategSub.setAttribute("data-Categ", e.Categ);
                            c.setClassText(tempCategSub, "lob_categorySubName", null, mlp.getLanguageKey("All"));
                            c.getFirstClassElement(tempCategSub, "lob_categorySubName").setAttribute("langkey", "All");

                            idCategSubList2.appendChild(tempCategSub);
                            tempCategSub.classList.add("Active");
                            tempCategSub.onclick = new Function("showGameList('" + brandCode + "', '" + nowCateg + "','', false)");

                            //排序
                            e.CategSubList.sort(function (a, b) {
                                var A = a;
                                var B = b;

                                if (A.length > B.length) {
                                    return -1;
                                }
                                if (A.length < B.length) {
                                    return 1;
                                }

                                return 0;
                            });
                            e.CategSubList.forEach(eSub => {
                                if (eSub != "") {
                                    var tempCategSub = c.getTemplate("TemplateGameCategorySubBtn2");
                                    tempCategSub.setAttribute("data-Categ", e.Categ);

                                    c.setClassText(tempCategSub, "lob_categorySubName", null, mlp.getLanguageKey(eSub));
                                    c.getFirstClassElement(tempCategSub, "lob_categorySubName").setAttribute("langkey", eSub)

                                    tempCategSub.onclick = new Function("changeGameCategSubByBrand(this, '" + brandCode + "', '" + nowCateg + "','" + eSub + "')");
                                    idCategSubList2.appendChild(tempCategSub);
                                }

                            });
                        }
                        
                    }
                })

                break;
            case "game":
                idCategSubList.innerHTML = "";

                o.forEach(e => {
                    var setFirstIcon = true;

                    if (e.Categ == nowCateg) {
                        //排序
                        e.CategSubList.sort(function (a, b) {
                            var A = a;
                            var B = b;

                            if (A.length > B.length) {
                                return -1;
                            }
                            if (A.length < B.length) {
                                return 1;
                            }

                            return 0;
                        });
                        e.CategSubList.forEach(eSub => {
                            var tempCategSub = c.getTemplate("TemplateGameCategorySubBtn");
                            tempCategSub.setAttribute("data-Categ", e.Categ);

                            if (eSub == "") {
                                eSub = "未分類";
                            }
                            c.setClassText(tempCategSub, "lob_categorySubName", null, mlp.getLanguageKey(eSub));
                            c.getFirstClassElement(tempCategSub, "lob_categorySubName").setAttribute("langkey", eSub)

                            tempCategSub.onclick = new Function("changeGameCategSub(this,'" + eSub + "')");
                            idCategSubList.appendChild(tempCategSub);

                            if (setFirstIcon == true) {
                                setFirstIcon = false;
                                tempCategSub.classList.add("Active");
                                tempCategSub.click();
                            }
                        });
                    }
                })

                initMyFavor();

                break;
        }
    }


    function updateGameBrand(o) {
        var idGameBrandList = document.getElementById("id_GameBrandList");
        o.forEach(e => {

            e.BrandCateg.forEach(eb => {
                let tempGB = c.getTemplate("templateGameBrandItem");
                let BIcon;
                let BImg;
                /*
                            <div class="lob_gameBrandDiv">
                            <!-- 電腦版圖片 -->
                            <div class="lob_gameBrandImg">
                                <img class="BrandIcon" src="images/logo.png">
                            </div>
                            <!-- 品牌名 -->
                            <div class="lob_gameBrandName"><span class="language_replace BrandName">Ewin百家樂</span></div>
                        </div>
                         */
                let BrandCode = e.BrandCode;
                let BrandCateg = eb;
                tempGB.setAttribute("data-Categ", BrandCateg);

                c.setClassText(tempGB, "span_BrandCode", null, "<span class='language_replace'>" + BrandCode + "</span> " + "<span class='language_replace'>" + BrandCateg + "</span>");
                //tempGB.getElementsByClassName("span_BrandCode")[0].classList.add("language_replace");

                BIcon = c.getFirstClassElement(tempGB, "BrandIcon");
                if (BIcon != null) {
                    BIcon.src = WebInfo.EWinUrl + "/Lobby/images/lobby/logo/" + BrandCode + "/logoPC_" + BrandCateg + ".png";
                    //BIcon.src = "images/" + BrandCode+"/PC/" + BrandCode+".png";
                }
                BImg = c.getFirstClassElement(tempGB, "BrandImg");
                if (BImg != null) {
                    BImg.src = WebInfo.EWinUrl + "/Lobby/images/lobby/logo/" + BrandCode + "/mainImg_" + BrandCateg + ".png";
                    //BIcon.src = "images/" + BrandCode+"/PC/" + BrandCode+".png";
                }

                tempGB.onclick = new Function("showGameList('" + BrandCode + "', '" + BrandCateg + "','', true)");

                idGameBrandList.appendChild(tempGB);
            })
        })

        mlp.loadLanguage(lang);

    }

    function updateGameCode(o, categoryCode, gameBrand, categoryCodeSub) {
        var idGamePage = document.getElementById("idGamePage");
        var idGameItemTitle = document.getElementById("idGameItemTitle");
        var idGameIcon = document.getElementById("idGameIcon");
        var idGameItemList = document.getElementById("idGameItemList");
        var removeList = [];
        var insertCount = 0;

        //let GameList = WebInfo.GameCodeList.GameList;

        c.setElementText("idGameItemTitle", null, mlp.getLanguageKey(gameBrand) + "/" + mlp.getLanguageKey(categoryCode));

        // 尋找刪除
        idGameItemList.innerHTML = "";
        //for (var i = 0; i < idGameItemList.children.length; i++) {
        //    var el = idGameItemList.children[i];
        //    var foundInList = false;

        //    if (el.hasAttribute("GameCode")) {
        //        var gCode = el.getAttribute("GameCode");

        //        if (WebInfo.GameCodeList != null) {
        //            for (var j = 0; j < o.length; j++) {
        //                var gcObj = o[j];

        //                if (gcObj.GameCategoryCode == categoryCode && gcObj.BrandCode == gameBrand) {
        //                    if (gcObj.GameCode == gCode) {
        //                        foundInList = true;
        //                        break;
        //                    }
        //                }
        //            }
        //        }
        //    }

        //    if (foundInList == false) {
        //        removeList[removeList.length] = el;
        //    }
        //}

        //if (removeList.length > 0) {
        //    for (var i = 0; i < removeList.length; i++) {
        //        try { idGameItemList.removeChild(removeList[i]); }
        //        catch (ex) { }
        //    }
        //}

        // 尋找新增
        if (o != null) {
            for (var i = 0; i < o.length; i++) {
                var gcObj = o[i];
                var GI = c.getTemplate("templateGameItem");
                var GIcon;
                var canInsert = false;
                var myFavorIcon;

                if (categoryCodeSub == "") {
                    canInsert = true;


                }
                else {
                    if (o[i].GameCategSub == categoryCodeSub) {
                        canInsert = true;
                    }
                }

                if (canInsert == true) {
                    insertCount++;
                    GI.setAttribute("GameCode", gameBrand + '.' + gcObj.GameName);
                    GI.classList.add(gameBrand + '.' + gcObj.GameName);
                    c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + gcObj.GameCode + "</span>");

                    GIcon = c.getFirstClassElement(GI, "idGameIcon");
                    if (GIcon != null) {
                        GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameBrand + "/PC/" + WebInfo.Lang + "/" + gcObj.GameName + ".png";
                    }

                    //GI.onclick = new Function("API_OpenGameCode('" + gameBrand + "', '" + gcObj.GameName + "')");
                    if (gcObj.AllowDemoPlay == 0) {
                        //不允許

                    }
                    else {

                    }
                    c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + gameBrand + "', '" + gcObj.GameName + "', false)");

                    myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                    myFavorIcon.onclick = new Function("setMyFavor('" + gameBrand + "', '" + gcObj.GameName + "'," + gcObj.AllowDemoPlay + ")");

                    idGameItemList.appendChild(GI);

                }
            }

            //只有一個遊戲，直接開
            if (insertCount == 1) {
                if (directShow == true) {
                    c.getFirstClassElement(GI, "lob_gameListBtn").click();
                }
            }

            mlp.loadLanguage(WebInfo.Lang);
            initMyFavor();
        }
    }

    function showDefaultGameIcon(el) {
        el.onerror = null;
        el.src = "/Files/GamePlatformPic/default.png";
    }

    function updateBaseInfo() {
        var pi = API_GetWallet(WebInfo.CurrencyType);

        c.setElementText("idLoginAccount", null, WebInfo.UserInfo.LoginAccount);
        c.setElementText("idCurrencyType", null, WebInfo.CurrencyType);

        if (pi != null)
            c.setElementText("idWalletBalance", null, pi.PointValue);
        else
            c.setElementText("idWalletBalance", null, "0");
    }

    function NumberTranslate(v) {
        var RetValue = v;

        if (WebInfo.DisplayUnit == 1) {
            if (WebInfo.UserInfo != null) {
                if (WebInfo.UserInfo.Company != null) {
                    //系統金額單位: 0=萬/1=K/2=元
                    switch (WebInfo.UserInfo.Company.CashUnit) {
                        case 0:
                            RetValue = new BigNumber(v).multipliedBy(10000).toNumber();
                            break;
                        case 1:
                            RetValue = new BigNumber(v).multipliedBy(1000).toNumber();
                            break;
                        case 2:
                            RetValue = v;
                            break;
                    }
                }
            }
        }

        if ((RetValue != null) && (RetValue != ""))
            return (new BigNumber(RetValue).toFormat());
        else
            return RetValue;
    }

    function showGameList(brandCode, brandCateg, brandCategSub, singleGameDirectShow) {
        var divGamePage = document.getElementById("divGamePage");
        var btnGameListClose = document.getElementById("btnGameListClose");

        directShow = singleGameDirectShow;
        c.setElementText("idGameItemTitle", null, mlp.getLanguageKey(brandCode) + "/" + mlp.getLanguageKey(brandCateg));

        if (divGamePage != null) {
            for (let i = 0; i < LobbyGameList.GameList.length; i++) {
                if (LobbyGameList.GameList[i].GameBrand == brandCode) {
                    
                    for (let j = 0; j < LobbyGameList.GameList[i].GameBrandList.length; j++) {
                        if (LobbyGameList.GameList[i].GameBrandList[j].GameCateg == brandCateg) {
                            updateGameCode(LobbyGameList.GameList[i].GameBrandList[j].List, brandCateg, brandCode, brandCategSub);
                            break;
                        }
                    }

                    if (brandCategSub == "") {
                        nowCateg = brandCateg;
                        updateGameCategSub(LobbyGameList.CategorySubBrandList, brandCode);
                    }

                    //}
                }
            }

            divGamePage.classList.add("comdPopUp_show");

            btnGameListClose.onclick = function () {
                divGamePage.classList.remove("comdPopUp_show");
            }
        }
    }

    function GoBackBrandList() {
        var idGamePage = document.getElementById("idGamePage");
        var idBrandPage = document.getElementById("id_GameBrandList");
        idBrandPage.style.display = "";
        idGamePage.style.display = "none";
    }

    function changeGameCateg(e, Categ) {
        //GoBackBrandList();
        var idBrandPage = document.getElementById("id_GameBrandList");
        var lob_gameTypeDiv = document.getElementsByClassName("lob_gameTypeDiv");
        for (let i = 0; i < lob_gameTypeDiv[0].children.length; i++) {
            var el = lob_gameTypeDiv[0].children[i];
            el.classList.remove("lobActive");
        }
        e.classList.add("lobActive");
        nowCateg = Categ;
        chgGameBtn(null, nowGameType);

        if (Categ == 'All') {
            for (let i = 0; i < idBrandPage.children.length; i++) {
                var el = idBrandPage.children[i];
                el.className = "lob_gameBrandDiv BrandShow";
            }

            updateGameCategSub(LobbyGameList.CategorySubList, '');
        }
        else if (Categ == "myFavor") {
            document.getElementById("idgameLobbyMain_games").style.display = "block";
            document.getElementById("idgameLobbyMain").style.display = "none";
            document.getElementById("id_GameSubBtnList").innerHTML = "";
            changeGameCategSub(null, "myFavor");
        }
        else if (Categ == "Fast") {
            document.getElementById("idgameLobbyMain_games").style.display = "block";
            document.getElementById("idgameLobbyMain").style.display = "none";
            document.getElementById("id_GameSubBtnList").innerHTML = "";
            changeGameCategSub(null, "Fast");
        }
        else {
            for (let i = 0; i < idBrandPage.children.length; i++) {
                var el = idBrandPage.children[i];
                if (el.getAttribute("data-Categ").indexOf(Categ) > -1)
                    el.className = "lob_gameBrandDiv BrandShow";
                else
                    el.className = "lob_gameBrandDiv BrandHidden";
            }

            updateGameCategSub(LobbyGameList.CategorySubList, '');
        }
    }
    
    function changeGameCategSub(e, CategSub) {
        //GoBackBrandList();
        var idCategorySubGameListPage = document.getElementById("idCategorySubGameList");
        var lob_gamesListBtn = document.getElementsByClassName("lob_gamesListBtn");
        var GIcon;
        var GI;
        var myFavorIcon;
        var canInsert = false;

        document.getElementById("idCategorySubGameList").style.display = "none";
        idCategorySubGameListPage.innerHTML = "";

        if (CategSub == "myFavor") {
            if (GameMyFavorArr.length == 0) {
                document.getElementById("idGameListNoData").style.display = "";
            }
            else {
                document.getElementById("idGameListNoData").style.display = "none";

                for (var i = 0; i < GameMyFavorArr.length; i++) {
                    var GameCode = GameMyFavorArr[i].gameBrand + "." + GameMyFavorArr[i].gameName;
                    GI = c.getTemplate("TemplateGameCategorySubGameItem");

                    GI.classList.add(GameCode);
                    c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + GameCode + "</span>")

                    GIcon = c.getFirstClassElement(GI, "idGameIcon");
                    if (GIcon != null) {
                        GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + GameMyFavorArr[i].gameBrand + "/PC/" + WebInfo.Lang + "/" + GameMyFavorArr[i].gameName + ".png";
                    }

                    if (GameMyFavorArr[i].AllowDemoPlay == 0) {
                        //不允許

                    }
                    else {

                    }
                    c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + GameMyFavorArr[i].gameBrand + "', '" + GameMyFavorArr[i].gameName + "', false)");

                    myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                    myFavorIcon.onclick = new Function("setMyFavor('" + GameMyFavorArr[i].gameBrand + "', '" + GameMyFavorArr[i].gameName + "'," + GameMyFavorArr[i].AllowDemoPlay + ")");

                    idCategorySubGameListPage.appendChild(GI);
                }
            }
            
        }
        else {
            if (e) {
                for (var i = 0; i < lob_gamesListBtn.length; i++) {
                    lob_gamesListBtn[i].classList.remove("Active");
                }
                e.classList.add("Active");
            }

            WebInfo.GameCodeList.forEach(e => {
                canInsert = false;
                if (nowCateg == "All") {
                    if (e.GameCategorySubCode == CategSub) {
                        GI = c.getTemplate("TemplateGameCategorySubGameItem");

                        GI.classList.add(e.GameCode);
                        c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + e.GameCode + "</span>")

                        GIcon = c.getFirstClassElement(GI, "idGameIcon");
                        if (GIcon != null) {
                            GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + e.BrandCode + "/PC/" + WebInfo.Lang + "/" + e.GameName + ".png";
                        }

                        //GI.onclick = new Function("API_OpenGameCode('" + e.BrandCode + "', '" + e.GameName + "')");
                        if (e.AllowDemoPlay == 0) {
                            //不允許

                        }
                        else {

                        }
                        c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + e.BrandCode + "', '" + e.GameName + "', false)");

                        myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                        myFavorIcon.onclick = new Function("setMyFavor('" + e.BrandCode + "', '" + e.GameName + "'," + e.AllowDemoPlay + ")");

                        idCategorySubGameListPage.appendChild(GI);

                        if (idCategorySubGameListPage.innerHTML == "") {
                            document.getElementById("idGameListNoData").style.display = "";
                        } else {
                            document.getElementById("idGameListNoData").style.display = "none";
                        }
                    }
                }
                else if (nowCateg == "Fast") {
                    //外部帶入
                    if (defaultB != "") {
                        if (e.BrandCode.toUpperCase() == defaultB.toUpperCase()) {
                            if (defaultC != "") {
                                if (e.GameCategoryCode.toUpperCase() == defaultC.toUpperCase()) {
                                    if (defaultCsub != "") {
                                        if (e.GameCategorySubCode.toUpperCase() == defaultCsub.toUpperCase()) {
                                            canInsert = true;
                                        }
                                    }
                                    else {
                                        canInsert = true;
                                    }
                                }      
                            }
                            else {
                                if (defaultCsub != "") {
                                    if (e.GameCategorySubCode.toUpperCase() == defaultCsub.toUpperCase()) {
                                        canInsert = true;
                                    }
                                }
                                else {
                                    canInsert = true;
                                }
                            }
                        }
                        
                    }
                    else {
                        if (defaultC != "") {
                            if (e.GameCategoryCode.toUpperCase() == defaultC.toUpperCase()) {
                                if (defaultCsub != "") {
                                    if (e.GameCategorySubCode.toUpperCase() == defaultCsub.toUpperCase()) {
                                        canInsert = true;
                                    }
                                }
                                else {
                                    canInsert = true;
                                }
                            }
                        }
                        
                    }

                    if (canInsert == true) {
                        GI = c.getTemplate("TemplateGameCategorySubGameItem");

                        GI.classList.add(e.GameCode);
                        c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + e.GameCode + "</span>")

                        GIcon = c.getFirstClassElement(GI, "idGameIcon");
                        if (GIcon != null) {
                            GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + e.BrandCode + "/PC/" + WebInfo.Lang + "/" + e.GameName + ".png";
                        }

                        //GI.onclick = new Function("API_OpenGameCode('" + e.BrandCode + "', '" + e.GameName + "')");
                        if (e.AllowDemoPlay == 0) {
                            //不允許

                        }
                        else {

                        }
                        c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + e.BrandCode + "', '" + e.GameName + "', false)");

                        myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                        myFavorIcon.onclick = new Function("setMyFavor('" + e.BrandCode + "', '" + e.GameName + "'," + e.AllowDemoPlay + ")");

                        idCategorySubGameListPage.appendChild(GI);
                    }
                }
                else {
                    if (e.GameCategoryCode == nowCateg) {
                        if (e.GameCategorySubCode == CategSub) {
                            GI = c.getTemplate("TemplateGameCategorySubGameItem");

                            GI.classList.add(e.GameCode);
                            c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + e.GameCode + "</span>")

                            GIcon = c.getFirstClassElement(GI, "idGameIcon");
                            if (GIcon != null) {
                                GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + e.BrandCode + "/PC/" + WebInfo.Lang + "/" + e.GameName + ".png";
                            }

                            if (e.AllowDemoPlay == 0) {
                                //不允許

                            }
                            else {

                            }
                            c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + e.BrandCode + "', '" + e.GameName + "', false)");
                            //GI.onclick = new Function("API_OpenGameCode('" + e.BrandCode + "', '" + e.GameName + "')");
                            myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                            myFavorIcon.onclick = new Function("setMyFavor('" + e.BrandCode + "', '" + e.GameName + "'," + e.AllowDemoPlay + ")");

                            idCategorySubGameListPage.appendChild(GI);

                            if (idCategorySubGameListPage.innerHTML == "") {
                                document.getElementById("idGameListNoData").style.display = "";
                            } else {
                                document.getElementById("idGameListNoData").style.display = "none";
                            }
                        }
                    }
                }
            })

        }

        initMyFavor();
        mlp.loadLanguage(WebInfo.Lang, function () {
            document.getElementById("idCategorySubGameList").style.display = "block";
        });
    }

    function changeGameCategSubByBrand(e, brandCode, brandCateg, brandCategSub) {
        var lob_gamesListBtn2 = document.getElementsByClassName("lob_gamesListBtn2");

        for (var i = 0; i < lob_gamesListBtn2.length; i++) {
            lob_gamesListBtn2[i].classList.remove("Active");
        }
        e.classList.add("Active");

        showGameList(brandCode, brandCateg, brandCategSub, false)
    }
    function chgGameBtn(el, iType) {
        var lob_gameLobbyMain = document.getElementsByClassName("lob_gameLobbyMain");
        var displayType_switch_Btn_G = document.getElementsByClassName("displayType_switch_Btn_G");

        if (el) {
            for (var i = 0; i < displayType_switch_Btn_G.length; i++) {
                displayType_switch_Btn_G[i].classList.remove("Active");
            }
            el.classList.add("Active");
        }

        for (var i = 0; i < lob_gameLobbyMain.length; i++) {
            lob_gameLobbyMain[i].style.display = "none";
        }

        switch (iType) {
            case "game":
                nowGameType = "game";
                document.getElementById("idgameLobbyMain_games").style.display = "block";
                updateGameCategSub(LobbyGameList.CategorySubList, '');
                break;
            case "brand":
                nowGameType = "brand";
                if (nowCateg == "myFavor") {
                    document.getElementById("idgameLobbyMain_games").style.display = "block";
                }
                else {
                    document.getElementById("idgameLobbyMain").style.display = "block";
                }
                
                break;
        }
    }

    function setGameHistory() {
        var idLastPlayedCon = document.getElementById("idLastPlayedCon");
        var GI;
        var GIcon;

        idLastPlayedCon.innerHTML = "";
        for (var i = (GameHistoryArr.length - 1); i >= 0; i--) {
            GI = c.getTemplate("TemplatePlayedItem");

            GIcon = c.getFirstClassElement(GI, "idGameIcon");
            if (GIcon != null) {
                GIcon.src = GameHistoryArr[i].imgSrc;
            }

            idLastPlayedCon.appendChild(GI);
            if (GameHistoryArr[i].AllowDemoPlay == 0) {
                //不允許

            }
            else {

            }
            GI.onclick = new Function("API_OpenGameCode('" + GameHistoryArr[i].gameBrand + "', '" + GameHistoryArr[i].gameName + "', false)");

        }

        if (GameHistoryArr.length > 0) {
            document.getElementById("idMyLastPlayed").style.display = "";
        }

        window.localStorage.setItem("gameHistory", JSON.stringify(GameHistoryArr));

    }

    function setMyFavor(gameBrand, gameName, AllowDemoPlay) {
        var iGameHistoryInfo = new GameHistoryInfo();
        var gameExist = false;

        for (var i = 0; i < GameMyFavorArr.length; i++) {
            if (GameMyFavorArr[i].gameName == gameName) {
                if (GameMyFavorArr[i].gameBrand == gameBrand) {
                    gameExist = true;
                    GameMyFavorArr.splice(i, 1);
                    break;
                }
            }
        }

        if (gameExist == false) {
            iGameHistoryInfo.gameName = gameName;
            iGameHistoryInfo.gameBrand = gameBrand;
            iGameHistoryInfo.imgSrc = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameBrand + "/PC/" + WebInfo.Lang + "/" + gameName + ".png";
            iGameHistoryInfo.AllowDemoPlay = AllowDemoPlay;
            GameMyFavorArr.push(iGameHistoryInfo);
        }

        window.localStorage.setItem("gameMyFavor", JSON.stringify(GameMyFavorArr));
        initMyFavor();
    }

    function initMyFavor() {
        var lob_gameListDiv = document.getElementsByClassName("lob_gameListDiv");

        for (var i = 0; i < lob_gameListDiv.length; i++) {
            lob_gameListDiv[i].classList.remove("myFavor");
        }

        if (window.localStorage.getItem("gameMyFavor") != null && window.localStorage.getItem("gameMyFavor") != "") {
            GameMyFavorArr = JSON.parse(window.localStorage.getItem("gameMyFavor"));

            for (var i = 0; i < GameMyFavorArr.length; i++) {
                lob_gameListDiv = document.getElementsByClassName(GameMyFavorArr[i].gameBrand + "." + GameMyFavorArr[i].gameName);

                for (j = 0; j < lob_gameListDiv.length; j++) {
                    lob_gameListDiv[j].classList.add("myFavor");
                }
            }
        }
    }


    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                updateBaseInfo();

                break;
            case "BalanceChange":
                break;
            case "SetLanguage":

                mlp.loadLanguage(param);
                break;
        }
    }

    function chkGameExist(iIndex, iType) {
        var gameExist = false;

        switch (iType) {
            case "history":
                for (var i = iIndex; i < GameHistoryArr.length; i++) {
                    if (GameHistoryArr[i].gameBrand == "EWin") {
                        gameExist = true;
                    }
                    else {
                        gameExist = false;
                        for (j = 0; j < WebInfo.GameCodeList.length; j++) {
                            if (GameHistoryArr[i].gameBrand == WebInfo.GameCodeList[j].BrandCode) {
                                if (GameHistoryArr[i].gameName == WebInfo.GameCodeList[j].GameName) {
                                    gameExist = true;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (gameExist == false) {
                        GameHistoryArr.splice(i, 1);
                        chkGameExist(i, iType);
                    }
                }

                window.localStorage.setItem("gameHistory", JSON.stringify(GameHistoryArr));
                break;
            case "myfavor":
                for (var i = iIndex; i < GameMyFavorArr.length; i++) {
                    gameExist = false;
                    for (j = 0; j < WebInfo.GameCodeList.length; j++) {
                        if (GameMyFavorArr[i].gameBrand == WebInfo.GameCodeList[j].BrandCode) {
                            if (GameMyFavorArr[i].gameName == WebInfo.GameCodeList[j].GameName) {
                                gameExist = true;
                                break;
                            }
                        }
                    }
                    if (gameExist == false) {
                        GameMyFavorArr.splice(i, 1);
                        chkGameExist(i, iType);
                    }
                }

                window.localStorage.setItem("gameMyFavor", JSON.stringify(GameMyFavorArr));
                break;
        }
    }
    function init() {
        var idEntryMask = document.getElementById("idEntryMask");

        WebInfo = window.parent.API_GetWebInfo();
        lang = WebInfo.Lang;

        idEntryMask.style.display = "none";

        mlp = new multiLanguage();
        mlp.addLangFile("/GameBrand");
        mlp.addLangFile("/GameCode");

        mlp.loadLanguage(WebInfo.Lang, function () {
            var idDefaultGameBrand = document.getElementById("DefaultGameBrand");
            var idDefaultCompanyCode = document.getElementById("DefaultCompanyCode");

            idDefaultCompanyCode.innerText = mlp.getLanguageKey("<%=EWinWeb.CompanyCode%>");
            idDefaultGameBrand.innerText =  mlp.getLanguageKey("VIP Club")
            

            WebInfo.GameCodeList = GameCodeList.GameCodeList
            initGameCode(WebInfo);

            if (defaultB != "" || defaultC != "") {
                nowCateg = "Fast";
                document.getElementById("idCategoryFast").style.display = "";
                changeGameCateg(document.getElementById("idCategoryFast"), 'Fast')
            }

            if (window.localStorage.getItem("gameHistory") != null && window.localStorage.getItem("gameHistory") != "") {
                document.getElementById("idMyLastPlayed").style.display = "";
                GameHistoryArr = JSON.parse(window.localStorage.getItem("gameHistory"));
                //確認遊戲是否存在
                chkGameExist(0, 'history');

                setGameHistory();
            }

            if (window.localStorage.getItem("gameMyFavor") != null && window.localStorage.getItem("gameMyFavor") != "") {
                GameMyFavorArr = JSON.parse(window.localStorage.getItem("gameMyFavor"));
                //確認遊戲是否存在
                chkGameExist(0, 'myfavor');
            }
            //if ((WebInfo.CT != "") && (WebInfo.CT != null)) {
            //    getCompanyGameCode();
            //} else {
            //    //loginRecover();

            //    if (WebInfo.GameCodeList != null) {
            //        initGameCode(WebInfo);
            //    }
            //}

            resize();

        });
    }

    function resize() {
    }

    window.onload = init;
    window.onresize = resize;
</script>
<body style="width: 100%; height: 100%; overflow: hidden;">
    <!-- 底圖樣式 -->
    <div class="mainBgCube">
        <div class="mainBgCube1"></div>
        <div class="mainBgCube2"></div>
        <div class="mainBgCube3"></div>
    </div>
    <div class="lob_wrapper" id="lob_wrapper">
        <!-- Header  -->
        <!-- 頁首左 -->
        <div class="lob_headerLeft">
            <%--   <!-- 菜單按鈕 -->
            <div class="lob_NavDivBtn" onclick="NavSwitch()">
                <div class="lob_NavDivIcon">
                    <img src="images/lobby/icon_btn_menu.svg" alt="">
                </div>
                <div class="lob_NavDivIcon2">
                    <img src="images/lobby/icon_close.svg" alt="">
                </div>
            </div>
            <!-- 會員狀態 -->
            <div class="lob_memberInfo">
                <!-- 會員帳號  -->
                <div class="lob_UserIdDiv">
                    <div class="lob_InfoDivIcon">
                        <img src="images/lobby/icon_user.svg" alt="">
                    </div>
                    <div class="lob_UserIdDivNub">
                        <span id="idLoginAccount">UserID</span>
                    </div>
                </div>
                <!-- 會員錢包  -->
                <div class="lob_UserCoinDiv" onclick="showWalletUI()">
                    <div class="lob_InfoDivIcon">
                        <img src="images/lobby/icon_welletCoin.svg" alt="">
                    </div>
                    <div class="lob_InfoDivNub">
                        <span id="idCurrencyType">CNY</span>
                        <span id="idWalletBalance">0</span>
                    </div>
                </div>
            </div>--%>
        </div>

        <!-- 公司LOGO -->
        <div class="lob_LogoDiv">
            <%-- <div class="lob_LogoImg">
                <img src="images/m_logo.png" alt="">
            </div>--%>
        </div>
        <!--  -->
        <div class="lob_mainMenu">
            <!-- 頁首右 -->
            <div class="lob_headerRight">
                <%--   <!-- 功能按鈕 -->
                <div class="lob_NavDivBtn" style="display:none">
                    <div class="lob_NavDivIcon">
                        <img src="images/lobby/icon_deposit.svg" alt="">
                    </div>
                </div>
                <div class="lob_NavDivBtn" onclick="showFrameHistory()">
                    <div class="lob_NavDivIcon">
                        <img src="images/lobby/icon_history.svg" alt="">
                    </div>
                </div>
                <div id="idChatDiv" class="lob_NavDivBtn" onclick="openServiceChat()">
                    <div class="lob_NavDivIcon">
                        <img src="images/lobby/icon_service.svg" alt="">
                    </div>
                </div>
                    <div id="idChatFrameParent" class="ChatFrameParent" style="display: none;">
						<div class="ChatFrameHeader">
							<span span class="language_replace">線上客服</span>
							<div class="ChatCloseBtn" onclick="openServiceChat()"><span></span></div>
							
						</div>
                        <!--<iframe id="idChatFrame" name="idChatFrame" class="ChatFrame" border="0" frameborder="0" marginwidth="0" marginheight="0" allowtransparency="no" scrolling="no"></iframe>-->
                    </div>--%>
            </div>
            <!-- -->

            <!-- 側邊選單 -->
            <div class="lob_leftMenu">
                <!-- 關閉按鈕 -->
                <div></div>
                <!-- -->
                <div class="lob_MenuOption">
                    <div class="lob_OptionIcon">
                        <img src="images/lobby/icon_welletCoin.svg">
                    </div>
                    <div class="lob_OptionText"><span class="language_replace">選單功能1</span></div>
                </div>
                <div class="lob_MenuOption">
                    <div class="lob_OptionIcon">
                        <img src="images/lobby/icon_welletCoin.svg">
                    </div>
                    <div class="lob_OptionText"><span class="language_replace">選單功能2</span></div>
                </div>
                <div class="lob_MenuOption">
                    <div class="lob_OptionIcon">
                        <img src="images/lobby/icon_welletCoin.svg">
                    </div>
                    <div class="lob_OptionText"><span class="language_replace">選單功能3</span></div>
                </div>

            </div>
        </div>
        <!-- Header END  -->
        <!-- 遊戲分類 -->
        <!-- radio版 -->
        <!--div class="lob_gameTypeMain">
			<div class="lob_gameTypeWrapper">
                <div class="lob_gameTypeDiv">
                    <input type="radio" name="gameType" id="a0" checked>
                    <label for="a0" class="lob_gameTypeBtn">
                        <div class="lob_gameTypeIcon">
                            <img src="images/lobby/icon_gametype_all.svg">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace">全部</span></div>
                    </label>
                    <input type="radio" name="gameType" id="a1">
                    <label for="a1" class="lob_gameTypeBtn">
                        <div class="lob_gameTypeIcon">
                            <img src="images/lobby/icon_gametype_poker.svg">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace">百家樂</span></div>
                    </label>
                    <input type="radio" name="gameType" id="a2">
                    <label for="a2" class="lob_gameTypeBtn">
                        <div class="lob_gameTypeIcon">
                            <img src="images/lobby/icon_gametype_slot.svg">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace">老虎機</span></div>
                    </label>
                    <input type="radio" name="gameType" id="a3">
                    <label for="a3" class="lob_gameTypeBtn">
                        <div class="lob_gameTypeIcon">
                            <img src="images/lobby/icon_gametype_fishing.svg">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace">捕魚</span></div>
                    </label>
                </div>
            </div>
		</div-->
        <!-- DIV版 -->
        <div class="lob_gameTypeMain">
            <div class="lob_gameTypeWrapper">
                <!-- 分類方式切換 -->
                <div class="displayType_switch">
                    <div class="displayType_switch_Div">
                        <div class="displayType_switch_Tit">
                            <div class="displayType_switch_Tit_icon"></div>
                            <span class="language_replace">Display</span> :
                        </div>
                        <div class="displayType_switch_Btn">
                            <div id="idGameBtn" class="displayType_switch_Btn_G" onclick="chgGameBtn(this, 'game')">
                                <div class="displayType_switch_Btn_icon"></div>
                                <span class="language_replace">Games</span>
                            </div>
                            <div id="idBrandBtn" class="displayType_switch_Btn_G Active" onclick="chgGameBtn(this,'brand')">
                                <div class="displayType_switch_Btn_icon"></div>
                                <span class="language_replace">Brands</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- -->
                <div id="templateCategoryItem" style="display: none">
                    <div class="lob_gameTypeBtn">
                        <div class="lob_gameTypeIcon">
                            <img class="gameTypeIcon">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace span_GameTypeName">[]</span></div>
                    </div>
                </div>
                <div id="id_GameCategoryList" class="lob_gameTypeDiv">
                    <div id="idCategoryMyFavor" class="lob_gameTypeBtn" data-categ="myFavor" onclick="changeGameCateg(this,'myFavor')" >
                        <div class="lob_gameTypeIcon">
                            <img src="images/lobby/icon_gametype_Favicon.svg">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace">最愛</span></div>
                    </div>
                    <div id="idCategoryFast" class="lob_gameTypeBtn" data-categ="Fast" onclick="changeGameCateg(this,'Fast')" style="display:none">
                        <div class="lob_gameTypeIcon">
                            <img src="images/lobby/icon_gametype_Favicon.svg">
                        </div>
                        <div class="lob_gameTypeName"><span class="language_replace">指定</span></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 遊戲大廳 依品牌 -->
        <div class="lob_gameLobbyMain" id="idgameLobbyMain" style="display: block;">
            <!--height: 0px;overflow: hidden;min-height: 0px;-->
            <!-- 遊戲廠牌內容  -->

            <div id="id_GameBrandList" class="lob_gameBrandWrapper">
                <!-- 遊戲按鈕 -->
                <div class="lob_gameBrandDiv BrandShow" style="cursor: pointer" gamebrandcode="EwinBaccarat" data-categ="Baccarat" onclick="API_OpenGameCode('EWin','')">
                    <div class="lob_gameBrandPanel" data-tilt>
                        <!-- 主視覺圖片 -->
                        <div class="lob_gameBrandImg mainImgBg">
                            <img src="images/lobby/logo/demo_mainImg.png">
                        </div>
                        <!-- LOGO圖片 -->
                        <div class="lob_gameBrandImg_M mainImgLogo">
                            <img src="images/lobby/logo/demo_logoPC2.png">
                        </div>
                        <!-- 品牌名 -->
                        <div class="lob_gameBrandName"><span class="language_replace span_gameBrandName" id="DefaultCompanyCode"><%=EWinWeb.CompanyCode%></span>&nbsp;<span class="language_replace span_gameBrandName" id="DefaultGameBrand">VIP Club</span></div>
                        <div class="lob_gameBrandStart">
                            <span class="language_replace">Start</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 遊戲按鈕 -->
            <div id="templateGameBrandItem" style="display: none">
                <div class="lob_gameBrandDiv BrandShow">
                    <div class="lob_gameBrandPanel" data-tilt>
                        <!-- 主視覺圖片 -->
                        <div class="lob_gameBrandImg">
                            <img class="BrandImg" src="images/lobby/logo/demo_mainImg.png">
                        </div>
                        <!-- LOGO圖片 -->
                        <div class="lob_gameBrandImg_M">
                            <img class="BrandIcon" src="images/lobby/logo/demo_logoPC.png">
                        </div>
                        <!-- 品牌名 -->
                        <div class="lob_gameBrandName"><span class="language_replace span_BrandCode">--</span></div>
                        <div class="lob_gameBrandStart">
                            <span class="language_replace">Start</span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 遊戲大廳END -->
        </div>
        <!-- 遊戲列表 依遊戲 -->
        <div class="lob_gameLobbyMain" id="idgameLobbyMain_games" style="display: none;">
            <!-- 遊戲廠牌內容  -->
            <div id="id_GamesList" class="lob_gameBrandWrapper">
                <!-- 遊戲子分類選單 -->
                <div class="lob_gamesListHeader" id="id_GameSubBtnList">
                    
                </div>
                <!-- 遊戲列表 -->
                <div id="idCategorySubGameList" class="lob_gamesListCon">

                </div>
                <div id="idGameListNoData" style="display:none">目前無資料</div>
            </div>
        </div>
        <!-- -->

        <!-- -->
        <div class="comdPopUp_hidden" id="divGamePage">
            <div class="maskDiv"></div>
            <div class="comdCon">
                <div class="gameComdHidden gameComdShow">
                    <!--div class="comdTit">
						<span id="divGamePageTitle"></span>
					</div>
                    <hr-->
                    <div class="popUp_input_div" id="divGamePageContent" style="font-size: 32px">
                        <div class="lob_gameListWrapper" id="idGamePage">
                            <div id="templateGameItem" style="display: none">
                                <div class="lob_gameListDiv">
                                    <div class="lob_gameListBtn">
                                        <div class="lob_gameListImg">
                                            <img class="idGameIcon" onerror="showDefaultGameIcon(this)">
                                        </div>
                                        <div class="lob_gameListName"><span class="idGameName">GameName</span></div>
                                    </div>
                                    <div class="myFavorBtn"></div>
                                </div>
                            </div>
                            <div class="lob_gameListBrand">
                                <div id="btnGameListClose" class="lob_gameListBackBtn">
                                    <img src="images/lobby/icon_back.svg">
                                </div>
                                <div class="lob_gameListTit"><span id="idGameItemTitle">CG老虎機</span></div>
                                <!-- 遊戲子分類 -->
                                <!-- 遊戲子分類選單 -->
                                <div class="lob_gamesListHeader2" id="id_GameSubBtnList2">
                                    
                                </div>
                            </div>
                            <div class="lob_gameListMain" id="idGameItemList">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 遊戲列表END -->


        <!-- 跳出訊息(通用框架) -->
        <div class="comdPopUp_hidden" id="divMessageBox">
            <div class="maskDiv"></div>
            <div class="comdCon">
                <div id="divMessageBoxCloseButton" class="comdPupUp_btn_cencel"><i class="icon icon-ico-cancel"></i><span class='language_replace'>關閉</span></div>
                <div id="divMessageBoxOKButton" class="comdPupUp_btn_send"><i class="icon icon-ico-circle"></i><span class='language_replace'>確認</span></div>
                <div class="gameComdHidden gameComdShow">
                    <div class="comdTit"><span id="divMessageBoxTitle">[Title]</span></div>
                    <hr>
                    <div class="popUp_input_div" id="divMessageBoxContent" style="font-size: 32px">
                        [Content]
                    </div>
                </div>
            </div>
        </div>

        <!-- 標準選擇框, 從檯紅選擇調整來 (MaxwellLin) -->
        <div class="TL_gameSetlistPopUp" id="idSelectBox">
            <div class="memberMoneyADJ">
                <div class="TL_PopUp_title">
                    <div class="TL_PopUp_ICON"><i class="icon icon-ico-coin"></i></div>
                    <span id="idSelectBox_Title">[Title]</span>
                    <div class="TL_NavMenu_BtnClose2" id="idSelectBoxCancel"><i class="icon icon-ico-cancel"></i></div>
                </div>
                <div id="idSelectBoxTemplate" style="display: none">
                    <div class="TL_gameSet_list_op2"><span class="SelectBoxText"></span><i class="icon icon-ico-selected"></i></div>
                </div>
                <div class="TL_gameSetlistCon">
                    <div id="idSelectBoxListContainer">
                        <!--<div class="TL_gameSetlistType"><span class="language_replace">CYN可用限紅</span></div>-->
                        <div id="idSelectBoxList">
                            <!-- 如需要顯示當前選項  額外加上 locActive 的class -->
                            <div class="TL_gameSet_list_op2"><span>CNY</span><span>1,000</span> ~<span>100,000</span><i class="icon icon-ico-selected"></i></div>
                            <div class="TL_gameSet_list_op2"><span>CNY</span><span>1,000</span> ~<span>100,000</span><i class="icon icon-ico-selected"></i></div>
                            <div class="TL_gameSet_list_op2"><span>CNY</span><span>1,000</span> ~<span>100,000</span><i class="icon icon-ico-selected"></i></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="idEntryMask" style="display: block; position: relative; z-index: 9999; top: 0; left: 0; right: 0;">
            <div id="idEntryMaskText" style="font-size: 20px; color: rgb(0,0,255)"></div>
            <div id="idEntryMaskText2" style="font-size: 20px; color: rgb(0,0,255)"></div>
            <!-- 向上划動畫 -->
            <div class="EntryMaskAniDiv">
                <div class="EntryMaskAniEl">
                </div>
            </div>
            <div class="EntryMaskAniDiv2">
                <div class="EntryMaskAniSkip">
                    <div class="EntryMaskAniSkipTit"><span class="language_replace">Scroll up to fullscreen.</span></div>
                    <!-- 取消上滑按鈕 -->
                    <div class="EntryMaskAniSkipBtn" onclick="API_SlideUpMaskDisable(true)"><span class="language_replace">No,thanks.</span></div>
                </div>
            </div>
        </div>


        <div id="idTemplateList" style="display: none">
            <div id="idTemplateWallet">
                <div class="TL_gameSetlistPopUp">
                    <div class="memberMoney memberMoneyAdj">
                        <div class="TL_PopUp_title">
                            <div class="TL_PopUp_ICON"><i class="icon icon-ico-coin"></i></div>
                            <div class="Title">切換幣別</div>
                            <div class="TL_NavMenu_BtnClose"><i class="icon icon-ico-cancel"></i></div>
                        </div>
                        <div class="TL_gameSetlistCon">
                            <div class="CashWallet">
                                <div class="TL_gameSetlistType"><span class="language_replace">現金錢包</span></div>
                                <div class="CashWalletPoint">
                                    <!--<div class="TL_gameSet_list_op locActive"><span>TWD</span><span>62,345</span><i class="icon icon-ico-selected"></i></div>
							    <div class="TL_gameSet_list_op"><span>HKD</span><span>1500</span><i class="icon icon-ico-selected"></i></div>
							    <div class="TL_gameSet_list_op"><span>CNY</span><span>500</span><i class="icon icon-ico-selected"></i></div>-->
                                </div>
                            </div>
                            <div class="CreditWallet">
                                <div class="TL_gameSetlistType"><span class="language_replace">信用錢包</span></div>
                                <div class="CreditWalletPoint">
                                    <!--
							    <div class="TL_gameSet_list_op"><span>TWDC</span><span>62,345</span><i class="icon icon-ico-selected"></i></div>
							    <div class="TL_gameSet_list_op"><span>HKDC</span><span>1500</span><i class="icon icon-ico-selected"></i></div>
							    <div class="TL_gameSet_list_op"><span>CNYC</span><span>500</span><i class="icon icon-ico-selected"></i></div>-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- 遊戲歷程-->
        <div id="idMyLastPlayed" class="myLastPlayed" style="display:none">
            <div class="myLastPlayedDIv">
                <div class="myLastPlayedHeader">
                    <img src="images/lobby/icon_myLastPlayedItem_B.svg">
                    <div class="myLastPlayedHeaderText"><span class="language_replace">History</span></div>
                </div>
                <div id="idLastPlayedCon" class="myLastPlayedCon">
                    
                </div>
            </div>
        </div>

        <div id="TemplateGameCategorySubBtn" style="display:none">
            <div class="lob_gamesListBtn">
                <div class="displayType_switch_Btn_icon2"></div>
                <span class="language_replace lob_categorySubName">--</span>
            </div>
        </div>

        <div id="TemplateGameCategorySubBtn2" style="display:none">
            <div class="displayType_switch_Btn_G lob_gamesListBtn2">
                <div class="displayType_switch_Btn_icon"></div>
                <span class="language_replace lob_categorySubName">--</span>
            </div>
        </div>

        <div id="TemplateGameCategorySubGameItem" style="display:none">
            <div class="lob_gameListDiv">
                <div class="lob_gameListBtn">
                    <div class="lob_gameListImg">
                        <img class="idGameIcon" src="images/slot/slot01.png">
                    </div>
                    <div class="lob_gameListName"><span class="idGameName">GameName</span></div>
                </div>
                <div class="myFavorBtn"></div>
            </div>
        </div>

        <div id="TemplatePlayedItem" style="display:none">
            <div class="myLastPlayedItem">
                <img class="idGameIcon" src="http://ewin.dev.mts.idv.tw/Files/GamePlatformPic/PG/PC/CHS/dragon-legend.png" alt="gameIcon">
            </div>
        </div>

        <!-- 開啟iframe用框 -->
        <div id="div_History" class="iFrameWrapper" style="display: none;">
            <iframe id="frame_History" border="0" frameborder="0" marginwidth="0" marginheight="0" allowtransparency="no" scrolling="no"></iframe>
        </div>
</body>
<script type="text/javascript" src="/Lobby/js/vanilla-tilt.js"></script>
<script type="text/javascript">
    VanillaTilt.init(document.querySelectorAll(".lob_gameBrandPanel"), {
        max: 10,
        speed: 5
    });


</script>
</html>
