<%@ Page Language="C#"%>
<%
    string URL;
    string PCode = Request["PCode"];
    int DownloadType = 0;  //0=Image, 1=download
    byte[] QRCodeContent;

    URL = Request.Url.Scheme + "://" + Request.Url.Authority + "/QRCodeJoinMember.aspx?PCode=" + PCode;
    QRCodeContent = Web.GenerateQRCode_URL(URL, 5);

    if (QRCodeContent != null)
    {
        if (string.IsNullOrEmpty(Request["T"]) == false)
        {
            DownloadType = Convert.ToInt32(Request["T"]);
        }

        if (DownloadType == 1)
        {
            Response.AddHeader("Content-Description", "Download File");
            Response.AddHeader("Content-Disposition", "attachment; filename=" + PCode + "_QRCode.png");
            Response.AddHeader("Content-Type", "application/octet-stream");
        }
        else
        { 
            Response.AddHeader("Content-Type", "image.png");
        }

        Response.BinaryWrite(QRCodeContent);
        Response.Flush();
        Response.Close();
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
