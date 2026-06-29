<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品詳細 - water park</title>
    <style>
        body { font-family: sans-serif; margin: 0; padding: 20px; background: #f4f9fc; color: #333; }
        .container { max-width: 600px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin: 0 auto; }
        .title-area { text-align: center; margin-bottom: 15px; }
        h1 { font-size: 22px; margin: 5px 0; color: #111; }
        .sub-info { font-size: 14px; color: #666; margin-bottom: 5px; }
        .image-area { text-align: center; margin-bottom: 20px; }
        .main-image { max-width: 100%; height: 280px; object-fit: contain; border: 1px solid #eee; border-radius: 4px; padding: 5px; }
        .thumb-container { display: flex; gap: 8px; justify-content: center; margin-top: 10px; }
        .thumb { width: 50px; height: 50px; object-fit: cover; border: 1px solid #ccc; cursor: pointer; border-radius: 4px; }
        .thumb:hover { border-color: #006699; }
        .price-area { text-align: center; font-size: 24px; color: #b12704; font-weight: bold; margin: 15px 0; }
        .action-row { display: flex; justify-content: center; align-items: center; gap: 15px; margin-bottom: 20px; }
        .qty-select { padding: 8px; font-size: 16px; border-radius: 4px; border: 1px solid #ccc; }
        .btn-buy { display: inline-block; background: #ffa41c; color: #111; padding: 10px 30px; font-size: 16px; font-weight: bold; text-decoration: none; border-radius: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); cursor: pointer; border: none; }
        .btn-buy:hover { background: #f59200; }
        .btn-soldout { display: inline-block; background: #e7e7e7; color: #555; padding: 10px 30px; font-size: 16px; font-weight: bold; border-radius: 20px; }
        .variant-container { display: flex; flex-wrap: wrap; gap: 12px; justify-content: center; margin: 20px 0; }
        .variant-card { border: 2px solid #ddd; border-radius: 6px; padding: 10px; width: 110px; text-align: center; cursor: pointer; background: #fff; transition: 0.2s; }
        .variant-card:hover { border-color: #ffa41c; background: #fffdf9; }
        .variant-card.selected { border-color: #006699; background: #f0f7fa; }
        .variant-card.disabled { background: #f5f5f5; border-color: #eee; color: #aaa; cursor: not-allowed; }
        .variant-title { font-weight: bold; font-size: 13px; word-break: break-all; }
        .variant-price { color: #b12704; font-weight: bold; margin-top: 5px; font-size: 14px; }
        .accordion-item { border-bottom: 1px solid #ddd; }
        .accordion-btn { width: 100%; background: none; border: none; padding: 15px 10px; text-align: left; font-size: 16px; font-weight: bold; cursor: pointer; display: flex; justify-content: space-between; align-items: center; }
        .accordion-btn::after { content: '▼'; font-size: 12px; color: #666; transition: 0.3s; }
        .accordion-btn.active::after { transform: rotate(180deg); }
        .accordion-content { max-height: 0; overflow: hidden; transition: max-height 0.2s ease-out; background: #fafafa; padding: 0 10px; font-size: 14px; line-height: 1.6; }
        .related-container{
    display:flex;
    gap:15px;
    flex-wrap:wrap;
    margin-top:20px;
}

.related-card{
    width:150px;
    border:1px solid #ddd;
    border-radius:8px;
    text-align:center;
    text-decoration:none;
    color:black;
    padding:10px;
    transition:0.2s;
}

.related-card:hover{
    transform:translateY(-3px);
    box-shadow:0 2px 8px rgba(0,0,0,0.15);
}

.related-card img{
    width:100%;
    height:120px;
    object-fit:cover;
}
.image-area{
    display:flex;
    flex-direction:column;
    align-items:center;
}

.main-image{
    width:100%;
    max-width:400px;
    height:350px;
    object-fit:contain;
    border:1px solid #eee;
    border-radius:4px;
    padding:5px;
}

.thumb-container{
    display:flex;
    gap:8px;
    overflow-x:auto;
    width:100%;
    margin-top:10px;
    padding-bottom:5px;
}

.thumb{
    width:70px;
    height:70px;
    object-fit:cover;
    border:1px solid #ccc;
    border-radius:4px;
    cursor:pointer;
    flex-shrink:0;
}
    </style>
</head>
<body>

<div class="container">
    
    <div class="title-area">
        <div class="sub-info">ミネラルウォーター / 国内大自然の湧水</div>
        <h1><c:out value="${product.name}"/></h1>
        <div style="color: #ff9900; font-size: 14px;">★★★★★ (レビュー4.5)</div>
    </div>
    
    <div class="image-area">

    <img id="mainImg"
         src="${not empty product.imageUrl ? product.imageUrl : '/images/no-image.jpg'}"
         alt="商品画像"
         class="main-image">

    <div class="thumb-container">

        <c:forEach var="img" items="${variantImages}">
            <img src="${img.imageUrl}"
                 class="thumb"
                 onclick="changeImage(this.src)">
        </c:forEach>

        <c:forEach var="img" items="${images}">
            <img src="${img.imageUrl}"
                 class="thumb"
                 onclick="changeImage(this.src)">
        </c:forEach>

    </div>

</div>
 
    
    <div class="price-area">
        <span id="displayPrice">0</span>円
    </div>

    <div class="variant-container" id="variantList">
        <c:forEach var="v" items="${variants}" varStatus="status">
    <div data-id="${v.id}"
         data-price="${v.price}"
         data-stock="${v.stock}"
         data-image="${v.imageUrl}"
         class="variant-card ${v.stock <= 0 ? 'disabled' : (status.index == 0 ? 'selected' : '')}"
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
        <div>
            <label for="qty" style="font-size: 14px; font-weight: bold;">数量:</label>
            <select id="qty" class="qty-select" onchange="updatePurchaseUrl()">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>
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
        <button class="accordion-btn" onclick="toggleAccordion(this)">製品について</button>
        <div class="accordion-content">
            <p>【区分】ナチュラルミネラルウォーター<br>
               厳選された採水地から直接ボトリングした、安心・安全でまろやかなおいしい天然水をお届けします。</p>
        </div>
    </div>

    <div class="accordion-item">
        <button class="accordion-btn" onclick="toggleAccordion(this)">安心保証</button>
        <div class="accordion-content">
            <p>万が一、配送中の破損や液漏れがございましたら、お届け後7日以内にご連絡ください。無償で新品と交換いたします。</p>
        </div>
    </div>
    <table class="spec-table">

<tr>
    <th>採水地</th>
    <td>${product.ken}</td>
</tr>

<tr>
    <th>硬度</th>
    <td>${product.hard}</td>
</tr>

<tr>
    <th>種類</th>
    <td>${product.kinds}</td>
</tr>

<tr>
    <th>採水方法</th>
    <td>${product.base}</td>
</tr>

</table>
    
    <h2>関連商品</h2>

<div class="related-container">

    <c:forEach var="r" items="${relatedProducts}">

        <a href="/product?id=${r.id}" class="related-card">

            <img src="${r.image_url}">

            <div>${r.name}</div>

        </a>

    </c:forEach>

</div>

</div>

<script>
    const productId = "${product.id}";

    window.onload = function() {
        const defaultCard = document.querySelector('.variant-card.selected');
        if (defaultCard) {
            clickVariant(defaultCard);
        } else {
            const firstCard = document.querySelector('.variant-card');
            if (firstCard) clickVariant(firstCard);
        }
    };

    function changeImage(src) {
        document.getElementById('mainImg').src = src;
    }

    function clickVariant(element) {

        document.querySelectorAll('.variant-card')
            .forEach(card => card.classList.remove('selected'));

        element.classList.add('selected');

        const price = parseInt(element.dataset.price);

        document.getElementById('displayPrice')
            .innerText = price.toLocaleString();

        const image = element.dataset.image;

        if(image){
            document.getElementById('mainImg').src = image;
        }

        updatePurchaseUrl();
    }

    function updatePurchaseUrl() {
        const selected = document.querySelector('.variant-card.selected');
        if (!selected) return;

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
    
</script>

</body>
</html>