<%@ Page Language="C#"%>
<%
    string PCode = Request["PCode"];

    Response.Redirect("index.aspx?Page=register.aspx?PCode=" + PCode);
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
