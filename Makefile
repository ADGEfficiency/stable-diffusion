all: setup

setup:
	pip install -r ./requirements.txt

weights:
	mkdir ./models/ldm/stable-diffusion-v1
	mv ~/Downloads/sd-v1-4.ckpt ./models/ldm/stable-diffusion-v1/model.ckpt
