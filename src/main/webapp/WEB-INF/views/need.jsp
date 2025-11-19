<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

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
                <div class="item" data-href="${pageContext.request.contextPath}/need/${need.id}">
                    <img src="${need.imagePath}" alt="${need.goodsName}">
                    <div class="item-details">
                        <p>${need.goodsName}</p>
                        <h3>${need.goodsDescription}</h3>

                        <c:if test="${sessionScope.loginUser.id ne need.userId}">
                            <div class="chat-btn-container">
                                <button type="button"
                                        class="chat-btn"
                                        data-partner-id="${need.userId}">
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