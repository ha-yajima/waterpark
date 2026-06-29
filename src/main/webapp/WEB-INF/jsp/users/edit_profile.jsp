<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>会員情報変更</title>
</head>
<body>

    <h2>会員情報変更</h2>
    <c:if test="${not empty successMessage}">
        <p>${successMessage}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/users/edit" method="post">
        
        <table border="1">
            <tr>
                <th>お名前</th>
                <td>
                    姓：<input type="text" name="lastName" value="${user.lastName}" required>
                    名：<input type="text" name="firstName" value="${user.firstName}" required>
                </td>
            </tr>
            <tr>
                <th>フリガナ</th>
                <td>
                    セイ：<input type="text" name="lastNameKana" value="${user.lastNameKana}" required>
                    メイ：<input type="text" name="firstNameKana" value="${user.firstNameKana}" required>
                </td>
            </tr>
            <tr>
                <th>メールアドレス</th>
                <td><input type="email" name="email" value="${user.email}" required></td>
            </tr>
            <tr>
                <th>電話番号</th>
                <td><input type="text" name="phoneNumber" value="${user.phoneNumber}" required></td>
            </tr>
            <tr>
                <th>郵便番号</th>
                <td><input type="text" name="postalCode" value="${user.postalCode}" required></td>
            </tr>
            <tr>
                <th>都道府県</th>
                <td><input type="text" name="prefecture" value="${user.prefecture}" required></td>
            </tr>
            <tr>
                <th>市区町村・番地</th>
                <td><input type="text" name="address1" value="${user.address1}" required></td>
            </tr>
            <tr>
                <th>建物名・部屋番号</th>
                <td><input type="text" name="address2" value="${user.address2}"></td>
            </tr>
        </table>

        <br>
        <button type="submit">変更を保存する</button>
    </form>

</body>
</html>