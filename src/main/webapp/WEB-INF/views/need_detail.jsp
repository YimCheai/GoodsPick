<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<head>
    <title>${needItem.goodsName} 상세</title>
    <link rel="stylesheet" href="/css/need_post.css"> <%-- Reusing some styling --%>
    <link rel="stylesheet" href="/css/navbar.css">
    <link rel="stylesheet" href="/css/detail_page.css">
</head>
<body>
<%@ include file="components/navbar.jsp" %>
<div class="navbar-divider"></div>

<div class="detail-wrapper">
    <div class="detail-image-half">
        <c:choose>
            <c:when test="${not empty needItem.imagePath}">
                <img src="${needItem.imagePath}" alt="${needItem.goodsName}">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/img/sample_img.svg" alt="No Image Available">
            </c:otherwise>
        </c:choose>
    </div>
    <div class="detail-info-half">
        <h1>${needItem.goodsName}</h1>
        <p>${needItem.goodsDescription}</p>
        <p class="transaction-status">
            현장 거래:
            <c:choose>
                <c:when test="${needItem.inPersonTransaction}">가능</c:when>
                <c:otherwise>불가능</c:otherwise>
            </c:choose>
        </p>
        <c:choose>
            <c:when test="${not empty loginUser && loginUser.id == needItem.userId}">
                <div class="owner-buttons">
                    <a href="${pageContext.request.contextPath}/need/edit/${needItem.id}" class="edit-button">수정</a>
                    <form action="${pageContext.request.contextPath}/need/delete/${needItem.id}" method="post" onsubmit="return confirm('정말로 삭제하시겠습니까?');" style="display:inline;">
                        <button type="submit" class="delete-button">삭제</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <a href="/chat?partnerId=${needItem.userId}" class="chat-button">채팅하기</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>