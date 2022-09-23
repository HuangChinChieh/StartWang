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
public class PaymentAPI : System.Web.Services.WebService
{
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public APIResult HeartBeat(string GUID, string Echo)
    {
        APIResult R = new APIResult();
        R.Result = enumResult.OK;
        R.Message = Echo;

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public BankSelectResult GetEPayBankSelect(string SID, string GUID, string ProviderCode)
    {
        BankSelectResult R = new BankSelectResult() { GUID = GUID, Result = enumResult.ERR };
        string Path;

        Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/" + "BankSetting.json");

        Newtonsoft.Json.Linq.JObject o = null;

        if (System.IO.File.Exists(Path))
        {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Path);

            if (string.IsNullOrEmpty(SettingContent) == false)
            {
                try { o = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(SettingContent); } catch (Exception ex) { }
            }

            R.Datas = o["BankCodeSettings"].ToString();
            R.Result = enumResult.OK;
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EPaySetting GetEPaySetting(string GUID)
    {
        EPaySetting R = new EPaySetting() { GUID = GUID, Result = enumResult.ERR };
        string Path;
        string SettingFile = "EPaySetting.json";
        dynamic EPAYSetting = null;
        if (EWinWeb.IsTestSite)
        {
            Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Test_" + SettingFile);
        }
        else
        {
            Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Formal_" + SettingFile);
        }

        if (System.IO.File.Exists(Path))
        {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Path);

            if (string.IsNullOrEmpty(SettingContent) == false)
            {
                try { EPAYSetting = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
            }
        }

        if (EPAYSetting != null)
        {
            R.MaxDepositAmount= (decimal)EPAYSetting.MaxDepositAmount;
            R.MinDepositAmount= (decimal)EPAYSetting.MinDepositAmount;
            R.MaxWithdrawAmount= (decimal)EPAYSetting.MaxWithdrawAmount;
            R.MinWithdrawAmount= (decimal)EPAYSetting.MinWithdrawAmount;
            R.ThresholdRate= (decimal)EPAYSetting.ThresholdRate;
            R.WithdrawHandlingFee= (decimal)EPAYSetting.WithdrawHandlingFee;
            R.WithdrawRate= (decimal)EPAYSetting.WithdrawRate;
            R.Result = enumResult.OK;
            return R;
        }

        return R;
    }

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.BankCardDepositResult BankCardDepostit(string CT, string GUID, string CurrencyType, int PaymentMethod, decimal Amount, string Description)
    //{
    //    EWin.EWinWeb.EWinWeb EWinWebAPI = new EWin.EWinWeb.EWinWeb();
    //    EWin.EWinWeb.BankCardDepositResult RetValue = null;
    //    string DownOrderNumber = Guid.NewGuid().ToString("N");
    //    RetValue = EWinWebAPI.BankCardDepostit(CT, GUID, CurrencyType, PaymentMethod, Amount, Description, DownOrderNumber);

    //    return RetValue;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult CompleteReceiptFile(string CT, string GUID, string UploadId)
    //{

    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.CompleteReceiptFile(CT, GUID, UploadId);


    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult GetCompanyPaymentBankCard(string CT, string GUID, string CurrencyType, int PaymentMethod)
    //{

    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.GetCompanyPaymentBankCard(CT, GUID, CurrencyType, PaymentMethod);


    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.UploadInfoResult CreateReceiptFIleUpload(string CT, string GUID, string PaymentSerial, string ExtName)
    //{
    //    EWin.EWinWeb.UploadInfoResult R = new EWin.EWinWeb.UploadInfoResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.CreateReceiptFIleUpload(CT, GUID, PaymentSerial, ExtName);
    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult UploadReceiptFIle(string CT, string GUID, string UploadId, int ChunkIndex, string ContentB64)
    //{
    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.UploadReceiptFIle(CT, GUID, UploadId, ChunkIndex, ContentB64);

    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult CheckBankCardDepostit(string CT, string GUID)
    //{
    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.CheckBankCardDepostit(CT, GUID);

    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult BankCardDepostitCancel(string CT, string GUID, string PaymentSerial)
    //{
    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.BankCardDepostitCancel(CT, GUID, PaymentSerial);

    //    return R;
    //}


    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult GetUserAccountBankCard(string CT, string GUID, string CurrencyType, int PaymentMethod)
    //{
    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.GetUserAccountBankCard(CT, GUID, CurrencyType, PaymentMethod);

    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public EWin.EWinWeb.APIResult BankCardWithdrawal(string CT, string GUID, string CurrencyType, int PaymentMethod, decimal Amount, string WalletPassword, string[] BankCardGUID)
    //{
    //    EWin.EWinWeb.APIResult R = new EWin.EWinWeb.APIResult();

    //    EWin.EWinWeb.EWinWeb CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //    //PaymentMethod 0=上分/1=下分
    //    R = CASINO3651API.BankCardWithdrawal(CT, GUID, CurrencyType, PaymentMethod, Amount, WalletPassword, BankCardGUID);

    //    return R;
    //}


    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public PaymentCommonResult CreateAgentWithdrawal(string WebSID, string GUID, decimal Amount, string BankName, string BankBranchName, string BankCard, string BankCardName) {
    //    PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
    //    PaymentCommonData PaymentCommonData = new PaymentCommonData() { PaymentCryptoDetailList = new List<CryptoDetail>() };


    //    string PaymentMethodName;
    //    string PaymentCode;
    //    string ReceiveCurrencyType;
    //    int MinLimit;
    //    int MaxLimit;
    //    int DailyMaxAmount;
    //    int DailyMaxCount;
    //    decimal ReceiveTotalAmount;
    //    decimal HandingFeeRate;
    //    int HandingFeeAmount;
    //    int WalletType;
    //    int ExpireSecond;
    //    int DecimalPlaces;
    //    string Description;
    //    string WithdrawalGUID = Guid.NewGuid().ToString("N");
    //    System.Data.DataTable PaymentMethodDT;


    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
    //        //if (EWinWeb.CheckInWithdrawalTime()) {
    //        if (!EWinWeb.IsWithdrawlTemporaryMaintenance()) {
    //            PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByCategory("Agent");

    //            if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
    //                if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
    //                    if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 1) {
    //                        MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
    //                        MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];
    //                        DailyMaxCount = (int)PaymentMethodDT.Rows[0]["DailyMaxCount"];
    //                        DailyMaxAmount = (int)PaymentMethodDT.Rows[0]["DailyMaxAmount"];
    //                        DecimalPlaces = (int)PaymentMethodDT.Rows[0]["DecimalPlaces"];
    //                        if (Amount >= MinLimit) {
    //                            if (Amount <= MaxLimit || MaxLimit == 0) {
    //                                //System.Data.DataTable SummaryDT = EWinWebDB.UserAccountPayment.GetTodayPaymentByLoginAccount(SI.LoginAccount, 1);

    //                                //if (SummaryDT != null && SummaryDT.Rows.Count > 0) {
    //                                //    WithdrawalAmountByDay = 0;
    //                                //    foreach (System.Data.DataRow dr in SummaryDT.Rows) {
    //                                //        WithdrawalAmountByDay += (decimal)dr["Amount"];
    //                                //    }
    //                                //    WithdrawalCountByDay = SummaryDT.Rows.Count;
    //                                //} else {
    //                                //    WithdrawalAmountByDay = 0;
    //                                //    WithdrawalCountByDay = 0;
    //                                //}

    //                                //if (DailyMaxCount == 0 || (WithdrawalCountByDay + 1) <= DailyMaxCount) {
    //                                //    if (DailyMaxAmount == 0 || (WithdrawalAmountByDay + Amount) <= DailyMaxAmount) {
    //                                if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 0) {
    //                                    //Check ThresholdValue
    //                                    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
    //                                    EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
    //                                    EWin.Lobby.ThresholdInfo thresholdInfo;
    //                                    decimal thresholdValue;

    //                                    if (userInfoResult.Result == EWin.Lobby.enumResult.OK) {
    //                                        thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

    //                                        if (thresholdInfo != null) {
    //                                            thresholdValue = thresholdInfo.ThresholdValue;
    //                                        } else {
    //                                            thresholdValue = 0;
    //                                        }
    //                                        if (thresholdValue == 0) {
    //                                            PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
    //                                            PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
    //                                            ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
    //                                            ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
    //                                            HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
    //                                            HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
    //                                            WalletType = (int)PaymentMethodDT.Rows[0]["EWinCryptoWalletType"];
    //                                            //MultiCurrencyInfo = (string)PaymentMethodDT.Rows[0]["MultiCurrencyInfo"];
    //                                            ReceiveTotalAmount = (Amount * (1 - (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) - HandingFeeAmount;

    //                                            if (string.IsNullOrEmpty(BankBranchName))
    //                                            {
    //                                                Description = WithdrawalGUID + "<br/>" + BankName + "<br/>" + BankCard + "<br/>" + BankCardName;
    //                                            }
    //                                            else {
    //                                                Description = WithdrawalGUID + "<br/>" + BankName + "<br/>" + BankBranchName + "<br/>" + BankCard + "<br/>" + BankCardName;
    //                                            }

    //                                            EWin.Lobby.APIResult InsertResult  = lobbyAPI.RequireWithdrawal(GetToken(), SI.EWinSID, GUID,(string)PaymentMethodDT.Rows[0]["CurrencyType"],Amount,Description);

    //                                            if (InsertResult.Result == EWin.Lobby.enumResult.OK)
    //                                            {
    //                                                AgentWithdrawal _AgentWithdrawalData = new AgentWithdrawal() { BankBranchName = BankBranchName, BankCard = BankCard, BankCardName = BankCardName, BankName = BankName, GUID = WithdrawalGUID, LoginAccount = SI.LoginAccount,CreateDate= DateTime.Now.ToString(("yyyy-MM-dd HH:mm:ss")),Status=0 ,Amount= Amount};
    //                                                int Year= DateTime.Now.Year;
    //                                                int Month = DateTime.Now.Month;
    //                                                RedisCache.AgentWithdrawalContent.KeepWithdrawalContents<AgentWithdrawal>(_AgentWithdrawalData,SI.LoginAccount, Year + "-" + Month);
    //                                                R.Result = enumResult.OK;
    //                                            }
    //                                            else {
    //                                                SetResultException(R, InsertResult.Message);
    //                                            }
    //                                        } else {
    //                                            SetResultException(R, "ThresholdLimit");
    //                                        }
    //                                    } else {
    //                                        SetResultException(R, "GetInfoError");
    //                                    }

    //                                } else {
    //                                    SetResultException(R, "PaymentMethodNotCrypto");
    //                                }

    //                                //    } else {
    //                                //        SetResultException(R, "DailyAmountGreaterThanMaxlimit");
    //                                //    }
    //                                //} else {
    //                                //    SetResultException(R, "DailyCountGreaterThanMaxlimit");
    //                                //}
    //                            } else {
    //                                SetResultException(R, "AmountGreaterThanMaxlimit");
    //                            }
    //                        } else {
    //                            SetResultException(R, "AmountLessThanMinLimit");
    //                        }
    //                    } else {
    //                        SetResultException(R, "PaymentMethodNotSupportDeposit");
    //                    }
    //                } else {
    //                    SetResultException(R, "PaymentMethodDisable");
    //                }
    //            } else {
    //                SetResultException(R, "PaymentMethodNotExist");
    //            }
    //        } else {
    //            SetResultException(R, "WithdrawlTemporaryMaintenance");
    //        }
    //        //} else {
    //        //    SetResultException(R, "NotInOpenTime");
    //        //}
    //    } else {
    //        SetResultException(R, "InvalidWebSID");
    //    }

    //    return R;
    //}





    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public PaymentCommonResult CreateCommonDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
    //    PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
    //    PaymentCommonData paymentCommonData = new PaymentCommonData() { };

    //    RedisCache.SessionContext.SIDInfo SI;
    //    string PaymentMethodName;
    //    string PaymentCode;
    //    string ReceiveCurrencyType;
    //    int MinLimit;
    //    int MaxLimit;
    //    int DailyMaxAmount;
    //    int DailyMaxCount;
    //    decimal ReceiveTotalAmount;
    //    decimal HandingFeeRate;
    //    int HandingFeeAmount;
    //    decimal ThresholdRate;
    //    decimal DepositAmountByDay;
    //    int DepositCountByDay;
    //    int ExpireSecond;
    //    System.Data.DataTable PaymentMethodDT;


    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
    //        PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

    //        if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
    //            if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
    //                if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
    //                    MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
    //                    MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];
    //                    DailyMaxCount = (int)PaymentMethodDT.Rows[0]["DailyMaxCount"];
    //                    DailyMaxAmount = (int)PaymentMethodDT.Rows[0]["DailyMaxAmount"];

    //                    if (Amount >= MinLimit) {
    //                        if (Amount <= MaxLimit || MaxLimit == 0) {
    //                            System.Data.DataTable SummaryDT = RedisCache.UserAccountSummary.GetUserAccountSummary(SI.LoginAccount, DateTime.Now);

    //                            if (SummaryDT != null && SummaryDT.Rows.Count > 0) {
    //                                DepositAmountByDay = (decimal)SummaryDT.Rows[0]["DepositAmount"];
    //                                DepositCountByDay = (int)SummaryDT.Rows[0]["DepositCount"];
    //                            } else {
    //                                DepositAmountByDay = 0;
    //                                DepositCountByDay = 0;
    //                            }


    //                            if (DailyMaxCount == 0 || (DepositCountByDay + 1) <= DailyMaxCount) {
    //                                if (DailyMaxAmount == 0 || (DepositAmountByDay + Amount) <= DailyMaxAmount) {
    //                                    if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 0) {
    //                                        string OrderNumber = System.Guid.NewGuid().ToString();
    //                                        int InsertRet;

    //                                        PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
    //                                        PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
    //                                        ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
    //                                        ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
    //                                        ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
    //                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
    //                                        HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
    //                                        ReceiveTotalAmount = (Amount * (1 + (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) + HandingFeeAmount;

    //                                        paymentCommonData.PaymentType = 0;
    //                                        paymentCommonData.BasicType = 0;
    //                                        paymentCommonData.OrderNumber = System.Guid.NewGuid().ToString();
    //                                        paymentCommonData.LoginAccount = SI.LoginAccount;
    //                                        paymentCommonData.Amount = Amount;
    //                                        paymentCommonData.HandingFeeRate = HandingFeeRate;
    //                                        paymentCommonData.HandingFeeAmount = HandingFeeAmount;
    //                                        paymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
    //                                        paymentCommonData.ExpireSecond = ExpireSecond;
    //                                        paymentCommonData.PaymentMethodID = PaymentMethodID;
    //                                        paymentCommonData.PaymentMethodName = PaymentMethodName;
    //                                        paymentCommonData.PaymentCode = PaymentCode;
    //                                        paymentCommonData.ThresholdRate = ThresholdRate;
    //                                        paymentCommonData.ThresholdValue = Amount * ThresholdRate;


    //                                        InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, paymentCommonData.PaymentType, 2, paymentCommonData.LoginAccount, paymentCommonData.Amount, paymentCommonData.HandingFeeRate, paymentCommonData.HandingFeeAmount, paymentCommonData.ThresholdRate, paymentCommonData.ThresholdValue, paymentCommonData.PaymentMethodID, "", "", "", paymentCommonData.ExpireSecond);

    //                                        if (InsertRet == 1) {
    //                                            R.Result = enumResult.OK;
    //                                            R.Data = paymentCommonData;
    //                                            RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(R), paymentCommonData.OrderNumber);
    //                                        } else {
    //                                            SetResultException(R, "InsertFailure");
    //                                        }
    //                                    } else {
    //                                        SetResultException(R, "PaymentMethodNotCrypto");
    //                                    }
    //                                } else {
    //                                    SetResultException(R, "DailyAmountGreaterThanMaxlimit");
    //                                }
    //                            } else {
    //                                SetResultException(R, "DailyCountGreaterThanMaxlimit");
    //                            }
    //                        } else {
    //                            SetResultException(R, "AmountGreaterThanMaxlimit");
    //                        }
    //                    } else {
    //                        SetResultException(R, "AmountLessThanMinLimit");
    //                    }
    //                } else {
    //                    SetResultException(R, "PaymentMethodNotSupportDeposit");
    //                }
    //            } else {
    //                SetResultException(R, "PaymentMethodDisable");
    //            }
    //        } else {
    //            SetResultException(R, "PaymentMethodNotExist");
    //        }
    //    } else {
    //        SetResultException(R, "InvalidWebSID");
    //    }

    //    return R;
    //}


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateEPayDeposit(string SID,string GUID, decimal Amount,string UserName)
    {
        //PaymentType:0=EWIN PAY 回傳URL /1=FORMPOST導頁 
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };


        string JoinActivityFailedMsg = string.Empty;
        decimal PointValue=Amount;
        string Decription = "";
        dynamic o = null;
        string PaymentCode;
        EWin.Payment.PaymentDetailInheritsBase[] p;
        string Path;
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.UserInfoResult userInfo = null;
        string SettingFile = "EPaySetting.json";
        dynamic EPAYSetting = null;
        decimal ReceiveTotalAmount = 0;

        if (EWinWeb.IsTestSite)
        {
            Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Test_" + SettingFile);
        }
        else
        {
            Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Formal_" + SettingFile);
        }

        if (System.IO.File.Exists(Path))
        {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Path);

            if (string.IsNullOrEmpty(SettingContent) == false)
            {
                try { EPAYSetting = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
            }
        }
        else
        {
            SetResultException(R, "GetSettingFail");
            return R;
        }

        if (EPAYSetting == null)
        {
            SetResultException(R, "GetSettingFail");
            return R;
        }

        if (Amount > (decimal)EPAYSetting.MaxDepositAmount)
        {
            SetResultException(R, "AmountGreaterThanMaxlimit");
            return R;
        }


        if (Amount < (decimal)EPAYSetting.MinDepositAmount)
        {
            SetResultException(R, "AmountLessThanMinLimit");
            return R;
        }

        if ((int)EPAYSetting.DepositType!=0)
        {
            SetResultException(R, "PaymentMethodDisable");
            return R;
        }

        PaymentCode = (string)EPAYSetting.PaymentCode;

        EWinTagInfoData tagInfoData = new EWinTagInfoData() {PaymentCode=PaymentCode,PaymentMethodName="銀行入金",ThresholdRate=(decimal)EPAYSetting.ThresholdRate,ThresholdValue=Amount*(decimal)EPAYSetting.ThresholdRate};
        userInfo = lobbyAPI.GetUserInfo(GetToken(), SID, GUID);

        if (userInfo.Result== EWin.Lobby.enumResult.OK)
        {
            ReceiveTotalAmount = Amount * (1 + (decimal)EPAYSetting.DepositRate);

            Decription = PaymentCode + ", ReceiveTotalAmount=" + ReceiveTotalAmount.ToString("F10");

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
            };

            paymentDetailBankCard.CashAmount = Amount;
            paymentDetailBankCard.TaxFeeValue = Amount * (decimal)EPAYSetting.DepositRate;

            p = new EWin.Payment.PaymentDetailInheritsBase[1];
            p[0] = paymentDetailBankCard;

            paymentResult = paymentAPI.CreatePaymentDeposit(GetToken(), userInfo.LoginAccount, GUID, EWinWeb.MainCurrencyType, Guid.NewGuid().ToString("N"), Amount, paymentDetailBankCard.TaxFeeValue, Decription, true, PointValue, PaymentCode, CodingControl.GetUserIP(), (int)EPAYSetting.ExpireSecond, p);
            if (paymentResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
            {
                EWin.Payment.Result updateTagResult = paymentAPI.UpdateTagInfo(GetToken(), GUID, paymentResult.PaymentSerial, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData));

                if (updateTagResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                {
                    var CreateEPayDepositeReturn = Payment.EPay.CreateEPayDeposite(paymentResult.PaymentSerial, Amount, UserName);
                    if (CreateEPayDepositeReturn.ResultState == Payment.APIResult.enumResultCode.OK)
                    {

                        PaymentCommonData TempCommonData = new PaymentCommonData() {PaymentSerial= paymentResult.PaymentSerial,ExpireSecond= (int)EPAYSetting.ExpireSecond,Amount=Amount,ReceiveCurrencyType=EWinWeb.MainCurrencyType};
                        R.Result = enumResult.OK;
                        R.Data = TempCommonData;
                        R.Message = CreateEPayDepositeReturn.Message;

                    }
                    else
                    {
                        SetResultException(R, "UpdateFailure2");
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
            SetResultException(R, "InvalidWebSID");
        }

        return R;
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public PaymentCommonResult CreateEPayWithdrawal(string SID, string GUID, string BankCard, string BankCardName, string BankName,string BankBranchCode,decimal Amount)
    {
        PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
        //APIResult CreateEPayWithdrawalReturn = new APIResult() { GUID = GUID, Result = enumResult.ERR };
        string Path;
        decimal PointValue;
        decimal ReceiveAmount;
        dynamic EPAYSetting = null;
        string SettingFile = "EPaySetting.json";
        string Token = GetToken();
        string OrderNumber= Guid.NewGuid().ToString("N");
        Newtonsoft.Json.Linq.JObject BankDatas = new Newtonsoft.Json.Linq.JObject();

        if (EWinWeb.IsTestSite)
        {
            Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Test_" + SettingFile);
        }
        else
        {
            Path = HttpContext.Current.Server.MapPath("/App_Data/EPay/Formal_" + SettingFile);
        }

        if (System.IO.File.Exists(Path))
        {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Path);

            if (string.IsNullOrEmpty(SettingContent) == false)
            {
                try { EPAYSetting = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
            }
        }
        else
        {
            SetResultException(R, "GetSettingFail");
            return R;
        }

        if (EPAYSetting == null)
        {
            SetResultException(R, "GetSettingFail");
            return R;
        }

        if (string.IsNullOrEmpty(BankCard))
        {
            R.Message = "BankCard Empty";
            return R;
        }

        if (string.IsNullOrEmpty(BankCardName))
        {
            R.Message = "BankCardName Empty";
            return R;
        }

        if (string.IsNullOrEmpty(BankName))
        {
            R.Message = "BankName Empty";
            return R;
        }

        if (string.IsNullOrEmpty(BankBranchCode))
        {
            R.Message = "BankBranchCode Empty";
            return R;
        }

        if (Amount < (decimal)EPAYSetting.MinWithdrawAmount)
        {
            SetResultException(R, "AmountLessThanMinLimit");
            return R;
        }


        if (Amount > (decimal)EPAYSetting.MaxWithdrawAmount)
        {
            SetResultException(R, "AmountGreaterThanMaxlimit");
            return R;
        }

        if ((int)EPAYSetting.WithdrawType!=0)
        {
            SetResultException(R, "PaymentMethodDisable");
            return R;
        }


        if (EWinWeb.CheckInWithdrawalTime())
        {
            if (!EWinWeb.IsWithdrawlTemporaryMaintenance())
            {

                EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
                EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SID, GUID);
                EWin.Lobby.ThresholdInfo thresholdInfo;


                if (userInfoResult.Result == EWin.Lobby.enumResult.OK)
                {
                    thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

                    if (thresholdInfo != null)
                    {
                        if (thresholdInfo.ThresholdValue == 0)
                        {
                            PointValue = Amount;

                            BankDatas.Add("BankCard",BankCard);
                            BankDatas.Add("BankCardName",BankCardName);
                            BankDatas.Add("BankName",BankName);
                            BankDatas.Add("ReceiveAmount",PointValue);
                            //準備送出至EWin

                            EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
                            EWin.Payment.PaymentResult paymentResult;
                            List<EWin.Payment.PaymentDetailBankCard> paymentDetailBankCards = new List<EWin.Payment.PaymentDetailBankCard>();
                            ReceiveAmount = (Amount * (1 -  (decimal)EPAYSetting.WithdrawRate)) -  (decimal)EPAYSetting.WithdrawHandlingFee;
                            //Description待實際測試後調整
                            string Decription = "ReceiveAmount:"+ReceiveAmount+",Card Number:"+BankCard+",Name:"+BankCardName+",BankName:"+BankName+",BankBranchCode:"+BankBranchCode;

                            EWin.Payment.PaymentDetailBankCard paymentDetailWallet = new EWin.Payment.PaymentDetailBankCard()
                            {
                                Status = EWin.Payment.enumBankCardStatus.None,
                                BankCardType = EWin.Payment.enumBankCardType.UserAccountBankCard,
                                BankCode = "",
                                BankName = BankName,
                                BranchName = BankBranchCode,
                                BankNumber = BankCard,
                                AccountName = BankCardName,
                                AmountMax = 9999999999,
                                BankCardGUID = Guid.NewGuid().ToString("N"),
                                Description = "",
                                TaxFeeValue = Amount - ReceiveAmount
                            };
                            paymentDetailBankCards.Add(paymentDetailWallet);
                            paymentResult = paymentAPI.CreatePaymentWithdrawal(GetToken(), userInfoResult.LoginAccount, GUID, EWinWeb.MainCurrencyType, OrderNumber, Amount,paymentDetailWallet.TaxFeeValue ,Decription, true, PointValue * -1, (string)EPAYSetting.PaymentCode, CodingControl.GetUserIP(),  (int)EPAYSetting.ExpireSecond, paymentDetailBankCards.ToArray());
                            if (paymentResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                            {
                                var CreateEPayWithdrawalReturn= Payment.EPay.CreateEPayWithdrawal(paymentResult.PaymentSerial,ReceiveAmount,paymentResult.CreateDate,BankCard,BankCardName,BankName,BankBranchCode);
                                if (CreateEPayWithdrawalReturn.ResultState == Payment.APIResult.enumResultCode.OK)
                                {

                                    PaymentCommonData TempCommonData = new PaymentCommonData() {PaymentSerial= paymentResult.PaymentSerial,CreateDate=paymentResult.CreateDate.ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss"),Amount=Amount,ReceiveTotalAmount=ReceiveAmount,ReceiveCurrencyType=EWinWeb.MainCurrencyType};
                                    R.Result = enumResult.OK;
                                    R.Message = paymentResult.PaymentSerial;
                                    R.Data = TempCommonData;
                                    //清除獎金
                                    //取得可領獎金資料
                                    //var PromotionCollectResult = lobbyAPI.GetPromotionCollectAvailable(Token, SI.EWinSID, GUID);

                                    //if (PromotionCollectResult.Result == EWin.Lobby.enumResult.OK)
                                    //{

                                    //    EWin.Lobby.APIResult R1 = new EWin.Lobby.APIResult() { GUID = GUID, Result = EWin.Lobby.enumResult.ERR };
                                    //    var collectList = PromotionCollectResult.CollectList.Where(x => x.CollectAreaType == 1).ToList();

                                    //    foreach (var item in collectList)
                                    //    {
                                    //        R1 = lobbyAPI.SetExpireUserAccountPromotionByID(Token, SI.EWinSID, GUID, item.CollectID);
                                    //    }
                                    //}

                                }
                                else
                                {
                                    SetResultException(R, "UpdateFailure");
                                }
                            }
                            else
                            {
                                SetResultException(R, paymentResult.ResultMessage);
                            }

                        }
                        else
                        {
                            SetResultException(R, "ThresholdLimit");
                        }
                    }
                    else
                    {
                        SetResultException(R, "ThresholdLimit");
                    }
                }
                else
                {
                    SetResultException(R, "GetThresholdError");
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

        return R;
    }





    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public PaymentCommonResult ConfirmBankCardDeposit(string WebSID, string GUID, string OrderNumber, string[] ActivityNames, string Lang,string PaymentSerial) {
    //    PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
    //    PaymentCommonData TempCommonData;
    //    RedisCache.SessionContext.SIDInfo SI;
    //    EWinTagInfoData tagInfoData = new EWinTagInfoData() { };
    //    string JoinActivityFailedMsg = string.Empty;
    //    decimal PointValue;
    //    string ReceiveCurrencyType;

    //    dynamic o = null;


    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
    //        //取得Temp(未確認)訂單
    //        TempCommonData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);

    //        if (TempCommonData != null) {
    //            tagInfoData.PaymentMethodID = TempCommonData.PaymentMethodID;
    //            tagInfoData.PaymentCode = TempCommonData.PaymentCode;
    //            tagInfoData.PaymentMethodName = TempCommonData.PaymentMethodName;
    //            tagInfoData.ThresholdRate = TempCommonData.ThresholdRate;
    //            tagInfoData.ThresholdValue = TempCommonData.ThresholdValue;
    //            PointValue = TempCommonData.Amount;
    //            ReceiveCurrencyType = TempCommonData.ReceiveCurrencyType;

    //            if (ActivityNames.Length > 0) {
    //                tagInfoData.IsJoinDepositActivity = true;
    //                tagInfoData.ActivityDatas = new List<EWinTagInfoActivityData>();
    //                //有儲值參加活動
    //                foreach (var ActivityName in ActivityNames) {
    //                    ActivityCore.ActResult<ActivityCore.DepositActivity> activityDepositResult = ActivityCore.GetDepositResult(ActivityName, TempCommonData.Amount, TempCommonData.PaymentCode, TempCommonData.LoginAccount);

    //                    if (activityDepositResult.Result == ActivityCore.enumActResult.OK) {
    //                        EWinTagInfoActivityData infoActivityData = new EWinTagInfoActivityData() {
    //                            ActivityName = ActivityName,
    //                            BonusRate = activityDepositResult.Data.BonusRate,
    //                            BonusValue = activityDepositResult.Data.BonusValue,
    //                            ThresholdRate = activityDepositResult.Data.ThresholdRate,
    //                            ThresholdValue = activityDepositResult.Data.ThresholdValue,
    //                        };
    //                        PointValue += activityDepositResult.Data.BonusValue;
    //                        tagInfoData.ActivityDatas.Add(infoActivityData);
    //                    } else {
    //                        JoinActivityFailedMsg += "Join " + ActivityName + " Failed,";
    //                        break;
    //                    }
    //                }
    //            } else {
    //                tagInfoData.IsJoinDepositActivity = false;
    //                //沒參加儲值活動
    //            }

    //            if (string.IsNullOrEmpty(JoinActivityFailedMsg)) {

    //                //準備送出至EWin

    //                EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();

    //                string Decription = TempCommonData.PaymentMethodName + ", ReceiveTotalAmount=" + TempCommonData.ReceiveTotalAmount.ToString("F10");


    //                EWin.Payment.Result updateTagResult = paymentAPI.UpdateTagInfo(GetToken(), GUID, PaymentSerial, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData));

    //                if (updateTagResult.ResultStatus == EWin.Payment.enumResultStatus.OK) {

    //                    int UpdateRet = EWinWebDB.UserAccountPayment.ConfirmPayment(OrderNumber, "", PaymentSerial, "", PointValue, Newtonsoft.Json.JsonConvert.SerializeObject(tagInfoData.ActivityDatas));

    //                    if (UpdateRet == 1) {
    //                        R.Result = enumResult.OK;
    //                        R.Data = TempCommonData;
    //                        TempCommonData.PaymentSerial = PaymentSerial;
    //                        TempCommonData.ActivityDatas = tagInfoData.ActivityDatas;
    //                        TempCommonData.PointValue = PointValue;

    //                        RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(TempCommonData), OrderNumber, TempCommonData.ExpireSecond);
    //                        RedisCache.PaymentContent.KeepPaymentContents(TempCommonData, SI.LoginAccount);
    //                    } else {
    //                        SetResultException(R, "UpdateFailure");
    //                    }
    //                } else {
    //                    SetResultException(R, updateTagResult.ResultMessage);
    //                    paymentAPI.CancelPayment(GetToken(), GUID, PaymentSerial);
    //                }


    //            } else {
    //                JoinActivityFailedMsg = JoinActivityFailedMsg.Substring(0, JoinActivityFailedMsg.Length - 1);
    //                SetResultException(R, JoinActivityFailedMsg);
    //            }
    //        } else {
    //            SetResultException(R, "OrderNotExist");
    //        }
    //    } else {
    //        SetResultException(R, "InvalidWebSID");
    //    }

    //    return R;
    //}


    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public PaymentCommonBankCardResult CreateBankCardDeposit(string WebSID, string GUID, decimal Amount, int PaymentMethodID) {
    //    PaymentCommonBankCardResult R = new PaymentCommonBankCardResult() { GUID = GUID, Result = enumResult.ERR };
    //    PaymentCommonData paymentCommonData = new PaymentCommonData() { };
    //    PaymentCommonBankData paymentBankCommonData = new PaymentCommonBankData() { };
    //    RedisCache.SessionContext.SIDInfo SI;
    //    string PaymentMethodName;
    //    string PaymentCode;
    //    string ReceiveCurrencyType;
    //    string ExtraData;
    //    int MinLimit;
    //    int MaxLimit;
    //    decimal ReceiveTotalAmount;
    //    decimal ThresholdRate;
    //    decimal HandingFeeRate;
    //    int ExpireSecond;
    //    System.Data.DataTable PaymentMethodDT;


    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
    //        PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByID(PaymentMethodID);

    //        if (PaymentMethodDT != null && PaymentMethodDT.Rows.Count > 0) {
    //            if ((int)PaymentMethodDT.Rows[0]["State"] == 0) {
    //                if ((int)PaymentMethodDT.Rows[0]["PaymentType"] == 0) {
    //                    MinLimit = (int)PaymentMethodDT.Rows[0]["MinLimit"];
    //                    MaxLimit = (int)PaymentMethodDT.Rows[0]["MaxLimit"];

    //                    if (Amount >= MinLimit) {
    //                        if (Amount <= MaxLimit || MaxLimit == 0) {
    //                            if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 1) {
    //                                string OrderNumber = System.Guid.NewGuid().ToString();
    //                                int InsertRet;

    //                                PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
    //                                PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
    //                                ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];

    //                                ThresholdRate = (decimal)PaymentMethodDT.Rows[0]["ThresholdRate"];
    //                                ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
    //                                ExtraData = (string)PaymentMethodDT.Rows[0]["ExtraData"];

    //                                if (string.IsNullOrEmpty(ExtraData)) {
    //                                    HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
    //                                } else {
    //                                    HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
    //                                    try {
    //                                        Newtonsoft.Json.Linq.JArray rangeRates = Newtonsoft.Json.Linq.JArray.Parse(ExtraData);
    //                                        foreach (var rangeRate in rangeRates) {
    //                                            decimal RangeMinValuie = (decimal)rangeRate["RangeMinValuie"];
    //                                            decimal RangeMaxValuie = (decimal)rangeRate["RangeMaxValuie"];

    //                                            if (RangeMaxValuie != 0) {
    //                                                if (RangeMinValuie <= Amount && Amount < RangeMaxValuie) {
    //                                                    HandingFeeRate = (decimal)rangeRate["RangeRate"];
    //                                                    break;
    //                                                }
    //                                            } else {
    //                                                if (RangeMinValuie <= Amount) {
    //                                                    HandingFeeRate = (decimal)rangeRate["RangeRate"];
    //                                                    break;
    //                                                }
    //                                            }
    //                                        }
    //                                    } catch (Exception) {
    //                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
    //                                    }
    //                                }
    //                                ReceiveTotalAmount = Amount * (1 + HandingFeeRate);

    //                                paymentCommonData.PaymentType = 0;
    //                                paymentCommonData.BasicType = 1;
    //                                paymentCommonData.OrderNumber = OrderNumber;
    //                                paymentCommonData.LoginAccount = SI.LoginAccount;
    //                                paymentCommonData.Amount = Amount;
    //                                paymentCommonData.HandingFeeRate = HandingFeeRate;
    //                                paymentCommonData.HandingFeeAmount = 0;
    //                                paymentCommonData.ReceiveCurrencyType = ReceiveCurrencyType;
    //                                paymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
    //                                paymentCommonData.ExpireSecond = ExpireSecond;
    //                                paymentCommonData.PaymentMethodID = PaymentMethodID;
    //                                paymentCommonData.PaymentMethodName = PaymentMethodName;
    //                                paymentCommonData.PaymentCode = PaymentCode;
    //                                paymentCommonData.ThresholdRate = ThresholdRate;
    //                                paymentCommonData.ThresholdValue = Amount * ThresholdRate;
    //                                paymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");

    //                                EWin.EWinWeb.EWinWeb _CASINO3651API = new EWin.EWinWeb.EWinWeb();

    //                                //PaymentMethod 0=上分/1=下分
    //                                EWin.EWinWeb.BankCardDepositResult bankCardDepositRet= _CASINO3651API.BankCardDepostit(SI.EWinCT,GUID,EWinWeb.MainCurrencyType,0,Amount,"",OrderNumber);

    //                                if (bankCardDepositRet.ResultState == EWin.EWinWeb.enumResultState.OK)
    //                                {
    //                                    paymentBankCommonData.BankCode = bankCardDepositRet.BankCardInfo.BankCode;
    //                                    paymentBankCommonData.BankName=bankCardDepositRet.BankCardInfo.BankName;
    //                                    paymentBankCommonData.AmountMax = bankCardDepositRet.BankCardInfo.AmountMax;
    //                                    paymentBankCommonData.AccountName=bankCardDepositRet.BankCardInfo.AccountName;
    //                                    paymentBankCommonData.BankNumber = bankCardDepositRet.BankCardInfo.BankNumber;
    //                                    paymentBankCommonData.BranchName=bankCardDepositRet.BankCardInfo.BranchName;
    //                                    paymentBankCommonData.PaymentSerial=bankCardDepositRet.PaymentSerial;
    //                                    InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, paymentCommonData.PaymentType, 0, paymentCommonData.LoginAccount, paymentCommonData.Amount, paymentCommonData.HandingFeeRate, paymentCommonData.HandingFeeAmount, paymentCommonData.ThresholdRate, paymentCommonData.ThresholdValue, paymentCommonData.PaymentMethodID, "", "", "", paymentCommonData.ExpireSecond);

    //                                    if (InsertRet == 1)
    //                                    {
    //                                        R.Result = enumResult.OK;
    //                                        R.Data = paymentCommonData;
    //                                        R.BankData = paymentBankCommonData;
    //                                        RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(paymentCommonData), paymentCommonData.OrderNumber);
    //                                    }
    //                                    else
    //                                    {
    //                                        SetResultException(R, "InsertFailure");
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    SetResultException(R, "InsertFailure");
    //                                }

    //                            } else {
    //                                SetResultException(R, "PaymentMethodNotCrypto");
    //                            }
    //                        } else {
    //                            SetResultException(R, "AmountGreaterThanMaxlimit");
    //                        }
    //                    } else {
    //                        SetResultException(R, "AmountLessThanMinLimit");
    //                    }
    //                } else {
    //                    SetResultException(R, "PaymentMethodNotSupportDeposit");
    //                }
    //            } else {
    //                SetResultException(R, "PaymentMethodDisable");
    //            }
    //        } else {
    //            SetResultException(R, "PaymentMethodNotExist");
    //        }
    //    } else {
    //        SetResultException(R, "InvalidWebSID");
    //    }

    //    return R;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public PaymentCommonResult CreateBankCardWithdrawal(string WebSID, string GUID, decimal Amount)
    //{
    //    PaymentCommonResult R = new PaymentCommonResult() { GUID = GUID, Result = enumResult.ERR };
    //    PaymentCommonData PaymentCommonData = new PaymentCommonData() { PaymentCryptoDetailList = new List<CryptoDetail>() };

    //    RedisCache.SessionContext.SIDInfo SI;
    //    string PaymentMethodName;
    //    string PaymentCode;
    //    string ReceiveCurrencyType;
    //    int MinLimit;
    //    int MaxLimit;
    //    int DailyMaxAmount;
    //    int DailyMaxCount;
    //    decimal ReceiveTotalAmount;
    //    decimal HandingFeeRate;
    //    int HandingFeeAmount;
    //    decimal WithdrawalAmountByDay;
    //    int WithdrawalCountByDay;
    //    int ExpireSecond;
    //    int DecimalPlaces;
    //    int PaymentMethodID;
    //    System.Data.DataTable PaymentMethodDT;

    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID))
    //    {
    //        if (EWinWeb.CheckInWithdrawalTime())
    //        {
    //            if (!EWinWeb.IsWithdrawlTemporaryMaintenance())
    //            {

    //                PaymentMethodDT = RedisCache.PaymentMethod.GetPaymentMethodByCategory("BankCard");
    //                var PaymentMethodRow=PaymentMethodDT.Select("PaymentType=1").FirstOrDefault();

    //                if (PaymentMethodRow != null )
    //                {
    //                    if ((int)PaymentMethodRow["State"] == 0)
    //                    {
    //                        if ((int)PaymentMethodRow["PaymentType"] == 1)
    //                        {
    //                            MinLimit = (int)PaymentMethodRow["MinLimit"];
    //                            MaxLimit = (int)PaymentMethodRow["MaxLimit"];
    //                            DailyMaxCount = (int)PaymentMethodRow["DailyMaxCount"];
    //                            DailyMaxAmount = (int)PaymentMethodRow["DailyMaxAmount"];
    //                            DecimalPlaces = (int)PaymentMethodRow["DecimalPlaces"];
    //                            PaymentMethodID= (int)PaymentMethodRow["PaymentMethodID"];
    //                            if (Amount >= MinLimit)
    //                            {
    //                                if (Amount <= MaxLimit || MaxLimit == 0)
    //                                {
    //                                    System.Data.DataTable SummaryDT = EWinWebDB.UserAccountPayment.GetTodayPaymentByLoginAccount(SI.LoginAccount, 1);

    //                                    if (SummaryDT != null && SummaryDT.Rows.Count > 0)
    //                                    {
    //                                        WithdrawalAmountByDay = 0;
    //                                        foreach (System.Data.DataRow dr in SummaryDT.Rows)
    //                                        {
    //                                            WithdrawalAmountByDay += (decimal)dr["Amount"];
    //                                        }
    //                                        WithdrawalCountByDay = SummaryDT.Rows.Count;
    //                                    }
    //                                    else
    //                                    {
    //                                        WithdrawalAmountByDay = 0;
    //                                        WithdrawalCountByDay = 0;
    //                                    }

    //                                    if (DailyMaxCount == 0 || (WithdrawalCountByDay + 1) <= DailyMaxCount)
    //                                    {
    //                                        if (DailyMaxAmount == 0 || (WithdrawalAmountByDay + Amount) <= DailyMaxAmount)
    //                                        {
    //                                            if ((int)PaymentMethodDT.Rows[0]["EWinPaymentType"] == 1)
    //                                            {
    //                                                //Check ThresholdValue
    //                                                EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
    //                                                EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
    //                                                EWin.Lobby.ThresholdInfo thresholdInfo;
    //                                                decimal thresholdValue;

    //                                                if (userInfoResult.Result == EWin.Lobby.enumResult.OK)
    //                                                {
    //                                                    thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

    //                                                    if (thresholdInfo != null)
    //                                                    {
    //                                                        thresholdValue = thresholdInfo.ThresholdValue;
    //                                                    }
    //                                                    else
    //                                                    {
    //                                                        thresholdValue = 0;
    //                                                    }
    //                                                    if (thresholdValue == 0)
    //                                                    {
    //                                                        PaymentMethodName = (string)PaymentMethodDT.Rows[0]["PaymentName"];
    //                                                        PaymentCode = (string)PaymentMethodDT.Rows[0]["PaymentCode"];
    //                                                        ReceiveCurrencyType = (string)PaymentMethodDT.Rows[0]["CurrencyType"];
    //                                                        ExpireSecond = (int)PaymentMethodDT.Rows[0]["ExpireSecond"];
    //                                                        HandingFeeRate = (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"];
    //                                                        HandingFeeAmount = (int)PaymentMethodDT.Rows[0]["HandingFeeAmount"];
    //                                                        ReceiveTotalAmount = (Amount * (1 - (decimal)PaymentMethodDT.Rows[0]["HandingFeeRate"])) - HandingFeeAmount;


    //                                                        string OrderNumber = System.Guid.NewGuid().ToString();
    //                                                        int InsertRet;

    //                                                        PaymentCommonData.PaymentType = 1;
    //                                                        PaymentCommonData.BasicType = 1;
    //                                                        PaymentCommonData.OrderNumber = OrderNumber;
    //                                                        PaymentCommonData.LoginAccount = SI.LoginAccount;
    //                                                        PaymentCommonData.Amount = Amount;
    //                                                        PaymentCommonData.ReceiveTotalAmount = ReceiveTotalAmount;
    //                                                        PaymentCommonData.HandingFeeRate = HandingFeeRate;
    //                                                        PaymentCommonData.HandingFeeAmount = HandingFeeAmount;
    //                                                        PaymentCommonData.ExpireSecond = ExpireSecond;
    //                                                        PaymentCommonData.PaymentMethodID = PaymentMethodID;
    //                                                        PaymentCommonData.PaymentMethodName = PaymentMethodName;
    //                                                        PaymentCommonData.PaymentCode = PaymentCode;
    //                                                        PaymentCommonData.CreateDate = DateTime.Now.ToString("yyyy/MM/dd hh:mm");

    //                                                        InsertRet = EWinWebDB.UserAccountPayment.InsertPayment(OrderNumber, PaymentCommonData.PaymentType, 1, PaymentCommonData.LoginAccount, PaymentCommonData.Amount, PaymentCommonData.HandingFeeRate, PaymentCommonData.HandingFeeAmount, 0, 0, PaymentCommonData.PaymentMethodID, "", "", "", PaymentCommonData.ExpireSecond);

    //                                                        if (InsertRet == 1)
    //                                                        {
    //                                                            R.Result = enumResult.OK;
    //                                                            R.Data = PaymentCommonData;
    //                                                            RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(R.Data), PaymentCommonData.OrderNumber);
    //                                                        }
    //                                                        else
    //                                                        {
    //                                                            SetResultException(R, "InsertFailure");
    //                                                        }

    //                                                    }
    //                                                    else
    //                                                    {
    //                                                        SetResultException(R, "ThresholdLimit");
    //                                                    }
    //                                                }
    //                                                else
    //                                                {
    //                                                    SetResultException(R, "GetInfoError");
    //                                                }

    //                                            }
    //                                            else
    //                                            {
    //                                                SetResultException(R, "PaymentMethodNotCrypto");
    //                                            }

    //                                        }
    //                                        else
    //                                        {
    //                                            SetResultException(R, "DailyAmountGreaterThanMaxlimit");
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        SetResultException(R, "DailyCountGreaterThanMaxlimit");
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    SetResultException(R, "AmountGreaterThanMaxlimit");
    //                                }
    //                            }
    //                            else
    //                            {
    //                                SetResultException(R, "AmountLessThanMinLimit");
    //                            }
    //                        }
    //                        else
    //                        {
    //                            SetResultException(R, "PaymentMethodNotSupportDeposit");
    //                        }
    //                    }
    //                    else
    //                    {
    //                        SetResultException(R, "PaymentMethodDisable");
    //                    }
    //                }
    //                else
    //                {
    //                    SetResultException(R, "PaymentMethodNotExist");
    //                }
    //            }
    //            else
    //            {
    //                SetResultException(R, "WithdrawlTemporaryMaintenance");
    //            }
    //        }
    //        else
    //        {
    //            SetResultException(R, "NotInOpenTime");
    //        }
    //    }
    //    else
    //    {
    //        SetResultException(R, "InvalidWebSID");
    //    }

    //    return R;
    //}


    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public APIResult ConfirmBankCardWithdrawal(string WebSID, string GUID, string OrderNumber,string BankName,string BankBranchName,string BankCard,string BankCardName) {
    //    APIResult R = new APIResult() { GUID = GUID, Result = enumResult.ERR };
    //    PaymentCommonData TempData;
    //    RedisCache.SessionContext.SIDInfo SI;
    //    decimal PointValue;

    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
    //        if (EWinWeb.CheckInWithdrawalTime()) {
    //            if (!EWinWeb.IsWithdrawlTemporaryMaintenance()) {
    //                //取得Temp(未確認)訂單
    //                TempData = RedisCache.PaymentContent.GetPaymentContent<PaymentCommonData>(OrderNumber);

    //                if (TempData != null) {
    //                    EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
    //                    EWin.Lobby.UserInfoResult userInfoResult = lobbyAPI.GetUserInfo(GetToken(), SI.EWinSID, GUID);
    //                    EWin.Lobby.ThresholdInfo thresholdInfo;


    //                    if (userInfoResult.Result == EWin.Lobby.enumResult.OK) {
    //                        thresholdInfo = userInfoResult.ThresholdInfo.Where(x => x.CurrencyType.ToUpper() == EWinWeb.MainCurrencyType.ToUpper()).FirstOrDefault();

    //                        if (thresholdInfo != null) {
    //                            if (thresholdInfo.ThresholdValue == 0) {
    //                                PointValue = TempData.Amount;

    //                                EWin.Lobby.APIResult addUserBankCard = lobbyAPI.AddUserBankCard(GetToken(), SI.EWinSID, GUID,EWinWeb.MainCurrencyType,0,BankName,BankBranchName,BankCard,BankCardName,"");
    //                                if (addUserBankCard.Result == EWin.Lobby.enumResult.OK || addUserBankCard.Message == "BankNumberExist")
    //                                {
    //                                    EWin.Lobby.UserBankCardListResult userBankCardListResult = lobbyAPI.GetUserBankCard(GetToken(), SI.EWinSID, GUID);
    //                                    if (userBankCardListResult.Result == EWin.Lobby.enumResult.OK)
    //                                    {
    //                                        string BankCardGUID = userBankCardListResult.BankCardList.Where(s => s.CurrencyType == EWinWeb.MainCurrencyType && s.BankName == BankName && s.BankNumber == BankCard).First().BankCardGUID;

    //                                        EWin.EWinWeb.EWinWeb _CASINO3651API = new EWin.EWinWeb.EWinWeb();
    //                                        //PaymentMethod 0=銀行卡
    //                                        EWin.EWinWeb.BankCardWithdrawalResult bankCardWithdrawalRet= new EWin.EWinWeb.BankCardWithdrawalResult();

    //                                        if (bankCardWithdrawalRet.ResultState == EWin.EWinWeb.enumResultState.OK)
    //                                        {

    //                                            int UpdateRet = EWinWebDB.UserAccountPayment.ConfirmPayment(OrderNumber, "", bankCardWithdrawalRet.PaymentSerial, PointValue, "");

    //                                            if (UpdateRet == 1)
    //                                            {
    //                                                R.Result = enumResult.OK;
    //                                                R.Message = bankCardWithdrawalRet.PaymentSerial;
    //                                                TempData.PaymentSerial = bankCardWithdrawalRet.PaymentSerial;
    //                                                TempData.PointValue = PointValue;
    //                                                RedisCache.PaymentContent.UpdatePaymentContent(Newtonsoft.Json.JsonConvert.SerializeObject(TempData), OrderNumber, TempData.ExpireSecond);
    //                                                RedisCache.PaymentContent.KeepPaymentContents(TempData, SI.LoginAccount);
    //                                            }
    //                                            else
    //                                            {
    //                                                SetResultException(R, "UpdateFailure");
    //                                            }

    //                                        }
    //                                        else
    //                                        {
    //                                            SetResultException(R, bankCardWithdrawalRet.Message);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        SetResultException(R, "GetUserBankCardFail");
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    SetResultException(R, "GetUserBankCardFail");
    //                                }
    //                            } else {
    //                                SetResultException(R, "ThresholdLimit");
    //                            }
    //                        } else {
    //                            SetResultException(R, "CurrencyNotFound");
    //                        }
    //                    } else {
    //                        SetResultException(R, "GetThresholdError");
    //                    }
    //                } else {
    //                    SetResultException(R, "OrderNotExist");
    //                }
    //            } else {
    //                SetResultException(R, "WithdrawlTemporaryMaintenance");
    //            }
    //        } else {
    //            SetResultException(R, "NotInOpenTime");
    //        }
    //    } else {
    //        SetResultException(R, "InvalidWebSID");
    //    }
    //    return R;
    //}



    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public AgentWithdrawalListResult GetAgentWithdrawalPayment(string WebSID, string GUID, DateTime SearchDate) {
    //    AgentWithdrawalListResult R = new AgentWithdrawalListResult() { Result = enumResult.ERR,Datas = new List<AgentWithdrawal>() };
    //    EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
    //    RedisCache.SessionContext.SIDInfo SI;
    //    List<AgentWithdrawal> ListEWinRequireWithdrawal = new List<AgentWithdrawal>();
    //    List<AgentWithdrawal> ListEndEWinRequireWithdrawal = new List<AgentWithdrawal>();
    //    string[] separatingStrings = { "<br/>"};
    //    string strDate = SearchDate.Year + "-" + (SearchDate.Month+1);
    //    SI = RedisCache.SessionContext.GetSIDInfo(WebSID);

    //    if (SI != null && !string.IsNullOrEmpty(SI.EWinSID)) {
    //        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

    //        EWin.Lobby.RequireWithdrawalHistoryResult EWinRequireWithdrawal = lobbyAPI.GetRequireWithdrawalHistoryByUserAccountID(GetToken(), SI.EWinSID, GUID, SearchDate.Year, SearchDate.Month + 1);

    //        if (EWinRequireWithdrawal.Result == EWin.Lobby.enumResult.OK)
    //        {
    //            for (int i = 0; i < EWinRequireWithdrawal.HistoryList.Length; i++)
    //            {
    //                var data = new AgentWithdrawal();
    //                var splitDescription = EWinRequireWithdrawal.HistoryList[i].Description.Split(separatingStrings, StringSplitOptions.RemoveEmptyEntries);
    //                if (splitDescription.Length == 5)
    //                {
    //                    data.GUID = splitDescription[0];
    //                    data.BankName = splitDescription[1];
    //                    data.BankBranchName = splitDescription[2];
    //                    data.BankCard = splitDescription[3];
    //                    data.BankCardName = splitDescription[4];
    //                }
    //                else {
    //                    data.GUID = splitDescription[0];
    //                    data.BankName = splitDescription[1];
    //                    data.BankCard = splitDescription[2];
    //                    data.BankCardName = splitDescription[3];
    //                }

    //                data.Status = EWinRequireWithdrawal.HistoryList[i].ProcessStatus;
    //                data.Amount = EWinRequireWithdrawal.HistoryList[i].Amount;
    //                data.FinishDate = EWinRequireWithdrawal.HistoryList[i].CreateDate + " " + EWinRequireWithdrawal.HistoryList[i].CreateTime;

    //                ListEWinRequireWithdrawal.Add(data);
    //            }

    //        }

    //        List<AgentWithdrawal> ListRequireWithdrawal = RedisCache.AgentWithdrawalContent.GetWithdrawalContents<List<AgentWithdrawal>>(SI.LoginAccount, strDate);
    //        if (ListRequireWithdrawal != null && ListRequireWithdrawal.Count > 0)
    //        {
    //            for (int i = 0; i < ListRequireWithdrawal.Count; i++)
    //            {
    //                if (ListEWinRequireWithdrawal != null)
    //                {
    //                    var EWinRequireWithdrawalData = ListEWinRequireWithdrawal.Find(x => x.GUID.Contains(ListRequireWithdrawal[i].GUID));
    //                    if (EWinRequireWithdrawalData != null)
    //                    {
    //                        ListRequireWithdrawal[i].Status = EWinRequireWithdrawalData.Status;
    //                        ListRequireWithdrawal[i].FinishDate = EWinRequireWithdrawalData.FinishDate;
    //                    }

    //                }
    //                ListEndEWinRequireWithdrawal.Add(ListRequireWithdrawal[i]);
    //            }
    //        }

    //        if (ListEWinRequireWithdrawal != null && ListEWinRequireWithdrawal.Count > 0)
    //        {
    //            if (ListRequireWithdrawal != null)
    //            {
    //                for (int i = 0; i < ListEWinRequireWithdrawal.Count; i++)
    //                {

    //                    var RequireWithdrawalData = ListRequireWithdrawal.Find(x => x.GUID.Contains(ListEWinRequireWithdrawal[i].GUID));
    //                    if (RequireWithdrawalData == null)
    //                    {
    //                        ListEndEWinRequireWithdrawal.Add(ListEWinRequireWithdrawal[i]);
    //                    }
    //                }

    //            }
    //            else {
    //                ListEndEWinRequireWithdrawal = ListEWinRequireWithdrawal;
    //            }
    //        }


    //        if (ListEndEWinRequireWithdrawal.Count > 0)
    //        {
    //            R.Datas = ListEndEWinRequireWithdrawal;
    //            R.Result = enumResult.OK;
    //        }
    //        else {
    //            SetResultException(R, "NoData");
    //        }
    //    } else {
    //        SetResultException(R, "InvalidWebSID");
    //    }

    //    return R;
    //}

    private PaymentCommonData CovertFromRow(System.Data.DataRow row)
    {
        string DetailDataStr = "";
        string ActivityDataStr = "";

        if (!Convert.IsDBNull(row["DetailData"]))
        {
            DetailDataStr = row["DetailData"].ToString();
        }

        if (!Convert.IsDBNull(row["ActivityData"]))
        {
            ActivityDataStr = row["ActivityData"].ToString();
        }



        if (string.IsNullOrEmpty(DetailDataStr))
        {
            PaymentCommonData result = new PaymentCommonData()
            {
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
        }
        else
        {
            PaymentCommonData result = new PaymentCommonData()
            {
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

            if (!string.IsNullOrEmpty(ActivityDataStr))
            {
                result.ActivityDatas = Newtonsoft.Json.JsonConvert.DeserializeObject<List<EWinTagInfoActivityData>>(ActivityDataStr);
            }

            return result;
        }
    }

    private void SetResultException(APIResult R, string Msg)
    {
        if (R != null)
        {
            R.Result = enumResult.ERR;
            R.Message = Msg;
        }
    }

    private string GetToken()
    {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    public class APIResult
    {
        public enumResult Result { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }

    public enum enumResult
    {
        OK = 0,
        ERR = 1
    }

    public class AgentWithdrawalResult : APIResult
    {
        public AgentWithdrawal Data { get; set; }
    }

    public class AgentWithdrawalListResult : APIResult
    {
        public List<AgentWithdrawal> Datas { get; set; }
    }

    public class AgentWithdrawal
    {
        public string LoginAccount { get; set; }
        public string GUID { get; set; }
        public string BankName { get; set; }
        public string BankBranchName { get; set; }
        public string BankCard { get; set; }
        public string BankCardName { get; set; }
        public int Status { get; set; }
        public string CreateDate { get; set; }
        public string FinishDate { get; set; }
        public decimal Amount { get; set; }
    }

    public class PaymentCommonResult : APIResult
    {
        public PaymentCommonData Data { get; set; }
    }

    public class PaymentCommonBankCardResult : APIResult
    {
        public PaymentCommonData Data { get; set; }
        public PaymentCommonBankData BankData { get; set; }
    }

    public class PaymentCommonBankData
    {

        public string AccountName { get; set; }
        public decimal AmountMax { get; set; }
        public string BankName { get; set; }
        public string BankCode { get; set; }
        public string BankNumber { get; set; }
        public string BranchName { get; set; }
        public string PaymentSerial { get; set; }
    }

    public class PaymentCommonListResult : APIResult
    {
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

    public class CryptoDetail
    {
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


    public class PaymentMethodResult : APIResult
    {
        public List<PaymentMethod> PaymentMethodResults { get; set; }
    }

    public class PaymentMethod
    {
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

    public class UserAccountPaymentResult : APIResult
    {
        public List<UserAccountPayment> UserAccountPayments { get; set; }
    }

    public class UserAccountPayment
    {
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

    public class UserAccountEventBonusHistoryResult : APIResult
    {
        public List<UserAccountEventBonusHistory> UserAccountEventBonusHistorys { get; set; }
    }

    public class UserAccountEventBonusHistory
    {
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

    public class BankSelectResult : APIResult
    {
        public string Datas { get; set; }
    }

    public class EPaySetting : APIResult
    {
        public decimal MinDepositAmount { get; set; }
        public decimal MaxDepositAmount { get; set; }
        public decimal MinWithdrawAmount { get; set; }
        public decimal MaxWithdrawAmount { get; set; }
        public decimal DepositRate { get; set; }
        public decimal WithdrawRate { get; set; }
        public decimal ThresholdRate { get; set; }
        public decimal WithdrawHandlingFee { get; set; }
    }
}