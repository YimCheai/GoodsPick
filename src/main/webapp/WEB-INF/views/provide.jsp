<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

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
                <div class="item" data-href="${pageContext.request.contextPath}/provide/${provide.id}">
                    <img src="${provide.imagePath}" alt="${provide.goodsName}">
                    <div class="item-details">
                        <p>${provide.goodsName}</p>
                        <h3>${provide.price}원</h3>

                        <c:if test="${sessionScope.loginUser.id ne provide.userId}">
                            <div class="chat-btn-container">
                                <button type="button"
                                        class="chat-btn"
                                        data-partner-id="${provide.userId}">
                                    채팅하기
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // 아이템 클릭 이벤트 (상세 페이지 이동)
    document.querySelectorAll('.item').forEach(item => {
        item.addEventListener('click', function(e) {
            // 채팅 버튼을 클릭한 경우가 아니면 상세 페이지로 이동
            if (!e.target.closest('.chat-btn')) {
                const href = this.getAttribute('data-href');
                if (href) {
                    location.href = href;
                }
            }
        });
    });

    // 채팅 버튼 클릭 이벤트
    document.querySelectorAll('.chat-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation(); // 이벤트 버블링 방지
            const partnerId = this.getAttribute('data-partner-id');
            if (partnerId) {
                location.href = '/chat?partnerId=' + partnerId;
            }
        });
    });
</script>
</body>