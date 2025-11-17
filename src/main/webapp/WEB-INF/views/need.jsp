<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- Define the number of items to display --%>

<head>
    <link rel="stylesheet" href="/css/need.css?v=1.1">
    <link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <div class="item-list">
        <c:choose>
            <c:when test="${empty needs}">
                <p style="text-align: center; width: 100%; font-size: 1.5em; margin-top: 50px;">해당 굿즈를 찾을 수 없습니다.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="need" items="${needs}">
                    <a href="${pageContext.request.contextPath}/need/${need.id}" class="item-link">
                        <div class="item">
                            <img src="${need.imagePath}" alt="${need.goodsName}">
                            <div class="item-details">
                                <p>${need.goodsName}</p>
                                <h3>${need.goodsDescription}</h3>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
