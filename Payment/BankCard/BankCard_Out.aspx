<%@ Page Language="C#" %>

<%
    string CurrencyType = Request["CurrencyType"];
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="Description" content="eWin Gaming">
    <title>eWin Gaming</title>

    <!-- CSS -->
    <link href="../css/BankCardInOutStyle.css" rel="stylesheet" />
    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="ico/apple-touch-icon-57-precomposed.png">
</head>
<script type="text/javascript" src="/Scripts/EWinExceptionMessage.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>

<script type="text/javascript">
    var ui = new uiControl();
    var c = new common();
    var apiUrl = "PaymentBankCardAPI.asmx";
    var api;
    var mlp;
    var Lang;
    var CT;
    var currencyType = "<%=CurrencyType%>";
    var oBankCardList;
    var oPaymentBankCard;
    var oBankCardWithdrawal;
    var bankCardGUID;

    function showDropdownWindow(title, item, defaultValue, cbConfirm, cbCancel) {
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

    function showMessage(title, message, cbOK, cbCancel) {
        var divMessageBox = document.getElementById("divMessageBox");
        var divMessageBoxCloseButton = document.getElementById("divMessageBoxCloseButton");
        var divMessageBoxOKButton = document.getElementById("divMessageBoxOKButton");
        var divMessageBoxTitle = document.getElementById("divMessageBoxTitle");
        var divMessageBoxContent = document.getElementById("divMessageBoxContent");

        if (divMessageBox != null) {
            divMessageBox.classList.add("comdPopUp_show");

            if (divMessageBoxCloseButton != null) {
                divMessageBoxCloseButton.style.display = "inline";

                divMessageBoxCloseButton.onclick = function () {
                    divMessageBox.classList.remove("comdPopUp_show");

                    if (cbCancel != null) {
                        cbCancel();
                    }
                }
            }

            if (divMessageBoxOKButton != null) {
                divMessageBoxOKButton.style.display = "inline";

                divMessageBoxOKButton.onclick = function () {
                    divMessageBox.classList.remove("comdPopUp_show");

                    if (cbOK != null)
                        cbOK();
                }
            }

            divMessageBoxTitle.innerHTML = title;
            divMessageBoxContent.innerHTML = message;
        }
    }

    function showMessageOK(title, message, cbOK) {
        var divMessageBox = document.getElementById("divMessageBox");
        var divMessageBoxCloseButton = document.getElementById("divMessageBoxCloseButton");
        var divMessageBoxOKButton = document.getElementById("divMessageBoxOKButton");
        var divMessageBoxTitle = document.getElementById("divMessageBoxTitle");
        var divMessageBoxContent = document.getElementById("divMessageBoxContent");

        if (divMessageBox != null) {
            divMessageBox.classList.add("comdPopUp_show");

            if (divMessageBoxCloseButton != null) {
                divMessageBoxCloseButton.style.display = "none";
            }

            if (divMessageBoxOKButton != null) {
                divMessageBoxOKButton.style.display = "inline";

                divMessageBoxOKButton.onclick = function () {
                    divMessageBox.classList.remove("comdPopUp_show");

                    if (cbOK != null)
                        cbOK();
                }
            }

            divMessageBoxTitle.innerHTML = title;
            divMessageBoxContent.innerHTML = message;
        }
    }

    function getPaymentBankCard(cb) {
        ui.showMask(null, "Wait...");
        p.GetCompanyPaymentBankCard(CT,Math.uuid(), currencyType,0, function (success, o) {
            ui.hideMask();
            if (success) {
                if (o.ResultState == 0) {
                    oPaymentBankCard = o;

                    if (cb)
                        cb(true);
                } else {
                    if (o.Message == "NoRecord") {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("目前無法提供這個幣別的轉帳") + " - " + currencyType);
                    }
                    else {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));

                    }

                    if (cb)
                        cb(false);
                }
            } else {
                if (o == "Timeout")
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        alert(o);
            }
        });
    }

    function getBankCardList(cb) {
        ui.showMask(null, "Wait...");
        p.GetUserAccountBankCard(CT,Math.uuid(), currencyType, 0, function (success, o) {
            ui.hideMask();
            if (success) {
                if (o.ResultState == 0) {
                    oBankCardList = o;

                    if (cb) {
                        cb(true);
                    }
                      
                } else {
                    if (o.Message == "NoRecord") {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("尚未設定銀行卡, 請至會員中心新增收款銀行卡"));
                    }
                    else {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));

                    }

                    if (cb)
                        cb(false);
                }
            } else {
                if (o == "Timeout")
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        alert(o);
            }
        });
    }

    function updateSelectedBankCard() {
        if (oBankCardList != null) {
            if (oBankCardList.BankCardList != null) {
                for (var i = 0; i < oBankCardList.BankCardList.length; i++) {
                    var bc = oBankCardList.BankCardList[i];

                    if (bc.BankCardGUID == bankCardGUID) {
                        c.setElementText("idStep1BankName", null, bc.BankName + "-" + bc.BranchName);
                        c.setElementText("idStep1AccountName", null, bc.BankNumber + "-" + bc.AccountName);
                        break;
                    }
                }
            }
        }
    }

    function updateBaseInfo() {
        if ((bankCardGUID == null) || (bankCardGUID == "")) {
            if (oBankCardList != null) {
                if (oBankCardList.BankCardList != null) {
                    if (oBankCardList.BankCardList.length > 0) {
                        bankCardGUID = oBankCardList.BankCardList[0].BankCardGUID;
                    }
                }
            }
        }

        updateSelectedBankCard();
        showStep1();
    }

    function btnBankCardSelect() {
        var oList = [];

        if (oBankCardList != null) {
            if (oBankCardList.BankCardList != null) {
                if (oBankCardList.BankCardList.length > 0) {
                    if ((bankCardGUID == null) || (bankCardGUID == ""))
                        bankCardGUID = oBankCardList.BankCardList[0].BankCardGUID;

                    for (var i = 0; i < oBankCardList.BankCardList.length; i++) {
                        var bc = oBankCardList.BankCardList[i];

                        oList[oList.length] = { name: bc.BankName + bc.BankNumber, value: bc.BankCardGUID };
                    }
                }
            }
        }

        showDropdownWindow(mlp.getLanguageKey("請選擇銀行卡"), oList, bankCardGUID, function (v) {
            bankCardGUID = v;
            updateSelectedBankCard();
        });
    }

    function btnConfirmWithdrawal() {
        var txtAmount = document.getElementById("txtAmount");
        var txtWalletPassword = document.getElementById("txtWalletPassword");

        if (txtAmount.value == "") {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入提款金額"));
        } else if (txtWalletPassword.value == "") {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包密碼"));
        } else {
            if (Number(txtAmount.value) < oPaymentBankCard.WithdrawalAmountMin) {
                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("提款金額小於最低申請金額"));
            } else if (Number(txtAmount.value) > oPaymentBankCard.WithdrawalAmountMax) {
                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("提款金額大於最高申請金額"));
            } else {
                showMessage(mlp.getLanguageKey("確認提款"), mlp.getLanguageKey("請確認是否要申請提款") + " " + decimalToString(txtAmount.value) + " " + mlp.getLanguageKey("元") + "?", function () {
                    ui.showMask(null, "Wait...");
                    p.BankCardWithdrawal(CT,Math.uuid(), currencyType, 0, txtAmount.value, txtWalletPassword.value, [bankCardGUID], function (success, o) {
                        ui.hideMask();
                        if (success) {
                            if (o.ResultState == 0) {
                                oBankCardWithdrawal = o;
                                showStep2();
                            } else {
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                            }
                        } else {
                            if (o == "Timeout")
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                            else
                                if ((o != null) && (o != ""))
                                    alert(o);
                        }
                    });
                });
            }
        }

    }

    function showStep1() {
        var idStep = document.getElementById("idStep");
        var idWithdrawalDescription = document.getElementById("idWithdrawalDescription");
        var idStepPage1 = document.getElementById("idStepPage1");
        var idStepPage2 = document.getElementById("idStepPage2");
        var idWithdrawalHistory = document.getElementById("idWithdrawalHistory");

        idStep.className = "pageStepDiv AtStep1";

        idStepPage1.style.display = "block";
        idStepPage2.style.display = "none";

        c.setElementText("idStep1CurrencyType", null, currencyType);

        if (oBankCardList != null) {
            c.setElementText("idStep1BalanceValue", null, decimalToString(oBankCardList.WalletBalance));

            c.clearChildren(idWithdrawalHistory);

            if (oBankCardList.InProcessWithdrawalList != null) {
                for (var i = 0; i < oBankCardList.InProcessWithdrawalList.length; i++) {
                    var wh = oBankCardList.InProcessWithdrawalList[i];
                    var template = c.getTemplate("templateWithdrawalHistory");

                    c.setClassText(template, "paymentDate", null, wh.WithdrawalDate);
                    c.setClassText(template, "paymentTime", null, wh.WithdrawalTime);
                    c.setClassText(template, "paymentCurrencyType", null, wh.CurrencyType);
                    c.setClassText(template, "paymentAmount", null, decimalToString(wh.Amount));
                    c.setClassText(template, "paymentSerial", null, wh.PaymentSerial);

                    idWithdrawalHistory.appendChild(template);
                }
            }
        }

        if (oPaymentBankCard != null) {
            c.setElementText("idStep1AmountMin", null, decimalToString(oPaymentBankCard.WithdrawalAmountMin));
            c.setElementText("idStep1AmountMax", null, decimalToString(oPaymentBankCard.WithdrawalAmountMax));

            if ((oPaymentBankCard.WithdrawalDescription != null) && (oPaymentBankCard.WithdrawalDescription != "")) {
                idWithdrawalDescription.style.display = "block";
                c.setElementText("idWithdrawalDescriptionText", null, oPaymentBankCard.WithdrawalDescription);
            } else {
                idWithdrawalDescription.style.display = "none";
            }
        }
    }

    function showStep2() {
        var idStep = document.getElementById("idStep");
        var idStepPage1 = document.getElementById("idStepPage1");
        var idStepPage2 = document.getElementById("idStepPage2");

        idStep.className = "pageStepDiv AtStep2";

        idStepPage1.style.display = "none";
        idStepPage2.style.display = "block";

        if (oBankCardWithdrawal != null) {
            c.setElementText("idStep2PaymentSerial", null, oBankCardWithdrawal.PaymentSerial);
            c.setElementText("idStep2CurrencyType", null, oBankCardWithdrawal.CurrencyType);
            c.setElementText("idStep2Amount", null, oBankCardWithdrawal.Amount);
            c.setElementText("idStep2Date", null, oBankCardWithdrawal.WithdrawalDate);
            c.setElementText("idStep2Time", null, oBankCardWithdrawal.WithdrawalTime);

            if (oBankCardWithdrawal.BankCardInfo != null) {
                if (oBankCardWithdrawal.BankCardInfo.length > 0) {
                    c.setElementText("idStep2BankName", null, oBankCardWithdrawal.BankCardInfo[0].BankName);
                    c.setElementText("idStep2BranchName", null, oBankCardWithdrawal.BankCardInfo[0].BranchName);
                    c.setElementText("idStep2BankNumber", null, oBankCardWithdrawal.BankCardInfo[0].BankNumber);
                    c.setElementText("idStep2AccountName", null, oBankCardWithdrawal.BankCardInfo[0].AccountName);
                }
            }
        }
    }

    function decimalToString(v) {
        return (new BigNumber(v).toFormat());
    }

    function init() {
      
        p = window.parent.API_GetPaymentAPI();
        webInfo = window.parent.API_GetWebInfo();
        Lang = webInfo.Lang;
        CT = webInfo.CT;
        // 設定預設錢包
        mlp = new multiLanguage();
        mlp.loadLanguage(Lang, function () {
            getPaymentBankCard(function (success) {
                if (success) {
                    getBankCardList(function (success2) {
                        if (success2) {
                            if (oBankCardList.IsWalletPassword == false) {
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("尚未設定錢包密碼, 請先至會員中心設定錢包密碼"));
                            } else {
                                //var bankCardListCount = 0;

                                //if (oBankCardList != null) {
                                //    if (oBankCardList.BankCardList != null) {
                                //        for (var i = 0; i < oBankCardList.BankCardList.length; i++) {
                                //            if (oBankCardList.BankCardList[i].BankCardState == 0) {
                                //                bankCardListCount++;
                                //            }
                                //        }
                                //    }
                                //}

                                //if (bankCardListCount <= 0) {
                                //    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("尚未設定銀行卡, 請至會員中心新增收款銀行卡"), function () {
                                //        parent.API_MemberCenter();
                                //    });
                                //}

                                updateBaseInfo();
                            }
                        }
                    });
                }
            });

        });
    }

    window.onload = init;
