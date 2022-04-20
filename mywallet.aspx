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
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<script>
    var c = new common();
    var GWebInfo;
    var p;
    var mlp;
    var lang;
    var bl;
    var selBankCard = null;


    function onBtnPaymentDeposit() {

        if (bl && bl.BankCardList && bl.BankCardList.length > 0) {
            var idDepositAmount = document.getElementById("idDepositAmount");

            //http://gweb.dev4.mts.idv.tw/api/payment/GpayDeposit.aspx?Token=&SID=&Amount=200&CurrencyType=CNY
            if (idDepositAmount.value != "") {
                window.open(GWebInfo.GWebUrl + "/API/Payment/GpayDeposit.aspx?Token=" + GWebInfo.Token + "&SID=" + GWebInfo.SID + "&Amount=" + idDepositAmount.value + "&CurrencyType=CNY");
            } else {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入存款金額"));
            }
        } else {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("銀行卡尚未綁定，請先綁定銀行卡"), function () {
                showTagPage(2);
            });
        }
    }

    function onBtnAddBankCard() {
        var idBankName = document.getElementById("idBankName");
        var idBankProvince = document.getElementById("idBankProvince");
        var idBankCity = document.getElementById("idBankCity");
        var idBankBranchName = document.getElementById("idBankBranchName");
        var idAccountName = document.getElementById("idAccountName");
        var idBankNumber = document.getElementById("idBankNumber");

        if (idBankName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行名稱"));
        } else if (idBankProvince.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行所在省份"));
        } else if (idBankCity.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行所在城市"));
        } else if (idBankBranchName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行支行名稱"));
        } else if (idAccountName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行開戶人姓名"));
        } else if (idBankNumber.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入銀行帳號"));
        } else {
            var bankDetail = {
                BankProvince: idBankProvince.value,
                BankCity: idBankCity.value
            };

            p.CheckBankCard(GWebInfo.SID, Math.uuid(), idBankName.value, idBankNumber.value, function (success, o) {
                if (success) {
                    if (o.ResultCode == 0) {
                        p.CheckRealName(GWebInfo.SID, Math.uuid(), idAccountName.value, function (success, o) {
                            if (success) {
                                if (o.ResultCode == 0) {
                                    p.AddUserBankCard(GWebInfo.SID, Math.uuid(), GWebInfo.CurrencyType, 0, "", idBankName.value, idBankBranchName.value, idBankNumber.value, idAccountName.value, "", JSON.stringify(bankDetail), function (success, o) {
                                        if (success) {
                                            if (o.ResultCode == 0) {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("新增銀行卡成功"), function () {
                                                    idBankName.value = "";
                                                    idBankProvince.value = "";
                                                    idBankCity.value = "";
                                                    idBankBranchName.value = "";
                                                    idAccountName.value = "";
                                                    idBankNumber.value = "";

                                                    getBankCardList(function (o) {
                                                        bl = o;
                                                        updateBaseInfo();
                                                    });
                                                });
                                            } else {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                                            }
                                        } else {
                                            if (o == "Timeout") {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                                            } else {
                                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                                            }
                                        }
                                    })
                                } else {
                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(mlp.getLanguageKey("銀行帳戶與會員資料不符，請確認您的銀行帳戶與會員資料相符")));
                                }
                            }
                        });
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(mlp.getLanguageKey("此銀行卡已被註冊使用，請選擇其他銀行卡")));
                    }
                }
            });           
        }
    }

    function showTagPage(idx) {
        var pages = document.getElementsByClassName("TagPage");
        var headers = document.getElementsByClassName("TagHeader");

        if (pages != null) {
            for (var i = 0; i < pages.length; i++) {
                var p = pages[i];

                if (i == idx) {
                    p.style.display = "block";
                } else {
                    p.style.display = "none";
                }
            }
        }

        if (headers != null) {
            for (var i = 0; i < headers.length; i++) {
                var h = headers[i];

                if (i == idx) {
                    c.addClassName(h, "active");
                } else {
                    c.removeClassName(h, "active");
                }
            }
        }

        if (idx == 1) {
            // 判斷是否有設定錢包密碼
            if (GWebInfo.UserInfo.IsWalletPasswordSet == false) {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("尚未設定錢包密碼"), mlp.getLanguageKey("請先至會員中心設置錢包密碼後才能申請取款"));
            }
        }
    }

    function onBtnPaymentDrawal() {
        if (bl && bl.BankCardList && bl.BankCardList.length > 0) {

            //var idDrawAmount = document.getElementById("idDrawAmount");
            var idDrawWalletPassword = document.getElementById("idDrawWalletPassword");

            //if (idDrawAmount.value == "") {
            //    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入取款金額"));
            //} else
            if (idDrawWalletPassword.value == "") {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包密碼"));
            } else {
                p.ValidateWalletPassword(GWebInfo.SID, Math.uuid(), idDrawWalletPassword.value, function (success, o) {
                    if (success) {
                        if (o.ResultCode == 0) {
                            if (o.ValidateState == true) {
                                // 錢包密碼正確, 要求取款

                                if (selBankCard != null) {
                                    var BankProvinceCity;
                                    if (selBankCard.Description != "") {
                                        BankProvinceCity = JSON.parse(selBankCard.Description);
                                    }
                                    var BanckCardDetail = {
                                        "AccountName": selBankCard.AccountName,
                                        "BankName": selBankCard.BankName,
                                        "BranchName": selBankCard.BranchName,
                                        "BankNumber": selBankCard.BankNumber,
                                        "BankProvince": BankProvinceCity.BankProvince,
                                        "BankCity": BankProvinceCity.BankCity
                                    }
                                    var strBanckCardDetail = JSON.stringify(BanckCardDetail);

                                    window.top.API_ShowMessageOK(mlp.getLanguageKey("已確認"), mlp.getLanguageKey("錢包密碼無誤，將前往取款頁面"), function () {
                                        window.open(GWebInfo.GWebUrl + "/API/Payment/GpayWithdraw.aspx?Token=" + GWebInfo.Token + "&SID=" + GWebInfo.SID + "&BanckCardDetail=" + strBanckCardDetail);
                                    });


                                } else {
                                    window.top.API_ShowMessageOK(mlp.getLanguageKey("已確認"), mlp.getLanguageKey("錢包密碼無誤，將前往取款頁面"), function () {
                                        window.open(GWebInfo.GWebUrl + "/API/Payment/GpayWithdraw.aspx?Token=" + GWebInfo.Token + "&SID=" + GWebInfo.SID);
                                    });
                                }

                                //p.CreateCashOutRequire(GWebInfo.SID, Math.uuid(), idDrawAmount.value, selBankCard.BankCardGUID, function (success, o) {
                                //    if (success) {
                                //        if (o.ResultCode == 0) {
                                //            window.parent.API_ShowMessageOK(mlp.getLanguageKey("完成"), mlp.getLanguageKey("已提交取款申請, 請耐心等待審核"), function () {
                                //                idDrawAmount.value = "";
                                //                idDrawWalletPassword.value = "";
                                //            });
                                //        } else {
                                //            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                                //        }
                                //    } else {
                                //        if (o == "Timeout") {
                                //            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                                //        } else {
                                //            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                                //        }
                                //    }
                                //});
                            } else {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("錢包密碼錯誤"));
                            }
                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                        }
                    } else {
                        if (o == "Timeout") {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                        } else {
                            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                        }
                    }
                });
            }
        } else {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("銀行卡尚未綁定，請先綁定銀行卡"), function () {
                showTagPage(2);
            });
        }
    }

    function onBtnSelectBankCard() {
        var itemList = [];
        var defaultGUID = "";

        for (var i = 0; i < bl.BankCardList.length; i++) {
            var b = bl.BankCardList[i];
            var item = {
                name: "[" + b.BankName + "][" + b.BranchName + "]",
                desc: b.BankNumber,
                value: b.BankCardGUID
            };

            itemList[itemList.length] = item;
        }

        if (selBankCard != null) {
            defaultGUID = selBankCard.BankCardGUID;
        }

        window.parent.API_ShowDropdownWindow(mlp.getLanguageKey("選擇銀行卡"), itemList, defaultGUID, function (v) {
            selectDrawBankCard(v);
        });
    }

    function getBankCardList(cb) {
        p.GetUserBankCard(GWebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.ResultCode == 0) {
                    if (cb)
                        cb(o);
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (o == "Timeout") {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), o);
                }
            }
        });
    }

    function selectDrawBankCard(guid) {
        var bb = null;

        for (var i = 0; i < bl.BankCardList.length; i++) {
            var b = bl.BankCardList[i];

            if (b.BankCardGUID == guid) {
                bb = b;
                break;
            }
        }

        if (bb != null) {
            c.setElementText("idDrawBankName", null, bb.BankName);
            c.setElementText("idDrawBankBranchName", null, bb.BranchName);
            c.setElementText("idDrawBankNumber", null, bb.BankName);
        }

        selBankCard = bb;
    }

    function updateBankList() {
        var idBankCardList = document.getElementById("idBankCardList");
        idBankCardList.innerHTML = "";

        if (bl != null) {
            if (bl.BankCardList != null) {
                for (var i = 0; i < bl.BankCardList.length; i++) {
                    var b = bl.BankCardList[i];
                    var t;

                    t = c.getTemplate("templateBankCardItem");
                    c.setClassText(t, "rowLeft1T", null, b.BankName);
                    c.setClassText(t, "rowRight1T", null, b.BranchName);
                    c.setClassText(t, "rowLeft2T", null, b.AccountName);
                    c.setClassText(t, "rowRight2T", null, b.BankName);

                    idBankCardList.appendChild(t);
                }
            }
        }
    }

    function updateBaseInfo() {
        updateBankList();
    }


    function init() {
        lang = window.top.API_GetLang();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            GWebInfo = window.parent.API_GetWebInfo();
            p = window.parent.API_GetGWebHubAPI();

            if (p != null) {
                if (GWebInfo.UserInfo.IsWalletPasswordSet == false) {
                    var idPaymentWithdrawalButtons = document.getElementById("idPaymentWithdrawalButtons");
                    var idDrawWalletPassword = document.getElementById("idDrawWalletPassword");

                    // 尚未設置錢包密碼, 隱藏取款送出按鈕
                    idDrawWalletPassword.disabled = true;
                    idPaymentWithdrawalButtons.style.display = "none";
                }

                getBankCardList(function (o) {
                    bl = o;

                    if (bl && bl.BankCardList && bl.BankCardList.length > 0) {
                        selectDrawBankCard(bl.BankCardList[0].BankCardGUID);
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("銀行卡尚未綁定，請先綁定銀行卡"), function () {
                            showTagPage(2);
                        });
                    }


                    showTagPage(0);
                    updateBaseInfo();
                });
            } else {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.top.location.href = "index.aspx";
                });
            }
        });
    }

    function GWebEventNotify(eventName, isDisplay, o) {
        if (isDisplay) {
            if (eventName == "SetLanguage") {
                lang = o;
                mlp.loadLanguage(lang, function () { });
            }
        }
    }

    window.onload = init;
