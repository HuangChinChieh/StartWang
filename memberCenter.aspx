<%@ Page Language="C#" %>

<%
    string Token;
    int RValue;
    int AllowChangePassword = 0;
    int AllowMemberCenter = 0;
    Random R = new Random();

    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());


    dynamic CompanySite = lobbyAPI.GetCompanySite(Token, Guid.NewGuid().ToString());
    AllowChangePassword = CompanySite.Company.AllowChangePassword;

%>
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
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<script type="text/javascript">
    var c = new common();
    var WebInfo;
    var p;
    var BackCardInfo = null;
    var postObj = null;
    var apiURL = "/memberCenter.aspx";
    var firstLoad = true;

    function nicknameEdit() {
        var nicknameEdit = document.getElementById("nicknameDiv");
        var nicknameEdit2 = document.getElementById("nicknameForm");
        nicknameEdit.style.display = "none";
        nicknameEdit2.style.display = "block";
    }

    function nicknameSend() {
        var nicknameSend = document.getElementById("nicknameDiv");
        var nicknameSend2 = document.getElementById("nicknameForm");
        nicknameSend.style.display = "block";
        nicknameSend2.style.display = "none";
    }

    function acpwEdit() {
        var acpwEdit = document.getElementById("acpwDiv");
        var acpwEdit2 = document.getElementById("acpwForm");
        acpwEdit.style.display = "none";
        acpwEdit2.style.display = "block";
    }

    function acpwSend() {
        var acpwSend = document.getElementById("acpwDiv");
        var acpwSend2 = document.getElementById("acpwForm");
        acpwSend.style.display = "block";
        acpwSend2.style.display = "none";
    }

    function wpwEdit() {
        var wpwEdit = document.getElementById("wpwDiv");
        var wpwEdit2 = document.getElementById("wpwForm");
        wpwEdit.style.display = "none";
        wpwEdit2.style.display = "block";
    }

    function wpwSend() {
        var wpwSend = document.getElementById("wpwDiv");
        var wpwSend2 = document.getElementById("wpwForm");
        wpwSend.style.display = "block";
        wpwSend2.style.display = "none";
    }

    function changeTag(e, Tag) {
        var switchTagDiv = document.getElementsByClassName("switchTagDiv");
        var divUserPage = document.getElementById("divUserPage");
        var divBankCard = document.getElementById("divBankCard");
        for (let i = 0; i < switchTagDiv[0].children.length; i++) {
            var el = switchTagDiv[0].children[i];
            el.classList.remove("active");
        }

        e.classList.add("active");
        if (Tag == 'UserPage') {
            divUserPage.style.display = "block";
            divBankCard.style.display = "none";
        }
        else if (Tag == 'BankCard') {
            divUserPage.style.display = "none";
            divBankCard.style.display = "block";
        }       
    }

    function cancelWalletPassword() {
        var idWalletPasswordSrc = document.getElementById("idWalletPasswordSrc");
        var idWalletPasswordNew1 = document.getElementById("idWalletPasswordNew1");
        var idWalletPasswordNew2 = document.getElementById("idWalletPasswordNew2");

        idWalletPasswordSrc.value = "";
        idWalletPasswordNew1.value = "";
        idWalletPasswordNew2.value = "";

        wpwSend();
    }

    function setWalletPassword() {
        var idWalletPasswordSrc = document.getElementById("idWalletPasswordSrc");
        var idWalletPasswordNew1 = document.getElementById("idWalletPasswordNew1");
        var idWalletPasswordNew2 = document.getElementById("idWalletPasswordNew2");

        if ((idWalletPasswordSrc.value == "") && (WebInfo.UserInfo.IsWalletPasswordSet == true)) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包原始密碼"));
        } else if (idWalletPasswordNew1.value == "") {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包新密碼"));
        } else if (idWalletPasswordNew1.value.length != 4) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼須超過 4 位數"));
        } else if (idWalletPasswordNew1.value != idWalletPasswordNew2.value) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("驗證密碼失敗"));
        } else {
            postObj = {
                SID: WebInfo.SID,
                GUID: Math.uuid(),
                LoginPassword: idWalletPasswordSrc.value,
                NewWalletPassword: idWalletPasswordNew1.value
            }
            p.SetWalletPassword(postObj, function (success, o) {
                if (success) {
                    if (o.Result == 0) {
                        idWalletPasswordSrc.value = "";
                        idWalletPasswordNew1.value = "";
                        idWalletPasswordNew2.value = "";
                        WebInfo.UserInfo.IsWalletPasswordSet = true;

                        window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("錢包新密碼已設定完成"), function () {
                            wpwSend();
                            updateBaseInfo();
                        });
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }
            });
        }
    }

    function cancelAccountPassword() {
        var idAccountPasswordSrc = document.getElementById("idAccountPasswordSrc");
        var idAccountPasswordNew1 = document.getElementById("idAccountPasswordNew1");
        var idAccountPasswordNew2 = document.getElementById("idAccountPasswordNew2");

        idAccountPasswordSrc.value = "";
        idAccountPasswordNew1.value = "";
        idAccountPasswordNew2.value = "";

        acpwSend();
    }

    function setAccountPassword() {
        var idAccountPasswordSrc = document.getElementById("idAccountPasswordSrc");
        var idAccountPasswordNew1 = document.getElementById("idAccountPasswordNew1");
        var idAccountPasswordNew2 = document.getElementById("idAccountPasswordNew2");

        if (idAccountPasswordSrc.value == "") {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入帳戶原始密碼"));
        } else if (idAccountPasswordNew1.value == "") {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入帳戶新密碼"));
        } else if (idAccountPasswordNew1.value.length < 4) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入4位數密碼"));
        } else if (idAccountPasswordNew1.value != idAccountPasswordNew2.value) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("驗證密碼失敗"));
        } else {
            postObj = {
                SID: WebInfo.SID,
                GUID: Math.uuid(),
                OldPassword: idAccountPasswordSrc.value,
                NewPassword: idAccountPasswordNew1.value
            }
            p.SetUserPassword(postObj, function (success, o) {
                if (success) {
                    if (o.Result == 0) {
                        idAccountPasswordSrc.value = "";
                        idAccountPasswordNew1.value = "";
                        idAccountPasswordNew2.value = "";

                        window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("帳戶新密碼已設定完成"), function () {
                            acpwSend();
                            updateBaseInfo();
                        });
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }
            });
        }
    }

    function getBankCardList(cb) {
        postObj = {
            SID: WebInfo.SID,
            GUID: Math.uuid()
        }

        p.GetUserBankCard(postObj, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    BackCardInfo = o.BankCardList;          
                    cb();
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (o == "Timeout") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }
        });
    }

    function backMainPage() {
        var idMainPage = document.getElementById("idMainPage");
        var idMaintainBankCard = document.getElementById("idMaintainBankCard");      
        
        idMainPage.style.display = "block";
        idMaintainBankCard.style.display = "none";
    }

    function addBankCard() {
        var retValue = true;
        var CurrencyType = $("#idBankCardCurrency").text();
        var PaymentType=0;
        var BankName = document.getElementById("txtBankName");
        var BranchName = document.getElementById("txtBranchName");
        var BankNumber = document.getElementById("txtBankNumber");
        var AccountName = document.getElementById("txtAccountName");
        var Description = document.getElementById("txtDescription");

        if (BankName.value == "") {
            retValue = false;
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行名稱"), null);
        }
        else if (BranchName.value == "") {
            retValue = false;
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入支行名稱"), null);
        }
        else if (BankNumber.value == "") {
            retValue = false;
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行帳號"), null);
        }
        else if (AccountName.value == "") {
            retValue = false;
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入帳戶名稱"), null);
        }

        if (retValue == true) {
            postObj = {
                SID: WebInfo.SID,
                GUID: Math.uuid(),
                CurrencyType: CurrencyType,
                PaymentMethod: PaymentType,
                BankName: BankName.value,
                BranchName: BranchName.value,
                BankNumber: BankNumber.value,
                AccountName: AccountName.value,
                Description: Description.value
            }
            p.AddUserBankCard(postObj, function (success, o) {

                if (success) {
                    if (o.Result == 0) {
                        window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("成功新增銀行卡"), function () {
                            getBankCardList(updateBaseInfo);
                        });
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                    }
                }
            });

        }
    }

    function updateBankCard() {
        var CurrencyType = $("#idBankCardCurrency").text();
        var BankCardGUID = BackCardInfo[0].BankCardGUID;
        var PaymentType = 0;
        var BankName = document.getElementById("idMBankName");
        var BranchName = document.getElementById("idMBranchName");
        var BankNumber = document.getElementById("idMBankNumber");
        var AccountName = document.getElementById("idAccountName");
        var Description = document.getElementById("idMBankName");

        postObj = {
            SID: WebInfo.SID,
            GUID: Math.uuid(),
            BankCardGUID: BankCardGUID,
            CurrencyType: CurrencyType,
            PaymentMethod: PaymentType,
            BankName: BankName.value,
            BranchName: BranchName.value,
            BankNumber: BankNumber.value,
            AccountName: AccountName.value,
            Description: Description.value
        }

        p.UpdateUserBankCard(postObj, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("成功"), function () {
                        getBankCardList(updateBaseInfo);                    
                    });
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (o == "Timeout") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }
        });
    }

    function updateBaseInfo() {
        var UserLevel = document.getElementById("idUserLevel");
        var CurrencyType = document.getElementById("idCurrencyType");
        var RealName = document.getElementById("idRealName");
        //var NickName = document.getElementById("idNickName");
        var ContactPhonePrefix = document.getElementById("idContactPhonePrefix");
        var ContactPhoneNumber = document.getElementById("idContactPhoneNumber");
        var PersonCode = document.getElementById("idPersonCode");
        var LoginAccount = document.getElementById("idLoginAccount");
        var ThresholdValue = document.getElementById("idThresholdValue");
        var UserValidBetValue = document.getElementById("idUserValidBetValue");
        var divBankCardCurrencyList = document.getElementById("tabCurrencyList");

        UserLevel.innerText = WebInfo.UserInfo.UserLevel;
        RealName.innerText = WebInfo.UserInfo.RealName;
        //NickName.innerText = WebInfo.UserInfo.BindingNickname;
        ContactPhonePrefix.innerText = WebInfo.UserInfo.ContactPhonePrefix;
        ContactPhoneNumber.innerText = WebInfo.UserInfo.ContactPhoneNumber;
        PersonCode.innerText = WebInfo.UserInfo.PersonCode;
        LoginAccount.innerText = WebInfo.UserInfo.LoginAccount;
        UserValidBetValue.innerText = WebInfo.UserInfo.UserValidBetValue;

        if (firstLoad == true) {
            CurrencyType.innerText = "";
            firstLoad = false;
            c.clearChildren(divBankCardCurrencyList);
            for (let i = 0; i < WebInfo.UserInfo.WalletList.length; i++) {
                if (i + 1 != WebInfo.UserInfo.WalletList.length)
                    CurrencyType.innerText += WebInfo.UserInfo.WalletList[i].CurrencyType + ',';
                else
                    CurrencyType.innerText += WebInfo.UserInfo.WalletList[i].CurrencyType;

                let spanCT = document.createElement("span");
                let inputCT = document.createElement("input");
                let labelCT = document.createElement("label");

                spanCT.setAttribute("CurrencyType", WebInfo.UserInfo.WalletList[i].CurrencyType.toUpperCase());
                spanCT.classList.add("myCurrencyType");

                inputCT.type = "radio";
                inputCT.id = WebInfo.UserInfo.WalletList[i].CurrencyType.toUpperCase();
                inputCT.name = "CurrencyType";
                inputCT.value = WebInfo.UserInfo.WalletList[i].CurrencyType.toUpperCase();
                inputCT.onclick = onTabSwitch;

                labelCT.className = "switchTagBtn";
                labelCT.setAttribute("for", WebInfo.UserInfo.WalletList[i].CurrencyType.toUpperCase());
                labelCT.innerHTML = "<span>" + WebInfo.UserInfo.WalletList[i].CurrencyType.toUpperCase() + "</span>";

                spanCT.appendChild(inputCT);
                spanCT.appendChild(labelCT);

                divBankCardCurrencyList.appendChild(spanCT);
            }

            onTabSwitch();
        }

    }

    function onTabSwitch() {
        var CTCurrency;
        var CTInput = document.getElementsByName("CurrencyType");
        var idBankCardList = document.getElementById("idBankCardList");
        var myCurrencyType = document.getElementsByClassName("myCurrencyType");

        c.clearChildren(idBankCardList);

        let nowCurrency = document.querySelector('input[name="CurrencyType"]:checked');
        if (nowCurrency)
            CTCurrency = document.querySelector('input[name="CurrencyType"]:checked').value;
        else

        //if (CTCurrency == null) {
        {
            if (CTInput.length >= 1) {
                CTInput[0].checked = true;
                CTCurrency = CTInput[0].value;
            }
        }

        if (BackCardInfo != null) {
            for (var i = 0; i < BackCardInfo.length; i++) {
                var bc = BackCardInfo[i];

                if (bc.CurrencyType.toUpperCase() == CTCurrency.toUpperCase()) {
                    var tmp = c.getTemplate("templateBankCardItem");
                    var elState = null;

                    c.setClassText(tmp, "BankName", null, bc.BankName);
                    c.setClassText(tmp, "BranchName", null, bc.BranchName);
                    c.setClassText(tmp, "AccountName", null, bc.AccountName);
                    c.setClassText(tmp, "BankNumber", null, bc.BankNumber);
                    c.setClassText(tmp, "Description", null, bc.Description);

                    if (bc.BankCardState == 0)
                        c.setClassText(tmp, "BankCardState", null, mlp.getLanguageKey("正常"));
                    else if (bc.BankCardState == 1)
                        c.setClassText(tmp, "BankCardState", "#ff0000", mlp.getLanguageKey("停用"));

                    elState = c.getFirstClassElement(tmp, "BankCardState");
                    if (elState != null) {
                        elState.onclick = new Function("btnDisableBankCard('" + bc.BankCardGUID + "');");
                    }

                    idBankCardList.appendChild(tmp);
                }
            }

            for (var i = 0; i < myCurrencyType.length; i++) {
                myCurrencyType[i].classList.remove("active");
                if (myCurrencyType[i].getAttribute("currencytype").toUpperCase() == CTCurrency.toUpperCase()) {
                    myCurrencyType[i].classList.add("active");

                    $("#txtBankName").val("");
                    $("#txtBranchName").val("");
                    $("#txtAccountName").val("");
                    $("#txtBankNumber").val("");
                    $("#txtDescription").val("");

                }
            }
        }

        c.setElementText("idBankCardCurrency", null, CTCurrency);
    }

    function btnClearBankCard() {
        var txtBankName = document.getElementById("txtBankName");
        var txtBranchName = document.getElementById("txtBranchName");
        var txtAccountName = document.getElementById("txtAccountName");
        var txtBankNumber = document.getElementById("txtBankNumber");
        var txtDescription = document.getElementById("txtDescription");

        if (txtBankName != null)
            txtBankName.value = "";

        if (txtBranchName != null)
            txtBranchName.value = "";

        if (txtBankNumber != null)
            txtBankNumber.value = "";

        if (txtAccountName != null)
            txtAccountName.value = "";

        if (txtDescription != null)
            txtDescription.value = "";
    }

    function btnDisableBankCard(bankCardGUID) {
        var state;
        var obc;

        for (var i = 0; i < BackCardInfo.length; i++) {
            var bc = BackCardInfo[i];

            if (bc.BankCardGUID.toUpperCase() == bankCardGUID.toUpperCase()) {
                if (bc.BankCardState == 0)
                    state = 1;
                else if (bc.BankCardState == 1)
                    state = 0;

                obc = bc;

                break;
            }
        }

        if (obc != null) {
            if (state != null) {
                postObj = {
                    SID: WebInfo.SID,
                    GUID: Math.uuid(),
                    BankCardGUID: bankCardGUID,
                    BankCardState: state
                }
                
                p.SetUserBankCardState(postObj, function (success, o) {
                    if (success) {
                        if (o.Result == 0) {
                            obc.BankCardState = state;
                        } else {
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                        }

                        onTabSwitch();
                    } else {
                        if (o == "Timeout") {
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                        } else {
                            if ((o != null) && (o != ""))
                                alert(o);
                        }
                    }
                });
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
                var lang = param;

                mlp.loadLanguage(lang);
                break;
        }
    }


    function init() {
        lang = window.top.API_GetLang();
        p = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            WebInfo = window.parent.API_GetWebInfo();

            if (WebInfo.CT != "")
                getBankCardList(updateBaseInfo);
            else {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.top.location.href = "index.aspx";
                });
            }
        });
    }
    window.onload = init;
