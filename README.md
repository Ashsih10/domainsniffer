# 🕵️‍♂️ Domsniff
# Domain and Subdomain extractor from URL WebPage

This is a simple and powerful Bash tool to **extract domains and subdomains** (including wildcard entries) from any webpage, especially useful with sites like [crt.sh](https://crt.sh). It processes the content step-by-step, cleans the data, removes duplicates, and saves the final output in an organized folder.

---

## 🚀 Features

- Extracts domains and subdomains (e.g., `*.example.com`, `sub.domain.com`)
- Automatically cleans wildcard prefixes
- Removes duplicate entries (before and after cleaning)
- Stores all intermediate and final output files in a dedicated folder
- Supports any URL, not just `crt.sh`
- Displays progress messages at every step
- Includes a helpful `--help` section

---

## 📦 Installation

Clone this repository and make the script executable:

```bash
git clone https://github.com/your-username/domsniff.git
cd domsniff
chmod +x domsniff.sh
