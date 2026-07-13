<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
   <!-- index.jspと同じ共通head -->
   <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
   <title>お中元・夏ギフト特集 | water park</title>
   <!-- キャンペーン専用CSS -->
   <link rel="stylesheet" href="/css/summerGift.css">
</head>
<body>
   <!-- index.jspと同じ共通ヘッダー・サーチ -->
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
               SUMMER GIFT
           </p>
           <h1>
               夏のご挨拶に、涼やかな水の贈りものを。
           </h1>
           <p>
               暑い季節にうれしい、こだわりの水ギフトを集めました。<br>
               お中元や帰省のお手土産、大切な方への夏のご挨拶にぴったりです。
           </p>
       </section>
       <!-- おすすめランキング -->
       <section class="campaign-section">
           <p class="section-label">
               RANKING
           </p>
           <h2>
               おすすめランキング
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
       <!-- 関東の名水 -->
       <section class="campaign-section">
           <p class="section-label">
               KANTO SELECTION
           </p>
           <h2>
               夏に贈りたい関東の名水
           </h2>
           <p class="campaign-lead">
               都心からほど近い山々や清流に育まれた、
               関東ならではの名水をセレクト。<br>
               身近でありながら特別感のある水ギフトは、
               夏のご挨拶にもぴったりです。
           </p>
           <div class="link-grid kanto-grid">
               <a href="/products/search?keyword=奥多摩">
                   <span class="area-name">
                       東京・奥多摩
                   </span>
                   <small>
                       森に育まれた澄んだ水
                   </small>
               </a>
               <a href="/products/search?keyword=秩父">
                   <span class="area-name">
                       埼玉・秩父
                   </span>
                   <small>
                       山あいから届く清涼感
                   </small>
               </a>
               <a href="/products/search?keyword=箱根">
                   <span class="area-name">
                       神奈川・箱根
                   </span>
                   <small>
                       贈りものに映える名水
                   </small>
               </a>
               <a href="/products/search?keyword=赤城">
                   <span class="area-name">
                       群馬・赤城
                   </span>
                   <small>
                       夏にうれしいすっきり感
                   </small>
               </a>
           </div>
       </section>
       <!-- お中元の豆知識 -->
       <section class="campaign-guide">
           <p class="section-label">
               GUIDE
           </p>
           <h2>
               お中元の豆知識
           </h2>
           <div class="guide-grid">
               <div class="guide-box">
                   <h3>
                       お中元を贈る時期
                   </h3>
                   <p>
                       お中元は、日頃お世話になっている方へ
                       感謝を伝える夏のご挨拶です。
                       地域によって時期が異なるため、
                       相手先に合わせて早めに準備すると安心です。
                   </p>
               </div>
               <div class="guide-box">
                   <h3>
                       のし・包装について
                   </h3>
                   <p>
                       夏の贈りものにふさわしい、
                       涼やかで上品な包装がおすすめです。
                       大切な方へのご挨拶や
                       法人向けギフトにも使いやすい内容です。
                   </p>
               </div>
           </div>
       </section>
   </main>
   <!-- index.jspと同じ共通フッター -->
   <jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>

