from datetime import date
from django.db.models import Max, Min, Sum
from .models import Products # クラス名「Products」に合わせる
from django.db import models








class ProductRecommendationService:
    @staticmethod
    def calculate_recommendations(limit=10):
        """
        product_variants のデータを集計し、
        独自の計算ロジックによりおすすめ商品とランキングを動的に算出する
        """
        today = date.today()
       
        # すべての商品を取得
        products = Products.objects.all()
       
        scored_products = []
       
        for product in products:
            # 逆参照名「productvariants_set」を使用して紐づくバリアント群を取得
            variants = product.productvariants_set.all()
           
            if not variants.exists():
                continue
               
            # バリアントから計算に必要な指標（最安値、最大容量、在庫数の合計）を抽出
            min_price = variants.aggregate(Min('price'))['price__min'] or 0
            max_volume = variants.aggregate(Max('litl'))['litl__max'] or 0  # 容量フィールド「litl」に対応
            total_stock = variants.aggregate(Sum('stock'))['stock__sum'] or 0
           
            # 1. コスパ計算 (最大容量 / 最安値) ※ゼロ除算防止
            cost_performance = 0.0
            if min_price > 0:
                cost_performance = float(max_volume) / float(min_price)
           
            # 2. 新着度計算 (30日以内を優遇、created_atがDateTimeFieldなのでdate型に変換)
            days_since_creation = 999
            if product.created_at:
                days_since_creation = (today - product.created_at.date()).days
            freshness_score = max(0, (30 - days_since_creation)) / 30.0
           
            # 3. 在庫僅少（売れ筋シミュレーション）スコア
            # 全バリアントの合計在庫が 1〜15個の間に収まっているものを加点
            scarcity_score = 1.0 if 0 < total_stock <= 15 else 0.0
           
            # 総合スコアの算出（重み付け）
            total_score = (cost_performance * 1000 * 0.4) + (freshness_score * 10 * 0.3) + (scarcity_score * 5 * 0.3)
           
            scored_products.append({
                'product': product,
                'total_score': total_score,
                'cost_performance': cost_performance,
                'min_price': min_price,
                'is_new': days_since_creation <= 7
            })
       
        # スコア順にソートして上限数で切り出し
        scored_products.sort(key=lambda x: x['total_score'], reverse=True)
        return scored_products[:limit]
   
    @classmethod
    def calculate_recommendations_v2(cls, limit=5):
        """
        おすすめ商品用ロジック：トレンド・注目度重視（新着度 × 在庫数）
        """
        from .models import Products, ProductVariants
        from django.utils import timezone
        import math








        products = Products.objects.all()
        ranked_list = []
        now = timezone.now()








        for prod in products:
            # 1. この商品に紐づくバリアント（容量違いなど）を取得
            variants = ProductVariants.objects.filter(product=prod)
            if not variants.exists():
                continue








            # 最安値と総在庫数を集計
            min_price = min(v.price for v in variants)
            total_stock = sum(v.stock for v in variants)








            # 在庫が0のものはおすすめから除外
            if total_stock <= 0:
                continue








            # 2. 新着度のスコア化（登録が新しいほど高得点、最大100点）
            days_old = (now - prod.created_at).days
            # 30日以内を新着として評価
            newness_score = max(0, 100 - (days_old * 3.3))








            # 3. 在庫のゆとり度をスコア化（在庫が多いほど安定供給できるため高得点、最大100点）
            # 大量在庫でスコアが跳ね上がりすぎないよう、対数（log）で緩やかに評価
            stock_score = min(100, math.log1p(total_stock) * 15)








            # 4. 総合スコアの計算（新着度と在庫ゆとり度の掛け合わせ）
            # 新着度が0でも在庫があれば選ばれるよう、ベース点（人気度などの代わり）を付与
            base_score = 50
            total_score = base_score + (newness_score * 0.5) + (stock_score * 0.5)








            # 新着かどうかのフラグ（JSPでのバッジ表示などに利用可能）
            is_new = days_old <= 30








            ranked_list.append({
                'product': prod,
                'total_score': total_score,
                'min_price': min_price,
                'is_new': is_new
            })








            # スコアが高い順にソートして指定件数（5件）を返す
            ranked_list.sort(key=lambda x: x['total_score'], reverse=True)








        return ranked_list[:limit]
   
    @classmethod
    def get_new_arrivals(cls, limit=5):
        """
        新着商品用ロジック：純粋に商品の登録日（created_at）が新しい順
        """
        from .models import Products, ProductVariants








        # created_at の降順（新しい順）で商品を取得
        products = Products.objects.all().order_by('-created_at')
        new_arrivals_list = []








        for prod in products:
            variants = ProductVariants.objects.filter(product=prod)
            if not variants.exists():
                continue








            # 最安値を取得
            min_price = min(v.price for v in variants)








            new_arrivals_list.append({
                'product': prod,
                'min_price': min_price,
                'is_new': True # 新着枠なので固定でTrue
            })








            if len(new_arrivals_list) >= limit:
                break








        return new_arrivals_list
   
    @classmethod
    def get_related_products(cls, current_product_id, limit=4):
        """
        指定した商品の「産地」または「種類」が同じ商品を取得する
        """
        from .models import Products, ProductVariants  # 💡 ProductImages → ProductVariants に変更
        current_prod = Products.objects.filter(id=current_product_id).first()
        if not current_prod:
            return []

        related = Products.objects.filter(
            (models.Q(ken=current_prod.ken) | models.Q(kinds=current_prod.kinds)) &
            ~models.Q(id=current_product_id)
        ).distinct()[:limit]

        results = []
        for prod in related:
            # メイン画像
            main_variant = ProductVariants.objects.filter(
                product=prod,
                is_main=0
            ).first()


            # 最安値
            min_price = ProductVariants.objects.filter(
                product=prod
            ).aggregate(Min('price'))['price__min']


            results.append({
                'id': prod.id,
                'name': prod.name,
                'image_url': main_variant.variant_image_url if main_variant else "",
                'price': min_price
            })




        return results
