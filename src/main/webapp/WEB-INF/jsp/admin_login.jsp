<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>地元の水ECサイト - 管理者ログイン</title>
    <style>
        body { background-color: #f4f6f9; font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #333; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 8px; color: #666; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn-login { width: 100%; padding: 12px; background-color: #007bff; border: none; color: white; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; }
        .btn-login:hover { background-color: #0056b3; }
        .error-msg { color: red; text-align: center; margin-bottom: 16px; }
    </style>
</head>
<body>

<div class="login-box">
    <h2>管理者ログイン</h2>
    
    <c:if test="${param.error == 'true'}">
        <div class="error-msg">IDまたはパスワードが違います。</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admintop/login" method="post">
        <div class="form-group">
            <label for="adminId">管理者ID</label>
            <input type="text" id="adminId" name="adminId" required>
        </div>
        <div class="form-group">
            <label for="password">パスワード</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="btn-login">ログイン</button>
    </form>
</div>

</body>
</html>