</script>

<body>
    <div class="pageWrapper" style="margin-top:110px">
        <div class="pageMain">
            <div class="pageHeader">
                <div class="backBtn" style="display: none;"><span class="fa fa-arrow-left"></span></div>
                <div class="pageTitle"><span class="language_replace">銀行卡取款</span></div>
                <div class="pageCloseBtn" onclick="javascript:window.close();" style="display:none"><span>close</span></div>
            </div>
            <div>
                <!-- 步驟 當前步驟請額外加上"AtStep1"，class中的數字代表進行到第幾個步驟，如在第三步則加上"AtStep3" -->
                <div id="idStep" class="pageStepDiv AtStep1">
                    <div class="pageStepItem">
                        <div class="pageStepItemNo">1</div>
                        <div class="pageStepItemText language_replace" >出款申請</div>
                    </div>
                    <div class="pageStepItem">
                        <div class="pageStepItemNo">2</div>
                        <div class="pageStepItemText language_replace">申請完成審核中</div>
                    </div>
                </div>
                <!-- 取款 STEP01 -->
                <div id="idStepPage1" class="pageMainCon" style="display: none;">
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">取款資料</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">選擇幣別</span></div>
                            <div class="rowRight">
                                <!--div class="rowDropBtn"><span id="idStep1CurrencyType"></span></div-->
                                <span id="idStep1CurrencyType"></span>
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">可用金額</span></div>
                            <div class="rowRight"><span id="idStep1BalanceValue"></span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最低提款金額</span></div>
                            <div class="rowRight"><span id="idStep1AmountMin"></span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最高提款金額</span></div>
                            <div class="rowRight"><span id="idStep1AmountMax"></span></div>
                        </div>
                    </div>
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">我要取款</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">選擇收款卡</span></div>
                            <div class="rowRight">
                                <!-- 有銀行卡時 -->
                                <!-- 下方有銀行卡跳出視窗 -->
                                <div class="rowDropBtn2" onclick="btnBankCardSelect()">
                                    <div><span id="idStep1BankName"></span></div>
                                    <div><span id="idStep1AccountName"></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">提款金額</span></div>
                            <div class="rowRight">
                                <input type="text" language_replace="placeholder" placeholder="請輸入提款金額" id="txtAmount">
                                <input type="password" language_replace="placeholder" placeholder="錢包密碼" id="txtWalletPassword">
                                <div class="rowBtnCon">
                                    <div class="sBtnOutline" onclick="window.close();"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull" onclick="btnConfirmWithdrawal();"><span class="language_replace">送出</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                    </div>
					<!-- -->
					<div class="pageFooter">
                        <div id="templateWithdrawalHistory" style="display: none">
							<div class="rowElm2L">
								<div class="row2XL1A"><span class="paymentDate">2021/08/08</span><span class="paymentTime">下午04:33</span></div>
								<div class="row2XL1B"><span class="paymentCurrencyType">CNY</span><span class="paymentAmount">1,000,000</span></div>
								<div class="row2XL2A"><span class="language_replace">交易序號</span>:<span class="paymentSerial">XD20200430125813AC</span></div>
								<!--div class="rowStatusCheck"><span class="language_replace">處理中</span></div-->
							</div>
                        </div>
                        <div class="rowTitle"><span class="language_replace">審核的中提款</span></div>
                        <div class="rowList" id="idWithdrawalHistory">
							<!-- 狀態樣式 成功"rowStatusSucc" 失敗"rowStatusFail" 審核中"rowStatusCheck" 取消/不可用"rowStatusGray" -->
							<!-- -->
                            <!--
							<div class="rowElm2L">
								<div class="row2XL1A"><span class="paymentDate">2021/08/08</span><span class="paymentTime">下午04:33</span></div>
								<div class="row2XL1B"><span class="paymentCurrencyType">CNY</span><span class="paymentAmount">1,000,000</span></div>
								<div class="row2XL2A"><span class="language_replace">交易序號</span>:<span class="paymentSerial">XD20200430125813AC</span></div>
								<div class="rowStatusCheck"><span class="language_replace">處理中</span></div>
							</div>
                            -->
							<!-- -->
                            <!--
							<div class="rowElm2L">
								<div class="row2XL1A"><span class="paymentDate">2021/08/08</span><span class="paymentTime">下午04:33</span></div>
								<div class="row2XL1B"><span class="paymentCurrencyType">CNY</span><span class="paymentAmount">1,000,000</span></div>
								<div class="row2XL2A"><span class="language_replace">交易序號</span>:<span class="paymentSerial">XD20200430125813AC</span></div>
								<div class="rowStatusCheck"><span class="language_replace">處理中</span></div>
							</div>
                            -->


							
                        </div>
                    </div>
					
					<!-- -->
                    <div class="pageFooter" id="idWithdrawalDescription">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList" id="idWithdrawalDescriptionText">
                        </div>
                    </div>
                </div>
                <!---->
                <!-- 取款 STEP02 -->
                <div id="idStepPage2" class="pageMainCon" style="display: none;">
                    <div class="popStatusRowTop">
                        <div class="popStatusTag"><span class="language_replace">目前狀態</span></div>
                        <!-- --->
                        <div class="popStatusTets"><span class="language_replace">申請審核中</span></div>
                    </div>
                    <div class="rowEdit">
                        <div class="rowLeft">
                            <span class="language_replace">出款金額</span>
                        </div>
                        <div class="rowRight">
                            <span id="idStep2CurrencyType"></span>
                            <span id="idStep2Amount"></span>
                        </div>
                    </div>
                    <div class="rowEdit">
                        <div class="rowLeft">
                            <span class="language_replace">申請時間</span>
                        </div>
                        <div class="rowRight">
                            <span id="idStep2Date"></span>
                            <span id="idStep2Time"></span>
                        </div>
                    </div>
                    <div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">交易單號</span>
						</div>
						<div class="rowRight paymentSerialAdj">
							<span id="idStep2PaymentSerial"></span>
						</div>	
					</div>
                    <div class="popStatusTit">
                        <span class="language_replace">收款帳戶資料</span>
                    </div>
                    <div class="rowEdit">
                        <div class="rowLeft">
                            <span class="language_replace">銀行名稱</span>
                        </div>
                        <div class="rowRight">
                            <span id="idStep2BankName"></span>
                            <span id="idStep2BranchName"></span>
                        </div>
                    </div>
                    <div class="rowEdit">
                        <div class="rowLeft">
                            <span class="language_replace">帳號</span>
                        </div>
                        <div class="rowRight">
                            <span id="idStep2BankNumber"></span>
                        </div>
                    </div>
                    <div class="rowEdit">
                        <div class="rowLeft">
                            <span class="language_replace">收款人</span>
                        </div>
                        <div class="rowRight">
                            <span id="idStep2AccountName"></span>
                        </div>
                    </div>
							
                </div>
                <!-- -->
            </div>
        </div>
    </div>

    <!-- 跳出訊息(通用框架) -->
    <div class="comdPopUp_hidden" id="divMessageBox">
        <div class="maskDiv" style="display: none;"></div>
        <div class="comdCon">
            <div class="comdConBtnTop">
                <div id="divMessageBoxCloseButton" class="comdPupUp_btn_cencel"><i class="icon icon-ico-cancel"></i><span class='language_replace'>關閉</span></div>
                <div id="divMessageBoxOKButton" class="comdPupUp_btn_send"><i class="icon icon-ico-circle"></i><span class='language_replace'>確認</span></div>
            </div>
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
                <div class="TL_NavMenu_BtnClose2" id="idSelectBoxCancel"></div>
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
</body>
</html>
