<%@ WebService Language="C#" Class="PaymentAPI" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
public class PaymentAPI : System.Web.Services.WebService {
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public APIResult HeartBeat(string GUID, string Echo) {
        APIResult R = new APIResult();
        R.Result = enumResult.OK;
        R.Message = Echo;

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.BankCardDepositResult BankCardDepostit(string CT,string GUID, string CurrencyType, int PaymentMethod, decimal Amount,string Description) {
        EWin.EWinWeb.EWinWeb EWinWebAPI = new EWin.EWinWeb.EWinWeb();
        EWin.EWinWeb.BankCardDepositResult RetValue = null;
        string DownOrderNumber = Guid.NewGuid().ToString("N");
        RetValue = EWinWebAPI.BankCardDepostit(CT, GUID,CurrencyType,PaymentMethod, Amount, Description,DownOrderNumber);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult CompleteReceiptFile(string CT, string GUID, string UploadId) {
        RedisCache.SessionContext.SIDInfo SI;
        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.CompleteReceiptFile(CT,GUID,UploadId);


        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult GetCompanyPaymentBankCard(string CT, string GUID, string CurrencyType,int PaymentMethod) {

        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.GetCompanyPaymentBankCard(CT,GUID,CurrencyType,PaymentMethod);


        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.UploadInfoResult CreateReceiptFIleUpload(string CT, string GUID, string PaymentSerial, string ExtName) {
        EWin.EWinWeb.UploadInfoResult R = new EWin.EWinWeb.UploadInfoResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.CreateReceiptFIleUpload(CT,GUID,PaymentSerial,ExtName);
        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult UploadReceiptFIle(string CT, string GUID, string UploadId, int ChunkIndex, string ContentB64) {
        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.UploadReceiptFIle(CT,GUID,UploadId,ChunkIndex,ContentB64);

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult CheckBankCardDepostit(string CT, string GUID) {
        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.CheckBankCardDepostit(CT,GUID);

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult BankCardDepostitCancel(string CT, string GUID, string PaymentSerial) {
        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.BankCardDepostitCancel(CT,GUID,PaymentSerial);

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult GetUserAccountBankCard(string CT, string GUID, string CurrencyType,int PaymentMethod) {
        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.GetUserAccountBankCard(CT,GUID,CurrencyType,PaymentMethod);

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.EWinWeb.APIResult BankCardWithdrawal(string CT, string GUID, string CurrencyType,int PaymentMethod,decimal Amount,string WalletPassword,string[] BankCardGUID) {
        EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

        EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
        //PaymentMethod 0=上分/1=下分
        R= CASINO3651API.BankCardWithdrawal(CT,GUID,CurrencyType,PaymentMethod,Amount,WalletPassword,BankCardGUID);

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentMethodResult GetPaymentMethodByCategory(string WebSID, string GUID, string PaymentCategoryCode, int PaymentType) {
        RedisCache.SessionContext.SIDInfo SI;
        PaymentMethodResult R = new PaymentMethodResult() { GUID = GUID, Result = enumResult.ERR, PaymentMethodResults = new List<PaymentMethod>() };
        System.Data.DataTable DT = new System.Data.DataTable();
        DT = RedisCache.PaymentMethod.GetPaymentMethodByCategory(PaymentCategoryCode);

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            if (DT != null) {
                if (DT.Rows.Count > 0) {
                    R.Result = enumResult.OK;
                    R.PaymentMethodResults = EWinWeb.ToList<PaymentMethod>(DT).Where(x => x.PaymentType == PaymentType).ToList();
                } else {
                    SetResultException(R, "NoData");
                }
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public ActivityCore.ActResult<List<ActivityCore.DepositActivity>> GetDepositActivityInfoByOrderNumber(string WebSID, string GUID, string OrderNumber)
    {
        RedisCache.SessionContext.SIDInfo SI;
        ActivityCore.ActResult<List<ActivityCore.DepositActivity>> R = new ActivityCore.ActResult<List<ActivityCore.DepositActivity>>() { GUID = GUID, Result = ActivityCore.enumActResult.ERR };
        PaymentCommonData TempCryptoData;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID))
        {
            TempCryptoData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);

            if (TempCryptoData != null)
            {
                R = ActivityCore.GetDepositAllResult(TempCryptoData.Amount, TempCryptoData.PaymentCode, TempCryptoData.LoginAccount);
            }
            else
            {
                ActivityCore.SetResultException(R, "OrderNotExist");
            }
        }
        else
        {
            ActivityCore.SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateAgentWithdrawal(string WebSID, string GUID, decimal Amount, string BankName, string BankBranchName, string BankCard, string BankCardName) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData PaymentCommonData = new PaymentCommonData() { PaymentCryptoDetailList = new List<CryptoDetail>() };

        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        int MinLimit;
        int MaxLimit;
        int DailyMaxAmount;
        int DailyMaxCount;
        decimal ReceiveTotalAmount;
        decimal HandingFeeRate;
        int HandingFeeAmount;
        int WalletType;
        int ExpireSecond;
        int DecimalPlaces;
        string Description;
        string WithdrawalGUID = Guid.NewGuid().ToString("N");
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            //if (EWinWeb.CheckInWithdrawalTime()) {
            if (!EWinWeb.IsWithdrawlTemporaryMaintenance()) {
                PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByCategory("Agent");

                if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                    if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                        if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 1) {
                            MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                            MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];
                            DailyMaxCount = (int)PaymentMethodDT.Rows[0]["DailyMaxCount"];
                            DailyMaxAmount = (int)PaymentMethodDT.Rows[0]["DailyMaxAmount"];
                            DecimalPlaces = (int)PaymentMethodDT.Rows[0]["DecimalPlaces"];
                            if (Amount >= MinLimit) {
                                if (Amount <= MaxLimit || MaxLimit == 0) {
                                    //System.Data.DataTable SummaryDT = EWinWebDB.UserAccountPayment.GetTodayPaymentByLoginAccount(SI.LoginAccount, 1);

                                    //if (SummaryDT != null && SummaryDT.Rows.Count > 0) {
                                    //    WithdrawalAmountByDay = 0;
                                    //    foreach (System.Data.DataRow dr in SummaryDT.Rows) {
                                    //        WithdrawalAmountByDay += (decimal)dr["Amount"];
                                    //    }
                                    //    WithdrawalCountByDay = SummaryDT.Rows.Count;
                                    //} else {
                                    //    WithdrawalAmountByDay = 0;
                                    //    WithdrawalCountByDay = 0;
                                    //}

                                    //if (DailyMaxCount == 0 || (WithdrawalCountByDay + 1) <= DailyMaxCount) {
                                    //    if (DailyMaxAmount == 0 || (WithdrawalAmountByDay + Amount) <= DailyMaxAmount) {
                                    if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 0) {
                                        //Check ThresholdValue
                                        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                                        EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
                                        EWin.Lobby.ThresholdInfo thresholdInfo;
                                        decimal thresholdValue;

                                        if (userInfoResult.Result == EWin.Lobby.enumResult.OK) {
                                            thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

                                            if (thresholdInfo != null) {
                                                thresholdValue = thresholdInfo.ThresholdValue;
                                            } else {
                                                thresholdValue = 0;
                                            }
                                            if (thresholdValue == 0) {
                                                PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                                PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                                ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
                                                ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                                HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                                HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
                                                WalletType = (int)PaymentMethodDT.Rows[0]["EWinCryptoWalletType"];
                                                //MultiCurrencyInfo = (string)PaymentMethodDT.Rows[0]["MultiCurrencyInfo"];
                                                ReceiveTotalAmount = (Amount * (1 - (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) - HandingFeeAmount;

                                                if (string.IsNullOrEmpty(BankBranchName))
                                                {
                                                    Description = WithdrawalGUID + "<br/>" + BankName + "<br/>" + BankCard + "<br/>" + BankCardName;
                                                }
                                                else {
                                                    Description = WithdrawalGUID + "<br/>" + BankName + "<br/>" + BankBranchName + "<br/>" + BankCard + "<br/>" + BankCardName;
                                                }

                                                EWin.Lobby.APIResult InsertResult  = lobbyAPI.RequireWithdrawal(GetToken(), SI.EWinSID, GUID,(string)PaymentMethodDT.Rows[0]["CurrencyType"],Amount,Description);

                                                if (InsertResult.Result == EWin.Lobby.enumResult.OK)
                                                {
                                                    AgentWithdrawal _AgentWithdrawalData = new AgentWithdrawal() { BankBranchName = BankBranchName, BankCard = BankCard, BankCardName = BankCardName, BankName = BankName, GUID = WithdrawalGUID, LoginAccount = SI.LoginAccount,CreateDate= DateTime.Now.ToString(("yyyy-MM-dd HH:mm:ss")),Status=0 ,Amount= Amount};
                                                    int Year= DateTime.Now.Year;
                                                    int Month = DateTime.Now.Month;
                                                    RedisCache.AgentWithdrawalContent.KeepWithdrawalContents<AgentWithdrawal>(_AgentWithdrawalData,SI.LoginAccount, Year + "-" + Month);
                                                    R.Result = enumResult.OK;
                                                }
                                                else {
                                                    SetResultException(R, InsertResult.Message);
                                                }
                                            } else {
                                                SetResultException(R, "ThresholdLimit");
                                            }
                                        } else {
                                            SetResultException(R, "GetInfoError");
                                        }

                                    } else {
                                        SetResultException(R, "PaymentMethodNotCrypto");
                                    }

                                    //    } else {
                                    //        SetResultException(R, "DailyAmountGreaterThanMaxlimit");
                                    //    }
                                    //} else {
                                    //    SetResultException(R, "DailyCountGreaterThanMaxlimit");
                                    //}
                                } else {
                                    SetResultException(R, "AmountGreaterThanMaxlimit");
                                }
                            } else {
                                SetResultException(R, "AmountLessThanMinLimit");
                            }
                        } else {
                            SetResultException(R, "PaymentMethodNotSupportDeposit");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodDisable");
                    }
                } else {
                    SetResultException(R, "PaymentMethodNotExist");
                }
            } else {
                SetResultException(R, "WithdrawlTemporaryMaintenance");
            }
            //} else {
            //    SetResultException(R, "NotInOpenTime");
            //}
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateCryptoDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData PaymentCommonData = new PaymentCommonData() { PaymentCryptoDetailList = new List<CryptoDetail>() };


        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        string MultiCurrencyInfo;
        int MinLimit;
        int MaxLimit;
        int DailyMaxAmount;
        int DailyMaxCount;
        decimal ReceiveTotalAmount;
        decimal HandingFeeRate;
        int HandingFeeAmount;
        decimal ThresholdRate;
        int WalletType;
        decimal DepositAmountByDay;
        int DepositCountByDay;
        int ExpireSecond;
        bool GetExchangeRateSuccess = true;
        int DecimalPlaces;
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

            if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                    if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
                        MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                        MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];
                        DailyMaxCount = (int)PaymentMethodDT.Rows[0]["DailyMaxCount"];
                        DailyMaxAmount = (int)PaymentMethodDT.Rows[0]["DailyMaxAmount"];
                        DecimalPlaces = (int)PaymentMethodDT.Rows[0]["DecimalPlaces"];
                        if (Amount >= MinLimit) {
                            if (Amount <= MaxLimit || MaxLimit == 0) {
                                System.Data.DataTable SummaryDT = RedisCache.UserAccountSummary.GetUserAccountSummary(SI.LoginAccount, DateTime.Now);

                                if (SummaryDT != null && SummaryDT.Rows.Count > 0) {
                                    DepositAmountByDay = (decimal)SummaryDT.Rows[0]["DepositAmount"];
                                    DepositCountByDay = (int)SummaryDT.Rows[0]["DepositCount"];
                                } else {
                                    DepositAmountByDay = 0;
                                    DepositCountByDay = 0;
                                }

                                if (DailyMaxCount == 0 || (DepositCountByDay + 1) <= DailyMaxCount) {
                                    if (DailyMaxAmount == 0 || (DepositAmountByDay + Amount) <= DailyMaxAmount) {
                                        if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 2) {
                                            PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                            PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                            ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
                                            ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                            HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
                                            ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                            WalletType = (int)PaymentMethodDT.Rows[0]["EWinCryptoWalletType"];
                                            MultiCurrencyInfo = (string)PaymentMethodDT.Rows[0]["MultiCurrencyInfo"];
                                            ReceiveTotalAmount = (Amount * (1 + HandingFeeRate)) + HandingFeeAmount;


                                            if (!string.IsNullOrEmpty(MultiCurrencyInfo)) {
                                                Newtonsoft.Json.Linq.JArray MultiCurrency = Newtonsoft.Json.Linq.JArray.Parse(MultiCurrencyInfo);

                                                foreach (var item in MultiCurrency) {
                                                    string TokenCurrency;
                                                    decimal ExchangeRate;
                                                    decimal PartialRate;
                                                    if (!int.TryParse(item["DecimalPlaces"].ToString(), out DecimalPlaces))
                                                    {
                                                        DecimalPlaces = 6;
                                                    }
                                                    TokenCurrency = item["Currency"].ToString();
                                                    ExchangeRate = CryptoExpand.GetCryptoExchangeRate(TokenCurrency);

                                                    if (ExchangeRate == 0) {
                                                        //表示取得匯率失敗
                                                        GetExchangeRateSuccess = false;
                                                        break;
                                                    } else {
                                                        PartialRate = (decimal)item["Rate"];

                                                        CryptoDetail Dcd = new CryptoDetail() {
                                                            TokenCurrencyType = TokenCurrency,
                                                            TokenContractAddress = item["TokenContractAddress"].ToString(),
                                                            ExchangeRate = CodingControl.FormatDecimal(ExchangeRate, DecimalPlaces),
                                                            PartialRate = PartialRate,
                                                            ReceiveAmount = CodingControl.FormatDecimal(ReceiveTotalAmount * PartialRate * ExchangeRate, DecimalPlaces),
                                                        };

                                                        PaymentCommonData.PaymentCryptoDetailList.Add(Dcd);
                                                    }
                                                }
                                            } else {
                                                decimal ExchangeRate;
                                                decimal ReceiveAmount;

                                                ExchangeRate = CryptoExpand.GetCryptoExchangeRate(ReceiveCurrencyType);
                                                ReceiveAmount = Amount * ExchangeRate;

                                                if (ExchangeRate == 0) {
                                                    //表示取得匯率失敗
                                                    GetExchangeRateSuccess = false;
                                                } else {
                                                    CryptoDetail Dcd = new CryptoDetail() {
                                                        TokenCurrencyType = ReceiveCurrencyType,
                                                        TokenContractAddress = (string)PaymentMethodDT.Rows[0]["TokenContractAddress"],
                                                        ExchangeRate = CodingControl.FormatDecimal(ExchangeRate, DecimalPlaces),
                                                        PartialRate = 1,
                                                        ReceiveAmount = CodingControl.FormatDecimal(ReceiveTotalAmount * 1 * ExchangeRate, DecimalPlaces),
                                                    };

                                                    PaymentCommonData.PaymentCryptoDetailList.Add(Dcd);
                                                }
                                            }

                                            if (GetExchangeRateSuccess) {
                                                string OrderNumber = System.Guid.NewGuid().ToString();
                                                int InsertRet;

                                                PaymentCommonData.PaymentType = 0;
                                                PaymentCommonData.BasicType = 2;
                                                PaymentCommonData.WalletType = WalletType;
                                                PaymentCommonData.OrderNumber = OrderNumber;
                                                PaymentCommonData.LoginAccount = SI.LoginAccount;
                                                PaymentCommonData.Amount = Amount;
                                                PaymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                                PaymentCommonData.HandingFeeRate = HandingFeeRate;
                                                PaymentCommonData.HandingFeeAmount = HandingFeeAmount;
                                                PaymentCommonData.ExpireSecond = ExpireSecond;
                                                PaymentCommonData.PaymentMethodID = PaymentMethodID;
                                                PaymentCommonData.PaymentMethodName = PaymentMethodName;
                                                PaymentCommonData.PaymentCode = PaymentCode;
                                                PaymentCommonData.ThresholdRate = ThresholdRate;
                                                PaymentCommonData.ThresholdValue = Amount * ThresholdRate;
                                                PaymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");

                                                InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, PaymentCommonData.PaymentType, 2, PaymentCommonData.LoginAccount, PaymentCommonData.Amount, PaymentCommonData.HandingFeeRate, PaymentCommonData.HandingFeeAmount, PaymentCommonData.ThresholdRate, PaymentCommonData.ThresholdValue, PaymentCommonData.PaymentMethodID, "", "", Newtonsoft.Json.JsonConvert.SerializeObject(PaymentCommonData.PaymentCryptoDetailList), PaymentCommonData.ExpireSecond);

                                                if (InsertRet == 1) {
                                                    R.Result = enumResult.OK;
                                                    R.Data = PaymentCommonData;
                                                    RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(PaymentCommonData), PaymentCommonData.OrderNumber);
                                                } else {
                                                    SetResultException(R, "InsertFailure");
                                                }
                                            } else {
                                                SetResultException(R, "GetExchangeFailed");
                                            }
                                        } else {
                                            SetResultException(R, "PaymentMethodNotCrypto");
                                        }
                                    } else {
                                        SetResultException(R, "DailyAmountGreaterThanMaxlimit");
                                    }
                                } else {
                                    SetResultException(R, "DailyCountGreaterThanMaxlimit");
                                }
                            } else {
                                SetResultException(R, "AmountGreaterThanMaxlimit");
                            }
                        } else {
                            SetResultException(R, "AmountLessThanMinLimit");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodNotSupportDeposit");
                    }
                } else {
                    SetResultException(R, "PaymentMethodDisable");
                }
            } else {
                SetResultException(R, "PaymentMethodNotExist");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateCommonDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData paymentCommonData = new PaymentCommonData() { };

        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        int MinLimit;
        int MaxLimit;
        int DailyMaxAmount;
        int DailyMaxCount;
        decimal ReceiveTotalAmount;
        decimal HandingFeeRate;
        int HandingFeeAmount;
        decimal ThresholdRate;
        decimal DepositAmountByDay;
        int DepositCountByDay;
        int ExpireSecond;
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

            if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                    if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
                        MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                        MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];
                        DailyMaxCount = (int)PaymentMethodDT.Rows[0]["DailyMaxCount"];
                        DailyMaxAmount = (int)PaymentMethodDT.Rows[0]["DailyMaxAmount"];

                        if (Amount >= MinLimit) {
                            if (Amount <= MaxLimit || MaxLimit == 0) {
                                System.Data.DataTable SummaryDT = RedisCache.UserAccountSummary.GetUserAccountSummary(SI.LoginAccount, DateTime.Now);

                                if (SummaryDT != null && SummaryDT.Rows.Count > 0) {
                                    DepositAmountByDay = (decimal)SummaryDT.Rows[0]["DepositAmount"];
                                    DepositCountByDay = (int)SummaryDT.Rows[0]["DepositCount"];
                                } else {
                                    DepositAmountByDay = 0;
                                    DepositCountByDay = 0;
                                }


                                if (DailyMaxCount == 0 || (DepositCountByDay + 1) <= DailyMaxCount) {
                                    if (DailyMaxAmount == 0 || (DepositAmountByDay + Amount) <= DailyMaxAmount) {
                                        if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 0) {
                                            string OrderNumber = System.Guid.NewGuid().ToString();
                                            int InsertRet;

                                            PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                            PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                            ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
                                            ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
                                            ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                            HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
                                            ReceiveTotalAmount = (Amount * (1 + (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) + HandingFeeAmount;

                                            paymentCommonData.PaymentType = 0;
                                            paymentCommonData.BasicType = 0;
                                            paymentCommonData.OrderNumber = System.Guid.NewGuid().ToString();
                                            paymentCommonData.LoginAccount = SI.LoginAccount;
                                            paymentCommonData.Amount = Amount;
                                            paymentCommonData.HandingFeeRate = HandingFeeRate;
                                            paymentCommonData.HandingFeeAmount = HandingFeeAmount;
                                            paymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                            paymentCommonData.ExpireSecond = ExpireSecond;
                                            paymentCommonData.PaymentMethodID = PaymentMethodID;
                                            paymentCommonData.PaymentMethodName = PaymentMethodName;
                                            paymentCommonData.PaymentCode = PaymentCode;
                                            paymentCommonData.ThresholdRate = ThresholdRate;
                                            paymentCommonData.ThresholdValue = Amount * ThresholdRate;


                                            InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, paymentCommonData.PaymentType, 2, paymentCommonData.LoginAccount, paymentCommonData.Amount, paymentCommonData.HandingFeeRate, paymentCommonData.HandingFeeAmount, paymentCommonData.ThresholdRate, paymentCommonData.ThresholdValue, paymentCommonData.PaymentMethodID, "", "", "", paymentCommonData.ExpireSecond);

                                            if (InsertRet == 1) {
                                                R.Result = enumResult.OK;
                                                R.Data = paymentCommonData;
                                                RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(R), paymentCommonData.OrderNumber);
                                            } else {
                                                SetResultException(R, "InsertFailure");
                                            }
                                        } else {
                                            SetResultException(R, "PaymentMethodNotCrypto");
                                        }
                                    } else {
                                        SetResultException(R, "DailyAmountGreaterThanMaxlimit");
                                    }
                                } else {
                                    SetResultException(R, "DailyCountGreaterThanMaxlimit");
                                }
                            } else {
                                SetResultException(R, "AmountGreaterThanMaxlimit");
                            }
                        } else {
                            SetResultException(R, "AmountLessThanMinLimit");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodNotSupportDeposit");
                    }
                } else {
                    SetResultException(R, "PaymentMethodDisable");
                }
            } else {
                SetResultException(R, "PaymentMethodNotExist");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreatePayPalDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData paymentCommonData = new PaymentCommonData() { };

        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        string ExtraData;
        int MinLimit;
        int MaxLimit;
        decimal ReceiveTotalAmount;
        decimal ThresholdRate;
        decimal HandingFeeRate;
        int ExpireSecond;
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

            if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                    if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
                        MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                        MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];

