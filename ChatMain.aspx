<%@ Page Language="C#" %>

<!doctype html>
<html style="background: none; height: 100%; max-height: 100%; width: 100%;">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimal-ui, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
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
	<link rel="stylesheet" href="../css/m_main.css" />
    <link href="../css/m_chat.css" rel="stylesheet" type="text/css">
    <style>
       
    </style>
</head>
<script type="text/javascript" src="/Scripts/Common.js"></script>
<script type="text/javascript" src="/Scripts/bignumber.min.js"></script>
<script type="text/javascript" src="/Scripts/Math.uuid.js"></script>
<script type="text/javascript" src="/Scripts/MultiLanguage.js"></script>
<script type="text/javascript" src="/Scripts/UIControl.js"></script>
<script type="text/javascript" src="/Scripts/iscroll.js"></script>
<script type="text/javascript" src="Scripts/jquery.min.1.7.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/jquery.signalR-2.3.0.min.js"></script>
<script type="text/javascript" src="<%=Web.GWebURL %>/Scripts/ServiceChat/ServiceChatSID.js"></script>
<script type="text/javascript">
    var c = new common();
    var ui = new uiControl();
    var Token = c.getParameter("Token");
    var SID = c.getParameter("SID");
    var LoginAccount = c.getParameter("Acc");
    var GWebUrl = "<%=Web.GWebURL%>";
    var sc;
    var mlp;
    var lang;
    var RoomID;
    var TopPageIndex;
    var TotalPageCount;
    var lastMsgGUID;
    var getMessage = false;
    var msgContent = [];
    var msgScroll;
    var lastDate = null;
    var idWrapper;
    var needCheckLogin = false;

    function onClickMediaFile() {
        var idSendMedia = document.getElementById("idSendMedia");

        if (idSendMedia != null) {
            if (idSendMedia.files != null) {
                if (idSendMedia.files.length > 0) {
                    var userFile = idSendMedia.files[0];

                    sendMediaFile(userFile);
                }
            }
        }
    }

    function showImageScale(id) {
        var imgScale = document.getElementById("imgScale");
        var idImgScale_Image = document.getElementById("idImgScale_Image");

        idImgScale_Image.src = "<%=Web.GWebURL%>/GetServiceChatMedia.aspx?Id=" + id;
        imgScale.style.display = "block";
    }

    function sendMediaFile(f) {
        var chunkSize = 20000;
        var readIndex = 0;
        var mediaId;
        var sendExceptionCount = 0;

        function readForChunk(chunkIndex, cb) {
            var position = (chunkIndex * chunkSize);
            var fr = new FileReader();

            fr.onload = function () {
                var contentB64 = fr.result;
                var tmpIndex;

                tmpIndex = contentB64.indexOf(",");
                if (tmpIndex != -1) {
                    contentB64 = contentB64.substr(tmpIndex + 1);
                }

                if (cb != null)
                    cb(true, contentB64);
            };

            if (position >= f.size) {
                if (cb != null)
                    cb(false, null);
            } else {
                var endPos = (position + chunkSize);
                var slice;
                var chunkCount;
                var persent;
                var idProgressBar = document.getElementById("idProgressBar");

                if (endPos >= f.size)
                    endPos = (f.size);

                if ((f.size % chunkSize) != 0)
                    chunkCount = (f.size / chunkSize) + 1;
                else
                    chunkCount = (f.size / chunkSize);

                persent = parseInt((chunkIndex / chunkCount) * 100);
                idProgressBar.style.display = "block";
                idProgressBar.style.width = persent + "%";

                slice = f.slice(position, endPos);
                fr.readAsDataURL(slice);
            }
        }

        function readMediaNext(finCb) {
            if (sc.state() == 1) {
                readForChunk(readIndex, function (success, contentB64) {
                    if (success) {
                        sc.SetMediaChunk(SID, mediaId, readIndex, contentB64, function (success2, ret) {
                            var sendSuccess = false;

                            if (success2) {
                                if (ret == true) {
                                    sendSuccess = true;
                                    sendExceptionCount = 0;
                                    readIndex++;
                                    readMediaNext(finCb);
                                }
                            }

                            if (sendSuccess == false) {
                                if (sendExceptionCount < 10) {
                                    sendExceptionCount++;

                                    setTimeout(function () {
                                        readMediaNext(finCb);
                                    }, 500);
                                } else {
                                    if (finCb)
                                        finCb(false);
                                }
                            }
                        });
                    } else {
                        // end read
                        if (finCb)
                            finCb(true);
                    }
                });
            } else {
                if (sendExceptionCount < 10) {
                    sendExceptionCount++;

                    setTimeout(function () {
                        readMediaNext(finCb);
                    }, 500);
                }
            }
        }

        if (f != null) {
            var filename = f.name;
            var extName = "";
            var tmpIndex;
            var fileType = 0; // 0=normal file, 1=image

            tmpIndex = filename.lastIndexOf(".");
            if (tmpIndex != -1)
                extName = filename.substr(tmpIndex + 1);

            switch (extName.toUpperCase()) {
                case "gif".toUpperCase():
                case "tif".toUpperCase():
                case "jpg".toUpperCase():
                case "png".toUpperCase():
                case "jpeg".toUpperCase():
                case "bmp".toUpperCase():
                    fileType = 1;
                default:
                    break;
            }
            // upload image
            sc.CreateMedia(SID, fileType, extName, function (success, MI) {
                if (success) {
                    if (MI != null) {
                        chunkSize = MI.ChunkSize;
                        mediaId = MI.Id;

                        readMediaNext(function (finished) {
                            // finished
                            if (finished) {
                                sc.CloseAndSendMedia(SID, RoomID, mediaId, function () {
                                    var idProgressBar = document.getElementById("idProgressBar");

                                    idProgressBar.style.display = "none";

                                    if (success) {
                                        txtUserMsg.focus();
                                    } else {
                                        alert("send msg exception");
                                    }
                                });
                            } else {
                                // upload exception
                            }
                        });
                    } else {
                        // upload exception
                    }
                } else {
                    // upload exception
                }
            });
        }
    }

    function checkUserKeyDown() {
        if (window.event.keyCode == 13) {
            sendMsg();
        }
    }

    function checkScroll() {
       // var idChatContent = document.getElementById("idChatContent");


        if (idWrapper != null) {
            if (idWrapper.scrollTop < 50) {
                if (TopPageIndex > 1) {
                    // 透過 getMessage 控制避免執行中重複執行
                    if (getMessage == false) {
                        getMessage = true;

                        // 先以目前 PageIndex - 1 嘗試取結果, 如成功再更新 TopPageIndex
                        // 避免網路異常 TopPageIndex 不正確
                        getPageMessage((TopPageIndex - 1), false, function (success, o) {
                            if (success) {
                                TopPageIndex--;
                            }

                            getMessage = false;
                        });
                    }
                }
            }
        }
    }

    function sendMsg() {
        var txtUserMsg = document.getElementById("txtUserMsg");
        var text;

        var nowDate = new Date();

        text = txtUserMsg.value;
        if (text != "") {
            sc.AddTextMessage(SID, RoomID, Math.uuid(), text, function (success) {
                if (success) {
                    txtUserMsg.value = "";
                    txtUserMsg.focus();
                } else {
                    alert("send msg exception");
                }
            });
        }
    }

    function createRoom(cb) {
        sc.CreateRoom(SID, function (success, o) {
            if (success) {
                if (o != null) {
                    RoomID = o.RoomID;
                    lastMsgGUID = o.LastMsgID;
                    TopPageIndex = o.PageCount;
                }

                getPageMessage(TopPageIndex, true, function () {
                    checkScroll();

                    if (cb)
                        cb(success, o);
                });
            }
        });
    }

    function getPageMessage(pageIndex, intoView, cb) {
        sc.GetRoomPageMessage(SID, pageIndex, function (success, o) {
            if (success) {
                if (o != null) {
                    for (var i = 0; i < o.length; i++) {
                        var msg = o[i];

                        msgContent[msg.TimeSerial] = msg;
                        addMessageToContent(msg, intoView);
                    }

                }
            }

            if (cb)
                cb(success, o);
        });
    }

    function getRoomInfo(cb) {
        // 維持用戶仍加入 Room
        sc.JoinRoom(SID, function (success, o) {
            if (success) {
                if (o == null) {
                }
            }
        })
    }

    function getMessageHeight() {
        var idMessageList = document.getElementById("idMessageList");
        var clientHeight = 0;

        if (idMessageList != null) {
            clientHeight = idMessageList.clientHeight;
        }

        return clientHeight;
    }

    function findMessage(msgSerial) {
        var idMessageList = document.getElementById("idMessageList");
        var retValue = null;

        for (var i = 0; i < idMessageList.children.length; i++) {
            var el = idMessageList.children[i];

            if (el.hasAttribute("MsgSerial")) {
                var mID = el.getAttribute("MsgSerial");

                if (mID == msgSerial) {
                    retValue = el;
                    break;
                }
            }
        }

        return retValue;
    }

    function addMessage(o) {
        var idMessageList = document.getElementById("idMessageList");
        var MsgSerial = o.TimeSerial;//當前訊息最上層序號
        var foundInList = false;
        var insertRef = null;//要新增訊息的參考點
        var retValue = null;

        //搜尋目前訊息 MsgSerial 是否有存在目前聊天訊息中
        for (var i = 0; i < idMessageList.children.length; i++) {
            var el = idMessageList.children[i];

            if (el.hasAttribute("MsgSerial")) {
                var mID = el.getAttribute("MsgSerial");

                if (mID == MsgSerial) {
                    foundInList = true;
                    break;
                } else if (mID > MsgSerial) {
                    insertRef = el;
                    break;
                }
            }
        }

        //沒有建立新訊息
        if (foundInList == false) {
            var isMyMsg = false;
            var msgTemp;
            var msgDate;

            retValue = {
                AddMdgEl: null,//要加入的訊息元素
                RefEl: null//參考點元素
            }

            if (o.ChatDirection == 1) { // User
                if (o.Account.toUpperCase() == LoginAccount.toUpperCase()) {
                    isMyMsg = true;
                }
            }

            //判斷是客服訊息或是帳戶訊息
            if (isMyMsg) {
                msgTemp = c.getTemplate("templateMessageUser");
                c.setClassText(msgTemp, "chatName", null, o.Account);
            } else {
                msgTemp = c.getTemplate("templateMessageService");
                c.setClassText(msgTemp, "chatName", null,  mlp.getLanguageKey("客服萬萬"));
            }

            msgDate = c.getFirstClassElement(msgTemp, "msgDate");

            if (msgDate != null) {
                msgDate.setAttribute("MsgDate", o.Date);
                c.setClassText(msgDate, "chatDate", null, o.Date);

                if (lastDate != o.Date) {
                    lastDate = o.Date;
                    msgDate.style.display = "block";
                } else {
                    msgDate.style.display = "none";
                }
            }

            //設定訊息編號
            msgTemp.setAttribute("MsgSerial", MsgSerial);

            //c.setClassText(msgTemp, "chatName", null, "客服萬萬");

            switch (o.MessageType) {
                case 0:
                    // text
                    c.setClassText(msgTemp, "chatText", null, o.Content);
                    break;
                case 1:
                    // image or file
                    var contentHTML = "";

                    if (o.MediaInfo != null) {
                        if (o.MediaInfo.MediaType == 1) {
                            // image
                            if ((o.MediaInfo.ThumbnailFilename != null) && (o.MediaInfo.ThumbnailFilename != "")) {
                                // display Thumbnail
                                contentHTML = "<img onclick=\"showImageScale('" + o.Content + "')\" src=\"<%=Web.GWebURL%>/GetServiceChatMedia.aspx?Id=" + o.Content + "&t=1\" />";
                            } else {
                                contentHTML = "<img src='<%=Web.GWebURL%>/GetServiceChatMedia.aspx?Id=" + o.Content + "' />";
                            }
                        } else {
                            // normal file
                            contentHTML = o.Content;
                        }
                    } else {
                        contentHTML = o.Content;
                    }

                    c.setClassText(msgTemp, "chatText", null, contentHTML);
                    break;
                default:
                    c.setClassText(msgTemp, "chatText", null, o.Content);
                    break;
            }
            
            c.setClassText(msgTemp, "chatTime", null, o.Time);

            if (insertRef != null) {
                idMessageList.insertBefore(msgTemp, insertRef);
            } else {
                idMessageList.appendChild(msgTemp);
            }

            
            //idMessageList.style.top = "-1000px";
            //idMessageList.scrollTop = 1000;
            retValue.AddMdgEl = msgTemp;
            retValue.RefEl = insertRef;
        }

        return retValue;
    }


    function scrollIntoMsg(msgSerial) {
        var el;

        el = findMessage(msgSerial);

        if (el != null) {
            scrollIntoEl(el);
        }
    }

    function scrollIntoEl(el) {
        //msgScroll.scrollToElement(el, null, true, true);
        if (idWrapper.scrollTo) {
            idWrapper.scrollTo(0, el.offsetTop);
        } else {
            idWrapper.scrollTop = el.offsetTop;
        }
    }

    function addMessageToContent(o, intoView) {
        var msgEl;

        msgEl = addMessage(o);

        if (intoView) {
            // 訊息卷軸移動到最下方
            var chatinput = document.getElementById("chatinput");
            var clientHeight = getMessageHeight();
           
            if (idWrapper.scrollTo) {
                idWrapper.scrollTo(0, (clientHeight - (document.body.clientHeight - chatinput.clientHeight) + 10));
            } else {
                idWrapper.scrollTop = clientHeight - (document.body.clientHeight - chatinput.clientHeight) + 10;
            }
            //msgScroll.scrollTo(0, 0 - (clientHeight - (document.body.clientHeight - chatinput.clientHeight) + 10));

        } else {
            // 訊息卷軸移動到參考點
            if (msgEl != null) {
                if (msgEl.RefEl != null) {
                    scrollIntoEl(msgEl.RefEl);
                }
            }
        }
    }

    function GWebEventNotify(eventName, isDisplay, o) {
        if (isDisplay) {
            if (eventName == "SetCurrencyType") {
            } else if (eventName == "LoginState") {
            } else if (eventName == "WindowFocus") {
            } else if (eventName == "SetLanguage") {
                lang = o;
                mlp.loadLanguage(lang, function () { });
            }
        }
    }

    function userRecover(cb) {
        function getCookie(cname) {
            var name = cname + "=";
            var decodedCookie = decodeURIComponent(document.cookie);
            var ca = decodedCookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }

        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toUTCString();
            document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        }

        var recoverToken = getCookie("RecoverToken");

        if ((recoverToken != null) && (recoverToken != "")) {
            var postData;

            ui.showMask(null, mlp.getLanguageKey("登入復原中"));
            postData = encodeURI("Token=" + Token + "&RecoverToken=" + recoverToken);
            c.callService("/LoginRecover.aspx?" + postData, null, function (success, o) {
                ui.hideMask();

                if (success) {
                    var obj = c.getJSON(o);

                    if (obj.ResultCode == 0) {
                        Token = obj.Token;
                        SID = obj.SID;

                        setCookie("RecoverToken", obj.RecoverToken, 365);

                        if (cb)
                            cb(true);
                    } else {
                        ui.showMask(null, mlp.getLanguageKey("登入已過期, 請重新登入"));
                        window.close();
                    }
                } else {
                    ui.showMask(null, mlp.getLanguageKey("登入已過期, 請重新登入"));
                    window.close();
                }
            });
        }
    }

    function init() {
        lang = window.localStorage.getItem("Lang");

        mlp = new multiLanguage();
        mlp.loadLanguage(lang, function () {
            sc = new ServiceChatSID(GWebUrl);

            sc.handleNotify(function (o) {
                if (o != null) {
                    switch (o.Event) {
                        case 0:
                            // CreateRoom
                            break;
                        case 1:
                            // JoinRoom
                            break;
                        case 2:
                            // Message
                            if (o.Content != null) {
                                msgContent[o.Content.TimeSerial] == o.Content;

                                addMessageToContent(o.Content, true);
                            }

                            break;
                        case 3:
                            // Exception
                            alert(o.Content);
                            break;
                    }
                }
            });

            sc.handleStateChange(function (newState, oldState) {
                switch (sc.state()) {
                    case 0:
                        break;
                    case 1:
                        ui.hideMask();
                        break;
                    case 2:
                        ui.showMask(null, mlp.getLanguageKey("重新連線中..."));
                        break;
                    case 4:
                        ui.showMask(null, mlp.getLanguageKey("服務器連線中斷"));
                        break;
                }
            });

            sc.handleReconnected(function () {
                ui.hideMask();
                needCheckLogin = true;
            });

            sc.handleConnected(function () {
                sc.UpdateConnection(SID, function (success, o) {
                    if (success) {
                        if (o.Success == true) {
                            createRoom();
                        }
                    }
                });
            });


            sc.initializeConnection();
            idWrapper = document.getElementById("Wrapper");
            /* msgScroll = new IScroll("#Wrapper");
             msgScroll.on('scrollStart', function () {
                 $("iframe").css("pointer-events", "none");
             });
 
             msgScroll.on('scrollEnd', function () {
                 $("iframe").css("pointer-events", "auto");
             });*/

            setInterval(function () {
                if (sc != null) {
                    needCheckLogin = true;
                }
            }, 15000);

            setInterval(function () {
                if (sc != null) {
                    if (sc.state() == 1) {
                        checkScroll();

                        if (needCheckLogin == true) {
                            needCheckLogin = false;
                            sc.UpdateConnection(SID, function (success, o) {
                                ui.hideMask();

                                if (success) {
                                    if (o.Success == true) {
                                        getRoomInfo();
                                    } else {
                                        // disconnect
                                        userRecover(function (success) {
                                            if (success) {
                                                needCheckLogin = true;
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    }
                }
            }, 500);
        });
    }

    function btnClose(){
        document.getElementById('imgScale').style.display = 'none';
    }

    function unloadPage() {
        alert("test");
    }

    window.onload = init;
    //window.onbeforeunload = unloadPage;
</script>
<body style="height: 100%; max-height: 100%; width: 100%;">
    <div id="templateGroup" style="display: none">
        <div id="templateDate">
            <div class="chatDate"><span class="language_replace">昨日</span></div>
        </div>
        <div id="templateMessageService">
            <div>
			    <div class="msgDate">
				    <div class="chatDate language_replace">今日</div>
			    </div>
                <div class="chatDivL">
                    <div class="chatIcon">
                        <img src="../images/avatar2.png" alt="mainIcon" />
                    </div>
                    <div class="chatCon">
                        <div class="chatName language_replace">客服萬萬</div>
                        <div class="chatTextDiv">
                            <div class="chatText">GGININDER</div>
                            <div class="chatTime"><span class="language_replace">上午</span><span>08:14</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="templateMessageUser">
            <div>
			    <div class="msgDate">
				    <div class="chatDate language_replace">今日</div>
			    </div>
                <div class="chatDivR">
                    <div class="chatCon">
                        <div class="chatName">You</div>
                        <div class="chatTextDiv">
                            <div class="chatTime"><span class="language_replace">上午</span><span>08:18</span></div>
                            <div class="chatText">Me2</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="Wrapper" style="height: 100%; width: 100%; overflow-y: auto; -webkit-overflow-scrolling: touch;">
        <div>
            <div class="mainWrapper">
                <div class="chatWapper" id="idMessageList">
                </div>
            </div>
        </div>
    </div>
    <div class="chatInputCon" id="chatinput">
		<div class="progressBarDIV">
			<!-- 請控制下方DIV的寬度百分比 -->
			<div class="progressBar" id="idProgressBar" style="display: none; width: 40%"></div>
		</div>
        <label for="idSendMedia" class="fileBTN">
            <img class="fileBTNImg" src="../images/m_chat_fileBTN.png" />
            <input type="file" onchange="onClickMediaFile()" accept="image/*"  id="idSendMedia" name="idSendMedia">
        </label>
        <div class="chatInput">
            <input type="text" onkeypress="checkUserKeyDown()" id="txtUserMsg" language_replace="placeholder" placeholder="說點甚麼...">
        </div>
        <div class="chatSendBtn" onclick="sendMsg()"></div>
    </div>
    <div class="imgScale_Outer" id="imgScale" style="display: none;">
        <div class="BtnClose" onclick="btnClose()"><i class="fas fa-times" style="color: #fff;"></i></div>
        <div class="imgScale_inner">
            <img id="idImgScale_Image" alt="">
        </div>
    </div>
</body>
</html>
