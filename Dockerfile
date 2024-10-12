# ベースイメージの指定; Set the base image
FROM python:3.12

# 作業ディレクトリの作成と設定; Set the working directory
WORKDIR /app

# requirements.txtをコンテナにコピー; Copy the requirements.txt file
COPY requirements.txt .

# 必要なパッケージのインストール; Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# アプリケーションコードをコンテナにコピー; Copy the application code
COPY . .

# コンテナ起動時のコマンドを指定; Specify the command to run on container start
CMD ["python", "app.py"]
