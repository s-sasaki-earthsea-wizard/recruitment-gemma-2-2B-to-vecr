import torch
from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import os
import psutil
import time

# Define global variables
model = None
tokenizer = None
pipe = None

def load_model():
    global model, tokenizer, pipe
    model_name = os.getenv('MODEL_NAME', 'google/gemma-2-2b-jpn-it')
    model_path = os.getenv('MODEL_PATH', './model')

    start_time = time.time()
    tokenizer = AutoTokenizer.from_pretrained(model_path)
    model = AutoModelForCausalLM.from_pretrained(
        model_path,
        device_map="auto",
        torch_dtype=torch.float16  # Load model in FP16
    )
    load_time = time.time() - start_time
    print(f"Model Load Time: {load_time:.2f} seconds")

    pipe = pipeline(
        "text-generation",
        model=model,
        tokenizer=tokenizer,
        device="cuda" if torch.cuda.is_available() else "cpu"
    )

    # Show memory usage
    process = psutil.Process(os.getpid())
    memory_info = process.memory_info()
    print(f"Memory Usage: {memory_info.rss / (1024 * 1024):.2f} MB")

app = Flask(__name__)
CORS(app)

@app.before_first_request
def initialize():
    load_model()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    try:
        user_message = request.json.get("message")
        if not user_message:
            return jsonify({"error": "Message is required"}), 400

        start_time = time.time()
        messages = [{"role": "user", "content": user_message}]
        outputs = pipe(messages, return_full_text=False, max_new_tokens=256)
        assistant_response = outputs[0]["generated_text"].strip()
        inference_time = time.time() - start_time

        # Check memory usage after inference
        process = psutil.Process(os.getpid())
        memory_info = process.memory_info()
        print(f"Memory Usage after inference: {memory_info.rss / (1024 * 1024):.2f} MB")

        return jsonify({
            "response": assistant_response,
            "inference_time": f"{inference_time:.2f}秒"
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)