<%@ Page Language="C#" %>
<% 
    string CurrencyType = Request["CurrencyType"];
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0">
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
<script type="text/javascript" src="/Scripts/PaymentAPI.js"></script>

<script type="text/javascript">
    var ui = new uiControl();
    var c = new common();
    var p;
    var mlp;
    var Lang;
    var CT;
    var webInfo;
    var currencyType = "<%=CurrencyType%>";
    var oPaymentBankCard;
    var oPaymentDeposit;
    var paymentSerial;

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

    function onBtnCancelDeposit() {
        showMessage(mlp.getLanguageKey("存款取消"), mlp.getLanguageKey("確認要取消存款?"), function () {
            ui.showMask(null, "Wait...");
            bankCardDepostitCancel(oPaymentDeposit.PaymentSerial);
        });
    }

    function onBtnSendPaymentBankCard() {
        var txtAmount = document.getElementById("txtAmount");
        var txtDescription = document.getElementById("txtDescription");
        var retValue = true;

        if (isNaN(txtAmount.value) == true) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入存款金額"));
            retValue = false;
        }
        else if (parseFloat(oPaymentBankCard.DepositAmountMin) > parseFloat(txtAmount.value)) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("存款金額小於最低存款金額"));
            retValue = false;
        }
        else if (parseFloat(oPaymentBankCard.DepositAmountMax) < parseFloat(txtAmount.value)) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("存款金額大於最高存款金額"));
            retValue = false;
        }

        if (retValue == true) {
            if (txtAmount.value != "") {
                showMessage(mlp.getLanguageKey("存款確認"), mlp.getLanguageKey("確認要存款") + " " + decimalToString(txtAmount.value) + " " + mlp.getLanguageKey("元") + "?", function () {
                    ui.showMask(null, "Wait...");
                    p.BankCardDepostit(CT,Math.uuid(), currencyType, 0, txtAmount.value, txtDescription.value, function (success, o) {
                        ui.hideMask();
                        if (success) {
                            if (o.ResultState == 0) {
                                oPaymentDeposit = o;

                                if (oPaymentDeposit.HasReceipt == false)
                                    showStep2(o);
                                else {
                                    showStep3(o);
                                }
                                    
                            } else {
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("目前無法提供這個幣別的轉帳") + " - " + currencyType + ":" + mlp.getLanguageKey(o.Message));
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
            } else {
                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入預計存款金額"));
            }

        }
    }

    function preViewFile(el) {
        var imgPreView = document.getElementById("imgPreView");
        var imgPreView2 = document.getElementById("imgPreView2");

        if (el.files && el.files[0]) {
            for (i = 0; i < el.files.length; i++) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    imgPreView.src = e.target.result;
                    imgPreView2.src = e.target.result;
                    document.getElementById("divPreView").style.display = "";
                    document.getElementById("divUploadFile").style.display = "none"
                }

                
                reader.readAsDataURL(el.files[i]);
            }
        }
    }

    function onBtnCancelFile() {

        document.getElementById("divPreView").style.display = "none";
        document.getElementById("divUploadFile").style.display = ""
        //document.getElementById("imgPreView").src = "";
    }


    function onBtnReceiptFile() {
        var idReceiptFile = document.getElementById("idReceiptFile");

        if (idReceiptFile != null) {
            if (idReceiptFile.files != null) {
                if (idReceiptFile.files.length > 0) {
                    var userFile = idReceiptFile.files[0];

                    uploadReceiptFile(userFile);
                }
            }
        }
    }

    function uploadReceiptFile(f) {
        var chunkSize = 20000;
        var readIndex = 0;
        var uploadId;
        var sendExceptionCount = 0;

        function readForChunk(chunkIndex, cb) {
            var position = (chunkIndex * chunkSize);
            var fr = new FileReader();

            fr.onload = function () {
                var contentB64 = fr.result;
                var tmpIndex;

                tmpIndex = contentB64.indexOf(",");
                if (tmpIndex != -1) {
                    contentB64 = contentB64.substr(tmpIndex + 1);
                }

                if (cb != null)
                    cb(true, contentB64);
            };

            if (position >= f.size) {
                if (cb != null)
                    cb(false, null);
            } else {
                var endPos = (position + chunkSize);
                var slice;
                var chunkCount;
                var persent;
                var idProgressBar = document.getElementById("idProgressBar");

                if (endPos >= f.size)
                    endPos = (f.size);

                if ((f.size % chunkSize) != 0)
                    chunkCount = (f.size / chunkSize) + 1;
                else
                    chunkCount = (f.size / chunkSize);

                persent = parseInt((chunkIndex / chunkCount) * 100);
                idProgressBar.style.width = persent + "%";

                slice = f.slice(position, endPos);
                fr.readAsDataURL(slice);
            }
        }

        function readMediaNext(finCb) {
            readForChunk(readIndex, function (success, contentB64) {
                if (success) {
                    p.UploadReceiptFIle(CT,Math.uuid(), uploadId, readIndex, contentB64, function (success2, ret) {
                        var sendSuccess = false;

                        if (success2) {
                            if (ret.ResultState == 0) {
                                sendSuccess = true;
                                sendExceptionCount = 0;
                                readIndex++;
                                readMediaNext(finCb);
                            }
                        }

                        if (sendSuccess == false) {
                            if (sendExceptionCount < 10) {
                                sendExceptionCount++;

                                setTimeout(function () {
                                    readMediaNext(finCb);
                                }, 500);
                            } else {
                            }
                        }
                    });
                } else {
                    // end read
                    if (finCb)
                        finCb(true);
                }
            });
        }

        if (f != null) {
            var filename = f.name;
            var extName = "";
            var tmpIndex;

            tmpIndex = filename.lastIndexOf(".");
            if (tmpIndex != -1)
                extName = filename.substr(tmpIndex + 1);

            // upload image
            p.CreateReceiptFIleUpload(CT,Math.uuid(), oPaymentDeposit.PaymentSerial, extName, function (success, UI) {
                if (success) {
                    if (UI.ResultState == 0) {
                        chunkSize = UI.ChunkSize;
                        uploadId = UI.UploadId;
                        document.getElementById("idProgressBarParent").style.display = "";

                        readMediaNext(function (finished) {
                            // finished
                            if (finished) {
                                p.CompleteReceiptFile(CT,Math.uuid(), uploadId, function () {
                                    var idProgressBar = document.getElementById("idProgressBar");

                                    idProgressBar.style.width = "0px";
                                    document.getElementById("idProgressBarParent").style.display = "none";

                                    showMessageOK(mlp.getLanguageKey("完成"), mlp.getLanguageKey("上傳完成"), function () {
                                        checkBankCardDepostit(null);
                                    });
                                });
                            } else {
                                // upload exception
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                            }
                        });
                    } else {
                        // upload exception
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                    }
                } else {
                    // upload exception
                    if (o == "Timeout")
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                    else
                        if ((o != null) && (o != ""))
                            alert(o);
                }
            });
        }
    }

    function checkBankCardDepostit(cb) {
        ui.showMask(null, "Wait...");
        p.CheckBankCardDepostit(CT,Math.uuid(), function (success, o) {
            ui.hideMask();
            if (success) {
                if (o.ResultState == 0) {
                    // 有尚未完成的存款
                    oPaymentDeposit = o;

                    if (oPaymentDeposit.HasReceipt == false)
                        showStep2(o);
                    else {
                        showStep3(o);
                    }
                       
                } else {
                    if (cb)
                        cb();
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

    function getPaymentBankCard() {
        ui.showMask(null, "Wait...");
        p.GetCompanyPaymentBankCard(CT,Math.uuid(), currencyType, 0, function (success, o) {
            ui.hideMask();
            if (success) {
                if (o.ResultState == 0) {
                    oPaymentBankCard = o;
                    showStep1();
                } else {
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("目前無法提供這個幣別的轉帳") + " - " + currencyType);
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

    function bankCardDepostitCancel(PaymentSerial) {
        p.BankCardDepostitCancel(CT,Math.uuid(), PaymentSerial, function (success, o) {
            ui.hideMask();
            if (success) {
                if (o.ResultState == 0) {
                    showMessageOK(mlp.getLanguageKey("取消完成"), mlp.getLanguageKey(o.Message), function () {
                        document.getElementById("idUploadFileBtnN").style.display = "none";
                        window.close();
                    });
                  
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
    }

    function showStep1() {
        var idStep = document.getElementById("idStep");
        var idDepositDescription = document.getElementById("idDepositDescription");
        var idDepositStep1 = document.getElementById("idDepositStep1");
        var idDepositStep2 = document.getElementById("idDepositStep2");
        var idDepositStep3 = document.getElementById("idDepositStep3");

        idStep.className = "pageStepDiv AtStep1";
        idDepositStep1.style.display = "block";
        idDepositStep2.style.display = "none";
        idDepositStep3.style.display = "none";

        c.setElementText("idCurrencyType", null, currencyType);

        if (oPaymentBankCard != null) {
            c.setElementText("idAmountMin", null, decimalToString(oPaymentBankCard.DepositAmountMin));
            c.setElementText("idAmountMax", null, decimalToString(oPaymentBankCard.DepositAmountMax));

            if ((oPaymentBankCard.DepositDescription != null) && (oPaymentBankCard.DepositDescription != "")) {
                idDepositDescription.style.display = "block";
                c.setElementText("idDepositDescriptionText", null, oPaymentBankCard.DepositDescription);
            } else {
                idDepositDescription.style.display = "none";
            }
        } else {
            c.setElementText("idAmountMin", null, mlp.getLanguageKey("不支援此幣別"));
            c.setElementText("idAmountMax", null, mlp.getLanguageKey("不支援此幣別"));
        }
    }

    function showStep2(o) {
        var idStep = document.getElementById("idStep");
        var idDepositStep1 = document.getElementById("idDepositStep1");
        var idDepositStep2 = document.getElementById("idDepositStep2");
        var idDepositStep3 = document.getElementById("idDepositStep3");

        idStep.className = "pageStepDiv AtStep2";
        idDepositStep1.style.display = "none";
        idDepositStep2.style.display = "block";
        idDepositStep3.style.display = "none";

        c.setElementText("idStep2PaymentSerial", null, o.PaymentSerial);
        c.setElementText("idStep2AccountName", null, o.BankCardInfo.AccountName);
        c.setElementText("idStep2BankNumber", null, o.BankCardInfo.BankNumber);
        c.setElementText("idStep2BranchName", null, o.BankCardInfo.BranchName);
        c.setElementText("idStep2BankName", null, o.BankCardInfo.BankName);
        c.setElementText("idStep2Time", null, o.DepositTime);
        c.setElementText("idStep2Date", null, o.DepositDate);
        c.setElementText("idStep2Amount", null, decimalToString(o.Amount));
        c.setElementText("idStep2CurrencyType", null, o.CurrencyType);
    }

    function showStep3(o) {
        var idStep = document.getElementById("idStep");
        var idDepositStep1 = document.getElementById("idDepositStep1");
        var idDepositStep2 = document.getElementById("idDepositStep2");
        var idDepositStep3 = document.getElementById("idDepositStep3");
        var nowTime = new Date();
        var imgUpdate = document.getElementById("imgUpdate");

        onBtnCancelFileStep3();

        idStep.className = "pageStepDiv AtStep3";
        idDepositStep1.style.display = "none";
        idDepositStep2.style.display = "none";
        idDepositStep3.style.display = "block";

        c.setElementText("idStep3PaymentSerial", null, o.PaymentSerial);
        c.setElementText("idStep3AccountName", null, o.BankCardInfo.AccountName);
        c.setElementText("idStep3BankNumber", null, o.BankCardInfo.BankNumber);
        c.setElementText("idStep3BranchName", null, o.BankCardInfo.BranchName);
        c.setElementText("idStep3BankName", null, o.BankCardInfo.BankName);
        c.setElementText("idStep3Time", null, o.DepositTime);
        c.setElementText("idStep3Date", null, o.DepositDate);
        c.setElementText("idStep3Amount", null, decimalToString(o.Amount));
        c.setElementText("idStep3CurrencyType", null, o.CurrencyType);

        paymentSerial = o.PaymentSerial;

        imgUpdate.src = webInfo.EWinUrl+"/GetReceiptImage.aspx?PaymentSerial=" + paymentSerial + "&" + nowTime.getTime();
    }

    function btnReUpload() {
        var divUploadCompleteMain = document.getElementById("divUploadCompleteMain");
        var divUploadComplete = document.getElementById("divUploadComplete");
        var divUploadFile = document.getElementById("divUploadFile");
        var divPreView = document.getElementById("divPreView");
        var btnCancelUpload = document.getElementById("btnCancelUpload");

        divUploadCompleteMain.appendChild(divUploadFile);
        divUploadCompleteMain.appendChild(divPreView);

        divUploadComplete.style.display = "none";
        divUploadFile.style.display = "";
        divPreView.style.display = "none";
        btnCancelUpload.style.display = "";
    }

    function onBtnCancelFileStep3() {
        var divUploadComplete = document.getElementById("divUploadComplete");
        var divUploadFile = document.getElementById("divUploadFile");
        var divPreView = document.getElementById("divPreView");

        divUploadComplete.style.display = "";
        divUploadFile.style.display = "none";
        divPreView.style.display = "none";

    }

    function btnShowUpload() {
        var nowTime = new Date();

        showMessageOK(mlp.getLanguageKey("檢視檔案"), "<img src='/GetReceiptImage.aspx?PaymentSerial=" + paymentSerial + "&" + nowTime.getTime() + "'>");
    }

    function btnCloseWindow() {
        window.close();
    }

    function decimalToString(v) {
        return (new BigNumber(v).toFormat());
    }

    function keepSID(cb) {
        api.KeepSID(Math.uuid(), function (success, o) {
            if (success) {
                if (o.ResultState != 0) {
                    if (o.Message == "InvalidSID") {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("登入過期, 請重新登入"));
                    } else {
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                    }
                }

                if (cb)
                    cb();
            } else {
                if (o == "Timeout")
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        alert(o);
            }
        });
    }

    function init() {

        p = window.parent.API_GetPaymentAPI();
        webInfo = window.parent.API_GetWebInfo();
        Lang = webInfo.Lang;

        CT = webInfo.CT;
        // 設定預設錢包
        mlp = new multiLanguage();
        mlp.loadLanguage(Lang, function () {
            checkBankCardDepostit(function () {
                getPaymentBankCard();
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
                <div class="pageTitle"><span class="language_replace">銀行卡存款</span></div>
                <div class="pageCloseBtn" onclick="btnCloseWindow();" style="display:none"><span>close</span></div>
            </div>
            <div>
                <!-- 步驟 當前步驟請額外加上"AtStep1"，class中的數字代表進行到第幾個步驟，如在第三步則加上"AtStep3" -->
                <div id="idStep" class="pageStepDiv AtStep1">
                    <div class="pageStepItem">
                        <div class="pageStepItemNo">1</div>
                        <div class="pageStepItemText"><span class="language_replace">存款申請</span></div>
                    </div>
                    <div class="pageStepItem">
                        <div class="pageStepItemNo">2</div>
                        <div class="pageStepItemText"><span class="language_replace">確認匯款</span></div>
                    </div>
                    <div class="pageStepItem">
                        <div class="pageStepItemNo">3</div>
                        <div class="pageStepItemText"><span class="language_replace">等待審核中</span></div>
                    </div>
                    <!--div class="pageStepItem">
                        <div class="pageStepItemNo">4</div>
                        <div class="pageStepItemText"><span class="language_replace">完成</span></div>
                    </div-->
                </div>
                <!-- 存款STEP1 -->
                <div class="pageMainCon" id="idDepositStep1" style="display: none">
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">存款資料</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">存款幣別</span></div>
                            <div class="rowRight">
                                <!--div class="rowDropBtn" id="idCurrencyType"></div-->
                                <span id="idCurrencyType"></span>
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最低存款金額 (元)</span></div>
                            <div class="rowRight" id="idAmountMin"></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最高存款金額 (元)</span></div>
                            <div class="rowRight" id="idAmountMax"></div>
                        </div>
                    </div>
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">我要存款</span></div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">存款金額</span></div>
                            <div class="rowRight">
                                <input type="text" language_replace="placeholder" placeholder="請輸入存款金額" id="txtAmount">
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">備註</span></div>
                            <div class="rowRight">
                                <input type="text" language_replace="placeholder" id="txtDescription">
                                <div class="rowBtnCon">
                                    <div class="sBtnOutline" onclick="window.close()"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull" onclick="onBtnSendPaymentBankCard()"><span class="language_replace">送出</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="pageFooter" id="idDepositDescription">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList" id="idDepositDescriptionText">
                        </div>

                    </div>
                </div>

				<!-- STEP2 -->
				<div class="pageMainCon" id="idDepositStep2" style="display:none;">
					<div class="popStatusRowTop">
						<div class="popStatusTag"><span class="language_replace">目前狀態</span></div>
						<!-- --->
						<div class="popStatusTets"><span class="language_replace">申請完成，請匯款至指定帳戶</span></div>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">存款金額</span>
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
							<span class="language_replace">指定帳戶資料</span>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">銀行名稱</span>
						</div>
						<div class="rowRight">
							<span id="idStep2BankName"></span>
							<span id="idStep2BranchName"></span>
						</div>
						<div class="copyBtn">
							<span>COPY</span>
						</div>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">帳號</span>
						</div>
						<div class="rowRight">
							<span id="idStep2BankNumber"></span>
						</div>
						<div class="copyBtn">
							<span>COPY</span>
						</div>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">收款人</span>
						</div>
						<div class="rowRight">
							<span id="idStep2AccountName"></span>
						</div>
						<div class="copyBtn">
							<span>COPY</span>
						</div>
					</div>
					<!-- -->
					<div class="popStatusTit">
						<span class="language_replace">匯款完成後，請上傳匯款單</span>
					</div>
					<div class="UploadFileDiv">
						<!-- STEP2-1 未上傳 -->
						<div id="divUploadFile" class="UploadFileCon">
							<label class="UploadFileBtn">
                                <input type="file" onchange="preViewFile(this)" accept="image/*"  id="idReceiptFile" name="idReceiptFile">
								<div class="UploadFileImg"><img src="images/icon_upload_W.svg"></div>
								<div class="UploadFileText"><span class="language_replace">選擇檔案</span></div>
							</label>	
                           <div id="btnCancelUpload" class="UploadFileBGBtnDiv" style="display:none">
								    <div class="UploadFileBGBtnCon">
									    <div class="UploadFileBGBtnN" onclick="onBtnCancelFileStep3()"><span class="language_replace">取消</span></div>
								    </div>	
							</div>
						</div>
						<!-- STEP2-2 已選取檔案  -->
						<div id="divPreView" class="UploadFileCon" style="display: none;">
							<div class="UploadFileBGIMG"><img id="imgPreView" src=""></div>
							<%--<div class="UploadFileBGTit"><span class="language_replace">已選擇檔案</span></div>--%>
							<%--<div class="UploadFileBGName"><span class="language_replace">fliename.png</span></div>--%>
                            <div class="UploadImgMask"></div>
                            <div class="UploadImgCube">
                                <div class="UploadImgDiv">
                                <img id="imgPreView2" src=""></div>
                                <div class="closeBtn_img"></div>
                            </div>
							<div class="UploadFileBGBtnDiv">
								<div class="UploadFileBGBtnCon">
                                    <!-- 進度條 控制idProgressBar的width = n % -->
                                    <div id="idProgressBarParent" class="UploadProgressBar" style="display: none;"><div id="idProgressBar" style="width:0%;"></div></div>
									<div class="UploadFileBGBtnN" onclick="onBtnCancelFile()"><span class="language_replace">取消</span></div>
									<div class="UploadFileBGBtnY" onclick="onBtnReceiptFile()"><span class="language_replace">確認上傳</span></div>
								</div>	
							</div>
						</div>
					</div>
					<div class="UploadFileBtnDiv">
						<div class="UploadFileBGBtnCon">
							<div class="UploadFileBtnN" id="idUploadFileBtnN" onclick="onBtnCancelDeposit()"><span class="language_replace">取消存款</span></div>
							<%--<div class="UploadFileBtnY"><span class="language_replace">我已匯款</span></div>--%>
						</div>	
					</div>
				</div>
				<!-- STEP3 -->
				<div class="pageMainCon" id="idDepositStep3" style="display: none">
					<div class="popStatusRowTop">
						<div class="popStatusTag"><span class="language_replace">目前狀態</span></div>
						<!-- --->
						<div class="popStatusTets"><span class="language_replace">匯款完成，等待審核中</span></div>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">存款金額</span>
						</div>
						<div class="rowRight">
							<span id="idStep3CurrencyType"></span>
							<span id="idStep3Amount"></span>
						</div>	
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">申請時間</span>
						</div>
						<div class="rowRight">
							<span id="idStep3Date"></span>
							<span id="idStep3Time"></span>
						</div>	
					</div>
                    <div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">交易單號</span>
						</div>
						<div class="rowRight">
							<span id="idStep3PaymentSerial"></span>
						</div>	
					</div>
					<div class="popStatusTit">
							<span class="language_replace">指定帳戶資料</span>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">銀行名稱</span>
						</div>
						<div class="rowRight">
							<span id="idStep3BankName"></span>
							<span id="idStep3BranchName"></span>
						</div>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">帳號</span>
						</div>
						<div class="rowRight">
							<span id="idStep3BankNumber"></span>
						</div>
					</div>
					<div class="rowEdit">
						<div class="rowLeft">
							<span class="language_replace">收款人</span>
						</div>
						<div class="rowRight">
							<span id="idStep3AccountName"></span>
						</div>
					</div>
					<!-- -->
					<div class="popStatusTit">
						<span class="language_replace">匯款完成，已上傳匯款單</span>
					</div>
					<div id="divUploadCompleteMain" class="UploadFileDiv">
						<!-- 03 已上傳檔案  -->
						<div id="divUploadComplete" class="UploadFileCon">
                            <div class="UploadImgCubeOK">
                                <div class="UploadImgDiv">
                                <img id="imgUpdate" src=""></div>
                                <div class="checkBtn_img"></div>
                            </div>
							<%--<div class="UploadFileBGIMG"><img src="images/testImage.jpg"></div>--%>
							<!--div class="UploadFileBGTit"><span class="language_replace">已上傳完成</span></div-->
							<%--<div class="UploadFileBGName"><span class="language_replace">fliename.png</span></div>--%>
							<div class="UploadFileBGBtnDiv">
								<div class="UploadFileBGBtnCon">
                                    <div class="UploadFileBGBtnN" onclick="btnReUpload()"><span class="language_replace">重新上傳</span></div>
									<div class="UploadFileBGBtnY" onclick="btnShowUpload()"><span class="language_replace">檢視檔案</span></div>
								</div>	
							</div>
						</div>
                        
					</div>
					<div class="UploadFileBtnDiv">
						<div class="UploadFileBGBtnCon">
							<!--div class="UploadFileBtnN"><span class="language_replace">取消存款</span></div>
							<div class="UploadFileBtnY"><span class="language_replace">我已匯款</span></div-->
						</div>	
					</div>
				</div>
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
</body>
</html>
