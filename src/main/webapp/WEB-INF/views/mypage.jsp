<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<head>
    <title>마이페이지</title>
    <link rel="stylesheet" href="/css/navbar.css?v=1.1">
    <link rel="stylesheet" href="/css/need.css?v=1.2"> <%-- Using need.css for base item styling --%>
    <link rel="stylesheet" href="/css/mypage.css?v=1.0"> <%-- Mypage specific styles --%>
</head>
<body>
    <%@ include file="components/navbar.jsp" %>
    <div class="navbar-divider"></div>

    <div class="mypage-container">
        <div class="mypage-header">
            <img src="${pageContext.request.contextPath}/img/login_logo.png" alt="마이페이지 로고" class="mypage-logo"/>
        </div>

        <!-- Tab Navigation -->
        <div class="mypage-tabs">
            <button class="tab-link active" onclick="openTab(event, 'needs')">구해요</button>
            <button class="tab-link" onclick="openTab(event, 'provides')">해드려요</button>
        </div>

        <!-- Tab Content -->
        <div id="needs" class="tab-content active">
            <div class="item-list">
                <c:choose>
                    <c:when test="${empty userNeeds}">
                        <div class="empty-state">
                            <p>아직 작성한 '구해요' 게시물이 없습니다.</p>
                            <a href="${pageContext.request.contextPath}/need_post" class="go-to-post-btn">게시물 작성하러 가기</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="need" items="${userNeeds}">
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
        </div>

        <div id="provides" class="tab-content">
            <div class="item-list">
                <c:choose>
                    <c:when test="${empty userProvides}">
                        <div class="empty-state">
                            <p>아직 작성한 '해드려요' 게시물이 없습니다.</p>
                            <a href="${pageContext.request.contextPath}/provide_post" class="go-to-post-btn">게시물 작성하러 가기</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="provide" items="${userProvides}">
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
        </div>
    </div>

    <script>
        // Set the "Needs" tab as active by default
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('needs').style.display = 'block';
        });

        function openTab(evt, tabName) {
            // Get all elements with class="tab-content" and hide them
            const tabcontent = document.getElementsByClassName("tab-content");
            for (let i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }

            // Get all elements with class="tab-link" and remove the class "active"
            const tablinks = document.getElementsByClassName("tab-link");
            for (let i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }

            // Show the current tab, and add an "active" class to the button that opened the tab
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }
    </script>
</body>
