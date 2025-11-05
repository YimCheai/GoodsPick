<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Define the number of items to display --%>
<% int count = 10; %>

<head>
    <link rel="stylesheet" href="/css/need.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <div class="item-list">
        <c:forEach begin="1" end="<%= count %>">
            <div class="item">
                <img src="${pageContext.request.contextPath}/img/sample_img.svg" alt="Sample Image">
                <p>데이식스 식빵 굿즈</p>
                <h3>21000원</h3>
            </div>
        </c:forEach>
    </div>
</body>
