<%@ Page Language="C#" CodeFile="Wallet_BitCoin.aspx.cs" Inherits="Wallet_BitCoin"%>

<%   
    int ShowPage = 0;  //0=收幣(QRCode), 1=打幣
    string EthWalletAddress = "";
    if (string.IsNullOrEmpty(Request["ShowPage"]) == false)
        ShowPage = Convert.ToInt32(Request["ShowPage"]);


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
<script type="text/javascript" src="../Scripts/Common.js"></script>
<script type="text/javascript" src="../Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="../Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="../Scripts/UIControl.js"></script>
<script type="text/javascript" src="../Scripts/qcode-decoder.min.js"></script>
<script type="text/javascript" src="../Scripts/clipboard.min.js"></script>
<script type="text/javascript" src="../Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="../Scripts/SelectItem.js"></script>
<script>
    var ui = new uiControl();
    var c = new common();
    var s = new SelectItem();
    var clipboard;
    var mlp;
    var lang;
    var EWinWebInfo;
    var showPage = <%=ShowPage%>;
    var api;
    var lobbyclient;
    var apiURL = "/Payment/Wallet_BitCoin.aspx";


    var EthWalletAddress = "";

    function showConfirmBitCoinTx() {
        var idConfirmBitCoinTx = document.getElementById("idConfirmBitCoinTx");
        var selBtc_out = document.getElementById("selBtc_out");
        var TxToAddress = document.getElementById("TxToAddress");
        var TxAmount = document.getElementById("TxAmount");
        var TxWalletPassword = document.getElementById("TxWalletPassword");
        var currencyType;

        if (selBtc_out.selectedIndex == -1) {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請選擇幣別"));
        } else {
            currencyType = selBtc_out.options[selBtc_out.selectedIndex].value;

            if (TxToAddress.value == "") {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入收幣錢包地址"));
            } else if (TxToAddress.value.length != 42) {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("收幣地址錯誤"));
            } else if (TxToAddress.value.substr(0, 2) != "0x") {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("收幣地址錯誤"));
            } else {
                if (TxAmount.value == "") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入打幣數量"));
                } else if (Number(TxAmount.value) < 1) {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("打幣數量錯誤, 至少要 1"));
                } else if (TxWalletPassword.value == "") {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包密碼"));
                } else {
                    for (var i = 0; i < EWinWebInfo.UserInfo.WalletList.length; i++) {
                        if (EWinWebInfo.UserInfo.WalletList[i].ValueType == 2) {
                            if (EWinWebInfo.UserInfo.WalletList[i].CurrencyType == currencyType) {
                                pi = EWinWebInfo.UserInfo.WalletList[i];
                            }
                        }
                    }
                    //pi = window.parent.API_GetWallet(currencyType);
                    if (pi != null) {
                        if (pi.PointValue >= Number(TxAmount.value)) {
                            var TxOutFromAddress = document.getElementById("TxOutFromAddress");
                            var TxOutToAddress = document.getElementById("TxOutToAddress");
                            var TxOutCurrencyType = document.getElementById("TxOutCurrencyType");
                            var TxOutAmount = document.getElementById("TxOutAmount");
                            var cashUnit;

                            cashUnit = EWinWebInfo.UserInfo.Company.CashUnit;

                            c.setElementText("TxOutFromAddress", null, EthWalletAddress);
                            c.setElementText("TxOutToAddress", null, TxToAddress.value);
                            c.setElementText("TxOutCurrencyType", null, currencyType);
                            c.setElementText("TxOutAmount", null, TxAmount.value + " Token");

                            c.addClassName(idConfirmBitCoinTx, "settingPopUp_show");
                        } else {
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("錢包餘額不足"));
                        }
                    } else {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("錢包錯誤"));
                    }
                }
            }
        }
    }

    function closeConfirmBitCoinTx() {
        var idConfirmBitCoinTx = document.getElementById("idConfirmBitCoinTx");

        c.removeClassName(idConfirmBitCoinTx, "settingPopUp_show");
    }


    function setETHBitCoinTx() {
        var idConfirmBitCoinTx = document.getElementById("idConfirmBitCoinTx");
        var api;
        var selBtc_out = document.getElementById("selBtc_out");
        var TxToAddress = document.getElementById("TxToAddress");
        var TxAmount = document.getElementById("TxAmount");
        var TxWalletPassword = document.getElementById("TxWalletPassword");
        var currencyType;
        var realAmount;
        var cashUnit;
        var postObj;


        cashUnit = EWinWebInfo.UserInfo.Company.CashUnit;
        currencyType = selBtc_out.options[selBtc_out.selectedIndex].value;

        //realAmount = new BigNumber(Number(TxAmount.value)).dividedBy(cashUnit);

        ui.showMask(null, "<span style='font-size: 32px; color: #ffffff'>" + mlp.getLanguageKey("執行中...") + "</span>");

        postObj = {
            CT: EWinWebInfo.CT,
            GUID: Math.uuid(),
            WalletPassword: TxWalletPassword.value,
            ToAddress: TxToAddress.value,
            CurrencyType: currencyType,
            Amount: TxAmount.value,
        }

        c.callService(apiURL + "/ETHBitCoinTx", postObj, function (success, content) {
            ui.hideMask();

            if (success) {
                var o = c.getJSON(content);
                if (o.ResultState == 0) {
                    window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("已傳送至區塊鏈網路中, 請等待區塊鏈交易完成"), function () {
                        //updateWalletBalance();
                        closeConfirmBitCoinTx();
                    });
                } else {
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                }
            } else {
                var o = c.getJSON(content);

                if (o == "Timeout")
                    window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        alert(o);
            }
        });
    }

    function QRScan(el) {
        var idErrorToAddress = document.getElementById("idErrorToAddress");
        var idErrorToAddressText = document.getElementById("idErrorToAddressText");
        var TxToAddress = document.getElementById("TxToAddress");


        idErrorToAddress.style.display = "none";

        if (el.files != null) {
            if (el.files.length > 0) {
                var fr = new FileReader();
                var userImageFile = el.files[0];

                fr.onload = function () {
                    //alert(fr.result);
                    setTimeout(function () {
                        qr.decodeFromImage(fr.result, function (err, res) {
                            if (err) {
                                idErrorToAddress.style.display = "block";
                                idErrorToAddressText.innerHTML = mlp.getLanguageKey("QRCode 不存在");
                            } else {
                                if (res != null) {
                                    if (res.length == 42) {
                                        if (res.substr(0, 2) == "0x") {
                                            idErrorToAddress.style.display = "none";
                                            TxToAddress.value = res;
                                        } else {
                                            idErrorToAddress.style.display = "block";
                                            idErrorToAddressText.innerHTML = mlp.getLanguageKey("地址錯誤");
                                        }
                                    } else {
                                        idErrorToAddress.style.display = "block";
                                        idErrorToAddressText.innerHTML = mlp.getLanguageKey("地址錯誤");
                                    }
                                }
                            }
                        });
                    }, 500);

                    //alert(fr.result);
                }

                //alert(userImageFile);
                fr.readAsDataURL(userImageFile);
            }
        }
    }

    //function updateWalletBalance() {
    //    var pi;
    //    var idTxWallet = document.getElementById("idTxWallet");
    //    var CurrencyType;
    //    var cashUnit;

    //    cashUnit = EWinWebInfo.UserInfo.Company.CashUnit;

    //    if (idTxWallet.selectedIndex != -1) {
    //        CurrencyType = idTxWallet.options[idTxWallet.selectedIndex].value;

    //        pi = window.parent.API_GetWallet(CurrencyType);
    //        if (pi != null) {
    //            c.setElementText("idBitCoinBalance", null, (new BigNumber(pi.PointValue).multipliedBy(cashUnit)).toString() + " Token");
    //        }
    //    }
    //}


    function btnConfirmWalletPassword() {
        var idWalletLoginPassword = document.getElementById("idWalletLoginPassword");
        var idWalletSetPassword = document.getElementById("idWalletSetPassword");
        var idWalletSetPassword2 = document.getElementById("idWalletSetPassword2");

        if (idWalletLoginPassword.value == "") {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入密碼"));
        } else if (idWalletSetPassword.value == "") {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包密碼"));
        } else if (idWalletSetPassword2.value == "") {
            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入確認錢包密碼"));
        }
         else {
            if (idWalletSetPassword.value != idWalletSetPassword2.value) {
                window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("錢包密碼確認失敗"));
            } else {

                ui.showMask(null, "<span style='font-size: 32px; color: #ffffff'>" + mlp.getLanguageKey("執行中...") + "</span>");
                postObj = {
                    SID: EWinWebInfo.SID,
                    GUID: Math.uuid(),
                    LoginPassword: idWalletLoginPassword.value,
                    NewWalletPassword: idWalletSetPassword.value
                }

                c.callService(apiURL + "/SetWalletPassword", postObj, function (success, content) {
                    ui.hideMask();
                    var o = c.getJSON(content);
                    if (success) {
                        if (o.Result == 0) {
                            window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("錢包密碼已設定"), function () {
                                var UI;
                                EWinWebInfo.UserInfo.IsWalletPasswordSet = true;
                                btnCloseWalletPassword();
                            });
                        } else {
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                        }
                    } else {
                        if (o == "Timeout")
                            window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                        else
                            if ((o != null) && (o != ""))
                                alert(o);
                    }
                });
            }
        }
    }

    function btnCloseWalletPassword() {
        var idWalletPassword = document.getElementById("idWalletPassword");

        c.removeClassName(idWalletPassword, "settingPopUp_show");
    }

    function checkEthState() {

        //api.ETHCheckBitCoinTxState(Math.uuid(), function (success, o) {
        //    var idMaskBitCoinOut = document.getElementById("idMaskBitCoinOut");
        //    var idMaskBitCoinOutText = document.getElementById("idMaskBitCoinOutText");

        //    if (success) {
        //        if (o.ResultState == 0) {
        //            idMaskBitCoinOut.style.display = "none";
        //        } else {
        //            idMaskBitCoinOut.style.display = "block";
        //            c.setElementText("idMaskBitCoinOutText", null, mlp.getLanguageKey("錢包目前忙碌中, 請稍後再進行操作"));
        //        }
        //    }
        //});
    }

    function setTabIndexAndCheckWallet(className, tabIndex) {
        setTabIndex(className, tabIndex, function () {
            if (tabIndex == 1) {
                // 轉出, 檢查錢包密碼
                var idWalletPassword = document.getElementById("idWalletPassword");

                if (EWinWebInfo.UserInfo.IsWalletPasswordSet == false) {
                    c.addClassName(idWalletPassword, "settingPopUp_show");
                }
            }
        });
    }

    function setTabIndex(className, tabIndex, cb) {
        var tabList = document.getElementsByClassName(className);
        var pageList = document.getElementsByClassName("tabPage");

        for (var i = 0; i < tabList.length; i++) {
            if (tabIndex == i) {
                c.addClassName(tabList[i], "active");
                pageList[i].style.display = "block";
            } else {
                c.removeClassName(tabList[i], "active");
                pageList[i].style.display = "none";
            }
        }

        if (cb != null)
            cb();
    }

    function init() {
        var selBtc_In = document.getElementById("selBtc_In");
        var selBtc_out = document.getElementById("selBtc_out");
        var hasWallet = false;

        EWinWebInfo = window.parent.API_GetWebInfo();
        EthWalletAddress = EWinWebInfo.UserInfo.EthWalletAddress;
        clipboard = new ClipboardJS(".clipbtn");

        clipboard.on('success', function (e) {
            var idToastCopied = document.getElementById("idToastCopied");

            idToastCopied.classList.add("show");
            setTimeout(function () {
                idToastCopied.classList.remove("show");
            }, 3000);

            e.clearSelection();
        });

        mlp = new multiLanguage();
        mlp.loadLanguage(EWinWebInfo.Lang, function () {
            // 顯示 page 0
            if (EWinWebInfo) {
                if (EWinWebInfo.UserInfo) {
                    if (EWinWebInfo.UserInfo.EthWalletAddress != "") {
                        document.getElementById("img_QRCode").src = "/GetQRCode.aspx?Data=" + encodeURIComponent(EWinWebInfo.UserInfo.EthWalletAddress);
                        document.getElementById("idEthAddr").value = EWinWebInfo.UserInfo.EthWalletAddress;
                    }
                    if (EWinWebInfo.UserInfo.WalletList) {
                        if (EWinWebInfo.UserInfo.WalletList.length > 0) {
                            for (var i = 0; i < EWinWebInfo.UserInfo.WalletList.length; i++) {
                                if (EWinWebInfo.UserInfo.WalletList[i].ValueType == 2) {
                                    hasWallet = true;
                                    s.addSelectItem(selBtc_In, EWinWebInfo.UserInfo.WalletList[i].CurrencyType, EWinWebInfo.UserInfo.WalletList[i].CurrencyType, false);
                                    s.addSelectItem(selBtc_out, EWinWebInfo.UserInfo.WalletList[i].CurrencyType + " " + c.toCurrency(EWinWebInfo.UserInfo.WalletList[i].PointValue), EWinWebInfo.UserInfo.WalletList[i].CurrencyType, false);

                                }
                            }
                        }
                    }

                    if (hasWallet == false) {
                        window.parent.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("未設定區塊鏈幣別"), function () {
                            window.parent.closeBitCoinAddress();
                        });
                    }
                }
            }
                
            setTabIndexAndCheckWallet('switchTagBtn', showPage);
            //updateWalletBalance();
        });

        checkEthState();
        window.setInterval(function () {
            checkEthState();
        }, 10000);
    }

    window.onload = init;
