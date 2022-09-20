var LobbyAPI = function (APIUrl) {
    this.HeartBeat = function (GUID, Echo, cb) {
        var url = APIUrl + "/HeartBeat";
        var postData;

        postData = {
            GUID: GUID,
            Echo: Echo
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetUserMail = function (GUID, ValidateType, SendMailType, EMail, ContactPhonePrefix, ContactPhoneNumber, SMSContent, LoginAccount, cb) {
        var url = APIUrl + "/SetUserMail";
        var postData;

        postData = {
            GUID: GUID,
            ValidateType: ValidateType,
            SendMailType: SendMailType,
            EMail: EMail,
            ContactPhonePrefix: ContactPhonePrefix,
            ContactPhoneNumber: ContactPhoneNumber,
            SMSContent: SMSContent,
            LoginAccount: LoginAccount
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetUserPasswordByValidateCode = function (GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber, ValidateCode, NewPassword, cb) {
        var url = APIUrl + "/SetUserPasswordByValidateCode";
        var postData;

        postData = {
            GUID: GUID,
            ValidateType: ValidateType,
            EMail: EMail,
            ContactPhonePrefix: ContactPhonePrefix,
            ContactPhoneNumber: ContactPhoneNumber,
            ValidateCode: ValidateCode,
            NewPassword: NewPassword
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetUserAccountProperty = function (GUID, SID, PropertyName, cb) {
        var url = APIUrl + "/GetUserAccountProperty";
        var postData;

        postData = {
            GUID: GUID,
            SID: SID,
            PropertyName: PropertyName
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetUserMail = function (GUID, ValidateType, SendMailType, EMail, ContactPhonePrefix, ContactPhoneNumber, ReceiveRegisterRewardURL, cb) {
        var url = APIUrl + "/SetUserMail";
        var postData;

        postData = {
            GUID: GUID,
            ValidateType: ValidateType,
            SendMailType: SendMailType,
            EMail: EMail,
            ContactPhonePrefix: ContactPhonePrefix,
            ContactPhoneNumber: ContactPhoneNumber,
            ReceiveRegisterRewardURL: ReceiveRegisterRewardURL
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.CheckValidateCode = function (GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber, ValidateCode, cb) {
        var url = APIUrl + "/CheckValidateCode";
        var postData;

        postData = {
            GUID: GUID,
            ValidateType: ValidateType,
            EMail: EMail,
            ContactPhonePrefix: ContactPhonePrefix,
            ContactPhoneNumber: ContactPhoneNumber,
            ValidateCode: ValidateCode,
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };


    this.CreateAccount = function (GUID, LoginAccount, LoginPassword, ParentPersonCode, CurrencyList, PS, cb) {
        var url = APIUrl + "/CreateAccount";
        var postData;

        postData = {
            GUID: GUID,
            LoginAccount: LoginAccount,
            LoginPassword: LoginPassword,
            ParentPersonCode: ParentPersonCode,
            CurrencyList: CurrencyList,
            PS: PS
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.CheckAccountExist = function (GUID, LoginAccount, cb) {
        var url = APIUrl + "/CheckAccountExist";
        var postData;

        postData = {
            LoginAccount: LoginAccount,
            GUID: GUID
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetUserAccountProperty = function (GUID, SID, PropertyName, PropertyValue, cb) {
        var url = APIUrl + "/SetUserAccountProperty";
        var postData;

        postData = {
            GUID: GUID,
            SID: SID,
            PropertyName: PropertyName,
            PropertyValue: PropertyValue
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    //#region Kevin
    this.RequireRegister2 = function (data, cb) {
        var url = APIUrl + "/RequireRegister2";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetUserBankCardState = function (data, cb) {
        var url = APIUrl + "/SetUserBankCardState";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.UpdateUserBankCard = function (data, cb) {
        var url = APIUrl + "/UpdateUserBankCard";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.AddUserBankCard = function (data, cb) {
        var url = APIUrl + "/AddUserBankCard";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetUserPassword = function (data, cb) {
        var url = APIUrl + "/SetUserPassword";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetUserBankCard = function (data, cb) {
        var url = APIUrl + "/GetUserBankCard";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.SetWalletPassword = function (data, cb) {
        var url = APIUrl + "/SetWalletPassword";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetUserInfo = function (data, cb) {
        var url = APIUrl + "/GetUserInfo";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetCompanyGameCode = function (data, cb) {
        var url = APIUrl + "/GetCompanyGameCode";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetCompanySite = function (data, cb) {
        var url = APIUrl + "/GetCompanySite";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.KeepSID = function (data, cb) {
        var url = APIUrl + "/KeepSID";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetGameOrderDetailHistoryBySummaryDate = function (data, cb) {
        var url = APIUrl + "/GetGameOrderDetailHistoryBySummaryDate";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    this.GetPaymentHistory = function (data, cb) {
        var url = APIUrl + "/GetPaymentHistory";
        var postData;

        postData = data;

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };
    //#endregion

    this.GetInfoData2 = function (GUID, InfoID, cb) {
        var url = APIUrl + "/GetInfoData2";
        var postData;

        postData = {
            GUID: GUID,
            InfoID: InfoID
        };

        callService(url, postData, 10000, function (success, text) {
            if (success == true) {
                var obj = getJSON(text);

                if (cb)
                    cb(true, obj);
            } else {
                if (cb)
                    cb(false, text);
            }
        });
    };

    function callService(URL, postObject, timeoutMS, cb) {
        var xmlHttp = new XMLHttpRequest;
        var postData;

        if (postObject)
            postData = JSON.stringify(postObject);

        xmlHttp.open("POST", URL, true);
        xmlHttp.onreadystatechange = function () {
            if (this.readyState == 4) {
                var contentText = this.responseText;

                if (this.status == "200") {
                    if (cb) {
                        cb(true, contentText);
                    }
                } else {
                    cb(false, contentText);
                }
            }
        };

        xmlHttp.timeout = timeoutMS;
        xmlHttp.ontimeout = function () {
            /*
            timeoutTryCount += 1;

            if (timeoutTryCount < 2)
                xmlHttp.send(postData);
            else*/
            if (cb)
                cb(false, "Timeout");
        };

        xmlHttp.setRequestHeader("Content-Type", "application/json; charset=utf-8");
        xmlHttp.send(postData);
    }

    function getJSON(text) {
        var obj = JSON.parse(text);

        if (obj) {
            if (obj.hasOwnProperty('d')) {
                return obj.d;
            } else {
                return obj;
            }
        }
    }
}