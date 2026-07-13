<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
   <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
   <title>
       <c:out value="${campaign.title}" /> | water park
   </title>
   <!-- キャンペーン専用CSS -->
   <link rel="stylesheet" href="/css/summerGift.css">
</head>
<body>
   <!-- 共通ヘッダー・検索メニュー -->
   <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
   <main class="campaign-page">
       <!-- メインビジュアル -->
       <section class="campaign-hero">
           <img
               src="${campaign.imageUrl}"
               alt="${campaign.title}">
       </section>
       <!-- 導入文 -->
       <section class="campaign-intro">
           <p class="section-label">
               HOKKAIDO SELECTION
           </p>
           <h1>
               北の大地から届く、特別な飲料セレクション。
           </h1>
           <p>
               澄んだ空気と豊かな自然に育まれた、
               北海道ならではのおいしさを集めました。<br>
               天然水やご当地サイダー、果実飲料など、
               贈りものにも日常にも楽しめる特集です。
           </p>
       </section>
       <!-- おすすめランキング -->
       <section class="campaign-section">
           <p class="section-label">
               RANKING
           </p>
           <h2>
               北海道特集おすすめランキング
           </h2>
           <c:if test="${empty rankingProducts}">
               <p class="empty-message">
                   現在ランキング商品はありません。
               </p>
           </c:if>
           <div class="product-grid">
               <c:forEach
                   var="product"
                   items="${rankingProducts}"
                   varStatus="status">
                   <div class="product-card">
                       <span class="rank">
                           <c:out value="${status.index + 1}" />
                       </span>
                       <div class="product-image">
                           <img
                               src="${product.variantImageUrl}"
                               alt="${product.name}">
                       </div>
                       <h3>
                           <c:out value="${product.name}" />
                       </h3>
                       <p class="price">
                           ¥<c:out value="${product.price}" />
                       </p>
                       <a
                           class="btn"
                           href="/product?id=${product.productId}">
                           商品を見る
                       </a>
                   </div>
               </c:forEach>
           </div>
       </section>
       <!-- ご予算から選ぶ -->
       <section class="campaign-section">
           <p class="section-label">
               BUDGET
           </p>
           <h2>
               ご予算から選ぶ
           </h2>
           <div class="link-grid budget-grid">
               <a href="/products?maxPrice=3000">
                   3,000円未満
               </a>
               <a href="/products?minPrice=3000&maxPrice=5000">
                   3,000〜5,000円
               </a>
               <a href="/products?minPrice=5000&maxPrice=8000">
                   5,000〜8,000円
               </a>
           </div>
       </section>
       <!-- 北海道のおすすめ飲料 -->
       <section class="campaign-section">
           <p class="section-label">
               HOKKAIDO SELECTION
           </p>
           <h2>
               北の大地から選ぶ、北海道のおすすめ飲料
           </h2>
           <p class="campaign-lead">
               広大な山々、清らかな雪どけ水、
               豊かな果実に恵まれた北海道。<br>
               すっきりとした飲み心地から
               華やかなご当地ドリンクまで、
               北海道らしい味わいを集めました。
           </p>
           <div class="link-grid kanto-grid">
               <a href="/products/search?keyword=北海道">
                   <span class="area-name">
                       北海道・天然水
                   </span>
                   <small>
                       澄んだ自然に育まれた清らかな水
                   </small>
               </a>
               <a href="/products/search?keyword=ふらの">
                   <span class="area-name">
                       富良野
                   </span>
                   <small>
                       ラベンダー香る爽やかな味わい
                   </small>
               </a>
               <a href="/products/search?keyword=余市">
                   <span class="area-name">
                       余市
                   </span>
                   <small>
                       果実のおいしさを楽しむ一杯
                   </small>
               </a>
               <a href="/products/search?keyword=ハスカップ">
                   <span class="area-name">
                       ハスカップ
                   </span>
                   <small>
                       北海道らしい甘酸っぱいご当地感
                   </small>
               </a>
           </div>
       </section>
       <!-- 北海道ギフトの楽しみ方 -->
       <section class="campaign-guide">
           <p class="section-label">
               GUIDE
           </p>
           <h2>
               北海道ギフトの楽しみ方
           </h2>
           <div class="guide-grid">
               <div class="guide-box">
                   <h3>
                       季節の贈りものに
                   </h3>
                   <p>
                       北海道らしい爽やかな飲料は、
                       夏のご挨拶や手土産にもぴったりです。
                       見た目にも涼しげで、
                       特別感のあるギフトとして楽しめます。
                   </p>
               </div>
               <div class="guide-box">
                   <h3>
                       飲み比べにもおすすめ
                   </h3>
                   <p>
                       天然水、サイダー、果実飲料など、
                       味わいの違う飲料を組み合わせると、
                       ご家庭用にも贈りものにも
                       選びやすい内容になります。
                   </p>
               </div>
           </div>
       </section>
   </main>
   <!-- 共通フッター -->
   <jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>

