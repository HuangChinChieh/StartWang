using Microsoft.CSharp.RuntimeBinder;
using System;
using System.Collections.Generic;

using System.Web;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
/// <summary>
/// Common 的摘要描述
/// </summary>
public partial class Common : System.Web.UI.Page {
    public static string SettingFile = "AksoPaySetting.json";

    public dynamic PaySetting;
    public dynamic ExchangeRateSetting;

    public Common() {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public APIResult GetToken(string DateTimeStr) {
        PaySetting = LoadSetting();
        JObject returnResult;
        APIResult result=new APIResult();
        JObject jsonContent = new JObject();
        string SendData = "";
        string GetTokenURL = PaySetting.ApiUrl + "/api/get/auth";
        string strDateTime = DateTime.Now.ToString("yyMMddHHmmss");
        string strSign= string.Format("{0}{1}{2}", PaySetting.MerchantNo, strDateTime, PaySetting.AuthKey);
        string Sign = CodingControl.GetMD5(strSign,false);
        //1b4ff434573992cb31bb9903775425c5
        jsonContent.Add("merchantNo", PaySetting.MerchantNo);
        jsonContent.Add("dateTime", strDateTime);
        jsonContent.Add("signature", Sign);

        foreach (var item in jsonContent)
        {
            SendData += item.Key + "=" + item.Value+"&";
        }
        SendData = SendData.Substring(0, SendData.Length - 1);
        returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "POST", SendData, "", "application/x-www-form-urlencoded");

        try {
            if (returnResult["code"] != null&& returnResult["code"].ToString() == "0") {

                result.Message = returnResult["data"]["auth_token"].ToString();
                result.ResultState = APIResult.enumResultCode.OK;

            } 
        } catch (RuntimeBinderException) {
            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "GetToken Fail";
        }

        return result;
    }

    public APIResult CreatePayment(string SID, string CurrencyType, decimal Amount) {
        PaySetting = LoadSetting();
        APIResult result = new APIResult();
        APIResult result_EWin = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;
        JObject jsonContent = new JObject();
        JObject application_context = new JObject();
        string EWinToken = GetEWinToken();
        string strDateTime = DateTime.Now.ToString("yyMMddHHmmss");
        string GetTokenURL = PaySetting.ApiUrl + "/api/transaction/deposit";
        string Token;
        string Channel;
        string Sign;
        string PaymentSerial;
        string SendData = "";
        APIResult CreateEWinPaymentResult;
        APIResult GetTokenResult;
        GetTokenResult = GetToken(strDateTime);

        CreateEWinPaymentResult=CreateEWinPayment(EWinToken,SID, System.Guid.NewGuid().ToString(), CurrencyType,Amount,"AksoPay","");

        if (CreateEWinPaymentResult.ResultState == APIResult.enumResultCode.OK)
        {
            PaymentSerial = CreateEWinPaymentResult.Message;
        }
        else
        {
            result = CreateEWinPaymentResult;
            return result;
        }


        if (GetTokenResult.ResultState == APIResult.enumResultCode.OK)
        {
            Token = GetTokenResult.Message;
        }
        else {
            result = GetTokenResult;
            return result;
        }
        Channel = "007002001";
        application_context.Add("merchantNo", PaySetting.MerchantNo);
        application_context.Add("merchantOrder", PaymentSerial);
        application_context.Add("channel", Channel);

        application_context.Add("amount", Amount.ToString("#.##"));
        application_context.Add("currency", "PHP");
        application_context.Add("dateTime", strDateTime);
        //($merchantNo . $merchantOrder . $channel . $amount . $currency . $dateTime . $pay_key)
        string strSign = string.Format("{0}{1}{2}{3}{4}{5}{6}", PaySetting.MerchantNo, PaymentSerial, Channel, Amount.ToString("#.##"), "PHP", strDateTime, PaySetting.PayKey);
         Sign = CodingControl.GetMD5(strSign, false);
  
        application_context.Add("signature", Sign);
        application_context.Add("callbackUrl", EWinWeb.EWinWebUrl+ "/Payment/AksoPay/PaymentSuccessCallback.aspx");
        

        foreach (var item in application_context)
        {
            SendData += item.Key + "=" + item.Value + "&";
        }
        SendData = SendData.Substring(0, SendData.Length - 1);

        returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "POST", SendData, "Authorization:Bearer "+ Token, "application/x-www-form-urlencoded");

