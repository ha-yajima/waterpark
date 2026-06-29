<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>購入手続き - water park</title>
    <style>
        body { font-family: sans-serif; margin: 40px; background: #f4f9fc; color: #333; }
        .container { max-width: 600px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin: 0 auto; }
        h1 { color: #006699; border-bottom: 2px solid #006699; padding-bottom: 10px; }
        .product-info { display: flex; align-items: center; gap: 20px; margin: 20px 0; padding-bottom: 20px; border-bottom: 1px solid #ddd; }
        .price { font-size: 20px; color: #ff5500; font-weight: bold; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"], input[type="number"] { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn-confirm { display: block; width: 100%; text-align: center; background: #006699; color: white; padding: 12px; font-size: 18px; font-weight: bold; text-decoration: none; border: none; border-radius: 4px; cursor: pointer; margin-top: 20px; }
        .btn-confirm:hover { background: #004466; }
        .delivery-info { background: #fffbe6; border: 1px solid #ffe58f; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; color: #d46b08; }
    </style>
</head>
<body>

<div class="container">
    <h1>購入手続き</h1>
    
    <div class="delivery-info">
        🚚 最短お届け予定日: <c:out value="${deliveryDate}"/>
    </div>
    
    <div class="product-info">
        <img src="${not empty product.imageUrl ? product.imageUrl : '/images/no-image.jpg'}" alt="商品画像" style="max-width: 100px; height: auto; border-radius: 4px;">
        <div>
            <h3><c:out value="${product.name}"/></h3>
            <p style="margin: 5px 0; color: #555; font-weight: bold;"><c:out value="${selectedVariant.name}"/></p>
            <p class="price">
                <fmt:formatNumber value="${selectedVariant.price}" pattern="#,###"/>円 (税込)
            </p>
        </div>
    </div>

    <c:if var="hasError" test="${not empty error}">
        <div style="color: red; font-weight: bold; margin-bottom: 15px;"><c:out value="${error}"/></div>
    </c:if>

    <form action="/purchase/complete" method="post">
        <input type="hidden" name="productId" value="${product.id}">
        <input type="hidden" name="variantId" value="${selectedVariant.id}">

        <div class="form-group">
            <label for="quantity">数量（セット数）</label>
            <input type="number" id="quantity" name="quantity" value="${buyQuantity}" min="1" max="${selectedVariant.stock}" required>
            <span style="font-size: 12px; color: #666;">（現在の残り在庫: <c:out value="${selectedVariant.stock}"/> セット）</span>
        </div>

        <div class="form-group">
            <label for="name">お名前</label>
            <input type="text" id="name" name="customerName" placeholder="山田 太郎" required>
        </div>

        <div class="form-group">
            <label for="address">お届け先住所</label>
            <input type="text" id="address" name="address" placeholder="岐阜県各務原市..." required>
        </div>

        <button type="submit" class="btn-confirm">注文を確定する</button>
    </form>
</div>

</body>
</html>