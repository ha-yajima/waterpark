<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>お問い合わせ - 入力</title>
</head>
<body>

    <h2>お問い合わせ（入力）</h2>

    <form action="${pageContext.request.contextPath}/inquiries/confirm" method="post">
        
        <table border="1">
            <tr>
                <th>お問い合わせ種類</th>
                <td>
                    <select name="type" required>
                        <option value="">選択してください</option>
                        <option value="製品について">製品について</option>
                        <option value="料金・お支払い">料金・お支払い</option>
                        <option value="その他">その他</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>メールアドレス</th>
                <td><input type="email" name="email" required></td>
            </tr>
            <tr>
                <th>お問い合わせ内容</th>
                <td>
                    <textarea name="message" rows="5" cols="40" required></textarea>
                </td>
            </tr>
            <tr>
                <th>添付画像URL</th>
                <td>
                    <input type="text" name="imageUrl" placeholder="http://...（任意）">
                </td>
            </tr>
        </table>

        <br>
        <button type="submit">確認画面へ</button>
    </form>

</body>
</html>