                        if (Amount >= MinLimit) {
                            if (Amount <= MaxLimit || MaxLimit == 0) {
                                if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 0) {
                                    string OrderNumber = System.Guid.NewGuid().ToString();
                                    int InsertRet;

                                    PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                    PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                    ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];

                                    ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
                                    ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                    ExtraData = (string)PaymentMethodDT.Rows[0]["ExtraData"];

                                    if (string.IsNullOrEmpty(ExtraData)) {
                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                    } else {
                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                        try {
                                            Newtonsoft.Json.Linq.JArray rangeRates = Newtonsoft.Json.Linq.JArray.Parse(ExtraData);
                                            foreach (var rangeRate in rangeRates) {
                                                decimal RangeMinValuie = (decimal)rangeRate["RangeMinValuie"];
                                                decimal RangeMaxValuie = (decimal)rangeRate["RangeMaxValuie"];

                                                if (RangeMaxValuie != 0) {
                                                    if (RangeMinValuie <= Amount && Amount < RangeMaxValuie) {
                                                        HandingFeeRate = (decimal)rangeRate["RangeRate"];
                                                        break;
                                                    }
                                                } else {
                                                    if (RangeMinValuie <= Amount) {
                                                        HandingFeeRate = (decimal)rangeRate["RangeRate"];
                                                        break;
                                                    }
                                                }
                                            }
                                        } catch (Exception) {
                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                        }
                                    }
                                    ReceiveTotalAmount = Amount * (1 + HandingFeeRate);

                                    paymentCommonData.PaymentType = 0;
                                    paymentCommonData.BasicType = 0;
                                    paymentCommonData.OrderNumber = OrderNumber;
                                    paymentCommonData.LoginAccount = SI.LoginAccount;
                                    paymentCommonData.Amount = Amount;
                                    paymentCommonData.HandingFeeRate = HandingFeeRate;
                                    paymentCommonData.HandingFeeAmount = 0;
                                    paymentCommonData.ReceiveCurrencyType = ReceiveCurrencyType;
                                    paymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                    paymentCommonData.ExpireSecond = ExpireSecond;
                                    paymentCommonData.PaymentMethodID = PaymentMethodID;
                                    paymentCommonData.PaymentMethodName = PaymentMethodName;
                                    paymentCommonData.PaymentCode = PaymentCode;
                                    paymentCommonData.ThresholdRate = ThresholdRate;
                                    paymentCommonData.ThresholdValue = Amount * ThresholdRate;
                                    paymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");


                                    InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, paymentCommonData.PaymentType, 0, paymentCommonData.LoginAccount, paymentCommonData.Amount, paymentCommonData.HandingFeeRate, paymentCommonData.HandingFeeAmount, paymentCommonData.ThresholdRate, paymentCommonData.ThresholdValue, paymentCommonData.PaymentMethodID, "", "", "", paymentCommonData.ExpireSecond);

