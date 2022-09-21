<%@ Page Language="C#" %>

<%
    //string Token = string.Empty;

    //Token = Request["Token"];
    //if (string.IsNullOrEmpty(Token)) {
    //    Response.Redirect("Init.aspx");
    //}
    int RValue;
    Random R = new Random();
    string Token;
    string GameCodeListStr = string.Empty;
    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

    RValue = R.Next(100000, 9999999);
    Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

    dynamic GameCodeList = lobbyAPI.GetCompanyGameCode(Token, Guid.NewGuid().ToString());
    GameCodeListStr = Newtonsoft.Json.JsonConvert.SerializeObject(GameCodeList);
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
    <link href="css/media-main.css" rel="stylesheet" type="text/css">
    <link href="css/swiper.min.css" rel="stylesheet" type="text/css">
    <link href="css/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="css/99playfont/99fonts.css" rel="stylesheet" type="text/css">
    <link href="css/gamelobby.css" rel="stylesheet" type="text/css">
    <link href="css/gameLobbyMedia.css" rel="stylesheet" />

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

    <style>
       
    </style>
</head>
<script type="text/javascript" src="/Scripts/SelectItem.js"></script>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<!-- Swiper JS -->
<script src="/Scripts/swiper.min.js"></script>
<script src="/Scripts/jquery.mkinfinite.js"></script>
<script src="/Scripts/vegas.min.js"></script>
<!-- Background Image Swiper-->
<script>
    $(function () {
        $("body").vegas({
            timer: false,
            animation: 'kenburns',
            overlay: true,
            delay: 8000,
            animationDuration: 80000,
            overlay: 'images/overlay-2.png',
            slides: [
                { src: "images/background/01.png" },
                { src: "images/background/02.png" },
                { src: "images/background/03.png" },
                { src: "images/background/04.png" }
            ]
        });
    });
