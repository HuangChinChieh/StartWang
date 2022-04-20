<%@ Page Language="C#" %>
<%
    string PCode = Request["PCode"];

%>
<!doctype html>
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
    var pCode = "<%=PCode%>";
    var GWebInfo;
    var p;
    var mlp;
    var lang;
    var lastPhoneCodeDate = new Date();

    function CheckAccountPhoneExist() {
        var idPhonePrefix = document.getElementById("idPhonePrefix");
        var idPhoneNumber = document.getElementById("idPhoneNumber");

        if ((idPhonePrefix.selectedIndex != -1) && (idPhoneNumber.value != "")) {
            p.CheckAccountPhoneExist(Math.uuid(), idPhonePrefix.options[idPhonePrefix.selectedIndex].value, idPhoneNumber.value, function (success, o) {
                var idLoginAccount = document.getElementById("idLoginAccount");

                if (success) {
                    if (o.ResultCode == 0) {
                        setDeniedText("idPhoneNumberDenied", mlp.getLanguageKey("電話號碼已存在, 請勿重複註冊"));
                    } else {
                        hideDeniedText("idPhoneNumberDenied");
                    }
                }
            });
        }
    }

    function CheckUserAccountExist() {
        var idLoginAccount = document.getElementById("idLoginAccount");

        hideDeniedText("idLoginAccountDeniedText");
        if (idLoginAccount.value != "") {
            p.CheckAccountExist(Math.uuid(), idLoginAccount.value, function (success, o) {
                if (success) {
                    if (o.ResultCode != 0) {
                        idLoginAccount.className = "checked";
                    } else {
                        idLoginAccount.className = "denied";
                        setDeniedText("idLoginAccountDeniedText", mlp.getLanguageKey("帳號已存在"));
                    }
                }
            });
        } else {
            setDeniedText("idLoginAccountDeniedText", mlp.getLanguageKey("請輸入登入帳號"));
        }
    }

    function CheckPasswordAvailable() {
        var idLoginPassword = document.getElementById("idLoginPassword");
        var idLoginPassword2 = document.getElementById("idLoginPassword2");

        hideDeniedText("idLoginPasswordDeniedText");
        hideDeniedText("idLoginPassword2DeniedText");

        if (idLoginPassword.value == "") {
            idLoginPassword.className = "denied";
            setDeniedText("idLoginPasswordDeniedText", mlp.getLanguageKey("請輸入登入密碼"));
        } else if (idLoginPassword.value.length < 6) {
            idLoginPassword.className = "denied";
            setDeniedText("idLoginPasswordDeniedText", mlp.getLanguageKey("密碼須超過 6 位數"));
        } else if (idLoginPassword.value.length > 16) {
            idLoginPassword.className = "denied";   
            setDeniedText("idLoginPasswordDeniedText", mlp.getLanguageKey("密碼不行超過 16 位數"));
        } else {
            idLoginPassword.className = "checked";

            if (idLoginPassword2.value != idLoginPassword.value) {
                idLoginPassword2.className = "denied";
                setDeniedText("idLoginPassword2DeniedText", mlp.getLanguageKey("驗證密碼失敗"));
            } else {
                idLoginPassword2.className = "checked";
            }
        }
    }



    function CheckValidateCode(cb) {
        var LoginGUID = document.forms[0].LoginGUID;
        var LoginValidateCode = document.forms[0].LoginValidateCode;


        c.callService("ValidateAuthCode.aspx?Token=" + GWebInfo.Token + "&LoginGUID=" + LoginGUID.value + "&ImageCode=" + LoginValidateCode.value, null, function (success, text) {
            if (success == true) {
                var o = c.getJSON(text);

                if (o.ResultCode == 0) {
                    if (cb)
                        cb(true);
                } else {
                    cb(false);
                }
            } else {
                cb(false);
            }
        });
    }

    function CreateRegisterValidateCode() {
        c.callService("CreateAuthCode.aspx?Token=" + GWebInfo.Token, null, function (success, text) {
            if (success == true) {
                var o = c.getJSON(text);

                if (o.ResultCode == 0) {
                    var idValidImage = document.getElementById("idRegValidImage");
                    var idFormRegister = document.getElementById("idFormRegister");

                    idFormRegister.LoginGUID.value = o.LoginGUID;

                    if (idValidImage != null) {
                        idValidImage.src = o.ImageContent;
                        idValidImage.style.display = "block";
                    }
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o.Message));
                }
            } else {
                if (text == "Timeout") {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("網路異常, 請再嘗試一次"));
                } else {
                    alert(text);
                }
            }
        });
    }

    function onBtnPhoneCode() {
        //CreateAccountPhoneValidateCode
        var idPhonePrefix = document.getElementById("idPhonePrefix");
        var idPhoneNumber = document.getElementById("idPhoneNumber");
        var allowValidate = false;

        if (idPhonePrefix.selectedIndex == -1) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請選擇電話國碼"));
        } else if (idPhoneNumber.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入電話號碼"));
        } else {
            allowValidate = true;
        }

        if (allowValidate) {
            var idBtnSendPhoneCode = document.getElementById("idBtnSendPhoneCode");
            var idBtnSendPhoneCodeText = document.getElementById("idBtnSendPhoneCodeText");

            idBtnSendPhoneCode.style.display = "none";
            idBtnSendPhoneCodeText.style.display = "block";

            p.CheckAccountPhoneExist(Math.uuid(), idPhonePrefix.options[idPhonePrefix.selectedIndex].value, idPhoneNumber.value, function (success, o) {
                var idLoginAccount = document.getElementById("idLoginAccount");

                if (success) {
                    if (o.ResultCode != 0) {
                        lastPhoneCodeDate = new Date();

                        p.CreatePhoneValidateCode(Math.uuid(), idPhonePrefix.options[idPhonePrefix.selectedIndex].value, idPhoneNumber.value, function (success, o) {
                            if (success) {
                                if (o.ResultCode == 0) {
                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("驗證碼已發送至您的手機"));
                                } else {
                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o.Message));
                                }
                            } else {
                                if (o == "Timeout") {
                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                                } else {
                                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o));
                                }
                            }
                        });
                    } else {
 
                        setDeniedText("idPhoneNumberDenied", mlp.getLanguageKey("電話號碼已存在, 請勿重複註冊"));

                        idBtnSendPhoneCode.style.display = "block";
                        idBtnSendPhoneCodeText.style.display = "none";
                    }
                } else {
                    if (o == "Timeout") {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    } else {
                        window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o));
                    }


                    idBtnSendPhoneCode.style.display = "block";
                    idBtnSendPhoneCodeText.style.display = "none";
                }
            });
        }
    }

    function onBtnUserRegisterStep1() {
        var idLoginAccount = document.getElementById("idLoginAccount");
        var idLoginPassword = document.getElementById("idLoginPassword");
        var idLoginPassword2 = document.getElementById("idLoginPassword2");
        var idPhonePrefix = document.getElementById("idPhonePrefix");
        var idPhoneNumber = document.getElementById("idPhoneNumber");
        var idRealName = document.getElementById("idRealName");
        var idNickName = document.getElementById("idNickName");

        if (idLoginAccount.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入帳號"));
        } else if (idLoginAccount.classList.contains("denied")) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("帳號已存在"));
        } else if (idLoginPassword.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入密碼"));
        } else if (idLoginPassword.value.length < 8) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼須超過 8 位數"));
        } else if (idLoginPassword.value.length > 16) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼不行超過 16 位數"));
        } else if (idPhonePrefix.selectedIndex == -1) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請選擇電話國碼"));
        } else if (idPhoneNumber.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入電話號碼"));
        } else if (idPhoneNumberDenied.style.display == "block") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("電話號碼已存在, 請勿重複註冊"));
        } else if (idRealName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入真實姓名"));
        } else if (idRealName.value.length >= 50) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("真實姓名長度勿超過50"));
        } else if (idNickName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入暱稱"));
        } else if (idNickName.value.length >= 16) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("暱稱長度勿超過16"));
        } else {
            if (idLoginPassword.value != idLoginPassword2.value) {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("驗證密碼失敗"));
            } else {
                CreateRegisterValidateCode();

                idUserRegStep1.style.display = "none";
                idUserRegStep2.style.display = "block";
            }
        }
    }

    function onBtnUserRegisterStep2() {
        var form = document.getElementById("idFormUserLogin");
        var idLoginAccount = document.getElementById("idLoginAccount");
        var idLoginPassword = document.getElementById("idLoginPassword");
        var idLoginPassword2 = document.getElementById("idLoginPassword2");
        var idPhonePrefix = document.getElementById("idPhonePrefix");
        var idPhoneNumber = document.getElementById("idPhoneNumber");
        var idRealName = document.getElementById("idRealName");
        var idPhoneCode = document.getElementById("idPhoneCode");
        var idNickName = document.getElementById("idNickName");
        var allowSubmit = true;

        if (idLoginAccount.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入帳號"));
            allowSubmit = false;
        } else if (idLoginPassword.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入登入密碼"));
            allowSubmit = false;
        } else if (idLoginPassword.value.length < 8) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼須超過 8 位數"));
            allowSubmit = false;
        } else if (idLoginPassword.value.length > 16) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("密碼不行超過 16 位數"));
            allowSubmit = false;
        } else if (idPhonePrefix.selectedIndex == -1) {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請選擇電話國碼"));
            allowSubmit = false;
        } else if (idPhoneNumber.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入電話號碼"));
            allowSubmit = false;
        } else if (idRealName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入真實姓名"));
            allowSubmit = false;
        } else if (idNickName.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入暱稱"));
            allowSubmit = false;
        } else if (idPhoneCode.value == "") {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("簡訊驗證碼為空"));
            allowSubmit = false;
        } else {
            if (idLoginPassword.value != idLoginPassword2.value) {
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("驗證密碼失敗"));
                allowSubmit = false;
            }
        }

        if (allowSubmit) {
            CheckValidateCode(function (success) {
                if (success == true) {
                    var LoginAccount = idLoginAccount.value;
                    var LoginPassword = idLoginPassword.value;
                    var PhoneCode = idPhoneCode.value;
                    var ParentPersonCode;

                    if ((pCode != null) && (pCode != "")) {
                        ParentPersonCode = pCode;
                    } else {
                        var idPCode = document.getElementById("idPCode");

                        ParentPersonCode = idPCode.value;
                    }

                    p.CreateAccount(Math.uuid(), LoginAccount, LoginPassword, ParentPersonCode, PhoneCode, [{ Name: "RealName", Value: idRealName.value, Name: "NickName", Value: idNickName.value }, { Name: "ContactPhonePrefix", Value: idPhonePrefix.options[idPhonePrefix.selectedIndex].value }, { Name: "ContactPhoneNumber", Value: idPhoneNumber.value }], function (success, o) {
                        if (success) {
                            if (o.ResultCode == 0) {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("註冊成功, 請按登入按鈕進行登入"), function () {
                                    window.parent.location.href = "index.aspx";
                                });
                            } else {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o.Message));
                            }
                        } else {
                            if (o == "Timeout") {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey("網路異常, 請重新嘗試"));
                            } else {
                                window.parent.API_ShowMessageOK(mlp.getLanguageKey("失敗"), mlp.getLanguageKey(o));
                            }
                        }
                    });
                } else {
                    window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("圖片驗證碼錯誤"));
                }
            });
        }
    }

    function QRCodeScanner() {
        var idQRImage = document.getElementById("idQRImage");
        var idQRCodeResult = document.getElementById("idQRCodeResult");
        var CurrencyType = document.getElementById("idInCurrencyType").dataset.value;

        window.top.API_OpenQRCodeScanner(idQRImage, function (result) {
            if ((result != null) && (result != "")) {
                var idPCode = document.getElementById("idPCode");

                idQRCodeResult.innerHTML = "";
                idPCode.value = result;
            } else {
                idQRCodeResult.innerHTML = mlp.getLanguageKey("找不到可用的 QRcode，請再試一次");
            }
        });
    }

    function updateBaseInfo() {
        var idPCode1 = document.getElementById("idPCode1");
        var idPCode2 = document.getElementById("idPCode2");

        if ((pCode != null) && (pCode != "")) {
            idPCode1.style.display = "block";
            idPCode2.style.display = "none";
        } else {
            idPCode1.style.display = "none";
            idPCode2.style.display = "block";
        }
    }

    function hideDeniedText(id) {
        var el = document.getElementById(id);

        if (el != null) {
            el.style.display = "none";
        }
    }

    function setDeniedText(id, text) {
        var el = document.getElementById(id);

        if (el != null) {
            var seted = false;

            for (var i = 0; i < el.children.length; i++) {
                var el2 = el.children[i];

                if (el2.tagName.toUpperCase() == "span".toUpperCase()) {
                    el2.innerHTML = text;
                    seted = true;
                    break;
                }
            }

            
            if (seted) {
                el.style.display = "block";
            } else {
                el.innerHTML = text;
                el.style.display = "block";
            }
        }
    }

    function init() {
        lang = window.top.API_GetLang();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            GWebInfo = window.parent.API_GetWebInfo();
            p = window.parent.API_GetGWebHubAPI();

            if (p != null)
                updateBaseInfo();
            else
                window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("網路錯誤"), function () {
                    window.top.location.href = "index.aspx";
                });

            setInterval(function () {
                var idBtnSendPhoneCode = document.getElementById("idBtnSendPhoneCode");
                var idBtnSendPhoneCodeText = document.getElementById("idBtnSendPhoneCodeText");
                var idBtnSendPhoneCodeTextSeconds = document.getElementById("idBtnSendPhoneCodeTextSeconds");

                if (idBtnSendPhoneCodeText.style.display == "block") {
                    var d = new Date();

                    if (((d - lastPhoneCodeDate) / 1000) > 60) {
                        idBtnSendPhoneCode.style.display = "block";
                        idBtnSendPhoneCodeText.style.display = "none";
                    } else {
                        idBtnSendPhoneCodeTextSeconds.innerText = 60 - parseInt((d - lastPhoneCodeDate) / 1000);
                    }
                }
            }, 500);
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
    <!-- HTML START -->
    <div class="wrapper">
        <!-- 註冊頁 -->
        <form method="post" id="idFormRegister">
            <input type="hidden" name="LoginGUID" value="" />
            <div id="idUserRegister" class="popupFrame">
                <div class="popupWrapper">
                    <div class="popupHeader">
                        <div class="popuptit"><span class="language_replace">會員註冊</span></div>
                    </div>
                    <div id="idUserRegStep1">
                        <!-- 第一步 -->
                        <!-- 掃碼或網址帶入推薦碼 -->
                        <div id="idPCode1" class="ReferralCode"><span class="language_replace">推薦碼</span>:<span><%=PCode %></span></div>
                        <!-- 自行輸入推薦碼 -->
                        <div id="idPCode2" class="ReferralCodeInput">
                            <input type="text" class="" language_replace="placeholder" placeholder="輸入推薦碼" name="ReferralCode" id="idPCode" value="<%=PCode %>">
                            <div class="scanBtn" onclick="QRCodeScanner()">
                                <i class="fa fa-qrcode"></i>
                                <input type="file" onchange="QRCodeScanner()" accept="image/*" id="idQRImage" name="idQRImage" style="display: none;">
                            </div>
                            <div id="idQRCodeResult" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span>Decode failure</span></div>
                        </div>
                        <div class="optionInput">
                            <div class="dropdownMenu">
                                <select id="idPhonePrefix" onchange="CheckAccountPhoneExist()">
                                    <option class="language_replace" value="+86">+86 中國</option>
                                    <option class="language_replace" value="+852">+852 香港</option>
                                    <option class="language_replace" value="+853">+853 澳門</option>
                                    <option class="language_replace" value="+886">+886 台灣</option>
                                    <option class="language_replace" value="+82">+82 南韓</option>
                                    <option class="language_replace" value="+81">+81 日本</option>
                                    <option class="language_replace" value="+84">+84 越南</option>
                                    <option class="language_replace" value="+60">+60 馬來西亞</option>
                                    <option class="language_replace" value="+61">+61 澳大利亞</option>
                                    <option class="language_replace" value="+62">+62 印尼</option>
                                    <option class="language_replace" value="+63">+63 菲律賓</option>
                                    <option class="language_replace" value="+65">+65 新加坡</option>
                                    <option class="language_replace" value="+66">+66 泰國</option>
                                    <option class="language_replace" value="+855">+855 柬埔寨</option>
                                    <option class="language_replace" value="+95">+95 緬甸</option>
                                </select>
                            </div>
                            <!-- 檢查正確請加上"checked" 檢查未通過請加上"denied" -->
                            <input id="idPhoneNumber" type="text" placeholder="輸入電話" name="UserPhoneNo" onblur="CheckAccountPhoneExist()">
                            <div id="idPhoneNumberDenied" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">電話已存在</span></div>
                        </div>
                        <div>
                            <div id="idBtnSendPhoneCode" class="popupBtn_red" onclick="onBtnPhoneCode()"><span class="language_replace">發送驗證碼</span></div>
                            <div id="idBtnSendPhoneCodeText" class="popupBtn_gray" style="display: none"><span class="language_replace">可於</span><span id="idBtnSendPhoneCodeTextSeconds">60</span><span class="language_replace">秒後再次發送</span></div>
                            <input id="idPhoneCode" type="password" class="" language_replace="placeholder" placeholder="輸入簡訊驗證碼" name="text">
                            <div class="popup_notice" style="display:inline;"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入發送至您指定手機門號之簡訊驗證碼</span></div>
                        </div>
                        <div>
                            <!-- 檢查正確請加上"checked" 檢查未通過請加上"denied" -->
                            <input id="idLoginAccount" type="text" language_replace="placeholder" placeholder="設定帳號" name="UserID" onblur="CheckUserAccountExist()">
                            <div id="idLoginAccountDeniedText" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">帳號重複</span></div>
                            <input id="idNickName" maxlength="16" type="text" language_replace="placeholder" placeholder="設定暱稱" name="NickName" autocomplete="off">
                            <input id="idRealName" maxlength="50" type="text" language_replace="placeholder" placeholder="設定真實姓名" name="RealName">
                            <div class="popup_notice" style="display:inline;"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入與銀行卡相同之真實姓名以確保您的權益</span></div>
                            <input id="idLoginPassword" type="password" class="" language_replace="placeholder" placeholder="輸入密碼" name="password" onblur="CheckPasswordAvailable()">
                            <div id="idLoginPasswordDeniedText" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入英文或數字8-16位數</span></div>
                            <input id="idLoginPassword2" type="password" class="" language_replace="placeholder" placeholder="確認密碼" name="password" onblur="CheckPasswordAvailable()">
                            <div id="idLoginPassword2DeniedText" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">輸入錯誤</span></div>
                            <div class="popupBtn_red" onclick="onBtnUserRegisterStep1()"><span class="language_replace">註冊</span></div>
                        </div>
                    </div>
                    <!-- 第二步 -->
                    <div id="idUserRegStep2" style="display: none">
                            <div class="ValidateDiv">
                                <div class="ValidateImg">
                                    <img id="idRegValidImage" alt="" />
                                    <div class="popupBtn_reF"><span onclick="CreateRegisterValidateCode()" class="fa fa-refresh fa-1x"></span></div>
                                </div>
                                <input type="text" name="LoginValidateCode" language_replace="placeholder" placeholder="輸入驗證碼" autocomplete="off">
                            </div>
                            <div class="popupBtn_red" onclick="onBtnUserRegisterStep2()"><span class="language_replace">確認</span></div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- HTML END -->
</body>
</html>
