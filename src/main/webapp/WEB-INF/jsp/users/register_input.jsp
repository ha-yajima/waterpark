<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>会員登録 - 入力</title>
</head>
<body>

    <h2>会員登録（入力）</h2>

    <form action="${pageContext.request.contextPath}/users/register/confirm" method="post">
        
        <table border="1">
            <tr>
                <th>お名前</th>
                <td>
                    姓：<input type="text" name="lastName" required>
                    名：<input type="text" name="firstName" required>
                </td>
            </tr>
            <tr>
                <th>フリガナ</th>
                <td>
                    セイ：<input type="text" name="lastNameKana" required>
                    メイ：<input type="text" name="firstNameKana" required>
                </td>
            </tr>
            <tr>
                <th>メールアドレス</th>
                <td><input type="email" name="email" required></td>
            </tr>
            <tr>
                <th>パスワード</th>
                <td><input type="password" name="password" required></td>
            </tr>
            <tr>
                <th>電話番号</th>
                <td><input type="text" name="phoneNumber" placeholder="ハイフンなし" required></td>
            </tr>
            <tr>
                <th>郵便番号</th>
                <td><input type="text" name="postalCode" placeholder="ハイフンなし" required></td>
            </tr>
            <tr>
                <th>都道府県</th>
                <td><input type="text" name="prefecture" required></td>
            </tr>
            <tr>
                <th>市区町村・番地</th>
                <td><input type="text" name="address1" required></td>
            </tr>
            <tr>
                <th>建物名・部屋番号</th>
                <td><input type="text" name="address2"></td>
            </tr>
        </table>

        <br>
        <button type="submit">確認画面へ</button>
    </form>

</body>
</html>