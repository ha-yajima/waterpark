<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>water park</title>
    <link rel="stylesheet" href="/css/index.css">
</head>
<body>

<header class="site-header">
    <div class="header-inner">
       <h1 class="site-logo">
    <a href="/" class="site-logo-link">
        <img src="/images/logo/waterpark_logo01.png" alt="water park" class="site-logo-img">
    </a>
</h1>

   <div class="header-right">

    <nav class="global-nav">
        <a href="/products?sort=new" class="nav-text-link">NEW</a>

        <a href="/products" class="nav-text-link">商品一覧</a>

        <a href="/mypage" class="nav-text-link">マイページ</a>

        <a href="/cart" class="nav-icon-link cart-icon-link" aria-label="カート" title="カート">
            <svg viewBox="0 0 24 24" class="nav-icon">
                <path d="M3 4h2l2.5 12h10L20 8H7"></path>
                <circle cx="10" cy="20" r="1.5"></circle>
                <circle cx="17" cy="20" r="1.5"></circle>
            </svg>

            <c:if test="${cartCount > 0}">
                <span class="cart-badge">
                    <c:out value="${cartCount}" />
                </span>
            </c:if>
        </a>
    </nav>

    <form action="/products/search" method="get" class="header-search-form">
        <input type="text" name="keyword" class="header-search-input" placeholder="キーワードを入力">
        <button type="submit" class="header-search-button" aria-label="検索">
            <svg viewBox="0 0 24 24" class="header-search-icon">
                <circle cx="11" cy="11" r="7"></circle>
                <path d="M16.5 16.5L21 21"></path>
            </svg>
        </button>
    </form>
</div>
</div>

</header>

<main>

<!-- 大判バナー：campaign_banners -->
<section class="main-banner-section">

    <div class="main-banner-wrapper" id="mainBannerWrapper">

        <c:if test="${empty bannerList}">
            <div class="main-banner">
                <div class="banner-text">
                    <h2>現在表示中のバナーはありません。</h2>
                </div>
            </div>
        </c:if>

        <c:forEach var="banner" items="${bannerList}">
           <a class="main-banner" href="/campaigns">
                <img src="${banner.imageUrl}" alt="${banner.title}">
                <div class="banner-text">
                    <h2><c:out value="${banner.title}" /></h2>
                    <p>商品一覧</p>
                </div>
            </a>
        </c:forEach>

    </div>

    <div class="banner-dots" id="bannerDots"></div>

</section>


<!-- おすすめ商品 -->
<section class="product-section">
    <div class="section-header">
        <h2>おすすめ</h2>
    </div>

    <c:if test="${empty recommendedProductList}">
        <p class="empty-message">現在おすすめ商品はありません。</p>
    </c:if>

    <div class="product-grid">
        <c:forEach var="product" items="${recommendedProductList}">
            <div class="product-card">
                <a href="/product?id=${product.productId}">
                    <div class="product-image">
                        <img src="${product.variantImageUrl}" alt="${product.name}">
                    </div>

                    <p class="product-name">
                        <c:out value="${product.name}" />
                    </p>

                    <p class="product-price">
                        ¥<c:out value="${product.price}" />
                    </p>
                </a>
            </div>
        </c:forEach>
    </div>

    <div class="view-all-wrap">
        <a href="/products" class="view-all-button">VIEW ALL</a>
    </div>
</section>


<!-- ランキング -->
<section class="product-section">
    <div class="section-header">
        <h2>ランキング</h2>
    </div>

    <c:if test="${empty rankingProductList}">
        <p class="empty-message">現在ランキング商品はありません。</p>
    </c:if>

    <div class="product-grid">
        <c:forEach var="product" items="${rankingProductList}" varStatus="status">
            <div class="product-card">
                <a href="/product?id=${product.productId}">
                    <div class="product-image">
                        <span class="product-label">No.${status.index + 1}</span>
                        <img src="${product.variantImageUrl}" alt="${product.name}">
                    </div>

                    <p class="product-name">
                        <c:out value="${product.name}" />
                    </p>

                    <p class="product-price">
                        ¥<c:out value="${product.price}" />
                    </p>
                </a>
            </div>
        </c:forEach>
    </div>

    <div class="view-all-wrap">
        <a href="/products" class="view-all-button">VIEW ALL</a>
    </div>
