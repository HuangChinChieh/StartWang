<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Common.cs" Inherits="Common" %>

<%
    string PostBody;
    APIResult returnData;
    Newtonsoft.Json.Linq.JObject Result=new Newtonsoft.Json.Linq.JObject();
    using (System.IO.StreamReader reader = new System.IO.StreamReader(Request.InputStream)) {
        PostBody = reader.ReadToEnd();
    };

    if (!string.IsNullOrEmpty(PostBody))
    {
        Result = Newtonsoft.Json.JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(PostBody);
        APIResult CapturePaymentResult;
    }
    else {
        Response.Write("Request Data is Empty");
        Response.Flush();
        Response.End();
    }

    if (Result["merchantNo"] != null)
    {
        if (Result["status"] != null && Result["status"].ToString() == "2")
        {
            returnData= QueryPayment(Result["merchantOrder"].ToString());

            if (returnData.ResultState == APIResult.enumResultCode.OK)
            {
                returnData= CapturePayment(Result["merchantOrder"].ToString(),Result["amount"].ToString(),Result["realAmount"].ToString(),Result["successTime"].ToString(),Result["currency"].ToString(),PostBody);

                if (returnData.ResultState == APIResult.enumResultCode.OK)
                {
                    Response.Write("SUCCESS");
                    Response.Flush();
                    Response.End();
                }
            }
            else {
                    Response.Write(returnData.Message);
                    Response.Flush();
                    Response.End();
            }

        }
        else {
            Response.Write("Request Data is Empty");
            Response.Flush();
            Response.End();
        }
    }
    else
    {
            Response.Write("merchantNo is Null");
            Response.Flush();
            Response.End();
    }
%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
