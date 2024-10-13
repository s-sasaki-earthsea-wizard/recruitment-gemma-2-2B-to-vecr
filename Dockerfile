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

# 環境変数の設定; Set environment variables
ARG PROJECT_NAME
ARG TEAM_MEMBER_NAME
ARG HF_TOKEN

ENV PROJECT_NAME=$PROJECT_NAME
ENV TEAM_MEMBER_NAME=$TEAM_MEMBER_NAME
ENV HUGGINGFACE_TOKEN=$HF_TOKEN
ARG MODEL_NAME
ENV MODEL_NAME=$MODEL_NAME
ARG MODEL_PATH
ENV MODEL_PATH=$MODEL_PATH

# モデルのダウンロード; Download the model
RUN huggingface-cli login --token $HUGGINGFACE_TOKEN \
    && huggingface-cli download $MODEL_NAME --local-dir $MODEL_PATH --local-dir-use-symlinks False \
    && huggingface-cli logout

# アプリケーションコードをコンテナにコピー; Copy the application code
COPY . .

# コンテナ起動時のコマンドを指定; Specify the command to run on container start
CMD ["python", "app.py"]
