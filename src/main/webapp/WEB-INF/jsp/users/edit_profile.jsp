<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>会員情報変更</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<div class="container">
    <h2>会員情報変更</h2>
    <c:if test="${not empty successMessage}">
    <p class="success-message">${successMessage}</p>
</c:if>
<c:if test="${not empty error}">
    <p class="error-message">${error}</p>
</c:if>

    <form action="${pageContext.request.contextPath}/users/edit" method="post" class="edit-form">
        <div class="form-group">
            <label>お名前</label>
            <div class="input-row">
                <input type="text" name="lastName" value="${user.lastName}" placeholder="姓" required>
                <input type="text" name="firstName" value="${user.firstName}" placeholder="名" required>
            </div>
        </div>

        <div class="form-group">
            <label>フリガナ</label>
            <div class="input-row">
                <input type="text" name="lastNameKana" value="${user.lastNameKana}" placeholder="セイ" required>
                <input type="text" name="firstNameKana" value="${user.firstNameKana}" placeholder="メイ" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email">メールアドレス</label>
            <input type="email" id="email" name="email" class="form-control" value="${user.email}" required>
        </div>

        <div class="form-group">
            <label for="phoneNumber">電話番号</label>
            <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="${user.phoneNumber}" required>
        </div>

        <div class="form-group">
            <label for="postalCode">郵便番号</label>
            <input type="text" id="postalCode" name="postalCode" class="form-control" value="${user.postalCode}" required>
        </div>

        <div class="form-group">
            <label for="prefecture">都道府県</label>
            <input type="text" id="prefecture" name="prefecture" class="form-control" value="${user.prefecture}" required>
        </div>

        <div class="form-group">
            <label for="address1">市区町村・番地</label>
            <input type="text" id="address1" name="address1" class="form-control" value="${user.address1}" required>
        </div>

        <div class="form-group">
            <label for="address2">建物名・部屋番号</label>
            <input type="text" id="address2" name="address2" class="form-control" value="${user.address2}">
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-login">変更を保存する</button>
        </div>
    </form>
</div>
</main>

<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>