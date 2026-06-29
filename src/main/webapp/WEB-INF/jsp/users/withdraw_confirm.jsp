<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>退会確認</title>
</head>
<body>

    <h2>退会手続き</h2>
    
    <p style="color: red; font-weight: bold;">
        ※一度退会すると、これまでの会員情報はすべて削除され、元に戻すことはできません。
    </p>
    <p>本当に退会しますか？</p>

    <form action="${pageContext.request.contextPath}/users/withdraw" method="post">
        <button type="submit" style="background-color: red; color: white; padding: 10px 20px; border: none; cursor: pointer;">
            退会する（会員情報を削除）
        </button>
    </form>

    <br>
    <a href="${pageContext.request.contextPath}/">トップ画面に戻る</a>

</body>
</html>