        try {
            if (returnResult["code"] != null&& returnResult["code"].ToString() == "0") {
                //string TransactionID = returnResult["id"].ToString();
                //var ret_jobject = JObject.Parse(returnResult.ToString());

                if (returnResult["data"] != null) {
                    result.ResultState = APIResult.enumResultCode.OK;
                    result.Message = returnResult["data"]["pageUrl"].ToString();
                    //result_EWin = CreateEWinPayment(Token, SID, System.Guid.NewGuid().ToString(), CurrencyType, Amount, "AksoPay", TransactionID);
                    ////result_EWin = CreateEWinPayment(Token, SID, System.Guid.NewGuid().ToString(), TransferCurrency, (Amount*100), "PayPal", TransactionID);

                    //if (result_EWin.ResultState == APIResult.enumResultCode.OK) {
                    //    var link_jarray = JArray.FromObject(ret_jobject["links"]);

                    //    for (int i = 0; i < link_jarray.Count; i++) {
                    //        if (link_jarray[i]["rel"].ToString() == "approve") {
                    //            result.ResultState = APIResult.enumResultCode.OK;
                    //            result.Message = link_jarray[i]["href"].ToString();
                    //        }
                    //    }
                    //} else {
                    //    result.ResultState = APIResult.enumResultCode.ERR;
                    //    result.Message = result_EWin.Message;
                    //}
                } 
                else {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "Return Data Error";
                }
                
            } else {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "Return Code Error data:"+ JsonConvert.SerializeObject(returnResult);
            }
        } catch (RuntimeBinderException) {
            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "CreatePayment Error";
        }

