<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
   <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
   <title>waterpark|注文完了</title>
   <style type="text/css">
	body{
	    font-family:sans-serif;
	    background:#f4f9fc;
	    color:#333;
	}
	
	.container{
	    max-width:700px;
	    margin:auto;
	    background:#fff;
	    padding:40px;
	    border-radius:8px;
	    box-shadow:0 2px 8px rgba(0,0,0,.1);
	}
	
	.complete-icon{
	    width:90px;
	    height:90px;
	    margin:auto;
	    border-radius:50%;
	    background:#3A8FBF;
	    color:#fff;
	    font-size:50px;
	    display:flex;
	    justify-content:center;
	    align-items:center;
	}
	
	h1{
	    text-align:center;
	    margin-top:20px;
	    color:#333;
	}
	
	.message{
	    text-align:center;
	    color:#666;
	    margin-bottom:35px;
	}
	
	
	.order-box{
	    display:flex;
	    gap:20px;
	    align-items:center;
	    border:1px solid #dcecf6;
	    border-left:5px solid #74C2F2;
	    background:#f8fbfd;
	    border-radius:10px;
	    padding:20px;
	}
	
	
	.product-img{
	    width:150px;
	    height:150px;
	    object-fit:cover;
	    border-radius:8px;
	    border:1px solid #ddd;
	}
	
	
	.info{
	    flex:1;
	}
	
	
	.info h3{
	    margin-top:0;
	}
	
	
	.button-area{
	    display:flex;
	    justify-content:center;
	    gap:20px;
	    margin-top:35px;
	}
	
	.btn{
	    background:#3A8FBF;
	    color:#fff;
	    padding:12px 35px;
	    border-radius:6px;
	    text-decoration:none;
	    transition:.2s;
	}
	
	.btn,
	.btn:visited{
	    color:#fff;
	}
			
	
	.btn:hover{
	    background:#2b79a5;
	}
	
	
	/* スマホ */
	@media(max-width:768px){
	
	.container{
	    margin:15px;
	    padding:25px 15px;
	}
	
	
	.complete-icon{
	    width:70px;
	    height:70px;
	    font-size:40px;
	}
	
	
	h1{
	    font-size:24px;
	}
	
	
	.order-box{
	    flex-direction:column;
	    text-align:center;
	}
	
	
	.product-img{
	    width:180px;
	    height:180px;
	}
	
	
	.info{
	    width:100%;
	}
	
	
	.button-area{
	    flex-direction:column;
	    gap:15px;
	}
	
	
	.btn{
	    width:100%;
	    text-align:center;
	    box-sizing:border-box;
	}
	
	}
	
	
	@media(max-width:480px){
	
	.container{
	    padding:20px 10px;
	}
	
	
	.message{
	    font-size:14px;
	}
	
	
	.product-img{
	    width:140px;
	    height:140px;
	}
	
	}
   </style>
   </head>
   <body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" />
<div class="container">
   <div class="complete-icon">✓</div>
   <h1>ご注文ありがとうございます！</h1>
   <p class="message">
       ご注文を受け付けました。<br>
       発送準備が整い次第、お届けいたします。
   </p>
   <div class="order-box">
       <img src="${selectedVariant.imageUrl}" class="product-img">
       <div class="info">
           <h3>${product.name}</h3>
           <p>${selectedVariant.name}</p>
           <p>数量：${orderData.quantity}</p>
           <p>
               合計：
               <fmt:formatNumber value="${orderData.sumPrice}" pattern="#,###"/>
               円
           </p>
           <p>お届け予定日：${deliveryDate}</p>
       </div>
   </div>
  <div class="button-area">
	<a href="/" class="btn">
	    トップページへ戻る
	</a>
</div>
</div>
<jsp:include page="/WEB-INF/jsp/common/footer.jsp" />
</body>
</html>

