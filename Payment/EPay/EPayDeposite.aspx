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
<script src="../../Scripts/jquery.min.1.7.js"></script>
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
    var currencyType = "";
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
        var txtRealName = document.getElementById("txtRealName");
        var retValue = true;

        if (isNaN(txtAmount.value) == true) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入存款金額"));
            retValue = false;
        }

        if (txtRealName.value.trim() == "") {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入真實姓名"));
            retValue = false;
        }

        else if (parseFloat(oPaymentBankCard.MinDepositAmount) > parseFloat(txtAmount.value)) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("存款金額小於最低存款金額"));
            retValue = false;
        }
        else if (parseFloat(oPaymentBankCard.MaxDepositAmount) < parseFloat(txtAmount.value)) {
            showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("存款金額大於最高存款金額"));
            retValue = false;
        }

        if (retValue == true) {
            if (txtAmount.value != "") {
                showMessage(mlp.getLanguageKey("存款確認"), mlp.getLanguageKey("確認要存款") + " " + decimalToString(txtAmount.value) + " " + mlp.getLanguageKey("元") + "?", function () {
                    ui.showMask(null, "Wait...");
                    p.CreateEPayDeposit(webInfo.SID, Math.uuid(), txtAmount.value, txtRealName.value, function (success, o) {
                        ui.hideMask();
                        if (success) {
                            if (o.Result == 0) {
                                oPaymentDeposit = o;
                                showMessageOK(mlp.getLanguageKey(""), mlp.getLanguageKey("前往付款"), function () {
                                    window.open(o.Message);
                                });
                                showStep2(o);
                            } else {
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                            }
                        } else {
                            if (o == "Timeout")
                                showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                            else
                                if ((o != null) && (o != ""))
                                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o));
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
        p.GetEPaySetting(Math.uuid(), function (success, o) {
            ui.hideMask();
            if (success) {
                if (o.Result == 0) {
                    oPaymentBankCard = o;
                    showStep1(o);
                } else {
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o));
                }
            } else {
                if (o == "Timeout")
                    showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新操作"));
                else
                    if ((o != null) && (o != ""))
                        showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o));
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

    function showStep1(data) {
        var idStep = document.getElementById("idStep");
        var idDepositDescription = document.getElementById("idDepositDescription");
        var idDepositStep1 = document.getElementById("idDepositStep1");
        var idDepositStep2 = document.getElementById("idDepositStep2");


        idStep.className = "pageStepDiv AtStep1";
        idDepositStep1.style.display = "block";


        c.setElementText("idCurrencyType", null, currencyType);

        if (data != null) {
            c.setElementText("idAmountMin", null, decimalToString(data.MinDepositAmount));
            c.setElementText("idAmountMax", null, decimalToString(data.MaxDepositAmount));

            //if ((oPaymentBankCard.DepositDescription != null) && (oPaymentBankCard.DepositDescription != "")) {
            //    idDepositDescription.style.display = "block";
            //    c.setElementText("idDepositDescriptionText", null, oPaymentBankCard.DepositDescription);
            //} else {
            //    idDepositDescription.style.display = "none";
            //}
        } else {
            c.setElementText("idAmountMin", null, mlp.getLanguageKey("不支援此幣別"));
            c.setElementText("idAmountMax", null, mlp.getLanguageKey("不支援此幣別"));
        }
    }

    function showStep2(data) {
        
        var o = data.Data;
        var idStep = document.getElementById("idStep");
        var idDepositStep1 = document.getElementById("idDepositStep1");
        var idDepositStep2 = document.getElementById("idDepositStep2");

        idStep.className = "pageStepDiv AtStep2";
        idDepositStep1.style.display = "none";
        idDepositStep2.style.display = "block";

        setExpireSecond(o.ExpireSecond);
        c.setElementText("idStep2PaymentSerial", null, o.PaymentSerial);
        c.setElementText("idStep2Amount", null, decimalToString(o.Amount));
        c.setElementText("idStep2CurrencyType", null, o.ReceiveCurrencyType);


    }

    function supplement(nn) {
        return nn = nn < 10 ? '0' + nn : nn;
    }

    function setExpireSecond(ExpireSecond) {
        var nowDate = new Date();
        nowDate.setSeconds(nowDate.getSeconds() + 86400);
        format(nowDate, "-")
       
    }

    function format(Date, str) {
        var obj = {
            Y: Date.getFullYear(),
            M: Date.getMonth() + 1,
            D: Date.getDate(),
            H: Date.getHours(),
            Mi: Date.getMinutes(),
            S: Date.getSeconds()
        }
        // 拼接时间 hh:mm:ss
        var time = ' ' + supplement(obj.H) + ':' + supplement(obj.Mi) + ':' + supplement(obj.S);
        // yyyy-mm-dd
        c.setElementText("idStep2Time", null, time);
        c.setElementText("idStep2Date", null, obj.Y + '-' + supplement(obj.M) + '-' + supplement(obj.D));
    }


    function showStep3(o) {
        var idStep = document.getElementById("idStep");
        var idDepositStep1 = document.getElementById("idDepositStep1");
        var idDepositStep2 = document.getElementById("idDepositStep2");
     
        var nowTime = new Date();
        var imgUpdate = document.getElementById("imgUpdate");

        onBtnCancelFileStep3();

        idStep.className = "pageStepDiv AtStep3";
        idDepositStep1.style.display = "none";
        idDepositStep2.style.display = "none";
 

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


    function setAmount() {
      
        var amount = $("#txtAmount").val().replace(/[^\-?\d.]/g, '');
        $("#txtAmount").val(amount);

        $("#idThrehold").text(Math.ceil(amount * oPaymentBankCard.ThresholdRate));
    }

    function init() {

        p = window.parent.API_GetPaymentAPI();
        webInfo = window.parent.API_GetWebInfo();
        Lang = webInfo.Lang;
        currencyType = webInfo.MainCurrencyType;
        // 設定預設錢包
        mlp = new multiLanguage();
        mlp.loadLanguage(Lang, function () {
            getPaymentBankCard();
        });
  
    }

    window.onload = init;
</script>

<body>
    <div class="pageWrapper" style="">
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
                <%--    <div class="pageStepItem">
                        <div class="pageStepItemNo">3</div>
                        <div class="pageStepItemText"><span class="language_replace">等待審核中</span></div>
                    </div>--%>
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
                                <input type="text" language_replace="placeholder" onkeyup="setAmount()"  placeholder="請輸入存款金額" id="txtAmount">
                            </div>
                        </div>
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">增加的出金門檻 (元)</span></div>
                            <div class="rowRight" id="idThrehold"></div>
                        </div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">真實姓名</span></div>
                            <div class="rowRight">
                                <input type="text" language_replace="placeholder" id="txtRealName">
                                <div class="rowBtnCon">
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
							<span class="language_replace">交易限制時間</span>
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
