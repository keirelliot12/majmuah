import os
from PIL import Image

input_dir = r"assets/images/quran"
output_dir = r"assets/images/quran_webp"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

print(f"Starting conversion from {input_dir} to {output_dir}...")

png_files = [f for f in os.listdir(input_dir) if f.endswith(".png")]
png_files.sort()

total = len(png_files)
for i, filename in enumerate(png_files):
    input_path = os.path.join(input_dir, filename)
    output_filename = os.path.splitext(filename)[0] + ".webp"
    output_path = os.path.join(output_dir, output_filename)

    # Skip if already converted
    if os.path.exists(output_path):
        continue

    with Image.open(input_path) as img:
        img.save(output_path, "WEBP", quality=85)

    if (i + 1) % 50 == 0 or (i + 1) == total:
        print(f"Processed {i + 1}/{total} files...")

print("Conversion complete.")
