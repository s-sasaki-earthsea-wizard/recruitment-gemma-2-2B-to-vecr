import torch
from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import os

# オリジナル版の作者に敬意を表し、日本語のコメントを残し、佐々木が英文コメントでの補足を行っています。
# In honour of the author of the original version, 
# I have left comments in Japanese and Sasaki has supplemented them with English comments.

# Get the model name and model path from the environment variables
model_name = os.getenv('MODEL_NAME')
model_path = os.getenv('MODEL_PATH')
model_name = os.getenv('MODEL_NAME', 'google/gemma-2-2b-jpn-it')  # Set the default model name

# Load the model and tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_path)
model = AutoModelForCausalLM.from_pretrained(
    model_path,
    device_map="auto",
    torch_dtype=torch.bfloat16
)

# パイプラインの準備 (CPUを使用するように設定)
# Prepare the pipeline (set to use CPU)
pipe = pipeline(
    "text-generation",
    model=model_name,
    device=-1  # CPUを使用; use CPU
)

# Flaskアプリケーションの設定
# Flask application settings
app = Flask(__name__)
CORS(app)  # CORSを有効にしてクロスオリジンアクセスを許可; Enable CORS to allow cross-origin access

# HTMLの提供用のルートエンドポイント
# Root endpoint for serving HTML
@app.route('/')
def index():
    return render_template('index.html')

# 対話APIエンドポイント
# Chat API endpoint
@app.route('/chat', methods=['POST'])
def chat():
    try:
        user_message = request.json.get("message")
        if not user_message:
            return jsonify({"error": "Message is required"}), 400

        # 推論の実行; Perform inference
        messages = [{"role": "user", "content": user_message}]
        outputs = pipe(messages, return_full_text=False, max_new_tokens=256)
        assistant_response = outputs[0]["generated_text"].strip()

        return jsonify({"response": assistant_response})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
