<%@ WebService Language="C#" Class="MgmtAPI" %>

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
public class MgmtAPI : System.Web.Services.WebService {

    [WebMethod]
    public APIResult OpenSite(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.InMaintenance = 0;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult MaintainSite(string Password, string Message) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.InMaintenance = 1;

                        if (string.IsNullOrEmpty(Message) == false) {
                            o.MaintainMessage = Message;
                        }

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult EnableWithdrawlTemporaryMaintenance(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.WithdrawlTemporaryMaintenance = 1;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult DisableWithdrawlTemporaryMaintenance(string Password) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.WithdrawlTemporaryMaintenance = 0;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    [WebMethod]
    public APIResult UpdateAnnouncement(string Password, string Announcement) {
        APIResult R = new APIResult() { Result = enumResult.ERR };

        dynamic o = null;
        string Filename;

        if (CheckPassword(Password)) {
            Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

            if (System.IO.File.Exists(Filename)) {
                string SettingContent;

                SettingContent = System.IO.File.ReadAllText(Filename);

                if (string.IsNullOrEmpty(SettingContent) == false) {
                    try {
                        o = Newtonsoft.Json.JsonConvert.DeserializeObject(SettingContent);
                        o.LoginMessage["Message"] = Announcement;
                        o.LoginMessage["Version"] = (decimal)o.LoginMessage["Version"] + 1;

                        System.IO.File.WriteAllText(Filename, Newtonsoft.Json.JsonConvert.SerializeObject(o));
                        R.Result = enumResult.OK;
                    } catch (Exception ex) { }
                }
            }

        } else {
            SetResultException(R, "InvalidPassword");
        }

        return R;
    }

    private bool CheckPassword(string Hash) {
        string key = EWinWeb.PrivateKey;

        bool Ret = false;
        int index = Hash.IndexOf('_');
        string tempStr1 = Hash.Substring(0, index);
        string tempStr2 = Hash.Substring(index + 1);
        string checkHash = "";
        DateTime CreateTime;
        DateTime TargetTime;
        if (index > 0) {
            if (DateTime.TryParse(tempStr1, out CreateTime)) {
                if (CreateTime.AddMinutes(15) >= DateTime.Now.AddSeconds(1)) {
                    TargetTime = RoundUp(CreateTime, TimeSpan.FromMinutes(15));
                    checkHash = CodingControl.GetMD5(TargetTime.ToString("yyyy/MM/dd HH:mm:ss") + key, false).ToLower();
                    if (checkHash.ToLower() == tempStr2) {
                        Ret = true;
                    }
                }
            }
        }

        return Ret;

    }

    private DateTime RoundUp(DateTime dt, TimeSpan d) {
        return new DateTime((dt.Ticks + d.Ticks - 1) / d.Ticks * d.Ticks, dt.Kind);
    }

    private void SetResultException(APIResult R, string Msg) {
        if (R != null) {
            R.Result = enumResult.ERR;
            R.Message = Msg;
        }
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

    public class PaymentValueReslut : APIResult {
        public string LoginAccount { get; set; }
        public string PaymentCode { get; set; }
        public string PaymentSerial { get; set; }
        public decimal Amount { get; set; }
        public decimal TotalPointValue { get; set; }
        public decimal TotalThresholdValue { get; set; }
        public List<string> ActivityDescription { get; set; }
        public string PaymentDescription { get; set; }
    }

    public class UserAccountSummaryResult : APIResult {
        public string SummaryGUID { get; set; }
        public DateTime SummaryDate { get; set; }
        public string LoginAccount { get; set; }
        public int DepositCount { get; set; }
        public decimal DepositRealAmount { get; set; }
        public decimal DepositAmount { get; set; }
        public int WithdrawalCount { get; set; }
        public decimal WithdrawalRealAmount { get; set; }
        public decimal WithdrawalAmount { get; set; }
    }

    public class UserAccountTotalSummaryResult : APIResult {
        public string LoginAccount { get; set; }
        public int DepositCount { get; set; }
        public decimal DepositRealAmount { get; set; }
        public decimal DepositAmount { get; set; }
        public int WithdrawalCount { get; set; }
        public decimal WithdrawalRealAmount { get; set; }
        public decimal WithdrawalAmount { get; set; }
        public DateTime LastDepositDate { get; set; }
        public DateTime LastWithdrawalDate { get; set; }
        public string FingerPrint { get; set; }
    }

    public class BulletinBoardResult : APIResult {
        public int BulletinBoardID { get; set; }
        public string BulletinTitle { get; set; }
        public string BulletinContent { get; set; }
        public DateTime CreateDate { get; set; }
        public int State { get; set; }

    }
}