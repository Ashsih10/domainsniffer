#!/bin/bash

function show_help() {
  cat << EOF
Usage: $0 <URL>

Downloads the content of the given URL, extracts domains and subdomains (including wildcards),
removes duplicates, cleans wildcards, and saves the results in an output folder.

Example:
  $0 "https://crt.sh/?q=netflix"

Options:
  -h, --help    Show this help message and exit.
EOF
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

if [ -z "$1" ]; then
  echo "[-] Error: No URL provided."
  show_help
  exit 1
fi

URL="$1"

# Sanitize folder name: take domain or the whole URL replacing non-alphanumeric chars with _
# Extract domain from URL, fallback to sanitized whole URL if fails
DOMAIN=$(echo "$URL" | grep -oP '(?<=://)[^/]+')
if [ -z "$DOMAIN" ]; then
  DOMAIN=$(echo "$URL" | sed 's/[^a-zA-Z0-9]/_/g')
fi

OUTPUT_DIR="output_${DOMAIN}"
mkdir -p "$OUTPUT_DIR"

echo "[*] Downloading content from URL: $URL ..."
OUTPUT_PREFIX="${OUTPUT_DIR}/output"

wget -q -O "${OUTPUT_PREFIX}.txt" "$URL"
if [ $? -ne 0 ]; then
  echo "[-] Failed to download data from $URL"
  exit 1
fi
echo "[+] Download done: ${OUTPUT_PREFIX}.txt"

echo "[*] Extracting domains and subdomains (including wildcards)..."
grep -oE '\*?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "${OUTPUT_PREFIX}.txt" > "${OUTPUT_PREFIX}_extracted.txt"
count_extracted=$(wc -l < "${OUTPUT_PREFIX}_extracted.txt")
echo "[+] Extracted $count_extracted domain entries: ${OUTPUT_PREFIX}_extracted.txt"

echo "[*] Removing duplicates (first pass)..."
count_before=$(wc -l < "${OUTPUT_PREFIX}_extracted.txt")
sort "${OUTPUT_PREFIX}_extracted.txt" | uniq > "${OUTPUT_PREFIX}_unique.txt"
count_after=$(wc -l < "${OUTPUT_PREFIX}_unique.txt")
dups=$((count_before - count_after))

if [ $dups -eq 0 ]; then
  echo "[-] No duplicates found."
else
  echo "[+] Removed $dups duplicate entries."
fi

echo "[*] Cleaning wildcard prefixes from domains..."
sed 's/^\*\.\?//' "${OUTPUT_PREFIX}_unique.txt" > "${OUTPUT_PREFIX}_clean.txt"
echo "[+] Wildcard prefixes removed."

echo "[*] Removing duplicates again after cleaning wildcards..."
count_before_clean=$(wc -l < "${OUTPUT_PREFIX}_clean.txt")
sort "${OUTPUT_PREFIX}_clean.txt" | uniq > "${OUTPUT_PREFIX}_final.txt"
count_after_clean=$(wc -l < "${OUTPUT_PREFIX}_final.txt")
dups_clean=$((count_before_clean - count_after_clean))

if [ $dups_clean -eq 0 ]; then
  echo "[-] No duplicates found after cleaning."
else
  echo "[+] Removed $dups_clean duplicates after cleaning."
fi

echo ""
echo "[✅] Process completed successfully."
echo "[✅] All files saved in folder: $OUTPUT_DIR"
echo "[✅] Final clean domain list: ${OUTPUT_PREFIX}_final.txt"

