#!/bin/bash

# ---------------------------- #
#      Domain Extractor       #
#     From crt.sh with love   #
# ---------------------------- #

# Requirements: bash, wget, grep, sed, sort, uniq
timestamp=$(date +"%Y%m%d_%H%M%S")

# Default values
output_dir="output"
base_domain=""
filter_pattern=""
url=""
show_help=0

# Help message
print_help() {
  cat <<EOF
Usage: ./extract_domains.sh [OPTIONS] <URL>

Extracts domains and subdomains from crt.sh results.

Options:
  -o, --output DIR       Output directory (default: ./output)
  -b, --base DOMAIN      Keep only domains/subdomains of this base (e.g. google.com)
  -f, --filter PATTERN   Advanced filtering using wildcards (this removes pattern):
                         google.com       → exact + subdomains
                         *google.com      → only subdomains
                         google.com.*     → TLD variants (e.g. .hk, .br)
                         *.google.com.*   → subdomains + TLDs
                         (all files will be saved as a seperate file so don't worry)
  -h, --help             Show help

Examples:
  ./extract_domains.sh 'https://crt.sh/?q=netflix'
  ./extract_domains.sh -o results -b google.com -f '*.google.com.*' 'https://crt.sh/?q=google.com'
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      output_dir="$2"
      shift 2
      ;;
    -b|--base)
      base_domain="$2"
      shift 2
      ;;
    -f|--filter)
      filter_pattern="$2"
      shift 2
      ;;
    -h|--help)
      show_help=1
      shift
      ;;
    *)
      if [[ "$1" == http* ]]; then
        url="$1"
        shift
      else
        echo "Unknown option: $1"
        exit 1
      fi
      ;;
  esac
done

# Show help if requested or URL not provided
if [[ $show_help -eq 1 || -z "$url" ]]; then
  print_help
  exit 0
fi

# Extract query from URL
query=$(echo "$url" | grep -oP '(?<=\?q=)[^&]+')
query_safe=$(echo "$query" | sed 's/[^a-zA-Z0-9.-]/_/g')

# Final output directory
final_output="$output_dir/$query_safe"
mkdir -p "$final_output"

# Output files
raw_file="$final_output/raw_${timestamp}.txt"
extracted_file="$final_output/domains_extracted_${timestamp}.txt"
unique_file="$final_output/unique_domains_${timestamp}.txt"
cleaned_file="$final_output/clean_domains_${timestamp}.txt"
final_file="$final_output/final_domains_${timestamp}.txt"
excluded_file="$final_output/excluded_domains_${timestamp}.txt"

echo "[+] Downloading webpage..."
wget -q -O "$raw_file" "$url"
if [[ $? -eq 0 ]]; then
  echo "[+] Download complete: $raw_file"
else
  echo "[-] Failed to download $url"
  exit 1
fi

echo "[+] Extracting domains..."
grep -oE '\*?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$raw_file" > "$extracted_file"
echo "[+] Domains extracted: $extracted_file"

echo "[+] Removing duplicates..."
sort "$extracted_file" | uniq > "$unique_file"
dups=$(( $(wc -l < "$extracted_file") - $(wc -l < "$unique_file") ))
if [[ $dups -gt 0 ]]; then
  echo "[+] Removed $dups duplicates"
else
  echo "[-] No duplicates found"
fi

echo "[+] Cleaning wildcard prefixes..."
sed 's/^\*\.\?//' "$unique_file" > "$cleaned_file"
sort "$cleaned_file" | uniq > "$cleaned_file.tmp" && mv "$cleaned_file.tmp" "$cleaned_file"

# Filtering logic
if [[ -n "$base_domain" || -n "$filter_pattern" ]]; then
  echo "[+] Applying filters..."
  if [[ -n "$base_domain" ]]; then
    grep -i "\(^\|\.\)$base_domain\$" "$cleaned_file" > "$final_file"
    grep -vi "\(^\|\.\)$base_domain\$" "$cleaned_file" > "$excluded_file"
    echo "[+] Kept only base domain: $base_domain"
  fi

  if [[ -n "$filter_pattern" ]]; then
    # Build regex from filter pattern
    regex=$(echo "$filter_pattern" | sed \
      -e 's/\./\\./g' \
      -e 's/\*/.*/g')

    if [[ -s "$final_file" ]]; then
      grep -iE "^$regex$" "$final_file" > "$final_file.tmp"
      grep -viE "^$regex$" "$final_file" >> "$excluded_file"
    else
      grep -iE "^$regex$" "$cleaned_file" > "$final_file.tmp"
      grep -viE "^$regex$" "$cleaned_file" >> "$excluded_file"
    fi

    mv "$final_file.tmp" "$final_file"
    echo "[+] Applied pattern filter: $filter_pattern"
  fi
else
  cp "$cleaned_file" "$final_file"
fi

echo "[+] Final domain list saved: $final_file"
if [[ -s "$excluded_file" ]]; then
  echo "[+] Excluded domains saved: $excluded_file"
fi