</script>
<body>
    <div class="pageWrapper">
        <div class="pageMain">
            <div class="pageHeader">
                <div class="backBtn" style="display: none;"><span class="fa fa-arrow-left"></span></div>
                <div class="pageTitle"><span class="language_replace">會員中心</span></div>
            </div>
            <div>
                <div class="switchTagDiv">
                    <div class="switchTagBtn active" onclick="changeTag(this,'UserPage')"><span class="language_replace">會員資料</span></div>
                    <div class="switchTagBtn" onclick="changeTag(this,'BankCard')"><span class="language_replace">銀行卡</span></div>
                </div>
                <div id="idMainPage">
                    <!-- 會員資料 -->
                    <div class="pageMainCon" id="divUserPage">
                        <div class="rowHalf">
                            <div class="rowTitle"><span class="language_replace">個人資料</span></div>
                            <div class="rowElm">
                                <div class="rowLeft"><span class="language_replace">會員等級</span></div>
                                <div class="rowRight"><span id="idUserLevel">[UserLevel]</span></div>
                            </div>
                            <div class="rowElm">
                                <div class="rowLeft"><span class="language_replace">可用幣別</span></div>
                                <div class="rowRight"><span id="idCurrencyType">[CurrencyType]</span></div>
                            </div>
                            <div class="rowElm">
                                <div class="rowLeft"><span class="language_replace">真實姓名</span></div>
                                <div class="rowRight"><span id="idRealName">[RealName]</span></div>
                            </div>
                            <div class="rowElm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">電話</span></div>
                                <div class="rowRight"><span id="idContactPhonePrefix">[PhonePrefix]</span><span id="idContactPhoneNumber">[PhoneNumber]</span></div>
                            </div>
                            <div class="rowElm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">我的推薦碼</span></div>
                                <div class="rowRight">
                                    <span id="idPersonCode">[PersonCode]</span>
                                    <img src="images/icon_copy.svg">
                                </div>
                                <div class="rowBtnFull" onclick="onBtnQRCodeShow()"><span class="language_replace">顯示二維碼</span></div>
                            </div>
                            <!-- -->
                        </div>
                        <!-- -->
                        <div class="rowHalf">
                            <div class="rowTitle"><span class="language_replace">帳號資料</span></div>
                            <div class="rowElm">
                                <div class="rowLeft"><span class="language_replace">帳號</span></div>
                                <div class="rowRight"><span id="idLoginAccount">[LoginAccount]</span></div>
                            </div>
                            <!-- -->
                            <%if (AllowChangePassword == 1) { %>
                            <div class="rowElm" id="acpwDiv">
                                <div class="rowLeft"><span class="language_replace">帳號密碼</span></div>
                                <div class="rowRight"><span>***********</span></div>
                                <div class="rowBtnFull" onclick="acpwEdit()"><span class="language_replace">修改</span></div>
                            </div>
                            <!-- -->
                            <div class="rowEdit" id="acpwForm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">修改帳號密碼</span></div>
                                <div class="rowRight">
                                    <input type="password" id="idAccountPasswordSrc" language_replace="placeholder" placeholder="輸入舊密碼">
                                    <input type="password" id="idAccountPasswordNew1" language_replace="placeholder" maxlength="4" placeholder="設定新密碼">
                                    <input type="password" id="idAccountPasswordNew2" language_replace="placeholder" maxlength="4" placeholder="確認新密碼">
                                    <div class="rowBtnCon">
                                        <div class="sBtnOutline" onclick="cancelAccountPassword()"><span class="language_replace">取消</span></div>
                                        <div class="sBtnFull" onclick="setAccountPassword()"><span class="language_replace">確定修改</span></div>
                                    </div>
                                </div>
                            </div>
                            <!-- -->
                            <div class="rowElm" id="wpwDiv">
                                <div class="rowLeft"><span class="language_replace">錢包密碼</span></div>
                                <div class="rowRight"><span id="idWalletPasswordSetText">***********</span></div>
                                <div class="rowBtnFull" onclick="wpwEdit()"><span id="idWalletPasswordButtonText" class="language_replace">修改</span></div>
                            </div>
                            <!-- -->
                            <div class="rowEdit" id="wpwForm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">修改錢包密碼</span></div>
                                <div class="rowRight">
                                    <input type="password" id="idWalletPasswordSrc" language_replace="placeholder" placeholder="輸入舊密碼">
                                    <input type="password" id="idWalletPasswordNew1" language_replace="placeholder" placeholder="設定新密碼">
                                    <input type="password" id="idWalletPasswordNew2" language_replace="placeholder" placeholder="確認新密碼">
                                    <div class="rowBtnCon">
                                        <div class="sBtnOutline" onclick="cancelWalletPassword()"><span class="language_replace">取消</span></div>
                                        <div class="sBtnFull" onclick="setWalletPassword()"><span class="language_replace">確定修改</span></div>
                                    </div>
                                </div>
                            </div>
                            <%} %>
                            <!-- -->
                            <div class="rowElm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">帳號狀態</span></div>
                                <div class="rowRight"><span class="language_replace">不可提款</span></div>
                            </div>
                            <!-- -->
                            <div class="rowElm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">提款所需投注</span></div>
                                <div class="rowRight"><span id="idThresholdValue">[ThresholdValue]</span></div>
                            </div>
                            <!-- -->
                            <div class="rowElm" style="display: none;">
                                <div class="rowLeft"><span class="language_replace">目前有效投注</span></div>
                                <div class="rowRight"><span id="idUserValidBetValue">1,500</span></div>
                            </div>
                        </div>
                        <!-- 我的二維碼 -->
                        <div id="idQRCode" class="pageConMask" style="display: none;">
                            <div class="pageConMaskMain">
                                <div class="pageConMasktit"><span class="language_replace">我的二維碼</span></div>
                                <div class="myQRCODE">
                                    <img id="idImgQRCode" style="display: none">
                                </div>
                                <div class="sBtnOutline" onclick="onBtnQRCodeHide()"><span class="language_replace">關閉</span></div>
                                <div class="sBtnFull" onclick="onBtnDownloadQRCode()"><span class="language_replace">下載圖片</span></div>
                            </div>
                        </div>
                    </div>
                    <!-- 會員資料 -->
                    <!-- 銀行卡 -->
                    <div class="pageMainCon" id="divBankCard" style="display: none">
                        <div class="switchTagDiv" id="tabCurrencyList" style="display: inline-block;">
                        </div>
                        <div class="pageMainCon">
                            <div class="rowHalf">
                                <div id="templateBankCardItem" style="display: none">
                                    <div class="rowElm2L">
                                        <div class="rowLeft1T"><span class="BankName language_replace">上海浦東發展銀行</span></div>
                                        <div class="rowRight1T"><span class="BranchName language_replace">香港尖沙嘴支行</span></div>
                                        <div class="rowLeft2T"><span class="AccountName language_replace">司徒浩南</span></div>
                                        <div class="rowRight2T"><span class="BankNumber language_replace">8945562698412</span></div>
                                        <div class="rowLeft2T"><span class="Description language_replace"></span></div>
                                        <div class="rowBtnOutline"><span class="BankCardState language_replace">可使用</span></div>
                                    </div>
                                </div>
                                <div class="rowTitle"><span class="language_replace">我的銀行卡</span></div>
                                <div id="idBankCardList">
                                    <div class="BankCardNone"><span class="language_replace">查無銀行卡資料</span></div>
                                    <div class="rowElm2L">
                                        <div class="rowLeft1T"><span class="language_replace">上海浦東發展銀行</span></div>
                                        <div class="rowRight1T"><span class="language_replace">香港尖沙嘴支行</span></div>
                                        <div class="rowLeft2T"><span class="language_replace">司徒浩南</span></div>
                                        <div class="rowRight2T"><span class="language_replace">8945562698412</span></div>
                                        <div class="rowBtnOutline"><span class="language_replace">可使用</span></div>
                                    </div>
                                    <div class="rowElm2L">
                                        <div class="rowLeft1T"><span class="language_replace">上海浦東發展銀行</span></div>
                                        <div class="rowRight1T"><span class="language_replace">香港尖沙嘴支行</span></div>
                                        <div class="rowLeft2T"><span class="language_replace">司徒浩南</span></div>
                                        <div class="rowRight2T"><span class="language_replace">8945562698412</span></div>
                                        <div class="rowBtnOutline"><span class="language_replace">可使用</span></div>
                                    </div>
                                    <div class="rowElm2L">
                                        <div class="rowLeft1T"><span class="language_replace">上海浦東發展銀行</span></div>
                                        <div class="rowRight1T"><span class="language_replace">香港尖沙嘴支行</span></div>
                                        <div class="rowLeft2T"><span class="language_replace">司徒浩南</span></div>
                                        <div class="rowRight2T"><span class="language_replace">8945562698412</span></div>
                                        <div class="rowBtnGray"><span class="language_replace">停用</span></div>
                                    </div>
                                </div>
                            </div>
                            <div class="rowHalf">
                                <div class="rowTitle"><span class="language_replace">新增銀行卡</span></div>
                                <!-- -->
                                <div class="rowEdit">
                                    <div class="rowLeft"><span class="language_replace">銀行名稱</span></div>
                                    <div class="rowRight">
                                        <input type="text" id="txtBankName" placeholder="請輸入銀行名稱" language_replace="placeholder">
                                    </div>
                                </div>
                                <!-- -->
                                <div class="rowEdit">
                                    <div class="rowLeft"><span class="language_replace">支行名稱</span></div>
                                    <div class="rowRight">
                                        <input type="text" id="txtBranchName" placeholder="請輸入支行名稱" language_replace="placeholder">
                                    </div>
                                </div>
                                <!-- -->
                                <div class="rowEdit">
                                    <div class="rowLeft"><span class="language_replace">使用貨幣</span></div>
                                    <div class="rowRight">
                                        <span id="idBankCardCurrency"></span>
                                    </div>
                                </div>
                                <!-- -->
                                <div class="rowEdit">
                                    <div class="rowLeft"><span class="language_replace">帳戶名稱</span></div>
                                    <div class="rowRight">
                                        <input type="text" id="txtAccountName" placeholder="請輸入帳戶名稱" language_replace="placeholder">
                                    </div>
                                </div>
                                <!-- -->
                                <div class="rowEdit">
                                    <div class="rowLeft"><span class="language_replace">銀行帳號</span></div>
                                    <div class="rowRight">
                                        <input type="text" id="txtBankNumber" placeholder="請輸入銀行帳號" language_replace="placeholder">
                                    </div>
                                </div>
                                <!-- rowRight textarea textareaInfo -->

                                <div class="rowEdit">
                                    <div class="rowLeft"><span class="language_replace">備註</span></div>
                                    <div class="rowRight">
                                        <textarea type="text" id="txtDescription" language_replace="placeholder" name="Remarks" rows="6" cols="40"></textarea>
                                    </div>
                                </div>
                                <!-- -->
                                <div class="rowEdit">
                                    <div class="rowRightAll">
                                        <div class="rowBtnCon">
                                            <div class="sBtnOutline" onclick="btnClearBankCard()"><span class="language_replace">取消</span></div>
                                            <div class="sBtnFull" onclick="addBankCard()"><span class="language_replace">送出</span></div>
                                        </div>
                                    </div>
                                </div>


                            </div>
                        </div>
                        <!---->
                    </div>
                    <!-- 銀行卡 -->
                </div>
                <div id="idMaintainBankCard" style="display: none;">
                    <div class="rowElm">
                        <span>幣別：</span><span id="idMCurrencyType"></span>
                        <input id="idMBankName" type="text" language_replace="placeholder" placeholder="銀行" name="BankName">
                        <input id="idMBranchName" type="text" language_replace="placeholder" placeholder="分行" name="BranchName">
                        <input id="idMBankNumber" type="text" language_replace="placeholder" placeholder="銀行卡號" name="BankNumber">
                        <input id="idAccountName" type="text" language_replace="placeholder" placeholder="戶名" name="AccountName">
                        <input id="idMDescription" type="text" class="" language_replace="placeholder" placeholder="備註" name="Description">
                    </div>
                    <div>
                        <div class="mainElmBtn" id="btnAddCard" onclick="addBankCard()" style="display: none"><span class="language_replace">新增</span></div>
                        <div class="mainElmBtn" id="btnUpdateCard" onclick="updateBankCard()" style="display: none"><span class="language_replace">編輯</span></div>
                        <div class="mainElmBtn" onclick="backMainPage()"><span class="language_replace">取消</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
