# domsniff

# 🔍 Domain Extractor Tool from Any URL

This is a simple Linux shell script that extracts all domain and subdomain names (including wildcards like `*.example.com`) from **any webpage URL**, cleans them, removes duplicates, and stores them in a neat folder for analysis or recon.

---

## 🚀 Features

- Accepts **any valid URL**
- Extracts domain names using regex
- Removes duplicates
- Cleans wildcard domains like `*.example.com` → `example.com`
- Saves intermediate and final results in a dedicated output folder
- Shows progress with detailed success/failure messages
- Built-in `--help` support

---

## 🧰 Requirements

- `bash`
- `wget`
- `grep`, `sed`, `sort`, `uniq`
- Works on most Linux distros and macOS with common Unix tools

---

## 📥 Installation

Clone this repository:

```bash
git clone https://github.com/Ashsih10/domsniff.git
cd domsniff
chmod +x domsniff.sh
