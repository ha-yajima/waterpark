from django.urls import path
from . import views

urlpatterns = [
    path('recommendations/', views.recommendation_list, name='recommendation_list'),
    path('recommendations/featured/', views.recommend_products, name='recommend_products'),
    path('recommendations/new/', views.new_products, name='new_products'),
    path('api/related_products', views.related_products, name='related_products'),
]