# cd stable-diffusion; python scripts/txt2img.py --prompt "$1" --n_samples 1 --n_iter 1 --plms --W 1200 --H 628
python scripts/txt2img.py --prompt "$1" --n_samples 1 --n_iter 1 --plms --W 1024 --H 512
# cd stable-diffusion; python scripts/txt2img.py --prompt "$1" --n_samples 1 --n_iter 1 --plms
