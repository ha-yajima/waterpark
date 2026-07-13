#Pythonのviews.pyを入れ替えてください

from django.http import JsonResponse
from .services import ProductRecommendationService
from .models import ProductVariants




def get_limit(request, default=5):
    """
    URLパラメータ ?limit=20 のように指定された件数を取得する。
    指定がなければ default 件にする。
    """
    try:
        limit = int(request.GET.get("limit", default))


        # 念のため、変な件数を防ぐ
        if limit <= 0:
            return default


        return limit


    except (TypeError, ValueError):
        return default




def recommendation_list(request):
    """ランキング商品をJSONで返す窓口"""


    limit = get_limit(request)


    ranked_products = ProductRecommendationService.calculate_recommendations(
        limit=limit
    )


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


    return JsonResponse(
        {"recommendations": data},
        json_dumps_params={'ensure_ascii': False}
    )




def recommend_products(request):
    """おすすめ商品（トレンド重視）をJSONで返す窓口"""


    limit = get_limit(request)


    recommended = ProductRecommendationService.calculate_recommendations_v2(
        limit=limit
    )


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


    return JsonResponse(
        {"recommendations": data},
        json_dumps_params={'ensure_ascii': False}
    )




def new_products(request):
    """新着商品をJSONで返す窓口"""


    limit = get_limit(request)


    arrivals = ProductRecommendationService.get_new_arrivals(
        limit=limit
    )


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


    return JsonResponse(
        {"new_arrivals": data},
        json_dumps_params={'ensure_ascii': False}
    )




def related_products(request):
    """
    関連商品をJSONで返す窓口
    URLパラメータで ?id=XX を受け取る想定
    """
    product_id = request.GET.get('id')
    if not product_id:
        return JsonResponse({"error": "ID is required"}, status=400)


    related = ProductRecommendationService.get_related_products(product_id)


    return JsonResponse(
        {"relatedProducts": related},
        json_dumps_params={'ensure_ascii': False}
    )