</script>
<body>
    <div class="pageWrapper cryptoCurrencyWallet">
        <div class="pageMain">
            <div class="pageHeader">
                <div class="backBtn" onclick="window.parent.closeBitCoinAddress();">
                    <img src="images/closeIcon.svg"><span class="language_replace">關閉</span>
                </div>
                <div class="pageTitle"><span class="language_replace">區塊鏈錢包</span></div>
            </div>
            <div>
                <div id="idTabList" class="switchTagDiv">
                    <!-- 使用中頁籤加上"active"-->
                    <div class="switchTagBtn active" onclick="setTabIndexAndCheckWallet('switchTagBtn', 0)"><span class="language_replace">存幣</span></div>
                    <div class="switchTagBtn" onclick="setTabIndexAndCheckWallet('switchTagBtn', 1)"><span class="language_replace">打幣</span></div>
                    <!-- <div class="switchTagBtn" onclick="setTabIndexAndCheckWallet('switchTagBtn', 2)"><span class="language_replace">兌換</span></div> -->
                    <!-- <div class="switchTagBtn" onclick="setTabIndexAndCheckWallet('switchTagBtn', 3)"><span>錢包歷程</span></div>   -->
                </div>

                <!-- 存幣 -->
                <div class="tabPage pageMainCon cryptoPurchase" style="display: none;">
                    <div class="rowOne">
                        <!-- 
                                如有兩種以上貨幣，顯示 "下拉icon"
                                且按下時， 切換幣別 idTemplateWallet 會開啟
                            -->
                        <div class="rm_list_input">
                            <!-- 幣別下拉選單 (新) -->
                            <div class="rm_list_menu">
                                <div class="select">
                                    <div class="titleBcoin"><span class="language_replace">幣別</span></div>
                                    <select id="selBtc_In" name="selBtc">
                                        
                                    </select>
                                    <%--<select id="#" name="#">
                                        <%
                                            if (PointDT != null)
                                            {
                                                foreach (System.Data.DataRow PointDR in PointDT.Rows)
                                                {
                                                    if (((int)PointDR["PointState"] == 0) && ((int)PointDR["ValueType"] == 2))
                                                    {
                                        %>
                                        <option value="<%=(string)PointDR["CurrencyType"] %>"><%=(string)PointDR["CurrencyType"] %></option>
                                        <%
                                                        break;
                                                    }
                                                } 
                                            }
                                        %>
                                    </select>--%>
                                </div>
                            </div>
                        </div>
                        <div class="qrCode">
                            <img id="img_QRCode" src="" alt="">
                        </div>
                        <div class="row">
                            <div class="rm_list_input dark">
                                <input type="text" id="idEthAddr" class="input-round rm_list_pre" value="">

                                <div class="rm_list_last">
                                    <!-- 按下時，出現 Toast元件, 且預設3秒後消失-->
                                    <button class="btn btn-text-main clipbtn" data-clipboard-target="#idEthAddr"><i class="icon icon2020-ico-files-o"></i><span class="language_replace">複製地址</span></button>
                                </div>
                                <!--Toast元件 要出現時 加入 class=> show -->
                                <div id="idToastCopied" class="toastCopied">
                                    <span class="language_replace">已複製</span>
                                </div>
                            </div>
                        </div>
                        <%--<div class="row">
                            <button class="btn btn_full_main_gradient" onclick="window.location.href='/GetQRCode.aspx?QRCode=<%=Server.UrlEncode(EthWalletAddress) %>&Download=1'"><i class="icon icon2020-ico-download-o"></i><span class="language_replace">下載圖片</span></button>
                        </div>--%>
                    </div>
                </div>

                <!-- 打幣 -->
                <div class="tabPage pageMainCon cryptoPayout" style="display: none;">

                    <!-- 不可用MASK 要出現請使用BLOCK-->
                    <div id="idMaskBitCoinOut" class="noticeText" style="display: none">
                        <div class="noticeFlex">
                            <span id="idMaskBitCoinOutText" class="language_replace">區塊鍊交易忙碌中...</span>
                        </div>
                    </div>
                    <!---->
                    <div class="rowOne">
                        <!-- 
                                如有兩種以上貨幣，顯示 "選擇幣別列"
                                且按下時， 切換幣別 idTemplateWallet 會開啟
                            -->
                        <!-- 選擇幣別列 -->
                        <div class="row" style="display: block;">
                            <div class="rm_list_input input-notice">
                                <div class="rm_list_menu">
                                    <div class="select">
                                        <div class="titleBcoin"><span class="language_replace">幣別</span></div>
                                        <select id="selBtc_out" name="selBtc" >
                                            
                                        </select>
                                        <%-- <select id="idTxWallet" name="#" onchange="updateWalletBalance()">
                                            <%
                                                if (PointDT != null)
                                                {
                                                    foreach (System.Data.DataRow PointDR in PointDT.Rows)
                                                    {
                                                        if (((int)PointDR["PointState"] == 0) && ((int)PointDR["ValueType"] == 2))
                                                        {
                                            %>
                                            <option value="<%=(string)PointDR["CurrencyType"] %>"><%=(string)PointDR["CurrencyType"] %></option>
                                            <%
                                                            break;
                                                        }
                                                    }
                                                }
                                            %>
                                        </select>--%>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="cryptoBalance" style="display: none;">
                            <p class="cryptoBalance_title language_replace">目前餘額</p>
                            <p class="cryptoBalance_balance" id="idBitCoinBalance">[Balance]</p>
                        </div>
                        <div class="row">
                            <div class="rm_list_input input-notice">
                                <input type="text" id="TxToAddress" class="input-round rm_list_pre" language_replace="placeholder" placeholder="輸入發送錢包地址">
                                <div class="rm_list_last">
                                    <div class="scanQrcode">
                                        <i class="icon icon2020-ico-qrcode"></i>
                                        <input type="file" onchange="QRScan(this)" accept="image/*" id="idQRImage" name="idQRImage" class="custom_input_file">
                                    </div>
                                </div>
                                <div id="idErrorToAddress" class="notice error"><i class="icon icon2020-information"></i><span class="language_replace" id="idErrorToAddressText">錢包地址錯誤</span></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="rm_list_input input-notice">
                                <!-- 輸入驗證錯誤時，在 input 加入class => error 
                                         驗證正確時，移除 class => error-->
                                <input type="number" id="TxAmount" class="input-round error" language_replace="placeholder" placeholder="取幣數量">
                                <div class="notice error"><i class="icon icon2020-information"></i><span class="language_replace">最少轉出數量為 1.0</span></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="rm_list_input input-notice">
                                <!-- 輸入驗證錯誤時，在 input 加入class => error 
                                         驗證正確時，移除 class => error-->
                                <input id="TxWalletPassword" type="password" class="input-round" language_replace="placeholder" placeholder="錢包密碼">
                                <div class="notice error"><i class="icon icon2020-information"></i><span class="language_replace">驗證錯誤提示</span></div>
                            </div>
                        </div>
                        <div class="cryptoBalance_Calculation">
                            <!-- 暫時不設定手續費 -->
                            <!--
                                <div class="cryptoBalanceCal_limitation">
                                    <div class="row cryptoBalanceCal_limitTimeOfUse">
                                        <span class="title"><span class="language_replace">本日可用次數</span></span>  
                                        <span class="value">3</span>
                                        <span class="currency"><span class="language_replace">次</span></span>
                                    </div>
                                    <div class="row cryptoBalanceCal_limitAmount">
                                        <span class="title"><span class="language_replace">本日可用額度</span></span>
                                        <span class="value">100</span>
                                        <span class="currency">USDT</span>
                                    </div>
                                    <div class="row cryptoBalanceCal_fees">
                                        <span class="title"><span class="language_replace">手續費</span></span>
                                        <span class="value">0.02</span>
                                        <span class="currency">USDT</span>
                                    </div>
                                </div>                                
                                <div class="row cryptoBalanceCal_total">
                                    <span class="title"><span class="language_replace">合計</span></span>
                                    <span class="value">1111111112.02</span>
                                    <span class="currency">USDT</span>
                                </div>
                                -->
                            <!-- 按鈕開啟 打幣確認 視窗 -->
                            <button class="btn btn_full_main_gradient" onclick="showConfirmBitCoinTx()"><i class="icon icon2020-ico-coin-o"></i><span class="language_replace">我要取幣</span></button>
                        </div>
                        <!--div class="pageFooter">
                            <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                            <div class="rowList">
                                <ol>
                                    <li><span class="language_replace">外部錢包地址需要支付手續費，手續費會動態變更。</span></li>
                                    <li><span class="language_replace">虛擬貨幣交易一經發送就無法取消或更改，請特別留意。若提供的地址錯誤，恕本公司無法負責。</span></li>
                                    <li><span class="language_replace">僅支援 ERC-20 版本的 USDT貨幣。</span></li>
                                </ol>
                            </div>
                        </div-->

                    </div>
                </div>

                <!-- 兌換 -->
                <div class="tabPage pageMainCon cryptoExchange" style="display: none;">
                    <div class="rowOne">
                        <!-- 幣值轉換 Button 按下後 class 加入 switch => class="Currency_Exchange default switch" 虛擬貨幣錢包 和 現金錢包會互換位置，並重新計算-->
                        <div class="Currency_Exchange default ">
                            <!-- 預設為虛擬貨幣錢包 -->
                            <div class="CurrencyArea">
                                <h2 class="currencyTypeTitle"><span class="language_replace">虛擬貨幣</span></h2>
                                <!-- 幣別選擇-->
                                <!-- 
                                    如有兩種以上貨幣，按下時， 切換幣別 idTemplateWallet 會開啟
                                     -->
                                <div class="rm_list_input">
                                    <div class="rm_list_menu">
                                        <div class="rm_list_tit">
                                            <div class="currencyType"><i class="icon icon2020-ico-coin-ustd icon-round"></i>USDT</div>
                                            <div class="available_Balance">
                                                <span class="title"><span class="language_replace">可用餘額</span></span>
                                                <span class="amount">11111.3659</span>
                                            </div>
                                            <!-- 如有兩種以上貨幣，再開啟此icon -->
                                            <!-- <i class="icon icon-ico-arrow-down icon-round"></i> -->
                                        </div>

                                    </div>
                                </div>
                                <!-- 幣值計算區 -->
                                <div class="exchange_Calculation">
                                    <div class="item exchange_Amount">
                                        <span class="title"><span class="language_replace">轉換金額</span></span>
                                        <span class="amount">23611.1203</span>
                                    </div>
                                </div>
                            </div>
                            <!-- 預設為法幣現金錢包 -->
                            <div class="CurrencyArea">
                                <h2 class="currencyTypeTitle"><span class="language_replace">現金</span></h2>
                                <!-- 幣別選擇-->
                                <!-- 
                                    如有兩種以上貨幣，按下時， 切換幣別 idTemplateWallet 會開啟
                                     -->
                                <div class="rm_list_input">
                                    <div class="rm_list_menu">
                                        <div class="rm_list_tit">
                                            <div class="currencyType">CNY</div>
                                            <div class="available_Balance">
                                                <span class="title"><span class="language_replace">可用餘額</span></span>
                                                <span class="amount">111112222.3659</span>
                                            </div>
                                            <i class="icon icon-ico-arrow-down icon-round"></i>
                                        </div>

                                    </div>
                                </div>
                                <!-- 幣值計算區 -->
                                <div class="exchange_Calculation">
                                    <div class="item exchange_Amount">
                                        <span class="title"><span class="language_replace">轉換金額</span></span>
                                        <span class="amount">13644551.0023</span>
                                    </div>
                                </div>
                            </div>
                            <!-- 幣值轉換 Button -->
                            <div class="Btn_exchangeCurrency">
                                <button class="btn btn-exchange"><i class="icon icon2020-ico-exchange-right"></i></button>
                            </div>
                        </div>
                        <div class="row-fluid">
                            <div class="rm_list_input input_exchange">
                                <div class="title"><i class="icon icon2020-ico-coin-o"></i></div>
                                <input type="text" class="input-round rm_list_pre" language_replace="placeholder" placeholder="請輸入欲轉換之金額">
                                <div class="rm_list_last"><span class="currencyType">USDT</span></div>
                            </div>

                            <p class="notice remind">
                                <span class="
                                    title language_replace">匯率</span><span class="value">0.0005</span>
                            </p>
                        </div>
                        <div class="row">
                            <button class="btn btn_full_main_gradient"><span class="language_replace">確認兌換</span></button>
                        </div>
                    </div>
                    <div class="pageFooter">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList">
                            <ol>
                                <li><span class="language_replace">試算結果及匯率僅提供參考，實際匯率仍以交易當時匯率為準。</span></li>
                            </ol>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <!-- 設定錢包密碼 -->
    <!-- 設定錢包密碼 視窗 => 要跳出視窗時，加入 class="settingPopUp_show"-->
    <div id="idWalletPassword" class="settingPopUpNew settingPopUp_transferOutConfirm settingPopUp_hidden">
        <div class="maskDiv"></div>
        <div class="settingPopUpWrapper">
            <div class="PopUp_Header">
                <div class="PopUp_Header_ICON"><i class="icon icon-ico-wallet"></i></div>
                <div class="PopUp_Header_Title"><span class="language_replace">設定錢包密碼</span></div>
                <div class="PopUp_Header_BtnClose" onclick="btnCloseWalletPassword()"><i class="icon icon-ico-cancel"></i></div>
            </div>
            <div class="PopUp_Content">
                <div class="noticeDiv">
                    <div class="noticeTit"><span class="language_replace">你還未設定錢包密碼</span></div>
                    <div class=""><span class="language_replace">請先完成錢包密碼設定，您也可在會員中心裡進行設定。</span></div>
                </div>
                <div class="popUpRow walletAddress">
                    <div class="rm_list_input input-notice">
                        <!-- 輸入驗證錯誤時，在 input 加入class => error 
                          驗證正確時，移除 class => error-->
                        <input id="idWalletLoginPassword" type="password" class="input-round" language_replace="placeholder" placeholder="輸入帳戶密碼">
                        <!--
                        <div class="notice error">
                            <i class="icon icon2020-information"></i><span class="language_replace">驗證錯誤提示</span>
                        </div>
                        -->
                    </div>
                </div>
                <div class="popUpRow walletAddress">
                    <div class="rm_list_input input-notice">
                        <!-- 輸入驗證錯誤時，在 input 加入class => error 
                          驗證正確時，移除 class => error-->
                        <input id="idWalletSetPassword" type="password" class="input-round" language_replace="placeholder" placeholder="設定錢包密碼">
                        <!--
                        <div class="notice error">
                            <i class="icon icon2020-information"></i><span class="language_replace">驗證錯誤提示</span>
                        </div>
                        -->
                    </div>
                </div>
                <div class="popUpRow walletAddress">
                    <div class="rm_list_input input-notice">
                        <!-- 輸入驗證錯誤時，在 input 加入class => error 
                          驗證正確時，移除 class => error-->
                        <input id="idWalletSetPassword2" type="password" class="input-round" language_replace="placeholder" placeholder="確認錢包密碼">
                        <!--
                        <div class="notice error">
                            <i class="icon icon2020-information"></i><span class="language_replace">驗證錯誤提示</span>
                        </div>
                        -->
                    </div>
                </div>

                <div class="form-control transaction_process">
                    <!--  -->
                    <button class="btn btn_full_main btn_confirm" onclick="btnConfirmWalletPassword()">
                        <span class="language_replace">確認設定</span>
                    </button>
                    <button class="btn btn_outline_main btn_cancel" onclick="btnCloseWalletPassword()">
                        <span class="language_replace">取消</span>
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- 打幣確認 視窗 => 要跳出視窗時，加入 class="settingPopUp_show"-->
    <div id="idConfirmBitCoinTx" class="settingPopUpNew settingPopUp_transferOutConfirm settingPopUp_hidden ">
        <div class="maskDiv"></div>
        <div class="settingPopUpWrapper">
            <div class="PopUp_Header">
                <div class="PopUp_Header_ICON"><i class="icon icon-ico-coin"></i></div>
                <div class="PopUp_Header_Title"><span class="language_replace">打幣確認資訊</span></div>
                <div class="PopUp_Header_BtnClose" onclick="closeConfirmBitCoinTx()"><i class="icon icon-ico-cancel"></i></div>
            </div>
            <div class="PopUp_Content">
                <div class="popUpRow underline walletAddress">
                    <div class="title"><span class="language_replace">轉出錢包地址</span></div>
                    <div class="data" id="TxOutFromAddress">[FromAddress]</div>
                </div>
                <div class="popUpRow underline walletAddress">
                    <div class="title"><span class="language_replace">轉入錢包地址</span></div>
                    <div class="data" id="TxOutToAddress">[ToAddress]</div>
                </div>
                <div class="popUpRow underline walletAddress">
                    <div class="title"><span class="language_replace">幣別</span></div>
                    <div class="data" id="TxOutCurrencyType">[CT]</div>
                </div>
                <div class="popUpRow underline walletAddress">
                    <div class="title"><span class="language_replace">交易數量</span></div>
                    <div class="data" id="TxOutAmount">[Amount]</div>
                </div>
                <div class="form-control transaction_process">
                    <!-- 按鈕開啟 打幣結果 視窗 -->
                    <button class="btn btn_full_main btn_confirm" onclick="setETHBitCoinTx()">
                        <span class="language_replace">確認打幣</span>
                    </button>
                    <button class="btn btn_outline_main btn_cancel" onclick="closeConfirmBitCoinTx()">
                        <span class="language_replace">取消</span>
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- 打幣結果 視窗 => 要跳出視窗時，加入 class="settingPopUp_show"-->
    <div id="" class="settingPopUpNew settingPopUp_currencyTransactionResult settingPopUp_hidden ">
        <div class="maskDiv"></div>
        <div class="settingPopUpWrapper">
            <div class="PopUp_Header">
                <div class="PopUp_Header_ICON"><i class="icon icon-ico-coin"></i></div>
                <div class="PopUp_Header_Title"><span class="language_replace">打幣結果</span></div>
                <div class="PopUp_Header_BtnClose"><i class="icon icon-ico-cancel"></i></div>
            </div>

            <div class="PopUp_Content">
                <!-- 加入 class=>success 為 執行成功  加入 class=>fail 為執行失敗 -->
                <div class="transactionResult success">
                    <div class="transaction_resultShow">
                        <div class="transaction_resultDisplay">
                            <div class="icon-symbol"></div>
                        </div>
                        <p class="transaction_resultTitle"><span class="language_replace">打幣成功</span></p>
                    </div>
                    <div class="transaction_currency">
                        <span class="transaction_amountTitle"><span class="language_replace">打幣金額</span></span>
                        <span class="transaction_currencyType"><span class="language_replace">USTD</span></span>
                        <div class="transaction_currencyAmount">2.2300</div>
                    </div>
                </div>
                <div class="transaction_session">
                    <span class="transaction_date">2020/11/19 </span><span class="transaction_time">18:10:30</span>
                </div>
                <div class="transaction_currencyBalance">
                    <div class="currencyBalance">
                        <span class="currencyType">USTD</span>
                        <span class="balance language_replace">目前餘額</span>
                    </div>
                    <div class="currencyAmount">15.2364</div>
                </div>
                <div class="transaction_recordLink">
                    <!--<p><span class="language_replace">至<span class="wallet_record language_replace">錢包紀錄</span>查看交易紀錄</span></p>-->
                    <p><span class="wallet_record language_replace">至錢包紀錄查看交易紀錄</span></p>
                </div>
                <div class="form-control transaction_process">
                    <button class="btn btn_full_main">
                        <span class="language_replace">首頁</span>
                    </button>
                    <button class="btn btn_full_main">
                        <span class="language_replace">返回</span>
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- 兌幣結果 視窗 => 要跳出視窗時，加入 class="settingPopUp_show"-->
    <div id="" class="settingPopUpNew settingPopUp_currencyTransactionResult settingPopUp_hidden ">
        <div class="maskDiv"></div>
        <div class="settingPopUpWrapper">
            <div class="PopUp_Header">
                <div class="PopUp_Header_ICON"><i class="icon icon-ico-coin"></i></div>
                <div class="PopUp_Header_Title"><span class="language_replace">兌幣結果</span></div>
                <div class="PopUp_Header_BtnClose"><i class="icon icon-ico-cancel"></i></div>
            </div>
            <div class="PopUp_Content">
                <!-- 加入 class=>success 為 執行成功  加入 class=>fail 為執行失敗 -->
                <div class="transactionResult fail">
                    <div class="transaction_resultShow">
                        <div class="transaction_resultDisplay">
                            <div class="icon-symbol"></div>
                        </div>
                        <p class="transaction_resultTitle"><span class="language_replace">兌幣失敗</span></p>
                    </div>
                    <div class="transaction_currency">
                        <span class="transaction_amountTitle"><span class="language_replace">兌幣金額</span></span>
                        <span class="transaction_currencyType"><span class="language_replace">USTD</span></span>
                        <div class="transaction_currencyAmount">2.2300</div>
                    </div>
                </div>
                <div class="transaction_session">
                    <span class="transaction_date">2020/11/19 </span><span class="transaction_time">18:10:30</span>
                </div>
                <div class="transaction_currencyBalance">
                    <div class="currencyBalance">
                        <span class="currencyType">USTD</span>
                        <span class="balance language_replace">目前餘額</span>
                    </div>
                    <div class="currencyAmount">15.2364</div>
                </div>
                <div class="transaction_currencyBalance">
                    <div class="currencyBalance">
                        <span class="currencyType">CNY</span>
                        <span class="balance language_replace">目前餘額</span>
                    </div>
                    <div class="currencyAmount">15.2364</div>
                </div>
                <div class="transaction_recordLink">
                    <!--<p><span class="language_replace">至<span class="wallet_record language_replace">錢包紀錄</span>查看交易紀錄</span></p>-->
                    <p><span class="wallet_record language_replace">至錢包紀錄查看交易紀錄</span></p>
                </div>
                <div class="form-control transaction_process">
                    <button class="btn btn_full_main">
                        <span class="language_replace">首頁</span>
                    </button>
                    <button class="btn btn_full_main">
                        <span class="language_replace"></span>返回</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
