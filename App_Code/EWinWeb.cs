using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// EWin 的摘要描述
/// </summary>
public static class EWinWeb
{
    public static string DBConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["DBConnStr"].ConnectionString;
    public static DateTime DateTimeNull = Convert.ToDateTime("1900/1/1");
    public static bool IsTestSite = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["IsTestSite"]);
    public static string EWinUrl = System.Configuration.ConfigurationManager.AppSettings["EWinUrl"];
    public static string EWinAgentUrl = System.Configuration.ConfigurationManager.AppSettings["EWinAgentUrl"];
    public static string MainCurrencyType = System.Configuration.ConfigurationManager.AppSettings["MainCurrencyType"];
    public static string ConvertCurrencyType = System.Configuration.ConfigurationManager.AppSettings["ConvertCurrencyType"];
    public static string RegisterCurrencyType = System.Configuration.ConfigurationManager.AppSettings["RegisterCurrencyType"];
    public static string APIKey = System.Configuration.ConfigurationManager.AppSettings["Key"];
    public static string PrivateKey = System.Configuration.ConfigurationManager.AppSettings["PrivateKey"];
    public static string CompanyCode = System.Configuration.ConfigurationManager.AppSettings["CompanyCode"];
    public static string EWinWebUrl = System.Configuration.ConfigurationManager.AppSettings["EWinWebUrl"];
    public static string TimeZone = System.Configuration.ConfigurationManager.AppSettings["TimeZone"];
    public static string AllowAksoDeposit = System.Configuration.ConfigurationManager.AppSettings["AllowAksoDeposit"];
    public static string AksoDepositLimit = System.Configuration.ConfigurationManager.AppSettings["AksoDepositLimit"];
    public static string AllowAksoWithDrawal = System.Configuration.ConfigurationManager.AppSettings["AllowAksoWithDrawal"];
    public static string AksoWithDrawalLimit = System.Configuration.ConfigurationManager.AppSettings["AksoWithDrawalLimit"];
    public static string SharedFolder = System.Configuration.ConfigurationManager.AppSettings["SharedFolder"];
    public static string WebRedisConnStr = System.Configuration.ConfigurationManager.AppSettings["WebRedisConnStr"];
    public static string Key3DES = "onoeTs39aHfAATKGxYmyJ3Nf";
    public static string DirSplit = "\\";
    public static string Version = System.Configuration.ConfigurationManager.AppSettings["Version"];
    public static string EWinGameUrl = System.Configuration.ConfigurationManager.AppSettings["EWinGameUrl"];
    public static string CasinoWorldUrl = System.Configuration.ConfigurationManager.AppSettings["CasinoWorldUrl"];
    public static string StartWangUrl = System.Configuration.ConfigurationManager.AppSettings["StartWangUrl"];

    public static string CreateToken(string PrivateKey, string ApiKey, string RandomValue)
    {
        string Token;

        Token = RandomValue + "_" + ApiKey + "_" + CalcURLToken(PrivateKey, ApiKey, RandomValue);

        return Token;
    }

    public static bool IsWithdrawlTemporaryMaintenance()
    {
        bool RetValue = false;
        string Filename;

        Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

        if (System.IO.File.Exists(Filename))
        {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false)
            {
                try
                {
                    Newtonsoft.Json.Linq.JObject o = Newtonsoft.Json.Linq.JObject.Parse(SettingContent);
                    int withdrawTM = (int)o["WithdrawlTemporaryMaintenance"];

                    if (withdrawTM == 1)
                    {
                        RetValue = true;
                    }
                }
                catch (Exception ex) { }
            }
        }

        return RetValue;
    }

    public static bool CheckInWithdrawalTime()
    {
        Newtonsoft.Json.Linq.JObject settingJObj = EWinWeb.GetSettingJObj();
        bool R = false;
        string StartTime;
        string EndTime;
        DateTime nowDateTime = DateTime.Now;
        DateTime startDateTime;
        DateTime endDateTime;

        if (settingJObj != null)
        {
            StartTime = (string)settingJObj["WithdrawalStartTime"];
            EndTime = (string)settingJObj["WithdrawlEndTime"];
            startDateTime = Convert.ToDateTime(StartTime);
            endDateTime = Convert.ToDateTime(EndTime);


            if (DateTime.Compare(nowDateTime, startDateTime) >= 0)
            {
                if (DateTime.Compare(endDateTime, nowDateTime) >= 0)
                {
                    return true;
                }
            }
        }

        return R;
    }

    private static StackExchange.Redis.ConnectionMultiplexer RedisClient = null;

    public static string GetJValue(Newtonsoft.Json.Linq.JObject o, string FieldName, string DefaultValue = null)
    {
        string RetValue = DefaultValue;

        if (o != null)
        {
            Newtonsoft.Json.Linq.JToken T;

            T = o[FieldName];
            if (T != null)
            {
                RetValue = T.ToString();
            }
        }

        return RetValue;
    }


    public static Newtonsoft.Json.Linq.JObject GetSettingJObj()
    {
        Newtonsoft.Json.Linq.JObject o = null;
        string Filename;

        Filename = HttpContext.Current.Server.MapPath("/App_Data/Setting.json");

        if (System.IO.File.Exists(Filename))
        {
            string SettingContent;

            SettingContent = System.IO.File.ReadAllText(Filename);

            if (string.IsNullOrEmpty(SettingContent) == false)
            {
                try { o = Newtonsoft.Json.Linq.JObject.Parse(SettingContent); } catch (Exception ex) { }
            }
        }

        return o;
    }

    public static string CalcURLToken(string PrivateKey, string ApiKey, string RandomValue)
    {
        System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] hash = null;
        string Source = RandomValue + ":" + ApiKey + ":" + PrivateKey.ToUpper();
        System.Text.StringBuilder RetValue = new System.Text.StringBuilder();

        hash = md5.ComputeHash(System.Text.Encoding.Default.GetBytes(Source));
        md5 = null;

        foreach (byte EachByte in hash)
        {
            string ByteStr = EachByte.ToString("x");

            ByteStr = new string('0', 2 - ByteStr.Length) + ByteStr;
            RetValue.Append(ByteStr);
        }

        return RetValue.ToString();
    }

    public static void AlertMessage(string Content, string ReturnURL = "")
    {
        bool IsJS = false;
        string JSCode = "";

        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.Write("<Script Language=\"JavaScript\">");
        HttpContext.Current.Response.Write("alert(\"" + CodingControl.JSEncodeString(Content) + "\");");

        if (ReturnURL.Length >= 11)
        {
            if (ReturnURL.Substring(0, 11).ToUpper() == "JavaScript:".ToUpper())
            {
                IsJS = true;
                JSCode = ReturnURL.Substring(11);
            }
        }

        if (IsJS == false)
        {
            if (string.IsNullOrEmpty(ReturnURL))
            {
                HttpContext.Current.Response.Write("window.history.back (1);");
            }
            else
            {
                HttpContext.Current.Response.Write("window.location.href=\"" + ReturnURL + "\";");
            }
        }
        else
        {
            HttpContext.Current.Response.Write(JSCode);
        }

        HttpContext.Current.Response.Write("</Script>");
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.End();
    }

    public static string GetToken() {
        string Token;
        int RValue;
        Random R = new Random();
        RValue = R.Next(100000, 9999999);
        Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

        return Token;
    }

    public static StackExchange.Redis.IDatabase GetRedisClient(int db = -1) {
        StackExchange.Redis.IDatabase RetValue;

        RedisPrepare();

        if (db == -1) {
            RetValue = RedisClient.GetDatabase();
        } else {
            RetValue = RedisClient.GetDatabase(db);
        }

        return RetValue;
    }

    public static IList<T> ToList<T>(this DataTable table) where T : new()
    {
        IList<PropertyInfo> properties = typeof(T).GetProperties().ToList();
        IList<T> result = new List<T>();

        //取得DataTable所有的row data
        foreach (var row in table.Rows)
        {
            var item = MappingItem<T>((DataRow)row, properties);
            result.Add(item);
        }

        return result;
    }

    private static T MappingItem<T>(DataRow row, IList<PropertyInfo> properties) where T : new()
    {
        T item = new T();
        foreach (var property in properties)
        {
            if (row.Table.Columns.Contains(property.Name))
            {
                //針對欄位的型態去轉換
                if (property.PropertyType == typeof(DateTime))
                {
                    DateTime dt = new DateTime();
                    if (DateTime.TryParse(row[property.Name].ToString(), out dt))
                    {
                        property.SetValue(item, dt, null);
                    }
                    else
                    {
                        property.SetValue(item, null, null);
                    }
                }
                else if (property.PropertyType == typeof(decimal))
                {
                    decimal val = new decimal();
                    decimal.TryParse(row[property.Name].ToString(), out val);
                    property.SetValue(item, val, null);
                }
                else if (property.PropertyType == typeof(double))
                {
                    double val = new double();
                    double.TryParse(row[property.Name].ToString(), out val);
                    property.SetValue(item, val, null);
                }
                else if (property.PropertyType == typeof(int))
                {
                    int val = new int();
                    int.TryParse(row[property.Name].ToString(), out val);
                    property.SetValue(item, val, null);
                }
                else
                {
                    if (row[property.Name] != DBNull.Value)
                    {
                        property.SetValue(item, row[property.Name], null);
                    }
                }
            }
        }
        return item;
    }


    private static void RedisPrepare() {
        if (RedisClient == null) {
            RedisClient = StackExchange.Redis.ConnectionMultiplexer.Connect(WebRedisConnStr);
        }
    }
}