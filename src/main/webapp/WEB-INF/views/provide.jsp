<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<head>
    <title>제공 목록</title>
    <link rel="stylesheet" href="/css/need.css?v=1.1"> <%-- Reusing existing item list styling --%>
    <link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>
    <div class="navbar-divider"></div>

    <div class="item-list">
        <c:choose>
            <c:when test="${empty provides}">
                <p style="text-align: center; width: 100%; font-size: 1.5em; margin-top: 50px;">해당 굿즈를 찾을 수 없습니다.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="provide" items="${provides}">
                    <a href="${pageContext.request.contextPath}/provide/${provide.id}" class="item-link">
                        <div class="item">
                            <img src="${provide.imagePath}" alt="${provide.goodsName}">
                            <div class="item-details">
                                <p>${provide.goodsName}</p>
                                <h3>${provide.price}원</h3>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</body>
