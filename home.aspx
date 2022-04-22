﻿<%@ Page Language="C#" %>

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
    <%--    <link href="css/gameLobbyMedia.css" rel="stylesheet" />--%>

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
        .lob_gameTypeIcon img {
            height: 25px;
            width: auto;
        }

        input[type="radio"] + label .lob_gameTypeIcon,
        .lob_gameTypeBtn .lob_gameTypeIcon {
            opacity: 0.3;
            /*background: rgba(35,37,49,1.0);*/
            background: #000;
            border-radius: 50px;
            padding: 5px 6px;
            position: relative;
            margin-top: 0px;
            z-index: 3;
            transition: all linear 0.2s;
        }

    </style>

    <style>
        .comdPopUp_hidden {
            position: fixed;
            width: 100%;
            height: 0%;
            top: 0px;
            left: 0px;
            overflow: hidden;
            background: none;
            opacity: 0.0;
            -o-transition: all .15s;
            -moz-transition: all .15s;
            -webkit-transition: all .15s;
            -ms-transition: all .15s;
            transition: all .15s;
        }

        .comdPopUp_show {
            height: 100%;
            display: block;
            background: rgba(30,30,30,0.8);
            opacity: 1.0;
            pointer-events: auto;
            z-index: 9999999;
        }

        .gameComdHidden {
            display: none;
        }

        .gameComdShow {
            display: block;
        }

        .popUp_input_div {
            /*width:90%;*/
            height: 300px;
            margin: uto;
            color: #aaa;
            text-align: center;
        }

            .popUp_input_div input {
                margin: 30px auto;
                margin-top: 65px;
                border-color: #999;
                line-height: 60px;
                height: 60px;
                font-size: 2em;
            }

        .lob_gameListWrapper {
            position: relative;
            box-sizing: border-box;
            height: calc(100vh - 110px);
            /*margin-top: -60px;*/
            width: calc(100% - 200px);
            left: 100px;
        }

        .lob_gameListBrand {
            box-sizing: border-box;
            position: absolute;
            top: 0;
            left: 0px;
            right: 0px;
            width: 100%;
            padding: 15px 30px;
            height: 52px;
            line-height: 40px;
            font-size: 20px;
            color: var(--main-color);
            padding-bottom: 10px;
            background: linear-gradient(180deg,rgba(55,59,78,1),rgba(55,59,78,0.8));
            -webkit-backdrop-filter: blur(10px);
            backdrop-filter: blur(10px);
            box-shadow: 0px 5px 15px 2px rgba(55,59,78,1);
        }

        .lob_gameListMain {
            box-sizing: border-box;
            height: calc(100vh - 300px);
            padding: 30px 30px 30px 30px;
            overflow: auto;
            overflow-x: hidden;
            overflow-y: auto;
            top: 100px;
            position: relative
        }

        .lob_gameListDiv {
            position: relative;
            /*float: left;*/
            display: inline-block;
            box-sizing: content-box;
            margin-bottom: 40px;
        }

        .lob_gameListBtn {
        }

        .lob_gameListImg {
            margin: 0 auto;
            height: 200px;
            text-align: center;
            width:200px;
        }

            .lob_gameListImg img {
                width: 85%;
                margin: 0 auto;
                height: auto;
            }

        .myFavorBtn {
            right: 10%;
        }

        .myFavorBtn {
            position: absolute;
            bottom: 36px;
            background: rgba(255,255,255,0.3);
            width: 29px;
            height: 29px;
            border-radius: 29px;
            z-index: 2;
            transition: all 0.10s ease-out;
            cursor: pointer;
        }

            .myFavorBtn::after {
                content: "";
                position: absolute;
                top: 10px;
                left: 5px;
                width: 15px;
                height: 9px;
                background: #aaa;
                border-radius: 12px 0px 0px 12px;
                transform: rotate(45deg);
                transition: all 0.10s ease-out;
            }

            .myFavorBtn::before {
                content: "";
                position: absolute;
                top: 10px;
                left: 9px;
                width: 15px;
                height: 9px;
                background: #aaa;
                border-radius: 0px 12px 12px 0px;
                transform: rotate(-45deg);
                transition: all 0.10s ease-out;
            }

            .myFavorBtn:hover {
                background: rgba(255,255,255,0.7);
            }

                .myFavorBtn:hover::after {
                    content: "";
                    position: absolute;
                    background: var(--main-color);
                    border-radius: 12px 0px 0px 12px;
                    transform: rotate(45deg);
                }

                .myFavorBtn:hover::before {
                    content: "";
                    position: absolute;
                    background: var(--main-color);
                    border-radius: 0px 12px 12px 0px;
                    transform: rotate(-45deg);
                }

        .myFavor .myFavorBtn {
            background: var(--main-color);
        }

            .myFavor .myFavorBtn::after {
                background: #fff;
            }

            .myFavor .myFavorBtn::before {
                background: #fff;
                ;
            }

            .myFavor .myFavorBtn:hover {
                background: var(--main-color);
                box-shadow: inset 0px 0px 0px 2px rgba(255,255,255,0.3);
            }

        .lob_gameListName {
            text-align: center;
            color: #fff;
            font-size: 14px;
        }

        .lob_gameListBackBtn {
        }

        .lob_gameListBackBtn {
            position: relative;
            width: auto;
            height: 40px;
            margin-right: 0px;
            background: rgba(0,0,0,0.15);
            padding-left: 10px;
            border-radius: 50px 0px 0px 50px;
            display: -wibkit-flex;
            display: -moz-flex;
            display: flex;
            -wibkit-align-items: center;
            -moz-align-items: center;
            align-items: center;
            color: aliceblue;
            cursor: pointer;
        }

            .lob_gameListBackBtn:hover {
                background: rgba(0,0,0,0.3);
            }

            .lob_gameListBackBtn img {
                width: 30px;
                height: 30px;
                opacity: 0.5;
            }

            .lob_gameListBackBtn:hover img {
                opacity: 1;
            }

        .lob_gamesListHeader2 {
            position: absolute;
            right: 10px;
            font-size: 12px;
            display: inline-flex;
            align-items: flex-start;
            justify-content: center;
            line-height: 20px;
        }

        .displayType_switch_Btn_G {
            white-space: nowrap;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 8px 13px;
            background: rgba(255,255,255,0.2);
            margin: 10px 3px 3px 3px;
            border-radius: 20px;
            cursor: pointer;
            color: rgba(0,0,0,0.5);
            -webkit-backdrop-filter: blur(20px);
            backdrop-filter: blur(20px);
        }

            .displayType_switch_Btn_G:hover {
                background: rgba(255,255,255,0.5);
                box-shadow: 0px 3px 13px 0px rgba(0,0,0,0.05);
            }

            .displayType_switch_Btn_G.Active {
                background: var(--main-color);
                color: #fff;
                box-shadow: 0px 3px 5px 0px rgba(0,0,0,0.1);
            }

        .lob_gameListTit {
            display: inline-block;
            background: linear-gradient(90deg,rgba(0,0,0,0.15),rgba(0,0,0,0));
            padding: 0px 60px 0px 10px;
            margin-top: 10px;
            text-align: left;
        }

        .lob_gameLobbyMain {
            display: -wibkit-flex;
            display: -moz-flex;
            display: flex;
            -wibkit-align-items: center;
            -moz-align-items: center;
            align-items: center;
            -wibkit-justify-content: space-around;
            -moz-justify-content: space-around;
            justify-content: space-around;
            margin-top: 8px;
            min-height: 320px;
            max-height: calc(100vh - 168px);
            width: auto;
            max-width: 100vw;
            overflow: auto;
            -webkit-overflow-scrolling: touch;
        }

        .lob_gameBrandWrapper {
            -webkit-overflow-scrolling: touch;
            width: auto;
            max-width: 900px;
        }

        .lob_gameBrandWrapper {
        }
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
        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            WebInfo = window.parent.API_GetWebInfo();
            WebInfo.GameCodeList = GameCodeList.GameCodeList
            initMyFavor();
            initGameCode(WebInfo);
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

        updateGameCateg(LobbyGameList.CategoryList);
        updateGameBrand(LobbyGameList.GameBrandList);
    }
    //建立分類
    function updateGameCateg(o) {
        var idTags = document.getElementById("idTags");

        var idCategList = document.getElementById("id_GameCategoryList");
        o.forEach(e => {
            let tempCateg = c.getTemplate("templateCategoryItem");
            let BIcon

            let Categ = e.Categ;

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
    function updateGameBrand(o) {
        var idGameBrandList = document.getElementById("gameSection");
        var sectionDom = c.getTemplate("templateSection");
        let tempGB = c.getTemplate("templateFigure");
        let BIcon;
        let BImg;
        let BrandCode;
        let BrandCateg;

        c.setClassText(sectionDom, "title", null, mlp.getLanguageKey("全部"));
        sectionDom.getElementsByClassName("gameList")[0].setAttribute("id", "id_GameBrandList");

        //#region Ewin
        tempGB = c.getTemplate("templateFigure");
        BrandCode = "Ewin";
        BrandCateg = "Baccarat";
        tempGB.setAttribute("data-Categ", BrandCateg);
        tempGB.classList.add("gameFigure");
        c.setClassText(tempGB, "gameName", null, "<span class='language_replace'>" + BrandCode + "</span> " + "<span class='language_replace'>" + BrandCateg + "</span>");

        BIcon = c.getFirstClassElement(tempGB, "mobileLogo");
        if (BIcon != null) {
            BIcon.src = "images/lobby/logo/demo_logoPC2.png";
        }
        BImg = c.getFirstClassElement(tempGB, "pcLogo");
        if (BImg != null) {
            BImg.src = "images/lobby/logo/demo_mainImg.png";
        }

        tempGB.onclick = new Function("showGameList('" + BrandCode + "', '" + BrandCateg + "','', true)");

        sectionDom.getElementsByClassName("gameList")[0].appendChild(tempGB);
        //#endregion

        o.forEach(e => {

            e.BrandCateg.forEach(eb => {
                tempGB = c.getTemplate("templateFigure");
                BrandCode = e.BrandCode;
                BrandCateg = eb;
                tempGB.setAttribute("data-Categ", BrandCateg);
                tempGB.classList.add("gameFigure");
                c.setClassText(tempGB, "gameName", null, "<span class='language_replace'>" + BrandCode + "</span> " + "<span class='language_replace'>" + BrandCateg + "</span>");

                BIcon = c.getFirstClassElement(tempGB, "mobileLogo");
                if (BIcon != null) {
                    BIcon.src = WebInfo.EWinUrl + "/Lobby/images/lobby/logo/" + BrandCode + "/logoPC_" + BrandCateg + ".png";
                }
                BImg = c.getFirstClassElement(tempGB, "pcLogo");
                if (BImg != null) {
                    BImg.src = WebInfo.EWinUrl + "/Lobby/images/lobby/logo/" + BrandCode + "/mainImg_" + BrandCateg + ".png";
                }

                tempGB.onclick = new Function("showGameList('" + BrandCode + "', '" + BrandCateg + "','', true)");

                sectionDom.getElementsByClassName("gameList")[0].appendChild(tempGB);
            })
        })

        idGameBrandList.appendChild(sectionDom);
        mlp.loadLanguage(lang);

    }
    //切換分類
    function changeGameCateg(e, Categ) {
        var idBrandPage = document.getElementById("id_GameBrandList");
        switchWebTag();

        nowCateg = Categ;

        $("#gameSection .title").text(Categ);
        //chgGameBtn(null, nowGameType);

        if (Categ == 'All') {
            for (let i = 0; i < idBrandPage.children.length; i++) {
                var el = idBrandPage.children[i];
                el.style = "";
            }

            updateGameCategSub(LobbyGameList.CategorySubList, '');
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

            updateGameCategSub(LobbyGameList.CategorySubList, '');
        }
    }
    //根據分類顯示遊戲
    function updateGameCategSub(o, brandCode) {
        var idCategSubList2 = document.getElementById("id_GameSubBtnList2");

        idCategSubList2.innerHTML = "";

        o.forEach(e => {
            var setFirstIcon = true;

            if (e.Categ == nowCateg) {
                if (e.Brand == brandCode) {
                    var tempCategSub = c.getTemplate("TemplateGameCategorySubBtn2");
                    tempCategSub.setAttribute("data-Categ", e.Categ);
                    c.setClassText(tempCategSub, "lob_categorySubName", null, mlp.getLanguageKey("All"));
                    c.getFirstClassElement(tempCategSub, "lob_categorySubName").setAttribute("langkey", "All");

                    idCategSubList2.appendChild(tempCategSub);
                    tempCategSub.classList.add("Active");
                    tempCategSub.onclick = new Function("showGameList('" + brandCode + "', '" + nowCateg + "','', false)");

                    //排序
                    e.CategSubList.sort(function (a, b) {
                        var A = a;
                        var B = b;

                        if (A.length > B.length) {
                            return -1;
                        }
                        if (A.length < B.length) {
                            return 1;
                        }

                        return 0;
                    });
                    e.CategSubList.forEach(eSub => {
                        if (eSub != "") {
                            var tempCategSub = c.getTemplate("TemplateGameCategorySubBtn2");
                            tempCategSub.setAttribute("data-Categ", e.Categ);

                            c.setClassText(tempCategSub, "lob_categorySubName", null, mlp.getLanguageKey(eSub));
                            c.getFirstClassElement(tempCategSub, "lob_categorySubName").setAttribute("langkey", eSub)

                            tempCategSub.onclick = new Function("changeGameCategSubByBrand(this, '" + brandCode + "', '" + nowCateg + "','" + eSub + "')");
                            idCategSubList2.appendChild(tempCategSub);
                        }

                    });
                }

            }
        })
    }
    //顯示遊戲列表(彈出)
    function showGameList(brandCode, brandCateg, brandCategSub, singleGameDirectShow) {
        var divGamePage = document.getElementById("divGamePage");
        var btnGameListClose = document.getElementById("btnGameListClose");

        directShow = singleGameDirectShow;

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
                for (let i = 0; i < LobbyGameList.GameList.length; i++) {
                    if (LobbyGameList.GameList[i].GameBrand == brandCode) {

                        for (let j = 0; j < LobbyGameList.GameList[i].GameBrandList.length; j++) {
                            if (LobbyGameList.GameList[i].GameBrandList[j].GameCateg == brandCateg) {
                                updateGameCode(LobbyGameList.GameList[i].GameBrandList[j].List, brandCateg, brandCode, brandCategSub);
                                break;
                            }
                        }

                        if (brandCategSub == "") {
                            nowCateg = brandCateg;
                            updateGameCategSub(LobbyGameList.CategorySubBrandList, brandCode);
                        }

                        //}
                    }
                }

                divGamePage.classList.add("comdPopUp_show");

                btnGameListClose.onclick = function () {
                    divGamePage.classList.remove("comdPopUp_show");
                }
            }
        }
    }
    //將廠商所有遊戲加入彈出的遊戲列表
    function updateGameCode(o, categoryCode, gameBrand, categoryCodeSub) {
        var idGamePage = document.getElementById("idGamePage");
        var idGameItemTitle = document.getElementById("idGameItemTitle");
        var idGameIcon = document.getElementById("idGameIcon");
        var idGameItemList = document.getElementById("idGameItemList");
        var removeList = [];
        var insertCount = 0;

        //let GameList = WebInfo.GameCodeList.GameList;

        c.setElementText("idGameItemTitle", null, mlp.getLanguageKey(gameBrand) + "/" + mlp.getLanguageKey(categoryCode));

        // 尋找刪除
        idGameItemList.innerHTML = "";

        // 尋找新增
        if (o != null) {
            for (var i = 0; i < o.length; i++) {
                var gcObj = o[i];
                var GI = c.getTemplate("templateGameItem");
                var GIcon;
                var canInsert = false;
                var myFavorIcon;

                if (categoryCodeSub == "") {
                    canInsert = true;


                }
                else {
                    if (o[i].GameCategSub == categoryCodeSub) {
                        canInsert = true;
                    }
                }

                if (canInsert == true) {
                    insertCount++;
                    GI.setAttribute("GameCode", gameBrand + '.' + gcObj.GameName);
                    GI.classList.add(gameBrand + '.' + gcObj.GameName);
                    c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + gcObj.GameCode + "</span>");

                    GIcon = c.getFirstClassElement(GI, "idGameIcon");
                    if (GIcon != null) {
                        GIcon.src = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameBrand + "/PC/" + WebInfo.Lang + "/" + gcObj.GameName + ".png";
                    }

                    if (gcObj.AllowDemoPlay == 0) {
                        //不允許

                    }
                    else {

                    }
                    c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + gameBrand + "', '" + gcObj.GameName + "', false)");

                    myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                    myFavorIcon.onclick = new Function("setMyFavor('" + gameBrand + "', '" + gcObj.GameName + "'," + gcObj.AllowDemoPlay + ")");

                    idGameItemList.appendChild(GI);

                }
            }

            //只有一個遊戲，直接開
            //if (insertCount == 1) {
            //    if (directShow == true) {
            //        c.getFirstClassElement(GI, "lob_gameListBtn").click();
            //    }
            //}

            mlp.loadLanguage(WebInfo.Lang);
            initMyFavor();
        }
    }
    //將廠商所有遊戲加入彈出的遊戲列表
    function updateFavGameCode() {
        var idGameItemList = document.getElementById("idGameItemList");
        c.setElementText("idGameItemTitle", null, "我的最愛");

        // 尋找刪除
        idGameItemList.innerHTML = "";

        // 尋找新增
        if (GameMyFavorArr != null) {
            for (var i = 0; i < GameMyFavorArr.length; i++) {
                var gcObj = GameMyFavorArr[i];
                var GI = c.getTemplate("templateGameItem");
                var GIcon;
                var canInsert = false;
                var myFavorIcon;
                
                GI.setAttribute("GameCode", gcObj.gameBrand + '.' + gcObj.gameName);
                GI.classList.add(gcObj.gameBrand + '.' + gcObj.gameName);
                c.setClassText(GI, "idGameName", null, "<span class='language_replace'>" + gcObj.gameBrand + '.' + gcObj.gameName + "</span>");

                GIcon = c.getFirstClassElement(GI, "idGameIcon");
                if (GIcon != null) {
                    GIcon.src = gcObj.imgSrc;
                }

                if (gcObj.AllowDemoPlay == 0) {
                    //不允許

                }
                else {

                }
                c.getFirstClassElement(GI, "lob_gameListBtn").onclick = new Function("API_OpenGameCode('" + gcObj.gameBrand + "', '" + gcObj.gameName + "', false)");

                myFavorIcon = c.getFirstClassElement(GI, "myFavorBtn");
                myFavorIcon.onclick = new Function("setMyFavor('" + gcObj.gameBrand + "', '" + gcObj.gameName + "'," + gcObj.AllowDemoPlay + ")");

                idGameItemList.appendChild(GI);
            }
            

            mlp.loadLanguage(WebInfo.Lang);
            initMyFavor();
        }
    }
    //遊戲缺圖時使用
    function showDefaultGameIcon(el) {
        el.onerror = null;
        el.src = "/Files/GamePlatformPic/default.png";
    }
    //彈出視窗右上分類
    function changeGameCategSubByBrand(e, brandCode, brandCateg, brandCategSub) {
        var lob_gamesListBtn2 = document.getElementsByClassName("lob_gamesListBtn2");

        for (var i = 0; i < lob_gamesListBtn2.length; i++) {
            lob_gamesListBtn2[i].classList.remove("Active");
        }
        e.classList.add("Active");

        showGameList(brandCode, brandCateg, brandCategSub, false)
    }

    function API_OpenGameCode(gameBrand, gameName, isDemo) {
        var iGameHistoryInfo = new GameHistoryInfo();
        var gameExist = false;
        var historyIndex = 0;
        var DemoPlay = 0

        if (isDemo == true) {
            DemoPlay = 1;
        }

        if (!WebInfo.UserLogined) {
            parent.top.showMessageOK(mlp.getLanguageKey("錯誤"), mlp.getLanguageKey("請先登入"), function () {
                parent.top.API_Home();
            });
        } else {

            if (gameBrand == 'EWin') {

                window.open(WebInfo.EWinUrl + "/Game/Login.aspx?SID=" + WebInfo.SID + "&Lang=" + WebInfo.Lang + "&CT=" + encodeURIComponent(WebInfo.CT))
            }
            else
                window.open(WebInfo.EWinUrl + "/API/GamePlatformAPI/" + gameBrand + "/UserLogin.aspx?SID=" + WebInfo.SID + "&Language=" + WebInfo.Lang + "&CurrencyType=" + window.parent.selectedCurrency + "&GameName=" + gameName + "&DemoPlay=" + DemoPlay, "_blank");
        }

        history
        for (var i = 0; i < GameHistoryArr.length; i++) {
            if (GameHistoryArr[i].gameBrand == gameBrand) {
                if (GameHistoryArr[i].gameName == gameName) {
                    gameExist = true;
                    historyIndex = i;
                    break;
                }
            }
        }

        if (gameExist == false) {
            if (GameHistoryArr.length >= 5) {
                GameHistoryArr.splice(0, 1);
            }

            iGameHistoryInfo.gameName = gameName;
            iGameHistoryInfo.gameBrand = gameBrand;
            iGameHistoryInfo.imgSrc = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameBrand + "/PC/" + WebInfo.Lang + "/" + gameName + ".png";
            iGameHistoryInfo.AllowDemoPlay = DemoPlay;
            GameHistoryArr.push(iGameHistoryInfo);

        }
        else {
            GameHistoryArr.push(GameHistoryArr[historyIndex]);
            GameHistoryArr.splice(historyIndex, 1);
        }

        //setGameHistory();
    }

    function setMyFavor(gameBrand, gameName, AllowDemoPlay) {
        var iGameHistoryInfo = new GameHistoryInfo();
        var gameExist = false;

        for (var i = 0; i < GameMyFavorArr.length; i++) {
            if (GameMyFavorArr[i].gameName == gameName) {
                if (GameMyFavorArr[i].gameBrand == gameBrand) {
                    gameExist = true;
                    GameMyFavorArr.splice(i, 1);
                    break;
                }
            }
        }

        if (gameExist == false) {
            iGameHistoryInfo.gameName = gameName;
            iGameHistoryInfo.gameBrand = gameBrand;
            iGameHistoryInfo.imgSrc = WebInfo.EWinUrl + "/Files/GamePlatformPic/" + gameBrand + "/PC/" + WebInfo.Lang + "/" + gameName + ".png";
            iGameHistoryInfo.AllowDemoPlay = AllowDemoPlay;
            GameMyFavorArr.push(iGameHistoryInfo);
        }

        window.localStorage.setItem("gameMyFavor", JSON.stringify(GameMyFavorArr));
        initMyFavor();
    }

    function initMyFavor() {
        var lob_gameListDiv = document.getElementsByClassName("lob_gameListDiv");

        for (var i = 0; i < lob_gameListDiv.length; i++) {
            lob_gameListDiv[i].classList.remove("myFavor");
        }

        if (window.localStorage.getItem("gameMyFavor") != null && window.localStorage.getItem("gameMyFavor") != "") {
            GameMyFavorArr = JSON.parse(window.localStorage.getItem("gameMyFavor"));

            for (var i = 0; i < GameMyFavorArr.length; i++) {
                lob_gameListDiv = document.getElementsByClassName(GameMyFavorArr[i].gameBrand + "." + GameMyFavorArr[i].gameName);

                for (j = 0; j < lob_gameListDiv.length; j++) {
                    lob_gameListDiv[j].classList.add("myFavor");
                }
            }
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
                    <div class="addFavorite"><span class="icon-fa-heart-o"></span></div>
                </a>
            </figure>
        </div>
        <div id="TemplateGameCategorySubBtn2">
            <div class="displayType_switch_Btn_G lob_gamesListBtn2">
                <div class="displayType_switch_Btn_icon"></div>
                <span class="language_replace lob_categorySubName">--</span>
            </div>
        </div>
        <div id="TemplateGameCategorySubGameItem" style="display: none">
            <div class="lob_gameListDiv">
                <div class="lob_gameListBtn">
                    <div class="lob_gameListImg">
                        <img class="idGameIcon" src="images/slot/slot01.png">
                    </div>
                    <div class="lob_gameListName"><span class="idGameName">GameName</span></div>
                </div>
                <div class="myFavorBtn"></div>
            </div>
        </div>
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
                        <img onclick="OpenBonusDepositShow()" src="images/banner/OpenBonusDeposit-20220331.jpg" />
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
                        <div id="a1" class="ann"><a href="#">99PLAY <i>HTML5 Beta版</i>上線!!</a></div>
                        <div id="a2" class="ann"><a href="#">恭喜!玩家user01，獲得<i>彩金$99,000</i></a></div>
                        <div id="a3" class="ann"><a href="#">聖誕活動!儲就送!<i>最高8,888點!</i></a></div>
                        <div id="a4" class="ann"><a href="#">恭喜!玩家user88，獲得<i>彩金$989,000</i></a></div>
                    </div>
                </div>
                <div class="marquee_form_right"><a href="#"><i class="icon icon-icon-news"></i><span class="language_replace">最新消息</span></a></div>
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
                <!-- 遊戲子分類選單 -->
                <div class="lob_gamesListHeader2" id="id_GameSubBtnList2">
                </div>
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
            <div class="lob_gameBrandDiv BrandShow" style="cursor: pointer" gamebrandcode="EwinBaccarat" data-categ="Baccarat" onclick="API_OpenGameCode('EWin','')">
                <div class="lob_gameBrandPanel" data-tilt>
                    <!-- 主視覺圖片 -->
                    <div class="lob_gameBrandImg mainImgBg">
                        <img src="images/lobby/logo/demo_mainImg.png">
                    </div>
                    <!-- LOGO圖片 -->
                    <div class="lob_gameBrandImg_M mainImgLogo">
                        <img src="images/lobby/logo/demo_logoPC2.png">
                    </div>
                    <!-- 品牌名 -->
                    <div class="lob_gameBrandName"><span class="language_replace span_gameBrandName" id="DefaultCompanyCode"><%=EWinWeb.CompanyCode%></span>&nbsp;<span class="language_replace span_gameBrandName" id="DefaultGameBrand">VIP Club</span></div>
                    <div class="lob_gameBrandStart">
                        <span class="language_replace">Start</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 遊戲按鈕 -->
        <div id="templateGameBrandItem" style="display: none">
            <div class="lob_gameBrandDiv BrandShow">
                <div class="lob_gameBrandPanel" data-tilt>
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
