 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="Common.cs" Inherits="Common" %>

<%
    string PostBody;
    string InIP;
    using (System.IO.StreamReader reader = new System.IO.StreamReader(Request.InputStream)) {
        PostBody = reader.ReadToEnd();
    };

    System.Data.DataTable PaymentOrderDT;
    APIResult R = new APIResult() { ResultState = APIResult.enumResultCode.ERR };

    if (!string.IsNullOrEmpty(PostBody))
    {
        dynamic RequestData = Common.ParseData(PostBody);

        InIP = CodingControl.GetUserIP();
        if (RequestData != null)
        {
            if (Common.CheckInIP(InIP))
            {
                if (Common.CheckWithdrawalSign(RequestData))
                {
                    EWin.Payment.PaymentAPI paymentAPI = new EWin.Payment.PaymentAPI();
                    EWin.Payment.PaymentResult paymentResult = paymentAPI.GetPaymentByPaymentSerial(EWinWeb.GetToken(), System.Guid.NewGuid().ToString(), (string)RequestData.OrderID);

                    R.Message = (string)RequestData.OrderID;

                    if (paymentResult.ResultStatus== EWin.Payment.enumResultStatus.OK)
                    {
                        if ((string)RequestData.WithdrawStatus == "0")
                        {
                            if (paymentResult.Status == EWin.Payment.enumPaymentStatus.PaymentCreated)
                            {
                                var finishResult = paymentAPI.FinishedPayment(EWinWeb.GetToken(), System.Guid.NewGuid().ToString(), paymentResult.PaymentSerial, -1);

                                if (finishResult.ResultStatus == EWin.Payment.enumResultStatus.OK)
                                {
                                    R.ResultState = APIResult.enumResultCode.OK;
                                    R.Message = "SUCCESS";
                                }
                                else
                                {
                                    R.ResultState = APIResult.enumResultCode.ERR;
                                    R.Message = "Finished Fail";
                                }
                            }
                            else
                            {
                                R.ResultState = APIResult.enumResultCode.ERR;
                                R.Message = "Flow Status Error";
                            }

                        }
                        else if ((string)RequestData.WithdrawStatus == "1")
                        {

                            string Token;
                            int RValue;
                            Random random = new Random();
                            RValue = random.Next(100000, 9999999);
                            Token = EWinWeb.CreateToken(EWinWeb.PrivateKey, EWinWeb.APIKey, RValue.ToString());

                            if (paymentResult.Status == EWin.Payment.enumPaymentStatus.PaymentCreated)
                            {
                                paymentAPI.CancelPayment(Token, Guid.NewGuid().ToString(), paymentResult.PaymentSerial);
                                R.ResultState = APIResult.enumResultCode.OK;
                                R.Message = "SUCCESS";
                            }
                            else
                            {
                                R.ResultState = APIResult.enumResultCode.ERR;
                                R.Message = "Flow Status Error";
                            }

                        }
                        else
                        {
                            R.ResultState = APIResult.enumResultCode.ERR;
                            R.Message = "Status Fail";
                        }
                    }
                    else
                    {
                        R.ResultState = APIResult.enumResultCode.ERR;
                        R.Message = "OtherOrderNumberNotFound";
                    }
                }
                else
                {
                    R.ResultState = APIResult.enumResultCode.ERR;
                    R.Message = "Sign Fail";
                }
            }
            else
            {
                R.ResultState = APIResult.enumResultCode.ERR;
                R.Message = "IP Fail:" + InIP;
            }

        }
        else
        {
            R.ResultState = APIResult.enumResultCode.ERR;
            R.Message = "Parse Data Fail";
        }

    }
    else
    {
        R.ResultState = APIResult.enumResultCode.ERR;
        R.Message = "No Data";
    }

    Response.Write(R.Message);
    Response.Flush();
    Response.End();
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
<script>
<%--    var Url = "<%:RedirectUrl%>";

    if (self == top) {
        window.location.href = Url;
    } else {
        window.top.API_LoadPage("PayPal", Url);
    }--%>

</script>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>

