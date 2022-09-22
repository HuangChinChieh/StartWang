<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0">
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
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<script>
    var c = new common();
    var ui = new uiControl();
    var apiURL = "/history.aspx";
    var mlp;
    var p;
    var EWinWebInfo;
    var postObj;

    function init() {
        EWinWebInfo = window.parent.API_GetWebInfo();
        p = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage();
        mlp.loadLanguage(EWinWebInfo.Lang, function () {
            window.parent.checkUserLogin(EWinWebInfo.SID, function () {
                //updateBaseInfo();
                var date = new Date();
                document.getElementById('idPageStartData').value = getDateString(date);
                document.getElementById('idPageEndData').value = getDateString(date);
                changeSwitchTag("Game");
            });
        });

        document.body.addEventListener('change', function (e) {
            let target = e.target;

            switch (target.id) {
                case 'radioToday':
                    var date = new Date();
                    document.getElementById('idPageStartData').value = getDateString(date);
                    document.getElementById('idPageEndData').value = getDateString(date);
                    break;
                case 'radioYesterday':
                    var yesterday = new Date();
                    yesterday = new Date(yesterday.setDate(yesterday.getDate() - 1));
                    document.getElementById('idPageStartData').value = getDateString(yesterday);
                    document.getElementById('idPageEndData').value = getDateString(yesterday);
                    break;
                case 'radioWeek':
                    var startdate = new Date();
                    var enddate = new Date();
                    startdate = new Date(startdate.setDate(startdate.getDate() - 7));
                    document.getElementById('idPageStartData').value = getDateString(startdate);
                    document.getElementById('idPageEndData').value = getDateString(enddate);
                    break;
            }
        });
    }

    function updateBaseInfo() {

    }

    function getDateString(date) {

        var mm = date.getMonth() + 1; // getMonth() is zero-based
        var dd = date.getDate();

        return [date.getFullYear(),
        (mm > 9 ? '' : '0') + mm,
        (dd > 9 ? '' : '0') + dd
        ].join('-');
    }

    function GWebEventNotify(eventName, isDisplay, o) {
        if (isDisplay) {
            if (eventName == "SetLanguage") {
                lang = o;
                mlp.loadLanguage(lang, function () { });
            }
        }
    }

    function EWinEventNotify(eventName, isDisplay, param) {
        switch (eventName) {
            case "LoginState":
                updateBaseInfo();

                break;
            case "BalanceChange":
                break;
            case "SetLanguage":
                var lang = param;

                mlp.loadLanguage(lang);
                break;
        }
    }

    function changeSwitchTag(eventName) {
        switch (eventName) {
            case "PaymentHistory":
                var element = document.getElementsByClassName("switchTagBtn");
                for (var i = 0; i < element.length; i++) {
                    element[i].classList.remove("active");
                }

                var activeElement = document.getElementById("TagPaymentHistory");
                activeElement.classList.add("active");
                document.getElementById("PaymentHistoryPageMainCon").style.display = "block";
                document.getElementById("gamePageMainCon").style.display = "none";
                break;
            case "Game":
                var element = document.getElementsByClassName("switchTagBtn");
                for (var i = 0; i < element.length; i++) {
                    element[i].classList.remove("active");
                }
                var activeElement = document.getElementById("TagGameHistory");
                activeElement.classList.add("active");
                document.getElementById("PaymentHistoryPageMainCon").style.display = "none";
                document.getElementById("gamePageMainCon").style.display = "block";
                break;
            default:
                break;
        }
    }

    function getHistory() {
        var tagID = document.getElementsByClassName('switchTagBtn active')[0].id;
        switch (tagID) {
            case 'TagGameHistory':
                var startDate = document.getElementById('idPageStartData').value;
                var endDate = document.getElementById('idPageEndData').value;
                var ParentMain = document.getElementById("gamePageMainCon").getElementsByClassName("rowOne")[0];

                ParentMain.innerHTML = "";
                document.getElementById('gameTotalRewardValue').style.color = "#999"

                postObj = {
                    SID: EWinWebInfo.SID,
                    GUID: Math.uuid(),
                    BeginDate: startDate,
                    EndDate: endDate
                }

                p.GetGameOrderDetailHistoryBySummaryDate(postObj, function (success, o) {
                    if (success) {
                        if (o.Result == 0) {
                            if (o.DetailList.length > 0) {
                                var numGameTotalValidBetValue = new BigNumber(0);
                                var numGameTotalRewardValue = new BigNumber(0);
                                var ParentMain = document.getElementById("gamePageMainCon").getElementsByClassName("rowOne")[0];

                                //排序
                                o.DetailList.sort(function (a, b) {
                                    var GameDateA = a.GameDate;
                                    var GameDateB = b.GameDate;
                                    var GameTimeA = a.GameTime;
                                    var GameTimeB = b.GameTime;

                                    if (GameDateA > GameDateB) {
                                        return -1;
                                    }
                                    if (GameDateA < GameDateB) {
                                        return 1;
                                    }

                                    if (GameTimeA > GameTimeB) {
                                        return -1;
                                    }
                                    if (GameTimeA < GameTimeB) {
                                        return 1;
                                    }

                                    return 0;
                                });

                                for (var i = 0; i < o.DetailList.length; i++) {
                                    var record = o.DetailList[i];
                                    var gameBrand = record.GameCode.split('.')[0];
                                    var gameCode = record.GameCode;

                                    if (gameBrand == "EWin") {
                                        gameCode = "EWin.EWinGaming";
                                    }

                                    window.parent.API_GetGameLang(EWinWebInfo.Lang, gameCode, (function (langText) {
                                        var record = this;
                                        var status = "lose";

                                        numGameTotalValidBetValue = numGameTotalValidBetValue.plus(record.ValidBetValue);
                                        numGameTotalRewardValue = numGameTotalRewardValue.plus(record.RewardValue);

                                        if (record.RewardValue >= 0) {
                                            status = "win";
                                        }

                                        var DateDom = c.getTemplate("templateRowTitle");
                                        c.setClassText(DateDom, "rowDate", null, record.GameDate + " " + record.GameTime);
                                        ParentMain.appendChild(DateDom);

                                        var gameRowOneDom = c.getTemplate("templateGameOrderRow");
                                        var statusDom = gameRowOneDom.getElementsByClassName("Status")[0];

                                        c.setClassText(gameRowOneDom, "CurrencyType", null, record.CurrencyType);
                                        c.setClassText(gameRowOneDom, "RewardValue", null, record.RewardValue);

                                        c.setClassText(gameRowOneDom, "ValidBetValue", null, record.ValidBetValue);

                                        if (record.RewardValue >= 0) {
                                            statusDom.classList.add("win");
                                        } else if (record.RewardValue < 0) {
                                            statusDom.classList.add("lose");
                                        }

                                        ParentMain.appendChild(gameRowOneDom);

                                        c.setClassText(gameRowOneDom, "GameName", null, "<sapn>" + langText + "</span>");
                                    }).bind(record));

                                }

                                document.getElementById('gameTotalValidBetValue').textContent = numGameTotalValidBetValue;
                                document.getElementById('gameTotalRewardValue').textContent = numGameTotalRewardValue;
                                if (numGameTotalRewardValue < 0) {
                                    document.getElementById('gameTotalRewardValue').style.color = "#FF0000";
                                }
                                else {
                                    document.getElementById('gameTotalRewardValue').style.color = "#999"
                                }

                                mlp.loadLanguage(EWinWebInfo.Lang);

                            } else {

                                window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("沒有資料"));
                                document.getElementById('gameTotalValidBetValue').textContent = 0;
                                document.getElementById('gameTotalRewardValue').textContent = 0;
                            }
                        } else {
                            window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("取得資料失敗"));
                            document.getElementById('gameTotalValidBetValue').textContent = 0;
                            document.getElementById('gameTotalRewardValue').textContent = 0;
                        }
                    }
                });

                break;
            case 'TagPaymentHistory':

                var startDate = document.getElementById('idPageStartData').value;
                var endDate = document.getElementById('idPageEndData').value;
                var ParentMain = document.getElementById("PaymentHistoryPageMainCon").getElementsByClassName("rowOne")[0];

                ParentMain.innerHTML = "";
                document.getElementById('gameTotalRewardValue').style.color = "#999"

                postObj = {
                    SID: EWinWebInfo.SID,
                    GUID: Math.uuid(),
                    BeginDate: startDate,
                    EndDate: endDate
                }
                p.GetPaymentHistory(postObj, function (success, o) {
                    if (success) {
                        if (o.Result == 0) {
                            if (o.DetailList.length > 0) {
                                var ParentMain = document.getElementById("PaymentHistoryPageMainCon").getElementsByClassName("rowOne")[0];
                                let nowDate = "";
                                for (var i = 0; i < o.DetailList.length; i++) {
                                    let CreateDate = o.DetailList[i].CreateDate.substr(0, 10);
                                    if (nowDate != CreateDate) {
                                        nowDate = CreateDate;
                                        var DateDom = c.getTemplate("templateRowTitle");
                                        c.setClassText(DateDom, "rowDate", null, nowDate);
                                        ParentMain.appendChild(DateDom);
                                    }


                                    var gameRowOneDom = c.getTemplate("templatePaymentRow");
                                    var statusDom = gameRowOneDom.getElementsByClassName("Status")[0];
                                    var PaymentProviderCode = "";

                                    switch (o.DetailList[i].PaymentType) {
                                        case 1:
                                            PaymentProviderCode = "銀行卡";
                                            break;
                                        case 2:
                                            PaymentProviderCode = "區塊鏈";
                                            break;
                                        default:
                                            PaymentProviderCode = "銀行卡";
                                            break;
                                    }

                                    c.setClassText(gameRowOneDom, "PaymentType", null, o.DetailList[i].DirectionType == 0 ? "<sapn class='language_replace'>存款</span>" : "<sapn class='language_replace'>取款</span>");
                                    c.setClassText(gameRowOneDom, "FinishedDate", null, o.DetailList[i].FinishedDate.split(" ")[1]);
                                    c.setClassText(gameRowOneDom, "PaymentProviderCode", null, "<sapn class='language_replace'>" + PaymentProviderCode + "</span>");
                                    c.setClassText(gameRowOneDom, "CurrencyType", null, o.DetailList[i].CurrencyType);
                                    c.setClassText(gameRowOneDom, "Amount", null, o.DetailList[i].Amount);
                                    c.setClassText(gameRowOneDom, "PaymentSerial", null, o.DetailList[i].PaymentSerial);

                                    switch (o.DetailList[i].PaymentType) {
                                        case 1:
                                            switch (o.DetailList[i].Status) {
                                                //-1= 尚未建立完成 / 0=訂單完成 / 1=交易開始 / 2=交易完成 / 3=結算完成 / 98=交易完成但扣捕點失敗 / 99=失敗
                                                case -1:
                                                    paymentState = "<sapn class='language_replace'>處理中</span>";
                                                    paymentStateClass = "rowStatusCheck";
                                                    break;
                                                case 0:
                                                    paymentState = "<sapn class='language_replace'>處理中</span>";
                                                    paymentStateClass = "rowStatusCheck";
                                                    break;
                                                case 1:
                                                    paymentState = "<sapn class='language_replace'>完成</span>";
                                                    paymentStateClass = "rowStatusSucc";
                                                    break;
                                                case 2:
                                                    paymentState = "<sapn class='language_replace'>失敗</span>";
                                                    paymentStateClass = "rowStatusFail";
                                                    break;
                                                case 3:
                                                    paymentState = "<sapn class='language_replace'>失敗</span>";
                                                    paymentStateClass = "rowStatusFail";
                                                    break;
                                                default:
                                                    paymentState = "<sapn class='language_replace'>失敗</span>";
                                                    paymentStateClass = "rowStatusFail";

                                                    break;
                                            }
                                            break;
                                    }

                                    c.setClassText(gameRowOneDom, "Status", null, paymentState);
                                    statusDom.parentElement.classList.add(paymentStateClass);

                                    ParentMain.appendChild(gameRowOneDom);
                                    mlp.loadLanguage(EWinWebInfo.Lang);
                                }
                            } else {
                                window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("沒有資料"));
                            }
                        } else {
                            window.parent.showMessageOK(mlp.getLanguageKey("提示"), mlp.getLanguageKey("取得資料失敗"));

                        }
                    }
                });

                //window.parent.lobbyClient.GetPaymentHistory(guid, startDate, endDate, function (success, o) {
                //    if (success) {
                //    } else {
                //        // 忽略 timeout 
                //    }
                //});
                break;
            default:
                break;
        }
    }

    window.onload = init;
