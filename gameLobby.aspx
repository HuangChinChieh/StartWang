<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
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
    <link href="css/gamelobby.css" rel="stylesheet" type="text/css">
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
    var webTagList;
    var nowWebTag = "fav";

    function getWebTag() {
        p.GetWebTag(Math.uuid(), function (success, o) {
            if (success) {
                var idTags = document.getElementById("idTags");

                //init
                while (idTags.children.length > 1) {
                    idTags.removeChild(idTags.lastChild);
                }


                if (o != null) {
                    if (o.WebTagList != null) {
                        var firstTagDom;
                        webTagList = o.WebTagList;
                        
                        for (var i = 0; i < webTagList.length; i++) {
                            var wt = webTagList[i];
                            //<a class="a_click"><i class="icon-tab-rb"></i><span class="tagName">真人</span></a>
                            var tag = c.getTemplate("templateTag");

                            c.setClassText(tag, "tagName", null, mlp.getLanguageKey(wt.WebTagName));
                            switch (wt.WebTagName) {
                                case "真人":
                                    tag.getElementsByClassName("iconTag")[0].classList.add("icon-tab-rb");
                                    break;
                                case "棋牌":
                                    tag.getElementsByClassName("iconTag")[0].classList.add("icon-tab-cg");
                                    break;
                                case "體育":
                                    tag.getElementsByClassName("iconTag")[0].classList.add("icon-tab-sp");
                                    break;
                                case "電子":
                                    tag.getElementsByClassName("iconTag")[0].classList.add("icon-tab-eg");
                                    break;
                                case "彩票":
                                    tag.getElementsByClassName("iconTag")[0].classList.add("icon-tab-lt");
                                    break;     
                                default:
                                    tag.classList.add("icon-tab-rb");
                                    break;
                            }


                            tag.dataset.tagid = wt.WebTagID;
                            idTags.appendChild(tag);

                            if (i == 0) {
                                firstTagDom = tag;
                                nowWebTag = o.WebTagList[0].WebTagID;
                            }
                        }


                        if (o.WebTagList.length > 0) {
                            //含切換左方tag
                            switchWebTag(firstTagDom);
                        } else {
                            //只切換右方內容
                            setGameLobbySection(nowWebTag);
                        }                      
                    }
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
                getWebTag();
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
                var webTagID = tag.dataset.tagid;
                gametags[i].classList.add("cur");
                setGameLobbySection(webTagID);
            } else {
                gametags[i].classList.remove("cur");
            }
        }
    }

    function setGameLobbySection(webTagID) {
        nowWebTag = webTagID;
        var sectionDom = c.getTemplate("templateSection");
        //我的最愛
        var favoriteGames = getFavoriteGames();

        if (webTagID == "fav") {           
            c.setClassText(sectionDom, "title", null,mlp.getLanguageKey("我的最愛"));
            for (var i = 0; i < favoriteGames.length; i++) {
                var gameCode = favoriteGames[i];
                var tagItemData = null;
                var tagItemDom;

                for (var ii = 0; ii < webTagList.length; ii++) {
                    if (tagItemData) {
                        break;
                    }
                    var wt = webTagList[ii];
                    tagItemData = wt.TagItem.find(function (tagItem) {
                        return tagItem.GameCode == gameCode
                    });
                }

                if (tagItemData) {
                    tagItemDom = c.getTemplate("templateFigure");
                    var openGameDom = tagItemDom.getElementsByClassName("openGame")[0];
                    var favoriteDom = tagItemDom.getElementsByClassName("addFavorite")[0];

                    tagItemDom.classList.add("gameFigure");
                    c.setClassText(tagItemDom, "gameName", null, tagItemData.GameName);
                    tagItemDom.getElementsByClassName("pcLogo")[0].src = tagItemData.ImagePCUrl;
                    tagItemDom.getElementsByClassName("mobileLogo")[0].src = tagItemData.ImageMobileUrl;

                    //設定開啟遊戲
                    openGameDom.dataset.gamecode = tagItemData.GameCode;
                    openGameDom.dataset.gamelobbyexist = tagItemData.GameLobbyExist;
                    openGameDom.dataset.wallettype = tagItemData.WalletType;
                    openGameDom.onclick = function () {
                        var gameCode = event.currentTarget.dataset.gamecode;
                        var GameLobbyExist = event.currentTarget.dataset.gamelobbyexist;
                        var WalletType = event.currentTarget.dataset.wallettype;
                        entryGame(gameCode, GameLobbyExist, WalletType);
                    };

                    //設定我的最愛相關樣式
                    favoriteDom.dataset.gamecode = tagItemData.GameCode;
                    favoriteDom.classList.add("IsFav");
                    favoriteDom.getElementsByClassName("icon-fa-heart-o")[0].classList.add("icon-fa-heart");
                    favoriteDom.onclick = favBtnEvent;

                    sectionDom.getElementsByClassName("gameList")[0].appendChild(tagItemDom);
                }

            }
        } else {
            //webTag項目
            for (var i = 0; i < webTagList.length; i++) {
                var wt = webTagList[i];
                if (webTagID == wt.WebTagID) {
                    c.setClassText(sectionDom, "title", null, mlp.getLanguageKey(wt.WebTagName));
                    for (var ii = 0; ii < wt.TagItem.length; ii++) {
                        var tagItemData = wt.TagItem[ii];
                        var tagItemDom;
                        if (tagItemData) {
                            tagItemDom = c.getTemplate("templateFigure");
                            tagItemDom.classList.add("gameFigure");
                            var openGameDom = tagItemDom.getElementsByClassName("openGame")[0];
                            var favoriteDom = tagItemDom.getElementsByClassName("addFavorite")[0];
                            c.setClassText(tagItemDom, "gameName", null, tagItemData.GameName);
                            tagItemDom.getElementsByClassName("pcLogo")[0].src = tagItemData.ImagePCUrl;
                            tagItemDom.getElementsByClassName("mobileLogo")[0].src = tagItemData.ImageMobileUrl;

                            
                            //設定開啟遊戲
                            //設定開啟遊戲
                            openGameDom.dataset.gamecode = tagItemData.GameCode;
                            openGameDom.dataset.gamelobbyexist = tagItemData.GameLobbyExist;
                            openGameDom.dataset.wallettype = tagItemData.WalletType;
                            openGameDom.onclick = function () {
                                var gameCode = event.currentTarget.dataset.gamecode;
                                var GameLobbyExist = event.currentTarget.dataset.gamelobbyexist;
                                var WalletType = event.currentTarget.dataset.wallettype;
                                entryGame(gameCode, GameLobbyExist, WalletType);
                            };

                            //設定我的最愛相關樣式
                            favoriteDom.dataset.gamecode = tagItemData.GameCode;
                            favoriteDom.onclick = favBtnEvent;
                            
                            if (favoriteGames.includes(tagItemData.GameCode)) {
                                favoriteDom.classList.add("IsFav");
                                favoriteDom.getElementsByClassName("icon-fa-heart-o")[0].classList.add("icon-fa-heart");
                            }

                            sectionDom.getElementsByClassName("gameList")[0].appendChild(tagItemDom);
                        }

                    }
                }
            }

        }
        document.getElementById("gameSection").innerHTML = "";
        document.getElementById("gameSection").appendChild(sectionDom);
        document.getElementById("searchGame").value = "";
    }

    function favBtnEvent () {
        var target = event.currentTarget;
        var gameCode = target.dataset.gamecode;
        var type = target.classList.contains("IsFav") ? 1 : 0;
        var heartDom = target.getElementsByClassName("icon-fa-heart-o")[0];
        if (type == 0) {
            target.classList.add("IsFav");
            heartDom.classList.add("icon-fa-heart");

            window.top.API_ShowMessage(mlp.getLanguageKey("我的最愛"),mlp.getLanguageKey("是否新增至我的最愛"), function () {
                setFavoriteGame(gameCode, type);
                setGameLobbySection(nowWebTag);                                        
            }, null);
        } else {
            target.classList.remove("IsFav");
            heartDom.classList.remove("icon-fa-heart")

            window.top.API_ShowMessage(mlp.getLanguageKey("我的最愛"), mlp.getLanguageKey("是否從我的最愛移除"), function () {
                setFavoriteGame(gameCode, type);
                setGameLobbySection(nowWebTag);
            }, null);
        }                                                                   
    };
     
    function setFavoriteGame(gameCode, type) {
        var favoriteGames = getFavoriteGames();

        if (type == 0) {
            //add
            favoriteGames.splice(0, 0, gameCode);
            window.localStorage.setItem("FavoriteGames", JSON.stringify(favoriteGames));
        } else {
            //remove
            var index = favoriteGames.indexOf(gameCode);
            if (index > -1) {
                favoriteGames.splice(index, 1);
            }

            window.localStorage.setItem("FavoriteGames", JSON.stringify(favoriteGames));
        }
    }

    function getFavoriteGames() {
        var favoriteGamesStr = window.localStorage.getItem("FavoriteGames");
        var favoriteGames;

        if (favoriteGamesStr) {
            favoriteGames = JSON.parse(favoriteGamesStr);
        } else {
            favoriteGames = [];
        }

        return favoriteGames;
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

    function entryGame(GameCode, GameLobbyExist, WalletType) {
        if (GWebInfo.UserLogined) {
            window.top.API_OpenGame(GameCode, GameLobbyExist, WalletType);
        } else {
            window.top.API_ShowMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"));
        }
    }

    function GWebEventNotify(eventName, isDisplay, o) {
        if (isDisplay) {
            if (eventName == "SetLanguage") {
                lang = o;
                mlp.loadLanguage(lang, function () {
                    getWebTag();
                });
            }
        }
    }


    window.onload = init;
</script>
<body>
    <div class="gamePage">
        <div id="templateGroup" style="display: none">
            <div id="templateTag">
                <a onclick="switchWebTag()" class="a_click tags"><i class="iconTag"></i><span class="tagName"></span></a>
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
                        <div class="addFavorite"><span class="icon-fa-heart-o"></span></div>
                    </a>
                </figure>
            </div>
        </div>
        <div class="gamePageBox">
            <aside class="gameTabs" id="idTags">
                <!-- 當前頁籤 要在<A> 加上class="cur" -->
                <a data-tagid="fav" onclick="switchWebTag()" class="cur tags"><i class="icon-tab-fav"></i><span class="language_replace">最愛</span></a>
                <%--                <a><i class="icon-tab-rb"></i><span>真人</span></a>
                <a><i class="icon-tab-cg"></i><span>棋牌</span></a>
                <a><i class="icon-tab-sp"></i><span>體育</span></a>
                <a><i class="icon-tab-eg"></i><span>電子</span></a>--%>
            </aside>

            <main class="gamePanel">
                <div class="gamePanel-inner">
                    <div class="gameSearchBox">
                        <div class="inner-box">
                            <i class="fa fa-search"></i>
                            <input onchange="searchGame()" id="searchGame" type="text" language_replace="placeholder" placeholder="搜尋">
                        </div>
                    </div>
                    <div id="gameSection">
                    </div>
                </div>
            </main>
        </div>
    </div>
    <!--- tabs 切換 --->
</body>
</html>
