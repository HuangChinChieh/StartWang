var PaymentAPI = function (APIUrl, CT) {
    this.HeartBeat = function (echoString, cb) {
        var url = APIUrl + "/HeartBeat";
        var postData;

        postData = {
            EchoString: echoString
        };

        callService(url, postData, 3000, function (success, text) {
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

    this.CreateReceiptFIleUpload = function (GUID, PaymentSerial, ExtName, cb) {
        var url = APIUrl + "/CreateReceiptFIleUpload";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            PaymentSerial: PaymentSerial,
            ExtName: ExtName
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.UploadReceiptFIle = function (GUID, UploadId, ChunkIndex, ContentB64, cb) {
        var url = APIUrl + "/UploadReceiptFIle";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            UploadId: UploadId,
            ChunkIndex: ChunkIndex,
            ContentB64: ContentB64
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.CompleteReceiptFile = function (GUID, UploadId, cb) {
        var url = APIUrl + "/CompleteReceiptFile";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            UploadId: UploadId
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.KeepSID = function (GUID, cb) {
        var url = APIUrl + "/KeepSID";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.CheckBankCardDepostit = function (GUID, cb) {
        var url = APIUrl + "/CheckBankCardDepostit";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.GetBankCardWithdrawalBySerial = function (GUID, PaymentSerial, cb) {
        var url = APIUrl + "/GetBankCardWithdrawalBySerial";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            PaymentSerial: PaymentSerial
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.GetBankCardDepostitBySerial = function (GUID, PaymentSerial, cb) {
        var url = APIUrl + "/GetBankCardDepostitBySerial";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            PaymentSerial: PaymentSerial
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.BankCardDepostitCancel = function (GUID, PaymentSerial, cb) {
        var url = APIUrl + "/BankCardDepostitCancel";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            PaymentSerial: PaymentSerial
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.BankCardWithdrawal = function (GUID, CurrencyType, PaymentMethod, Amount, WalletPassword, BankCardGUID, cb) {
        var url = APIUrl + "/BankCardWithdrawal";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            CurrencyType: CurrencyType,
            PaymentMethod: PaymentMethod,
            Amount: Amount,
            WalletPassword: WalletPassword,
            BankCardGUID: BankCardGUID
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.BankCardDepostit = function (GUID, CurrencyType, PaymentMethod, Amount, Description, cb) {
        var url = APIUrl + "/BankCardDepostit";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            CurrencyType: CurrencyType,
            PaymentMethod: PaymentMethod,
            Amount: Amount,
            Description: Description
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.GetUserAccountBankCard = function (GUID, CurrencyType, PaymentMethod, cb) {
        var url = APIUrl + "/GetUserAccountBankCard";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            CurrencyType: CurrencyType,
            PaymentMethod: PaymentMethod
        };

        callService(url, postData, 5000, function (success, text) {
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

    this.GetCompanyPaymentBankCard = function (GUID, CurrencyType, PaymentMethod, cb) {
        var url = APIUrl + "/GetCompanyPaymentBankCard";
        var postData;

        postData = {
            CT: CT,
            GUID: GUID,
            CurrencyType: CurrencyType,
            PaymentMethod: PaymentMethod
        };

        callService(url, postData, 5000, function (success, text) {
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
};