</script>
<body>
    <div id="templateGroup" style="display: none">
        <div id="templateRowTitle">
            <div class="rowTitle"><span class="rowDate"></span></div>
        </div>

        <div id="templateGameOrderRow">
            <!-- 狀態樣式 客上贏錢"win" 客下輸錢"lose" -->
            <div class="rowElm2L">
                <div class="row3XL1A"><span class="GameName language_replace">99Play</span></div>
                <div class="row3XL1B"><span class="CurrencyType" style="color: black; margin-right: 5px">CNY</span></div>
                <div class="Status row3XL1C win"><span class="language_replace">上下數</span> : <span class="RewardValue">6,523</span></div>
                <div class="row3XL2B"><span class="language_replace">有效投注</span>:<span class="ValidBetValue">7,300</span></div>
                <div class="row3XL2C"><span></span></div>
            </div>
            <!-- -->
        </div>

        <div id="templatePaymentRow">
            <div class="rowElm2L">
                <div class="row3XL1A"><span class="FinishedDate">下午04:33</span></div>
                <div class="row3XL1B"><span class="PaymentProviderCode language_replace">支付寶</span></div>
                <div class="row3XL1C"><span class="" style="color: black; margin-right: 5px">CNY</span><span class="Amount">1,000,000</span></div>
                <div class="row3XL2A"><span class="PaymentType language_replace"></span></div>
                <div class="row3XL2B"><span class="PaymentSerial">-</span></div>
                <div class=""><span class="Status"></span></div>
            </div>

        </div>
    </div>
    <div class="pageWrapper">
        <div class="pageMain">
            <div class="pageHeader">
                <div class="backBtn" style="display: none;"><span class="fa fa-arrow-left"></span></div>
                <div class="pageTitle"><span class="language_replace">各項報表</span></div>
            </div>
            <div>
                <div class="switchTagDiv">
                    <div class="switchTagBtn active" id="TagGameHistory" onclick="changeSwitchTag('Game')"><span class="language_replace">遊戲紀錄</span></div>
                    <div class="switchTagBtn" id="TagPaymentHistory" onclick="changeSwitchTag('PaymentHistory')"><span class="language_replace">存取款紀錄</span></div>
                </div>
                <!-- 搜尋列 -->
                <div class="pageDataBar">
                    <form>
                        <div class="pageStartData">
                            <span class="language_replace">起始日期</span>
                            <input id="idPageStartData" type="date">
                        </div>
                        <div class="pageEndData">
                            <span class="language_replace">結束日期</span>
                            <input id="idPageEndData" type="date">
                        </div>
                    </form>
                    <div class="pageDSreachBtn" onclick="getHistory()">
                        <span class="language_replace">搜尋</span>
                    </div>
                    <div class="pageDDataSwitchBar">
                        <form>
                            <label class="">
                                <input type="radio" name="DData" id="radioToday">
                                <div class="pageDDataBtn"><span class="language_replace">本日</span></div>
                            </label>
                            <label class="">
                                <input type="radio" name="DData" id="radioYesterday">
                                <div class="pageDDataBtn"><span class="language_replace">前日</span></div>
                            </label>
                            <label class="">
                                <input type="radio" name="DData" id="radioWeek">
                                <div class="pageDDataBtn"><span class="language_replace">本週</span></div>
                            </label>
                        </form>
                    </div>
                </div>
                <!-- 存款紀錄 -->
                <div id="PaymentHistoryPageMainCon" class="pageMainCon" style="display: none;">
                    <!---->
                    <div class="rowOne">
                    </div>
                    <%--<div class="pageFooter">
                        <div class="rowTitle"><span class="language_replace">注意事項</span></div>
                        <div class="rowList">
                            <ol>
                                <li class="language_replace">每次提款最少點數為1000點以上，請務必確認填寫之帳號，若提供的帳號錯誤，恕本公司無法負責。</li>
                                <li class="language_replace">提款時需達到存款總金額的100%有效投注量才可提出申請。(PS:如利用本平臺進行任何洗錢詐騙行為，本公司保留權利審核會員帳戶或停權終止會員服務)</li>
                            </ol>
                        </div>
                    </div>--%>
                </div>
                <!---->
                <!-- 遊戲紀錄 -->
                <div id="gamePageMainCon" class="pageMainCon" style="display: none;">
                    <!-- -->
                    <div class="infoBar">
                        <%--<div class="infoDiv"><span class="language_replace">期間總下注金額</span>:<span  id="TotalOrderValue">0</span></div>--%>
                        <div class="infoDiv"><span class="language_replace">期間總有效投注</span>:<span id="gameTotalValidBetValue">0</span></div>
                        <div class="infoDiv"><span class="language_replace">期間總派彩</span>:<span id="gameTotalRewardValue">0</span></div>
                    </div>
                    <!---->
                    <div class="rowOne" id="gameRowOne">
                        <!-- -->
                        <div class="rowNoRessult"><span class="language_replace">無資料</span></div>
                        <!-- -->
                        <!-- -->
                        <div class="rowTitle"><span></span></div>
                        <!-- -->
                    </div>
                </div>
                <!---->

            </div>
        </div>
    </div>

</body>
</html>