</section>


<!-- 新着商品 -->
<section class="product-section">
    <div class="section-header">
        <h2>新着商品</h2>
    </div>

    <c:if test="${empty newProductList}">
        <p class="empty-message">現在新着商品はありません。</p>
    </c:if>

    <div class="product-grid">
        <c:forEach var="product" items="${newProductList}">
            <div class="product-card">
                <a href="/product?id=${product.productId}">
                    <div class="product-image">
                        <span class="product-label">NEW</span>
                        <img src="${product.variantImageUrl}" alt="${product.name}">
                    </div>

                    <p class="product-name">
                        <c:out value="${product.name}" />
                    </p>

                    <p class="product-price">
                        ¥<c:out value="${product.price}" />
                    </p>
                </a>
            </div>
        </c:forEach>
    </div>

    <div class="view-all-wrap">
        <a href="/products" class="view-all-button">VIEW ALL</a>
    </div>
</section>
<!-- お知らせ -->
<section class="news-section">
    <h2>お知らせ</h2>

    <c:if test="${empty newsList}">
        <p class="empty-message">現在お知らせはありません。</p>
    </c:if>

    <ul class="news-list">
        <c:forEach var="news" items="${newsList}">
            <li>
                <strong><c:out value="${news.title}" /></strong>
                <p><c:out value="${news.content}" /></p>
            </li>
        </c:forEach>
    </ul>
</section>

</main>

<footer class="site-footer">
    <div class="footer-inner">
        <div>
            <img src="/images/logo/waterpark_logo01.png" alt="water park" class="site-logo-img">
         </div>


    <div class="footer-links">
        <div>
            <h3>お買い物ガイド</h3>
            <p>ご利用ガイド</p>
            <p>送料・配送について</p>
            <p>お支払い方法</p>
        </div>
        <div>
            <h3>会員サービス</h3>
            <p>マイページ</p>
            <p>注文履歴</p>
            <p>会員登録</p>
        </div>
        <div>
            <h3>当サイトについて</h3>
            <p>お問い合わせ</p>
          	<p><a href="/privacy">プライバシーポリシー</a></p>
            <p>運営会社</p>
        </div>
    </div>
</div>

<p class="copyright">&copy; 2026 water park All Rights Reserved.</p>

</footer>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const bannerWrapper = document.getElementById("mainBannerWrapper");
    const banners = document.querySelectorAll(".main-banner");
    const dotsContainer = document.getElementById("bannerDots");

    if (!bannerWrapper || !dotsContainer || banners.length === 0) {
        return;
    }

    let currentIndex = 0;
    const slideInterval = 6000;

    // ドットを作成
    banners.forEach((banner, index) => {
        const dot = document.createElement("button");
        dot.type = "button";
        dot.classList.add("banner-dot");

        if (index === 0) {
            dot.classList.add("active");
        }

        dot.addEventListener("click", () => {
            currentIndex = index;
            moveBanner();
            resetAutoSlide();
        });

        dotsContainer.appendChild(dot);
    });

    const dots = document.querySelectorAll(".banner-dot");

    function moveBanner() {
        const bannerWidth = bannerWrapper.clientWidth;

        bannerWrapper.scrollTo({
            left: bannerWidth * currentIndex,
            behavior: "smooth"
        });

        dots.forEach(dot => dot.classList.remove("active"));

        if (dots[currentIndex]) {
            dots[currentIndex].classList.add("active");
        }
    }

    function nextBanner() {
        if (banners.length <= 1) {
            return;
        }

        currentIndex++;

        if (currentIndex >= banners.length) {
            currentIndex = 0;
        }

        moveBanner();
    }

    let autoSlide = setInterval(nextBanner, slideInterval);

    function resetAutoSlide() {
        clearInterval(autoSlide);
        autoSlide = setInterval(nextBanner, slideInterval);
    }
});
</script>

</body>
</html>
