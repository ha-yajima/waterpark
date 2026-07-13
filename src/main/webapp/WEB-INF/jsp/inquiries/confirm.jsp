<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>お問い合わせ - 確認</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<div class="container">
    <h2>お問い合わせ（確認）</h2>
    <p>以下の内容で送信します。よろしければ「送信する」ボタンを押してください。</p>

    <div class="confirm-list">
        <div class="confirm-row">
            <div class="confirm-label">お問い合わせ種類</div>
            <div class="confirm-value">${inquiry.type}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">メールアドレス</div>
            <div class="confirm-value">${inquiry.email}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">お問い合わせ内容</div>
            <div class="confirm-value">${inquiry.message}</div>
        </div>
        <div class="confirm-row">
            <div class="confirm-label">添付画像</div>
            <div class="confirm-value">
                <c:if test="${not empty inquiry.imageUrl}">
                    <img src="${inquiry.imageUrl}" width="100">
                </c:if>
                <c:if test="${empty inquiry.imageUrl}">
                    なし
                </c:if>
            </div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/inquiries/execute" method="post">
        <input type="hidden" name="type" value="${inquiry.type}">
        <input type="hidden" name="email" value="${inquiry.email}">
        <input type="hidden" name="message" value="${inquiry.message}">
        <input type="hidden" name="imageUrl" value="${inquiry.imageUrl}">

        <div class="confirm-actions">
            <button type="button" class="btn-back" onclick="history.back()">戻る</button>
            <button type="submit" class="btn-login">送信する</button>
        </div>
    </form>
</div>
</main>

<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>