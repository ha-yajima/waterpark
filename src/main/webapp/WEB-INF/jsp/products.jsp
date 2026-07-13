<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <jsp:include page="/WEB-INF/jsp/common/head.jsp" />
    <title>商品一覧 | water park</title>
    <link rel="stylesheet" href="/css/index.css">
</head>
<body>
    <!-- index.jspと同じ共通ヘッダー・サーチを使用 -->
    <jsp:include page="/WEB-INF/jsp/common/header.jsp" />




    <main>


        <section class="product-section">


            <div class="section-header">


                <h2>
                    <c:choose>


                        <c:when test="${not empty keyword
                                or not empty prefecture
                                or not empty hardness
                                or not empty type}">


                            「


                            <c:if test="${not empty keyword}">
                                <c:out value="${keyword}" />
                            </c:if>


                            <c:if test="${not empty prefecture}">
                                <c:if test="${not empty keyword}">
                                    ・
                                </c:if>


                                <c:out value="${prefecture}" />
                            </c:if>


                            <c:if test="${not empty hardness}">


                                <c:if test="${not empty keyword
                                        or not empty prefecture}">
                                    ・
                                </c:if>


                                <c:forEach
                                        var="h"
                                        items="${hardness}"
                                        varStatus="status">


                                    <c:if test="${!status.first}">
                                        ・
                                    </c:if>


                                    <c:out value="${h}" />


                                </c:forEach>


                            </c:if>


                            <c:if test="${not empty type}">


                                <c:if test="${not empty keyword
                                        or not empty prefecture
                                        or not empty hardness}">
                                    ・
                                </c:if>


                                <c:forEach
                                        var="t"
                                        items="${type}"
                                        varStatus="status">


                                    <c:if test="${!status.first}">
                                        ・
                                    </c:if>


                                    <c:out value="${t}" />


                                </c:forEach>


                            </c:if>


                            」の検索結果


                        </c:when>


                        <c:when test="${sort == 'new'}">
                            新着商品
                        </c:when>


                        <c:when test="${sort == 'ranking'}">
                            ランキング
                        </c:when>


                        <c:when test="${sort == 'recommended'}">
                            おすすめ商品
                        </c:when>


                        <c:otherwise>
                            商品一覧
                        </c:otherwise>


                    </c:choose>
                </h2>


            </div>




            <!-- 商品が0件の場合 -->
            <c:if test="${empty productList}">
                <p class="empty-message">
                    該当する商品はありません。
                </p>
            </c:if>




            <!-- 商品一覧 -->
            <div class="product-grid">


                <c:forEach var="product" items="${productList}">


                    <div class="product-card">


                        <a href="/product?id=${product.productId}">


                            <div class="product-image">
                                <img
                                    src="${product.variantImageUrl}"
                                    alt="${product.name}">
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


        </section>


    </main>




    <!-- 共通フッター -->
    <jsp:include page="/WEB-INF/jsp/common/footer.jsp" />


</body>


</html>





