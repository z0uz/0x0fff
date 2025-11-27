# 0x0fff - GitHub Hunter v2.0

<div align="center">

```
╔════════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║                        0x0fff - GitHub Hunter                        ║
║                     Advanced User Search & Analysis                    ║
║                                                                      ║
╚════════════════════════════════════════════════════════════════════════╝
```

**Advanced GitHub User Search Tool with Enhanced Features**

[![GitHub release](https://img.shields.io/github/release/username/0x0fff.svg)](https://github.com/username/0x0fff/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](github_hunter.sh)
[![GitHub CLI](https://img.shields.io/badge/dependencies-gh%20%7C%20jq-orange.svg)](#dependencies)

</div>

## Overview

GitHub Hunter is a powerful, feature-rich command-line tool that enhances the basic GitHub API user search functionality. It transforms the simple `gh api search/users` command into a professional-grade user hunting tool with advanced filtering, beautiful output, and comprehensive data extraction.

## Key Features

### Beautiful Interface
- ASCII art banner with GitHub Hunter branding
- Full-color terminal output with emoji indicators
- Real-time progress bars with Unicode characters
- Professional command-line experience

### Advanced Search Capabilities
- **Bio-based searching** - Find users by their bio content
- **Location filtering** - Target users in specific locations
- **Repository filtering** - Filter by minimum repository count
- **Followers filtering** - Filter by minimum followers
- **Multi-page support** - Fetch up to 1000+ results

### Multiple Output Formats
- **JSON** - Structured data for programmatic use
- **CSV** - Spreadsheet-ready format
- **TXT** - Human-readable formatted output

### Professional Features
- **Verbose mode** - Detailed operation feedback
- **Rate limiting** - Respectful API usage
- **Error handling** - Comprehensive error management
- **Dependency checking** - Automatic tool validation
- **Timestamped outputs** - Organized result storage

## Installation

### Prerequisites

Before using GitHub Hunter, ensure you have the following dependencies installed:

#### GitHub CLI (gh)
```bash
# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh

# Other Linux
curl -L https://github.com/cli/cli/releases/latest/download/gh_*_linux_amd64.tar.gz | tar xz
sudo mv gh_*_linux_amd64/bin/gh /usr/local/bin/

# Authenticate with GitHub
gh auth login
```

#### jq (JSON Processor)
```bash
# Ubuntu/Debian
sudo apt install jq

# macOS
brew install jq

# Other Linux
sudo apt-get install jq
```

### Setup

1. **Clone the repository:**
```bash
git clone https://github.com/username/0x0fff.git
cd 0x0fff
```

2. **Make the script executable:**
```bash
chmod +x github_hunter.sh
```

3. **Verify installation:**
```bash
./github_hunter.sh --help
```

## Usage

### Basic Usage

```bash
# Simple bio search
./github_hunter.sh -q "security researcher"

# Search with location filter
./github_hunter.sh -q "penetration tester" -l "San Francisco"

# Search with repository and follower filters
./github_hunter.sh -q "machine learning engineer" -r 50 -f 1000
```

### Advanced Usage

```bash
# JSON output with verbose mode
./github_hunter.sh -q "cybersecurity expert" -o json -v

# CSV output for spreadsheet analysis
./github_hunter.sh -q "open source contributor" -o csv -p 5

# Multi-filter search with custom page limit
./github_hunter.sh -q "devops engineer" -l "New York" -r 25 -f 500 -p 3
```

### Command Options

| Option | Short | Description | Example |
|--------|-------|-------------|---------|
| `--query` | `-q` | Search query (required) | `-q "security researcher"` |
| `--location` | `-l` | Filter by location | `-l "San Francisco"` |
| `--repos` | `-r` | Minimum repositories | `-r 50` |
| `--followers` | `-f` | Minimum followers | `-f 1000` |
| `--output` | `-o` | Output format (json|csv|txt) | `-o json` |
| `--pages` | `-p` | Maximum pages to fetch | `-p 10` |
| `--verbose` | `-v` | Verbose output | `-v` |
| `--help` | `-h` | Show help menu | `-h` |

## Output Formats

### TXT Format (Default)
```
👤 @username
📛 Name: John Doe
📍 Location: San Francisco, CA
📝 Bio: Security researcher and penetration tester
📚 Repositories: 125
👥 Followers: 2,450
🔗 Following: 342
📅 Created: 2015-03-15T10:30:00Z
🔄 Updated: 2024-11-27T15:45:00Z
────────────────────────────────────────────────────────────
```

### JSON Format
```json
{
  "username": "username",
  "name": "John Doe",
  "bio": "Security researcher and penetration tester",
  "location": "San Francisco, CA",
  "public_repos": 125,
  "followers": 2450,
  "following": 342,
  "created_at": "2015-03-15T10:30:00Z",
  "updated_at": "2024-11-27T15:45:00Z"
}
```

### CSV Format
```csv
username,name,bio,location,public_repos,followers,following,created_at,updated_at
"username","John Doe","Security researcher and penetration tester","San Francisco, CA",125,2450,342,"2015-03-15T10:30:00Z","2024-11-27T15:45:00Z"
```

## Use Cases

### Research & Analysis
- Find security researchers for collaboration
- Analyze developer communities in specific regions
- Study open source contributor demographics
- Track industry expert distribution

### Networking & Recruitment
- Identify potential team members
- Find speakers for tech conferences
- Locate contributors for open source projects
- Discover industry influencers

### Competitive Intelligence
- Analyze competitor's developer ecosystem
- Track technology adoption patterns
- Study hiring trends in tech companies
- Monitor community growth metrics

### Market Research
- Identify technology adoption by region
- Analyze skill distribution across industries
- Study developer career progression
- Track emerging technology trends

## Project Structure

```
0x0fff/
├── github_hunter.sh          # Main executable script
├── README.md                 # This documentation
├── LICENSE                   # MIT License
├── github_results/           # Output directory (auto-created)
│   ├── github_hunter_20241127_183000.txt
│   ├── github_hunter_20241127_183100.json
│   └── github_hunter_20241127_183200.csv
└── assets/                   # Screenshots and demos
    ├── demo.gif
    └── screenshot.png
```

## Technical Details

### Search Query Building
The tool constructs sophisticated GitHub search queries using the following format:
```
QUERY in:bio location:LOCATION repos:>MIN_REPOS followers:>MIN_FOLLOWERS
```

### API Rate Limiting
- **Respectful timing**: 1-second delay between API calls
- **Batch processing**: 100 results per page (GitHub maximum)
- **Error handling**: Automatic retry on API failures
- **Authentication**: Uses GitHub CLI token for higher limits

### Data Extraction
For each user found, GitHub Hunter extracts:
- Username and display name
- Bio and location information
- Repository and follower counts
- Account creation and last update dates
- Profile URL and additional metadata

## Contributing

We welcome contributions! Here's how you can help:

### Bug Reports
- Open an issue with detailed description
- Include terminal output and error messages
- Specify your OS and tool versions

### Feature Requests
- Open an issue with "Feature Request" label
- Describe the use case and expected behavior
- Consider contributing the implementation

### Pull Requests
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow shell scripting best practices
- Add comments for complex logic
- Update documentation for new features
- Test thoroughly before submitting

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

GitHub Hunter is intended for legitimate research and networking purposes. Users are responsible for:

- Complying with GitHub's Terms of Service
- Respecting user privacy and data protection laws
- Using the tool ethically and responsibly
- Not overwhelming GitHub's API servers

## Acknowledgments

- **GitHub CLI** - For providing excellent API access
- **jq** - For powerful JSON processing capabilities
- **The open source community** - For inspiration and feedback

---

<div align="center">

**Happy Hunting!**

Made with ❤️ by z0uz

[![GitHub stars](https://img.shields.io/github/stars/username/0x0fff.svg?style=social&label=Star)](https://github.com/username/0x0fff)
[![GitHub forks](https://img.shields.io/github/forks/username/0x0fff.svg?style=social&label=Fork)](https://github.com/username/0x0fff/fork)

</div>
