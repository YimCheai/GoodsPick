<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style>
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');

        body {
            margin: 0;
            width: 100vw;
            height: 100vh;
            background-color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .logo {
            width: 200px;
            height: auto;
        }

        .login-title {
            font-family: 'Pretendard', sans-serif;
            font-weight: 600;
            font-size: 45px;
            margin-top: 42px;
            margin-bottom: 27px;
        }

        .signup-text {
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Pretendard', sans-serif;
            font-size: 24px;
            color: #757575;
            margin-bottom: 50px;
        }

        .signup-text span {
            margin-left: 28px;
            font-weight: 700;
            color: #5271ff;
            cursor: pointer;
        }

        .input-box {
            width: 680px;
            height: 162px;
            border: 1px solid #d9d9d9;
            border-radius: 25px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .input-row {
            flex: 1;
            display: flex;
            align-items: center;
            padding: 0 20px;
            font-family: 'Pretendard', sans-serif;
            font-size: 22px;
            color: #d9d9d9;
            border-top: 1px solid #d9d9d9;
        }

        .input-row:first-child {
            border-top: none;
        }

        .input-row img.icon {
            width: 32px;
            height: 32px;
            margin-right: 16px;
            opacity: 0.7;
        }

        .input-row input {
            border: none;
            outline: none;
            font-family: 'Pretendard', sans-serif;
            font-size: 22px;
            color: #000;
            flex: 1;
        }

        .input-row input::placeholder {
            color: #d9d9d9;
        }

        .eye-icon {
            width: 32px;
            height: 32px;
            cursor: pointer;
        }

        .login-button {
            width: 680px;
            height: 88px;
            background-color: #5271ff;
            border-radius: 25px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 141px;
            cursor: pointer;
            font-family: 'Pretendard', sans-serif;
            font-weight: 600;
            font-size: 32px;
            color: #fff;
            border: none;
        }

        .error-message {
            color: red;
            margin-bottom: 10px;
            font-family: 'Pretendard', sans-serif;
            font-size: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <img src="/img/login_logo.png" alt="logo" class="logo">
    <div class="login-title">로그인</div>
    <div class="signup-text">
        이미 회원이 아니신가요?<span onclick="location.href='/signup'">회원가입</span>
    </div>

    <!-- 로그인 실패 메시지 -->
    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>

    <!-- 로그인 폼 -->
    <form action="/login" method="post">
        <div class="input-box">
            <div class="input-row">
                <img src="/img/person.png" alt="person" class="icon">
                <input type="text" name="username" placeholder="아이디">
            </div>
            <div class="input-row">
                <img src="/img/lock.png" alt="lock" class="icon">
                <input type="password" name="password" placeholder="비밀번호" id="password">
                <img src="/img/eyeoff.png" alt="toggle" id="togglePassword" class="eye-icon">
            </div>
        </div>
        <button type="submit" class="login-button">로그인</button>
    </form>
</div>

<script>
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    let isVisible = false;

    togglePassword.addEventListener('click', () => {
        isVisible = !isVisible;
        passwordInput.type = isVisible ? 'text' : 'password';
        togglePassword.src = isVisible ? '/img/eyeon.png' : '/img/eyeoff.png';
    });
</script>
</body>
</html>