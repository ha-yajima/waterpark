<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>プライバシーポリシー | water park</title>
    <link rel="stylesheet" href="/css/index.css">
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <h1 class="site-logo">
            <a href="/" class="site-logo-link">
               <img src="/images/logo/waterpark_logo01.png" alt="water park" class="site-logo-img">
            </a>
        </h1>

        <div class="header-right">

            <nav class="global-nav">
                <a href="/products?sort=new" class="nav-text-link">NEW</a>

                <a href="/products" class="nav-text-link">商品一覧</a>

                <a href="/mypage" class="nav-text-link">マイページ</a>

                <a href="/cart" class="nav-icon-link cart-icon-link" aria-label="カート" title="カート">
                    <svg viewBox="0 0 24 24" class="nav-icon">
                        <path d="M3 4h2l2.5 12h10L20 8H7"></path>
                        <circle cx="10" cy="20" r="1.5"></circle>
                        <circle cx="17" cy="20" r="1.5"></circle>
                    </svg>

                    <c:if test="${cartCount > 0}">
                        <span class="cart-badge">
                            <c:out value="${cartCount}" />
                        </span>
                    </c:if>
                </a>
            </nav>

            <form action="/products/search" method="get" class="header-search-form">
                <input type="text" name="keyword" class="header-search-input" placeholder="キーワードを入力">
                <button type="submit" class="header-search-button" aria-label="検索">
                    <svg viewBox="0 0 24 24" class="header-search-icon">
                        <circle cx="11" cy="11" r="7"></circle>
                        <path d="M16.5 16.5L21 21"></path>
                    </svg>
                </button>
            </form>

        </div>
    </div>
</header>

<main class="policy-page">

    <h1>プライバシーポリシー</h1>

    <p>
        water park運営事務局（以下、「当サイト」といいます。）は、
        当サイトのサービスをご利用いただくお客様の個人情報を適切に取り扱うため、
        以下のとおりプライバシーポリシーを定めます。
    </p>

    <section class="policy-section">
        <h2>1. 個人情報の取得について</h2>
        <p>
            当サイトでは、会員登録、商品のご注文、お問い合わせ等の際に、
            お客様の氏名、住所、電話番号、メールアドレス、配送先情報、購入履歴などの個人情報を取得する場合があります。
        </p>
    </section>

    <section class="policy-section">
        <h2>2. 個人情報の利用目的</h2>
        <p>
            当サイトは、取得した個人情報を以下の目的で利用します。
        </p>
        <ul>
            <li>商品の発送、注文内容の確認、代金請求のため</li>
            <li>会員登録、ログイン、マイページ機能の提供のため</li>
            <li>お問い合わせへの対応のため</li>
            <li>キャンペーン、重要なお知らせ、サービスに関するご案内のため</li>
            <li>購入履歴や利用状況の確認、サービス改善のため</li>
            <li>不正利用の防止、トラブル対応のため</li>
        </ul>
    </section>

    <section class="policy-section">
        <h2>3. 個人情報の管理について</h2>
        <p>
            当サイトは、取得した個人情報について、漏えい、紛失、改ざん、不正アクセス等を防止するため、
            適切な管理に努めます。
        </p>
    </section>

    <section class="policy-section">
        <h2>4. 個人情報の第三者提供について</h2>
        <p>
            当サイトは、法令に基づく場合を除き、お客様の同意なく個人情報を第三者に提供することはありません。
            ただし、商品の配送、決済処理、システム管理など、サービス提供に必要な範囲で業務委託先に情報を提供する場合があります。
        </p>
    </section>

    <section class="policy-section">
        <h2>5. Cookie等の利用について</h2>
        <p>
            当サイトでは、サイトの利便性向上や利用状況の確認のため、Cookie等を使用する場合があります。
            Cookieにより取得される情報には、個人を直接特定する情報は含まれません。
        </p>
    </section>

    <section class="policy-section">
        <h2>6. 個人情報の開示・訂正・削除について</h2>
        <p>
            お客様ご本人から、登録情報の開示、訂正、削除、利用停止等のご希望があった場合には、
            本人確認の上、合理的な範囲で対応いたします。
        </p>
    </section>

    <section class="policy-section">
        <h2>7. プライバシーポリシーの変更について</h2>
        <p>
            当サイトは、必要に応じて本プライバシーポリシーの内容を変更することがあります。
            変更後の内容は、当サイト上に掲載した時点で効力を生じるものとします。
        </p>
    </section>

    <section class="policy-section">
        <h2>8. お問い合わせ先</h2>
        <p>
            個人情報の取り扱いに関するお問い合わせは、お問い合わせページよりご連絡ください。
        </p>
    </section>

    <p class="policy-date">
        制定日：2026年7月14日<br>
        water park運営事務局
    </p>

</main>

<footer class="site-footer">
    <div class="footer-inner">
        <div>
            <h2>💧 water park</h2>
            <p>日本各地の特色ある水を、もっと身近に。</p>
        </div>

        <div class="footer-links">
            <div>
                <h3>お買い物ガイド</h3>
                <p>ご利用ガイド</p>
                <p>送料・配送について</p>
                <p>お支払い方法</p>
            </div>
            <div>
                <h3>会員サービス</h3>
                <p>マイページ</p>
                <p>注文履歴</p>
                <p>会員登録</p>
            </div>
            <div>
                <h3>当サイトについて</h3>
                <p>お問い合わせ</p>
                <p><a href="/privacy">プライバシーポリシー</a></p>
                <p>運営会社</p>
            </div>
        </div>
    </div>

    <p class="copyright">&copy; 2026 water park All Rights Reserved.</p>
</footer>

</body>
</html>