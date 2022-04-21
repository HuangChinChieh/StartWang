<%@ WebService Language="C#" Class="LobbyAPI" %>

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
public class LobbyAPI : System.Web.Services.WebService {

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult HeartBeat(string GUID, string Echo) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();

        return lobbyAPI.HeartBeat(GUID, Echo);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SendSMS(string GUID, string SMSTypeCode, int RecvUserAccountID, string ContactNumber, string SendContent) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { GUID = GUID, Result = EWin.Lobby.enumResult.ERR };
        string ValidateCode = string.Empty;

        R = lobbyAPI.SendSMS(GetToken(), GUID, SMSTypeCode, RecvUserAccountID, ContactNumber, SendContent);

        return R;
    }

    private EWin.Lobby.APIResult SendMail(string EMail, string ValidateCode, EWin.Lobby.APIResult result, CodingControl.enumSendMailType SendMailType) {
        string Subject = string.Empty;
        string SendBody = string.Empty;
        string LoginAccount = "mail@ewin-soft.com";
        string LoginPassword = "pjxkeuoxnntvjuar";
        Subject = "Verify Code";
        SendBody = " 您的驗證碼為 <Font color='#FF0000'>" + ValidateCode + "</Font>，" + "請您於180分鐘內驗證，如超過時間，請重新發送驗證碼。 <br/><br/>" +
            " 您的验证码为 <Font color='#FF0000'>" + ValidateCode + "</Font>，" + "请您于180分钟内验证，如超过时间，请重新发送验证码。 <br/><br/>" +
            " Your verification code is <Font color='#FF0000'>" + ValidateCode + "</Font>，" + "Please verify within 180 minutes. If the time is exceeded, please resend the verification code. <br/><br/>" +
            " 인증 코드는 <Font color='#FF0000'>" + ValidateCode + "</Font> 입니다. 인증은 180분 내에  완료하여야 합니다. 시간 내에 인증하지 않을 시 인증코드를 재 발송 신청을 부탁드립니다. <br/><br/>" +
            " Mã xác minh của bạn là <Font color='#FF0000'>" + ValidateCode + "</Font> Vui lòng xác minh trong vòng 180 phút. Nếu thời gian xác minh đã hết, vui lòng nhấp lại vào \"Gửi mã xác minh\". <br/><br/>"+
            " あなたの認証番号は <Font color='#FF0000'>" + ValidateCode + "</Font> です。有効時間の180分内に認証をよろしく御願い致します。もし時間を超えたら、認証番号をもう一度発送させをよろしくお願い致します。";
        //SendBody = CodingControl.GetEmailTemp(EMail, ValidateCode, SendMailType);

        try {
            //CodingControl.SendMail("smtp.gmail.com", new System.Net.Mail.MailAddress("Service <service@OCW888.com>"), new System.Net.Mail.MailAddress(EMail), Subject, SendBody, "service@OCW888.com", "koajejksxfyiwixx", "utf-8", true);
          CodingControl.SendMail("smtp.gmail.com", new System.Net.Mail.MailAddress("Service <mail@ewin-soft.com>"), new System.Net.Mail.MailAddress(EMail), Subject, SendBody, LoginAccount, LoginPassword, "utf-8", true);
            result.Result = EWin.Lobby.enumResult.OK;
            result.Message = "";

        } catch (Exception ex) {
            result.Result = EWin.Lobby.enumResult.ERR;
            result.Message = "";
        }
        return result;
    }

    #region Eric

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult GetInfoData2(string GUID,string InfoID)
    {
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { Result = EWin.Lobby.enumResult.ERR };
        int AppID = 0;
        InfoData iInfoData;
        string JsonStr = string.Empty;
        string ReturnStr = string.Empty;
        string InfoDataStr = string.Empty;
        string InfoAccountStr = string.Empty;
        string InfoAccount = string.Empty;
        string[] InfoDataStrArr;
        string[] InfoAccountArr;
        string[] stringSeparators = new string[] { "\r\n" };
        DateTime InfoDate = DateTime.Now.AddHours(Convert.ToInt32(EWinWeb.TimeZone));
        ArrayList RetInfoArr = new ArrayList();
        Random rnd = new Random();
        Newtonsoft.Json.Linq.JObject Jobj = new Newtonsoft.Json.Linq.JObject();

        if (System.IO.Directory.Exists(Server.MapPath("/Files/InfoData")) == false)
        {
            Application["AppID"] = 0;
            Application["AppDate"] = DateTime.Now.ToString("yyyy/MM/dd");
        }


        try
        {
            if (Application["AppDate"].ToString() != DateTime.Now.ToString("yyyy/MM/dd"))
            {
                Application["AppID"] = 0;
                Application["AppDate"] = DateTime.Now.ToString("yyyy/MM/dd");
                System.IO.File.Delete(Server.MapPath("/Files/InfoData") + "/InfoData.txt");
            }
        }
        catch (Exception ex)
        {
            Application["AppID"] = 0;
            Application["AppDate"] = DateTime.Now.ToString("yyyy/MM/dd");
            System.IO.File.Delete(Server.MapPath("/Files/InfoData") + "/InfoData.txt");

        }

        if (System.IO.Directory.Exists(Server.MapPath("/Files/InfoData")) == false)
        {
            System.IO.Directory.CreateDirectory(Server.MapPath("/Files/InfoData"));
        }

        Application.Lock();
        try
        {
            if (System.IO.File.Exists(Server.MapPath("/Files/InfoData") + "/InfoData.txt") == false)
            {
                InfoID = "0";
                InfoAccountStr = System.IO.File.ReadAllText(Server.MapPath("/App_Data") + "/InfoAccount.txt");
                InfoAccountArr = InfoAccountStr.Split(stringSeparators, StringSplitOptions.None);
                for (var i = 0; i < 2500; i++)
                {

                    AppID++;

                    InfoAccount = InfoAccountArr[rnd.Next(0, InfoAccountArr.Length - 1)];
                    InfoAccount = InfoAccount + "**" + rnd.Next(0, 9);

                    iInfoData = new InfoData();
                    iInfoData.InfoID = AppID;
                    iInfoData.InfoDate = InfoDate.ToString("yyyy/MM/dd HH:mm:ss");
                    iInfoData.InfoAccount = InfoAccount;
                    iInfoData.InfoAmount = Convert.ToInt32(rnd.Next(10, 100).ToString() + "00000");

                    InfoDataStr += Newtonsoft.Json.JsonConvert.SerializeObject(iInfoData) + Environment.NewLine;
                    InfoDate = InfoDate.AddSeconds(rnd.Next(20, 60));
                }

                System.IO.File.AppendAllText(Server.MapPath("/Files/InfoData") + "/InfoData.txt", InfoDataStr);
            }
        }

        catch (Exception ex) { }
        finally
        {
            Application.UnLock();
        }

        try
        {
            if (System.IO.File.Exists(Server.MapPath("/Files/InfoData") + "/InfoData.txt") == true)
            {
                InfoDataStr = string.Empty;
                InfoDataStr = System.IO.File.ReadAllText(Server.MapPath("/Files/InfoData") + "/InfoData.txt");

                InfoDataStrArr = InfoDataStr.Split(stringSeparators, StringSplitOptions.None);

                if (InfoDataStrArr.Length > (Convert.ToInt32(InfoID) + 1))
                {
                    for (var i = (InfoDataStrArr.Length - 1); i >= 0; i--)
                    {
                        JsonStr = InfoDataStrArr[i];
                        if (Convert.ToInt32(InfoID) == 0)
                        {
                            if (string.IsNullOrEmpty(JsonStr) == false)
                            {
                                Jobj = Newtonsoft.Json.Linq.JObject.Parse(JsonStr);

                                if (Convert.ToDateTime(Jobj["InfoDate"]) < DateTime.Now.AddHours(Convert.ToInt32(EWinWeb.TimeZone)))
                                {
                                    iInfoData = new InfoData();
                                    iInfoData.InfoID = Convert.ToInt32(Jobj["InfoID"]);
                                    iInfoData.InfoDate = Jobj["InfoDate"].ToString();
                                    iInfoData.InfoAccount = Jobj["InfoAccount"].ToString();
                                    iInfoData.InfoAmount = Convert.ToInt32(Jobj["InfoAmount"]);

                                    RetInfoArr.Add(iInfoData);

                                    if (RetInfoArr.Count > 2)
                                    {
                                        break;
                                    }
                                }
                            }

                        }
                        else
                        {
                            if (i >= Convert.ToInt32(InfoID))
                            {
                                if (string.IsNullOrEmpty(JsonStr) == false)
                                {
                                    Jobj = Newtonsoft.Json.Linq.JObject.Parse(JsonStr);

                                    if (Convert.ToInt32(Jobj["InfoID"]) > Convert.ToInt32(InfoID))
                                    {
                                        if (Convert.ToDateTime(Jobj["InfoDate"].ToString()) < DateTime.Now.AddHours(Convert.ToInt32(EWinWeb.TimeZone)))
                                        {
                                            iInfoData = new InfoData();
                                            iInfoData.InfoID = Convert.ToInt32(Jobj["InfoID"]);
                                            iInfoData.InfoDate = Jobj["InfoDate"].ToString();
                                            iInfoData.InfoAccount = Jobj["InfoAccount"].ToString();
                                            iInfoData.InfoAmount = Convert.ToInt32(Jobj["InfoAmount"]);

                                            RetInfoArr.Add(iInfoData);
                                        }
                                    }
                                }
                            }
                            else
                            {
                                break;
                            }

                        }
                    }
                }
                else
                {
                    iInfoData = new InfoData();
                    iInfoData.InfoID = 0;

                    RetInfoArr.Add(iInfoData);
                }
            }

        }
        catch (Exception ex) { }

        if (RetInfoArr.Count > 0)
        {
            R.Message = Newtonsoft.Json.JsonConvert.SerializeObject(RetInfoArr);
            R.Result = EWin.Lobby.enumResult.OK;
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserMail(string GUID, EWin.Lobby.enumValidateType ValidateType, CodingControl.enumSendMailType SendMailType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber,string SMSContent,string LoginAccount) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.EWinWeb.EWinWeb EWinWebAPI = new EWin.EWinWeb.EWinWeb();
        EWin.Lobby.ValidateCodeResult validateCodeResult;
        EWin.Lobby.APIResult R = new EWin.Lobby.APIResult() { GUID = GUID, Result = EWin.Lobby.enumResult.ERR };
        EWin.EWinWeb.APIResult checkUserAccountResult;
        string ValidateCode = string.Empty;
        TelPhoneNormalize telPhoneNormalize = new TelPhoneNormalize(ContactPhonePrefix, ContactPhoneNumber);
        if (telPhoneNormalize != null) {
            ContactPhonePrefix = telPhoneNormalize.PhonePrefix;
            ContactPhoneNumber = telPhoneNormalize.PhoneNumber;
        }

        switch (SendMailType) {
            case CodingControl.enumSendMailType.Register:
                    validateCodeResult = lobbyAPI.SetValidateCodeOnlyNumber(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber);
                    if (validateCodeResult.Result == EWin.Lobby.enumResult.OK)
                    {
                        ValidateCode = validateCodeResult.ValidateCode;
                    }
                break;
            case CodingControl.enumSendMailType.ForgetPassword:
                checkUserAccountResult= EWinWebAPI.CheckUserAccountByEMailAndLoginAccount(GetToken(), GUID, EMail,LoginAccount);
                if (checkUserAccountResult.ResultState == EWin.EWinWeb.enumResultState.OK)
                {
                    validateCodeResult = lobbyAPI.SetValidateCode(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber);
                    if (validateCodeResult.Result == EWin.Lobby.enumResult.OK)
                    {
                        ValidateCode = validateCodeResult.ValidateCode;
                    }
                }
                else
                {
                    return R;
                }


                break;
            case CodingControl.enumSendMailType.ThanksLetter:

                break;
        }

        switch (ValidateType) {
            case EWin.Lobby.enumValidateType.EMail:
                R = SendMail(EMail, ValidateCode, R, SendMailType);
                break;
            case EWin.Lobby.enumValidateType.PhoneNumber:
                SMSContent = string.Format(SMSContent, ValidateCode);

                R = SendSMS(GUID, "0", 0, ContactPhonePrefix + ContactPhoneNumber, SMSContent);
                break;
            default:
                break;
        }

        return R;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserPasswordByValidateCode(string GUID, EWin.Lobby.enumValidateType ValidateType, string EMail, string ContactPhonePrefix, string ContactPhoneNumber, string ValidateCode, string NewPassword) {

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.SetUserPasswordByValidateCode(GetToken(), GUID, ValidateType, EMail, ContactPhonePrefix, ContactPhoneNumber, ValidateCode, NewPassword);

        return RetValue;
    }

    #endregion

    #region Kevin
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public  EWin.Lobby.APIResult RequireRegister2(string GUID, string ParentPersonCode, EWin.Lobby.PropertySet[] PS,EWin.Lobby.UserBankCard[] UBC) {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.RequireRegister(Token, GUID, ParentPersonCode, PS, UBC);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserBankCardState(string SID, string GUID, string BankCardGUID, int BankCardState) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.SetUserBankCardState(GetToken(), SID, GUID, BankCardGUID, BankCardState);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult UpdateUserBankCard(string SID, string GUID, string BankCardGUID, string CurrencyType, int PaymentMethod, string BankName, string BranchName, string BankNumber, string AccountName, string Description) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.UpdateUserBankCard(GetToken(), SID, GUID, BankCardGUID, CurrencyType, PaymentMethod, BankName, BranchName, BankNumber, AccountName, Description);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult AddUserBankCard(string SID, string GUID, string CurrencyType, int PaymentMethod, string BankName, string BranchName, string BankNumber, string AccountName, string Description) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.AddUserBankCard(GetToken(), SID, GUID, CurrencyType, PaymentMethod, BankName, BranchName, BankNumber, AccountName, Description);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.UserBankCardListResult GetUserBankCard(string SID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.UserBankCardListResult RetValue = null;

        RetValue = lobbyAPI.GetUserBankCard(GetToken(), SID, GUID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetUserPassword(string SID, string GUID, string OldPassword, string NewPassword) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.SetUserPassword(GetToken(), SID, GUID, OldPassword, NewPassword);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult SetWalletPassword(string SID, string GUID, string LoginPassword, string NewWalletPassword) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.SetWalletPassword(GetToken(), SID, GUID, LoginPassword, NewWalletPassword);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.UserInfoResult GetUserInfo(string SID, string GUID) {

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.UserInfoResult RetValue = null;

        RetValue = lobbyAPI.GetUserInfo(GetToken(), SID, GUID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.CompanyGameCodeResult GetCompanyGameCode(string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.CompanyGameCodeResult RetValue = null;

        RetValue = lobbyAPI.GetCompanyGameCode(GetToken(), GUID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.CompanySiteResult GetCompanySite(string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.CompanySiteResult RetValue = null;

        RetValue = lobbyAPI.GetCompanySite(GetToken(), GUID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.APIResult KeepSID(string SID, string GUID) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.APIResult RetValue = null;

        RetValue = lobbyAPI.KeepSID(GetToken(), SID, GUID);

        return RetValue;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.GameOrderDetailListResult GetGameOrderDetailHistoryBySummaryDate(string SID, string GUID, string BeginDate, string EndDate) {
        EWin.Lobby.GameOrderDetailListResult iGameOrderDetailListResult = new EWin.Lobby.GameOrderDetailListResult();
        List<EWin.Lobby.GameOrderDetail> DetailList = new List<EWin.Lobby.GameOrderDetail>();

        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.GameOrderDetailListResult RetValue = null;

        for (var i = 0; i <= Convert.ToDateTime(EndDate).Date.Subtract(Convert.ToDateTime(BeginDate)).TotalDays; i++) {
            DateTime QueryDate = Convert.ToDateTime(BeginDate).Date.AddDays(i);
            string QueryDateStr = QueryDate.ToString("yyyy-MM-dd");
            RetValue = lobbyAPI.GetGameOrderDetailHistoryBySummaryDate(GetToken(), SID, GUID, QueryDateStr);

            for (var j = 0; j < RetValue.DetailList.Length; j++) {
                EWin.Lobby.GameOrderDetail iGameOrderDetail = new EWin.Lobby.GameOrderDetail();

                iGameOrderDetail.CreateDate = RetValue.DetailList[j].CreateDate;
                iGameOrderDetail.CreateTime = RetValue.DetailList[j].CreateTime;
                iGameOrderDetail.GameDate = RetValue.DetailList[j].GameDate;
                iGameOrderDetail.GameTime = RetValue.DetailList[j].GameTime;
                iGameOrderDetail.SummaryDate = RetValue.DetailList[j].SummaryDate;
                iGameOrderDetail.LoginAccount = RetValue.DetailList[j].LoginAccount;
                iGameOrderDetail.CurrencyType = RetValue.DetailList[j].CurrencyType;
                iGameOrderDetail.GameCode = RetValue.DetailList[j].GameCode;
                iGameOrderDetail.GameAccountingCode = RetValue.DetailList[j].GameAccountingCode;
                iGameOrderDetail.RewardValue = RetValue.DetailList[j].RewardValue;
                iGameOrderDetail.ValidBetValue = RetValue.DetailList[j].ValidBetValue;

                DetailList.Add(iGameOrderDetail);
            }
        }

        iGameOrderDetailListResult.Result = 0;
        iGameOrderDetailListResult.DetailList = DetailList.ToArray();


        return iGameOrderDetailListResult;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public EWin.Lobby.PaymentResult GetPaymentHistory(string SID, string GUID, string BeginDate, string EndDate) {
        EWin.Lobby.LobbyAPI lobbyAPI = new EWin.Lobby.LobbyAPI();
        EWin.Lobby.PaymentResult RetValue = null;

        RetValue = lobbyAPI.GetPaymentHistory(GetToken(), SID, GUID, BeginDate, EndDate);

        return RetValue;
    }
    #endregion

    private string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    public class BulletinBoardResult : EWin.Lobby.APIResult {
        public List<BulletinBoard> Datas { get; set; }
    }

    public class BulletinBoard {
        public int BulletinBoardID { get; set; }
        public string BulletinTitle { get; set; }
        public string BulletinContent { get; set; }
        public DateTime CreateDate { get; set; }
        public int State { get; set; }
    }

    public class LoginMessageResult : EWin.Lobby.APIResult
    {
        public string Message { get; set; }
        public string Version { get; set; }
    }

    public class InfoData {
        public int InfoID { get; set; }
        public string InfoDate { get; set; }
        public string InfoAccount { get; set; }
        public int InfoAmount { get; set; }
    }

}