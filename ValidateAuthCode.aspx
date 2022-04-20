<%@ Page Language="C#"%>
<%
    string Token = string.Empty;
    string LoginGUID = null;
    string ImageCode = null;
    dynamic RetValue = new System.Dynamic.ExpandoObject();

    if (CodingControl.FormSubmit())
    {
        GWebAPI.Auth.AuthAPI AuthAPI = new GWebAPI.Auth.AuthAPI();
        GWebAPI.Auth.APIResult Ret;

        Token = Request["Token"];
        LoginGUID = Request["LoginGUID"];
        ImageCode = Request["ImageCode"];

        Ret = AuthAPI.CheckOnlyImageCode(Token, LoginGUID, ImageCode);
        if (Ret != null)
        {
            if (Ret.ResultCode == GWebAPI.Auth.enumResultCode.OK)
            {
                RetValue.ResultCode = 0;
                RetValue.Message = string.Empty;
            }
            else
            {
                RetValue.ResultCode = 1;
                RetValue.Message = Ret.Message;
            }
        }
        else
        {
            RetValue.ResultCode = 1;
            RetValue.Message = "InvalidLoginGUID";
        }
    }
    else
    {
        RetValue.ResultCode = 1;
        RetValue.Message = "Other";
    }

    Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(RetValue));
    Response.Flush();
    Response.End();
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
