<%@page import="java.util.*"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hidden Field Demo</title>
</head>
<body>
    <%
        int current = 0;
        String last = request.getParameter("int");
        String button = request.getParameter("button");
        if(button != null){
            if(button.equals("next")){
                current = Integer.parseInt(last)+1;
            }else{
                current = Integer.parseInt(last)-1;
            }
        }
        out.println(current);
    %>
    <br>
    <form name="myForm" method="post">
        <input type="hidden" name="int" value="<%=current%>">
        <input type="submit" name="button" value="prev">
        <input type="submit" name="button" value="next">
    </form>
</body>
</html>
