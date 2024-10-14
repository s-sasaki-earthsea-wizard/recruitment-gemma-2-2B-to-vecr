# オリジナル版の作者に敬意を表し、日本語のコメントを残し、佐々木が英文コメントでの補足を行っています。
# In honour of the author of the original version, I have left comments in Japanese and Sasaki has supplemented them with English comments.

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
ARG MODEL_NAME
ARG MODEL_PATH

ENV PROJECT_NAME=$PROJECT_NAME
ENV TEAM_MEMBER_NAME=$TEAM_MEMBER_NAME
ENV HF_TOKEN=$HF_TOKEN
ENV MODEL_NAME=$MODEL_NAME
ENV MODEL_PATH=$MODEL_PATH

# アプリケーションコードをコンテナにコピー; Copy the application code
COPY . .

# Create the model path directory
RUN mkdir -p $MODEL_PATH

# Download the model
RUN python app/download_model.py

# Remove the download script
RUN rm app/download_model.py

# Remove the HF token from the environment variables
ENV HF_TOKEN=

# コンテナ起動時のコマンドを指定; Specify the command to run on container start
CMD ["/bin/bash"]
