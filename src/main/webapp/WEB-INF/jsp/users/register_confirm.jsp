<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>会員登録 - 確認</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<div class="container">
    <h2>会員登録（確認）</h2>
    <c:if test="${not empty error}">
    <p class="error-message">${error}</p>
</c:if>
    <p>以下の内容で登録します。よろしければ「登録する」ボタンを押してください。</p>

    <div class="confirm-list">
        <div class="confirm-row">
            <div class="confirm-label">お名前</div>
            <div class="confirm-value">${user.lastName} ${user.firstName}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">フリガナ</div>
            <div class="confirm-value">${user.lastNameKana} ${user.firstNameKana}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">メールアドレス</div>
            <div class="confirm-value">${user.email}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">パスワード</div>
            <div class="confirm-value">********（セキュリティのため非表示）</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">電話番号</div>
            <div class="confirm-value">${user.phoneNumber}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">郵便番号</div>
            <div class="confirm-value">${user.postalCode}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">都道府県</div>
            <div class="confirm-value">${user.prefecture}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">市区町村・番地</div>
            <div class="confirm-value">${user.address1}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">建物名・部屋番号</div>
            <div class="confirm-value">${user.address2}</div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/users/register/execute" method="post">
        <input type="hidden" name="lastName" value="${user.lastName}">
        <input type="hidden" name="firstName" value="${user.firstName}">
        <input type="hidden" name="lastNameKana" value="${user.lastNameKana}">
        <input type="hidden" name="firstNameKana" value="${user.firstNameKana}">
        <input type="hidden" name="email" value="${user.email}">
        <input type="hidden" name="password" value="${user.password}">
        <input type="hidden" name="phoneNumber" value="${user.phoneNumber}">
        <input type="hidden" name="postalCode" value="${user.postalCode}">
        <input type="hidden" name="prefecture" value="${user.prefecture}">
        <input type="hidden" name="address1" value="${user.address1}">
        <input type="hidden" name="address2" value="${user.address2}">

        <div class="confirm-actions">
            <button type="button" class="btn-back" onclick="history.back()">戻る</button>
            <button type="submit" class="btn-login">登録する</button>
        </div>
    </form>
</div>
</main>

<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>