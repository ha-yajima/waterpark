<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>会員登録 - 入力</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<div class="container">
    <h2>会員登録（入力）</h2>

    <form action="${pageContext.request.contextPath}/users/register/confirm" method="post" class="edit-form">

        <div class="form-group">
            <label>お名前</label>
            <div class="input-row">
                <input type="text" name="lastName" placeholder="姓" required>
                <input type="text" name="firstName" placeholder="名" required>
            </div>
        </div>

        <div class="form-group">
            <label>フリガナ</label>
            <div class="input-row">
                <input type="text" name="lastNameKana" placeholder="セイ" required>
                <input type="text" name="firstNameKana" placeholder="メイ" required>
            </div>
        </div>

        <div class="form-group">
            <label for="email">メールアドレス</label>
            <input type="email" id="email" name="email" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="password">パスワード</label>
            <input type="password" id="password" name="password" required>
        </div>

        <div class="form-group">
            <label for="phoneNumber">電話番号</label>
            <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" placeholder="ハイフンなし" required>
        </div>

        <div class="form-group">
            <label for="postalCode">郵便番号</label>
            <input type="text" id="postalCode" name="postalCode" class="form-control" placeholder="ハイフンなし" required>
        </div>

        <div class="form-group">
            <label for="prefecture">都道府県</label>
            <input type="text" id="prefecture" name="prefecture" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="address1">市区町村・番地</label>
            <input type="text" id="address1" name="address1" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="address2">建物名・部屋番号</label>
            <input type="text" id="address2" name="address2" class="form-control">
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-login">確認画面へ</button>
        </div>
    </form>
</div>
</main>

<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>