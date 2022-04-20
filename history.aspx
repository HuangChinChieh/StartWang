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
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script>
    var c = new common();
    var GWebInfo;
    var p;
    var mlp;
    var lang;
    var nowTag;


    function switchTagBtn(tag) {
        var target = event.currentTarget;
        var targets = document.getElementsByClassName("switchTagBtn");
        for (var i = 0; i < targets.length; i++) {
            if (target == targets[i]) {
                targets[i].classList.add("active");
            } else {
                targets[i].classList.remove("active");
            }
        }

        showHistory(tag);
    }

    function showHistory(tag) {
        nowTag = tag;
        var pageMainCons = document.getElementsByClassName("pageMainCon");

        for (var i = 0; i < pageMainCons.length; i++) {
            pageMainCons[i].style.display = "none";
        }
        
        if (tag == 'Deposit') {
            document.getElementById("MainDeposit").style.display = "block";            
            getPaymentDeposit();
        } else if (tag == 'Withdraw') {
            document.getElementById("MainWithdraw").style.display = "block";
            getPaymentWithdraw();
        } else if (tag == 'GameOrder') {
            document.getElementById("MainGameOrder").style.display = "block";
            getGameOrderSummary();
        }
    }

    function getPaymentDeposit() {
        p.GetPaymentHistory(
            GWebInfo.SID,
            Math.uuid(),
            document.getElementById("searchStartDate").value,
            document.getElementById("searchEndDate").value,
            function (success, o) {
                if (success) {
                    if (o != null) {
                        var ParentMain = document.getElementById("MainDeposit").getElementsByClassName("rowOne")[0];
                        ParentMain.innerHTML = "";

                        if (o.PaymentDetailList && o.PaymentDetailList.length > 0) {
                            var datas = o.PaymentDetailList.filter(function (item, index, array) {
                                return item.PaymentType == 0 && item.PaymentFlowType != -1;
                            }).sort(function (x, y) {
                                var Date1 = new Date(x.CreateDate + " " + x.CreateTime);
                                var Date2 = new Date(x.CreateDate + " " + x.CreateTime);

                                return Date1.getTime() < Date2.getTime()
                            });
                           
                            var QueryDate;
                            
                            for (var i = 0; i < datas.length; i++) {
                                var paymentDetail = datas[i];
                                var createDate = new Date(paymentDetail.CreateDate)

                                if (QueryDate == null || QueryDate != createDate) {
                                    QueryDate = createDate;
                                    var DateDom = c.getTemplate("templateRowTitle");
                                    c.setClassText(DateDom, "rowDate", null, QueryDate.toISOString().substring(0, 10));
                                    ParentMain.appendChild(DateDom);
                                }

                                var paymentDetailDom = c.getTemplate("templateDepositRow");
                                var statusDom = paymentDetailDom.getElementsByClassName("Status")[0];

                                c.setClassText(paymentDetailDom, "CreateTime", null, paymentDetail.CreateTime);
                                c.setClassText(paymentDetailDom, "ChannelCode", null, paymentDetail.ChannelCode);
                                c.setClassText(paymentDetailDom, "CurrencyType", null, paymentDetail.CurrencyType);
                                c.setClassText(paymentDetailDom, "Amount", null, paymentDetail.Amount);
                                c.setClassText(paymentDetailDom, "PaymentSerial", null, paymentDetail.PaymentSerial);
                                c.setClassText(paymentDetailDom, "BankName", null, paymentDetail.BankName);
                                c.setClassText(paymentDetailDom, "AccountName", null, paymentDetail.AccountName);



                                switch (paymentDetail.PaymentFlowType) {
                                    case -1:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null,mlp.getLanguageKey("尚未建立完成"));
                                        statusDom.classList.add("rowStatusCheck");
                                        break;
                                    case 0:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("訂單完成(尚未審核)"));
                                        statusDom.classList.add("rowStatusCheck");
                                        break;
                                    case 1:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易開始"));
                                        statusDom.classList.add("rowStatusCheck");
                                        break;
                                    case 2:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易完成"));
                                        statusDom.classList.add("rowStatusSucc");
                                        break;
                                    case 3:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null,mlp.getLanguageKey("結算完成"));
                                        statusDom.classList.add("rowStatusSucc");
                                        break;
                                    case 98:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易完成，扣捕點失敗"));
                                        statusDom.classList.add("rowStatusGray");
                                        break;
                                    case 99:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易失敗"));
                                        statusDom.classList.add("rowStatusGray");
                                        break;
                                }

                                ParentMain.appendChild(paymentDetailDom);
                            }
                        }
                    }
                }
            });
    }

    function getPaymentWithdraw() {
        p.GetPaymentHistory(
            GWebInfo.SID,
            Math.uuid(),
            document.getElementById("searchStartDate").value,
            document.getElementById("searchEndDate").value,
            function (success, o) {
                if (success) {
                    if (o != null) {
                        var ParentMain = document.getElementById("MainWithdraw").getElementsByClassName("rowOne")[0];
                        ParentMain.innerHTML = "";

                        if (o.PaymentDetailList && o.PaymentDetailList.length > 0) {
                            var datas = o.PaymentDetailList.filter(function (item, index, array) {
                                return item.PaymentType == 1 && item.PaymentFlowType != -1;
                            }).sort(function (x, y) {
                                var Date1 = new Date(x.CreateDate + " " + x.CreateTime);
                                var Date2 = new Date(x.CreateDate + " " + x.CreateTime);

                                return Date1.getTime() < Date2.getTime()
                            });
                            
                            var QueryDate;

                            for (var i = 0; i < datas.length; i++) {
                                var paymentDetail = datas[i];
                                var createDate = new Date(paymentDetail.CreateDate)

                                if (QueryDate == null || QueryDate != createDate) {
                                    QueryDate = createDate;
                                    var DateDom = c.getTemplate("templateRowTitle");
                                    c.setClassText(DateDom, "rowDate", null, QueryDate.toISOString().substring(0, 10));
                                    ParentMain.appendChild(DateDom);
                                }

                                var paymentDetailDom = c.getTemplate("templateWithdrawRow");
                                var statusDom = paymentDetailDom.getElementsByClassName("Status")[0];

                                c.setClassText(paymentDetailDom, "CreateTime", null, paymentDetail.CreateTime);
                                c.setClassText(paymentDetailDom, "ChannelCode", null, paymentDetail.ChannelCode);
                                c.setClassText(paymentDetailDom, "CurrencyType", null, paymentDetail.CurrencyType);
                                c.setClassText(paymentDetailDom, "Amount", null, paymentDetail.Amount);
                                c.setClassText(paymentDetailDom, "PaymentSerial", null, paymentDetail.PaymentSerial);
                                c.setClassText(paymentDetailDom, "BankName", null, paymentDetail.BankName);
                                c.setClassText(paymentDetailDom, "AccountName", null, paymentDetail.AccountName);



                                switch (paymentDetail.PaymentFlowType) {
                                    case -1:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("尚未建立完成"));
                                        statusDom.classList.add("rowStatusCheck");
                                        break;
                                    case 0:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null,mlp.getLanguageKey("訂單完成(尚未審核)"));
                                        statusDom.classList.add("rowStatusCheck");
                                        break;
                                    case 1:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易開始"));
                                        statusDom.classList.add("rowStatusCheck");
                                        break;
                                    case 2:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易完成"));
                                        statusDom.classList.add("rowStatusSucc");
                                        break;
                                    case 3:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null,mlp.getLanguageKey("結算完成"));
                                        statusDom.classList.add("rowStatusSucc");
                                        break;
                                    case 98:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易完成，扣捕點失敗"));
                                        statusDom.classList.add("rowStatusGray");
                                        break;
                                    case 99:
                                        c.setClassText(paymentDetailDom, "PaymentFlowType", null, mlp.getLanguageKey("交易失敗"));
                                        statusDom.classList.add("rowStatusGray");
                                        break;
                                }

                                ParentMain.appendChild(paymentDetailDom);
                            }
                        }
                    }
                }
            });
    }

    function getGameOrderSummary() {
        p.GetOrderSummaryByUserAccount(
                  GWebInfo.SID,
                  Math.uuid(),
                  document.getElementById("searchStartDate").value,
                  document.getElementById("searchEndDate").value,
                  function (success, o) {
                      if (success) {
                          if (o != null) {
                              var ParentMain = document.getElementById("MainGameOrder").getElementsByClassName("rowOne")[0];
                              var TotalOrderValue = new BigNumber(0);
                              var TotalValiBet = new BigNumber(0);
                              var TotalRewardValue = new BigNumber(0);
                              ParentMain.innerHTML = "";

                              if (o.SummaryList && o.SummaryList.length > 0) {
                                  var datas = o.SummaryList;                                  
                                  var QueryDate;

                                  for (var i = 0; i < datas.length; i++) {
                                      var orderSummary = datas[i];
                                      var createDate = new Date(orderSummary.SummaryDate)
                                      TotalOrderValue = TotalOrderValue.plus(orderSummary.OrderValue);
                                      TotalValiBet = TotalValiBet.plus(orderSummary.ValidBetValue);
                                      TotalRewardValue = TotalRewardValue.plus(orderSummary.RewardValue);


                                      if (QueryDate == null || QueryDate != createDate) {
                                          QueryDate = createDate;
                                          var DateDom = c.getTemplate("templateRowTitle");
                                          c.setClassText(DateDom, "rowDate", null, QueryDate.toISOString().substring(0, 10));
                                          ParentMain.appendChild(DateDom);
                                      }

                                      var orderSummaryDom = c.getTemplate("templateGameOrderRow");
                                      var statusDom = orderSummaryDom.getElementsByClassName("Status")[0];

                                      c.setClassText(orderSummaryDom, "GameName", null, orderSummary.GameName);
                                      c.setClassText(orderSummaryDom, "WebTagName", null, orderSummary.WebTagName);
                                      c.setClassText(orderSummaryDom, "CurrencyType", null, orderSummary.CurrencyType);
                                      c.setClassText(orderSummaryDom, "RewardValue", null, orderSummary.RewardValue);
                                      c.setClassText(orderSummaryDom, "OrderValue", null, orderSummary.OrderValue);
                                      c.setClassText(orderSummaryDom, "ValidBetValue", null, orderSummary.ValidBetValue);

                                      if (orderSummary.RewardValue > 0) {
                                          statusDom.classList.add("win");
                                      } else if (orderSummary.RewardValue < 0) {
                                          statusDom.classList.add("lose");
                                      }

                                      ParentMain.appendChild(orderSummaryDom);
                                  }
                              }

                              document.getElementById("TotalOrderValue").innerText = TotalOrderValue;
                              document.getElementById("TotalValiBet").innerText = TotalValiBet;
                              document.getElementById("TotalRewardValue").innerText = TotalRewardValue;
                          }
                      }
                  });
    }

    function searchHistory(){
        showHistory(nowTag);
    }

    function setSearchDate(type) {
        var BeginDate = new Date();
        var EndDate = new Date();
        switch (type) {
            case 0:
                //本日

                break;
            case 1:
                //前日
                BeginDate.setDate(BeginDate.getDate() - 1);
                EndDate.setDate(EndDate.getDate() - 1);                
                break;
            case 2:
                BeginDate.setDate(BeginDate.getDate() - 7);               
                break;
            default:
        }

        document.getElementById("searchStartDate").valueAsDate = new Date(Date.UTC(BeginDate.getFullYear(), BeginDate.getMonth(), BeginDate.getDate()));
        document.getElementById("searchEndDate").valueAsDate = new Date(Date.UTC(EndDate.getFullYear(), EndDate.getMonth(), EndDate.getDate()));
        searchHistory();
    }

    function init() {
        lang = window.top.API_GetLang();
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            GWebInfo = window.parent.API_GetWebInfo();
            p = window.parent.API_GetGWebHubAPI();
            nowTag = 'Deposit';


            if (p != null) {
                setSearchDate(0);
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
    <div id="templateGroup" style="display: none">
        <div id="templateRowTitle">
            <div class="rowTitle"><span class="rowDate">2020/01/26</span></div>
        </div>
        <div id="templateDepositRow">
            <!-- 狀態樣式 成功"rowStatusSucc" 失敗"rowStatusFail" 處理中"rowStatusCheck" 取消/不可用"rowStatusGray" -->
            <div class="rowElm2L">
                <div class="clearfix">
                    <div class="row3XL1A"><span class="CreateTime language_replace">下午04:33</span></div>
                    <div class="row3XL1B"><span class="ChannelCode">支付寶</span></div>
                </div>
                <div class="row3XL1C"><span class="CurrencyType">CNY</span><span class="Amount">1,000,000</span></div>
                <div class="row3XL2A"><span class="language_replace">交易序號</span>:<span class="PaymentSerial">XD20200430125813AC</span></div>
                <div class="row3XL2B"><span class="language_replace">匯款銀行</span>:<span class="BankName">上海浦東發展銀行</span></div>
                <div class="row3XL2C"><span class="language_replace">匯款人</span>:<span class="AccountName">司徒浩南</span></div>
                <div class="Status"><span class="PaymentFlowType language_replace">處理中</span></div>
            </div>
            <!-- -->
        </div>
        <div id="templateWithdrawRow">
            <!-- 狀態樣式 成功"rowStatusSucc" 失敗"rowStatusFail" 處理中"rowStatusCheck" 取消/不可用"rowStatusGray" -->
            <div class="rowElm2L">
                <div class="clearfix">
                    <div class="row3XL1A"><span class="CreateTime">下午04:33</span></div>
                    <div class="row3XL1B"><span class="ChannelCode language_replace">支付寶</span></div>
                </div>               
                <div class="row3XL1C"><span class="CurrencyType">CNY</span><span class="Amount">1,000,000</span></div>
                <div class="row3XL2A"><span class="language_replace">交易序號</span>:<span class="PaymentSerial">XD20200430125813AC</span></div>
                <div class="row3XL2B"><span class="language_replace">匯款銀行</span>:<span class="BankName">上海浦東發展銀行</span></div>
                <div class="row3XL2C"><span class="language_replace">匯款人</span>:<span class="AccountName">司徒浩南</span></div>
                <div class="Status"><span class="PaymentFlowType language_replace">處理中</span></div>
            </div>
            <!-- -->
        </div>
        <div id="templateGameOrderRow">
            <!-- 狀態樣式 客上贏錢"win" 客下輸錢"lose" -->
            <div class="rowElm2L">
                <div class="row3XL1A"><span class="GameName">99Play</span></div>
                <div class="row3XL1B"><span class="WebTagName language_replace">真人百家樂</span></div>
                <div class="Status row3XL1C win"><span class="CurrencyType">CNY</span><span class="RewardValue">6,523</span></div>
                <div class="row3XL2A"><span class="language_replace">下注金額</span>:<span class="OrderValue">12,300</span></div>
                <div class="row3XL2B"><span class="language_replace">有效投注</span>:<span class="ValidBetValue">7,300</span></div>
                <div class="row3XL2C"><span></span></div>
            </div>
            <!-- -->
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
                    <!-- 使用中頁籤加上"active"-->
                    <div onclick="switchTagBtn('Deposit')" class="switchTagBtn active"><span class="language_replace">存款紀錄</span></div>
                    <div onclick="switchTagBtn('Withdraw')" class="switchTagBtn"><span class="language_replace">取款紀錄</span></div>
                    <%--<div style="display:none" class="switchTagBtn"><span>活動紀錄</span></div>--%>
                    <div onclick="switchTagBtn('GameOrder')" class="switchTagBtn"><span class="language_replace">遊戲紀錄</span></div>
                </div>
                <!-- 搜尋列 -->
                <div class="pageDataBar">
                    <form>
                        <div class="pageStartData">
                            <span class="language_replace">起始日期</span>
                            <input id="searchStartDate" type="date">
                        </div>
                        <div class="pageEndData">
                            <span class="language_replace">結束日期</span>
                            <input id="searchEndDate" type="date">
                        </div>
                    </form>
                    <div class="pageDSreachBtn" onclick="searchHistory()">
                        <span class="language_replace">搜尋</span>
                    </div>
                    <div class="pageDDataSwitchBar">
                        <form>
                            <label class="">
                                <input checked type="radio" name="DData" onclick="setSearchDate(0)">
                                <div class="pageDDataBtn"><span class="language_replace">本日</span></div>
                            </label>
                            <label class="">
                                <input type="radio" name="DData" onclick="setSearchDate(1)">
                                <div class="pageDDataBtn"><span class="language_replace">前日</span></div>
                            </label>
                            <label class="">
                                <input type="radio" name="DData" onclick="setSearchDate(2)">
                                <div class="pageDDataBtn"><span class="language_replace">本週</span></div>
                            </label>
                        </form>
                    </div>
                </div>
                <!-- 存款紀錄 -->
                <div id="MainDeposit" class="pageMainCon">
                    <!---->
                    <div class="rowOne">

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
                <!-- 取款紀錄 -->
                <div id="MainWithdraw" class="pageMainCon" style="display: none;">
                    <!---->
                    <div class="rowOne">

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
                <!-- 活動紀錄 -->
                <%--<div class="pageMainCon">
                    <!---->
                    <div class="rowOne">
                        <!-- -->
                        <div class="rowTitle"><span>2020/01/26</span></div>
                        <!-- -->
                        <!-- 狀態樣式 成功"rowStatusSucc" 失敗"rowStatusFail" 審核中"rowStatusCheck" 取消/不可用"rowStatusGray" -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span>下午04:33</span></div>
                            <div class="row3XL1B"><span>活動返點</span></div>
                            <div class="row3XL1C"><span>CNY</span><span>500</span></div>
                            <div class="row3XL2A">真人百家30%返水活動</span></div>
                            <div class="row3XL2B"><span>提款倍率</span>:<span>0.5</span></div>
                            <div class="row3XL2C"><span>領取期限</span>:<span>2020/01/16</span></div>
                            <div class="rowStatusCheck"><span>審核中</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span>下午04:33</span></div>
                            <div class="row3XL1B"><span>儲值贈點</span></div>
                            <div class="row3XL1C"><span>CNY</span><span>500</span></div>
                            <div class="row3XL2A">真人百家30%返水活動</span></div>
                            <div class="row3XL2B"><span>提款倍率</span>:<span>5</span></div>
                            <div class="row3XL2C"><span>領取期限</span>:<span>2020/01/16</span></div>
                            <div class="rowStatusBtn"><span>領取</span></div>
                        </div>
                        <!-- -->
                        <div class="rowTitle"><span>2020/01/26</span></div>
                        <!-- -->
                        <!-- 狀態樣式 成功"rowStatusSucc" 失敗"rowStatusFail" 審核中"rowStatusCheck" 取消/不可用"rowStatusGray" -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span>下午04:33</span></div>
                            <div class="row3XL1B"><span>活動返點</span></div>
                            <div class="row3XL1C"><span>CNY</span><span>500</span></div>
                            <div class="row3XL2A">真人百家30%返水活動</span></div>
                            <div class="row3XL2B"><span>提款倍率</span>:<span>0.5</span></div>
                            <div class="row3XL2C"><span>領取期限</span>:<span>2020/01/16</span></div>
                            <div class="rowStatusSucc"><span>已領取</span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span>下午04:33</span></div>
                            <div class="row3XL1B"><span>儲值贈點</span></div>
                            <div class="row3XL1C"><span>CNY</span><span>500</span></div>
                            <div class="row3XL2A">真人百家30%返水活動</span></div>
                            <div class="row3XL2B"><span>提款倍率</span>:<span>5</span></div>
                            <div class="row3XL2C"><span>領取期限</span>:<span>2020/01/16</span></div>
                            <div class="rowStatusGray"><span>已過期</span></div>
                        </div>
                        <!-- -->



                    </div>
                    <div class="pageFooter">
                        <div class="rowTitle"><span>注意事項</span></div>
                        <div class="rowList">
                            <ol>
                                <li>每次提款最少點數為1000點以上，請務必確認填寫之帳號，若提供的帳號錯誤，恕本公司無法負責。</li>
                                <li>提款時需達到存款總金額的100%有效投注量才可提出申請。(PS:如利用本平臺進行任何洗錢詐騙行為，本公司保留權利審核會員帳戶或停權終止會員服務)</li>
                            </ol>
                        </div>
                    </div>
                </div>--%>
                <!---->
                <!-- 遊戲紀錄 -->
                <div id="MainGameOrder" class="pageMainCon" style="display: none;">
                    <!-- -->
                    <div class="infoBar">
                        <div class="infoDiv"><span class="language_replace">期間總下注金額</span>:<span  id="TotalOrderValue">0</span></div>
                        <div class="infoDiv"><span class="language_replace">期間總有效投注</span>:<span  id="TotalValiBet">0</span></div>
                        <div class="infoDiv"><span class="language_replace">期間總派彩</span>:<span  id="TotalRewardValue">0</span></div>
                    </div>
                    <!---->
                    <div class="rowOne">
                        <!-- -->
                        <div class="rowTitle"><span>2020/01/26</span></div>
                        <!-- -->
                        <!-- 狀態樣式 客上贏錢"win" 客下輸錢"lose" -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span >99Play</span></div>
                            <div class="row3XL1B"><span class="language_replace">真人百家樂</span></div>
                            <div class="row3XL1C win"><span>CNY</span><span>6,523</span></div>
                            <div class="row3XL2A"><span class="language_replace">下注金額</span>:<span>12,300</span></div>
                            <div class="row3XL2B"><span class="language_replace">有效投注</span>:<span>7,300</span></div>
                            <div class="row3XL2C"><span></span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span class="language_replace">99電子</span></div>
                            <div class="row3XL1B"><span class="language_replace">電子娛樂</span></div>
                            <div class="row3XL1C lose"><span>CNY</span><span>-1,458</span></div>
                            <div class="row3XL2A language_replace"><span class="language_replace">下注金額</span>:<span>5,800</span></div>
                            <div class="row3XL2B language_replace"><span class="language_replace">有效投注</span>:<span>5,800</span></div>
                            <div class="row3XL2C"><span></span></div>
                        </div>
                        <!-- -->
                        <div class="rowTitle"><span>2020/01/25</span></div>
                        <!-- -->
                        <!-- 狀態樣式 客上贏錢"win" 客下輸錢"lose" -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span>99Play</span></div>
                            <div class="row3XL1B"><span class="language_replace">真人百家樂</span></div>
                            <div class="row3XL1C win"><span>CNY</span><span>6,523</span></div>
                            <div class="row3XL2A"><span class="language_replace">下注金額</span>:<span>12,300</span></div>
                            <div class="row3XL2B"><span class="language_replace">有效投注</span>:<span>7,300</span></div>
                            <div class="row3XL2C"><span></span></div>
                        </div>
                        <!-- -->
                        <div class="rowElm2L">
                            <div class="row3XL1A"><span class="language_replace">99電子</span></div>
                            <div class="row3XL1B"><span class="language_replace">電子娛樂</span></div>
                            <div class="row3XL1C lose"><span>CNY</span><span>-1,458</span></div>
                            <div class="row3XL2A"><span class="language_replace">下注金額</span>:<span>5,800</span></div>
                            <div class="row3XL2B"><span class="language_replace">有效投注</span>:<span>5,800</span></div>
                            <div class="row3XL2C"><span></span></div>
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
