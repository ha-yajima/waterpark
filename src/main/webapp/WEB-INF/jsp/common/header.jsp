<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<header class="site-header">
 <div class="header-inner">
<!-- ハンバーガーメニューボタン -->
<button class="hamburger-button" id="hamburgerButton" type="button" aria-label="メニューを開く">
 <span></span>
 <span></span>
 <span></span>
 <small>SEARCH</small>
</button>
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
<!-- ★ここから追記★サイド検索メニュー -->
<div class="side-menu-overlay" id="sideMenuOverlay"></div>
<aside class="side-search-menu" id="sideSearchMenu">
 <div class="side-search-header">
    <h2>SEARCH</h2>
    <button class="side-menu-close" id="sideMenuClose" type="button" aria-label="メニューを閉じる">×</button>
 </div>
 <form action="/products/search" method="get" class="side-search-form">
    <div class="side-search-group">
    <div class="side-keyword-row">
  <div class="side-keyword-input-wrap">
      <input type="text" id="sideKeyword" name="keyword" placeholder="キーワードを入力">
      <button type="button" class="side-keyword-clear"  id="keywordClearButton" aria-label="キーワードを消す">×</button>
  </div>
</div>
    </div>
    <div class="side-search-group">
     
       <details open>
 <summary>都道府県</summary>
 <select name="prefecture" class="side-select" >
    <option value="" class="accordion-btn">選択してください</option>
    <option value="北海道">北海道</option>
    <option value="青森県">青森県</option>
    <option value="岩手県">岩手県</option>
    <option value="宮城県">宮城県</option>
    <option value="秋田県">秋田県</option>
    <option value="山形県">山形県</option>
    <option value="福島県">福島県</option>
    <option value="茨城県">茨城県</option>
    <option value="栃木県">栃木県</option>
    <option value="群馬県">群馬県</option>
    <option value="埼玉県">埼玉県</option>
    <option value="千葉県">千葉県</option>
    <option value="東京都">東京都</option>
    <option value="神奈川県">神奈川県</option>
    <option value="新潟県">新潟県</option>
    <option value="富山県">富山県</option>
    <option value="石川県">石川県</option>
    <option value="福井県">福井県</option>
    <option value="山梨県">山梨県</option>
    <option value="長野県">長野県</option>
    <option value="岐阜県">岐阜県</option>
    <option value="静岡県">静岡県</option>
    <option value="愛知県">愛知県</option>
    <option value="三重県">三重県</option>
    <option value="滋賀県">滋賀県</option>
    <option value="京都府">京都府</option>
    <option value="大阪府">大阪府</option>
    <option value="兵庫県">兵庫県</option>
    <option value="奈良県">奈良県</option>
    <option value="和歌山県">和歌山県</option>
    <option value="鳥取県">鳥取県</option>
    <option value="島根県">島根県</option>
    <option value="岡山県">岡山県</option>
    <option value="広島県">広島県</option>
    <option value="山口県">山口県</option>
    <option value="徳島県">徳島県</option>
    <option value="香川県">香川県</option>
    <option value="愛媛県">愛媛県</option>
    <option value="高知県">高知県</option>
    <option value="福岡県">福岡県</option>
    <option value="佐賀県">佐賀県</option>
    <option value="長崎県">長崎県</option>
    <option value="熊本県">熊本県</option>
    <option value="大分県">大分県</option>
    <option value="宮崎県">宮崎県</option>
    <option value="鹿児島県">鹿児島県</option>
    <option value="沖縄県">沖縄県</option>
 </select>
</details>
       <details>
          <summary>硬度</summary>
          <label><input type="checkbox" name="hardness" value="軟水"> 軟水</label>
          <label><input type="checkbox" name="hardness" value="中硬水"> 中硬水</label>
          <label><input type="checkbox" name="hardness" value="硬水"> 硬水</label>
       </details>
       <details>
		   <summary>種類・タイプ</summary>
		
		   <label><input type="checkbox" name="type" value="天然水"> 天然水</label>
		   <label><input type="checkbox" name="type" value="ミネラルウォーター"> ミネラルウォーター</label>
		   <label><input type="checkbox" name="type" value="ナチュラルミネラルウォーター"> ナチュラルミネラルウォーター</label>
		   <label><input type="checkbox" name="type" value="ナチュラルウォーター"> ナチュラルウォーター</label>
		   <label><input type="checkbox" name="type" value="ボトルドウォーター"> ボトルドウォーター</label>
		   <label><input type="checkbox" name="type" value="蒸留水"> 蒸留水</label>
		   <label><input type="checkbox" name="type" value="緑茶"> 緑茶 </label>
		   <label><input type="checkbox" name="type" value="ほうじ茶"> ほうじ茶 </label>
		   <label><input type="checkbox" name="type" value="烏龍茶"> 烏龍茶 </label>
		   <label><input type="checkbox" name="type" value="玄米茶"> 玄米茶 </label>
		   <label><input type="checkbox" name="type" value="紅茶"> 紅茶 </label>
		   <label><input type="checkbox" name="type" value="地サイダー"> 地サイダー </label>
		   <label><input type="checkbox" name="type" value="地ラムネ"> 地ラムネ </label>
		   <label><input type="checkbox" name="type" value="地コーラ"> 地コーラ </label>
		   <label><input type="checkbox" name="type" value="地ビール"> 地ビール </label>
		   <label><input type="checkbox" name="type" value="地ワイン"> 地ワイン </label>
		   <label><input type="checkbox" name="type" value="日本酒"> 日本酒 </label>
		   
		</details>
    </div>
    <div class="side-search-buttons">
       <button type="reset" class="side-clear-button">クリア</button>
       <button type="submit" class="side-submit-button">検索</button>
    </div>
 </form>
</aside>