<%@page import="java.util.*"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>URL Rewriting Demo</title>
</head>
<body>
    <%
        int last = 0;
        String param = request.getParameter("int");
        if(param != null) last = Integer.parseInt(param);
        out.println(last);
    %>
    <br>
    <a href="urlrw.jsp?int=<%=last-1%>">prev </a>
    <a href="urlrw.jsp?int=<%=last+1%>">next </a>
</body>
</html>
