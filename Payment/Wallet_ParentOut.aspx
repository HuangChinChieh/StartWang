<%@ Page Language="C#" CodeFile="Wallet_ParentOut.aspx.cs" Inherits="Wallet_ParentOut"%>

<%
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0">
    <meta name="Description" content="99PLAY">
    <title>Ewin - Crypto Currency Wallet</title>

    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="/Game/ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/Game/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/Game/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/Game/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="/Game/ico/apple-touch-icon-57-precomposed.png">

    <!-- CSS -->
    <link href="css/layout.css" rel="stylesheet" type="text/css">
    <link href="css/svgfont/styles.css" rel="stylesheet" type="text/css">
    <link href="css/wallet_layout.css" rel="stylesheet" type="text/css">
    <link href="css/media-main.css" rel="stylesheet" type="text/css">
    <link href="css/swiper.min.css" rel="stylesheet" type="text/css">
    <link href="css/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="css/99playfont/99fonts.css" rel="stylesheet" type="text/css">

    <link href="css/wallet_crypto.css" rel="stylesheet" type="text/css">

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

    <!-- Tab Switch 僅作測試用 -->
</head>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/qcode-decoder.min.js"></script>
<script type="text/javascript" src="/Scripts/clipboard.min.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="../Scripts/SelectItem.js"></script>
<script>
    var api;
    var ui = new uiControl();
    var c = new common();
    var s = new SelectItem();
    var clipboard;
    var mlp;
    var lang;
    var oLoginInfo;
    var WithdrawalCurrencyType;
    var apiURL = "/Payment/Wallet_ParentOut.aspx";
    var postObj = null;

    function showMessageOKEx(title, message, cbOK) {
        if (window.parent.showMessageOK != null) {
            window.parent.showMessageOK(title, message, cbOK);
        } else {
            showMessageOK(title, message, cbOK);
        }
    }

    function showMessageEx(title, message, cbOK, cbCancel) {
        if (window.parent.showMessage != null) {
            window.parent.showMessage(title, message, cbOK, cbCancel);
        } else {
            showMessage(title, message, cbOK, cbCancel);
        }
    }


    //function getPointInfo(c) {
    //    var retValue = null;

    //    if (oLoginInfo != null) {
    //        if (oLoginInfo.PointInfo != null) {
    //            for (var i = 0; i < oLoginInfo.PointInfo.length; i++) {
    //                if (oLoginInfo.PointInfo[i].CurrencyType.toUpperCase() == c.toUpperCase()) {
    //                    retValue = oLoginInfo.PointInfo[i];
    //                    break;
    //                }
    //            }
    //        }
    //    }

    //    return retValue;
    //}


    function btnShowRequireWithdrawal() {
        var RequireWithdrawalAmount = document.getElementById("RequireWithdrawalAmount");
        var RequireWithdrawalDescription = document.getElementById("RequireWithdrawalDescription");
        var idWithdrawalWallet = document.getElementById("idWithdrawalWallet");

        //if (EWinWebInfo != null) {
        //    if (EWinWebInfo.UserInfo != null) {
        //        if (EWinWebInfo.UserInfo.WalletList != null) {
        //            if (EWinWebInfo.UserInfo.WalletList.length > 0) {
        //                for (var i = 0; i < EWinWebInfo.UserInfo.WalletList.length; i++) {
        //                    var w = EWinWebInfo.UserInfo.WalletList[i];

        //                    if ((WithdrawalCurrencyType == null) || (WithdrawalCurrencyType == "")) {
        //                        WithdrawalCurrencyType = w.CurrencyType;
        //                        idWithdrawalWallet.innerHTML = "<span>" + w.CurrencyType + "</span><span>" + w.PointValue + "</span>";
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}

        RequireWithdrawalAmount.value = "";
        RequireWithdrawalDescription.value = "";
    }


    //function showWithdrawalWallet() {
    //    // 申請提款只允許現金錢包
    //    window.parent.API_ShowWallet(mlp.getLanguageKey("選擇錢包"), true, false, function (ct) {
    //        WithdrawalCurrencyType = ct;
    //        //updateWithdrawalInfo();
    //    });
    //}

    function btnRequireWithdrawalSubmit() {
        var sel_out = document.getElementById("sel_out");
        var RequireWithdrawalAmount = document.getElementById("RequireWithdrawalAmount");
        var RequireWithdrawalDescription = document.getElementById("RequireWithdrawalDescription");
        var allowRequire = true;
        var guid;
        var pi;

        if (sel_out.selectedIndex != -1) {
            WithdrawalCurrencyType = sel_out.options[sel_out.selectedIndex].value;
            for (var i = 0; i < EWinWebInfo.UserInfo.WalletList.length; i++) {
                if (EWinWebInfo.UserInfo.WalletList[i].CurrencyType == WithdrawalCurrencyType) {
                    pi = EWinWebInfo.UserInfo.WalletList[i];
                }
            }
            //pi = getPointInfo(WithdrawalCurrencyType);

            if (RequireWithdrawalAmount.value == "") {
                showMessageOKEx(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入要求提款金額"));
                allowRequire = false;
            } else {
                if (pi != null) {
                    var amount = Number(RequireWithdrawalAmount.value);

                    if (amount > pi.PointValue) {
                        showMessageOKEx(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("要求取款金額超過錢包餘額"));
                        allowRequire = false;
                    }
                }
            }

            if (allowRequire == true) {
                showMessageEx(mlp.getLanguageKey("確認要求提款"), mlp.getLanguageKey("將會預先從您的錢包保管額度並通知您的代理處理提款要求") + "<br>" + WithdrawalCurrencyType + " " + RequireWithdrawalAmount.value + "<br><br>" + mlp.getLanguageKey("是否確定進行?"), function () {
                    postObj = {
                        CT: EWinWebInfo.CT,
                        GUID: Math.uuid(),
                        CurrencyType: WithdrawalCurrencyType,
                        Amount: RequireWithdrawalAmount.value,
                        Description: RequireWithdrawalDescription.value
                    }

                    c.callService(apiURL + "/RequireWithdrawal", postObj, function (success, content) {
                        var o = c.getJSON(content);

                        if (success) {
                            if (o.ResultState == 0) {
                                showMessageOKEx(mlp.getLanguageKey("成功"), mlp.getLanguageKey("已保存您的額度並通知代理要求取款"), function () {
                                    btnRequireWithdrawalCancel();
                                    window.parent.API_RefreshUserInfo();
                                });
                            } else {
                                showMessageOKEx(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("要求取款失敗:") + mlp.getLanguageKey(o.Message));
                            }
                        } else {
                            if (o == "Timeout")
                                showMessageOKEx(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                            else
                                if ((o != null) && (o != ""))
                                    alert(o);
                        }
                    });
                }, function () {
                    btnRequireWithdrawalCancel();
                });
            }

        }
        else {
            showMessageOKEx(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請選擇幣別"));
        }
    }

    function btnRequireWithdrawalCancel() {
        window.parent.closeParentOut();
    }


    function init() {
        var sel_out = document.getElementById("sel_out");
        var CashUnitText = document.getElementsByClassName("CashUnitText");
        var cashUnit = "";

        EWinWebInfo = window.parent.API_GetWebInfo();
        //oLoginInfo = window.parent.API_GetUserInfo();
        lang = EWinWebInfo.Lang;

        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            if (EWinWebInfo.UserInfo.WalletList) {
                if (EWinWebInfo.UserInfo.WalletList.length > 0) {
                    for (var i = 0; i < EWinWebInfo.UserInfo.WalletList.length; i++) {
                        if (EWinWebInfo.UserInfo.WalletList[i].ValueType != 2) {
                            hasWallet = true;
                            s.addSelectItem(sel_out, EWinWebInfo.UserInfo.WalletList[i].CurrencyType + " " + c.toCurrency(EWinWebInfo.UserInfo.WalletList[i].PointValue), EWinWebInfo.UserInfo.WalletList[i].CurrencyType, false);

                        }
                    }
                }
            }

            if (EWinWebInfo.UserInfo.Company) {
                switch (EWinWebInfo.UserInfo.Company.CashUnit) {
                    case 0:
                        cashUnit = mlp.getLanguageKey("萬");
                        break;
                    case 1:
                        cashUnit = mlp.getLanguageKey("千");
                        break;
                    case 2:
                        cashUnit = mlp.getLanguageKey("元");
                        break;
                }
            }

            for (var i = 0; i < CashUnitText.length; i++) {
                CashUnitText[i].innerHTML = cashUnit;
            }

            btnShowRequireWithdrawal();
        });

    }

    window.onload = init;
</script>
    <style type="text/css">
        .wrapper_login{
            background: rgba(255,255,255,0.00);
            font-size: 16px;
            max-width: 900px;
            margin: 0px auto
        }
        .pageHeader {
            position: relative;
            width: 100%;
            height: 30px;
            line-height: 30px;
            font-size: 25px;
            margin-bottom: 10px;
        }
        .pageCloseBtn {
            box-sizing: border-box;
            position: absolute;
            width: 40px;
            height: 40px;
            top: 0px;
            right: 0px;
            border-radius: 50px;
            background-color: rgba(0,0,0,0.15);
            border: 3px solid rgba(185,161,121,0.0);
            background-image: url("images/closeIcon.svg");
            background-position: center;
            background-size: 40%;
            background-repeat: no-repeat;
            cursor: pointer;
            transition: border ease-in 0.3s;
        }
        .pageCloseBtn span {
            display: none;
        }
        .login_con2{
            background: rgba(255,255,255,0.05);
            border-radius: 20px 20px 20px 20px;
            padding: 40px 50px;
            margin-top: 25px;
            color: rgba(255,255,255,0.5);          
        }
        .TL_gameSet_list_op2{
           position: relative;
            box-sizing: border-box;
            line-height: 50px;
            margin: 9px auto;
            padding: 5px 0px;
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            padding-left: 10px;
            box-shadow: 0px 0px 8px 0px rgb(0 0 0 / 30%);
            cursor: pointer;
            transition: all ease-in 0.2s;
            min-height: 50px;
            width: 100%;
            text-indent: 5px;
            font-size: 1.3em;
        }
        	.TL_gameSet_list_op2:hover {
            background: rgba(255,255,255,0.08);
			box-shadow: 0px 2px 12px 0px rgba(0,0,0,0.5);
        }

        .TL_gameSet_list_op2 div:first-child {
            color: #fff;
        }
        
        .TL_gameSet_list_op2::after {
            content: "";
            position: absolute;
            top: 20px;
            right: 12px;
            width:25px;
            height: 25px;
            content: "";
            background-image: url(images/icon_dropdown_G.svg);
            background-size: cover;
            background-repeat: no-repeat;
        }
        .pageWrapper label span{
            margin-left: 10px;
            
        }
        .pageWrapper input{
            line-height: 50px;    
            height: 50px;
            margin-bottom: 30px;
        }
        .btn_login_Y{
            padding: 6px 10px;
            background: #c1a678;
            border-radius: 3px;
            border: 1px solid #c1a678;
            color: #fff;
            line-height: 25px;
            margin-left: 30px;
        }
        .btn_login_N{
            padding: 6px 10px;
            color: #c1a678;
            border-radius: 3px;

            border: 1px solid #c1a678;
            line-height: 25px;
        }
        .btn_login_Y,.btn_login_N{
            display: flex;
            justify-content: center;
            align-items: center;
            height: 55px;
            border-radius: 8px;
            cursor: pointer;
        }
        .rowBtnCon{
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            
        }
        select{
            padding-left:0px;
        }
    </style>
<body>
<div class="pageWrapper cryptoCurrencyWallet">
        <div class="pageMain">        
            <!--	出款申請	-->
        <div id="askCashOut" class="menberPopUp" >
            <div class="outer">
                <div class="wrapper_login">
                    <div class="pageHeader">
                        <div class="backBtn" style="display: none;"><span class="fa fa-arrow-left"></span></div>
                        <div class="pageTitle"><span class="language_replace">申請出款</span></div>
                        <div class="pageCloseBtn" onclick="btnRequireWithdrawalCancel()"><span>close</span></div>
                    </div>
                    <div class="login_con2">
                        <div class="contentGroup">
                            <div class="content">
                                <label for="code"><i class="icon icon-ico-wallet"></i><span class="language_replace">選擇錢包</span></label><br>
                                
                                <div class="TL_gameSet_list_op2" >
                                   <%--<div id="idWithdrawalWallet">
                                        <span>CNY</span><span>1,000</span> ~<span>100,000</span>
                                    </div>--%>
                                    <select id="sel_out" name="selBtc">
                                        
                                    </select>

                                </div>
                                <br>
                                <label for="RequireWithdrawalAmount"><i class="icon icon-ico-coin"></i><span class="language_replace">出款金額</span> (<span class="language_replace">單位</span>: <span class="CashUnitText"></span>)</label><br>
                                <input type="text" name="RequireWithdrawalAmount" id="RequireWithdrawalAmount"><br>
                                <label for="RequireWithdrawalDescription"><i class="icon icon-ico-tablelist"></i><span class="language_replace">備註</span></label><br>
                                <input type="text" name="RequireWithdrawalDescription" id="RequireWithdrawalDescription"><br>
                            </div>
                            <div class="rowBtnCon">
                                <div class="login_btn_con_m">
                                    <div class="btn_login_N" onclick="btnRequireWithdrawalCancel()"><i class="icon icon-ico-back"></i><span class="language_replace">返回</span></div>
                                </div>
                                <div class="login_btn_con_m">
                                    <div class="btn_login_Y" onclick="btnRequireWithdrawalSubmit()"><i class="icon icon-ico-check"></i><span class="language_replace">確定</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        </div>
    </div>

</body>
</html>
