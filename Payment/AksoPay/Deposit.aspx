<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Common.cs" Inherits="Common" %>

<%

    string SID = Request["SID"];
    string Amount = Request["Amount"];
    string CurrencyType = Request["CurrencyType"];
    string PaypalToken = string.Empty;
    dynamic Result = new System.Dynamic.ExpandoObject();
    APIResult CreatePaymentResult;





    CreatePaymentResult = CreatePayment(SID,CurrencyType, decimal.Parse(Amount));

    if (CreatePaymentResult.ResultState == APIResult.enumResultCode.OK) {
        Result.ResultCode = "OK";
        Result.Message = CreatePaymentResult.Message;
        Response.Redirect(CreatePaymentResult.Message);
    } else {
        Result.Result = "ERR";
        Result.Message = CreatePaymentResult.Message;
    }

    Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(Result));
    Response.Flush();
    Response.End();
%>
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
</body>
</html>
