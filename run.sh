#!/usr/bin/env bash

prompt=$1
json_file="./outputs/generation.json"

height=512
width=1024

function generate_random_seeds() {
  local num_seeds=$1
  local max_seed=$2
  local seed_arr=()

  for ((i = 0; i < num_seeds; i++)); do
    seed_arr+=( $((RANDOM % max_seed)) )
  done

  echo "${seed_arr[@]}"
}

seeds=($(generate_random_seeds 30 100))
echo $seeds

for seed in "${seeds[@]}"; do
  echo "prompt: $prompt, seed: $seed"

  # run the generation
  python scripts/txt2img.py --prompt "$1" --n_samples 1 --n_iter 1 --plms --W $width --H $height --seed "$seed"

  # find the most recent image filename in the txt2img-samples folder
  image_filename=$(find ./outputs/txt2img-samples -maxdepth 1 -name "grid-*.png" -type f -printf "%T@ %p\n" | sort -nr | head -n 1 | cut -d ' ' -f 2-)
  image_filename=$(basename "$image_filename")

  # check if the JSON file exists, if not create an empty JSON array
  if [ ! -f "$json_file" ]; then
    echo "[]" > "$json_file"
  fi

  # ISO 8601 UTC timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Append generation to the JSON file
  new_entry='{"seed": "'"$seed"'", "timestamp": "'"$timestamp"'", "prompt": "'"$prompt"'", "image": "./outputs/txt2img-samples/'"$image_filename"'"}'
  jq --argjson new_entry "$new_entry" '. + [$new_entry]' "$json_file" > temp.json
  mv temp.json "$json_file"

  echo "Image information appended to $json_file"
done
