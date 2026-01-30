import hashlib
import os
import json

def get_sha256(file_path):
    sha256_hash = hashlib.sha256()
    with open(file_path, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

chunks_dir = "quran_chunks"
manifest = {
    "version": "1.0.0",
    "lastUpdated": "2026-01-31",
    "quran": {
        "version": "1.0",
        "totalPages": 604,
        "chunks": []
    }
}

files = [
    {"id": "part1", "name": "quran-part1.zip", "start": 1, "end": 200},
    {"id": "part2", "name": "quran-part2.zip", "start": 201, "end": 400},
    {"id": "part3", "name": "quran-part3.zip", "start": 401, "end": 604},
]

for file_info in files:
    file_path = os.path.join(chunks_dir, file_info["name"])
    if os.path.exists(file_path):
        size = os.path.getsize(file_path)
        checksum = get_sha256(file_path)
        # Using placeholder URL as per user instructions for later replacement
        manifest["quran"]["chunks"].append({
            "id": file_info["id"],
            "url": f"https://github.com/REPLACE_WITH_YOUR_USER/an-nibros-assets/releases/download/v1.0/{file_info['name']}",
            "startPage": file_info["start"],
            "endPage": file_info["end"],
            "sizeBytes": size,
            "checksum": f"sha256:{checksum}"
        })

with open(os.path.join(chunks_dir, "manifest.json"), "w") as f:
    json.dump(manifest, f, indent=2)

print("manifest.json created in quran_chunks/")
