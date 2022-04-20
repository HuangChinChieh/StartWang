<%@ Page Language="C#"%>
<%
    string Token = string.Empty;
    string LoginGUID = null;
    dynamic RetValue = new System.Dynamic.ExpandoObject();

    if (CodingControl.FormSubmit())
    {
        GWebAPI.Auth.AuthAPI AuthAPI = new GWebAPI.Auth.AuthAPI();

        Token = Request["Token"];

        LoginGUID = AuthAPI.CreateLoginGUID(Token);
        if (string.IsNullOrEmpty(LoginGUID) == false)
        {
            string ImageContentString = string.Empty;

            ImageContentString = AuthAPI.GetValidateImage(Token, LoginGUID);
            if (string.IsNullOrEmpty(ImageContentString) == false)
            {
                RetValue.ResultCode = 0;
                RetValue.Message = "";
                RetValue.LoginGUID = LoginGUID;
                RetValue.ImageContent = "data:image/png;base64," + ImageContentString;
            }
            else
            {
                RetValue.ResultCode = 1;
                RetValue.Message = "NoImageContent";
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