</script>
<body>
    <div class="pageWrapper">
        <div class="pageMain">
            <div class="pageHeader">
                <div class="backBtn" style="display: none;"><span class="fa fa-arrow-left"></span></div>
                <div class="pageTitle"><span class="language_replace">錢包中心</span></div>
            </div>
            <div>
                <div class="switchTagDiv">
                    <!-- 使用中頁籤加上"active"-->
                    <div onclick="showTagPage(0)" class="switchTagBtn TagHeader"><span class="language_replace">存款</span></div>
                    <div onclick="showTagPage(1)" class="switchTagBtn TagHeader"><span class="language_replace">取款</span></div>
                    <div onclick="showTagPage(2)" class="switchTagBtn TagHeader"><span class="language_replace">銀行卡</span></div>
                </div>
                <!-- 存款 -->
                <div class="pageMainCon TagPage">
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">存款資料</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">幣別</span></div>
                            <div class="rowRight"><span>CNY</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最低存款金額</span></div>
                            <div class="rowRight"><span>500</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最高存款金額</span></div>
                            <div class="rowRight"><span>10,000</span></div>
                        </div>
                    </div>
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">我要存款</span></div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">存款金額</span></div>
                            <div class="rowRight">
                                <input type="text" id="idDepositAmount" language_replace="placeholder" placeholder="請輸入存款金額">
                                <div class="rowBtnCon">
                                    <div class="sBtnOutline"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull" onclick="onBtnPaymentDeposit()"><span class="language_replace">送出</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                    </div>
                    <div class="pageFooter">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList">
                            <ol>
                                <li class="language_replace">敬愛的會員：虛擬帳號轉帳提供多家銀行帳號，"虛擬帳號轉帳"與"超商代碼支付"繳費成功後，即可到"帳戶訊息"查詢入帳資訊。</li>
                                <li class="language_replace">如您要"銀行轉帳"存款前，請您先聯繫您的代理商及客服人員告知存款，存款完成，請您正確填寫轉帳金額後"按下申請"。</li>
                                <li class="language_replace">晚上 12 點至凌晨 1 點之間為銀行固定維護時間，如於此期間進行轉帳，將於凌晨 1 點後入帳。</li>
                                <li class="language_replace">若使用ATM櫃員機，可選擇轉帳 / 轉出 ( 轉帳單筆上限3萬元 ) 。</li>
                                <li class="language_replace">本公司銀行帳號不定期變動，每次儲值前，請務必確認當前系統為您綁訂的專屬銀行帳號進行儲值，若您將款項儲值至非系統當前為您所綁定的專屬銀行帳號，本公司將不予承認該筆款項。</li>
                            </ol>
                        </div>

                    </div>
                </div>
                <!-- 取款 -->
                <div class="pageMainCon TagPage" style="display: none;">
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">取款資料</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">幣別</span></div>
                            <div class="rowRight"><span>CNY</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">可用金額</span></div>
                            <div class="rowRight"><span>10,000</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最低提款金額</span></div>
                            <div class="rowRight"><span>1,000</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">最高提款金額</span></div>
                            <div class="rowRight"><span>10,000</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">手續費</span></div>
                            <div class="rowRight"><span>1.2%</span></div>
                        </div>
                    </div>
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">我要提款</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">選擇收款方式</span></div>
                            <div class="rowRight">
                                <div class="rowDropBtn" onclick="onBtnSelectBankCard();">
                                    <div><span id="idDrawBankName">[銀行名稱]</span><span id="idDrawBankBranchName">[支行名稱]</span></div>
                                    <div><span id="idDrawBankNumber">[銀行卡號]</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">錢包密碼</span></div>
                            <div class="rowRight">
                                <%--<input type="text" id="idDrawAmount" placeholder="請輸入提款金額">--%>
                                <input type="text" id="idDrawWalletPassword" language_replace="placeholder" placeholder="錢包密碼">
                                <div id="idPaymentWithdrawalButtons" class="rowBtnCon">
                                    <div class="sBtnOutline"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull" onclick="onBtnPaymentDrawal();"><span class="language_replace">送出</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                    </div>
                    <div class="pageFooter">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList">
                            <ol>
                                <li class="language_replace">每次提款最少點數為1000點以上，請務必確認填寫之帳號，若提供的帳號錯誤，恕本公司無法負責。</li>
                                <li class="language_replace">每次提款最少點數為1000點以上，請務必確認填寫之帳號，若提供的帳號錯誤，恕本公司無法負責。</li>
                                <li class="language_replace">提款時需達到存款總金額的100%有效投注量才可提出申請。(PS:如利用本平臺進行任何洗錢詐騙行為，本公司保留權利審核會員帳戶或停權終止會員服務)</li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!-- 銀行卡 -->
                <div class="pageMainCon TagPage" style="display: none;">
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">我的銀行卡</span></div>
                        <div id="idBankCardList">
                        </div>
                        <!-- -->
                        <div id="idBankCardTemplate" style="display: none">
                            <div id="templateBankCardItem">
                                <div class="rowElm2L">
                                    <div class="rowLeft1T"><span>上海浦東發展銀行</span></div>
                                    <div class="rowRight1T"><span>香港尖沙嘴支行</span></div>
                                    <div class="rowLeft2T"><span>司徒浩南</span></div>
                                    <div class="rowRight2T"><span>8945562698412</span></div>
                                    <div class="rowBtnOutline"><span class="language_replace">可使用</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">新增銀行卡</span></div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">銀行名稱</span></div>
                            <div class="rowRight">
                                <input maxlength="25" type="text" id="idBankName" language_replace="placeholder" placeholder="請輸入銀行名稱">
                            </div>
                        </div>
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">所在省</span></div>
                            <div class="rowRight">
                                <input maxlength="25" type="text" id="idBankProvince" language_replace="placeholder" placeholder="請輸入銀行所在省">
                            </div>
                        </div>
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">所在城市/州/區</span></div>
                            <div class="rowRight">
                                <input maxlength="25" type="text" id="idBankCity" language_replace="placeholder" placeholder="請輸入銀行所在城市/州/區">
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">支行名稱</span></div>
                            <div class="rowRight">
                                <input maxlength="25" type="text" id="idBankBranchName" language_replace="placeholder" placeholder="請輸入支行名稱">
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">帳戶名稱</span></div>
                            <div class="rowRight">
                                <input maxlength="25" type="text" id="idAccountName" language_replace="placeholder" placeholder="請輸入帳戶名稱">
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowEdit">
                            <div class="rowLeft"><span class="language_replace">銀行帳號</span></div>
                            <div class="rowRight">
                                <input type="text" id="idBankNumber"  maxlength="25" language_replace="placeholder" placeholder="請輸入銀行帳號" oninput="value=value.replace(/[^\d]/g,'')">
                                <div class="rowBtnCon">
                                    <div class="sBtnOutline"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull" onclick="onBtnAddBankCard()"><span class="language_replace">送出</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                    </div>
                    <div class="pageFooter">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList">
                            <ol>
                                <li class="language_replace">每次提款最少點數為1000點以上，請務必確認填寫之帳號，若提供的帳號錯誤，恕本公司無法負責。</li>
                                <li class="language_replace">提款時需達到存款總金額的100%有效投注量才可提出申請。(PS:如利用本平臺進行任何洗錢詐騙行為，本公司保留權利審核會員帳戶或停權終止會員服務)</li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!---->
            </div>
        </div>
    </div>

</body>
</html>
