<%@ Page Language="C#" %>

<%
    string Page = Request["Page"];
    string Token = string.Empty;

    Token = Request["Token"];
    if (string.IsNullOrEmpty(Token))
    {
        if (string.IsNullOrEmpty(Page) == false)
            Response.Redirect("Init.aspx?Page=" + Server.UrlEncode(Page));
        else
            Response.Redirect("Init.aspx");
    }
%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="Description" content="關於我們" />
    <meta name="keywords" content="關於我們 99Play" />
    <title>About Us</title>

    <!-- CSS -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:400italic,400" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:700,400" />
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="assets/elegant-font/code/elegant-font.css" />
    <link rel="stylesheet" href="assets/css/animate.css" />
    <link rel="stylesheet" href="assets/css/magnific-popup.css" />
    <link rel="stylesheet" href="assets/flexslider/flexslider.css" />
    <link rel="stylesheet" href="assets/css/form-elements.css" />
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/media-queries.css" />
    <link rel="shortcut icon" href="assets/img/logo_99play.png" />
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/logo_99play_144.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/logo_99play_114.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/logo_99play_72.png" />
    <link rel="apple-touch-icon-precomposed" href="assets/img/logo_99play.png" />
</head>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/jquery.signalR-2.3.0.min.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/GWebHubAPI.js"></script>
<script type="text/javascript">
    var Token = "<%=Token%>";
    var GWebUrl = "<%=Web.GWebURL %>";
    var pHubClient;
    var sid;

    function funcFreePlay() {
        var p = API_GetGWebHubAPI();

        if (p != null) {
            p.UserTryItLogin(Math.uuid(), function (success, o) {
                if (success) {
                    if (o.ResultCode == 0) {
                        var expires = new Date('31 Dec 2038 00:00:00 PDT').toUTCString();

                        document.cookie = "DeviceGUID=" + o.DeviceGUID + ";" + expires + ";path=/";
                        document.cookie = "RecoverToken=" + o.RecoverToken + ";" + expires + ";path=/";

                        sid = o.SID;

                        var gameWindow = window.open("OpenGame.aspx?Type=0&Token=" + Token + "&GameCode=99Play&CurrencyType=CNY&SID=" + sid + "&Lang=CHS&GameLobbyExist=0&WalletType=1");

                    } else {
                        swal(mlp.getLanguageKey("目前試玩次數已額滿，請稍後在試"));
                    }
                } else {
                    if (o == "Timeout") {
                        swal(mlp.getLanguageKey("網路異常, 請重新嘗試"));
                    } else {
                        swal(mlp.getLanguageKey("錯誤") + o);
                    }
                }
            });
        } else {
            swal(mlp.getLanguageKey("網路異常, 請重新嘗試"));
            window.top.location.href = "About99Demo.aspx";
        }
    }

    function API_GetGWebHubAPI(newInst) {
        var retValue;

        if (newInst == true) {
            retValue = new GWebHubAPI(GWebUrl, Token);
        } else {
            retValue = pHubClient;
        }

        return retValue;
    }

    function init() {
        pHubClient = new GWebHubAPI(GWebUrl, Token);

        // 設定 SignalR 事件
        // handleReceiveMsg: 收到伺服器傳回訊息
        // handleConnected: 連線完成
        // handleReconnected: 重新連線完成
        // handleReconnecting: 重新連線中
        // handleDisconnect: 斷線
        pHubClient.handleReceiveMsg(function (o) {
        });

        pHubClient.handleConnected(function () {
        });

        pHubClient.handleReconnected(function () {
        });

        pHubClient.handleReconnecting(function () {
        });

        pHubClient.handleDisconnect(function () {
        });

        pHubClient.handleStateChange(function (newState, oldState) {
        });

        pHubClient.initializeConnection();

        pHubClient.SetToken(Token);
    }

    window.onload = init;

