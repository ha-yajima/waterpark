<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
 <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
 <title>water park</title>
 <link rel="stylesheet" href="/css/index.css">
</head>

<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />

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
    <a class="main-banner" href="${banner.linkUrl}">
        <img src="${banner.imageUrl}" alt="${banner.title}">
        <div class="banner-text">
            <h2 class="visually-hidden"><c:out value="${banner.title}" /></h2>
        </div>
    </a>
</c:forEach>
 </div>
 <div class="banner-dots" id="bannerDots"></div>
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
             <a href="/product?id=${product.product_id}">
                 <div class="product-image">
                     <span class="product-label">NEW</span>
                                                          
                                          
                     <img src="${product.image_url}" alt="${product.name}">
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
     <a href="/products?sort=new" class="view-all-button">VIEW ALL</a>
 </div>
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
             <a href="/product?id=${product.product_id}">
                 <div class="product-image">
                     <img src="${product.image_url}" alt="${product.name}">
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
     <a href="/products?sort=recommended" class="view-all-button">VIEW ALL</a>
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
             <a href="/product?id=${product.product_id}">
                 <div class="product-image">
                     <span class="product-label">RANK <c:out value="${status.count}" /></span>
                     <img src="${product.image_url}" alt="${product.name}">
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
     <a href="/products?sort=ranking" class="view-all-button">VIEW ALL</a>
 </div>
</section>
<!-- お知らせ -->
<section class="news-section">
 <h2>お知らせ</h2>
 <c:if test="${empty newsList}">
    <p class="empty-message">現在お知らせはありません。</p>
 </c:if>
 <ul class="news-list">
    <c:forEach var="news" items="${newsList}" varStatus="status">
       <li class="news-item">
          <button type="button"
                  class="news-title-button"
                  data-modal-target="newsModal${status.index}">
             <strong><c:out value="${news.title}" /></strong>
          </button>
          <p class="news-preview">
             <c:out value="${news.content}" />
          </p>
       </li>
       <dialog id="newsModal${status.index}" class="news-modal">
          <div class="news-modal-inner">
             <button type="button" class="news-modal-close">×</button>
             <h2>
                <c:out value="${news.title}" />
             </h2>
             <p>
                <c:out value="${news.content}" />
             </p>
          </div>
       </dialog>
    </c:forEach>
 </ul>
</section>
</main>
<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
<script>
document.addEventListener("DOMContentLoaded", function () {

    // バナースライド
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

    // お知らせモーダル
    const newsOpenButtons = document.querySelectorAll(".news-title-button");
    newsOpenButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const modalId = button.dataset.modalTarget;
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.showModal();
            }
        });
    });

    const newsCloseButtons = document.querySelectorAll(".news-modal-close");
    newsCloseButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const modal = button.closest("dialog");
            if (modal) {
                modal.close();
            }
        });
    });

});

</script>

</body>
</html>

