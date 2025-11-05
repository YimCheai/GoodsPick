<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <link rel="stylesheet" href="/css/navbar.css">
</head>
<nav class="navbar">
    <!-- Logo -->
    <c:set var="currentPath" value="${pageContext.request.requestURI}" />

    <a href="${pageContext.request.contextPath}/" class="logo">
        <c:choose>
            <c:when test="${currentPath.contains('/need') or currentPath.contains('/provide')}">
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
               class="${currentPath.contains('/need') and not currentPath.contains('_post') ? 'active' : ''}">구해요</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/provide"
               class="${currentPath.contains('/provide') and not currentPath.contains('_post') ? 'active' : ''}">해드려요</a>
        </li>
        <li class="action-item">
            <c:choose>
                <c:when test="${currentPath.contains('/need_post') or currentPath.contains('/provide_post')}">
                    <a href="/" class="post-button">게시</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">
                        <img src="${pageContext.request.contextPath}/img/login.svg" alt="Login" />
                    </a>
                </c:otherwise>
            </c:choose>
        </li>
    </ul>
</nav>