</script>
<!-- Dropdown NAV MENU-->
<script type="text/javascript">
    var c = new common();
    var WebInfo;
    var p;
    var mlp;
    var lang;
    var webTagList;
    var nowWebTag = "fav";
    var GameCodeList = <%=GameCodeListStr%>;
    var GameHistoryArr = new Array();
    var GameMyFavorArr = new Array();
    var GCB;

    var GameHistoryInfo = function () {
        this.gameBrand = "";
        this.gameName = "";
        this.imgSrc = "";
        this.AllowDemoPlay = 0;
    }

    var LobbyGameList = {
        CategoryList: [{
            Categ: "All",
            CategBrandList: []
        }],
        GameBrandList: [],
        GameList: [],
        CategorySubList: [{
            Categ: "All",
            CategSubList: []
        }],
        CategorySubBrandList: []
    }
   
    function init() {
        lang = window.top.API_GetLang();
        p = window.parent.API_GetLobbyAPI();
        mlp = new multiLanguage();
        GCB = window.parent.API_GetGCB();

        mlp.loadLanguage(lang, function () {
            WebInfo = window.parent.API_GetWebInfo();
            WebInfo.GameCodeList = GameCodeList.GameCodeList;
            initGameCode(WebInfo);
            
        });
    }

    function getFavoGameList(PropertyName,cb) {
        p.GetUserAccountProperty(Math.uuid(), WebInfo.SID, PropertyName, function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (cb) {
                        cb(o.Message,true);
                    }
                }
                else {
                    if (cb) {
                        cb(null, false);
                    }
                }
            } else {
                if (cb) {
                    cb(null,false);
                }
            }
        });
    }

    function setFavoGameList(PropertyName, PropertyValue,cb) {
        p.SetUserAccountProperty(Math.uuid(), WebInfo.SID, PropertyName, PropertyValue ,function (success, o) {
            if (success) {
                if (o.Result == 0) {
                    if (cb) {
                        cb(true);
                    }
                }
                else {
                    if (cb) {
                        cb(false);
                    }
                }
            } else {
                if (cb) {
                    cb(null, false);
                }
            }
        });
    }

    function switchWebTag(tag) {

        if (!tag) {
            tag = event.currentTarget;
        }

        var gametags = document.getElementById("idTags").getElementsByClassName("tags");
        for (var i = 0; i < gametags.length; i++) {
            if (gametags[i] == tag) {
                gametags[i].classList.add("cur");
            } else {
                gametags[i].classList.remove("cur");
            }
        }
    }

    function searchGame() {
        var target = event.currentTarget;
        var searchValue = target.value;
        var gameDoms = document.getElementsByClassName("gameFigure");
        for (var i = 0; i < gameDoms.length; i++) {
            var gd = gameDoms[i];
            var gameName = gd.getElementsByClassName("gameName")[0].innerText;
            if (!searchValue) {
                gd.style.display = "block";
            } else {
                if (gameName && gameName.toUpperCase().includes(searchValue.toUpperCase())) {
                    gd.style.display = "block";
                } else {
                    gd.style.display = "none";
                }
            }
        }
    }

    function OpenBonusDepositShow() {
        window.top.API_LoadPage("Activity/OpenBonusDeposit_03312022/index.html");
    }

    function initGameCode(o) {
        o.GameCodeList.forEach(e => {
            if (LobbyGameList.CategoryList[0].CategBrandList.find(eb => eb == e.BrandCode) == undefined)
                LobbyGameList.CategoryList[0].CategBrandList.push(e.BrandCode);

            if (LobbyGameList.CategoryList.find(eb => eb.Categ == e.GameCategoryCode) == undefined) {
                let data = {
                    Categ: e.GameCategoryCode,
                    CategBrandList: [
                        e.BrandCode
                    ]
                }
                LobbyGameList.CategoryList.push(data);
            }
            else {
                LobbyGameList.CategoryList.forEach(cl => {
                    if (cl.Categ == e.GameCategoryCode) {
                        if (cl.CategBrandList.find(cbl => cbl == e.BrandCode) == undefined)
                            cl.CategBrandList.push(e.BrandCode)
                    }
                })
            }

            if (LobbyGameList.GameBrandList.find(eb => eb.BrandCode == e.BrandCode) == undefined) {
                let Brand = {
                    BrandCode: e.BrandCode,
                    BrandCateg: [e.GameCategoryCode]
                }
                LobbyGameList.GameBrandList.push(Brand);
            }
            else {
                LobbyGameList.GameBrandList.forEach(eb => {
                    if (eb.BrandCode == e.BrandCode) {
                        if (eb.BrandCateg.find(eb => eb == e.GameCategoryCode) == undefined) {
                            eb.BrandCateg.push(e.GameCategoryCode);
                        }
                    }
                })
            }

            if (LobbyGameList.GameList.find(eb => eb.GameBrand == e.BrandCode) == undefined) {
                let GameData = {
                    GameBrand: e.BrandCode,
                    GameBrandList: [{
                        GameCateg: e.GameCategoryCode,
                        List: [{
                            GameName: e.GameName,
                            GameCode: e.GameCode,
                            GameCategSub: e.GameCategorySubCode,
                            Description: e.GameName,
                            IsNew: e.IsNew,
                            IsHot: e.IsHot,
                            AllowDemoPlay: e.AllowDemoPlay
                        }]
                    }
                    ]
                }
                LobbyGameList.GameList.push(GameData);
            }
            else {
                LobbyGameList.GameList.forEach(eg => {

                    if (eg.GameBrand == e.BrandCode) {
                        if (eg.GameBrandList.find(eb => eb.GameCateg == e.GameCategoryCode) == undefined) {
                            let data = {
                                GameCateg: e.GameCategoryCode,
                                List: [{
                                    GameName: e.GameName,
                                    GameCode: e.GameCode,
                                    GameCategSub: e.GameCategorySubCode,
                                    Description: e.GameName,
                                    IsNew: e.IsNew,
                                    IsHot: e.IsHot,
                                    AllowDemoPlay: e.AllowDemoPlay
                                }]
                            }
                            eg.GameBrandList.push(data);
                        }
                        else {
                            eg.GameBrandList.forEach(ebl => {
                                if (ebl.GameCateg == e.GameCategoryCode) {
                                    let data = {
                                        GameName: e.GameName,
                                        GameCode: e.GameCode,
                                        GameCategSub: e.GameCategorySubCode,
                                        Description: e.GameName,
                                        IsNew: e.IsNew,
                                        IsHot: e.IsHot,
                                        AllowDemoPlay: e.AllowDemoPlay
                                    }
                                    ebl.List.push(data);
                                }
                            })
                        }
                    }

                })
            }

            if (LobbyGameList.CategorySubList[0].CategSubList.find(eb => eb == e.GameCategorySubCode) == undefined)
                LobbyGameList.CategorySubList[0].CategSubList.push(e.GameCategorySubCode);

            if (LobbyGameList.CategorySubList.find(eb => eb.Categ == e.GameCategoryCode) == undefined) {
                let data = {
                    Categ: e.GameCategoryCode,
                    CategSubList: [
                        e.GameCategorySubCode
                    ]
                }
                LobbyGameList.CategorySubList.push(data);
            }
            else {
                LobbyGameList.CategorySubList.forEach(cl => {
                    if (cl.Categ == e.GameCategoryCode) {
                        if (cl.CategSubList.find(cbl => cbl == e.GameCategorySubCode) == undefined)
                            cl.CategSubList.push(e.GameCategorySubCode)
                    }
                })
            }

            if (LobbyGameList.CategorySubBrandList.find(eb => eb.Categ == e.GameCategoryCode && eb.Brand == e.BrandCode) == undefined) {
                let data = {
                    Categ: e.GameCategoryCode,
                    Brand: e.BrandCode,
                    CategSubList: [
                        e.GameCategorySubCode
                    ]
                }
                LobbyGameList.CategorySubBrandList.push(data);
            }
            else {
                LobbyGameList.CategorySubBrandList.forEach(cl => {
                    if (cl.Categ == e.GameCategoryCode && cl.Brand == e.BrandCode) {
                        if (cl.CategSubList.find(cbl => cbl == e.GameCategorySubCode) == undefined)
                            cl.CategSubList.push(e.GameCategorySubCode)
                    }
                })
            }
        });

        updateGameCateg(window.parent.CompanyGameCategoryCodes);
        updateGameBrand();
    }
    //建立分類
    function updateGameCateg(o) {
        var idTags = document.getElementById("idTags");
        
        o.forEach(e => {
            let BIcon

            let Categ = e;

            var tag = c.getTemplate("templateTag");

            if (Categ == "All") {
                tag.classList.add("cur");
                c.setClassText(tag, "tagName", null, mlp.getLanguageKey("全部"));
            }
            else {
                c.setClassText(tag, "tagName", null, mlp.getLanguageKey(Categ));
            }

            BIcon = c.getFirstClassElement(tag, "gameTypeIcon");
            if (BIcon != null) {
                BIcon.src = WebInfo.EWinUrl + "/Lobby/images/lobby/icon_gametype_" + Categ + ".svg";
            }

            tag.dataset.tagid = Categ;
            tag.onclick = new Function("changeGameCateg(this,'" + Categ + "')");
            idTags.appendChild(tag);
        })
    }
    //建立遊戲
    function updateGameBrand() {
        var idGameBrandList = document.getElementById("gameSection");
        var sectionDom = c.getTemplate("templateSection");
        let tempGB = c.getTemplate("templateFigure");
        let BIcon;
        let BImg;
        let BrandCode;
        let BrandCateg;

        c.setClassText(sectionDom, "title", null, mlp.getLanguageKey("全部"));
        sectionDom.getElementsByClassName("gameList")[0].setAttribute("id", "id_GameBrandList");

        GCB.GetGameCategoryCode((categoryCodeItem) => {
            tempGB = c.getTemplate("templateFigure");
            BrandCode = categoryCodeItem.GameBrand;
            BrandCateg = categoryCodeItem.GameCategoryCode;
            tempGB.setAttribute("data-Categ", BrandCateg);
            tempGB.classList.add("gameFigure");
            c.setClassText(tempGB, "gameName", null, "<span class='language_replace'>" + mlp.getLanguageKey(BrandCode) + "</span> " + "<span class='language_replace'>" + mlp.getLanguageKey(BrandCateg) + "</span>");

            if (BrandCode == "EWin") {
                BIcon = c.getFirstClassElement(tempGB, "mobileLogo");
                if (BIcon != null) {
                    BIcon.src = "images/lobby/logo/demo_logoPC2.png";
                }
                BImg = c.getFirstClassElement(tempGB, "pcLogo");
                if (BImg != null) {
                    BImg.src = "images/lobby/logo/demo_mainImg.png";
                }
            } else {
                BIcon = c.getFirstClassElement(tempGB, "mobileLogo");
                if (BIcon != null) {
                    BIcon.src = WebInfo.EWinUrl + "/Lobby/images/lobby/logo/" + BrandCode + "/logoPC_" + BrandCateg + ".png";
                }
                BImg = c.getFirstClassElement(tempGB, "pcLogo");
                if (BImg != null) {
                    BImg.src = WebInfo.EWinUrl + "/Lobby/images/lobby/logo/" + BrandCode + "/mainImg_" + BrandCateg + ".png";
                }
            }

            tempGB.onclick = new Function("showGameList('" + BrandCode + "', '" + BrandCateg + "')");

            sectionDom.getElementsByClassName("gameList")[0].appendChild(tempGB);
        }, () => {
            //console.log("done");
        })

        idGameBrandList.appendChild(sectionDom);
        mlp.loadLanguage(lang);

    }
    //切換分類
    function changeGameCateg(e, Categ) {
        var idBrandPage = document.getElementById("id_GameBrandList");
        switchWebTag();

        nowCateg = Categ;

        $("#gameSection .title").text(mlp.getLanguageKey(Categ));
        //chgGameBtn(null, nowGameType);

        if (Categ == 'All') {
            for (let i = 0; i < idBrandPage.children.length; i++) {
                var el = idBrandPage.children[i];
                el.style = "";
            }
        }
        else if (Categ == "myFavor") {
            showGameList("myFavor");
        }
        else {
            for (let i = 0; i < idBrandPage.children.length; i++) {
                var el = idBrandPage.children[i];
                if (el.getAttribute("data-Categ").indexOf(Categ) > -1)
                    el.style = "";
                else
                    el.style = "display:none";
            }
        }
    }
    //顯示遊戲列表(彈出)
    function showGameList(brandCode, brandCateg) {
        var divGamePage = document.getElementById("divGamePage");
        var btnGameListClose = document.getElementById("btnGameListClose");

        if (brandCode == "myFavor") {
            if (divGamePage != null) {
                updateFavGameCode();

                divGamePage.classList.add("comdPopUp_show");

                btnGameListClose.onclick = function () {
                    divGamePage.classList.remove("comdPopUp_show");
                }
            }
        } else {
            c.setElementText("idGameItemTitle", null, mlp.getLanguageKey(brandCode) + "/" + mlp.getLanguageKey(brandCateg));

            if (divGamePage != null) {
                var idGameItemList = document.getElementById("idGameItemList");
                idGameItemList.innerHTML = "";

                GCB.CursorGetByGameBrand(brandCode, (gameItem) => {
                    updateGameCode(gameItem);
                }, () => {
                    //console.log("done");
                })

                divGamePage.classList.add("comdPopUp_show");

                btnGameListClose.onclick = function () {
                    divGamePage.classList.remove("comdPopUp_show");
                }
            }
        }
    }
    //將廠商所有遊戲加入彈出的遊戲列表
    function updateGameCode(gameItem) {
        var gameBrand;
        var gameName;
        var gameCode;
        var gameName_show;
        var isFavo = 0;

        if (gameItem != null) {
            var GI = c.getTemplate("templateGameItem");
            var GIcon;
            var myFavorIcon;

            gameBrand = gameItem.GameBrand;
            gameName = gameItem.GameName;
            gameCode = gameItem.GameCode;
            isFavo = gameItem.IsFavo;
            gameName_show = gameItem.Language.find(x => x.LanguageCode == WebInfo.Lang) ? gameItem.Language.find(x => x.LanguageCode == lang).DisplayText : "";

            GI.setAttribute("GameCode", gameBrand + '.' + gameName);
            GI.classList.add(gameBrand + '.' + gameName);
            c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + gameName_show + "</span>");

            if (isFavo != 0) {
                GI.classList.add("myFavor");
            }

            GIcon = c.getFirstClassElement(GI, "idGameIcon");
            if (GIcon != null) {
                GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameItem.GameBrand + "/PC/" + WebInfo.Lang + "/" + gameName + ".png";
            }
            c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("window.parent.openGame('" + gameBrand + "', '" + gameName + "')");

            myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
            myFavorIcon.onclick = new Function("setMyFavor('" + gameCode + "')");

            idGameItemList.appendChild(GI);

        }
    }
    //將廠商所有遊戲加入彈出的遊戲列表
    function updateFavGameCode() {
        var idGameItemList = document.getElementById("idGameItemList");
        c.setElementText("idGameItemTitle", null, mlp.getLanguageKey("我的最愛"));

        // 尋找刪除
        idGameItemList.innerHTML = "";

        GCB.GetPersonal(0,
            (gameItem) => {
                updateGameCode(gameItem);
            });
    }
    //遊戲缺圖時使用
    function showDefaultGameIcon(el) {
        el.onerror = null;
        el.src = "/Files/GamePlatformPic/default.png";
    }

    function setMyFavor(gameCode) {
        if (WebInfo.UserLogined == true) {

            var btn = event.currentTarget;
            event.stopPropagation();

            if ($(btn).parent().hasClass("myFavor")) {
                $(btn).parent().removeClass("myFavor");
                GCB.RemoveFavo(gameCode, function () {
                    //window.parent.API_RefreshPersonalFavo(gameCode, false);
                });
            } else {
                $(btn).parent().addClass("myFavor");
                GCB.AddFavo(gameCode, function () {
                    //window.parent.API_RefreshPersonalFavo(gameCode, true);
                });
            }

        } else {
            window.parent.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                parent.top.API_Home();
            });
        }

    }

    window.onload = init;
