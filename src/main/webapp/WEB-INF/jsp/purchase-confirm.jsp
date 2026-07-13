<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/common/head.jsp" />
<title>waterpark|注文内容の確認</title>
<style>
.container{
   max-width:700px;
   margin:auto;
   background:#fff;
   padding:30px;
   border-radius:8px;
   box-shadow:0 2px 8px rgba(0,0,0,.1);
}
.product{
   display:block;
   padding:20px;
   margin-bottom:25px;
   background:#f8fbfd;
   border:1px solid #dcecf6;
   border-left:5px solid #74C2F2;
   border-radius:10px;
}
.product-info img{
   width:140px;
   height:140px;
   object-fit:cover;
   border-radius:8px;
   border:1px solid #ddd;
   display:block;
   margin:0 auto 20px;
}
.info{
   text-align:left;
}
.product-info div{
   flex:1;
}
.price{
   color:#3A8FBF;
   font-size:20px;
   font-weight:bold;
}
.total-price{
   color:#3A8FBF;
   font-size:24px;
   font-weight:bold;
}
th,td{
   padding:10px;
   border-bottom:1px solid #ddd;
   text-align:left;
}
.button-area{
   display:flex;
   justify-content:center;
   gap:50px;
   margin-top:35px;
}
.button-area button{
   background:#3A8FBF;
   color:#fff;
   border:none;
   border-radius:6px;
   padding:12px 30px;
   font-size:16px;
   transition:.2s;
}
.button-area button:hover{
   background:#2b79a5;
}
.form-group{
   margin-top:18px;
}
.form-group label{
   display:block;
   font-weight:bold;
   margin-bottom:6px;
}
.display-box{
   border:1px solid #ddd;
   border-radius:5px;
   background:#fafafa;
   padding:10px 12px;
}
h2{
   border-bottom:3px solid #3A8FBF;
   padding-bottom:10px;
   margin-bottom:25px;
}
.delivery-info{
   background:#fffbe6;
   border:1px solid #ffe58f;
   padding:10px;
   border-radius:4px;
   margin-bottom:15px;
   font-weight:bold;
   color:#d46b08;
}
.name-row{
   display:flex;
   gap:10px;
}
.name-row>div{
   flex:1;
}
/* --------------------
  タブレット
-------------------- */
@media (max-width:768px){
.container{
   margin:15px;
   padding:20px;
}
.product{
   flex-direction:column;
   text-align:center;
}
.product img{
   width:180px;
   height:180px;
}
.button-area{
   flex-direction:column;
}
.button-area button{
   width:100%;
}
.name-row{
   display:flex;
   flex-direction:row;
   gap:10px;
}
}
@media (max-width:480px){
.container{
   margin:10px;
   padding:15px;
}
.product img{
   width:140px;
   height:140px;
}
.price{
   font-size:22px;
}
.form-group>div{
   flex-direction:column !important;
   gap:12px !important;
}
.form-group>div>div{
   width:100%;
}
.display-box{
   font-size:15px;
}
h2{
   font-size:24px;
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
<div class="container">
<h2>注文内容の確認</h2>
<div class="product">
   <div class="product-info">
       <img src="${selectedVariant.imageUrl}">
   </div>
   <div class="info">
       <h3>${product.name}</h3>
       <p>${selectedVariant.name}</p>
       <p>数量：${orderData.quantity}</p>
       <p>単価：
           <fmt:formatNumber value="${selectedVariant.price}" pattern="#,###"/>円
       </p>
       <p class="price">
           合計：
           <fmt:formatNumber value="${orderData.sumPrice}" pattern="#,###"/>円
       </p>
       <p>お届け予定日：${deliveryDate}</p>
   </div>
</div>
<div class="form-group">
   <label>お名前</label>
   <div class="name-row">
       <div style="flex:1;">
           <div style="font-size:12px;color:#666;margin-bottom:4px;">姓</div>
           <div class="display-box">${orderData.lastName}</div>
       </div>
       <div style="flex:1;">
           <div style="font-size:12px;color:#666;margin-bottom:4px;">名</div>
           <div class="display-box">${orderData.firstName}</div>
       </div>
   </div>
</div>
<div class="form-group">
   <label>フリガナ</label>
   <div class="name-row">
       <div style="flex:1;">
           <div style="font-size:12px;color:#666;margin-bottom:4px;">セイ</div>
           <div class="display-box">${orderData.lastNameKana}</div>
       </div>
       <div style="flex:1;">
           <div style="font-size:12px;color:#666;margin-bottom:4px;">メイ</div>
           <div class="display-box">${orderData.firstNameKana}</div>
       </div>
   </div>
</div>
<div class="form-group">
   <label>郵便番号</label>
   <div class="display-box">〒${orderData.zipCode}</div>
</div>
<div class="form-group">
   <label>都道府県</label>
   <div class="display-box">${orderData.prefecture}</div>
</div>
<div class="form-group">
   <label>市区町村・番地</label>
   <div class="display-box">${orderData.address1}</div>
</div>
<div class="form-group">
   <label>建物名・部屋番号</label>
   <div class="display-box">${orderData.address2}</div>
</div>
<div class="form-group">
   <label>電話番号</label>
   <div class="display-box">${orderData.phone}</div>
</div>
<form action="/purchase/complete" method="post">
<div class="button-area">
<button type="button" onclick="history.back()">
戻る
</button>
<button type="submit">
注文を確定する
</button>
</div>
</form>
</div>
<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>

