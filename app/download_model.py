import os
from transformers import AutoTokenizer, AutoModelForCausalLM
from huggingface_hub import snapshot_download
import logging

logging.basicConfig(level=logging.DEBUG, filename='download.log')

model_name = os.getenv('MODEL_NAME')
model_path = os.getenv('MODEL_PATH')
hf_token = os.getenv('HF_TOKEN')

if not hf_token:
    print("Warning: HF_TOKEN is not set. Some models may not be accessible.")

# Download model: ONLY DOWNLOAD, DO NOT LOAD
snapshot_download(repo_id=model_name, cache_dir=model_path, token=hf_token)

# DEBUG: THESE COMMANDS DOWNLOAD AND LOAD THE MODEL AT THE SAME TIME.
# tokenizer = AutoTokenizer.from_pretrained(model_name, cache_dir=model_path, token=hf_token)
# model = AutoModelForCausalLM.from_pretrained(model_name, cache_dir=model_path, token=hf_token)

print(f"Model downloaded and saved to {model_path}")