</script>
<script>
    var c = new common();
    var ui = new uiControl();
    var pHubClient;
    var mlp;

</script>
<body>
    <div id="templateGroup" style="display: none">
        <div id="templateTag">
            <%--       <a onclick="switchWebTag()" class="a_click tags">--%>
            <a class="a_click tags">
                <%--  <i class="iconTag"></i>--%>
                <div class="lob_gameTypeIcon">
                    <img class="gameTypeIcon" />
                </div>
                <span class="tagName"></span></a>
        </div>
        <div id="templateSection">
            <section class="cur">
                <h2 class="title"></h2>
                <div class="gameList brand">
                </div>
            </section>
        </div>
        <div id="templateFigure">
            <figure>
                <a href="#">
                    <div class="openGame">
                        <div class="img-box">
                            <div class="kv">
                                <img class="pcLogo" src="images/lobby/realbet/realbet-img01.png" alt="">
                            </div>
                            <div class="logo">
                                <img class="mobileLogo" src="images/lobby/realbet/realbet-logo01.png" alt="">
                            </div>
                        </div>
                    </div>
                    <figcaption class="gameName"></figcaption>

                    <!-- 當user 按下 加人最愛按鈕時 加入class => icon-fa-heart
                             移除最愛時 則 remove class => icon-fa-hear
                        -->
                    <%--<div class="addFavorite"><span class="icon-fa-heart-o"></span></div>--%>
                </a>
            </figure>
        </div>
        <div id="TemplateGameCategorySubBtn2">
            <div class="displayType_switch_Btn_G lob_gamesListBtn2">
                <div class="displayType_switch_Btn_icon"></div>
                <span class="language_replace lob_categorySubName">--</span>
            </div>
        </div>
