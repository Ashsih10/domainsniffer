# domsniff

# 🔍 Domain and Subdomain Extractor Tool from Any URL WebPage

# 🛠️ Domain Extractor from crt.sh

This script extracts, cleans, and filters domains from a `crt.sh` webpage.

---
## 📥 Installation

Clone this repository:

```bash
git clone https://github.com/Ashsih10/domsniff.git
cd domsniff
chmod +x domsniff.sh

## 📦 Features

- Fetches raw HTML content from any `crt.sh` URL.
- Extracts all domains and subdomains, including wildcards.
- Cleans and deduplicates entries.
- Filters by:
  - Base domain (e.g. `google.com`)
  - Wildcard-like filters (`*google.com`, `google.com.*`, etc.)
- Saves filtered-out domains for future reference.
- Fully compatible with Linux.

---

## 🧪 Example

```bash
./extract_domains.sh -o results -b google.com -f '*.google.com.*' 'https://crt.sh/?q=google'






