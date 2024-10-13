import os
from transformers import AutoTokenizer, AutoModelForCausalLM

model_name = os.getenv('MODEL_NAME')
model_path = os.getenv('MODEL_PATH')

tokenizer = AutoTokenizer.from_pretrained(model_name, cache_dir=model_path)
model = AutoModelForCausalLM.from_pretrained(model_name, cache_dir=model_path)

print(f"Model downloaded and saved to {model_path}")