<%--        <div id="TemplateGameCategorySubGameItem" style="display: none">
            <div class="lob_gameListDiv">
                <div class="lob_gameListBtn">
                    <div class="lob_gameListImg">
                        <img class="idGameIcon" src="images/slot/slot01.png">
                    </div>
                    <div class="lob_gameListName"><span class="idGameName">GameName</span></div>
                </div>
                <div class="myFavorBtn"></div>
            </div>
        </div>--%>
        <div id="TemplateGameCategorySubBtn" style="display: none">
            <div class="lob_gamesListBtn">
                <div class="displayType_switch_Btn_icon2"></div>
                <span class="language_replace lob_categorySubName">--</span>
            </div>
        </div>
    </div>
    <!-- HTML START -->
    <div class="wrapper">
        <!-- Swiper -->
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <div class="swiper-tit"></div>
                    <div class="swiper-zoom-container">
                        <img src="images/banner/OpenBonusDeposit-20220920.jpg" />
                    </div>
                </div>
            </div>
            <!-- Add Pagination -->
            <div class="swiper-pagination"></div>
            <!-- Add Arrows -->
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>
        </div>
        <!-- 最新公告 -->
        <div class="marquee">
            <div class="marquee_form">
                <!--跑碼燈-->
                <div class="marquee_form_left"><a class="icon icon-megaphone"></a></div>
                <div class="navbar-Marquee">
                    <div id="ann_box" class="ann">
                       <%-- <div id="a1" class="ann"><a href="#">99PLAY <i>HTML5 Beta版</i>上線!!</a></div>
                        <div id="a2" class="ann"><a href="#">恭喜!玩家user01，獲得<i>彩金$99,000</i></a></div>
                        <div id="a3" class="ann"><a href="#">聖誕活動!儲就送!<i>最高8,888點!</i></a></div>
                        <div id="a4" class="ann"><a href="#">恭喜!玩家user88，獲得<i>彩金$989,000</i></a></div>--%>
                        <marquee direction="left" height="30" scrollamount="5" behavior="behavior" style="color:white">哥睡的不是覺，睡的是夢想與希望</marquee>
                    </div>
                </div>
               <%-- <div class="marquee_form_right"><a href="#"><i class="icon icon-icon-news"></i><span class="language_replace">最新消息</span></a></div>--%>
            </div>
        </div>
        <!-- 遊戲介紹 -->
        <%--<div class="main-game-list">
            <div id="IFrameGamePage" class="DivContent">
                <iframe id="idFrameContent" scrolling="auto" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
            </div>
        </div>--%>

        <div class="main-game-list">
            <div class="gamePageBox">
                <aside class="gameTabs" id="idTags">
                    <!-- 當前頁籤 要在<A> 加上class="cur" -->
                    <%--<a data-tagid="fav" onclick="switchWebTag()" class="cur tags"><i class="icon-tab-fav"></i><span class="language_replace">最愛</span></a>--%>
                    <div>
                        <a onclick="changeGameCateg(this,'myFavor')" class="a_click tags">
                            <div class="lob_gameTypeIcon">
                                <img class="gameTypeIcon" src="images/lobby/icon_gametype_Favicon.svg" />
                            </div>
                            <span class="tagName language_replace">最愛</span></a>
                    </div>
                </aside>

                <main class="gamePanel">
                    <div class="gamePanel-inner">
                        <%--  <div class="gameSearchBox">
                            <div class="inner-box">
                                <i class="fa fa-search"></i>
                                <input onchange="searchGame()" id="searchGame" type="text" language_replace="placeholder" placeholder="搜尋">
                            </div>
                        </div>--%>
                        <div id="gameSection">
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <!-- 下載頁面 -->
        <%--
        <div class="mobileAPP-con">
            <div class="download-tit">
                <h1 class="language_replace">行動娛樂-APP</h1>
                <hr>
                <div class="download-icon"><span aria-hidden="true" class="fa fa-cloud-download"></span></div>
                <h2 class="language_replace">立即下載</h2>
                <p>
                    <span class="language_replace">安裝簡便，快速暢玩。</span><br>
                    <span class="language_replace">軟體跨平台，讓你不管走到哪就玩到哪。</span>
                </p>
                <br>
                <a>
                    <img src="images/btn_google_play.png" alt="" /></a><br>
                <a>
                    <img src="images/btn_apple_store.png" alt="" /></a>
            </div>
        </div>--%>

        <!-- 網站特點 -->
        <div class="web-spec">
            <div class="container">
                <ul class="web-spec-list">
                    <li class="spec-item spec-01">
                        <div class="spec-item-inner">
                            <div class="content">
                                <h3 class="title">最專業</h3>
                                <p class="desc">為您提供最優質的體育賽事、真人娛樂場、電子遊戲、彩票及無數小遊戲，同時不斷開發更佳的娛樂產品，給您全方位的優良體驗和酣暢淋漓的遊戲享受。</p>
                            </div>
                        </div>

                    </li>
                    <li class="spec-item spec-02">
                        <div class="spec-item-inner">
                            <div class="content">
                                <h3 class="title">最安全</h3>
                                <p class="desc">採用國際知名互聯網安全檢測機嚴格檢測與 128 位加密技術，確保您的數據安全和隱私，保證絕不將您的資料透漏或出售給第三方。</p>
                            </div>
                        </div>

                    </li>
                    <li class="spec-item spec-03">
                        <div class="spec-item-inner">
                            <div class="content">
                                <h3 class="title">最便捷</h3>
                                <p class="desc">引領市場的卓越技術，自主研發了全套終端應用，讓您暢享Web、H5，更有iOS、Android原生App，讓您隨時隨地，娛樂投注隨心所欲！ 7X24小時在線客服提供最貼心最優質的服務。</p>
                            </div>
                        </div>

                    </li>
                    <li class="spec-item spec-04">
                        <div class="spec-item-inner">
                            <div class="content">
                                <h3 class="title">最可靠</h3>
                                <p class="desc">為您承諾提供負責任的博彩和各種安全簡便的存款及提款選擇，最安全的保證並且遵守其製定的行為和準則。</p>
                            </div>
                        </div>

                    </li>
                </ul>

            </div>
           
        </div>

        <!-- FOOTER -->
        <div id="footer">
            <footer class="footer-container">
                    <div class="footer-inner">
                        <div class="container">
                            <%--
                            <ul class="company-info row">
                                <li class="info-item col">
                                    <a id="Footer_About" onclick="showPartialHtml('','About', true, null)"><span class="language_replace">關於我們</span></a>
                                </li>                       
                                <li class="info-item col">
                                    <a id="Footer_ResponsibleGaming" onclick="showPartialHtml('', 'ResponsibleGaming', true, null)">
                                        <span class="language_replace">負責任的賭博</span>
                                    </a>
                                </li>
                                <li class="info-item col">
                                    <a id="Footer_Rules" onclick="showPartialHtml('', 'Rules', true, null)">
                                        <span class="language_replace">利用規約</span>
                                    </a>
                                </li>
                                <li class="info-item col">
                                    <a id="Footer_PrivacyPolicy" onclick="showPartialHtml('', 'PrivacyPolicy', true, null)">
                                        <span class="language_replace">隱私權政策</span>
                                    </a>
                                </li>
                            </ul>
                            --%>
                            <div class="partner">
                                <div class="logo">
                                    <div class="row">
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-eWIN.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-microgaming.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-kgs.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-bbin.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-gmw.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-cq9.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-red-tiger.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-evo.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-bco.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-cg.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-playngo.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-pg.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-netent.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-kx.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-evops.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-bti.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-zeus.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-biggaming.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-play.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-h.png" alt="">
                                            </div>
                                        </div>
                                        <div class="logo-item">
                                            <div class="img-crop">
                                                <img src="/images/logo/footer/logo-va.png" alt="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="footer-copyright">
                                <p class="language_replace">Copyright © 2022 亿万. All Rights Reserved.</p>
                            </div>
                        </div>
                    </div>
            </footer>
           </div>
    </div>
    <!-- wrapper END -->
    

    <!-- HTML END -->

    <!-- -->
    <div class="comdPopUp_hidden" id="divGamePage" hidden="hidden">
        <div class="maskDiv"></div>
        <div class="comdCon lob_gameListWrapper" id="idGamePage">
            <div id="templateGameItem" style="display: none">
                <div class="lob_gameListDiv">
                    <div class="lob_gameListBtn">
                        <div class="lob_gameListImg">
                            <img class="idGameIcon" onerror="showDefaultGameIcon(this)">
                        </div>
                        <div class="lob_gameListName"><span class="idGameName">GameName</span></div>
                    </div>
                    <div class="myFavorBtn"></div>
                </div>
            </div>
            <div class="lob_gameListBrand">
                <div id="btnGameListClose" class="lob_gameListBackBtn">
                    <img src="images/lobby/icon_back.svg">
                </div>
                <div class="lob_gameListTit"><span id="idGameItemTitle">CG老虎機</span></div>
                <!-- 遊戲子分類 -->
            </div>
            <div class="lob_gameListMain" id="idGameItemList">
            </div>
        </div>
    </div>

    <!-- 遊戲列表END -->
    <!-- 遊戲大廳 依品牌 -->
    <div class="lob_gameLobbyMain" id="idgameLobbyMain" style="display: none;">
        <!--height: 0px;overflow: hidden;min-height: 0px;-->
        <!-- 遊戲廠牌內容  -->

        <div id="id_GameBrandList" class="lob_gameBrandWrapper">
            <!-- 遊戲按鈕 -->
         
        </div>

        <!-- 遊戲按鈕 -->
        <div id="templateGameBrandItem" style="display: none">
            <div class="lob_gameBrandDiv BrandShow">
                <div class="lob_gameBrandPanel">
                    <!-- 主視覺圖片 -->
                    <div class="lob_gameBrandImg">
                        <img class="BrandImg" src="images/lobby/logo/demo_mainImg.png">
                    </div>
                    <!-- LOGO圖片 -->
                    <div class="lob_gameBrandImg_M">
                        <img class="BrandIcon" src="images/lobby/logo/demo_logoPC.png">
                    </div>
                    <!-- 品牌名 -->
                    <div class="lob_gameBrandName"><span class="language_replace span_BrandCode">--</span></div>
                    <div class="lob_gameBrandStart">
                        <span class="language_replace">Start</span>
                    </div>
                </div>
            </div>
        </div>
        <!-- 遊戲大廳END -->
    </div>
    <!-- Initialize Swiper -->
    <%--<script src="/Scripts/index_marquee.js"></script>--%>
    <script>
        var swiper = new Swiper('.swiper-container', {
            slidesPerView: 1,
            spaceBetween: 30,
            loop: true,
            autoplay: {
                delay: 8000,
                disableOnInteraction: false,
            },
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
        });
    </script>
</body>
</html>
