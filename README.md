<p align="center">
  <img src="https://github.com/user-attachments/assets/f7b7aee4-9742-46fb-8378-ab584ca467c8" alt="domsniff" width="400"/>
</p>

# 🕵️ domainsniffer


A powerful Bash tool to **extract**, **filter**, and **clean** domains and subdomains from [crt.sh](https://crt.sh/) certificate transparency logs and any web url Built for OSINT, recon, and bug bounty hunters.

---

## Makers Note
you went into a webpage , now you want to  extract all the domains and subdomains from it. You use this tool , thats it . copy the web url put it in the tool , done.

## 📦 Features

- 🔗 Accepts `https://crt.sh/?q=...` as input and any working web urls , eg shodan , censys
- 📤 Output to a specified directory (`-o`)
- 📁 Automatically names folders based on the domain (e.g., `google_output`)
- 📄 Saves multiple stages of output (raw HTML, extracted, unique, cleaned, final)
- 🧹 Removes wildcard prefixes like `*.` from domains
- 🧼 Filters out non-matching domains/subdomains using:
  - `--base` to keep only those matching a base domain
  - `--filter` to apply advanced wildcard filtering:
    - `google.com` → exact + subdomains
    - `*google.com` → only subdomains
    - `google.com.*` → TLD variants
    - `*.google.com.*` → subdomains + TLDs
- 📑 Excluded domains are saved for reference
- 🆘 Help menu (`-h`) to guide usage
- ✅ Verbose output of each step with `[+]`, `[-]` messages

---

## ⚙️ Requirements

- `bash`
- `wget`
- `grep`
- `sed`
- `sort`, `uniq`

Install them using:

```bash
sudo apt install wget grep sed coreutils
````

---

## 🚀 Installation

```bash
git clone https://github.com/Ashsih10/domainsniffer.git
cd domainsniffer
chmod +x domainsniffer
```
---

## next step
```bash
sudo cp domainsniffer /opt (for accessing globally)
```
## 🧪 Usage

```bash
domainsniffer [OPTIONS] <crt.sh URL>
```

### 🧾 Examples

#### 🔍 Basic extraction

```bash
domainsniffer 'https://crt.sh/?q=netflix'
```

#### 📂 Save output to custom directory

```bash
domainsniffer -o ./results 'https://crt.sh/?q=google.com'
```

#### 🎯 Base domain filtering

Only keep domains related to `google.com`:

```bash
domainsniffer -b google.com 'https://crt.sh/?q=google.com'
```

#### 🔎 Advanced wildcard filtering (removes the patterns and keep it in another file for reference)

Only subdomains of `google.com`:

```bash
domainsniffer -f '*google.com' 'https://crt.sh/?q=google.com'
```

Subdomains and TLD variants:

```bash
domainsniffer -f '*.google.com.*' 'https://crt.sh/?q=google.com'
```

#### ℹ️ Help

```bash
domainsniffer -h
```

---

## ⚙️ Options

| Option                   | Description                                                                                                                                                                          |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `-o`, `--output DIR`     | Output directory (default: `./output`)                                                                                                                                               |
| `-b`, `--base DOMAIN`    | Keep only domains/subdomains of this base (e.g. `google.com`)                                                                                                                        |
| `-f`, `--filter PATTERN` | Advanced filtering using wildcards:<br>`google.com` → exact + subdomains<br>`*google.com` → only subdomains<br>`google.com.*` → TLD variants<br>`*.google.com.*` → subdomains + TLDs |
| `-h`, `--help`           | Show help                                                                                                                                                                            |

---

## 🧼 Output Structure

Each run generates a time-stamped output directory like:

```bash
google_output/
├── raw_YYYYMMDD_HHMMSS.txt                # Raw HTML from crt.sh
├── domains_extracted_YYYYMMDD_HHMMSS.txt  # All extracted domains
├── unique_domains_YYYYMMDD_HHMMSS.txt     # Unique domains
├── clean_domains_YYYYMMDD_HHMMSS.txt      # Wildcards cleaned
├── final_domains_YYYYMMDD_HHMMSS.txt      # Final cleaned output
├── excluded_domains_YYYYMMDD_HHMMSS.txt   # Domains filtered out (optional)
```

---

## 🧠 Author

Developed with 🖤 by Ashish (https://github.com/Ashsih10)

