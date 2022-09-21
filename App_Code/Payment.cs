using Microsoft.CSharp.RuntimeBinder;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;

/// <summary>
/// Payment 的摘要描述
/// </summary>
public class Payment
{
    public Payment()
    {
        //
        // TODO: 在這裡新增建構函式邏輯
        //
    }

    public static class EPay
    {
        public static string SettingFile = "EPaySetting.json";
        public static APIResult CreateEPayWithdrawal(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string BankCard, string BankCardName, string BankName, string BankBranchCode)
        {
            APIResult R = new APIResult() { ResultState = APIResult.enumResultCode.ERR };
            JObject sendData = new JObject();
            string URL;
            string ReturnURL;
            string Path;
            string CompanyCode;
            string CurrencyType;
            string CompanyKey;
            string Sign;
            string result;
            string token = EWinWeb.EPayToken;
            dynamic EPAYSetting = null;
            JObject returnResult;

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

            if (EPAYSetting == null)
            {
                R.Message = "Get EPaySetting Fail";
                return R;
            }

            URL = (string)EPAYSetting.ApiUrl + "RequireWithdraw2";
            ReturnURL = EWinWeb.StartWangUrl + "/Payment/EPay/WithdrawalCallback.aspx";
            CompanyCode = (string)EPAYSetting.CompanyCode;
            CurrencyType = (string)EPAYSetting.CyrrencyType;
            CompanyKey = (string)EPAYSetting.ApiKey;

            Sign = GetEPayWithdrawSign(OrderID, OrderAmount, OrderDateTime, CurrencyType, CompanyCode, CompanyKey);

            sendData.Add("ManageCode", CompanyCode);
            sendData.Add("Currency", CurrencyType);
            sendData.Add("OrderAmount", OrderAmount);
            sendData.Add("BankCard", BankCard);
            sendData.Add("BankCardName", BankCardName);
            sendData.Add("BankName", BankName);
            sendData.Add("BankComponentName", BankBranchCode);
            sendData.Add("OwnProvince", "OwnProvince");
            sendData.Add("OwnCity", "OwnCity");
            sendData.Add("OrderID", OrderID);
            sendData.Add("OrderDate", OrderDateTime.ToString("yyyy-MM-dd HH:mm:ss"));
            sendData.Add("RevolveUrl", ReturnURL);
            sendData.Add("ClientIP", CodingControl.GetUserIP());
            sendData.Add("Sign", Sign);

            using (HttpClientHandler handler = new HttpClientHandler())
            {
                using (HttpClient client = new HttpClient(handler))
                {
                    try
                    {
                        #region 呼叫遠端 Web API

                        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, URL);
                        HttpResponseMessage response = null;

                        #region  設定相關網址內容

                        // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                        //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.TryAddWithoutValidation("token", token);
                        // Content-Type 用於宣告遞送給對方的文件型態
                        //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                        // 將 data 轉為 json
                        string json = sendData.ToString();
                        request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                        response = client.SendAsync(request).GetAwaiter().GetResult();

                        #endregion
                        #endregion

                        #region 處理呼叫完成 Web API 之後的回報結果
                        if (response != null)
                        {
                            if (response.IsSuccessStatusCode == true)
                            {
                                // 取得呼叫完成 API 後的回報內容
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                            }
                            else
                            {
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                            }
                        }
                        else
                        {
                            R.Message = "Create Order Fail";
                            return R;
                        }
                        #endregion

                    }
                    catch (Exception ex)
                    {
                        R.Message = "Create Order Fail";
                        return R;
                    }
                }
            }

            if (!string.IsNullOrEmpty(result))
            {
                returnResult = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(result);
                if (returnResult["Status"].ToString() == "0")
                {
                    R.ResultState = APIResult.enumResultCode.OK;
                    return R;
                }
                else
                {
                    R.Message = "Create Order Fail";
                    return R;
                }
            }
            else
            {
                R.Message = "Send to EPay Fail";
                return R;
            }
        }

