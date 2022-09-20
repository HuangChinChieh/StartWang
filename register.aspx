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
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script>
    var c = new common();
    var apiURL = "/RequireRegister.aspx";
    var pCode = "<%=PCode%>";
    var p;
    var mlp;
    var EWinWebInfo;
    var lang;
    var isSent = false;
    var RegisterParentPersonCode = 0;

    function requireRegister() {
        var form = document.forms[0];
        var PCode = form.PCode.value;
        var ContactPhonePrefix = form.ContactPhonePrefix.value;
        var ContactPhoneNumber = form.ContactPhoneNumber.value;
        var ValidateCode = form.ValidateCode.value;
        var LoginPassword = form.LoginPassword.value;
        var EMail = form.EMail.value;
        var NickName = form.NickName.value;
        var RealName = form.RealName.value;
        var postObj;
        var ps = [];
        var CurrencyList = EWinWebInfo.RegisterCurrencyType;
        var PS = [{
            Name: "ContactPhonePrefix",
            Value: ContactPhonePrefix
        }, {
            Name: "ContactPhoneNumber",
            Value: ContactPhoneNumber
        }, {
            Name: "EMail",
            Value: EMail
        }, {
            Name: "RealName",
            Value: RealName
        },
        {
            Name: "Country",
            Value: form.Country.options[form.Country.selectedIndex].value
        }
         , {
            Name: "NickName",
            Value: NickName
        }
        ];
        p.CheckValidateCode(Math.uuid(), 0, EMail, "", "", ValidateCode, function (success2, o2) {
            if (success2) {
                if (o2.Result != 0) {
                    window.parent.showMessageOK("", mlp.getLanguageKey("請輸入正確驗證碼"));
                } else {
                    p.CreateAccount(Math.uuid(), EMail, LoginPassword, PCode, CurrencyList, PS, function (success, o) {
                        if (success) {
                            if (o.Result == 0) {
                                window.parent.showMessageOK(mlp.getLanguageKey("成功"), mlp.getLanguageKey("註冊成功, 請按登入按鈕進行登入"), function () {
                                    window.parent.API_Home();
                                });
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
            } else {
                window.parent.showMessageOK("", mlp.getLanguageKey("驗證碼錯誤"));
            }
        });
    }

    function validateEmail(mail, cb) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(mail)) {
            cb(true)
        } else {
            cb(false)
        }
    }

    function startCountDown(duration) {
        isSent = true;
        let secondsRemaining = duration;
        let min = 0;
        let sec = 0;

        let countInterval = setInterval(function () {
            let BtnSend = document.getElementById("btnSendValidateCode");
            $('#btnSendValidateCode').attr('disabled', true);
            //min = parseInt(secondsRemaining / 60);
            //sec = parseInt(secondsRemaining % 60);
            BtnSend.innerText = secondsRemaining + "s"

            secondsRemaining = secondsRemaining - 1;
            if (secondsRemaining < 0) {
                clearInterval(countInterval);
                SetBtnSend();
            };

        }, 1000);
    }

    function SetBtnSend() {
        let BtnSend = document.getElementById("btnSendValidateCode");
        $('#btnSendValidateCode').attr('disabled', false);
        BtnSend.innerText = mlp.getLanguageKey("驗證碼");
        isSent = false;
    }

    function onBtnSendValidateCode() {
        if (isSent == false) {
            var mail = $('#idEMail').val().trim();
            if (mail != "") {
                p.CheckAccountExist(Math.uuid(), mail, function (success, o) {
                    if (success) {
                        if (o.Result != 0) {
                            validateEmail(mail, function (success1) {
                                //test
                                if (success1) {
                                    window.parent.API_ShowMask();
                                    p.SetUserMail(Math.uuid(), 0, 0, mail, "", "", "", function (success2, o) {
                                        window.parent.API_HideMask();
                                        if (success2) {
                                            if (o.Result != 0) {
                                                window.parent.API_ShowMessageOK("", mlp.getLanguageKey("發送驗證碼失敗"));
                                            } else {
                                                window.parent.API_ShowMessageOK("", mlp.getLanguageKey("發送驗證碼成功"));
                                                startCountDown(120);

                                            }
                                        }
                                    });
                                } else {
                                    window.parent.API_ShowMessageOK("", mlp.getLanguageKey("EMail格式有誤"));
                                }
                            });
                        } else {
                            window.parent.API_ShowMessageOK("", mlp.getLanguageKey("信箱已存在"));
                        }
                    }

                });
            } else {
                window.parent.API_ShowMessageOK("", mlp.getLanguageKey("請先輸入信箱"));
            }
            
        } else {
            window.parent.API_ShowMessageOK("", mlp.getLanguageKey("已發送驗證碼，短時間內請勿重複發送"));
        }
    }

    function formSubmitCheck() {
        var form = document.forms[0];
        var PCode = form.PCode;
        var ContactPhonePrefix = form.ContactPhonePrefix;
        var ContactPhoneNumber = form.ContactPhoneNumber;
        var ValidateCode = form.ValidateCode;
        var EMail = form.EMail;
        var RealName = form.RealName;
        var NickName = form.NickName;
        var LoginPassword = form.LoginPassword;
        var retValue = false;
      
        if (ContactPhonePrefix.selectedIndex == -1)
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("請選擇聯繫電話國碼"));
        else if (ContactPhoneNumber.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("請輸入聯繫電話"));
        else if (EMail.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("請輸入E-mail"));
        else if (ValidateCode.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入驗證碼"));
        else if (LoginPassword.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請輸入密碼"));
        else if (NickName.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("請輸入暱稱"));
        else if (NickName.value.trim().length > 12)
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("暱稱請輸入英文與數字，長度12位元以內"));
        else if (RealName.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("請輸入真實姓名"));
        else if (RegisterParentPersonCode == 2 && PCode.value == "")
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"),mlp.getLanguageKey("請輸入推薦碼"));
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

    function CheckValidateCode() {
        if ($("#idValidateCode").val() == "") {
            $("#btnSendValidateCode").removeAttr("disabled");
        } else {
            $("#btnSendValidateCode").attr("disabled", "disabled");
        }
    }

    function init() {
        lang = window.top.API_GetLang();
        EWinWebInfo = window.parent.EWinWebInfo;
        p = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            //document.forms[0].Lang.value = lang;
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
                        <input id="idEMail" type="text" language_replace="placeholder" placeholder="信箱" name="EMail">
                        <div class="popupBtn_red" onclick="onBtnSendValidateCode()" id="btnSendValidateCode"><span class="language_replace">傳送驗證碼</span></div>
                        <input id="idValidateCode" name="ValidateCode" type="text" language_replace="placeholder" placeholder="驗證碼" onkeyup="CheckValidateCode()">
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
                            <input id="idContactPhoneNumber" type="text" language_replace="placeholder" placeholder="輸入電話" name="ContactPhoneNumber">
                            <div id="idContactPhoneNumberDenied" class="popup_notice" style="display: none"><i class="fa fa-info-circle"></i><span class="language_replace">電話已存在</span></div>
                        </div>
                       <input id="idLoginPassword" name="LoginPassword" type="password" language_replace="placeholder" placeholder="請輸入密碼">
                        <div>
                            <!-- 檢查正確請加上"checked" 檢查未通過請加上"denied" -->
                            <div class="form-group">
                                <div id="" class="ReferralCode"><span class="language_replace">國家</span>:</div>
                                <div class="input-group">
                                    <select class="form-control custom-style" name="Country">
                                        <option value="AF">Afghanistan</option>
                                        <option value="AX">Åland Islands</option>
                                        <option value="AL">Albania</option>
                                        <option value="DZ">Algeria</option>
                                        <option value="AS">American Samoa</option>
                                        <option value="AD">Andorra</option>
                                        <option value="AO">Angola</option>
                                        <option value="AI">Anguilla</option>
                                        <option value="AQ">Antarctica</option>
                                        <option value="AG">Antigua and Barbuda</option>
                                        <option value="AR">Argentina</option>
                                        <option value="AM">Armenia</option>
                                        <option value="AW">Aruba</option>
                                        <option value="AU">Australia</option>
                                        <option value="AT">Austria</option>
                                        <option value="AZ">Azerbaijan</option>
                                        <option value="BS">Bahamas (the)</option>
                                        <option value="BH">Bahrain</option>
                                        <option value="BD">Bangladesh</option>
                                        <option value="BB">Barbados</option>
                                        <option value="BY">Belarus</option>
                                        <option value="BE">Belgium</option>
                                        <option value="BZ">Belize</option>
                                        <option value="BJ">Benin</option>
                                        <option value="BM">Bermuda</option>
                                        <option value="BT">Bhutan</option>
                                        <option value="BO">Bolivia (Plurinational State of)</option>
                                        <option value="BQ">Bonaire, Sint Eustatius and Saba</option>
                                        <option value="BA">Bosnia and Herzegovina</option>
                                        <option value="BW">Botswana</option>
                                        <option value="BV">Bouvet Island</option>
                                        <option value="BR">Brazil</option>
                                        <option value="IO">British Indian Ocean Territory (the)</option>
                                        <option value="BN">Brunei Darussalam</option>
                                        <option value="BG">Bulgaria</option>
                                        <option value="BF">Burkina Faso</option>
                                        <option value="BI">Burundi</option>
                                        <option value="CV">Cabo Verde</option>
                                        <option value="KH">Cambodia</option>
                                        <option value="CM">Cameroon</option>
                                        <option value="CA">Canada</option>
                                        <option value="KY">Cayman Islands (the)</option>
                                        <option value="CF">Central African Republic (the)</option>
                                        <option value="TD">Chad</option>
                                        <option value="CL">Chile</option>
                                        <option value="CN">China</option>
                                        <option value="CX">Christmas Island</option>
                                        <option value="CC">Cocos (Keeling) Islands (the)</option>
                                        <option value="CO">Colombia</option>
                                        <option value="KM">Comoros (the)</option>
                                        <option value="CD">Congo (the Democratic Republic of the)</option>
                                        <option value="CG">Congo (the)</option>
                                        <option value="CK">Cook Islands (the)</option>
                                        <option value="CR">Costa Rica</option>
                                        <option value="HR">Croatia</option>
                                        <option value="CU">Cuba</option>
                                        <option value="CW">Curaçao</option>
                                        <option value="CY">Cyprus</option>
                                        <option value="CZ">Czechia</option>
                                        <option value="CI">Côte d'Ivoire</option>
                                        <option value="DK">Denmark</option>
                                        <option value="DJ">Djibouti</option>
                                        <option value="DM">Dominica</option>
                                        <option value="DO">Dominican Republic (the)</option>
                                        <option value="EC">Ecuador</option>
                                        <option value="EG">Egypt</option>
                                        <option value="SV">El Salvador</option>
                                        <option value="GQ">Equatorial Guinea</option>
                                        <option value="ER">Eritrea</option>
                                        <option value="EE">Estonia</option>
                                        <option value="SZ">Eswatini</option>
                                        <option value="ET">Ethiopia</option>
                                        <option value="FK">Falkland Islands (the) [Malvinas]</option>
                                        <option value="FO">Faroe Islands (the)</option>
                                        <option value="FJ">Fiji</option>
                                        <option value="FI">Finland</option>
                                        <option value="FR">France</option>
                                        <option value="GF">French Guiana</option>
                                        <option value="PF">French Polynesia</option>
                                        <option value="TF">French Southern Territories (the)</option>
                                        <option value="GA">Gabon</option>
                                        <option value="GM">Gambia (the)</option>
                                        <option value="GE">Georgia</option>
                                        <option value="DE">Germany</option>
                                        <option value="GH">Ghana</option>
                                        <option value="GI">Gibraltar</option>
                                        <option value="GR">Greece</option>
                                        <option value="GL">Greenland</option>
                                        <option value="GD">Grenada</option>
                                        <option value="GP">Guadeloupe</option>
                                        <option value="GU">Guam</option>
                                        <option value="GT">Guatemala</option>
                                        <option value="GG">Guernsey</option>
                                        <option value="GN">Guinea</option>
                                        <option value="GW">Guinea-Bissau</option>
                                        <option value="GY">Guyana</option>
                                        <option value="HT">Haiti</option>
                                        <option value="HM">Heard Island and McDonald Islands</option>
                                        <option value="VA">Holy See (the)</option>
                                        <option value="HN">Honduras</option>
                                        <option value="HK">Hong Kong</option>
                                        <option value="HU">Hungary</option>
                                        <option value="IS">Iceland</option>
                                        <option value="IN">India</option>
                                        <option value="ID">Indonesia</option>
                                        <option value="IR">Iran (Islamic Republic of)</option>
                                        <option value="IQ">Iraq</option>
                                        <option value="IE">Ireland</option>
                                        <option value="IM">Isle of Man</option>
                                        <option value="IL">Israel</option>
                                        <option value="IT">Italy</option>
                                        <option value="JM">Jamaica</option>
                                        <option value="JP">Japan</option>
                                        <option value="JE">Jersey</option>
                                        <option value="JO">Jordan</option>
                                        <option value="KZ">Kazakhstan</option>
                                        <option value="KE">Kenya</option>
                                        <option value="KI">Kiribati</option>
                                        <option value="KP">Korea (the Democratic People's Republic of)</option>
                                        <option value="KR">Korea (the Republic of)</option>
                                        <option value="KW">Kuwait</option>
                                        <option value="KG">Kyrgyzstan</option>
                                        <option value="LA">Lao People's Democratic Republic (the)</option>
                                        <option value="LV">Latvia</option>
                                        <option value="LB">Lebanon</option>
                                        <option value="LS">Lesotho</option>
                                        <option value="LR">Liberia</option>
                                        <option value="LY">Libya</option>
                                        <option value="LI">Liechtenstein</option>
                                        <option value="LT">Lithuania</option>
                                        <option value="LU">Luxembourg</option>
                                        <option value="MO">Macao</option>
                                        <option value="MG">Madagascar</option>
                                        <option value="MW">Malawi</option>
                                        <option value="MY">Malaysia</option>
                                        <option value="MV">Maldives</option>
                                        <option value="ML">Mali</option>
                                        <option value="MT">Malta</option>
                                        <option value="MH">Marshall Islands (the)</option>
                                        <option value="MQ">Martinique</option>
                                        <option value="MR">Mauritania</option>
                                        <option value="MU">Mauritius</option>
                                        <option value="YT">Mayotte</option>
                                        <option value="MX">Mexico</option>
                                        <option value="FM">Micronesia (Federated States of)</option>
                                        <option value="MD">Moldova (the Republic of)</option>
                                        <option value="MC">Monaco</option>
                                        <option value="MN">Mongolia</option>
                                        <option value="ME">Montenegro</option>
                                        <option value="MS">Montserrat</option>
                                        <option value="MA">Morocco</option>
                                        <option value="MZ">Mozambique</option>
                                        <option value="MM">Myanmar</option>
                                        <option value="NA">Namibia</option>
                                        <option value="NR">Nauru</option>
                                        <option value="NP">Nepal</option>
                                        <option value="NL">Netherlands (the)</option>
                                        <option value="NC">New Caledonia</option>
                                        <option value="NZ">New Zealand</option>
                                        <option value="NI">Nicaragua</option>
                                        <option value="NE">Niger (the)</option>
                                        <option value="NG">Nigeria</option>
                                        <option value="NU">Niue</option>
                                        <option value="NF">Norfolk Island</option>
                                        <option value="MP">Northern Mariana Islands (the)</option>
                                        <option value="NO">Norway</option>
                                        <option value="OM">Oman</option>
                                        <option value="PK">Pakistan</option>
                                        <option value="PW">Palau</option>
                                        <option value="PS">Palestine, State of</option>
                                        <option value="PA">Panama</option>
                                        <option value="PG">Papua New Guinea</option>
                                        <option value="PY">Paraguay</option>
                                        <option value="PE">Peru</option>
                                        <option value="PH">Philippines (the)</option>
                                        <option value="PN">Pitcairn</option>
                                        <option value="PL">Poland</option>
                                        <option value="PT">Portugal</option>
                                        <option value="PR">Puerto Rico</option>
                                        <option value="QA">Qatar</option>
                                        <option value="MK">Republic of North Macedonia</option>
                                        <option value="RO">Romania</option>
                                        <option value="RU">Russian Federation (the)</option>
                                        <option value="RW">Rwanda</option>
                                        <option value="RE">Réunion</option>
                                        <option value="BL">Saint Barthélemy</option>
                                        <option value="SH">Saint Helena, Ascension and Tristan da Cunha</option>
                                        <option value="KN">Saint Kitts and Nevis</option>
                                        <option value="LC">Saint Lucia</option>
                                        <option value="MF">Saint Martin (French part)</option>
                                        <option value="PM">Saint Pierre and Miquelon</option>
                                        <option value="VC">Saint Vincent and the Grenadines</option>
                                        <option value="WS">Samoa</option>
                                        <option value="SM">San Marino</option>
                                        <option value="ST">Sao Tome and Principe</option>
                                        <option value="SA">Saudi Arabia</option>
                                        <option value="SN">Senegal</option>
                                        <option value="RS">Serbia</option>
                                        <option value="SC">Seychelles</option>
                                        <option value="SL">Sierra Leone</option>
                                        <option value="SG">Singapore</option>
                                        <option value="SX">Sint Maarten (Dutch part)</option>
                                        <option value="SK">Slovakia</option>
                                        <option value="SI">Slovenia</option>
                                        <option value="SB">Solomon Islands</option>
                                        <option value="SO">Somalia</option>
                                        <option value="ZA">South Africa</option>
                                        <option value="GS">South Georgia and the South Sandwich Islands</option>
                                        <option value="SS">South Sudan</option>
                                        <option value="ES">Spain</option>
                                        <option value="LK">Sri Lanka</option>
                                        <option value="SD">Sudan (the)</option>
                                        <option value="SR">Suriname</option>
                                        <option value="SJ">Svalbard and Jan Mayen</option>
                                        <option value="SE">Sweden</option>
                                        <option value="CH">Switzerland</option>
                                        <option value="SY">Syrian Arab Republic</option>
                                        <option value="TW" selected>Taiwan</option>
                                        <option value="TJ">Tajikistan</option>
                                        <option value="TZ">Tanzania, United Republic of</option>
                                        <option value="TH">Thailand</option>
                                        <option value="TL">Timor-Leste</option>
                                        <option value="TG">Togo</option>
                                        <option value="TK">Tokelau</option>
                                        <option value="TO">Tonga</option>
                                        <option value="TT">Trinidad and Tobago</option>
                                        <option value="TN">Tunisia</option>
                                        <option value="TR">Turkey</option>
                                        <option value="TM">Turkmenistan</option>
                                        <option value="TC">Turks and Caicos Islands (the)</option>
                                        <option value="TV">Tuvalu</option>
                                        <option value="UG">Uganda</option>
                                        <option value="UA">Ukraine</option>
                                        <option value="AE">United Arab Emirates (the)</option>
                                        <option value="GB">United Kingdom of Great Britain and Northern Ireland (the)</option>
                                        <option value="UM">United States Minor Outlying Islands (the)</option>
                                        <option value="US">United States of America (the)</option>
                                        <option value="UY">Uruguay</option>
                                        <option value="UZ">Uzbekistan</option>
                                        <option value="VU">Vanuatu</option>
                                        <option value="VE">Venezuela (Bolivarian Republic of)</option>
                                        <option value="VN">Viet Nam</option>
                                        <option value="VG">Virgin Islands (British)</option>
                                        <option value="VI">Virgin Islands (U.S.)</option>
                                        <option value="WF">Wallis and Futuna</option>
                                        <option value="EH">Western Sahara</option>
                                        <option value="YE">Yemen</option>
                                        <option value="ZM">Zambia</option>
                                        <option value="ZW">Zimbabwe</option>
                                    </select>
                                </div>
                            </div>
                            <input id="idNickName" type="text" language_replace="placeholder" placeholder="暱稱請輸入英文與數字，長度12位元以內" name="NickName">
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
