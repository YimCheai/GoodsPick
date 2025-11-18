<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<nav class="navbar">
    <!-- Logo -->
    <c:set var="currentPath" value="${pageContext.request.requestURI}" />

    <a href="${pageContext.request.contextPath}/" class="logo">
        <c:choose>
            <c:when test="${currentPath.contains('/need') or currentPath.contains('/provide') or currentPath.contains('/mypage')}">
                <img src="${pageContext.request.contextPath}/img/logo_gray.svg" alt="Logo" />
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/img/logo.svg" alt="Logo" />
            </c:otherwise>
        </c:choose>
    </a>

    <!-- Search Container -->
    <div class="search-container">
        <img src="${pageContext.request.contextPath}/img/search_icon.svg" alt="Search" class="search-icon" />
        <input type="text" class="search-input" placeholder="원하는 굿즈를 입력하세요" />
    </div>

    <!-- Navigation Menu -->
    <ul>
        <li>
            <a href="${pageContext.request.contextPath}/need"
               class="${currentPath.contains('/need') ? 'active' : ''}">구해요</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/provide"
               class="${currentPath.contains('/provide') ? 'active' : ''}">해드려요</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/chat"
               class="${currentPath.contains('/chat') ? 'active' : ''}">메시지</a>
        </li>
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <li>
                    <c:choose>
                        <c:when test="${fn:endsWith(pageContext.request.servletPath, '/mypage.jsp')}">
                            <button type="button" class="mypage-button" onclick="location.href='${pageContext.request.contextPath}/logout'">로그아웃</button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="mypage-button" onclick="location.href='${pageContext.request.contextPath}/mypage'">마이페이지</button>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:when>
            <c:otherwise>
                <li class="action-item">
                    <a href="${pageContext.request.contextPath}/login">
                        <img src="${pageContext.request.contextPath}/img/login.svg" alt="Login" />
                    </a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<script>
    const searchInput = document.querySelector('.search-input');
    const currentPath = window.location.pathname;

    searchInput.addEventListener('keypress', (event) => {
        if (event.key === 'Enter') {
            const query = searchInput.value.trim();
            if (query) {
                let redirectPath = '';
                if (currentPath.startsWith('${pageContext.request.contextPath}/need')) {
                    redirectPath = '${pageContext.request.contextPath}/need';
                } else if (currentPath.startsWith('${pageContext.request.contextPath}/provide')) {
                    redirectPath = '${pageContext.request.contextPath}/provide';
                }

                if (redirectPath) {
                    window.location.href = redirectPath + '?query=' + encodeURIComponent(query);
                }
            }
        }
    });

    // Retain search query in input field
    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const query = urlParams.get('query');
        if (query) {
            searchInput.value = query;
        }
    });
</script>