#④Pythonの「views.py 」を入れ替え
from django.http import JsonResponse
from .services import ProductRecommendationService
from .models import ProductVariants








def recommendation_list(request):
    ranked_products = ProductRecommendationService.calculate_recommendations(limit=5)




    data = []
    for item in ranked_products:
        # 商品代表画像は is_main=0 のバリエーションから取得
        main_variant = ProductVariants.objects.filter(
            product=item['product'],
            is_main=0
        ).first()




        image_url = main_variant.variant_image_url if main_variant else ""




        data.append({
            "product_id": item['product'].id,
            "name": item['product'].name,
            "total_score": round(item['total_score'], 2),
            "price": item['min_price'],
            "image_url": image_url,
            "is_new": item['is_new']
        })




    return JsonResponse({"recommendations": data}, json_dumps_params={'ensure_ascii': False})








def recommend_products(request):
    """おすすめ商品（トレンド重視）をJSONで返す窓口"""
    recommended = ProductRecommendationService.calculate_recommendations_v2(limit=5)




    data = []
    for item in recommended:
        # 商品代表画像は is_main=0 のバリエーションから取得
        main_variant = ProductVariants.objects.filter(
            product=item['product'],
            is_main=0
        ).first()




        image_url = main_variant.variant_image_url if main_variant else ""




        data.append({
            "product_id": item['product'].id,
            "name": item['product'].name,
            "total_score": round(item['total_score'], 2),
            "price": item['min_price'],
            "image_url": image_url,
            "is_new": item['is_new']
        })




    return JsonResponse({"recommendations": data}, json_dumps_params={'ensure_ascii': False})








def new_products(request):
    """新着商品をJSONで返す窓口"""
    arrivals = ProductRecommendationService.get_new_arrivals(limit=5)




    data = []
    for item in arrivals:
        # 商品代表画像は is_main=0 のバリエーションから取得
        main_variant = ProductVariants.objects.filter(
            product=item['product'],
            is_main=0
        ).first()




        image_url = main_variant.variant_image_url if main_variant else ""




        data.append({
            "product_id": item['product'].id,
            "name": item['product'].name,
            "price": item['min_price'],
            "image_url": image_url,
            "is_new": item['is_new']
        })




    return JsonResponse({"new_arrivals": data}, json_dumps_params={'ensure_ascii': False})








def related_products(request):
    """
    関連商品をJSONで返す窓口
    URLパラメータで ?id=XX を受け取る想定
    """
    product_id = request.GET.get('id')
    if not product_id:
        return JsonResponse({"error": "ID is required"}, status=400)




    related = ProductRecommendationService.get_related_products(product_id)




    return JsonResponse({"relatedProducts": related}, json_dumps_params={'ensure_ascii': False})



