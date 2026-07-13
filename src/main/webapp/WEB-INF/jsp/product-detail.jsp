<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
   <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
   <title>water park | 商品詳細</title>
   <link rel="stylesheet" href="/css/product-details.css">
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />
<main>
<div class="container">
   <div class="title-area">
       <h1><c:out value="${product.name}"/></h1>
   </div>
   <div class="image-area">
       <!-- メイン画像 -->
       <img id="mainImg" class="main-image" src="${product.fixedImageUrl}">
   </div>
   <div class="thumb-container">
       <c:forEach var="img" items="${variantImages}">
           <img src="${img.imageUrl}" class="thumb" onclick="changeImage(this.src)">
       </c:forEach>
       <c:forEach var="img" items="${images}">
           <img src="${img.imageUrl}" class="thumb" onclick="changeImage(this.src)">
       </c:forEach>
   </div>
   <div class="price-area">
       合計金額：<span id="displayPrice">価格を選択してください</span>
   </div>
   <div class="variant-container" id="variantList">
       <c:forEach var="v" items="${variants}" varStatus="status">
           <div data-id="${v.id}"
                data-price="${v.price}"
                data-stock="${v.stock}"
                data-image="${v.imageUrl}"
                class="variant-card ${v.stock <= 0 ? 'disabled' : ''}"
                onclick="clickVariant(this)">
               <div class="variant-title"><c:out value="${v.label}"/></div>
               <div class="variant-price">
                   <fmt:formatNumber value="${v.price}" pattern="#,###"/>円
               </div>
               <div style="font-size: 11px; color:#666;">
                   ${v.stock > 0 ? '在庫あり' : '売り切れ'}
               </div>
           </div>
       </c:forEach>
   </div>
   <div class="action-row">
       <div id="stockText" style="margin-top:5px; font-size:14px; color:#666;">
           バリエーションを選択してください
       </div>
       <div>
           <label style="font-size:14px; font-weight:bold;">数量:</label>
           <div class="qty-box">
               <button type="button" id="minusBtn" onclick="decreaseQty()">－</button>
               <input type="number" id="qty" value="" min="1" oninput="changeQty()">
               <button type="button" id="plusBtn" onclick="increaseQty()">＋</button>
           </div>
       </div>
       <div id="buttonArea">
           <a id="buyBtn" href="#" class="btn-buy">購入する</a>
           <div id="soldoutLabel" class="btn-soldout" style="display: none;">SOLDOUT</div>
       </div>
   </div>
   <div class="accordion-item">
       <button class="accordion-btn" onclick="toggleAccordion(this)">説明文</button>
       <div class="accordion-content">
           <p><c:out value="${product.description}"/></p>
       </div>
   </div>
   <div class="accordion-item">
       <button class="accordion-btn" onclick="toggleAccordion(this)">安心保証</button>
       <div class="accordion-content">
           <p>万が一、配送中の破損や液漏れがございましたら、お届け後7日以内にご連絡ください。無償で新品と交換いたします。</p>
       </div>
   </div>
	<div class="spec-area">
	
	    <div class="spec-card">
	        <div class="spec-title"> 産地</div>
	        <div class="spec-value">${product.ken}</div>
	    </div>
	
	    <div class="spec-card">
	        <div class="spec-title"> 硬度</div>
	        <div class="spec-value">${product.hard}</div>
	    </div>
	
	    <div class="spec-card">
	        <div class="spec-title"> 種類</div>
	        <div class="spec-value">${product.kinds}</div>
	    </div>
	
	    <div class="spec-card">
	        <div class="spec-title"> タイプ</div>
	        <div class="spec-value">${product.base}</div>
	    </div>
	
	</div>
   <h2>関連商品</h2>
   <div class="detail-containerr" id="related-products-area">
       <c:if test="${empty relatedProducts}">
           <p>関連商品はございません。</p>
       </c:if>
       <c:forEach var="r" items="${relatedProducts}">
           <a href="/product?id=${r.id}" class="related-card">
               <img src="${r.imageUrl}" alt="${r.name}">
               <div class="product-name"><c:out value="${r.name}"/></div>
               <div class="related-price">¥<fmt:formatNumber value="${r.price}" pattern="#,###"/></div>
           </a>
       </c:forEach>
   </div>
