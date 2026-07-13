<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>マイページ</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

<main>
<div class="container">
    <h2>マイページ</h2>

    <div class="mypage-profile">
        <div class="mypage-avatar">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="8" r="4"></circle>
                <path d="M4 20c0-4 4-6 8-6s8 2 8 6"></path>
                </svg>

        </div>
        <div>
            <div class="mypage-profile-name">${loginUser.lastName} ${loginUser.firstName} さん</div>
            <div class="mypage-profile-sub">マイページ</div>
        </div>
    </div>

    <div class="mypage-edit-link">
        <a href="/users/edit">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 20h9"></path>
                <path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"></path>
            </svg>
            会員情報を編集する
        </a>
    </div>

    <div class="mypage-section-title">
        <svg class="icon" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 2h6l1 5H8l1-5Z"></path>
            <path d="M5 7h14l1 13a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2L5 7Z"></path>
        </svg>
        ご注文履歴
    </div>

    <c:if test="${empty orderHistory}">
        <p class="empty-message">注文履歴はありません。</p>
    </c:if>

    <c:if test="${not empty orderHistory}">
        <div class="order-list">
            <c:forEach var="order" items="${orderHistory}">
                <div class="order-row">
                    <div class="order-row-left">
                        <svg class="icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 2s6 7 6 11a6 6 0 0 1-12 0c0-4 6-11 6-11Z"></path>
                        </svg>
                        <div>
                            <div class="order-date">${fn:substring(order.order_date, 0, 10)}</div>
                        </div>
                    </div>
                    <div>
                        <div class="order-status-badge">${order.status}</div>
                        <div class="order-price">${order.sum_price}円</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <div class="mypage-links-row">
        <a href="/users/register">
            <svg class="icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M19 8v6"></path>
                <path d="M22 11h-6"></path>
            </svg>
            新規会員登録
        </a>
        <form action="/auth/logout" method="post" style="display:inline;">
            <button type="submit" class="btn-logout">
                <svg class="icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <path d="M16 17l5-5-5-5"></path>
                    <path d="M21 12H9"></path>
                </svg>
                ログアウトする
            </button>
        </form>
        <a href="/users/withdraw" style="color: var(--muted-text);">
            <svg class="icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M17 8l5 5"></path>
                <path d="M22 8l-5 5"></path>
            </svg>
            退会
        </a>
    </div>
</div>
</main>

<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>
