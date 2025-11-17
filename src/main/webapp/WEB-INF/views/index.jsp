<%@ page contentType="text/html; charset=UTF-8" %>
<head>
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/navbar.css">
</head>
<%@ include file="components/navbar.jsp" %>

<div id="image-buttons-container">
    <a href="/need_post"><img class="image-button" src="/img/need.svg" alt="Need Button"></a>
    <a href="/provide_post"><img class="image-button" src="/img/provide.svg" alt="Provide Button"></a>
</div>
<a href="${pageContext.request.contextPath}/need_post"><img id="startButton" src="/img/start_btn.svg" alt="Start Button"></a>
