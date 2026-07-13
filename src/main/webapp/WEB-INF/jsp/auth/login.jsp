<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>ログイン</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<div class="login-container">
    <h2>ログイン</h2>
    
    <c:if test="${not empty error}">
    <p class="error-message" style="color: red; font-weight: bold;">${error}</p>
</c:if>

    <form action="/auth/login" method="post" class="login-form">
        <input type="hidden" name="redirect" value="${param.redirect}">

        <div class="form-group">
            <label for="email">メールアドレス</label>
            <input type="text" id="email" name="email" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="password">パスワード</label>
            <input type="password" id="password" name="password" class="form-control" required>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-login">ログイン</button>
        </div>
    </form>
    <p><a href="/users/register">新規会員登録はこちら</a></p>
</div>
</main>

<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>