        public static APIResult CreateEPayDeposite(string OrderID, decimal OrderAmount, string UserName)
        {
            APIResult R = new APIResult() { ResultState = APIResult.enumResultCode.ERR };
            JObject sendData = new JObject();
            string URL;
            string ReturnURL;
            string Path;
            string CompanyCode;
            string CurrencyType;
            string CompanyKey;
            string ServiceType;
            DateTime OrderDate = DateTime.Now;
            string Sign;
            string result;
            System.Data.DataTable DT = new System.Data.DataTable();
            string token = EWinWeb.EPayToken;
            decimal JPYRate = 0;
            dynamic EPAYSetting = null;
            JObject returnResult;

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

            if (EPAYSetting == null)
            {
                R.Message = "Get EPaySetting Fail";
                return R;
            }

            URL = (string)EPAYSetting.ApiUrl + "RequirePayingReturnUrl";

            ReturnURL = EWinWeb.StartWangUrl + "/Payment/EPay/PaymentCallback.aspx";

            CompanyCode = (string)EPAYSetting.CompanyCode;
            CurrencyType = (string)EPAYSetting.CyrrencyType;
            CompanyKey = (string)EPAYSetting.ApiKey;
            ServiceType = (string)EPAYSetting.ServiceType;
            sendData.Add("ManageCode", CompanyCode);
            sendData.Add("Currency", CurrencyType);
            sendData.Add("Service", ServiceType);
            sendData.Add("CustomerIP", CodingControl.GetUserIP());
            sendData.Add("OrderID", OrderID);
            sendData.Add("OrderDate", OrderDate.ToString("yyyy-MM-dd HH:mm:ss"));
            Sign = GetEPayDepositSign(OrderID, OrderAmount, OrderDate, ServiceType, CurrencyType, CompanyCode, CompanyKey);
            sendData.Add("OrderAmount", OrderAmount.ToString("#.##"));

            sendData.Add("RevolveURL", ReturnURL);
            sendData.Add("UserName", UserName);
            sendData.Add("Sign", Sign);

            using (HttpClientHandler handler = new HttpClientHandler())
            {
                using (HttpClient client = new HttpClient(handler))
                {
                    try
                    {
                        #region 呼叫遠端 Web API

                        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, URL);
                        HttpResponseMessage response = null;

                        #region  設定相關網址內容

                        // Accept 用於宣告客戶端要求服務端回應的文件型態 (底下兩種方法皆可任選其一來使用)
                        //client.DefaultRequestHeaders.Accept.TryParseAdd("application/json");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.TryAddWithoutValidation("token", token);
                        // Content-Type 用於宣告遞送給對方的文件型態
                        //client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");


                        // 將 data 轉為 json
                        string json = sendData.ToString();
                        request.Content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
                        response = client.SendAsync(request).GetAwaiter().GetResult();

                        #endregion
                        #endregion

                        #region 處理呼叫完成 Web API 之後的回報結果
                        if (response != null)
                        {
                            if (response.IsSuccessStatusCode == true)
                            {
                                // 取得呼叫完成 API 後的回報內容
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                            }
                            else
                            {
                                result = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                            }
                        }
                        else
                        {
                            R.Message = "Create Order Fail";
                            return R;
                        }
                        #endregion

                    }
                    catch (Exception ex)
                    {
                        R.Message = "Create Order Fail";
                        return R;
                    }
                }
            }

            if (!string.IsNullOrEmpty(result))
            {
                returnResult = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(result);
                if (returnResult["Status"].ToString() == "0")
                {
                    R.ResultState = APIResult.enumResultCode.OK;
                    R.Message = returnResult["Message"].ToString();
                    return R;
                }
                else
                {
                    R.Message = "Create Order Fail";
                    return R;
                }
            }
            else
            {
                R.Message = "Send to EPay Fail";
                return R;
            }
        }

        public static string GetEPayDepositSign(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string ServiceType, string CurrencyType, string CompanyCode, string CompanyKey)
        {
            string sign;
            string signStr = "ManageCode=" + CompanyCode;
            signStr += "&Currency=" + CurrencyType;
            signStr += "&Service=" + ServiceType;
            signStr += "&OrderID=" + OrderID;
            signStr += "&OrderAmount=" + OrderAmount.ToString("#.##");
            signStr += "&OrderDate=" + OrderDateTime.ToString("yyyy-MM-dd HH:mm:ss");
            signStr += "&CompanyKey=" + CompanyKey;

            sign = CodingControl.GetSHA256(signStr, false).ToUpper();

            return sign;
        }

        private static string GetEPayWithdrawSign(string OrderID, decimal OrderAmount, DateTime OrderDateTime, string CurrencyType, string CompanyCode, string CompanyKey)
        {
            string sign;
            string signStr = "ManageCode=" + CompanyCode;
            signStr += "&Currency=" + CurrencyType;
            signStr += "&OrderID=" + OrderID;
            signStr += "&OrderAmount=" + OrderAmount.ToString("#.##");
            signStr += "&OrderDate=" + OrderDateTime.ToString("yyyy-MM-dd HH:mm:ss");
            signStr += "&CompanyKey=" + CompanyKey;

            sign = CodingControl.GetSHA256(signStr, false);
            return sign.ToUpper();
        }

    }

    public class APIResult
    {
        public enum enumResultCode
        {
            OK = 0,
            ERR = 1
        }

        public enumResultCode ResultState { get; set; }
        public string GUID { get; set; }
        public string Message { get; set; }
    }
}