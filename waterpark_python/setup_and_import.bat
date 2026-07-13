@echo off
chcp 65001 > nul
cd /d %~dp0

echo [1/5] 仮想環境を作成中...
py -3.12 -m venv venv
call venv\Scripts\activate

echo [2/5] 必要なライブラリをインストール中...
:: ここでpip installを一括で行います
pip install --upgrade pip
pip install django pymysql

echo [3/5] DBマイグレーションを実行中...
:: これが重要です！DBのテーブル構造を最新にします
python manage.py makemigrations shop
python manage.py migrate

echo [4/5] システムファイルの初期化...
python -m compileall shop config > nul 2>&1

echo [5/5] CSVデータのインポートを実行中...
python manage.py import_csv

echo ==================================================
echo  完了しました！
echo ==================================================
pause