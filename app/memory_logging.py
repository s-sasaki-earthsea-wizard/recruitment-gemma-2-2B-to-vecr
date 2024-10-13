import os
import psutil

# Function to check memory usage
def check_memory():
    process = psutil.Process(os.getpid())
    mem_info = process.memory_info()
    print(f"Memory usage: {mem_info.rss / 1024 ** 2:.2f} MB")

# Check memory before loading model
check_memory()

tokenizer = AutoTokenizer.from_pretrained(model_name, cache_dir=model_path, token=hf_token)
model = AutoModelForCausalLM.from_pretrained(model_name, cache_dir=model_path, token=hf_token)

# Check memory after loading model
check_memory()
