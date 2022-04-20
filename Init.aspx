<%@ Page Language="C#"%>
<%
    dynamic postObject = null;
    dynamic Result = null;
    string SourceEncString;
    string CustomHeader;
    string WebApiURL = string.Empty;
    string GWebDate = string.Empty;
    string Page = Request["Page"];

    WebApiURL = Web.GWebApiUrl;
    GWebDate = System.DateTime.UtcNow.ToString("yyyyMMddHHmmss");
    SourceEncString = Web.CompanyCode + ":" + Web.ApiKey + ":" + GWebDate;

    postObject = new System.Dynamic.ExpandoObject();
    postObject.GUID = System.Guid.NewGuid().ToString();
    postObject.Hash = CodingControl.GetMD5(SourceEncString, false);

    CustomHeader = "GWeb-CompanyCode: " + Web.CompanyCode + "\r\n" +
                   "GWeb-ApiKey: " + Web.ApiKey + "\r\n" +
                   "GWeb-Date: " + GWebDate;

    Result = CodingControl.GetWebJSONContent(WebApiURL + "/CreateServerToken", "POST", Newtonsoft.Json.JsonConvert.SerializeObject(postObject), CustomHeader);
    if (Result.ResultCode == 0)
    {
        string Token = Result.Message;

        Response.SetCookie(new HttpCookie("Token", Token));

        if (string.IsNullOrEmpty(Page))
            Response.Redirect("Refresh.aspx?index.aspx", true);
        else
            Response.Redirect("Refresh.aspx?index.aspx?Page=" + Server.UrlEncode(Page), true);
    }
    else
    {
        Response.Write(SourceEncString + ":" + Result.Message);
        Response.Flush();
        Response.End();
    }
%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
</body>
</html>
