from django.db import models

class CampaignBanners(models.Model):
    title = models.CharField(max_length=255)
    image_url = models.CharField(max_length=255)
    link_url = models.CharField(max_length=255, blank=True, null=True)
    start_at = models.DateTimeField()
    end_at = models.DateTimeField()
    sort_order = models.IntegerField()
    class Meta:
        
        db_table = 'campaign_banners'

class Delivery(models.Model):
    last_name = models.CharField(max_length=255)
    first_name = models.CharField(max_length=255)
    last_name_kana = models.CharField(max_length=255)
    first_name_kana = models.CharField(max_length=255)
    postal_code = models.CharField(max_length=7)
    prefecture = models.CharField(max_length=50)
    address1 = models.CharField(max_length=255)
    address2 = models.CharField(max_length=255, blank=True, null=True)
    class Meta:
        
        db_table = 'delivery'

class Inquiries(models.Model):
    type = models.CharField(max_length=255)
    email = models.CharField(max_length=255)
    message = models.TextField()
    image_url = models.CharField(max_length=255, blank=True, null=True)
    status = models.CharField(max_length=20)
    created_at = models.DateTimeField()
    class Meta:
        
        db_table = 'inquiries'

class News(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    published_at = models.DateTimeField()
    class Meta:
        
        db_table = 'news'

class OrderDetails(models.Model):
    order = models.ForeignKey('Orders', models.DO_NOTHING)
    variant = models.ForeignKey('ProductVariants', models.DO_NOTHING)
    desired = models.DateTimeField(blank=True, null=True)
    quantity = models.IntegerField()
    price = models.IntegerField()
    sum_price = models.IntegerField()
    class Meta:
        
        db_table = 'order_details'

class Orders(models.Model):
    user = models.ForeignKey('Users', models.DO_NOTHING)
    order_date = models.DateTimeField()
    status = models.CharField(max_length=20)
    delivery = models.ForeignKey(Delivery, models.DO_NOTHING)
    class Meta:
        
        db_table = 'orders'

class ProductImages(models.Model):
    product = models.ForeignKey('Products', models.DO_NOTHING)
    image_url = models.CharField(max_length=255)
    sort_order = models.IntegerField()
    class Meta:
        
        db_table = 'product_images'

class ProductVariants(models.Model):
    product = models.ForeignKey('Products', models.DO_NOTHING)
    size_or_color = models.CharField(max_length=100)
    price = models.IntegerField()
    variant_image_url = models.CharField(max_length=255, blank=True, null=True)
    is_main = models.IntegerField()
    stock = models.IntegerField()
    litl = models.IntegerField(blank=True, null=True)
    class Meta:
        
        db_table = 'product_variants'

class Products(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    hard = models.CharField(max_length=255, blank=True, null=True)
    ken = models.CharField(max_length=255, blank=True, null=True)
    kinds = models.CharField(max_length=255, blank=True, null=True)
    base = models.CharField(max_length=255, blank=True, null=True)
    is_recommended = models.IntegerField(blank=True, null=True)
    rank = models.IntegerField(blank=True, null=True)
    class Meta:
        
        db_table = 'products'

class StockHistories(models.Model):
    variant = models.ForeignKey(ProductVariants, models.DO_NOTHING)
    type = models.CharField(max_length=10)
    quantity = models.IntegerField()
    order = models.ForeignKey(Orders, models.DO_NOTHING, blank=True, null=True)
    processed_at = models.DateTimeField()
    class Meta:
        
        db_table = 'stock_histories'

class Users(models.Model):
    last_name = models.CharField(max_length=255)
    first_name = models.CharField(max_length=255)
    last_name_kana = models.CharField(max_length=255)
    first_name_kana = models.CharField(max_length=255)
    email = models.CharField(unique=True, max_length=255)
    password = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=20)
    postal_code = models.CharField(max_length=7)
    prefecture = models.CharField(max_length=50)
    address1 = models.CharField(max_length=255)
    address2 = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    class Meta:
        
        db_table = 'users'