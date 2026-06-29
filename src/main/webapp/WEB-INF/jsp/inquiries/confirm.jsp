<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>お問い合わせ - 確認</title>
</head>
<body>

    <h2>お問い合わせ（確認）</h2>
    <p>以下の内容で送信します。よろしければ「送信する」ボタンを押してください。</p>

    <table border="1">
        <tr>
            <th>お問い合わせ種類</th>
            <td>${inquiry.type}</td>
        </tr>
        <tr>
            <th>メールアドレス</th>
            <td>${inquiry.email}</td>
        </tr>
        <tr>
            <th>お問い合わせ内容</th>
            <td>${inquiry.message}</td>
        </tr>
        <tr>
            <th>添付画像URL</th>
            <td>${inquiry.imageUrl}</td>
        </tr>
    </table>

    <br>

    <form action="${pageContext.request.contextPath}/inquiries/execute" method="post">
        
        <input type="hidden" name="type" value="${inquiry.type}">
        <input type="hidden" name="email" value="${inquiry.email}">
        <input type="hidden" name="message" value="${inquiry.message}">
        <input type="hidden" name="imageUrl" value="${inquiry.imageUrl}">

        <button type="button" onclick="history.back()">戻る</button>
        <button type="submit">送信する</button>
    </form>

</body>
</html>