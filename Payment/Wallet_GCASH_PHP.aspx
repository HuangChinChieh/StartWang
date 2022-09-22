<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Wallet_GCASH_PHP.aspx.cs" Inherits="Wallet_GCASH_PHP" %>

<%   
    string SID="";
    string CurrencyType="";
    string Lan = "";
    string[] stringSeparators = new string[] { "," };
    string AllowAksoDeposit = EWinWeb.AllowAksoDeposit;
    string AksoDepositLimit = EWinWeb.AksoDepositLimit;
    int AksoDepositLimitUp = 0;
    int AksoDepositLimitDown = 0;

    if (string.IsNullOrEmpty(Request["SID"]) == false)
        SID = Request["SID"].ToString();

    if (string.IsNullOrEmpty(Request["CurrencyType"]) == false)
        CurrencyType = Request["CurrencyType"].ToString();

    if (string.IsNullOrEmpty(Request["Lan"]) == false)
        Lan = Request["Lan"].ToString();

    AksoDepositLimitUp = Convert.ToInt32(AksoDepositLimit.Split(stringSeparators, StringSplitOptions.None)[0]);
    AksoDepositLimitDown = Convert.ToInt32(AksoDepositLimit.Split(stringSeparators, StringSplitOptions.None)[1]);
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0">
    <meta name="Description" content="99PLAY">
    <title>Ewin - Wallet</title>

    <!-- Favicon and touch icons -->
    <link rel="shortcut icon" href="/Game/ico/favicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/Game/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/Game/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/Game/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="/Game/ico/apple-touch-icon-57-precomposed.png">

    <!-- CSS -->
    <link href="css/GCASH_PAGE.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
    <!-- Favicon and touch icons -->
 
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/Lobby/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/Lobby/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/Lobby/ico/apple-touch-icon-57-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="/Lobby/ico/apple-touch-icon-72-precomposed.png">
    <script type="text/javascript" src="/Scripts/Common.js"></script>
    <script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
    <script type="text/javascript">
        var c = new common();
        var AllowAksoDeposit = "<%=AllowAksoDeposit%>";
        var AksoDepositLimitUp = "<%=AksoDepositLimitUp%>";
        var AksoDepositLimitDown = "<%=AksoDepositLimitDown%>";

        function sendPayment() {
            var retValue = true;
            var amount = document.getElementById("input_amount").value;

            if (parseInt(amount) <= 0 || isNaN(amount) == true || amount == "") {
                alert(mlp.getLanguageKey("請輸入正確金額"));
                retValue = false;
            }

            if (retValue == true) {
                if (parseInt(amount) < AksoDepositLimitUp || parseInt(amount) > AksoDepositLimitDown) {
                    alert(mlp.getLanguageKey("存款金額限制") + AksoDepositLimitUp + " ~ " + AksoDepositLimitDown);
                    retValue = false;
                }
            }

            if (retValue == true) {
                 window.open("/Payment/AksoPay/Deposit.aspx?SID=" + "<%=SID%>" + "&Amount=" + amount + "&CurrencyType=" +"<%=CurrencyType%>" , "_blank");
            }
        }

        function closeWindow() {
            window.close();
        }

        window.onload = function () {
            document.getElementById("AksoDepositLimitUp").innerText = c.toCurrency(AksoDepositLimitUp);
            document.getElementById("AksoDepositLimitDown").innerText = c.toCurrency(AksoDepositLimitDown);
            
            mlp = new multiLanguage();
            mlp.loadLanguage("<%=Lan%>", function () {
                if (AllowAksoDeposit == "0") {
                    alert(mlp.getLanguageKey("不支援此存款方式"));
                    window.close();
                }
            });
        }
    </script>
</head>

<body>
    <div class="GCP_wrapper">
        <div class="GCP_main">
            <div class="GCP_header">
                <div class="GCP_Tit"><span class="language_replace">我要存款</span></div>
                <div class="GCP_closeBtn" onclick="closeWindow()"><span>Close</span></div>
            </div>
            <div class="GCP_div">
                <div class="GCP_input">
                    <div><span class="language_replace">存款金額</span> :</div>
                    <input id="input_amount" type="number" language_replace="placeholder" placeholder="0">
                    <div class="GCP_info"><span class="language_replace">金額限制</span><span id="AksoDepositLimitUp">--</span>~<span id="AksoDepositLimitDown">--</span></div>
                </div>
                <div onclick="sendPayment()" class="GCP_OKBtn"><span class="language_replace">送出</span></div>
            </div>
        </div>
    </div>   
    <!-- 跳出訊息 -->
    <div class="GCP_POPUP" style="display: none;">
        <div class="GCP_POPUPDiv">
            <!--
            
            -->
            <div class="GCP_POPUPText"><span class="language_replace">錢包餘額不足</span></div>
            <div class="GCP_Btn2"><span class="language_replace">確認</span></div>
        </div>
    </div>
</body>
</html>