</script>
<body data-spy="scroll" data-target=".navbar-fixed-top">
    <div class="wrapper">
        <nav class="navbar navbar-fixed-top">
            <div class="container">
                <div class="languageMobileLogin text-right">
                    <button type="button" data-toggle="tooltip" class="language_replace" data-placement="bottom" title="简体中文" onclick="changeLanguage('CHS');">
                        <img src="assets/img/ico_china.png" alt="简体中文" />
                    </button>
                    <button type="button" data-toggle="tooltip" class="language_replace" data-placement="bottom" title="正體中文" onclick="changeLanguage('CHT');">
                        <img src="assets/img/ico_hongkong.png" alt="正體中文" />
                    </button>
                    <button type="button" data-toggle="tooltip" class="language_replace" data-placement="bottom" title="한국어" onclick="changeLanguage('KOR');">
                        <img src="../images/ic_korea.png" alt="한국어" />
                    </button>
                    <button type="button" data-toggle="tooltip" class="language_replace" data-placement="bottom" title="English" onclick="changeLanguage('ENG');">
                        <img src="../images/ic_uk.png" alt="English" />
                    </button>
                    <button type="button" data-toggle="tooltip" class="language_replace" data-placement="bottom" title="日本語" onclick="changeLanguage('JPN');">
                        <img src="../images/ic_japan.png" alt="日本語" />
                    </button>
                </div>
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#defaultNavbar1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a href="#">
                        <img src="assets/img/logo_99play.svg" class="navbarLogo" alt="logo99play"></a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="defaultNavbar1">
                    <ul class="nav navbar-nav navbar-right">
                        <li class="page-scroll"><a href="#page-top"><i class="icon_house" aria-hidden="true"></i></a></li>
                        <li class="page-scroll"><a href="#freeplay"><span class="language_replace">產品展示</span></a></li>
                        <li class="page-scroll"><a href="#real"><span class="language_replace">賭城真人</span></a></li>
                        <li class="page-scroll"><a href="#onlyone"><span class="language_replace">業界唯一</span></a></li>
                        <li class="page-scroll"><a href="#service"><span class="language_replace">創新服務</span></a></li>
                        <li class="page-scroll"><a href="#vip"><span class="language_replace">尊榮體驗</span></a></li>
                        <!--<li class="page-scroll"><a href="#contactus"><span class="language_replace"></span>聯絡我們</a></li>-->
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Slider -->
        <div class="slider-container">
            <div class="slider">
                <div class="flexslider">
                    <ul class="slides">
                        <li>
                            <div class="slides-img">
                                <img src="assets/img/slider_okada.jpg">
                            </div>
                            <div class="flex-caption">
                                <div class="container">
                                    <div class="row">
                                        <div>
                                            <h2><span class="language_replace">Okada Manila</span></h2>
                                            <h6><i><span class="language_replace">Pasay, Metro Manila, Philippines</span></i></h6>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>
                            <div class="slides-img">
                                <img src="assets/img/slider_cod.jpg">
                            </div>
                            <div class="flex-caption">
                                <div class="container">
                                    <div class="row">
                                        <div>
                                            <h2><span class="language_replace">City of Dreams Manila</span></h2>
                                            <h6><i><span class="language_replace">Pasay, Metro Manila, Philippines</span></i></h6>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>
                            <div class="slides-img">
                                <img src="assets/img/slider_venus.jpg">
                            </div>
                            <div class="flex-caption">
                                <div class="container">
                                    <div class="row">
                                        <div>
                                            <h2><span class="language_replace">金星娛樂城</span></h2>
                                            <h6><i><span class="language_replace">Bavet, Krong Bavet, Cambodia</span></i></h6>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>
                            <div class="slides-img">
                                <img src="assets/img/slider_xh.png">
                            </div>
                            <div class="flex-caption">
                                <div class="container">
                                    <div class="row">
                                        <div>
                                            <h2><span class="language_replace">西湖國際渡假村</span></h2>
                                            <h6><i><span class="language_replace">Preah Sihanouk Province, Cambodia</span></i></h6>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- Slider END -->
        <!-- freeplay -->
        <section id="freeplay">
            <div class="container-fluid">
                <h1 class="text-center"><span class="language_replace">產品展示</span></h1>
            </div>
            <div class="container">
                <img src="assets/img/ico_html5.png" alt="iconhtml5" class="html5">
                <img src="assets/img/platform.png" alt="allplatform" class="allplatform">
                <div class="row">
                    <div class="col-md-12 wow fadeInDown">
                        <button class="testPlay" onclick="funcFreePlay();">
                            <span class="language_replace">立即試玩</span>
                        </button>
                        <br>
                        <h5 id="lbMuliLanguageContent1"><span class="language_replace">全新HTML5技術打造</span><br>
                            <span class="language_replace">免下載!跨平台即開即玩!</span></h5>
                    </div>
                </div>
            </div>
        </section>
        <!-- freeplay end -->
        <!-- real -->
        <section id="real">
            <div class="container">
                <h1 class="text-center"><span class="language_replace">賭城真人</span></h1>
                <div class="row">
                    <div class="col-md-12 col-lg-6 wow fadeInUp">
                        <div class="realPeople">
                            <h3 id="lbMuliLanguageContent2"><span class="language_replace">99PLAY真人視訊平台</span></h3>
                            <span id="lbMuliLanguageContent3"><span class="language_replace">目前越來越多世界各地的玩家開始要求公平公正合法的網路真人視訊博弈，所以我們努力佈局連線於亞洲，與各個擁有</span><em><span class="language_replace">合法執照的大型綜合渡假村賭場貴賓廳，</span></em><span class="language_replace">開發真人百家樂、龍虎等視訊產品，提供</span><em><span class="language_replace">平台API技術接入</span></em><span class="language_replace">、支持一站式解決服務。</span></span>
                        </div>
                    </div>
                    <div class="col-sm-12 col-lg-6 wow fadeInDown">
                        <div class="phoneDemoBox"></div>
                    </div>
                </div>
            </div>
        </section>
        <!-- real end -->
        <!-- onlyone -->
        <section id="onlyone">
            <div class="container-fluid">
                <h1 class="text-center"><span class="language_replace">業界唯一</span></h1>
            </div>
            <div class="container">
                <h3><span class="language_replace">業界網投唯一與亞洲真實賭場連線</span></h3>
                <div class="row text-center wow fadeInUp">
                    <div class="col-sm-4">
                        <div class="img-circle imgOkada">
                            <img class="" src="assets/img/206_okada.jpg" />
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="img-circle imgCod">
                            <img class="" src="assets/img/206_cod.jpg" />
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="img-circle imgVenus">
                            <img class="" src="assets/img/206_venus.jpg" />
                        </div>
                    </div>
                </div>
                <div class="row text-center wow fadeInDown">
                    <div class="col-sm-3"></div>
                    <div class="col-sm-6">
                        <span id="lbMuliLanguageContent4"><span class="language_replace">真人視訊來源全來自菲律賓馬尼拉以及柬埔寨最</span><em><span class="language_replace">大型的綜合渡假村的賭場貴賓廳、公廳</span></em><span class="language_replace">，而非攝影棚，強調合法、公平、公正，讓玩家在世界任何角落，都能享受置身於豪華賭場的真實體驗。</span></span>
                    </div>
                </div>
            </div>
        </section>
        <!-- onlyone end -->
        <!-- service -->
        <section id="service">
            <div class="container-fluid">
                <h1 class="text-center"><span class="language_replace">創新服務</span></h1>
            </div>
            <div class="container">
                <h3><span class="language_replace">提供最穩定視訊技術，</span><br>
                    <span class="language_replace">創新服務及金流解決方案</span></h3>
                <div class="row">
                    <div class="col-sm-12 col-md-6 wow fadeInUp">
                        <img src="assets/img/strongpoint.png" alt="">
                    </div>
                    <div class="col-sm-12 col-md-6 wow fadeInDown">
                        <p style="font-size: 16px;" id="lbMuliLanguageContent5">
                            －<span class="language_replace">我們重視業界不斷反饋的需求，致力穩定的視訊技術，尤其在玩家本身訊號不良的狀況下，</span><span class="language_replace" style="color: #FF9600; font-weight: 700; font-style: normal;">視訊來源也不會被切斷。</span><br>
                            <br>
                            －<span class="language_replace">同時平台也支持</span><span class="language_replace" style="color: #FF9600; font-weight: 700; font-style: normal;">隨時切換多國貨幣進行投注，</span><span class="language_replace">不只提供營運商更多元的金流操作規劃，也提供玩家的錢包在同一個平台上可以做最彈性的運用。</span>
                        </p>
                    </div>
                </div>
            </div>
        </section>
        <!-- service end -->
        <!-- vip -->
        <section id="vip">
            <div class="container-fluid">
                <h1 class="text-center"><span class="language_replace">尊榮體驗</span></h1>
            </div>
            <div class="container">
                <h3><span class="language_replace">不用飛到貴賓廳，</span><br>
                    <span class="language_replace">連線99PLAY你就是貴賓</span></h3>
                <div style="width: 85%; margin: 0 auto;">
                    <span class="wow fadeInUp" id="lbMuliLanguageContent6">
                        <span class="language_replace">99PLAY平台的誕生，無論是</span><em><span class="language_replace">真人百家樂、真人龍虎、以及電子產品</span></em><span class="language_replace">，在網路與實地賭場的結合下，都能輕鬆快速上線投注，任何人都有機會與全亞洲賭場貴賓VIP玩家一同享樂博弈，</span><em><span class="language_replace">享受親臨賭場的頂級服務。</span></em>
                    </span>
                </div>
                <div class="row wow fadeInDown">
                    <img src="assets/img/vip.jpg" alt="vip" style="padding-top: 12px;">
                </div>
            </div>
        </section>
        <!-- vip end -->
        <!-- contact us -->
        <section id="contactus">
            <div class="container-fluid">
                <h1 class="text-center"><span class="language_replace">聯絡我們</span></h1>
            </div>
            <div class="container">
                <div class="row">
                    <div class="col-sm-4 text-center wow fadeInUp">
                        <img class="img_contactus" src="assets/img/contactus3.jpg" />
                        <h4 class="language_replace">99PLAY GAMING</h4>
                        <div class="contact-box-text">
                            <!--<p><span aria-hidden="true" class="icon_phone"></span> <span class="language_replace">電話</span> : <a href="tel:+886-2-9999-9999">+886-2-9999-9999</a></p>-->
                            <p><span aria-hidden="true" class="icon_mail"></span><span id="spEmailIconTitle" class="language_replace">信箱</span> : <a href="mailto:service@99play.com">service@99play.com</a></p>
                        </div>
                        <br>
                    </div>
                    <div class="col-sm-8 text-center wow fadeInDown">
                        <div class="contact_com">
                            <div class="contact_com_tit">
                                <h6 id="lbMuliLanguageContent7"><span class="language_replace">若您所屬的企業公司，希望能在業務上跟99PLAY進行多面向的合作，共創雙贏局面，請您留下合作內容以及聯繫方式，我們將有專人盡快與您聯繫。</span></h6>
                            </div>
                            <table width="100%" border="0">
                                <tbody>
                                    <tr>
                                        <td id="tbReportingItems"><span class="language_replace">回報項目</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <input type="radio" name="contact-type" language_replace="placeholder" placeholder="合作提案" class="squaredFour" id="contact_Checkbox2">
                                                <label for="contact_Checkbox2" id="lbCooperationProposals"><span class="language_replace">合作提案</span></label>
                                                <input type="radio" name="contact-type" language_replace="placeholder" placeholder="熱心建議" class="squaredFour" id="contact_Checkbox1">
                                                <label for="contact_Checkbox1" id="lbSuggestions"><span class="language_replace">熱心建議</span></label>
                                            </form>
                                        </td>
                                    </tr>
                                    <tr id="tr_coname">
                                        <td id="tbCompanyName"><span class="language_replace">公司名稱</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <label class="sr-only" for="contact-coname"><span class="language_replace">請輸入公司名稱</span></label>
                                                <input type="text" name="coname" language_replace="placeholder" placeholder="請輸入完整公司名稱(最多30字元)" class=" form-control" id="contact-coname" maxlength="30">
                                            </form>
                                        </td>
                                    </tr>
                                    <tr id="tr_depart">
                                        <td id="tbDepartmentPosition"><span class="language_replace">部門職稱</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <label class="sr-only" for="contact-depart"><span class="language_replace">請填寫部門、職稱</span></label>
                                                <input type="text" name="depart" language_replace="placeholder" placeholder="請填寫部門職稱(最多20字元)" class="form-control" id="contact-depart" maxlength="20">
                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tbName"><span class="language_replace">姓名</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <label class="sr-only" for="contact-mainname"><span class="language_replace">請填寫聯絡人姓名</span></label>
                                                <input type="text" name="mainname" language_replace="placeholder" placeholder="請填寫聯絡人姓名(最多20字元)" class="form-control" id="contact-mainname" maxlength="20">
                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tbEmail"><span class="language_replace">電子信箱</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <label class="sr-only" for="contact-mail">example@mail.com</label>
                                                <input type="text" name="contact-mail" language_replace="placeholder" placeholder="example@mail.com" class="form-control" id="contact-mail" maxlength="50">
                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tbContactTel"><span class="language_replace">連絡電話</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <label class="sr-only" for="contact-no"><span class="language_replace">請留下聯絡方式，海外請加國碼</span></label>
                                                <input type="text" name="contact-no" language_replace="placeholder" placeholder="請留下聯絡方式，海外請加國碼(最多30字元)" class="form-control" id="contact-no" maxlength="30">
                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="tbContentDescription"><span class="language_replace">內容說明</span> :</td>
                                        <td>
                                            <form action="" method="post">
                                                <label class="sr-only" for="contact-com"><span class="language_replace">煩請您留下詳細內容</span></label>
                                                <textarea name="contact-com" language_replace="placeholder" placeholder="煩請您留下詳細內容(最多500字元)" class="form-control" id="contact-com" maxlength="500"></textarea>
                                            </form>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <br>
                            <form method="" action="">
                                <button id="btnMail" type="button" class="btn btn-sm"><span class="language_replace">確認送出</span></button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- contact end -->
        <!--<div class="sitemap">
			<div class="container">
				<div class="row">
					<span class="sitemap_link">
						<a href="#">
							<span class="fa fa-home fa-fw" aria-hidden="true"></span>
						</a>
					</span>
					<span class="sitemap_link"><a href="#">99Play</a></span>
					<span class="sitemap_link"><a href="#">隱私權管理規章</a></span>
					<span class="sitemap_link"><a href="#">顧客服務</a></span>
				</div>
			</div>
		</div>-->
        <footer>
            <div class="container">
                <div class="row">
                    <div class="footer-copyright text-center">
                        <span class="footer_copyright">Copyright &copy; 99Play . All rights reserved.</span>
                    </div>
                    <!-- <div class="col-sm-3 footer-social wow fadeIn">
						<a href="#"><span class="social_facebook"></span></a>
						<a href="#"><span class="social_googleplus"></span></a>
						<a href="#"><span class="social_twitter"></span></a>
					</div> -->
                </div>
            </div>
        </footer>
    </div>
</body>
</html>
