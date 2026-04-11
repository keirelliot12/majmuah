import os
import zipfile

def create_zip_chunk(chunk_id, start_page, end_page, source_dir, output_name):
    print(f"Creating {output_name} (Pages {start_page}-{end_page})...")
    with zipfile.ZipFile(output_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
        count = 0
        for i in range(start_page, end_page + 1):
            filename = f"page{str(i).zfill(3)}.png"
            filepath = os.path.join(source_dir, filename)
            if os.path.exists(filepath):
                zipf.write(filepath, filename)
                count += 1
            else:
                print(f"Warning: {filename} not found.")
        print(f"Done. Added {count} files.")

source_dir = r"assets/images/quran"
output_dir = r"quran_chunks"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Define chunks
chunks = [
    {"id": "part1", "start": 1, "end": 200, "name": "quran-part1.zip"},
    {"id": "part2", "start": 201, "end": 400, "name": "quran-part2.zip"},
    {"id": "part3", "start": 401, "end": 604, "name": "quran-part3.zip"},
]

for chunk in chunks:
    output_path = os.path.join(output_dir, chunk["name"])
    create_zip_chunk(chunk["id"], chunk["start"], chunk["end"], source_dir, output_path)

print("\nAll chunks created successfully in 'quran_chunks' folder.")
