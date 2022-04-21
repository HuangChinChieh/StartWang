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
    <meta name="Description" content="12one">
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
    var apiURL = "/RequireRegister.aspx";
    var pCode = "<%=PCode%>";
    var p;
    var mlp;
    var EWinWebInfo;
    var lang;
    var RegisterParentPersonCode = 0;
    function requireRegister() {
        var form = document.forms[0];
        var PCode = form.PCode;
        var ContactPhonePrefix = form.ContactPhonePrefix;
        var ContactPhoneNumber = form.ContactPhoneNumber;
        var EMail = form.EMail;
        var RealName = form.RealName;
        var postObj;
        var ps = [];

        postObj = {
            GUID: Math.uuid(),
            ParentPersonCode: PCode.value,
            PS: [{
                Name: "ContactPhonePrefix",
                Value: ContactPhonePrefix.value
            }, {
                Name: "ContactPhoneNumber",
                Value: ContactPhoneNumber.value
            }, {
                Name: "EMail",
                Value: EMail.value
            }, {
                Name: "RealName",
                Value: RealName.value
            }],
            UBC: null
        }
        p.RequireRegister2(postObj, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    alert(mlp.getLanguageKey("感謝您的註冊, 我們會盡快通知您帳號與密碼"));
                    location.reload();
                } else {
                    if (o.Message == "AlreadyRegister") {
                        alert(mlp.getLanguageKey("E-mail 或聯繫電話已經註冊!"));
                    } else {
                        alert(mlp.getLanguageKey(o.Message));
                    }
                }
            } else {
                alert(mlp.getLanguageKey("網路錯誤:") + o);
            }
        });
    }

    function formSubmitCheck() {
        var form = document.forms[0];
        var PCode = form.PCode;
        var ContactPhonePrefix = form.ContactPhonePrefix;
        var ContactPhoneNumber = form.ContactPhoneNumber;
        var EMail = form.EMail;
        var RealName = form.RealName;
        var retValue = false;

        if (ContactPhonePrefix.selectedIndex == -1)
            alert(mlp.getLanguageKey("錯誤, 請選擇聯繫電話國碼"));
        else if (ContactPhoneNumber.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入聯繫電話"));
        else if (EMail.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入 E-mail"));
        else if (RealName.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入真實姓名"));
        else if (RegisterParentPersonCode == 2 && PCode.value == "")
            alert(mlp.getLanguageKey("錯誤, 請輸入推薦碼"));
        else
            retValue = true;

        if (retValue) {
            requireRegister();
        }
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
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
        EWinWebInfo = window.parent.EWinWebInfo;
        p = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            document.forms[0].Lang.value = lang;
            if (!EWinWebInfo)
                RegisterParentPersonCode = 0;
            else
                RegisterParentPersonCode = EWinWebInfo.RegisterParentPersonCode;

            if (pCode != "") {
                let PCode1 = document.getElementById("idPCode1");
                let PCode2 = document.getElementById("idPCode2");
                PCode1.style.display = "block";
                PCode2.style.display = "none";
            }
        });
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
                            <input type="text" class="" language_replace="placeholder" placeholder="輸入推薦碼" name="PCode" id="idPCode" value="<%=PCode %>">
                         <%--   <div class="scanBtn" onclick="QRCodeScanner()">
                                <i class="fa fa-qrcode"></i>
                                <input type="file" onchange="QRCodeScanner()" accept="image/*" id="idQRImage" name="idQRImage" style="display: none;">
                            </div>--%>
                            <%--<div id="idQRCodeResult" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span>Decode failure</span></div>--%>
                        </div>
                        <div class="optionInput">
                            <div class="dropdownMenu">
                                <select id="idPhonePrefix" name="ContactPhonePrefix">
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
                            <input id="idContactPhoneNumber" type="text" placeholder="輸入電話" name="ContactPhoneNumber" >
                            <div id="idContactPhoneNumberDenied" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">電話已存在</span></div>
                        </div>
                        <div>
                         <%--   <div id="idBtnSendPhoneCode" class="popupBtn_red" onclick="onBtnPhoneCode()"><span class="language_replace">發送驗證碼</span></div>
                            <div id="idBtnSendPhoneCodeText" class="popupBtn_gray" style="display: none"><span class="language_replace">可於</span><span id="idBtnSendPhoneCodeTextSeconds">60</span><span class="language_replace">秒後再次發送</span></div>
                            <input id="idPhoneCode" type="password" class="" language_replace="placeholder" placeholder="輸入簡訊驗證碼" name="text">
                            <div class="popup_notice" style="display:inline;"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入發送至您指定手機門號之簡訊驗證碼</span></div>--%>
                        </div>
                        <div>
                            <!-- 檢查正確請加上"checked" 檢查未通過請加上"denied" -->
                            <input id="idEMail" type="text" language_replace="placeholder" placeholder="信箱" name="EMail">
                            <input id="idRealName" type="text" language_replace="placeholder" placeholder="設定真實姓名" name="RealName">
                            <div class="popup_notice" style="display: inline;"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入與銀行卡相同之真實姓名以確保您的權益</span></div>
                            <div class="popupBtn_red" onclick="formSubmitCheck()"><span class="language_replace">註冊</span></div>
                           <%-- <input id="idNickName" maxlength="16" type="text" language_replace="placeholder" placeholder="設定暱稱" name="NickName" autocomplete="off">
                            <input id="idRealName" maxlength="50" type="text" language_replace="placeholder" placeholder="設定真實姓名" name="RealName">
                            <div class="popup_notice" style="display:inline;"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入與銀行卡相同之真實姓名以確保您的權益</span></div>
                            <input id="idLoginPassword" type="password" class="" language_replace="placeholder" placeholder="輸入密碼" name="password" onblur="CheckPasswordAvailable()">
                            <div id="idLoginPasswordDeniedText" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">請輸入英文或數字8-16位數</span></div>
                            <input id="idLoginPassword2" type="password" class="" language_replace="placeholder" placeholder="確認密碼" name="password" onblur="CheckPasswordAvailable()">
                            <div id="idLoginPassword2DeniedText" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">輸入錯誤</span></div>
                            <div class="popupBtn_red" onclick="onBtnUserRegisterStep1()"><span class="language_replace">註冊</span></div>--%>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- HTML END -->
</body>
</html>
