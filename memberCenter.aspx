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
<script>
    var c = new common();
    var ud;
    var GWebInfo;
    var p;
    var mlp;
    var lang;

    function onBtnDownloadQRCode() {
        window.location.href = "/QRCodeImage.aspx?T=1&PCode=" + GWebInfo.UserInfo.PersonCode;
    }

    function onBtnQRCodeHide() {
        var idQRCode = document.getElementById("idQRCode");

        idQRCode.style.display = "none";
    }

    function onBtnQRCodeShow() {
        var idQRCode = document.getElementById("idQRCode");
        var idImgQRCode = document.getElementById("idImgQRCode");

        idImgQRCode.src = "/QRCodeImage.aspx?PCode=" + GWebInfo.UserInfo.PersonCode;

        idImgQRCode.style.display = "block";
        idQRCode.style.display = "block";
    }

    function setAccountNickName() {
        var idAccountNickName = document.getElementById("idAccountNickName");

        if (idAccountNickName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入您的暱稱"));
        } else {
            var nickname = idAccountNickName.value;

            p.UpdateUserAccountInfo(GWebInfo.SID, Math.uuid(), [{ Name: "NickName", Value: nickname }], function (success, o) {
                if (success) {
                    if (o.ResultCode == 0) {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("暱稱修改完成"), function () {
                            c.setElementText("idNickName", null, nickname);
                            nicknameSend();
                            getUserDetail();                        });
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
    }

    function onBtnWalletPassword() {
        var idWalletPasswordSrc = document.getElementById("idWalletPasswordSrc");

        if (GWebInfo.UserInfo.IsWalletPasswordSet == true) {
            idWalletPasswordSrc.style.display = "block";
        } else {
            idWalletPasswordSrc.style.display = "none";
        }

        wpwEdit();
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

        if ((idWalletPasswordSrc.value == "") && (GWebInfo.UserInfo.IsWalletPasswordSet == true)) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包原始密碼"));
        } else if (idWalletPasswordNew1.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入錢包新密碼"));
        } else if (idWalletPasswordNew1.value.length < 8) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼須超過 8 位數"));
        } else if (idWalletPasswordNew1.value.length > 16) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼不行超過 16 位數"));
        } else if (idWalletPasswordNew1.value != idWalletPasswordNew2.value) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("驗證密碼失敗"));
        } else {
            p.SetAccountPassword(GWebInfo.SID, Math.uuid(), 1, idWalletPasswordSrc.value, idWalletPasswordNew1.value, function (success, o) {
                if (success) {
                    if (o.ResultCode == 0) {
                        idWalletPasswordSrc.value = "";
                        idWalletPasswordNew1.value = "";
                        idWalletPasswordNew2.value = "";
                        GWebInfo.UserInfo.IsWalletPasswordSet = true;

                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("錢包新密碼已設定完成"), function () {
                            wpwSend();
                            updateBaseInfo();
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
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入帳戶原始密碼"));
        } else if (idAccountPasswordNew1.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入帳戶新密碼"));
        } else if (idAccountPasswordNew1.value.length < 8) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼須超過 8 位數"));
        } else if (idAccountPasswordNew1.value.length > 16) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼不行超過 16 位數"));
        } else if (idAccountPasswordNew1.value != idAccountPasswordNew2.value) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("驗證密碼失敗"));
        } else {
            p.SetAccountPassword(GWebInfo.SID, Math.uuid(), 0, idAccountPasswordSrc.value, idAccountPasswordNew1.value, function (success, o) {
                if (success) {
                    if (o.ResultCode == 0) {
                        idAccountPasswordSrc.value = "";
                        idAccountPasswordNew1.value = "";
                        idAccountPasswordNew2.value = "";

                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("帳戶新密碼已設定完成"), function () {
                            acpwSend();
                            updateBaseInfo();
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
            });
        }
    }

    function updateBaseInfo() {
        var pi = window.parent.API_GetCurrencyType(GWebInfo.CurrencyType);

        c.setElementText("idLoginAccount", null, GWebInfo.UserInfo.LoginAccount);
        c.setElementText("idUserLevel", null, GWebInfo.UserInfo.UserLevel);
        c.setElementText("idPersonCode", null, GWebInfo.UserInfo.PersonCode);
        c.setElementText("idCurrencyType", null, GWebInfo.CurrencyType);

        //for (var i = 0; i < GWebInfo.UserInfo.PointInfo.length; i++) {
        //    var pointInfo = GWebInfo.UserInfo.PointInfo[i];
        //    if(GWebInfo.CurrencyType == pointInfo.CurrencyType){
        //        c.setElementText("idSumValidBetValue", null, new BigNumber(pointInfo.SumValidBetValue).toFormat());
        //    }
        //}       
        //***********
        if (GWebInfo.UserInfo.IsWalletPasswordSet == true) {
            c.setElementText("idWalletPasswordSetText", null, "***********");
            c.setElementText("idWalletPasswordButtonText", null, mlp.getLanguageKey("修改"));
        } else {
            c.setElementText("idWalletPasswordSetText", null, mlp.getLanguageKey("尚未設定"));
            c.setElementText("idWalletPasswordButtonText", null, mlp.getLanguageKey("設定"));
        }

        if (ud != null) {
            if (ud.PSList != null) {
                for (var i = 0; i < ud.PSList.length; i++) {
                    var ps = ud.PSList[i];

                    switch (ps.Name.toUpperCase()) {
                        case "NickName".toUpperCase():
                            var idAccountNickName = document.getElementById("idAccountNickName");

                            c.setElementText("idNickName", null, ps.Value);
                            idAccountNickName.value = ps.Value;

                            break;
                        case "ContactPhonePrefix".toUpperCase():
                            //idContactPhonePrefix
                            c.setElementText("idContactPhonePrefix", null, ps.Value);

                            break;
                        case "ContactPhoneNumber".toUpperCase():
                            c.setElementText("idContactPhoneNumber", null, ps.Value);

                            break;
                        case "RealName".toUpperCase():
                            c.setElementText("idRealName", null, ps.Value);

                            break;
                        case "Birthday".toUpperCase():
                            c.setElementText("idBirthday", null, ps.Value);
                            
                            break;
                    }
                }
            }
        }

        if (pi != null) {
            c.setElementText("idThresholdValue", null, pi.ThresholdValue + pi.SumValidBetValue);
            c.setElementText("idSumValidBetValue", null, new BigNumber(pi.SumValidBetValue).toFormat());
        }
    }

    function getUserDetail() {
        p.GetUserAccountDetail(GWebInfo.SID, Math.uuid(), function (success, o) {
            if (success) {
                if (o.ResultCode == 0) {
                    ud = o;
                    updateBaseInfo();
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

    function init() {
        lang = window.top.API_GetLang();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            GWebInfo = window.parent.API_GetWebInfo();
            p = window.parent.API_GetGWebHubAPI();

            if (p != null) {
                getUserDetail();
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
                mlp.loadLanguage(lang, function () {
                    getWebTag();
                });
            } else if (eventName == "SetCurrencyType") {
                updateBaseInfo();
            }
        }
    }

    window.onload = init;
</script>
<script type="text/javascript">
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
</script>
<body>
    <div class="pageWrapper">
        <div class="pageMain">
            <div class="pageHeader">
                <div class="backBtn" style="display:none;"><span class="fa fa-arrow-left"></span></div>
                <div class="pageTitle"><span class="language_replace">會員中心</span></div>
            </div>
            <div>
                <div class="switchTagDiv">
                    <div class="switchTagBtn active"><span class="language_replace">會員資料</span></div>
                    <div class="switchTagBtn"><span class="language_replace">代理資料</span></div>
                </div>
                <!-- 會員資料 -->
                <div class="pageMainCon">
                    <div class="rowHalf">
                        <div class="rowTitle"><span class="language_replace">個人資料</span></div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">會員等級</span></div>
                            <div class="rowRight"><span id="idUserLevel">[UserLevel]</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">可用幣別</span></div>
                            <div class="rowRight"><span id="idCurrencyType">[CurrencyType]</span></div>
                        </div>
                         <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">真實姓名</span></div>
                            <div class="rowRight"><span id="idRealName">[RealName]</span></div>
                        </div>
                        <div class="rowElm" id="nicknameDiv">
                            <div class="rowLeft"><span class="language_replace">暱稱</span></div>
                            <div class="rowRight"><span id="idNickName">[NickName]</span></div>
                            <div class="rowBtnFull" onclick="nicknameEdit()"><span class="language_replace">修改</span></div>
                        </div>
                        <!-- -->
                        <div class="rowEdit" id="nicknameForm" style="display:none;">
                            <div class="rowLeft"><span class="language_replace">修改暱稱</span></div>
                            <div class="rowRight">
                                <input type="text" maxlength="16" id="idAccountNickName" language_replace="placeholder" placeholder="輸入新暱稱" autocomplete="off">
                                <div class="rowBtnCon">
                                    <div class="sBtnOutline" onclick="nicknameSend()"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull"onclick="setAccountNickName()" ><span class="language_replace">確定修改</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">電話</span></div>
                            <div class="rowRight"><span id="idContactPhonePrefix">[PhonePrefix]</span><span id="idContactPhoneNumber">[PhoneNumber]</span></div>
                        </div>
                        <!-- -->
                        <!--div class="rowElm">
                            <div class="rowLeft"><span>生日</span></div>
                            <div class="rowRight"><span id="idBirthday">[Birthday]</span></div>
                        <div-->
                        <!-- -->
                        <div class="rowElm">
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
                        <div class="rowElm" id="acpwDiv">
                            <div class="rowLeft"><span class="language_replace">帳號密碼</span></div>
                            <div class="rowRight"><span>***********</span></div>
                            <div class="rowBtnFull" onclick="acpwEdit()"><span class="language_replace">修改</span></div>
                        </div>
                        <!-- -->
                        <div class="rowEdit" id="acpwForm" style="display:none;">
                            <div class="rowLeft"><span class="language_replace">修改帳號密碼</span></div>
                            <div class="rowRight">
                                <input type="text" id="idAccountPasswordSrc" language_replace="placeholder" placeholder="輸入舊密碼">
                                <input type="text" id="idAccountPasswordNew1" language_replace="placeholder" placeholder="設定新密碼">
                                <input type="text" id="idAccountPasswordNew2" language_replace="placeholder" placeholder="確認新密碼">
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
                            <div class="rowBtnFull" onclick="onBtnWalletPassword()"><span id="idWalletPasswordButtonText" class="language_replace">修改</span></div>
                        </div>
                        <!-- -->
                        <div class="rowEdit" id="wpwForm" style="display:none;">
                            <div class="rowLeft"><span>修改錢包密碼</span></div>
                            <div class="rowRight">
                                <input type="text" id="idWalletPasswordSrc" language_replace="placeholder" placeholder="輸入舊密碼">
                                <input type="text" id="idWalletPasswordNew1" language_replace="placeholder" placeholder="設定新密碼">
                                <input type="text" id="idWalletPasswordNew2" language_replace="placeholder" placeholder="確認新密碼">
                                <div class="rowBtnCon">
                                    <div class="sBtnOutline" onclick="cancelWalletPassword()"><span class="language_replace">取消</span></div>
                                    <div class="sBtnFull" onclick="setWalletPassword()"><span class="language_replace">確定修改</span></div>
                                </div>
                            </div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">帳號狀態</span></div>
                            <div class="rowRight"><span class="language_replace">不可提款</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">提款所需投注</span></div>
                            <div class="rowRight"><span id="idThresholdValue">[ThresholdValue]</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm">
                            <div class="rowLeft"><span class="language_replace">目前有效投注</span></div>
                            <div class="rowRight"><span id="idSumValidBetValue"></span></div>
                        </div>
                    </div>
                    <!-- 我的二維碼 -->
                    <div id="idQRCode" class="pageConMask" style="display:none;">
                        <div class="pageConMaskMain">
                            <div class="pageConMasktit"><span class="language_replace">我的二維碼</span></div>
                            <div class="myQRCODE"><img id="idImgQRCode" style="display: none"></div>
                            <div class="sBtnOutline" onclick="onBtnQRCodeHide()"><span class="language_replace">關閉</span></div>
                            <div class="sBtnFull" onclick="onBtnDownloadQRCode()"><span class="language_replace">下載圖片</span></div>
                        </div>
                    </div>
                </div>
                <!-- 會員資料 -->
            </div>
        </div>
    </div>

</body>
</html>