</div>
</main>
<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
<script>
document.addEventListener("DOMContentLoaded", function() {
   // 関連商品はサーバー側（Controller経由）で取得済みのため、
   // ここでのクライアント側fetchは不要になりました
   document.getElementById("displayPrice").innerText = "価格を選択してください";
   document.getElementById("stockText").innerText = "バリエーションを選択してください";
   document.getElementById("qty").disabled = true;
   document.getElementById("plusBtn").disabled = true;
   document.getElementById("minusBtn").disabled = true;
   document.getElementById("buyBtn").style.display = "none";
});
const getProductId = () => "${product.id}";
function changeImage(src) {
   document.getElementById('mainImg').src = src;
}
function clickVariant(element) {
   if (element.classList.contains("disabled")) { return; }
   document.querySelectorAll('.variant-card').forEach(card => card.classList.remove('selected'));
   element.classList.add('selected');
   const stock = parseInt(element.dataset.stock);
   const price = parseInt(element.dataset.price);
   const qty = 1;
   document.getElementById("displayPrice").innerText = (price * qty).toLocaleString() + "円";
   const image = element.dataset.image;
   if (image) { document.getElementById('mainImg').src = image; }
   updateQty(stock);
   document.getElementById("buyBtn").style.display = "inline-block";
   updatePurchaseUrl();
}
function updatePurchaseUrl() {
   const selected = document.querySelector(".variant-card.selected");
   if (!selected) { return; }
   const productId = getProductId();
   const variantId = selected.dataset.id;
   const stock = parseInt(selected.dataset.stock);
   const qty = document.getElementById('qty').value;
   const buyBtn = document.getElementById('buyBtn');
   const soldoutLabel = document.getElementById('soldoutLabel');
   if (stock > 0) {
       buyBtn.style.display = 'inline-block';
       buyBtn.href = "/purchase?id=" + productId + "&variantId=" + variantId + "&quantity=" + qty;
       soldoutLabel.style.display = 'none';
   } else {
       buyBtn.style.display = 'none';
       soldoutLabel.style.display = 'inline-block';
   }
}
function toggleAccordion(btn) {
   btn.classList.toggle('active');
   const content = btn.nextElementSibling;
   if (content.style.maxHeight) {
       content.style.maxHeight = null;
       content.style.padding = "0 10px";
   } else {
       content.style.maxHeight = content.scrollHeight + "px";
       content.style.padding = "10px 10px";
   }
}
let maxStock = 1;
function updateQty(stock) {
   maxStock = stock;
   const qty = document.getElementById("qty");
   const plusBtn = document.getElementById("plusBtn");
   const minusBtn = document.getElementById("minusBtn");
   const stockText = document.getElementById("stockText");
   if (stock <= 0) {
       stockText.innerText = "売り切れ";
       qty.value = "";
       qty.disabled = true;
       plusBtn.disabled = true;
       minusBtn.disabled = true;
   } else {
       stockText.innerText = "在庫：" + stock + "個";
       qty.disabled = false;
       qty.value = 1;
       updateButton();
   }
}
function increaseQty() {
   const qty = document.getElementById("qty");
   let value = parseInt(qty.value);
   if (value < maxStock) { qty.value = value + 1; }
   updateButton();
   updatePurchaseUrl();
   updatePrice();
}
function decreaseQty() {
   const qty = document.getElementById("qty");
   let value = parseInt(qty.value);
   if (value > 1) { qty.value = value - 1; }
   updateButton();
   updatePurchaseUrl();
   updatePrice();
}
function updateButton() {
   const qty = parseInt(document.getElementById("qty").value);
   document.getElementById("minusBtn").disabled = (qty <= 1);
   document.getElementById("plusBtn").disabled = (qty >= maxStock);
}
function changeQty() {
   const qty = document.getElementById("qty");
   let value = parseInt(qty.value);
   if (isNaN(value) || value < 1) { value = 1; }
   if (value > maxStock) { value = maxStock; }
   qty.value = value;
   updateButton();
   updatePurchaseUrl();
   updatePrice();
}
const firstThumb = document.querySelector(".thumb");
if (firstThumb) {
   document.getElementById("mainImg").src = firstThumb.src;
}
function updatePrice() {
   const selected = document.querySelector(".variant-card.selected");
   if (!selected) return;
   const price = parseInt(selected.dataset.price);
   const qty = parseInt(document.getElementById("qty").value);
   document.getElementById("displayPrice").innerText = (price * qty).toLocaleString() + "円";
}
</script>
</body>
</html>

