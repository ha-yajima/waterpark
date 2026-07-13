<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>地元の水ECサイト - 管理者画面</title>
   <style>
       .admin-container { display: flex; min-height: 100vh; }
       .admin-sidebar { width: 150px; background-color: #333; padding: 20px; color: white; }
       .admin-main-content { flex: 1; padding: 20px; background-color: #f8f9fa; }
       .admin-sidebar a { display: block; padding: 10px 0; text-decoration: none; color: #fff; }
       .admin-sidebar a:hover { text-decoration: underline; }
       .sub-image-row { display: flex; align-items: center; margin-bottom: 5px; }
       .admin-sidebar {
		    position: fixed;        /* 位置を固定 */
		    top: 0;                 /* 上端に配置 */
		    left: 0;                /* 左端に配置 */
		    width: 150px;           /* 適切な幅 */
		    height: 100vh;          /* 画面の高さに合わせる */
		    overflow-y: auto;       /* 中身が多い場合はサイドバー内でスクロールできるようにする */
		    z-index: 1000;          /* 他の要素より上に表示 */
		}
		
		/* メインコンテンツ側も調整が必要です */
		.admin-main-content {
		    margin-left: 250px;     /* サイドバーの幅分だけ左側に余白を作る */
		    padding: 10px;
		}
   </style>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_responsive.css">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<div class="admin-container">
   <div class="admin-sidebar">
       <h3>管理メニュー</h3>
       <hr>
       <a href="${pageContext.request.contextPath}/admintop/main?mode=top">TOP</a>
       <a href="${pageContext.request.contextPath}/admintop/main?mode=product">商品管理</a>
       <a href="${pageContext.request.contextPath}/admintop/orders">注文管理</a>
       <a href="${pageContext.request.contextPath}/admintop/campaign">キャンペーン管理</a>
       <a href="${pageContext.request.contextPath}/admintop/news">お知らせ管理</a>
       <a href="${pageContext.request.contextPath}/admintop/main?mode=inquiry">問い合わせ対応</a>
       <hr>
       <a href="${pageContext.request.contextPath}/admintop/login" style="color: #ff6b6b;">ログアウト</a>
   </div>
   <div class="admin-main-content">
       <c:choose>
       	<%-- ➕ ダッシュボードの初期トップ画面（真ん中にロゴを表示） --%>
			<c:when test="${mode == 'top' || empty mode}">
			    <div style="display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 60vh; text-align: center;">
			   
			        <!-- 歓迎メッセージ（必要に応じて文言は変えてください！） -->
			        <h2 style="color: #495057; margin-top: 110px; font-size: 24px;">管理コンソールへようこそ</h2>
			   
			        <!-- 40行目：src=" の直後のスペースを完全に削除 -->
			        <img src="${pageContext.request.contextPath}/assets/logo/waterpark_logo01.png"
					     alt="Water Park Logo"
					     style="max-width: 700px; width: 100%; height: auto; margin-bottom: 10px;">
			            
			        <p style="color: #6c757d; font-size: 14px; margin-top: 5px;">左側のメニューから操作を選択してください。</p>
			       
			    </div>
			</c:when>
      
		    <c:when test="${mode == 'product'}">
		        <h2>📦 商品管理（登録・変更・削除）</h2>
		        <hr>
			
		        <div style="background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
		            <h3 style="margin-top:0;">${isEdit ? '🔄 商品を変更する' : '➕ 商品を新しく登録する'}</h3>
		           
		            <!-- 🔍 検索窓エリア（登録時・変更時どちらでもJSエラーを起こさないよう、常に配置を維持します） -->
		            <div style="background: #e9ecef; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
		                <label>🔍 登録済みの商品名を入力して検索：</label>
		                <input type="text" id="ajaxSearchName" value="${searchKeyword}" placeholder="商品名を入力..." style="padding: 5px; width: 250px;">
		                <button type="button" onclick="searchProduct()" style="padding: 5px 10px;">検索</button>
		                <c:if test="${not empty searchKeyword}">
		                    <a href="${pageContext.request.contextPath}/admintop/main?mode=product" style="margin-left: 10px; color: #666; text-decoration: none; font-size: 11px;">❌ 検索クリア</a>
		                </c:if>
		            </div>
			
		            <form action="${pageContext.request.contextPath}/admin/product/save" method="post" enctype="multipart/form-data">
		                <input type="hidden" name="productId" value="${productForm.productId}">
					
		                <!-- ■ 1. 商品の基本情報（productsテーブル対応） -->
		                <h4 style="margin: 0 0 10px 0; color: #007bff;">💧 商品の基本情報</h4>
		                <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
		                    <tr>
		                        <td style="width: 15%; padding: 8px;">商品名</td>
		                        <td><input type="text" name="name" value="${productForm.name}" required style="width: 80%; padding: 6px;"></td>
		                        <td style="width: 15%; padding: 8px;">水の硬度</td>
		                        <td><input type="text" name="hard" value="${productForm.hard}" placeholder="例: 硬水、軟水" style="width: 80%; padding: 6px;"></td>
		                    </tr>
		                    <tr>
		                        <td style="padding: 8px;">商品説明</td>
		                        <td><textarea name="description" style="width: 80%; height: 60px; padding: 6px;">${productForm.description}</textarea></td>
		                        <td style="padding: 8px;">都道府県</td>
		                        <td><input type="text" name="ken" value="${productForm.ken}" placeholder="例: 岐阜県" style="width: 80%; padding: 6px;"></td>
		                    </tr>
		                    <tr>
		                        <td style="padding: 8px;">水の種類</td>
		                        <td>
		                            <select name="kinds" style="width: 83%; padding: 6px;" required>
		                                <option value="">-- 選択してください --</option>
		                                <option value="ミネラルウォーター" ${productForm.kinds == 'ミネラルウォーター' ? 'selected' : ''}>ミネラルウォーター</option>
		                                <option value="ナチュラルミネラルウォーター" ${productForm.kinds == 'ナチュラルミネラルウォーター' ? 'selected' : ''}>ナチュラルミネラルウォーター</option>
		                                <option value="ナチュラルウォーター" ${productForm.kinds == 'ナチュラルウォーター' ? 'selected' : ''}>ナチュラルウォーター</option>
		                                <option value="ボトルドウォーター" ${productForm.kinds == 'ボトルドウォーター' ? 'selected' : ''}>ボトルドウォーター</option>
		                                <option value="蒸留水" ${productForm.kinds == '蒸留水' ? 'selected' : ''}>蒸留水</option>
		                                <option value="緑茶" ${productForm.base == '緑茶' ? 'selected' : ''}>緑茶</option>
		                                <option value="ほうじ茶" ${productForm.base == 'ほうじ茶' ? 'selected' : ''}>ほうじ茶</option>
		                                <option value="烏龍茶" ${productForm.base == '烏龍茶' ? 'selected' : ''}>烏龍茶</option>
		                                <option value="玄米茶" ${productForm.base == '玄米茶' ? 'selected' : ''}>玄米茶</option>
		                                <option value="紅茶" ${productForm.base == '紅茶' ? 'selected' : ''}>紅茶</option>
		                                <option value="地サイダー" ${productForm.base == '地サイダー' ? 'selected' : ''}>地サイダー</option>
		                                <option value="地ラムネ" ${productForm.base == '地ラムネ' ? 'selected' : ''}>地ラムネ</option>
		                                <option value="地コーラ" ${productForm.base == '地コーラ' ? 'selected' : ''}>地コーラ</option>
		                                <option value="地ビール" ${productForm.base == '地ビール' ? 'selected' : ''}>地ビール</option>
		                                <option value="地ワイン" ${productForm.base == '地ワイン' ? 'selected' : ''}>地ワイン</option>
		                                <option value="日本酒" ${productForm.base == '日本酒' ? 'selected' : ''}>日本酒</option>
		                            </select>


		                        </td>
		                        <td style="padding: 8px;">水のベース</td>
		                        <td>
		                            <select name="base" style="width: 83%; padding: 6px;">
		                                <option value="地下水" ${productForm.base == '地下水' ? 'selected' : ''}>地下水</option>
		                                <option value="温泉水" ${productForm.base == '温泉水' ? 'selected' : ''}>温泉水</option>
		                            </select>
		                        </td>
		                    </tr>
		                </table>
					
		                <hr style="border: 0; border-top: 1px dashed #ccc; margin: 20px 0;">
					
		                <!-- ■ 2. サブ画像管理（複数画像・product_images対応完了） -->
		                <h4 style="margin: 0 0 10px 0; color: #17a2b8;">🖼️ 商品サブ画像（複数管理用）</h4>
						<div style="background: #f8f9fa; padding: 15px; border-radius: 6px; margin-bottom: 20px; border-left: 5px solid #17a2b8;">
						    <div style="margin-bottom: 10px;">
						        <input type="file" name="subImageFiles" multiple style="padding: 6px;">
						        <small style="color: #6c757d; display: block; margin-top: 4px;">※複数選択して一括アップロードできます。</small>
						    </div>
						   
						    <c:if test="${isEdit && not empty productForm.productImages}">
						        <div style="display: flex; flex-wrap: wrap; gap: 15px; margin-top: 15px;">
						            <c:forEach var="img" items="${productForm.productImages}" varStatus="imgStatus">
						                <!-- 💡 削除時に対象の画像を画面から消せるよう、id="sub-img-box-${img.id}" を追加し、position: relative; を設定 -->
						                <div id="sub-img-box-${img.id}" style="background: white; padding: 8px; border: 1px solid #ddd; border-radius: 4px; text-align: center; width: 100px; position: relative;">
						                   
						                    <!-- ❌ 個別削除用のバツボタン -->
						                    <button type="button" onclick="deleteSubImage('${img.id}')"
						                            style="position: absolute; top: -5px; right: -5px; background: #dc3545; color: white; border: none; border-radius: 50%; width: 20px; height: 20px; font-size: 11px; cursor: pointer; line-height: 18px; padding: 0; text-align: center; font-weight: bold; box-shadow: 0 1px 3px rgba(0,0,0,0.2);">
						                        ×
						                    </button>
						
						                    <img src="${pageContext.request.contextPath}${img.imageUrl}" style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px; margin-bottom: 5px;">
						                    <div style="font-size: 10px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap; color: #555;" title="${img.imageUrl}">
						                        ${img.imageUrl}
						                    </div>
						                    <input type="hidden" name="productImages[${imgStatus.index}].id" value="${img.id}">
						                    <input type="hidden" name="productImages[${imgStatus.index}].imageUrl" value="${img.imageUrl}">
						                </div>
						            </c:forEach>
						        </div>
						    </c:if>
						</div>
						
						<!-- 💡 ボタンが押された時に、裏側で削除を行って画面から消すJavaScript（JSPの一番下などの既存のscriptタグの近くに置いても動きます） -->
						<script>
						function deleteSubImage(imageId) {
						    if (!confirm('このサブ画像を削除してもよろしいですか？\n※この操作はすぐに反映され、元に戻せません。')) {
						        return;
						    }
						
						    const contextPath = "${pageContext.request.contextPath}";
						   
						    // 非同期（Fetch API）でコントローラーの削除処理を呼び出す
						    fetch(contextPath + '/admin/product/deleteImage?imageId=' + imageId, {
						        method: 'POST'
						    })
						    .then(response => {
						        if (response.ok) {
						            // 削除に成功したら、対応する画像ボックスを画面から削除する
						            const imgBox = document.getElementById('sub-img-box-' + imageId);
						            if (imgBox) {
						                imgBox.remove();
						            }
						            alert('サブ画像を削除しました。');
						        } else {
						            alert('画像の削除に失敗しました。');
						        }
						    })
						    .catch(error => {
						        console.error('Error:', error);
						        alert('通信エラーが発生しました。');
						    });
						}
						</script>
					
		                <hr style="border: 0; border-top: 1px dashed #ccc; margin: 20px 0;">
		               
						<!-- ■ 3. バリエーション情報（product_variantsテーブル対応） -->
		                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
		                    <h4 style="margin: 0; color: #28a745;">📦 バリエーション設定（容量や本数違い）</h4>
		                    <!-- 💡 変更時（isEdit）でも新しく追加できるように、c:ifの制限を外して常にボタンを表示します -->
		                    <button type="button" onclick="addVariantRow()" style="padding: 6px 15px; background: #28a745; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer;">
		                        ＋ バリエーションを追加する
		                    </button>
		                </div>
					
		                <div id="variant-container">
		                    <c:choose>
		                        <c:when test="${isEdit && not empty productForm.variants}">
		                            <c:forEach var="v" items="${productForm.variants}" varStatus="status">
		                                <div class="variant-box" style="background: #f1f3f5; padding: 15px; border-radius: 6px; margin-bottom: 15px; border-left: 5px solid #17a2b8;">
		                                    <input type="hidden" name="variants[${status.index}].variantId" value="${v.variantId}">
		                                   
		                                    <table style="width: 100%; border-collapse: collapse;">
		                                    	
		                                    	<tr>
									                <td colspan="6">
									                    <!-- ★重要：元々のURLを隠しフィールドとして持たせる -->
									                    <input type="hidden" name="variants[${status.index}].variantImageUrl" value="${v.variantImageUrl}">
									                </td>
									            </tr>
		                                   
		                                        <tr>
		                                            <td style="width: 12%; padding: 6px;">種類 (単位)</td>
		                                            <td style="width: 21%;"><input type="text" name="variants[${status.index}].sizeOrColor" value="${v.sizeOrColor}" required style="width: 90%; padding: 6px;"></td>
		                                           
		                                            <td style="width: 12%; padding: 6px;">単価 (円)</td>
		                                            <td style="width: 21%;"><input type="number" name="variants[${status.index}].price" value="${v.price}" required style="width: 90%; padding: 6px;"></td>
		                                           
		                                            <td style="width: 12%; padding: 6px;">1本あたり容量</td>
		                                            <td style="width: 22%;">
		                                                <select name="variants[${status.index}].litl" style="width: 95%; padding: 6px;">
		                                                    <option value="250" ${v.litl == 250 ? 'selected' : ''}>250ml</option>
		                                                    <option value="500" ${v.litl == 500 ? 'selected' : ''}>500ml</option>
		                                                    <option value="1000" ${v.litl == 1000 ? 'selected' : ''}>1000ml</option>
		                                                    <option value="2000" ${v.litl == 2000 ? 'selected' : ''}>2000ml</option>
		                                                </select>
		                                            </td>
		                                        </tr>
		                                        <tr>
		                                            <td style="padding: 6px;">メイン画像</td>
		                                            <td>
		                                                <c:if test="${not empty v.existingImageUrl}">
														    <div style="margin-bottom: 8px; background: #fff; padding: 6px; border-radius: 4px; border: 1px solid #ddd; width: fit-content;">
														        <img src="${pageContext.request.contextPath}${v.existingImageUrl}" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #ccc; vertical-align: middle;">
														        <div style="font-size: 11px; color: #333; margin-top: 4px; font-weight: bold;">
														            🔗 設定中: <span style="color: #007bff;">${v.existingImageUrl}</span>
														        </div>
														        <input type="hidden" name="variants[${status.index}].existingImageUrl" value="${v.existingImageUrl}">
														    </div>
														</c:if>
		                                                <input type="file" name="variants[${status.index}].mainImageFile" style="padding: 6px;">
		                                            </td>
		                                           
		                                            <!-- 📦 既存データの在庫数は readonly -->
		                                            <td style="padding: 6px;">現在在庫数</td>
		                                            <td>
		                                                <input type="number" name="variants[${status.index}].stock" value="${v.stock}" readonly style="width: 90%; padding: 6px; background-color: #e9ecef; color: #495057; border: 1px solid #ced4da; cursor: not-allowed;">
		                                            </td>
		                                           
		                                            <!-- ➕ 右側に「増やしたい個数」の入力欄を追加 -->
		                                            <td style="padding: 6px; color: #007bff; font-weight: bold;">在庫の増減</td>
		                                            <td>
		                                                <input type="number" name="variants[${status.index}].stockAdjustment" placeholder="0 (例: 5や-3)" style="width: 90%; padding: 6px; border: 2px solid #007bff; border-radius: 4px; font-weight: bold;" />
		                                            </td>
		                                        </tr>
		                                        <tr>
		                                        <!-- バリエーション設定内のテーブル行 -->
												    <td style="padding: 6px;">表示順</td>
               									<td><input type="number" name="variants[0].isMain" value="0" min="0" required style="width: 60px; padding: 6px;"></td>
		                                            <td colspan="6" style="text-align: right; padding-top: 10px; padding-right: 10px;">
		                                                <button type="button" onclick="removeVariantRow(this)" style="padding: 5px 12px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 11px;">削除</button>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                </div>
		                            </c:forEach>
		                        </c:when>
		                       
		                        <c:otherwise>
		                            <div class="variant-box" style="background: #f1f3f5; padding: 15px; border-radius: 6px; margin-bottom: 15px; border-left: 5px solid #17a2b8;">
		                                <table style="width: 100%; border-collapse: collapse;">
		                                    <tr>
		                                        <td style="width: 12%; padding: 6px;">種類 (単位)</td>
		                                        <td style="width: 21%;"><input type="text" name="variants[0].sizeOrColor" placeholder="例: 28本入り" required style="width: 90%; padding: 6px;"></td>
		                                        <td style="width: 12%; padding: 6px;">単価 (円)</td>
		                                        <td style="width: 21%;"><input type="number" name="variants[0].price" required style="width: 90%; padding: 6px;"></td>
		                                        <td style="width: 12%; padding: 6px;">1本あたり容量</td>
		                                        <td style="width: 22%;">
		                                            <select name="variants[0].litl" style="width: 95%; padding: 6px;">
		                                                <option value="250">250ml</option>
		                                                <option value="500" selected>500ml</option>
		                                                <option value="1000">1000ml</option>
		                                                <option value="2000">2000ml</option>
		                                            </select>
		                                        </td>
		                                    </tr>
		                                    <tr>
		                                        <td style="padding: 6px;">メイン画像</td>
		                                        <td><input type="file" name="variants[0].mainImageFile" style="padding: 6px;"></td>
		                                        <td style="padding: 6px;">在庫数</td>
		                                        <td><input type="number" name="variants[0].stock" value="0" style="width: 90%; padding: 6px;"></td>
		                                        <td style="padding: 6px;">表示順</td>
							                	<td><input type="number" name="variants[0].isMain" value="0" min="0" required style="width: 60px; padding: 6px;"></td>
							                </tr>
		                                </table>
		                            </div>
		                        </c:otherwise>
		                    </c:choose>
		                </div>
					
		                <div style="margin-top: 20px; text-align: right;">
		                    <c:if test="${isEdit}">
		                        <a href="${pageContext.request.contextPath}/admintop/main?mode=product" style="margin-right: 10px; color: #666;">キャンセル</a>
		                    </c:if>
		                    <button type="submit" style="padding: 10px 30px; background: #007bff; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer;">
		                        ${isEdit ? '変更を確定する' : 'この内容で一括登録・変更する'}
		                    </button>
		                </div>
		            </form>
					
		            <script>
					    // 初期インデックスをセット
					    let variantIndex = ${not empty productForm.variants ? productForm.variants.size() : 1};
					   
					    function addVariantRow() {
					        const container = document.getElementById('variant-container');
					        const newBox = document.createElement('div');
					        newBox.className = 'variant-box';
					        newBox.style = "background: #f1f3f5; padding: 15px; border-radius: 6px; margin-bottom: 15px; border-left: 5px solid #28a745;";
					       
					        // HTMLの構築
					        newBox.innerHTML =
					            '<table style="width: 100%; border-collapse: collapse;">' +
					            '    <tr>' +
					            '        <td style="width: 12%; padding: 6px;">種類 (単位)</td>' +
					            '        <td style="width: 21%;"><input type="text" name="variants[' + variantIndex + '].sizeOrColor" placeholder="例: 28本入り" required style="width: 90%; padding: 6px;"></td>' +
					            '        <td style="width: 12%; padding: 6px;">単価 (円)</td>' +
					            '        <td style="width: 21%;"><input type="number" name="variants[' + variantIndex + '].price" required style="width: 90%; padding: 6px;"></td>' +
					            '        <td style="width: 12%; padding: 6px;">1本あたり容量</td>' +
					            '        <td style="width: 22%;">' +
					            '            <select name="variants[' + variantIndex + '].litl" style="width: 95%; padding: 6px;">' +
					            '                <option value="250">250ml</option>' +
					            '                <option value="500" selected>500ml</option>' +
					            '                <option value="1000">1000ml</option>' +
					            '                <option value="2000">2000ml</option>' +
					            '            </select>' +
					            '        </td>' +
					            '    </tr>' +
					            '    <tr>' +
					            '        <td style="padding: 6px;">メイン画像</td>' +
					            '        <td><input type="file" name="variants[' + variantIndex + '].mainImageFile" style="padding: 6px;"></td>' +
					            '        <td style="padding: 6px;">初期在庫数</td>' +
					            '        <td><input type="number" name="variants[' + variantIndex + '].stock" value="0" style="width: 90%; padding: 6px;"></td>' +
					            '        <td style="padding: 6px;">表示順</td>' +
					            '        <td><input type="number" name="variants[' + variantIndex + '].isMain" value="0" min="0" required style="width: 60px; padding: 6px;"></td>' +
					            '    </tr>' +
					            '    <tr>' +
					            '        <td colspan="6" style="text-align: right; padding: 10px;">' +
					            '            <button type="button" onclick="removeVariantRow(this)" style="padding: 5px 12px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 11px;">削除</button>' +
					            '        </td>' +
					            '    </tr>' +
					            '</table>';
					       
					        container.appendChild(newBox);
					       
					        // インデックスをインクリメント
					        variantIndex++;
					    }
					   
					    function removeVariantRow(btn) {
					        // ボタンから親のdiv.variant-boxを探して削除
					        const box = btn.closest('.variant-box');
					        if (box) {
					            box.remove();
					        }
					    }
					</script>
		        </div>
			
		        <h3>📋 水の商品一覧</h3>
		        <table style="width: 100%; border-collapse: collapse; background: white; text-align: left; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 40px;">
		            <thead>
		                <tr style="background: #007bff; color: white;">
		                    <th style="padding: 10px; width: 25%;">商品名</th>
		                    <th style="padding: 10px; width: 15%;">水の種類</th>
		                    <th style="padding: 10px; width: 25%;">容量/単位（バリエーション切り替え）</th>
		                    <th style="padding: 10px; width: 12%;">単価</th>
		                    <th style="padding: 10px; width: 10%;">現在在庫</th>
		                    <th style="padding: 10px; text-align: center; width: 13%;">操作</th>
		                </tr>
		            </thead>
		            <tbody>
		                <%--
		                  💡【重要：検索順序に左右されない重複排除ロジック】
		                  描画済みのproductIdを一時変数（カンマ区切り文字列）に格納し、
		                  indexOf（fn:containsの代わり）を利用して完全な重複チェックを行います。
		                --%>
		                <c:set var="renderedIds" value="," />
		               
		                <c:forEach var="item" items="${productList}" varStatus="status">
		                   
		                    <%-- 今回のIDが「,ID,」という形で文字列に含まれているか確認 --%>
		                    <c:set var="currentIdPattern" value=",${item.productId}," />
		                   
		                    <%-- スクリプト変数やStringメソッドを応用して、含まれているかを判定 --%>
		                    <c:set var="isAlreadyRendered" value="false" />
		                    <c:if test="${renderedIds.indexOf(currentIdPattern) >= 0}">
		                        <c:set var="isAlreadyRendered" value="true" />
		                    </c:if>
		                   
		                    <%-- まだ未描画の商品IDの時だけ、新しく行（tr）を生成する（Amazon方式） --%>
		                    <c:if test="${!isAlreadyRendered}">
		                        <%-- 描画済みリストに現在のIDを追加 --%>
		                        <c:set var="renderedIds" value="${renderedIds}${item.productId}," />
		                       
		                        <tr style="border-bottom: 1px solid #eee; font-size: 11px;">
		                            <td style="padding: 10px; font-weight: bold;">${item.name}</td>
		                            <td style="padding: 10px;">${item.kinds} (${item.base})</td>
		                           
		                            <!-- 🔄 バリエーション選択ドロップダウン -->
		                            <td style="padding: 10px;">
		                                <select onchange="switchAmazonVariant(this, '${item.productId}')" style="padding: 4px 8px; border: 1px solid #007bff; border-radius: 3px; font-weight: bold; color: #007bff; background: #e6f2ff; cursor: pointer;">
		                                    <%--
		                                      全体のデータから、この商品IDに紐づくすべてのバリエーションを
		                                      検索順に関係なく正確にすべてオプション化します
		                                    --%>
		                                    <c:forEach var="subItem" items="${productList}">
		                                        <c:if test="${subItem.productId == item.productId}">
		                                            <option value="${subItem.variantId}"
		                                                    data-price="${subItem.price}"
		                                                    data-stock="${subItem.stock}">
		                                                ${subItem.litl}ml / ${subItem.sizeOrColor}
		                                            </option>
		                                        </c:if>
		                                    </c:forEach>
		                                </select>
		                            </td>
		                           
		                            <!-- 💰 価格表示エリア（JSで連動して切り替わる） -->
		                            <td style="padding: 10px; font-weight: bold; color: #d9534f;">
		                                <span id="price-display-${item.productId}">${item.price}</span>円
		                            </td>
		                           
		                            <!-- 📦 在庫表示エリア（JSで連動して切り替わる） -->
		                            <td style="padding: 10px;">
		                                <span id="stock-display-${item.productId}">${item.stock}</span> 個
		                            </td>
		                           
		                            <!-- 🛠️ 操作ボタンエリア（JSで遷移先 variantId が切り替わる） -->
		                            <td style="padding: 10px; text-align: center;">
		                                <a id="edit-btn-${item.productId}"
		                                   href="${pageContext.request.contextPath}/admin/product/edit?productId=${item.productId}&variantId=${item.variantId}"
		                                   style="padding: 5px 10px; background: #ffc107; color: #333; text-decoration: none; border-radius: 4px; margin-right: 2px; font-size: 10px; display: inline-block;">変更</a>
		                                <a href="${pageContext.request.contextPath}/admin/product/delete?productId=${item.productId}"
		                                   onclick="return confirm('本当にこの商品を削除しますか？\n（関連するバリエーションデータも全て削除されます）');"
		                                   style="padding: 5px 10px; background: #dc3545; color: white; text-decoration: none; border-radius: 4px; font-size: 10px; display: inline-block;">削除</a>
		                            </td>
		                        </tr>
		                    </c:if>
		                   
		                </c:forEach>
		               
		                <%-- 検索結果が完全に空だった場合のセーフティ表示 --%>
		                <c:if test="${empty productList}">
		                    <tr>
		                        <td colspan="6" style="padding: 20px; text-align: center; color: #888; font-style: italic;">
		                            🔍 該当する商品は見つかりませんでした。
		                        </td>
		                    </tr>
		                </c:if>
		            </tbody>
		        </table>
		        <%-- 💡 スクリプト群 --%>
		        <script>
		        function searchProduct() {
		            var inputName = document.getElementById("ajaxSearchName").value;
		            if(inputName) {
		                location.href = "${pageContext.request.contextPath}/admin/product/editOnSearch?name=" + encodeURIComponent(inputName);
		            } else {
		                // 空白の状態で検索した場合は全件表示に戻す
		                location.href = "${pageContext.request.contextPath}/admintop/main?mode=product";
		            }
		        }
		        function switchAmazonVariant(selectElem, productId) {
		            // 選択された option 要素を取得
		            const selectedOption = selectElem.options[selectElem.selectedIndex];
		           
		            // custom data 属性から価格と在庫を抽出
		            const price = selectedOption.getAttribute('data-price');
		            const stock = selectedOption.getAttribute('data-stock');
		            const variantId = selectedOption.value;
		           
		            // 画面の表示をリアルタイムに書き換え
		            document.getElementById('price-display-' + productId).innerText = price;
		            document.getElementById('stock-display-' + productId).innerText = stock;
		           
		            // 「変更」ボタンのリンク先（variantId）も選択されたものに追従させる
		            const editBtn = document.getElementById('edit-btn-' + productId);
		            const contextPath = "${pageContext.request.contextPath}";
		            editBtn.href = contextPath + "/admin/product/edit?productId=" + productId + "&variantId=" + variantId;
		        }
		        </script>
		    </c:when>
			<c:when test="${mode == 'orders'}">
				<style>
			        /* 注文管理コンテナ */
			        .order-container { background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #dee2e6; }
			        .order-container table { width: 100%; border-collapse: collapse; margin-top: 20px; }
			        .order-container thead tr { background-color: #17a2b8; color: white; }
			        .order-container th, .order-container td { padding: 12px; border-bottom: 1px solid #dee2e6; text-align: left; }
			        .order-container tbody tr:nth-child(even) { background-color: #f8f9fa; }
			        /* ボタンデザイン */
			        .btn-detail { background-color: #007bff; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
			        .btn-detail:hover { background-color: #0069d9; }
			    </style>
			    <div class="order-container" style="padding: 20px;">
			        <h2>📦 注文管理</h2>
			       
			        <!-- 修正後の検索フォーム -->
					<form action="${pageContext.request.contextPath}/admintop/orders" method="get">
					    <select name="status">
					        <option value="">すべての注文</option>
					        <!-- value を '注文完了' に変更 -->
					        <option value="注文完了" ${currentStatus == '注文完了' ? 'selected' : ''}>注文完了</option>
					        <option value="出荷準備中" ${currentStatus == '出荷準備中' ? 'selected' : ''}>出荷準備中</option>
					        <option value="出荷済み" ${currentStatus == '出荷済み' ? 'selected' : ''}>出荷済み</option>
					    </select>
					    <button type="submit">絞り込み</button>
					</form>
			
			        <table>
			            <thead>
				                <tr><th>ID</th><th>購入時間</th><th>商品名</th><th>個数</th><th>詳細</th><th>ステータス</th></tr>
			            </thead>
			            <tbody>
			                <c:forEach var="order" items="${orders}">
			                    <tr>
			                        <td>${order.id}</td>
			                        <td>${order.purchase_date}</td>
			                        <td>${order.product_name}</td>
			                        <td>${order.quantity}</td>
			                        <td><button class="btn-detail" data-id="${order.id}">詳細を見る</button></td>
			                        <!-- ステータスの列（table内のTDの中身を差し替えてください） -->
									<td>
									    <form action="${pageContext.request.contextPath}/admintop/orders/updateStatus" method="post" style="margin: 0; display: inline-block;">
									        <input type="hidden" name="orderId" value="${order.id}">
									       
									        <select name="status" onchange="this.form.submit()" style="padding: 5px 8px; border-radius: 4px; font-weight: bold; cursor: pointer;
											    /* '注文完了' の場合の色（例：赤）を追加し、条件を整理しました */
											    background-color: ${order.status == '注文完了' ? '#dc3545' : order.status == '出荷準備中' ? '#ffc107' : order.status == '出荷済み' ? '#28a745' : '#ccc'};
											    color: white;
											    border: none;">
											   
											    <option value="注文完了" ${order.status == '注文完了' ? 'selected' : ''}>🔴 注文完了</option>
											    <option value="出荷準備中" ${order.status == '出荷準備中' ? 'selected' : ''}>🟡 出荷準備中</option>
											    <option value="出荷済み" ${order.status == '出荷済み' ? 'selected' : ''}>🟢 出荷済み</option>
											</select>
									    </form>
									</td>
			                    </tr>
			                </c:forEach>
			            </tbody>
			        </table>
			    </div>
			
			    <div id="detailModal" style="display: none; position: fixed; z-index: 9999; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); align-items: center; justify-content: center;">
				    <div style="background: white; width: 600px; max-width: 90%; padding: 25px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); position: relative;">
				        <h3 style="margin-top: 0; padding-bottom: 10px; border-bottom: 2px solid #17a2b8;">📦 注文詳細内容</h3>
				       
				        <div style="margin-top: 15px; font-size: 13px; line-height: 1.6;">
				            <p><strong>［氏名］</strong> <span id="modalName"></span></p>
				            <p><strong>［郵便番号］</strong> <span id="modalZip"></span></p>
				            <p><strong>［住所］</strong> <span id="modalAddress"></span></p>
				            <p><strong>［注文日時］</strong> <span id="modalDate"></span></p>
				            <hr style="border: 0; border-top: 1px solid #eee; margin: 15px 0;">
							<p><strong>［購入情報］</strong> <span id="modalTotal"></span></p>
				            <div id="modalItems" style="background: #f8f9fa; padding: 15px; border-radius: 6px; border: 1px solid #e9ecef; max-height: 200px; overflow-y: auto;"></div>
				        </div>
				
				        <div style="margin-top: 25px; text-align: right;">
				            <button type="button" onclick="closeDetailModal()" style="background: #6c757d; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: bold;">
				                閉じる
				            </button>
				        </div>
				    </div>
				</div>
			
			    <script>
				    // ボタンクリック時の詳細取得処理
				    document.querySelectorAll('.btn-detail').forEach(button => {
				        button.addEventListener('click', function() {
				            const orderId = this.getAttribute('data-id');
				           
				            fetch('${pageContext.request.contextPath}/admintop/orders/api/detail/' + orderId)
				                .then(response => response.json())
				                .then(data => {
				                    const o = data.order;
				                    const items = data.items;
				                   
				                    // 商品リストをHTML文字列として生成
				                    const itemsHtml = items.map(i => {
				                        return "<div>" + i.product_name + " - " + i.quantity + "個 / " + i.sum_price.toLocaleString() + "円</div>";
				                    }).join('');
				                   
				                    // モーダルへ流し込み
				                    openOrderModal(
				                        o.last_name + ' ' + o.first_name,
				                        o.postal_code,
				                        o.prefecture + o.address1 + o.address2,
				                        o.purchase_date,
				                        itemsHtml,
				                        items.reduce((sum, i) => sum + i.sum_price, 0)
				                    );
				                })
				                .catch(error => console.error("通信エラー:", error));
				        });
				    });
				   
				    // モーダルを開く関数
				    function openOrderModal(name, zip, address, date, itemsHtml, total) {
				        document.getElementById('modalName').innerText = name;
				        document.getElementById('modalZip').innerText = zip;
				        document.getElementById('modalAddress').innerText = address;
				        document.getElementById('modalDate').innerText = date;
				        document.getElementById('modalItems').innerHTML = itemsHtml;
				        document.getElementById('modalTotal').innerText = "合計: " + total.toLocaleString() + "円";
				        document.getElementById('detailModal').style.display = 'flex';
				    }
				   
				    // モーダルを閉じる関数
				    function closeDetailModal() {
				        document.getElementById('detailModal').style.display = 'none';
				    }
	
				    // 背景クリックで閉じる処理
				    document.getElementById('detailModal').addEventListener('click', function(event) {
				        if (event.target === this) {
				            closeDetailModal();
				        }
				    });
				   
				</script>
			</c:when>
			<c:when test="${mode == 'campaign'}">
			    <h2>✨ キャンペーン管理</h2>
			
			    <div style="padding:20px; border:1px solid #ccc; background:#f9f9f9; margin-bottom:20px; border-radius:5px;">
			        <h3>${editCampaign != null ? 'キャンペーン編集' : '新規キャンペーン登録'}</h3>
			        <form action="campaign/save" method="post" enctype="multipart/form-data">
			            <input type="hidden" name="id" value="${editCampaign != null ? editCampaign.id : 0}">
			            <input type="hidden" name="imageUrl" value="${editCampaign.imageUrl}">
			           
			            <div style="margin-bottom:10px;">
			                <label>タイトル:</label><br>
			                <input type="text" name="title" value="${editCampaign.title}" required style="width:100%; max-width:400px; padding:5px;">
			            </div>
			
			            <div style="margin-bottom:10px;">
			                <c:if test="${not empty editCampaign.imageUrl}">
						    <p>現在の画像:<br>
						    <img src="${pageContext.request.contextPath}${editCampaign.imageUrl}" width="150" style="border:1px solid #ddd;"></p>
						</c:if>
			                <label>画像ファイル:</label><br>
			                <input type="file" name="imageFile">
			            </div>
			
			            <div style="margin-bottom:10px;">
			                <label>URL:</label><br>
			                <input type="text" name="linkUrl" value="${editCampaign.linkUrl}" style="width:100%; max-width:400px; padding:5px;">
			            </div>
			
			            <div style="display:flex; gap:20px; margin-bottom:10px;">
			                <div>
			                    <label>開始日時:</label><br>
			                    <input type="datetime-local" name="startAt" value="${editCampaign != null ? editCampaign.startAt.toString().substring(0, 16) : ''}" style="padding:5px;">
			                </div>
			                <div>
			                    <label>終了日時:</label><br>
			                    <input type="datetime-local" name="endAt" value="${editCampaign != null ? editCampaign.endAt.toString().substring(0, 16) : ''}" style="padding:5px;">
			                </div>
			                <div>
			                    <label>表示順:</label><br>
			                    <input type="number" name="sortOrder" value="${editCampaign != null ? editCampaign.sortOrder : 0}" style="width:60px; padding:5px;">
			                </div>
			            </div>
			
			            <button type="submit" style="padding:8px 20px; cursor:pointer;">${editCampaign != null ? '変更する' : '登録する'}</button>
			            <c:if test="${editCampaign != null}">
			                <a href="/admintop/campaign" style="margin-left:10px; color:#666; text-decoration:none; padding:8px 20px; border:1px solid #ccc; background:#eee; border-radius:3px;">キャンセル</a>
			            </c:if>
			        </form>
			    </div>
			
			    <table border="1" style="width:100%; border-collapse:collapse; margin-top:20px; background:#fff;">
			        <tr style="background:#00a0ac; color:white;">
			            <th style="padding:10px;">ID</th><th>表示順</th><th>タイトル</th><th>画像</th><th style="padding:10px;">操作</th>
			        </tr>
			       
			        <c:forEach var="c" items="${campaignList}">
			            <c:set var="isExpired" value="${c.endAt != null && now.isAfter(c.endAt)}" />
			            <c:set var="isNotStarted" value="${c.startAt != null && now.isBefore(c.startAt)}" />
			           
			            <tr style="background-color: ${isExpired ? '#e0e0e0' : (isNotStarted ? '#ffffcc' : 'white')}; text-align:center;">
			                <td style="padding:8px;">${c.id}</td>
			                <td style="padding:8px;">${c.sortOrder}</td>
			                <td style="text-align:left; padding:8px;">${c.title}</td>
			                <td style="padding:8px;">
						    <c:if test="${not empty c.imageUrl}"><img src="${pageContext.request.contextPath}${c.imageUrl}" width="50"></c:if></td>
			               
			                <td style="padding:8px;">
			                    <a href="?editId=${c.id}" style="margin-right:10px;">編集</a>
			                    <form action="campaign/delete" method="post" style="display:inline;">
			                        <input type="hidden" name="id" value="${c.id}">
			                        <button type="submit" onclick="return confirm('削除しますか？')">削除</button>
			                    </form>
			                   
			                    <form action="campaign/swap" method="post" style="display:inline; margin-left:10px;">
			                        <input type="hidden" name="id1" value="${c.id}">
			                        <c:if test="${!isExpired}">
			                            <button type="submit" name="direction" value="up">↑</button>
			                            <button type="submit" name="direction" value="down">↓</button>
			                        </c:if>
			                        <c:if test="${isExpired}">
			                            <span style="font-size:0.8em; color:#999;">終了済み</span>
			                        </c:if>
			                    </form>
			                </td>
			            </tr>
			        </c:forEach>
			    </table>
			</c:when>
          
           <c:when test="${mode == 'news'}">
				<div class="news-container" style="padding: 20px;">
			    	<h2 style="margin-bottom: 20px;">📰ニュース管理</h2>
			
			    	<div class="news-form" style="margin-bottom: 30px; padding: 20px; background-color: #fff; border: 1px solid #eee; border-radius: 5px;">
			        	<h3 style="margin-top: 0; margin-bottom: 15px;">${editNews != null ? 'ニュース編集' : '新規ニュース追加'}</h3>
			        	<form action="${pageContext.request.contextPath}/admintop/news/save" method="post">
			          	  <input type="hidden" name="id" value="${editNews.id}">
			             
			          	  <div style="margin-bottom: 15px;">
			                  <label style="display: block; font-weight: bold; margin-bottom: 5px;">タイトル</label>
			                  <input type="text" name="title" value="${editNews.title}" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
			              </div>
			             
			              <div style="margin-bottom: 15px;">
			                  <label style="display: block; font-weight: bold; margin-bottom: 5px;">内容</label>
			                  <textarea name="content" required style="width: 100%; height: 100px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">${editNews.content}</textarea>
			              </div>
			             
			              <button type="submit" style="padding: 8px 20px; background-color: #007bff; color: #fff; border: none; border-radius: 4px; cursor: pointer;">
			                  ${editNews != null ? '更新する' : '登録する'}
			              </button>
			              <c:if test="${editNews != null}">
			                  <a href="${pageContext.request.contextPath}/admintop/news" style="margin-left: 10px; color: #666; text-decoration: none;">キャンセル</a>
			              </c:if>
			          </form>
			      </div>
			
			      <h3>ニュース一覧</h3>
			      <table style="width: 100%; border-collapse: collapse; background-color: #fff; margin-top: 10px;">
			          <thead style="background-color: #17a2b8; color: #fff;"> <tr>
			                  <th style="padding: 12px; text-align: left; border: 1px solid #e9ecef;">ID</th>
			                  <th style="padding: 12px; text-align: left; border: 1px solid #e9ecef;">タイトル</th>
			                  <th style="padding: 12px; text-align: left; border: 1px solid #e9ecef;">投稿日時</th>
			                  <th style="padding: 12px; text-align: center; border: 1px solid #e9ecef;">操作</th>
			              </tr>
			          </thead>
			          <tbody>
			              <c:forEach var="news" items="${newsList}">
			                  <tr style="border-bottom: 1px solid #e9ecef;">
			                      <td style="padding: 12px; border: 1px solid #e9ecef;">${news.id}</td>
			                      <td style="padding: 12px; border: 1px solid #e9ecef;">${news.title}</td>
			                      <td style="padding: 12px; border: 1px solid #e9ecef;">${news.publishedAt}</td>
			                      <td style="padding: 12px; text-align: center; border: 1px solid #e9ecef;">
			                          <a href="${pageContext.request.contextPath}/admintop/news?editId=${news.id}"
			                             style="display: inline-block; padding: 5px 12px; background-color: #007bff; color: #fff; border-radius: 4px; text-decoration: none; font-size: 14px; margin-right: 5px;">編集</a>
			                         
			                          <form action="${pageContext.request.contextPath}/admintop/news/delete" method="post" style="display:inline;">
			                              <input type="hidden" name="id" value="${news.id}">
			                              <button type="submit" onclick="return confirm('本当に削除しますか？');"
			                                      style="padding: 5px 12px; background-color: #dc3545; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px;">削除</button>
			                          </form>
			                      </td>
			                  </tr>
			              </c:forEach>
			          </tbody>
			      </table>
			  </div>
			</c:when>
			<c:when test="${mode == 'inquiry'}">
			    <h2>📩 お問い合わせ管理</h2>
			    <hr>
			
			    <!-- 完了メッセージの表示エリア -->
			    <c:if test="${not empty message}">
			        <div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #c3e6cb; font-weight: bold;">
			            ✅ ${message}
			        </div>
			    </c:if>
			
			    <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 40px;">
			        <h3>📋 受信お問合せ一覧</h3>
			       
			        <table style="width: 100%; border-collapse: collapse; text-align: left; margin-top: 15px; font-size: 12px;">
			            <thead>
			                <tr style="background: #17a2b8; color: white;">
			                    <th style="padding: 12px; width: 12%;">受信日時</th>
			                    <th style="padding: 12px; width: 12%;">分類</th>
			                    <th style="padding: 12px; width: 18%;">メールアドレス</th>
			                    <th style="padding: 12px; width: 25%;">お問い合わせ内容（抜粋）</th>
			                    <th style="padding: 12px; width: 15%; text-align: center;">詳細</th>
			                    <th style="padding: 12px; width: 16%; text-align: center;">対応ステータス</th>
			                </tr>
			            </thead>
			            <tbody>
			                <c:forEach var="inq" items="${inquiryList}">
			                    <tr style="border-bottom: 1px solid #eee; background: ${inq.status == '未対応' ? '#fff9f9' : 'white'}">
			                       
			                        <!-- 1. 受信日時 -->
			                        <td style="padding: 12px; color: #666;">${inq.createdAt}</td>
			                       
			                        <!-- 2. 問い合わせ分類 -->
			                        <td style="padding: 12px;">
			                            <span style="background: #e9ecef; padding: 3px 8px; border-radius: 4px; font-weight: bold; color: #495057;">
			                                ${inq.type}
			                            </span>
			                        </td>
			                       
			                        <!-- 3. メールアドレス -->
			                        <td style="padding: 12px;">
			                            <a href="mailto:${inq.email}" style="color: #007bff; text-decoration: none;">${inq.email}</a>
			                        </td>
			                       
			                        <!-- 4. お問い合わせ内容（抜粋） -->
			                        <td style="padding: 12px; color: #333; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
			                            ${inq.message}
			                        </td>
			                       
			                        <!-- 5. 詳細を見るボタン -->
			                        <td style="padding: 12px; text-align: center;">
			                            <button type="button"
			                                    onclick="openDetailModal('${inq.createdAt}', '${inq.type}', '${inq.email}', `${inq.message}`, '${inq.imageUrl}')"
			                                    style="background: #007bff; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold;">
			                                🔍 詳細を見る
			                            </button>
			                        </td>
			                       
			                        <!-- 6. 対応ステータス -->
			                        <td style="padding: 12px; text-align: center;">
			                            <form action="${pageContext.request.contextPath}/admin/inquiry/updateStatus" method="post" style="margin: 0; display: inline-block;">
			                                <input type="hidden" name="inquiryId" value="${inq.id}">
			                               
			                                <select name="status" onchange="this.form.submit()" style="padding: 5px 8px; border-radius: 4px; font-weight: bold; cursor: pointer;
			                                    background-color: ${inq.status == '未対応' ? '#dc3545' : inq.status == '対応中' ? '#ffc107' : '#28a745'};
			                                    color: ${inq.status == '対応中' ? '#333' : 'white'};
			                                    border: none;">
			                                    <option value="未対応" ${inq.status == '未対応' ? 'selected' : ''}>🔴 未対応</option>
			                                    <option value="対応中" ${inq.status == '対応中' ? 'selected' : ''}>🟡 対応中</option>
			                                    <option value="対応済み" ${inq.status == '対応済み' ? 'selected' : ''}>🟢 対応済み</option>
			                                </select>
			                            </form>
			                        </td>
			                    </tr>
			                </c:forEach>
			               
			                <c:if test="${empty inquiryList}">
			                    <tr>
			                        <td colspan="6" style="padding: 30px; text-align: center; color: #888; font-style: italic;">
			                            📩 まだお問い合わせは届いていません。
			                        </td>
			                    </tr>
			                </c:if>
			            </tbody>
			        </table>
			       
			        <!-- 💡 ページネーション（var属性を除去して確実に表示されるよう修正） -->
			        <c:if test="${totalPages > 1}">
			            <div style="display: flex; justify-content: center; align-items: center; margin-top: 30px; gap: 15px; font-size: 14px;">
			               
			                <!-- 「前へ」ボタン -->
			                <c:choose>
			                    <c:when test="${currentPage > 1}">
			                        <a href="${pageContext.request.contextPath}/admintop/main?mode=inquiry&page=${currentPage - 1}"
			                           style="padding: 6px 12px; background: #17a2b8; color: white; text-decoration: none; border-radius: 4px; font-weight: bold;">
			                           ◀ 前の20件
			                        </a>
			                    </c:when>
			                    <c:otherwise>
			                        <span style="padding: 6px 12px; background: #e9ecef; color: #6c757d; border-radius: 4px; cursor: not-allowed;">
			                           ◀ 前の20件
			                        </span>
			                    </c:otherwise>
			                </c:choose>
					
			                <!-- ページ位置表示 -->
			                <span style="font-weight: bold; color: #495057;">
			                    ${currentPage} / ${totalPages} ページ（全 ${totalCount} 件）
			                </span>
					
			                <!-- 「次へ」ボタン -->
			                <c:choose>
			                    <c:when test="${currentPage < totalPages}">
			                        <a href="${pageContext.request.contextPath}/admintop/main?mode=inquiry&page=${currentPage + 1}"
			                           style="padding: 6px 12px; background: #17a2b8; color: white; text-decoration: none; border-radius: 4px; font-weight: bold;">
			                           次の20件 ▶
			                        </a>
			                    </c:when>
			                    <c:otherwise>
			                        <span style="padding: 6px 12px; background: #e9ecef; color: #6c757d; border-radius: 4px; cursor: not-allowed;">
			                           次の20件 ▶
			                        </span>
			                    </c:otherwise>
			                </c:choose>
			               
			            </div>
			        </c:if>
			    </div>
			
			    <%-- ======================================================= --%>
			    <%-- 📄 画面中央に大きく表示される「詳細表示モーダル」 --%>
			    <%-- ======================================================= --%>
			    <div id="detailModal" style="display: none; position: fixed; z-index: 9999; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); align-items: center; justify-content: center;">
			        <div style="background: white; width: 600px; max-width: 90%; padding: 25px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); position: relative;">
			           
			            <h3 style="margin-top: 0; padding-bottom: 10px; border-bottom: 2px solid #17a2b8;">📄 お問い合わせ詳細内容</h3>
			           
			            <div style="margin-top: 15px; font-size: 13px; line-height: 1.6;">
			                <p><strong>［受信日時］</strong> <span id="modalDate"></span></p>
			                <p><strong>［分 類］</strong> <span id="modalType" style="background: #e9ecef; padding: 2px 6px; border-radius: 4px; font-weight: bold;"></span></p>
			                <p><strong>［メール］</strong> <span id="modalEmail"></span></p>
			                <hr style="border: 0; border-top: 1px solid #eee; margin: 15px 0;">
			                <p><strong>［本 文］</strong></p>
			                <div id="modalMessage" style="background: #f8f9fa; padding: 15px; border-radius: 6px; border: 1px solid #e9ecef; white-space: pre-wrap; max-height: 200px; overflow-y: auto; font-size: 14px;"></div>
			               
			                <!-- 添付画像エリア -->
			                <div id="modalImgWrapper" style="margin-top: 15px; display: none;">
			                    <p><strong>［添付画像］</strong></p>
			                    <img id="modalImg" src="" style="max-width: 100%; max-height: 200px; object-fit: contain; border: 1px solid #ddd; border-radius: 6px;">
			                </div>
			            </div>
						
			            <!-- 閉じるボタン -->
			            <div style="margin-top: 25px; text-align: right;">
			                <button type="button" onclick="closeDetailModal()" style="background: #6c757d; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: bold;">
			                    閉じる
			                </button>
			            </div>
			        </div>
			    </div>
						
			    <%-- 💡 モーダル制御用のJavaScript --%>
			    <script>
			        function openDetailModal(date, type, email, message, imageUrl) {
			            document.getElementById('modalDate').innerText = date;
			            document.getElementById('modalType').innerText = type;
			            document.getElementById('modalEmail').innerText = email;
			            document.getElementById('modalMessage').innerText = message;
			           
			            const imgWrapper = document.getElementById('modalImgWrapper');
			            const imgTag = document.getElementById('modalImg');
			            if (imageUrl && imageUrl !== 'null' && imageUrl !== '') {
			                imgTag.src = "${pageContext.request.contextPath}" + imageUrl;
			                imgWrapper.style.display = 'block';
			            } else {
			                imgWrapper.style.display = 'none';
			            }
			           
			            document.getElementById('detailModal').style.display = 'flex';
			        }
						
			        function closeDetailModal() {
			            document.getElementById('detailModal').style.display = 'none';
			        }
			    </script>
			</c:when>
       </c:choose>
   </div>
</div>
</body>
</html>

