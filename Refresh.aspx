<%@Page Language="C#"%>
<%
    string DestURL;

    Response.Clear();
    Response.Expires = 0;

    DestURL = CodingControl.GetQueryString();

    if (string.IsNullOrEmpty(DestURL))
        DestURL = "/";
%>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Content-Language" content="zh-cn">
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="Refresh" content="0; URL=<%=DestURL%>">
	<style type="text/css">
		html , body{
			margin: 0;
			padding: 0;
			width: 100%;
			height: 100%;
		}
		html{background: #000;}
		body{
			background: -webkit-linear-gradient(135deg,#2d2d2d,#4D4744);
			background: -moz-linear-gradient(135deg,#2d2d2d,#4D4744);
			background: -ms-linear-gradient(135deg,#2d2d2d,#4D4744);
			background: linear-gradient(135deg,#2d2d2d,#4D4744);
            display: -webkit-flex;
            display: -moz-flex;
            display: -ms-flex;
            display: flex;
			-webkit-align-items: center;
		    -moz-align-items: center;
			-ms-align-items: center;
			align-items: center;
		}
		body span{
			color: #999;
		}
	</style>	
</head>
<body style="width: 100%">
<span style="font-size:24px; text-align: center; width: 100%;">
Please wait...
</span>
<script language="javascript">
    window.location.href="<%=CodingControl.JSEncodeString(DestURL) %>";
</script>
</body>
</html>