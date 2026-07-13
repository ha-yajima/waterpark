<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>お問い合わせ - 入力</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<c:if test="${not empty message}">
    <div class="container">
        <p class="info-message">${message}</p>
    </div>
</c:if>

<div class="container">
    <h2>お問い合わせ（入力）</h2>

    <form action="${pageContext.request.contextPath}/inquiries/confirm" method="post" enctype="multipart/form-data" class="edit-form">

        <div class="form-group">
            <label for="type">お問い合わせ種類</label>
            <select id="type" name="type" required>
                <option value="">選択してください</option>
                <option value="製品について">製品について</option>
                <option value="料金・お支払い">料金・お支払い</option>
                <option value="その他">その他</option>
            </select>
        </div>

        <div class="form-group">
            <label for="email">メールアドレス</label>
            <input type="email" id="email" name="email" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="message">お問い合わせ内容</label>
            <textarea id="message" name="message" required></textarea>
        </div>

        <div class="form-group">
            <label for="imageFile">添付画像</label>
            <input type="file" id="imageFile" name="imageFile" accept="image/*">
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