                                    if (InsertRet == 1) {
                                        R.Result = enumResult.OK;
                                        R.Data = paymentCommonData;
                                        RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(paymentCommonData), paymentCommonData.OrderNumber);
                                    } else {
                                        SetResultException(R, "InsertFailure");
                                    }
                                } else {
                                    SetResultException(R, "PaymentMethodNotCrypto");
                                }
                            } else {
                                SetResultException(R, "AmountGreaterThanMaxlimit");
                            }
                        } else {
                            SetResultException(R, "AmountLessThanMinLimit");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodNotSupportDeposit");
                    }
                } else {
                    SetResultException(R, "PaymentMethodDisable");
                }
            } else {
                SetResultException(R, "PaymentMethodNotExist");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateEPayDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData paymentCommonData = new PaymentCommonData() { };

        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        string ExtraData;
        int MinLimit;
        int MaxLimit;
        decimal ReceiveTotalAmount;
        decimal ThresholdRate;
        decimal HandingFeeRate;
        int ExpireSecond;
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

            if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                    if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
                        MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                        MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];

                        if (Amount >= MinLimit) {
                            if (Amount <= MaxLimit || MaxLimit == 0) {
                                if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 1) {
                                    string OrderNumber = System.Guid.NewGuid().ToString();
                                    int InsertRet;

                                    PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                    PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                    ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];

                                    ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
                                    ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                    ExtraData = (string)PaymentMethodDT.Rows[0]["ExtraData"];

                                    if (string.IsNullOrEmpty(ExtraData)) {
                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                    } else {
                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                        try {
                                            Newtonsoft.Json.Linq.JArray rangeRates = Newtonsoft.Json.Linq.JArray.Parse(ExtraData);
                                            foreach (var rangeRate in rangeRates) {
                                                decimal RangeMinValuie = (decimal)rangeRate["RangeMinValuie"];
                                                decimal RangeMaxValuie = (decimal)rangeRate["RangeMaxValuie"];

                                                if (RangeMaxValuie != 0) {
                                                    if (RangeMinValuie <= Amount && Amount < RangeMaxValuie) {
                                                        HandingFeeRate = (decimal)rangeRate["RangeRate"];
                                                        break;
                                                    }
                                                } else {
                                                    if (RangeMinValuie <= Amount) {
                                                        HandingFeeRate = (decimal)rangeRate["RangeRate"];
                                                        break;
                                                    }
                                                }
                                            }
                                        } catch (Exception) {
                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                        }
                                    }
                                    ReceiveTotalAmount = Amount * (1 + HandingFeeRate);

                                    paymentCommonData.PaymentType = 0;
                                    paymentCommonData.BasicType = 0;
                                    paymentCommonData.OrderNumber = OrderNumber;
                                    paymentCommonData.LoginAccount = SI.LoginAccount;
                                    paymentCommonData.Amount = Amount;
                                    paymentCommonData.HandingFeeRate = HandingFeeRate;
                                    paymentCommonData.HandingFeeAmount = 0;
                                    paymentCommonData.ReceiveCurrencyType = ReceiveCurrencyType;
                                    paymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                    paymentCommonData.ExpireSecond = ExpireSecond;
                                    paymentCommonData.PaymentMethodID = PaymentMethodID;
                                    paymentCommonData.PaymentMethodName = PaymentMethodName;
                                    paymentCommonData.PaymentCode = PaymentCode;
                                    paymentCommonData.ThresholdRate = ThresholdRate;
                                    paymentCommonData.ThresholdValue = Amount * ThresholdRate;
                                    paymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");


                                    InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, paymentCommonData.PaymentType, 0, paymentCommonData.LoginAccount, paymentCommonData.Amount, paymentCommonData.HandingFeeRate, paymentCommonData.HandingFeeAmount, paymentCommonData.ThresholdRate, paymentCommonData.ThresholdValue, paymentCommonData.PaymentMethodID, "", "", "", paymentCommonData.ExpireSecond);

                                    if (InsertRet == 1) {
                                        R.Result = enumResult.OK;
                                        R.Data = paymentCommonData;
                                        RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(paymentCommonData), paymentCommonData.OrderNumber);
                                    } else {
                                        SetResultException(R, "InsertFailure");
                                    }
                                } else {
                                    SetResultException(R, "PaymentMethodNotCrypto");
                                }
                            } else {
                                SetResultException(R, "AmountGreaterThanMaxlimit");
                            }
                        } else {
                            SetResultException(R, "AmountLessThanMinLimit");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodNotSupportDeposit");
                    }
                } else {
                    SetResultException(R, "PaymentMethodDisable");
                }
            } else {
                SetResultException(R, "PaymentMethodNotExist");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult ConfirmEPayDeposit(string WebSID, string GUID, string OrderNumber, string[] ActivityNames, string Lang, string PaymentType, int RequestType = 0)
    {
        //PaymentType:0=EWIN PAY 回傳URL /1=FORMPOST導頁 
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData TempCommonData;
        RedisCache.SessionContext.SIDInfo SI;
        EWinTagInfoData tagInfoData = new EWinTagInfoData() { };
        string JoinActivityFailedMsg = string.Empty;
        decimal PointValue;
        string ReceiveCurrencyType;
        string Decription = "";
        dynamic o = null;
        decimal JPYRate = 0;
        System.Data.DataTable DT;
        EWin.Payment.PaymentDetailInheritsBase[] p;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID))
        {
            //取得Temp(未確認)訂單
            TempCommonData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);

            if (TempCommonData != null)
            {
                tagInfoData.PaymentMethodID = TempCommonData.PaymentMethodID;
                tagInfoData.PaymentCode = TempCommonData.PaymentCode;
                tagInfoData.PaymentMethodName = TempCommonData.PaymentMethodName;
                tagInfoData.ThresholdRate = TempCommonData.ThresholdRate;
                tagInfoData.ThresholdValue = TempCommonData.ThresholdValue;
                PointValue = TempCommonData.Amount;
                ReceiveCurrencyType = TempCommonData.ReceiveCurrencyType;

                if (PaymentType == "EPay")
                {
                    Decription = TempCommonData.PaymentMethodName + ", ReceiveTotalAmount=" + TempCommonData.ReceiveTotalAmount.ToString("F10");
                }
                else if (PaymentType == "GASH")
                {
                    Decription = TempCommonData.PaymentMethodName + ", ReceiveTotalAmount=" + TempCommonData.ReceiveTotalAmount.ToString("F10");
                }
                else
                {
                    SetResultException(R, "PaymentType Error");
                    return R;
                }

                if (ActivityNames.Length > 0)
                {
                    tagInfoData.IsJoinDepositActivity = true;
                    tagInfoData.ActivityDatas = new List<EWinTagInfoActivityData>();
                    //有儲值參加活動
                    foreach (var ActivityName in ActivityNames)
                    {
                        ActivityCore.ActResult<ActivityCore.DepositActivity> activityDepositResult = ActivityCore.GetDepositResult(ActivityName, TempCommonData.Amount, TempCommonData.PaymentCode, TempCommonData.LoginAccount);

                        if (activityDepositResult.Result == ActivityCore.enumActResult.OK)
                        {
                            EWinTagInfoActivityData infoActivityData = new EWinTagInfoActivityData()
                            {
                                ActivityName = ActivityName,
                                BonusRate = activityDepositResult.Data.BonusRate,
                                BonusValue = activityDepositResult.Data.BonusValue,
                                ThresholdRate = activityDepositResult.Data.ThresholdRate,
                                ThresholdValue = activityDepositResult.Data.ThresholdValue,
                                JoinActivityCycle = activityDepositResult.Data.JoinActivityCycle == null ? "1" : activityDepositResult.Data.JoinActivityCycle,
                                CollectAreaType = activityDepositResult.Data.CollectAreaType == null ? "1" : activityDepositResult.Data.CollectAreaType
                            };
                            //PointValue += activityDepositResult.Data.BonusValue;
                            tagInfoData.ActivityDatas.Add(infoActivityData);
                        }
                        else
                        {
                            JoinActivityFailedMsg += "Join " + ActivityName + " Failed,";
                            break;
                        }
                    }
                }
                else
                {
                    tagInfoData.IsJoinDepositActivity = false;
                    //沒參加儲值活動
                }

                if (string.IsNullOrEmpty(JoinActivityFailedMsg))
                {

                    //準備送出至EWin

                    EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
                    EWin.Payment.PaymentResult paymentResult;
                    List<EWin.Payment.PaymentDetailBankCard> paymentDetailBankCards = new List<EWin.Payment.PaymentDetailBankCard>();
                    List<EWin.Payment.PaymentDetailWallet> paymentDetailWallets = new List<EWin.Payment.PaymentDetailWallet>();
                    EWin.Payment.PaymentDetailBankCard paymentDetailBankCard = new EWin.Payment.PaymentDetailBankCard()
                    {
                        DetailType = EWin.Payment.enumDetailType.Bankcard,
                        Status = EWin.Payment.enumBankCardStatus.None,
                        BankCardType = EWin.Payment.enumBankCardType.UserAccountBankCard,
                        BankCode = "",
                        BankName = "",
                        BranchName = "",
                        BankNumber = "",
                        AccountName = "",
                        AmountMax = 9999999999,
                        BankCardGUID = Guid.NewGuid().ToString("N"),
                        Description = "",
                        CashAmount = 0,
                        TaxFeeValue = 0
                        //TaxFeeValue = (TempCryptoData.Amount*ProviderHandingFeeRate)+ProviderHandingFeeAmount
                    };

                    if (PaymentType == "EPayJKC")
                    {
                        DT = RedisCache.PaymentMethod.GetPaymentMethodByCategory("EPAYJKC");
                        var MultiCurrencyInfo = (string)DT.Select("PaymentCategoryCode='" + "EPAYJKC" + "'")[0]["MultiCurrencyInfo"];
                        Newtonsoft.Json.Linq.JArray MultiCurrency = Newtonsoft.Json.Linq.JArray.Parse(MultiCurrencyInfo);
                        for (int i = 0; i < MultiCurrency.Count; i++)
                        {
                            if ((string)MultiCurrency[i]["Currency"] == "JPY")
                            {
                                JPYRate = (decimal)MultiCurrency[i]["Rate"];
                            }
                        }
                        paymentDetailBankCard.CashAmount = JPYRate * TempCommonData.Amount;
                        paymentDetailBankCard.TaxFeeValue = (JPYRate * TempCommonData.Amount) * TempCommonData.ProviderHandingFeeRate;
                        p = new EWin.Payment.PaymentDetailInheritsBase[2];

                        for (int i = 0; i < TempCommonData.PaymentCryptoDetailList.Count; i++)
                        {
                            if (TempCommonData.PaymentCryptoDetailList[i].TokenCurrencyType == "JKC")
                            {
                                EWin.Payment.PaymentDetailWallet paymentDetailWallet = new EWin.Payment.PaymentDetailWallet()
                                {
                                    DetailType = EWin.Payment.enumDetailType.BitCoinWallet,
                                    WalletType = (EWin.Payment.enumWalletType)TempCommonData.WalletType,
                                    Status = EWin.Payment.enumDetailWalletStatus.DetailCreated,
                                    ToWalletAddress = "",
                                    TokenName = TempCommonData.PaymentCryptoDetailList[i].TokenCurrencyType,
                                    TokenContractAddress = TempCommonData.PaymentCryptoDetailList[i].TokenContractAddress,
                                    TokenAmount = TempCommonData.PaymentCryptoDetailList[i].ReceiveAmount
                                };
                                p[0] = paymentDetailWallet;
                            }

                        }

                        p[1] = paymentDetailBankCard;
                    }
                    else
                    {
                        paymentDetailBankCard.CashAmount = TempCommonData.Amount;
                        paymentDetailBankCard.TaxFeeValue = TempCommonData.Amount * TempCommonData.ProviderHandingFeeRate;

                        p = new EWin.Payment.PaymentDetailInheritsBase[1];
                        p[0] = paymentDetailBankCard;
                    }

                    paymentResult = paymentAPI.CreatePaymentDeposit(GetToken(), TempCommonData.LoginAccount, GUID, EWinWeb.MainCurrencyType, OrderNumber, TempCommonData.Amount,paymentDetailBankCard.TaxFeeValue ,Decription, true, PointValue, TempCommonData.PaymentCode, CodingControl.GetUserIP(), TempCommonData.ExpireSecond, p);
                    if (paymentResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                    {
                        EWin.Payment.Result updateTagResult = paymentAPI.UpdateTagInfo(GetToken(), GUID, paymentResult.PaymentSerial, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData));

                        if (updateTagResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                        {
                            if (RequestType == 0)
                            {
                                EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                                EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
                                var CreateEPayDepositeReturn = Payment.EPay.CreateEPayDeposite(paymentResult.PaymentSerial, TempCommonData.Amount, PaymentType, TempCommonData.ToInfo, userInfoResult.ContactPhoneNumber);
                                if (CreateEPayDepositeReturn.ResultState == Payment.APIResult.enumResultCode.OK)
                                {
                                    int UpdateRet = EWinWebDB.UserAccountPayment.ConfirmPayment(OrderNumber, TempCommonData.ToInfo, paymentResult.PaymentSerial, "", PointValue, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData.ActivityDatas));

                                    if (UpdateRet == 1)
                                    {
                                        R.Result = enumResult.OK;
                                        R.Data = TempCommonData;
                                        R.Message = CreateEPayDepositeReturn.Message;
                                        TempCommonData.PaymentSerial = paymentResult.PaymentSerial;
                                        TempCommonData.ActivityDatas = tagInfoData.ActivityDatas;
                                        TempCommonData.PointValue = PointValue;

                                        //RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(TempCommonData), OrderNumber, TempCommonData.ExpireSecond);
                                        //RedisCache.PaymentContent.KeepPaymentContents(TempCommonData, SI.LoginAccount);
                                    }
                                    else
                                    {
                                        SetResultException(R, "UpdateFailure1");
                                    }
                                }
                                else
                                {
                                    SetResultException(R, "UpdateFailure2");
                                }
                            }
                            else
                            {
                                R.Result = enumResult.OK;
                                R.Data = TempCommonData;
                                TempCommonData.PaymentSerial = paymentResult.PaymentSerial;
                                TempCommonData.ActivityDatas = tagInfoData.ActivityDatas;
                                TempCommonData.PointValue = PointValue;
                            }

                        }
                        else
                        {
                            SetResultException(R, updateTagResult.ResultMessage);
                            paymentAPI.CancelPayment(GetToken(), GUID, paymentResult.PaymentSerial);
                        }
                    }
                    else
                    {
                        SetResultException(R, paymentResult.ResultMessage);
                    }

                }
                else
                {
                    JoinActivityFailedMsg = JoinActivityFailedMsg.Substring(0, JoinActivityFailedMsg.Length - 1);
                    SetResultException(R, JoinActivityFailedMsg);
                }
            }
            else
            {
                SetResultException(R, "OrderNotExist");
            }
        }
        else
        {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult ConfirmBankCardDeposit(string WebSID, string GUID, string OrderNumber, string[] ActivityNames, string Lang,string PaymentSerial) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData TempCommonData;
        RedisCache.SessionContext.SIDInfo SI;
        EWinTagInfoData tagInfoData = new EWinTagInfoData() { };
        string JoinActivityFailedMsg = string.Empty;
        decimal PointValue;
        string ReceiveCurrencyType;

        dynamic o = null;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            //取得Temp(未確認)訂單
            TempCommonData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);

            if (TempCommonData != null) {
                tagInfoData.PaymentMethodID = TempCommonData.PaymentMethodID;
                tagInfoData.PaymentCode = TempCommonData.PaymentCode;
                tagInfoData.PaymentMethodName = TempCommonData.PaymentMethodName;
                tagInfoData.ThresholdRate = TempCommonData.ThresholdRate;
                tagInfoData.ThresholdValue = TempCommonData.ThresholdValue;
                PointValue = TempCommonData.Amount;
                ReceiveCurrencyType = TempCommonData.ReceiveCurrencyType;

                if (ActivityNames.Length > 0) {
                    tagInfoData.IsJoinDepositActivity = true;
                    tagInfoData.ActivityDatas = new List<EWinTagInfoActivityData>();
                    //有儲值參加活動
                    foreach (var ActivityName in ActivityNames) {
                        ActivityCore.ActResult<ActivityCore.DepositActivity> activityDepositResult = ActivityCore.GetDepositResult(ActivityName, TempCommonData.Amount, TempCommonData.PaymentCode, TempCommonData.LoginAccount);

                        if (activityDepositResult.Result == ActivityCore.enumActResult.OK) {
                            EWinTagInfoActivityData infoActivityData = new EWinTagInfoActivityData() {
                                ActivityName = ActivityName,
                                BonusRate = activityDepositResult.Data.BonusRate,
                                BonusValue = activityDepositResult.Data.BonusValue,
                                ThresholdRate = activityDepositResult.Data.ThresholdRate,
                                ThresholdValue = activityDepositResult.Data.ThresholdValue,
                            };
                            PointValue += activityDepositResult.Data.BonusValue;
                            tagInfoData.ActivityDatas.Add(infoActivityData);
                        } else {
                            JoinActivityFailedMsg += "Join " + ActivityName + " Failed,";
                            break;
                        }
                    }
                } else {
                    tagInfoData.IsJoinDepositActivity = false;
                    //沒參加儲值活動
                }

                if (string.IsNullOrEmpty(JoinActivityFailedMsg)) {

                    //準備送出至EWin

                    EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();

                    string Decription = TempCommonData.PaymentMethodName + ", ReceiveTotalAmount=" + TempCommonData.ReceiveTotalAmount.ToString("F10");


                    EWin.Payment.Result updateTagResult = paymentAPI.UpdateTagInfo(GetToken(), GUID, PaymentSerial, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData));

                    if (updateTagResult.ResultStatus == EWin.Payment.enumResultStatus.OK) {

                        int UpdateRet = EWinWebDB.UserAccountPayment.ConfirmPayment(OrderNumber, "", PaymentSerial, "", PointValue, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData.ActivityDatas));

                        if (UpdateRet == 1) {
                            R.Result = enumResult.OK;
                            R.Data = TempCommonData;
                            TempCommonData.PaymentSerial = PaymentSerial;
                            TempCommonData.ActivityDatas = tagInfoData.ActivityDatas;
                            TempCommonData.PointValue = PointValue;

                            RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(TempCommonData), OrderNumber, TempCommonData.ExpireSecond);
                            RedisCache.PaymentContent.KeepPaymentContents(TempCommonData, SI.LoginAccount);
                        } else {
                            SetResultException(R, "UpdateFailure");
                        }
                    } else {
                        SetResultException(R, updateTagResult.ResultMessage);
                        paymentAPI.CancelPayment(GetToken(), GUID, PaymentSerial);
                    }


                } else {
                    JoinActivityFailedMsg = JoinActivityFailedMsg.Substring(0, JoinActivityFailedMsg.Length - 1);
                    SetResultException(R, JoinActivityFailedMsg);
                }
            } else {
                SetResultException(R, "OrderNotExist");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonBankCardResult CreateBankCardDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
        PaymentCommonBankCardResult R = new PaymentCommonBankCardResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData paymentCommonData = new PaymentCommonData() { };
        PaymentCommonBankData paymentBankCommonData = new PaymentCommonBankData() { };
        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        string ExtraData;
        int MinLimit;
        int MaxLimit;
        decimal ReceiveTotalAmount;
        decimal ThresholdRate;
        decimal HandingFeeRate;
        int ExpireSecond;
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

            if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                    if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
                        MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                        MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];

                        if (Amount >= MinLimit) {
                            if (Amount <= MaxLimit || MaxLimit == 0) {
                                if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 1) {
                                    string OrderNumber = System.Guid.NewGuid().ToString();
                                    int InsertRet;

                                    PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                    PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                    ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];

                                    ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
                                    ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                    ExtraData = (string)PaymentMethodDT.Rows[0]["ExtraData"];

                                    if (string.IsNullOrEmpty(ExtraData)) {
                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                    } else {
                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                        try {
                                            Newtonsoft.Json.Linq.JArray rangeRates = Newtonsoft.Json.Linq.JArray.Parse(ExtraData);
                                            foreach (var rangeRate in rangeRates) {
                                                decimal RangeMinValuie = (decimal)rangeRate["RangeMinValuie"];
                                                decimal RangeMaxValuie = (decimal)rangeRate["RangeMaxValuie"];

                                                if (RangeMaxValuie != 0) {
                                                    if (RangeMinValuie <= Amount && Amount < RangeMaxValuie) {
                                                        HandingFeeRate = (decimal)rangeRate["RangeRate"];
                                                        break;
                                                    }
                                                } else {
                                                    if (RangeMinValuie <= Amount) {
                                                        HandingFeeRate = (decimal)rangeRate["RangeRate"];
                                                        break;
                                                    }
                                                }
                                            }
                                        } catch (Exception) {
                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                        }
                                    }
                                    ReceiveTotalAmount = Amount * (1 + HandingFeeRate);

                                    paymentCommonData.PaymentType = 0;
                                    paymentCommonData.BasicType = 1;
                                    paymentCommonData.OrderNumber = OrderNumber;
                                    paymentCommonData.LoginAccount = SI.LoginAccount;
                                    paymentCommonData.Amount = Amount;
                                    paymentCommonData.HandingFeeRate = HandingFeeRate;
                                    paymentCommonData.HandingFeeAmount = 0;
                                    paymentCommonData.ReceiveCurrencyType = ReceiveCurrencyType;
                                    paymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                    paymentCommonData.ExpireSecond = ExpireSecond;
                                    paymentCommonData.PaymentMethodID = PaymentMethodID;
                                    paymentCommonData.PaymentMethodName = PaymentMethodName;
                                    paymentCommonData.PaymentCode = PaymentCode;
                                    paymentCommonData.ThresholdRate = ThresholdRate;
                                    paymentCommonData.ThresholdValue = Amount * ThresholdRate;
                                    paymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");

                                    EWin.EWinWeb.EWinWeb _CASINO3651API = new EWin.EWinWeb.EWinWeb();

                                    //PaymentMethod 0=上分/1=下分
                                    EWin.EWinWeb.BankCardDepositResult bankCardDepositRet= _CASINO3651API.BankCardDepostit(SI.EWinCT,GUID,EWinWeb.MainCurrencyType,0,Amount,"",OrderNumber);

                                    if (bankCardDepositRet.ResultState == EWin.EWinWeb.enumResultState.OK)
                                    {
                                        paymentBankCommonData.BankCode = bankCardDepositRet.BankCardInfo.BankCode;
                                        paymentBankCommonData.BankName=bankCardDepositRet.BankCardInfo.BankName;
                                        paymentBankCommonData.AmountMax = bankCardDepositRet.BankCardInfo.AmountMax;
                                        paymentBankCommonData.AccountName=bankCardDepositRet.BankCardInfo.AccountName;
                                        paymentBankCommonData.BankNumber = bankCardDepositRet.BankCardInfo.BankNumber;
                                        paymentBankCommonData.BranchName=bankCardDepositRet.BankCardInfo.BranchName;
                                        paymentBankCommonData.PaymentSerial=bankCardDepositRet.PaymentSerial;
                                        InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, paymentCommonData.PaymentType, 0, paymentCommonData.LoginAccount, paymentCommonData.Amount, paymentCommonData.HandingFeeRate, paymentCommonData.HandingFeeAmount, paymentCommonData.ThresholdRate, paymentCommonData.ThresholdValue, paymentCommonData.PaymentMethodID, "", "", "", paymentCommonData.ExpireSecond);

                                        if (InsertRet == 1)
                                        {
                                            R.Result = enumResult.OK;
                                            R.Data = paymentCommonData;
                                            R.BankData = paymentBankCommonData;
                                            RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(paymentCommonData), paymentCommonData.OrderNumber);
                                        }
                                        else
                                        {
                                            SetResultException(R, "InsertFailure");
                                        }
                                    }
                                    else
                                    {
                                        SetResultException(R, "InsertFailure");
                                    }

                                } else {
                                    SetResultException(R, "PaymentMethodNotCrypto");
                                }
                            } else {
                                SetResultException(R, "AmountGreaterThanMaxlimit");
                            }
                        } else {
                            SetResultException(R, "AmountLessThanMinLimit");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodNotSupportDeposit");
                    }
                } else {
                    SetResultException(R, "PaymentMethodDisable");
                }
            } else {
                SetResultException(R, "PaymentMethodNotExist");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateBankCardWithdrawal(string WebSID, string GUID, decimal Amount)
    {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData PaymentCommonData = new PaymentCommonData() { PaymentCryptoDetailList = new List<CryptoDetail>() };

        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        int MinLimit;
        int MaxLimit;
        int DailyMaxAmount;
        int DailyMaxCount;
        decimal ReceiveTotalAmount;
        decimal HandingFeeRate;
        int HandingFeeAmount;
        decimal WithdrawalAmountByDay;
        int WithdrawalCountByDay;
        int ExpireSecond;
        int DecimalPlaces;
        int PaymentMethodID;
        System.Data.DataTable PaymentMethodDT;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID))
        {
            if (EWinWeb.CheckInWithdrawalTime())
            {
                if (!EWinWeb.IsWithdrawlTemporaryMaintenance())
                {

                    PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByCategory("BankCard");
                    var PaymentMethodRow=PaymentMethodDT.Select("PaymentType=1").FirstOrDefault();

                    if (PaymentMethodRow != null )
                    {
                        if ((int)PaymentMethodRow["State"] == 0)
                        {
                            if ((int)PaymentMethodRow["PaymentType"] == 1)
                            {
                                MinLimit = (int)PaymentMethodRow["MinLimit"];
                                MaxLimit = (int)PaymentMethodRow["MaxLimit"];
                                DailyMaxCount = (int)PaymentMethodRow["DailyMaxCount"];
                                DailyMaxAmount = (int)PaymentMethodRow["DailyMaxAmount"];
                                DecimalPlaces = (int)PaymentMethodRow["DecimalPlaces"];
                                PaymentMethodID= (int)PaymentMethodRow["PaymentMethodID"];
                                if (Amount >= MinLimit)
                                {
                                    if (Amount <= MaxLimit || MaxLimit == 0)
                                    {
                                        System.Data.DataTable SummaryDT = EWinWebDB.UserAccountPayment.GetTodayPaymentByLoginAccount(SI.LoginAccount, 1);

                                        if (SummaryDT != null && SummaryDT.Rows.Count > 0)
                                        {
                                            WithdrawalAmountByDay = 0;
                                            foreach (System.Data.DataRow dr in SummaryDT.Rows)
                                            {
                                                WithdrawalAmountByDay += (decimal)dr["Amount"];
                                            }
                                            WithdrawalCountByDay = SummaryDT.Rows.Count;
                                        }
                                        else
                                        {
                                            WithdrawalAmountByDay = 0;
                                            WithdrawalCountByDay = 0;
                                        }

                                        if (DailyMaxCount == 0 || (WithdrawalCountByDay + 1) <= DailyMaxCount)
                                        {
                                            if (DailyMaxAmount == 0 || (WithdrawalAmountByDay + Amount) <= DailyMaxAmount)
                                            {
                                                if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 1)
                                                {
                                                    //Check ThresholdValue
                                                    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                                                    EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
                                                    EWin.Lobby.ThresholdInfo thresholdInfo;
                                                    decimal thresholdValue;

                                                    if (userInfoResult.Result == EWin.Lobby.enumResult.OK)
                                                    {
                                                        thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

                                                        if (thresholdInfo != null)
                                                        {
                                                            thresholdValue = thresholdInfo.ThresholdValue;
                                                        }
                                                        else
                                                        {
                                                            thresholdValue = 0;
                                                        }
                                                        if (thresholdValue == 0)
                                                        {
                                                            PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                                            PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                                            ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
                                                            ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                                            HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
                                                            ReceiveTotalAmount = (Amount * (1 - (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) - HandingFeeAmount;


                                                            string OrderNumber = System.Guid.NewGuid().ToString();
                                                            int InsertRet;

                                                            PaymentCommonData.PaymentType = 1;
                                                            PaymentCommonData.BasicType = 1;
                                                            PaymentCommonData.OrderNumber = OrderNumber;
                                                            PaymentCommonData.LoginAccount = SI.LoginAccount;
                                                            PaymentCommonData.Amount = Amount;
                                                            PaymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                                            PaymentCommonData.HandingFeeRate = HandingFeeRate;
                                                            PaymentCommonData.HandingFeeAmount = HandingFeeAmount;
                                                            PaymentCommonData.ExpireSecond = ExpireSecond;
                                                            PaymentCommonData.PaymentMethodID = PaymentMethodID;
                                                            PaymentCommonData.PaymentMethodName = PaymentMethodName;
                                                            PaymentCommonData.PaymentCode = PaymentCode;
                                                            PaymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");

                                                            InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, PaymentCommonData.PaymentType, 1, PaymentCommonData.LoginAccount, PaymentCommonData.Amount, PaymentCommonData.HandingFeeRate, PaymentCommonData.HandingFeeAmount, 0, 0, PaymentCommonData.PaymentMethodID, "", "", "", PaymentCommonData.ExpireSecond);

                                                            if (InsertRet == 1)
                                                            {
                                                                R.Result = enumResult.OK;
                                                                R.Data = PaymentCommonData;
                                                                RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(R.Data), PaymentCommonData.OrderNumber);
                                                            }
                                                            else
                                                            {
                                                                SetResultException(R, "InsertFailure");
                                                            }

                                                        }
                                                        else
                                                        {
                                                            SetResultException(R, "ThresholdLimit");
                                                        }
                                                    }
                                                    else
                                                    {
                                                        SetResultException(R, "GetInfoError");
                                                    }

                                                }
                                                else
                                                {
                                                    SetResultException(R, "PaymentMethodNotCrypto");
                                                }

                                            }
                                            else
                                            {
                                                SetResultException(R, "DailyAmountGreaterThanMaxlimit");
                                            }
                                        }
                                        else
                                        {
                                            SetResultException(R, "DailyCountGreaterThanMaxlimit");
                                        }
                                    }
                                    else
                                    {
                                        SetResultException(R, "AmountGreaterThanMaxlimit");
                                    }
                                }
                                else
                                {
                                    SetResultException(R, "AmountLessThanMinLimit");
                                }
                            }
                            else
                            {
                                SetResultException(R, "PaymentMethodNotSupportDeposit");
                            }
                        }
                        else
                        {
                            SetResultException(R, "PaymentMethodDisable");
                        }
                    }
                    else
                    {
                        SetResultException(R, "PaymentMethodNotExist");
                    }
                }
                else
                {
                    SetResultException(R, "WithdrawlTemporaryMaintenance");
                }
            }
            else
            {
                SetResultException(R, "NotInOpenTime");
            }
        }
        else
        {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public APIResult ConfirmBankCardWithdrawal(string WebSID, string GUID, string OrderNumber,string BankName,string BankBranchName,string BankCard,string BankCardName) {
        APIResult R = new APIResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData TempData;
        RedisCache.SessionContext.SIDInfo SI;
        decimal PointValue;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            if (EWinWeb.CheckInWithdrawalTime()) {
                if (!EWinWeb.IsWithdrawlTemporaryMaintenance()) {
                    //取得Temp(未確認)訂單
                    TempData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);

                    if (TempData != null) {
                        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                        EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
                        EWin.Lobby.ThresholdInfo thresholdInfo;


                        if (userInfoResult.Result == EWin.Lobby.enumResult.OK) {
                            thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

                            if (thresholdInfo != null) {
                                if (thresholdInfo.ThresholdValue == 0) {
                                    PointValue = TempData.Amount;

                                    EWin.Lobby.APIResult addUserBankCard = lobbyAPI.AddUserBankCard(GetToken(), SI.EWinSID, GUID,EWinWeb.MainCurrencyType,0,BankName,BankBranchName,BankCard,BankCardName,"");
                                    if (addUserBankCard.Result == EWin.Lobby.enumResult.OK || addUserBankCard.Message == "BankNumberExist")
                                    {
                                        EWin.Lobby.UserBankCardListResult userBankCardListResult = lobbyAPI.GetUserBankCard(GetToken(), SI.EWinSID, GUID);
                                        if (userBankCardListResult.Result == EWin.Lobby.enumResult.OK)
                                        {
                                            string BankCardGUID = userBankCardListResult.BankCardList.Where(s => s.CurrencyType == EWinWeb.MainCurrencyType && s.BankName == BankName && s.BankNumber == BankCard).First().BankCardGUID;

                                            EWin.EWinWeb.EWinWeb _CASINO3651API = new EWin.EWinWeb.EWinWeb();
                                            //PaymentMethod 0=銀行卡
                                            EWin.EWinWeb.BankCardWithdrawalResult bankCardWithdrawalRet= new EWin.EWinWeb.BankCardWithdrawalResult();

                                            if (bankCardWithdrawalRet.ResultState == EWin.EWinWeb.enumResultState.OK)
                                            {

                                                int UpdateRet = EWinWebDB.UserAccountPayment.ConfirmPayment(OrderNumber, "", bankCardWithdrawalRet.PaymentSerial, PointValue, "");

                                                if (UpdateRet == 1)
                                                {
                                                    R.Result = enumResult.OK;
                                                    R.Message = bankCardWithdrawalRet.PaymentSerial;
                                                    TempData.PaymentSerial = bankCardWithdrawalRet.PaymentSerial;
                                                    TempData.PointValue = PointValue;
                                                    RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(TempData), OrderNumber, TempData.ExpireSecond);
                                                    RedisCache.PaymentContent.KeepPaymentContents(TempData, SI.LoginAccount);
                                                }
                                                else
                                                {
                                                    SetResultException(R, "UpdateFailure");
                                                }

                                            }
                                            else
                                            {
                                                SetResultException(R, bankCardWithdrawalRet.Message);
                                            }
                                        }
                                        else
                                        {
                                            SetResultException(R, "GetUserBankCardFail");
                                        }
                                    }
                                    else
                                    {
                                        SetResultException(R, "GetUserBankCardFail");
                                    }
                                } else {
                                    SetResultException(R, "ThresholdLimit");
                                }
                            } else {
                                SetResultException(R, "CurrencyNotFound");
                            }
                        } else {
                            SetResultException(R, "GetThresholdError");
                        }
                    } else {
                        SetResultException(R, "OrderNotExist");
                    }
                } else {
                    SetResultException(R, "WithdrawlTemporaryMaintenance");
                }
            } else {
                SetResultException(R, "NotInOpenTime");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }
        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateCryptoWithdrawal(string WebSID, string GUID, decimal Amount, int PaymentMethodID, string ToWalletAddress) {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        PaymentCommonData PaymentCommonData = new PaymentCommonData() { PaymentCryptoDetailList = new List<CryptoDetail>() };

        RedisCache.SessionContext.SIDInfo SI;
        string PaymentMethodName;
        string PaymentCode;
        string ReceiveCurrencyType;
        string MultiCurrencyInfo;
        int MinLimit;
        int MaxLimit;
        int DailyMaxAmount;
        int DailyMaxCount;
        decimal ReceiveTotalAmount;
        decimal HandingFeeRate;
        int HandingFeeAmount;
        int WalletType;
        decimal WithdrawalAmountByDay;
        int WithdrawalCountByDay;
        int ExpireSecond;
        bool GetExchangeRateSuccess = true;
        int DecimalPlaces;
        System.Data.DataTable PaymentMethodDT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            if (EWinWeb.CheckInWithdrawalTime()) {
                if (!EWinWeb.IsWithdrawlTemporaryMaintenance()) {
                    PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

                    if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
                        if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
                            if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 1) {
                                MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
                                MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];
                                DailyMaxCount = (int)PaymentMethodDT.Rows[0]["DailyMaxCount"];
                                DailyMaxAmount = (int)PaymentMethodDT.Rows[0]["DailyMaxAmount"];
                                DecimalPlaces = (int)PaymentMethodDT.Rows[0]["DecimalPlaces"];
                                if (Amount >= MinLimit) {
                                    if (Amount <= MaxLimit || MaxLimit == 0) {
                                        System.Data.DataTable SummaryDT = EWinWebDB.UserAccountPayment.GetTodayPaymentByLoginAccount(SI.LoginAccount, 1);

                                        if (SummaryDT != null && SummaryDT.Rows.Count > 0) {
                                            WithdrawalAmountByDay = 0;
                                            foreach (System.Data.DataRow dr in SummaryDT.Rows) {
                                                WithdrawalAmountByDay += (decimal)dr["Amount"];
                                            }
                                            WithdrawalCountByDay = SummaryDT.Rows.Count;
                                        } else {
                                            WithdrawalAmountByDay = 0;
                                            WithdrawalCountByDay = 0;
                                        }

                                        if (DailyMaxCount == 0 || (WithdrawalCountByDay + 1) <= DailyMaxCount) {
                                            if (DailyMaxAmount == 0 || (WithdrawalAmountByDay + Amount) <= DailyMaxAmount) {
                                                if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 2) {
                                                    //Check ThresholdValue
                                                    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                                                    EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
                                                    EWin.Lobby.ThresholdInfo thresholdInfo;
                                                    decimal thresholdValue;

                                                    if (userInfoResult.Result == EWin.Lobby.enumResult.OK) {
                                                        thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

                                                        if (thresholdInfo != null) {
                                                            thresholdValue = thresholdInfo.ThresholdValue;
                                                        } else {
                                                            thresholdValue = 0;
                                                        }
                                                        if (thresholdValue == 0) {
                                                            PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
                                                            PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
                                                            ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
                                                            ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
                                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
                                                            HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
                                                            WalletType = (int)PaymentMethodDT.Rows[0]["EWinCryptoWalletType"];
                                                            MultiCurrencyInfo = (string)PaymentMethodDT.Rows[0]["MultiCurrencyInfo"];
                                                            ReceiveTotalAmount = (Amount * (1 - (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) - HandingFeeAmount;
                                                            if (!string.IsNullOrEmpty(MultiCurrencyInfo)) {
                                                                Newtonsoft.Json.Linq.JArray MultiCurrency = Newtonsoft.Json.Linq.JArray.Parse(MultiCurrencyInfo);

                                                                foreach (var item in MultiCurrency) {
                                                                    string TokenCurrency;
                                                                    decimal ExchangeRate;
                                                                    decimal PartialRate;

                                                                    TokenCurrency = item["Currency"].ToString();
                                                                    ExchangeRate = CryptoExpand.GetCryptoExchangeRate(TokenCurrency);
                                                                    if (!int.TryParse(item["DecimalPlaces"].ToString(),out DecimalPlaces))
                                                                    {
                                                                        DecimalPlaces = 6;
                                                                    }

                                                                    if (ExchangeRate == 0) {
                                                                        //表示取得匯率失敗
                                                                        GetExchangeRateSuccess = false;
                                                                        break;
                                                                    } else {
                                                                        PartialRate = (decimal)item["Rate"];

                                                                        CryptoDetail Dcd = new CryptoDetail() {
                                                                            TokenCurrencyType = TokenCurrency,
                                                                            TokenContractAddress = item["TokenContractAddress"].ToString(),
                                                                            ExchangeRate = CodingControl.FormatDecimal(ExchangeRate, DecimalPlaces),
                                                                            PartialRate = PartialRate,
                                                                            ReceiveAmount = CodingControl.FormatDecimal(ReceiveTotalAmount * PartialRate * ExchangeRate, DecimalPlaces)
                                                                        };

                                                                        PaymentCommonData.PaymentCryptoDetailList.Add(Dcd);

                                                                    }
                                                                }
                                                            } else {
                                                                decimal ExchangeRate;
                                                                decimal ReceiveAmount;

                                                                ExchangeRate = CryptoExpand.GetCryptoExchangeRate(ReceiveCurrencyType);
                                                                ReceiveAmount = Amount * ExchangeRate;

                                                                if (ExchangeRate == 0) {
                                                                    //表示取得匯率失敗
                                                                    GetExchangeRateSuccess = false;
                                                                } else {
                                                                    CryptoDetail Dcd = new CryptoDetail() {
                                                                        TokenCurrencyType = ReceiveCurrencyType,
                                                                        TokenContractAddress = (string)PaymentMethodDT.Rows[0]["TokenContractAddress"],
                                                                        ExchangeRate = CodingControl.FormatDecimal(ExchangeRate, DecimalPlaces),
                                                                        PartialRate = 1,
                                                                        ReceiveAmount = CodingControl.FormatDecimal(ReceiveTotalAmount * 1 * ExchangeRate, DecimalPlaces),
                                                                    };

                                                                    PaymentCommonData.PaymentCryptoDetailList.Add(Dcd);
                                                                }
                                                            }

                                                            if (GetExchangeRateSuccess) {
                                                                string OrderNumber = System.Guid.NewGuid().ToString();
                                                                int InsertRet;

                                                                PaymentCommonData.PaymentType = 1;
                                                                PaymentCommonData.BasicType = 2;
                                                                PaymentCommonData.WalletType = WalletType;
                                                                PaymentCommonData.OrderNumber = OrderNumber;
                                                                PaymentCommonData.LoginAccount = SI.LoginAccount;
                                                                PaymentCommonData.Amount = Amount;
                                                                PaymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
                                                                PaymentCommonData.HandingFeeRate = HandingFeeRate;
                                                                PaymentCommonData.HandingFeeAmount = HandingFeeAmount;
                                                                PaymentCommonData.ExpireSecond = ExpireSecond;
                                                                PaymentCommonData.PaymentMethodID = PaymentMethodID;
                                                                PaymentCommonData.PaymentMethodName = PaymentMethodName;
                                                                PaymentCommonData.PaymentCode = PaymentCode;
                                                                PaymentCommonData.ToWalletAddress = ToWalletAddress;
                                                                PaymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");

                                                                InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, PaymentCommonData.PaymentType, 2, PaymentCommonData.LoginAccount, PaymentCommonData.Amount, PaymentCommonData.HandingFeeRate, PaymentCommonData.HandingFeeAmount, 0, 0, PaymentCommonData.PaymentMethodID, "", "", Newtonsoft.Json.JsonConvert.SerializeObject(PaymentCommonData.PaymentCryptoDetailList), PaymentCommonData.ExpireSecond);

                                                                if (InsertRet == 1) {
                                                                    R.Result = enumResult.OK;
                                                                    R.Data = PaymentCommonData;
                                                                    RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(R.Data), PaymentCommonData.OrderNumber);
                                                                } else {
                                                                    SetResultException(R, "InsertFailure");
                                                                }
                                                            } else {
                                                                SetResultException(R, "GetExchangeFailed");
                                                            }
                                                        } else {
                                                            SetResultException(R, "ThresholdLimit");
                                                        }
                                                    } else {
                                                        SetResultException(R, "GetInfoError");
                                                    }

                                                } else {
                                                    SetResultException(R, "PaymentMethodNotCrypto");
                                                }

                                            } else {
                                                SetResultException(R, "DailyAmountGreaterThanMaxlimit");
                                            }
                                        } else {
                                            SetResultException(R, "DailyCountGreaterThanMaxlimit");
                                        }
                                    } else {
                                        SetResultException(R, "AmountGreaterThanMaxlimit");
                                    }
                                } else {
                                    SetResultException(R, "AmountLessThanMinLimit");
                                }
                            } else {
                                SetResultException(R, "PaymentMethodNotSupportDeposit");
                            }
                        } else {
                            SetResultException(R, "PaymentMethodDisable");
                        }
                    } else {
                        SetResultException(R, "PaymentMethodNotExist");
                    }
                } else {
                    SetResultException(R, "WithdrawlTemporaryMaintenance");
                }
            } else {
                SetResultException(R, "NotInOpenTime");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonListResult GetPaymentByNonFinished(string WebSID, string GUID) {
        PaymentCommonListResult R = new PaymentCommonListResult() { Result = enumResult.ERR };
        EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            List<PaymentCommonData> payments = RedisCache.PaymentContent.GetPaymentContents<PaymentCommonData>(SI.LoginAccount);

            if (payments != null && payments.Count > 0) {
                R.Result = enumResult.OK;
                R.Datas = payments;
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public AgentWithdrawalListResult GetAgentWithdrawalPayment(string WebSID, string GUID, DateTime SearchDate) {
        AgentWithdrawalListResult R = new AgentWithdrawalListResult() { Result = enumResult.ERR,Datas = new List<AgentWithdrawal>() };
        EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
        RedisCache.SessionContext.SIDInfo SI;
        List<AgentWithdrawal> ListEWinRequireWithdrawal = new List<AgentWithdrawal>();
        List<AgentWithdrawal> ListEndEWinRequireWithdrawal = new List<AgentWithdrawal>();
        string[] separatingStrings = { "<br/>"};
        string strDate = SearchDate.Year + "-" + (SearchDate.Month+1);
        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

            EWin.Lobby.RequireWithdrawalHistoryResult EWinRequireWithdrawal = lobbyAPI.GetRequireWithdrawalHistoryByUserAccountID(GetToken(), SI.EWinSID, GUID, SearchDate.Year, SearchDate.Month + 1);

            if (EWinRequireWithdrawal.Result == EWin.Lobby.enumResult.OK)
            {
                for (int i = 0; i < EWinRequireWithdrawal.HistoryList.Length; i++)
                {
                    var data = new AgentWithdrawal();
                    var splitDescription = EWinRequireWithdrawal.HistoryList[i].Description.Split(separatingStrings, StringSplitOptions.RemoveEmptyEntries);
                    if (splitDescription.Length == 5)
                    {
                        data.GUID = splitDescription[0];
                        data.BankName = splitDescription[1];
                        data.BankBranchName = splitDescription[2];
                        data.BankCard = splitDescription[3];
                        data.BankCardName = splitDescription[4];
                    }
                    else {
                        data.GUID = splitDescription[0];
                        data.BankName = splitDescription[1];
                        data.BankCard = splitDescription[2];
                        data.BankCardName = splitDescription[3];
                    }

                    data.Status = EWinRequireWithdrawal.HistoryList[i].ProcessStatus;
                    data.Amount = EWinRequireWithdrawal.HistoryList[i].Amount;
                    data.FinishDate = EWinRequireWithdrawal.HistoryList[i].CreateDate + " " + EWinRequireWithdrawal.HistoryList[i].CreateTime;

                    ListEWinRequireWithdrawal.Add(data);
                }

            }

            List<AgentWithdrawal> ListRequireWithdrawal = RedisCache.AgentWithdrawalContent.GetWithdrawalContents<List<AgentWithdrawal>>(SI.LoginAccount, strDate);
            if (ListRequireWithdrawal != null && ListRequireWithdrawal.Count > 0)
            {
                for (int i = 0; i < ListRequireWithdrawal.Count; i++)
                {
                    if (ListEWinRequireWithdrawal != null)
                    {
                        var EWinRequireWithdrawalData = ListEWinRequireWithdrawal.Find(x => x.GUID.Contains(ListRequireWithdrawal[i].GUID));
                        if (EWinRequireWithdrawalData != null)
                        {
                            ListRequireWithdrawal[i].Status = EWinRequireWithdrawalData.Status;
                            ListRequireWithdrawal[i].FinishDate = EWinRequireWithdrawalData.FinishDate;
                        }

                    }
                    ListEndEWinRequireWithdrawal.Add(ListRequireWithdrawal[i]);
                }
            }

            if (ListEWinRequireWithdrawal != null && ListEWinRequireWithdrawal.Count > 0)
            {
                if (ListRequireWithdrawal != null)
                {
                    for (int i = 0; i < ListEWinRequireWithdrawal.Count; i++)
                    {

                        var RequireWithdrawalData = ListRequireWithdrawal.Find(x => x.GUID.Contains(ListEWinRequireWithdrawal[i].GUID));
                        if (RequireWithdrawalData == null)
                        {
                            ListEndEWinRequireWithdrawal.Add(ListEWinRequireWithdrawal[i]);
                        }
                    }

                }
                else {
                    ListEndEWinRequireWithdrawal = ListEWinRequireWithdrawal;
                }
            }


            if (ListEndEWinRequireWithdrawal.Count > 0)
            {
                R.Datas = ListEndEWinRequireWithdrawal;
                R.Result = enumResult.OK;
            }
            else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonListResult GetClosePayment(string WebSID, string GUID, DateTime StartDate, DateTime EndDate) {
        PaymentCommonListResult R = new PaymentCommonListResult() { Result = enumResult.ERR };
        EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            R.Datas = new List<PaymentCommonData>();
            R.Result = enumResult.OK;

            for (int i = 0; i <= EndDate.Subtract(StartDate).TotalDays; i++) {
                var QueryDate = StartDate.AddDays(i);
                string Content = string.Empty;
                Content = ReportSystem.UserAccountPayment.GetUserAccountPayment(QueryDate, SI.LoginAccount);

                foreach (string EachString in Content.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries)) {
                    PaymentCommonData data = null;
                    try { data = Newtonsoft.Json.JsonConvert.DeserializeObject<PaymentCommonData>(EachString); } catch (Exception ex) { }
                    if (data != null) {
                        R.Datas.Add(data);
                    }
                }
            }

            if (R.Datas.Count > 0) {
                R.Result = enumResult.OK;
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult GetPaymentByOrderNumber(string WebSID, string GUID, string OrderNumber) {
        PaymentCommonResult R = new PaymentCommonResult();
        RedisCache.SessionContext.SIDInfo SI;
        System.Data.DataTable DT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            DT = EWinWebDB.UserAccountPayment.GetPaymentByOrderNumber(OrderNumber);

            if (DT != null && DT.Rows.Count > 0) {
                R.Result = enumResult.OK;
                R.Data = CovertFromRow(DT.Rows[0]);
            } else {
                SetResultException(R, "InvalidWebSID");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult GetPaymentByPaymentSerial(string WebSID, string GUID, string PaymentSerial) {
        PaymentCommonResult R = new PaymentCommonResult();
        RedisCache.SessionContext.SIDInfo SI;
        System.Data.DataTable DT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            DT = EWinWebDB.UserAccountPayment.GetPaymentByPaymentSerial(PaymentSerial);

            if (DT != null && DT.Rows.Count > 0) {
                R.Result = enumResult.OK;
                R.Data = CovertFromRow(DT.Rows[0]);
            } else {
                SetResultException(R, "InvalidWebSID");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserAccountPaymentResult GetInProgressPaymentByLoginAccount(string WebSID, string GUID, string LoginAccount, int PaymentType) {
        UserAccountPaymentResult R = new UserAccountPaymentResult();
        RedisCache.SessionContext.SIDInfo SI;
        System.Data.DataTable DT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            DT = EWinWebDB.UserAccountPayment.GetInProgressPaymentByLoginAccount(LoginAccount, PaymentType);

            if (DT != null && DT.Rows.Count > 0) {
                R.Result = enumResult.OK;
                R.UserAccountPayments = EWinWeb.ToList<UserAccountPayment>(DT).ToList();
            } else {
                SetResultException(R, "InvalidWebSID");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserAccountPaymentResult GetInProgressPaymentByLoginAccountPaymentMethodID(string WebSID, string GUID, string LoginAccount, int PaymentType, int PaymentMethodID) {
        UserAccountPaymentResult R = new UserAccountPaymentResult();
        RedisCache.SessionContext.SIDInfo SI;
        System.Data.DataTable DT;


        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            DT = EWinWebDB.UserAccountPayment.GetInProgressPaymentByLoginAccountPaymentMethodID(LoginAccount, PaymentType, PaymentMethodID);

            if (DT != null && DT.Rows.Count > 0) {
                R.Result = enumResult.OK;
                R.UserAccountPayments = EWinWeb.ToList<UserAccountPayment>(DT).ToList();
            } else {
                R.Result = enumResult.OK;
                R.UserAccountPayments = new List<UserAccountPayment>();
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public APIResult CancelPayment(string WebSID, string GUID, string PaymentSerial, string OrderNumber) {
        APIResult R = new APIResult() { Result = enumResult.ERR, GUID = GUID };
        EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
        RedisCache.SessionContext.SIDInfo SI;

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {


            PaymentCommonData paymentCommonData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);
            if (paymentCommonData != null) {
                if (paymentCommonData.PaymentType == 0)
                {
                    if (paymentCommonData.BasicType == 2)
                    {
                        new EWin.EWinWeb.EWinWeb().FinishCompanyWallet(SI.EWinCT, (EWin.EWinWeb.enumWalletType)paymentCommonData.WalletType, paymentCommonData.ToWalletAddress);
                        var paymentResult = paymentAPI.CancelPayment(GetToken(), GUID, PaymentSerial);
                        if (paymentResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                        {
                            R.Result = enumResult.OK;
                        }
                        else
                        {
                            SetResultException(R, paymentResult.ResultMessage);
                        }

                    }
                    else if (paymentCommonData.BasicType == 1)
                    {
                        EWin.EWinWeb.EWinWeb _CASINO3651API = new EWin.EWinWeb.EWinWeb();
                        //PaymentMethod 0=上分/1=下分
                        var BankCardDepostitR = _CASINO3651API.BankCardDepostitCancel(SI.EWinCT, GUID, PaymentSerial);
                        if (BankCardDepostitR.ResultState == EWin.EWinWeb.enumResultState.OK)
                        {
                            R.Result = enumResult.OK;
                        }
                        else
                        {
                            SetResultException(R, BankCardDepostitR.Message);
                        }
                    }
                    else
                    {
                        SetResultException(R, "NoOrderCanCancel");
                    }
                }
                else
                {
                    SetResultException(R, "OnlyDepositCanCancel");
                }
            } else {
                SetResultException(R, "NotFoundData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public ActivityCore.ActResult<List<ActivityCore.DepositActivity>> GetDepositInfo(string WebSID, string GUID, decimal Amount, string PaymentCode, string LoginAccount)
    {
        RedisCache.SessionContext.SIDInfo SI;
        ActivityCore.ActResult<List<ActivityCore.DepositActivity>> R = new ActivityCore.ActResult<List<ActivityCore.DepositActivity>>()
        {
            GUID = GUID,
            Result = ActivityCore.enumActResult.ERR
        };

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID))
        {
            R = ActivityCore.GetDepositAllResult(Amount, PaymentCode, LoginAccount);
        }
        else
        {
            ActivityCore.SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public APIResult GetExchangeRateFromNomics(string WebSID, string GUID) {
        string RedisReturn = string.Empty;
        string strCryptoExchangeRateFromNomics;
        RedisCache.SessionContext.SIDInfo SI;
        APIResult R = new APIResult() {
            GUID = GUID,
            Result = enumResult.ERR
        };

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            RedisReturn = RedisCache.CryptoExchangeRate.GetCryptoExchangeRate();

            if (string.IsNullOrEmpty(RedisReturn)) {
                strCryptoExchangeRateFromNomics = CryptoExpand.GetAllCryptoExchangeRate();
                if (!string.IsNullOrEmpty(strCryptoExchangeRateFromNomics)) {
                    RedisCache.CryptoExchangeRate.UpdateCryptoExchangeRate(strCryptoExchangeRateFromNomics);
                    R.Message = strCryptoExchangeRateFromNomics;
                    R.Result = enumResult.OK;
                } else {
                    SetResultException(R, "InvalidCryptoExchangeRate");
                }
            } else {
                R.Message = RedisReturn;
                R.Result = enumResult.OK;
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }
        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public UserAccountEventBonusHistoryResult GetUserAccountEventBonusHistoryByLoginAccount(string WebSID, string GUID, DateTime StartDate, DateTime EndDate) {
        string RedisReturn = string.Empty;
        RedisCache.SessionContext.SIDInfo SI;
        UserAccountEventBonusHistoryResult R = new UserAccountEventBonusHistoryResult() {
            GUID = GUID,
            Result = enumResult.ERR
        };

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            R.UserAccountEventBonusHistorys = new List<UserAccountEventBonusHistory>();
            R.Result = enumResult.OK;

            for (int i = 0; i <= EndDate.Subtract(StartDate).TotalDays; i++) {
                var QueryDate = StartDate.AddDays(i);
                string Content = string.Empty;
                Content = ReportSystem.UserAccountEventBonusHistory.GetUserAccountEventBonusHistory(QueryDate, SI.LoginAccount);

                foreach (string EachString in Content.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries)) {
                    UserAccountEventBonusHistory data = null;
                    try { data = Newtonsoft.Json.JsonConvert.DeserializeObject<UserAccountEventBonusHistory>(EachString); } catch (Exception ex) { }
                    if (data != null) {
                        R.UserAccountEventBonusHistorys.Add(data);
                    }
                }
            }

            if (R.UserAccountEventBonusHistorys.Count > 0) {
                R.Result = enumResult.OK;
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public APIResult UpdateUserAccountNotifyMsgStatus(string WebSID, string GUID, int forNotifyMsgID, int MessageReadStatus) {
        string RedisReturn = string.Empty;
        RedisCache.SessionContext.SIDInfo SI;
        APIResult R = new APIResult() {
            GUID = GUID,
            Result = enumResult.ERR
        };

        SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

        if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
            int ret = EWinWebDB.UserAccountNotifyMsg.UpdateUserAccountNotifyMsgStatus(forNotifyMsgID, SI.LoginAccount, MessageReadStatus);

            if (ret > 0) {
                R.Result = enumResult.OK;
            } else {
                SetResultException(R, "NoData");
            }
        } else {
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }

    private PaymentCommonData CovertFromRow(System.Data.DataRow row) {
        string DetailDataStr = "";
        string ActivityDataStr = "";

        if (!Convert.IsDBNull(row["DetailData"])) {
            DetailDataStr = row["DetailData"].ToString();
        }

        if (!Convert.IsDBNull(row["ActivityData"])) {
            ActivityDataStr = row["ActivityData"].ToString();
        }



        if (string.IsNullOrEmpty(DetailDataStr)) {
            PaymentCommonData result = new PaymentCommonData() {
                PaymentType = (int)row["PaymentType"],
                BasicType = (int)row["BasicType"],
                LoginAccount = (string)row["LoginAccount"],
                OrderNumber = (string)row["OrderNumber"],
                Amount = (decimal)row["Amount"],
                HandingFeeRate = (decimal)row["HandingFeeRate"],
                //ReceiveTotalAmount = (decimal)row["ReceiveTotalAmount"],
                ThresholdValue = (decimal)row["ThresholdValue"],
                ThresholdRate = (decimal)row["ThresholdRate"],
                CreateDate = ((DateTime)row["CreateDate"]).ToString("yyyy/MM/dd HH:mm:ss"),
                LimitDate = ((DateTime)row["CreateDate"]).AddSeconds((int)row["ExpireSecond"]).ToString("yyyy/MM/dd HH:mm:ss"),
                ExpireSecond = (int)row["ExpireSecond"],
                PaymentMethodID = (int)row["PaymentMethodID"],
                PaymentMethodName = (string)row["PaymentName"],
                PaymentCode = (string)row["PaymentCode"]
            };

            return result;
        } else {
            PaymentCommonData result = new PaymentCommonData() {
                PaymentType = (int)row["PaymentType"],
                BasicType = (int)row["BasicType"],
                LoginAccount = (string)row["LoginAccount"],
                OrderNumber = (string)row["OrderNumber"],
                Amount = (decimal)row["Amount"],
                HandingFeeRate = (decimal)row["HandingFeeRate"],
                //ReceiveTotalAmount = (decimal)row["ReceiveTotalAmount"],
                ThresholdValue = (decimal)row["ThresholdValue"],
                ThresholdRate = (decimal)row["ThresholdRate"],
                CreateDate = ((DateTime)row["CreateDate"]).ToString("yyyy/MM/dd HH:mm:ss"),
                LimitDate = ((DateTime)row["CreateDate"]).AddSeconds((int)row["ExpireSecond"]).ToString("yyyy/MM/dd HH:mm:ss"),
                ExpireSecond = (int)row["ExpireSecond"],
                PaymentMethodID = (int)row["PaymentMethodID"],
                PaymentMethodName = (string)row["PaymentName"],
                PaymentCode = (string)row["PaymentCode"],
                ToWalletAddress = (string)row["ToInfo"],
                WalletType = (int)row["EWinCryptoWalletType"],
            };

            result.PaymentCryptoDetailList = Newtonsoft.Json.JsonConvert.DeserializeObject<List<CryptoDetail>>(DetailDataStr);

            if (!string.IsNullOrEmpty(ActivityDataStr)) {
                result.ActivityDatas = Newtonsoft.Json.JsonConvert.DeserializeObject<List<EWinTagInfoActivityData>>(ActivityDataStr);
            }

            return result;
        }
    }

    private void SetResultException(APIResult R, string Msg) {
        if (R != null) {
            R.Result = enumResult.ERR;
            R.Message = Msg;
        }
    }

    private string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    public class APIResult {
        public enumResult Result { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }

    public enum enumResult {
        OK = 0,
        ERR = 1
    }

    public class AgentWithdrawalResult : APIResult {
        public AgentWithdrawal Data { get; set; }
    }

    public class AgentWithdrawalListResult : APIResult {
        public List<AgentWithdrawal> Datas { get; set; }
    }

    public class AgentWithdrawal {
        public string LoginAccount { get; set; }
        public string GUID { get; set; }
        public string BankName { get; set; }
        public string BankBranchName  { get; set; }
        public string BankCard  { get; set; }
        public string BankCardName  { get; set; }
        public int Status  { get; set; }
        public string CreateDate  { get; set; }
        public string FinishDate  { get; set; }
        public decimal Amount  { get; set; }
    }

    public class PaymentCommonResult : APIResult {
        public PaymentCommonData Data { get; set; }
    }

    public class PaymentCommonBankCardResult : APIResult {
        public PaymentCommonData Data { get; set; }
        public PaymentCommonBankData BankData { get; set; }
    }

    public class PaymentCommonBankData {

        public string AccountName { get; set; }
        public decimal AmountMax { get; set; }
        public string BankName { get; set; }
        public string BankCode { get; set; }
        public string BankNumber { get; set; }
        public string BranchName { get; set; }
        public string PaymentSerial { get; set; }
    }

    public class PaymentCommonListResult : APIResult {
        public List<PaymentCommonData> Datas { get; set; }
    }

    public class PaymentCommonData
    {
        public int PaymentType { get; set; } // 0=入金,1=出金
        public int BasicType { get; set; } // 0=一般/1=銀行卡/2=區塊鏈
        public int PaymentFlowType { get; set; } // 0=建立/1=進行中/2=成功/3=失敗
        public string LoginAccount { get; set; }
        public string PaymentSerial { get; set; }
        public string OrderNumber { get; set; }
        public string ReceiveCurrencyType { get; set; }
        public decimal Amount { get; set; }
        public decimal PointValue { get; set; }
        public decimal HandingFeeRate { get; set; }
        public int HandingFeeAmount { get; set; }
        public decimal ReceiveTotalAmount { get; set; }
        public int ProviderHandingFeeAmount { get; set; }
        public decimal ProviderHandingFeeRate { get; set; }
        public decimal ThresholdValue { get; set; }
        public decimal ThresholdRate { get; set; }
        public int ExpireSecond { get; set; }
        public int PaymentMethodID { get; set; }
        public string PaymentMethodName { get; set; }
        public string PaymentCode { get; set; }
        public string CreateDate { get; set; }
        public string FinishDate { get; set; }
        public string LimitDate { get; set; }
        public int WalletType { get; set; } // 0=ERC,1=XRP
        public string ToWalletAddress { get; set; }
        public List<CryptoDetail> PaymentCryptoDetailList { get; set; }
        public List<EWinTagInfoActivityData> ActivityDatas { get; set; }
        public string ActivityData { get; set; }
        public string FromInfo { get; set; }
        public string ToInfo { get; set; }
    }

    public class CryptoDetail {
        public string TokenCurrencyType { get; set; }
        public string TokenContractAddress { get; set; }
        public decimal ReceiveAmount { get; set; }
        public decimal ExchangeRate { get; set; }
        public decimal PartialRate { get; set; }
    }

    public class EWinTagInfoData
    {
        public int PaymentMethodID { get; set; }
        public string PaymentCode { get; set; }
        public string PaymentMethodName { get; set; }
        public decimal ThresholdRate { get; set; }
        public decimal ThresholdValue { get; set; }
        public bool IsJoinDepositActivity { get; set; }
        public List<EWinTagInfoActivityData> ActivityDatas { get; set; }
    }


    public class EWinTagInfoActivityData
    {
        public string ActivityName { get; set; }
        public string JoinActivityCycle { get; set; }
        public decimal BonusRate { get; set; }
        public decimal BonusValue { get; set; }
        public decimal ThresholdRate { get; set; }
        public decimal ThresholdValue { get; set; }
        public int JoinCount { get; set; }
        public string CollectAreaType { get; set; }
    }


    public class PaymentMethodResult : APIResult {
        public List<PaymentMethod> PaymentMethodResults { get; set; }
    }

    public class PaymentMethod {
        public int PaymentMethodID { get; set; }
        public int PaymentType { get; set; }
        public string PaymentName { get; set; }
        public string PaymentCode { get; set; }
        public string PaymentCategoryCode { get; set; }
        public int State { get; set; }
        public string EwinPayServiceType { get; set; }
        public int EWinPaymentType { get; set; }
        public int EWinCryptoWalletType { get; set; }
        public decimal ThresholdRate { get; set; }
        public int MinLimit { get; set; }
        public int MaxLimit { get; set; }
        public decimal HandingFeeRate { get; set; }
        public decimal HandingFeeAmount { get; set; }
        public string CurrencyType { get; set; }
        public string MultiCurrencyInfo { get; set; }
        public string ExtraData { get; set; }
        public string HintText { get; set; }
    }

    public class UserAccountPaymentResult : APIResult {
        public List<UserAccountPayment> UserAccountPayments { get; set; }
    }

    public class UserAccountPayment {
        public string OrderNumber { get; set; }
        public string PaymentSerial { get; set; }
        public string PaymentName { get; set; }
        public int PaymentType { get; set; }
        public int BasicType { get; set; }
        public int FlowStatus { get; set; }
        public string LoginAccount { get; set; }
        public decimal Amount { get; set; }
        public decimal PointValue { get; set; }
        public decimal HandingFeeRate { get; set; }
        public int HandingFeeAmount { get; set; }
        public decimal ThresholdRate { get; set; }
        public decimal ThresholdValue { get; set; }
        public int forPaymentMethodID { get; set; }
        public string FromInfo { get; set; }
        public string ToInfo { get; set; }
        public string DetailData { get; set; }
        public string ActivityData { get; set; }
        public int ExpireSecond { get; set; }
        public DateTime FinishDate { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreateDate1 { get; set; }
    }

    public class UserAccountEventBonusHistoryResult : APIResult {
        public List<UserAccountEventBonusHistory> UserAccountEventBonusHistorys { get; set; }
    }

    public class UserAccountEventBonusHistory {
        public int EventBonusHistoryID { get; set; }
        public string LoginAccount { get; set; }
        public string RelationID { get; set; }
        public int EventType { get; set; }
        public string ActivityName { get; set; }
        public decimal ThresholdRate { get; set; }
        public decimal ThresholdValue { get; set; }
        public decimal BonusRate { get; set; }
        public decimal BonusValue { get; set; }
        public string CreateDate { get; set; }
    }

}