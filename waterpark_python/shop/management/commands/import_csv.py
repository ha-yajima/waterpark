"""
CSVファイルから Products / ProductImages / ProductVariants を取り込む管理コマンド。

使い方:
    python manage.py import_csv
    python manage.py import_csv --dir "C:\\path\\to\\csv_data"

デフォルトでは BASE_DIR/csv_data/ 以下の以下のファイルを読み込みます。
    - products.csv
    - product_images.csv
    - product_variants.csv

何度実行しても安全です（update_or_create のため、既存レコードは上書き更新されます）。
"""

import csv
from datetime import datetime
from pathlib import Path

from django.conf import settings
from django.core.management.base import BaseCommand
from django.db import transaction
from django.utils import timezone

from shop.models import ProductImages, Products, ProductVariants


def parse_int(value, default=None):
    """空文字/None は default を返し、それ以外は int に変換する。"""
    if value is None or value == "":
        return default
    return int(value)


def parse_str_or_none(value):
    """空文字は None（NULL）として扱う。値があればそのまま返す。"""
    if value is None or value == "":
        return None
    return value


def parse_datetime(value):
    """'YYYY-MM-DD HH:MM:SS' 形式の文字列を datetime に変換する。
    USE_TZ=True の場合はタイムゾーン情報を付与する。
    """
    if not value:
        return None
    dt = datetime.strptime(value, "%Y-%m-%d %H:%M:%S")
    if settings.USE_TZ and timezone.is_naive(dt):
        dt = timezone.make_aware(dt, timezone.get_default_timezone())
    return dt


class Command(BaseCommand):
    help = "CSVファイルから Products / ProductImages / ProductVariants を取り込みます"

    def add_arguments(self, parser):
        parser.add_argument(
            "--dir",
            type=str,
            default=str(Path(settings.BASE_DIR) / "csv_data"),
            help="CSVファイルが格納されているディレクトリ（デフォルト: BASE_DIR/csv_data）",
        )

    def handle(self, *args, **options):
        csv_dir = Path(options["dir"])
        self.stdout.write(f"CSVディレクトリ: {csv_dir}")

        if not csv_dir.exists():
            self.stderr.write(
                self.style.ERROR(f"ディレクトリが見つかりません: {csv_dir}")
            )
            return

        # 外部キーの依存関係があるため、この順番で取り込む
        self.import_products(csv_dir / "products.csv")
        self.import_product_images(csv_dir / "product_images.csv")
        self.import_product_variants(csv_dir / "product_variants.csv")

        self.stdout.write(self.style.SUCCESS("全ての取り込みが完了しました"))

    def import_products(self, path):
        if not path.exists():
            self.stdout.write(
                self.style.WARNING(f"{path.name} が見つかりません。スキップします。")
            )
            return

        count = 0
        with open(path, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            with transaction.atomic():
                for row in reader:
                    Products.objects.update_or_create(
                        id=row["id"],
                        defaults={
                            "name": row["name"],
                            "description": parse_str_or_none(row.get("description")),
                            "created_at": parse_datetime(row["created_at"]),
                            "hard": parse_str_or_none(row.get("hard")),
                            "ken": parse_str_or_none(row.get("ken")),
                            "kinds": parse_str_or_none(row.get("kinds")),
                            "base": parse_str_or_none(row.get("base")),
                            "is_recommended": parse_int(row.get("is_recommended")),
                            "rank": parse_int(row.get("rank")),
                        },
                    )
                    count += 1
        self.stdout.write(self.style.SUCCESS(f"Products: {count}件 取り込み完了"))

    def import_product_images(self, path):
        if not path.exists():
            self.stdout.write(
                self.style.WARNING(f"{path.name} が見つかりません。スキップします。")
            )
            return

        count = 0
        skipped = []
        with open(path, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            with transaction.atomic():
                for row in reader:
                    try:
                        product = Products.objects.get(id=row["product_id"])
                    except Products.DoesNotExist:
                        skipped.append((row["id"], row["product_id"]))
                        continue
                    ProductImages.objects.update_or_create(
                        id=row["id"],
                        defaults={
                            "product": product,
                            "image_url": row["image_url"],
                            "sort_order": parse_int(row["sort_order"]),
                        },
                    )
                    count += 1
        self.stdout.write(self.style.SUCCESS(f"ProductImages: {count}件 取り込み完了"))
        if skipped:
            self.stdout.write(
                self.style.WARNING(
                    f"product_idが存在せずスキップした行 (id, product_id): {skipped}"
                )
            )

    def import_product_variants(self, path):
        if not path.exists():
            self.stdout.write(
                self.style.WARNING(f"{path.name} が見つかりません。スキップします。")
            )
            return

        count = 0
        skipped = []
        with open(path, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            with transaction.atomic():
                for row in reader:
                    try:
                        product = Products.objects.get(id=row["product_id"])
                    except Products.DoesNotExist:
                        skipped.append((row["id"], row["product_id"]))
                        continue
                    ProductVariants.objects.update_or_create(
                        id=row["id"],
                        defaults={
                            "product": product,
                            "size_or_color": row["size_or_color"],
                            "price": parse_int(row["price"]),
                            "variant_image_url": parse_str_or_none(
                                row.get("variant_image_url")
                            ),
                            "is_main": parse_int(row.get("is_main"), default=0),
                            "stock": parse_int(row["stock"]),
                            "litl": parse_int(row.get("litl")),
                        },
                    )
                    count += 1
        self.stdout.write(
            self.style.SUCCESS(f"ProductVariants: {count}件 取り込み完了")
        )
        if skipped:
            self.stdout.write(
                self.style.WARNING(
                    f"product_idが存在せずスキップした行 (id, product_id): {skipped}"
                )
            )
