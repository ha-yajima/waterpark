<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>会員登録 - 確認</title>
</head>
<body>

    <h2>会員登録（確認）</h2>
    <p>以下の内容で登録します。よろしければ「登録する」ボタンを押してください。</p>

    <table border="1">
        <tr>
            <th>お名前</th>
            <td>${user.lastName} ${user.firstName}</td>
        </tr>
        <tr>
            <th>フリガナ</th>
            <td>${user.lastNameKana} ${user.firstNameKana}</td>
        </tr>
        <tr>
            <th>メールアドレス</th>
            <td>${user.email}</td>
        </tr>
        <tr>
            <th>パスワード</th>
            <td>********（セキュリティのため非表示）</td>
        </tr>
        <tr>
            <th>電話番号</th>
            <td>${user.phoneNumber}</td>
        </tr>
        <tr>
            <th>郵便番号</th>
            <td>${user.postalCode}</td>
        </tr>
        <tr>
            <th>都道府県</th>
            <td>${user.prefecture}</td>
        </tr>
        <tr>
            <th>市区町村・番地</th>
            <td>${user.address1}</td>
        </tr>
        <tr>
            <th>建物名・部屋番号</th>
            <td>${user.address2}</td>
        </tr>
    </table>

    <br>

    <form action="${pageContext.request.contextPath}/users/register/execute" method="post">
        
        <input type="hidden" name="lastName" value="${user.lastName}">
        <input type="hidden" name="firstName" value="${user.firstName}">
        <input type="hidden" name="lastNameKana" value="${user.lastNameKana}">
        <input type="hidden" name="firstNameKana" value="${user.firstNameKana}">
        <input type="hidden" name="email" value="${user.email}">
        <input type="hidden" name="password" value="${user.password}"> <input type="hidden" name="phoneNumber" value="${user.phoneNumber}">
        <input type="hidden" name="postalCode" value="${user.postalCode}">
        <input type="hidden" name="prefecture" value="${user.prefecture}">
        <input type="hidden" name="address1" value="${user.address1}">
        <input type="hidden" name="address2" value="${user.address2}">

        <button type="button" onclick="history.back()">戻る</button>
        <button type="submit">登録する</button>
    </form>

</body>
</html>