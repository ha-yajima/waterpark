<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<footer class="site-footer">
   <div class="footer-inner">
       <div>
           <img src="/images/logo/waterpark_logo01.png" alt="water park" class="site-logo-img">
        </div>
   <div class="footer-links">
       <div>
           <h3>会員サービス</h3>
           <p><a href="/mypage">マイページ</a></p>
           <p><a href="/users/register">会員登録</a></p>
       </div>
       <div>
           <h3>当サイトについて</h3>
           <p><a href="/inquiries">お問い合わせ</a></p>
         	<p><a href="/privacy">プライバシーポリシー</a></p>
       </div>
   </div>
</div>
<p class="copyright">&copy; 2026 water park All Rights Reserved.</p>
</footer>

<button type="button" class="back-to-top" id="backToTopButton" aria-label="ページの先頭へ戻る">
    <svg viewBox="0 0 24 24" class="back-to-top-icon">
        <path d="M18 15l-6-6-6 6"></path>
    </svg>
</button>

<script>
document.addEventListener("DOMContentLoaded", function () {

   const hamburgerButton = document.getElementById("hamburgerButton");
   const sideSearchMenu = document.getElementById("sideSearchMenu");
   const sideMenuOverlay = document.getElementById("sideMenuOverlay");
   const sideMenuClose = document.getElementById("sideMenuClose");

   if (hamburgerButton && sideSearchMenu && sideMenuOverlay && sideMenuClose) {
      hamburgerButton.addEventListener("click", function () {
         sideSearchMenu.classList.add("is-open");
         sideMenuOverlay.classList.add("is-open");
      });

      sideMenuClose.addEventListener("click", function () {
         sideSearchMenu.classList.remove("is-open");
         sideMenuOverlay.classList.remove("is-open");
      });

      sideMenuOverlay.addEventListener("click", function () {
         sideSearchMenu.classList.remove("is-open");
         sideMenuOverlay.classList.remove("is-open");
      });
   }

   const keywordInput = document.getElementById("sideKeyword");
   const keywordClearButton = document.getElementById("keywordClearButton");

   if (keywordInput && keywordClearButton) {
      keywordClearButton.addEventListener("click", function () {
         keywordInput.value = "";
         keywordInput.focus();
      });
   }
   const backToTopButton = document.getElementById("backToTopButton");

   if (backToTopButton) {
       window.addEventListener("scroll", function () {
           if (window.scrollY > 300) {
               backToTopButton.classList.add("is-visible");
           } else {
               backToTopButton.classList.remove("is-visible");
           }
       });

       backToTopButton.addEventListener("click", function () {
           window.scrollTo({ top: 0, behavior: "smooth" });
       });
   }
});
</script>