        return result;
    }

    public APIResult QueryPayment(string MerchantOrder)
    {
        PaySetting = LoadSetting();
        APIResult result = new APIResult();
        APIResult result_EWin = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;
        JObject jsonContent = new JObject();
        JObject application_context = new JObject();

        string strDateTime = DateTime.Now.ToString("yyMMddHHmmss");
        string GetTokenURL = PaySetting.ApiUrl + "/api/transaction/deposit/verify";
        string Token;
        string Sign;
        string SendData = "";
  
        APIResult GetTokenResult;
        GetTokenResult = GetToken(strDateTime);

        if (GetTokenResult.ResultState == APIResult.enumResultCode.OK)
        {
            Token = GetTokenResult.Message;
        }
        else
        {
            result = GetTokenResult;
            return result;
        }

 
        application_context.Add("merchantNo", PaySetting.MerchantNo);
        application_context.Add("merchantOrder", MerchantOrder);
        application_context.Add("currency", "PHP");
        application_context.Add("dateTime", strDateTime);
        //($merchantNo . $merchantOrder . $channel . $amount . $currency . $dateTime . $pay_key)
        string strSign = string.Format("{0}{1}{2}{3}", PaySetting.MerchantNo, MerchantOrder, strDateTime, PaySetting.PayKey);
        Sign = CodingControl.GetMD5(strSign, false);

        application_context.Add("signature", Sign);


        foreach (var item in application_context)
        {
            SendData += item.Key + "=" + item.Value + "&";
        }
        SendData = SendData.Substring(0, SendData.Length - 1);

        returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "POST", SendData, "Authorization:Bearer " + Token, "application/x-www-form-urlencoded");

        try
        {
            if (returnResult["code"] != null && returnResult["code"].ToString() == "0")
            {

                if (returnResult["data"] != null&& returnResult["data"]["status"].ToString()=="2")
                {
                    result.ResultState = APIResult.enumResultCode.OK;
                    result.Message = "SUCCESS";
                
                }
                else
                {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "Return Data Error";
                }

            }
            else
            {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "Return Code Error";
            }
        }
        catch (RuntimeBinderException)
        {
            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "QueryPayment Error";
        }

        return result;
    }
    public APIResult CreateEWinPayment(string Token, string SID, string GUID, string CurrencyType, decimal Amount, string PaymentName, string TransactionID) {
        APIResult result = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;
        JObject jsonContent = new JObject();
        string URL = EWinWeb.EWinUrl + "/Payment/External/ExternalPaymentCreate.aspx";

        jsonContent.Add("Token", Token);
        jsonContent.Add("SID", SID);
        jsonContent.Add("GUID", GUID);
        jsonContent.Add("CurrencyType", CurrencyType);
        jsonContent.Add("UserAmount", Amount);
        jsonContent.Add("PaymentName", PaymentName);
        jsonContent.Add("TransactionID", TransactionID);

        returnResult = CodingControl.GetWebJSONContent(URL, "POST", jsonContent.ToString());

        try {
            if (returnResult != null) {
                result = Newtonsoft.Json.JsonConvert.DeserializeObject<APIResult>(returnResult.ToString());
            } else {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "CreateEWinPayment Error";
            }
        } catch (RuntimeBinderException) {
            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "CreateEWinPayment Error";
        }

        return result;
    }

    public APIResult ConfirmEWinPayment(string Token, string GUID, string PaymentName, int PaymentStatus, decimal OrderAmount, decimal PaymentAmount, string PaymentSerial, string OrderDate, string ChannelCode, string RawData, int Autopay, string TransferCurrency) {
        APIResult result = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;
        JObject jsonContent = new JObject();
        string URL = EWinWeb.EWinUrl + "/Payment/External/ExternalPaymentConfirmByPaymentSerial.aspx";

        jsonContent.Add("Token", Token);
        jsonContent.Add("GUID", GUID);
        jsonContent.Add("PaymentName", PaymentName);
        jsonContent.Add("PaymentStatus", PaymentStatus);
        jsonContent.Add("OrderAmount", OrderAmount);
        jsonContent.Add("PaymentAmount", PaymentAmount);
        jsonContent.Add("PaymentSerial", PaymentSerial);
        jsonContent.Add("OrderDate", OrderDate);
        jsonContent.Add("ChannelCode", ChannelCode);
        jsonContent.Add("RawData", RawData);
        jsonContent.Add("Autopay", Autopay);
        jsonContent.Add("TransferCurrency", TransferCurrency);

        returnResult = CodingControl.GetWebJSONContent(URL, "POST", jsonContent.ToString());

        try {
            if (returnResult != null) {
                result = Newtonsoft.Json.JsonConvert.DeserializeObject<APIResult>(returnResult.ToString());
            } else {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "ConfirmEWinPayment Error";
            }
        } catch (RuntimeBinderException) {
            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "ConfirmEWinPayment Error";
        }

        return result;
    }

    public APIResult CheckPaymentState(string PayPalOrderID, string PaypalToken) {
        APIResult result = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;
        string GetTokenURL = PaySetting.ApiUrl + "/v2/checkout/orders/"+ PayPalOrderID;

        returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "GET", "", GetHeaderString(PaypalToken));

        try {
            if (returnResult["id"] != null) {
                string TransactionID = returnResult["id"].ToString();
                
                if (TransactionID == PayPalOrderID) {

                    if (returnResult["status"].ToString() == "APPROVED") {
                        result.ResultState = APIResult.enumResultCode.OK;
                    } else {
                        result.ResultState = APIResult.enumResultCode.ERR;
                        result.Message = "用戶未付款";
                    }
                } else {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "PayPalOrderID err";
                }
            } else {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "No id";
            }
        } catch (RuntimeBinderException) {

            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "CheckPaymentState Error";
        }

        return result;
    }

    public APIResult CapturePayment(string PaymentSerial, string Amount, string RealAmountAmount,string SuccessTime,string Currency,string RawData) {
        APIResult result = new APIResult();
        APIResult ConfirmEWinPaymentresult = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;

        ConfirmEWinPaymentresult = ConfirmEWinPayment(GetEWinToken(), System.Guid.NewGuid().ToString(), "AksoPay", 0, decimal.Parse(Amount) ,decimal.Parse(RealAmountAmount), PaymentSerial, SuccessTime, "AksoPay", RawData, 1, Currency);

        if (ConfirmEWinPaymentresult.ResultState == APIResult.enumResultCode.OK)
        {
            result.ResultState = APIResult.enumResultCode.OK;
            result.Message = "SUCCESS";
        }
        else
        {
            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = ConfirmEWinPaymentresult.Message;
        }

        return result;
    }

    public APIResult CancelPayment(string PayPalOrderID, string PaypalToken) {
        APIResult result = new APIResult();
        APIResult ConfirmEWinPaymentresult = new APIResult();
        Newtonsoft.Json.Linq.JObject returnResult;
        string GetTokenURL = PaySetting.ApiUrl + "/v2/checkout/orders/" + PayPalOrderID;

        returnResult = CodingControl.GetWebJSONContent(GetTokenURL, "GET", "", GetHeaderString(PaypalToken));

        try {
            if (returnResult["id"] != null) {
                string TransactionID = returnResult["id"].ToString();

                if (TransactionID == PayPalOrderID) {

                    JArray PaymenDetail = JArray.FromObject(returnResult["purchase_units"]);
                    decimal OrderAmount = (decimal)PaymenDetail[0]["amount"].SelectToken("value");
                    string OrderDate = DateTime.Parse(returnResult["create_time"].ToString()).AddHours(9).ToString();

                    ConfirmEWinPaymentresult = ConfirmEWinPayment(GetEWinToken(), System.Guid.NewGuid().ToString(), "PayPal", 1, OrderAmount, OrderAmount, TransactionID, OrderDate, "PayPal", returnResult.ToString(), 0, "");

                    if (ConfirmEWinPaymentresult.ResultState == APIResult.enumResultCode.OK) {
                        result.ResultState = APIResult.enumResultCode.OK;
                        result.Message = "/DepositFail.aspx?TranID=" + PayPalOrderID + "&Amount=" + OrderAmount + "&TranDate=" + OrderDate;
                    } else {
                        result.ResultState = APIResult.enumResultCode.ERR;
                        result.Message = ConfirmEWinPaymentresult.Message;
                    }
                } else {
                    result.ResultState = APIResult.enumResultCode.ERR;
                    result.Message = "PayPalOrderID err";
                }
            } else {
                result.ResultState = APIResult.enumResultCode.ERR;
                result.Message = "No id";
            }
        } catch (RuntimeBinderException) {

            result.ResultState = APIResult.enumResultCode.ERR;
            result.Message = "CheckPaymentState Error";
        }

        return result;
    }

    private string GetTokenHeaderString(string Username, string Password) {
        string Ret;
        string HeaderStr = CodingControl.Base64URLEncode(Username + ":" + Password);

        Ret = "Authorization:Basic " + HeaderStr;
        return Ret;
    }

    private string GetHeaderString(string HeaderStr) {
        string Ret;

        Ret = "Authorization:Bearer " + HeaderStr;
        return Ret;
    }

    private string GetEWinToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    private static dynamic LoadSetting() {
        dynamic o = null;
        string Filename;

        if (EWinWeb.IsTestSite) {
            Filename = HttpContext.Current.Server.MapPath("Test_" + SettingFile);
        } else {
            Filename = HttpContext.Current.Server.MapPath("Formal_" + SettingFile);
        }

        if (System.IO.File.Exists(Filename)) {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false) {
                try { o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent); } catch (Exception ex) { }
            }
        }

        return o;
    }

    public class APIResult {
        public enum enumResultCode {
            OK = 0,
            ERR = 1
        }

        public enumResultCode ResultState { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }
}