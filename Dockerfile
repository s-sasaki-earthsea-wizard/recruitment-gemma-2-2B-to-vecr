# オリジナル版の作者に敬意を表し、コメントを日英併記しています。
# In respect to the original author, comments are written in both Japanese and English.

# ベースイメージの指定; Set the base image
FROM python:3.12

# 作業ディレクトリの作成と設定; Set the working directory
WORKDIR /app

# requirements.txtをコンテナにコピー; Copy the requirements.txt file
COPY requirements.txt .

# 必要なパッケージのインストール; Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# Hugging Face CLI のインストール; Install Hugging Face CLI
RUN pip install --no-cache-dir huggingface_hub

# モデルのダウンロード; Download the model
# ARG HF_TOKEN
# RUN huggingface-cli login --token $HF_TOKEN \
#     && huggingface-cli download google/gemma-2-2b-it --local-dir /app/model --local-dir-use-symlinks False \
#     && huggingface-cli logout

# アプリケーションコードをコンテナにコピー; Copy the application code
COPY . .

# 環境変数の設定; Set environment variables
# ENV MODEL_PATH=/app/model

# コンテナ起動時のコマンドを指定; Specify the command to run on container start
CMD ["python", "app.py"]
