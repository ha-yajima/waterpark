<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
   <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
   <title>waterpark|購入手続き</title>
    <link rel="stylesheet" href="/css/product-details.css">
   <style>
       body { font-family: sans-serif;background: #f4f9fc; color: #333; }
       .container { max-width: 600px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin: 0 auto; }
       h1 {  padding-bottom: 10px; }
       .product-info { display: flex; align-items: center; gap: 20px; margin: 20px 0; padding-bottom: 20px; border-bottom: 1px solid #ddd; }
       .price { font-size: 20px; color:#3A8FBF; font-weight: bold; }
       .form-group { margin-bottom: 15px; }
       label { display: block; font-weight: bold; margin-bottom: 5px; }
       input[type="text"], input[type="number"] { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
       .btn-confirm { display: block; width: 100%; text-align: center; background: #006699; color: white; padding: 12px; font-size: 18px; font-weight: bold; text-decoration: none; border: none; border-radius: 4px; cursor: pointer; margin-top: 20px; }
       .btn-confirm:hover { background: #004466; }
       .delivery-info { background: #fffbe6; border: 1px solid #ffe58f; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; color: #d46b08; }
      
.product-info{
   display:flex;
   gap:20px;
   align-items:center;
   margin:20px 0;
   padding:20px;
   background:#f8fbfd;
   border:1px solid #dcecf6;
   border-left:5px solid #74C2F2;
   border-radius:10px;
}
.product-info img{
   width:150px;
   height:150px;
   object-fit:cover;
   border-radius:8px;
   border:1px solid #ddd;
}
.product-info div{
   flex:1;
}
		.product-info div{
		    flex:1;
		}
		
		.name-row{
   display:flex;
   gap:10px;
}
.name-row > div{
   flex:1;
}
		
		@media (max-width:768px){
	    .container{
       width:100%;
       padding:20px 15px;
       box-sizing:border-box;
       border-radius:0;
       box-shadow:none;
   }
   h1{
       font-size:24px;
   }
   .price{
       font-size:22px;
   }
   #totalPrice{
       font-size:24px;
   }
   .btn-confirm{
       width:100%;
       font-size:18px;
       padding:15px;
   }
   .product-info{
       flex-direction:column;
       text-align:center;
       gap:15px;
   }
   .product-info img{
       width:180px;
       height:180px;
   }
   .product-info h3{
       margin:10px 0;
   }
  
       .name-row{
       flex-direction:column;
       gap:12px;
   }
}
      
   </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />
<main>
		<div class="container">
		    <h1 style=" border-bottom: 2px solid #006699;">購入手続き</h1>
		   
		    <div class="delivery-info">
		        🚚 最短お届け予定日: <c:out value="${deliveryDate}"/>
		    </div>
		   
		<div class="product-info">
		
		    <img
		        id="mainImage"
		        src="${selectedVariant.imageUrl}"
		        alt="${product.name}">
		
		    <div>
		
		        <h3>
		            <c:out value="${product.name}"/>
		        </h3>
		
		        <p>
		            <c:out value="${selectedVariant.name}"/>
		        </p>
		
		
		        <p class="price">
		            <fmt:formatNumber
		                value="${selectedVariant.price}"
		                pattern="#,###"/>
		            円(税込)
		        </p>
		
		
		        <p style="font-size:22px;font-weight:bold;color:#3A8FBF;">
		            合計：
		            <span id="totalPrice">
		                <fmt:formatNumber
		                    value="${selectedVariant.price * buyQuantity}"
		                    pattern="#,###"/>
		            </span>
		            円
		        </p>
		
		
		    </div>
		
		</div>
		<form action="/purchase/confirm" method="post">
		
		<input type="hidden" name="productId" value="${product.id}">
		<input type="hidden" name="variantId" value="${selectedVariant.id}">
		
       <div class="form-group">
		    <label for="quantity">数量</label>
		    <input
		        type="number"
		        id="quantity"
		        name="quantity"
		        value="${buyQuantity}"
		        min="1"
		        max="${selectedVariant.stock}"
		        step="1"
		        required>
		
		    <span style="font-size:12px;color:#666;">
		        （現在の残り在庫:
		        <c:out value="${selectedVariant.stock}"/> セット）
		    </span>
		</div>
		        <div class="form-group">
		    <label>お名前</label>
		
		    <div class="name-row">
		        <div style="flex:1;">
		            <div style="font-size:12px;color:#666;margin-bottom:4px;">
		                姓
		            </div>
		            <input
		                type="text"
		                name="lastName"
		                value="${user.lastName}"
		                placeholder="姓"
		                required>
		        </div>
		        <div style="flex:1;">
		            <div style="font-size:12px;color:#666;margin-bottom:4px;">
		                名
		            </div>
		            <input
		                type="text"
		                name="firstName"
		                value="${user.firstName}"
		                placeholder="名"
		                required>
		        </div>
		    </div>
		</div>
      
		<div class="form-group">
		    <label>フリガナ</label>
		    <div class="name-row">
		        <div style="flex:1;">
		            <div style="font-size:12px;color:#666;margin-bottom:4px;">
		                セイ
		            </div>
		            <input
		                type="text"
		                name="lastNameKana"
		                value="${user.lastNameKana}"
		                placeholder="セイ">
		        </div>
		        <div style="flex:1;">
		            <div style="font-size:12px;color:#666;margin-bottom:4px;">
		                メイ
		            </div>
		            <input
		                type="text"
		                name="firstNameKana"
		                value="${user.firstNameKana}"
		                placeholder="メイ">
		        </div>
		    </div>
		</div>
		<div class="from-group">
			<label for="phone">電話番号</label>
			<input
			 type="text"
			 name="phone"
			 value="${user.phoneNumber}"
			 placeholder="ハイフンなし">
		</div>
		<div class="form-group">
		    <label for="zipCode">郵便番号</label>
		    <input
			 type="text"
			 id="zipCode"
			 name="zipCode"
			 value="${user.postalCode}"
			 maxlength="7"
			 placeholder="ハイフンなし">
		</div>
       <div class="form-group">
           <label for="ken">都道県</label>
		    <input
			 type="text"
			 name="prefecture"
			 value="${user.prefecture}">
       </div>
      
       <div class="form-group">
       <label for="address1">市区町村・番地</label>
       <input
			 type="text"
			 id="address1"
			 name="address1"
			 value="${user.address1}">
       </div>
      
       <div class="form-group">
       <label for="address2">建物名・部屋番号</label>
       <input
			 type="text"
			 name="address2"
			 value="${user.address2}">
       </div>
       <button type="submit" class="btn-confirm">注文を確認する</button>
   </form>
</div>
</main>
<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
<script>
		const unitPrice = Number("${selectedVariant.price}");
		const maxStock = Number("${selectedVariant.stock}");
		
		const qty = document.getElementById("quantity");
		const total = document.getElementById("totalPrice");
		
		function updateTotal(){
		    let value = parseInt(qty.value);
		    if(isNaN(value)){
		        value = 1;
		    }
		    if(value < 1){
		        value = 1;
		    }
		    if(value > maxStock){
		        value = maxStock;
		        alert("在庫数を超える数量は入力できません。");
		    }
		    qty.value = value;
		    total.innerText = (unitPrice * value).toLocaleString();
		}
		qty.addEventListener("input", updateTotal);
		qty.addEventListener("change", updateTotal);
		qty.addEventListener("keydown", function(e){
		    if(e.key==="e" ||
		       e.key==="E" ||
		       e.key==="+" ||
		       e.key==="-"){
		        e.preventDefault();
		    }
		});
		updateTotal();
		const zip = document.getElementById("zipCode");
		zip.addEventListener("input", function () {
		    this.value = this.value
		        .replace(/[^0-9]/g, "")
		        .slice(0, 7);
		});
		document.querySelectorAll("input[name='lastName'], input[name='firstName']").forEach(input => {
		    input.addEventListener("input", function () {
		        this.value = this.value.replace(/[^ぁ-んァ-ヶー一-龯A-Za-zａ-ｚＡ-Ｚ]/g, "");
		    });
		});
		const address = document.getElementById("address1");
		address.addEventListener("input", function(){
		    this.value = this.value.replace(/[^0-9０-９ぁ-んァ-ヶー一-龯A-Za-zａ-ｚＡ-Ｚ\-－ー丁目番地号室\s]/g,"");
		});
		
</script>
</body>
</html>

