#!/bin/bash

# =============================================================================
# GitHub Hunter - Advanced GitHub User Search Tool
# =============================================================================
# Enhanced version of GitHub API user search with cool features
# Author: Security Research Team
# Version: 2.0
# =============================================================================

# Colors for cool output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Cool ASCII Art Banner
cat << "EOF"
${CYAN}
╔════════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║                        0x0fff - GitHub Hunter                        ║
║                     Advanced User Search & Analysis                    ║
║                                                                      ║
╚════════════════════════════════════════════════════════════════════════╝
${NC}
EOF

# Configuration
GITHUB_API="https://api.github.com"
RESULTS_PER_PAGE=100
MAX_PAGES=10
OUTPUT_DIR="github_results"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Help function
show_help() {
    echo -e "${CYAN}GitHub Hunter - Advanced User Search Tool${NC}"
    echo -e "${YELLOW}Usage: $0 [OPTIONS] QUERY${NC}"
    echo ""
    echo -e "${WHITE}Options:${NC}"
    echo -e "  ${GREEN}-q, --query QUERY${NC}        Search query (required)"
    echo -e "  ${GREEN}-l, --location LOCATION${NC}    Filter by location"
    echo -e "  ${GREEN}-r, --repos MIN_REPOS${NC}     Minimum repositories"
    echo -e "  ${GREEN}-f, --followers MIN_FOLLOWERS${NC} Minimum followers"
    echo -e "  ${GREEN}-o, --output FORMAT${NC}        Output format (json|csv|txt)"
    echo -e "  ${GREEN}-p, --pages MAX_PAGES${NC}      Maximum pages to fetch (default: 10)"
    echo -e "  ${GREEN}-v, --verbose${NC}             Verbose output"
    echo -e "  ${GREEN}-h, --help${NC}                Show this help"
    echo ""
    echo -e "${WHITE}Examples:${NC}"
    echo -e "  $0 -q 'security researcher' -l 'San Francisco'"
    echo -e "  $0 -q 'penetration tester' -r 50 -f 1000"
    echo -e "  $0 -q 'machine learning engineer' -o json -v"
}

# Parse arguments
QUERY=""
LOCATION=""
MIN_REPOS=""
MIN_FOLLOWERS=""
OUTPUT_FORMAT="txt"
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -q|--query)
            QUERY="$2"
            shift 2
            ;;
        -l|--location)
            LOCATION="$2"
            shift 2
            ;;
        -r|--repos)
            MIN_REPOS="$2"
            shift 2
            ;;
        -f|--followers)
            MIN_FOLLOWERS="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -p|--pages)
            MAX_PAGES="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Check if query is provided
if [[ -z "$QUERY" ]]; then
    echo -e "${RED}❌ Query is required! Use -q or --query${NC}"
    show_help
    exit 1
fi

# Build search query
SEARCH_QUERY="$QUERY in:bio"
if [[ -n "$LOCATION" ]]; then
    SEARCH_QUERY="$SEARCH_QUERY location:$LOCATION"
fi
if [[ -n "$MIN_REPOS" ]]; then
    SEARCH_QUERY="$SEARCH_QUERY repos:>=$MIN_REPOS"
fi
if [[ -n "$MIN_FOLLOWERS" ]]; then
    SEARCH_QUERY="$SEARCH_QUERY followers:>=$MIN_FOLLOWERS"
fi

echo -e "${CYAN}Search Query: ${WHITE}$SEARCH_QUERY${NC}"
echo -e "${CYAN}Results per page: ${WHITE}$RESULTS_PER_PAGE${NC}"
echo -e "${CYAN}Max pages: ${WHITE}$MAX_PAGES${NC}"
echo -e "${CYAN}Output format: ${WHITE}$OUTPUT_FORMAT${NC}"
echo ""

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${YELLOW}Progress: [${GREEN}"
    printf "%*s" $filled | tr ' ' '█'
    printf "${RED}"
    printf "%*s" $empty | tr ' ' '░'
    printf "${YELLOW}] %d%% (%d/%d)${NC}" $percentage $current $total
}

# Search function
search_github_users() {
    local page=1
    local total_found=0
    local output_file="$OUTPUT_DIR/github_hunter_$TIMESTAMP.$OUTPUT_FORMAT"
    
    echo -e "${BLUE}Starting GitHub search...${NC}"
    
    # Initialize output file
    case "$OUTPUT_FORMAT" in
        json)
            echo "[" > "$output_file"
            ;;
        csv)
            echo "username,name,bio,location,public_repos,followers,following,created_at,updated_at" > "$output_file"
            ;;
        txt)
            echo "GitHub Hunter Results - $(date)" > "$output_file"
            echo "Query: $SEARCH_QUERY" >> "$output_file"
            echo "======================================" >> "$output_file"
            echo "" >> "$output_file"
            ;;
    esac
    
    while [[ $page -le $MAX_PAGES ]]; do
        if [[ "$VERBOSE" == true ]]; then
            echo -e "${CYAN}Fetching page $page...${NC}"
        fi
        
        # API call
        api_response=$(gh api -X GET "search/users" -f q="$SEARCH_QUERY" -f per_page=$RESULTS_PER_PAGE -f page=$page 2>/dev/null)
        
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}API request failed. Check your gh CLI authentication.${NC}"
            break
        fi
        
        # Extract users
        users=$(echo "$api_response" | jq -r '.items[]?.login' 2>/dev/null)
        total_count=$(echo "$api_response" | jq -r '.total_count' 2>/dev/null)
        
        if [[ -z "$users" ]]; then
            echo -e "${YELLOW}No more users found.${NC}"
            break
        fi
        
        # Process each user
        user_count=0
        while IFS= read -r username; do
            if [[ -n "$username" && "$username" != "null" ]]; then
                ((total_found++))
                ((user_count++))
                
                if [[ "$VERBOSE" == true ]]; then
                    echo -e "${GREEN}Found: @${username}${NC}"
                fi
                
                # Get detailed user info
                user_info=$(gh api -X GET "users/$username" 2>/dev/null)
                
                # Extract user details
                name=$(echo "$user_info" | jq -r '.name // "N/A"')
                bio=$(echo "$user_info" | jq -r '.bio // "N/A"')
                location=$(echo "$user_info" | jq -r '.location // "N/A"')
                repos=$(echo "$user_info" | jq -r '.public_repos // 0')
                followers=$(echo "$user_info" | jq -r '.followers // 0')
                following=$(echo "$user_info" | jq -r '.following // 0')
                created=$(echo "$user_info" | jq -r '.created_at // "N/A"')
                updated=$(echo "$user_info" | jq -r '.updated_at // "N/A"')
                
                # Format output
                case "$OUTPUT_FORMAT" in
                    json)
                        if [[ $total_found -gt 1 ]]; then
                            echo "," >> "$output_file"
                        fi
                        cat >> "$output_file" << EOF
{
  "username": "$username",
  "name": "$name",
  "bio": "$bio",
  "location": "$location",
  "public_repos": $repos,
  "followers": $followers,
  "following": $following,
  "created_at": "$created",
  "updated_at": "$updated"
}
EOF
                        ;;
                    csv)
                        echo "\"$username\",\"$name\",\"$bio\",\"$location\",\"$repos\",\"$followers\",\"$following\",\"$created\",\"$updated\"" >> "$output_file"
                        ;;
                    txt)
                        cat >> "$output_file" << EOF
@${username}
Name: $name
Location: $location
Bio: $bio
Repositories: $repos
Followers: $followers
Following: $following
Created: $created
Updated: $updated
────────────────────────────────────────────────────────────
EOF
                        ;;
                esac
                
                # Show progress
                show_progress $total_found $total_count
            fi
        done <<< "$users"
        
        # Check if we got all results
        if [[ $user_count -lt $RESULTS_PER_PAGE ]]; then
            echo ""
            echo -e "${GREEN}All results fetched!${NC}"
            break
        fi
        
        ((page++))
        
        # Rate limiting - be nice to GitHub
        sleep 1
    done
    
    # Close output file
    case "$OUTPUT_FORMAT" in
        json)
            echo "" >> "$output_file"
            echo "]" >> "$output_file"
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}Search completed!${NC}"
    echo -e "${CYAN}Total users found: ${WHITE}$total_found${NC}"
    echo -e "${CYAN}Results saved to: ${WHITE}$output_file${NC}"
    
    # Generate summary
    if [[ "$VERBOSE" == true ]]; then
        echo ""
        echo -e "${BLUE}Search Summary:${NC}"
        echo -e "${WHITE}• Query: $SEARCH_QUERY${NC}"
        echo -e "${WHITE}• Pages fetched: $((page - 1))${NC}"
        echo -e "${WHITE}• Users per page: $RESULTS_PER_PAGE${NC}"
        echo -e "${WHITE}• Total results: $total_found${NC}"
        echo -e "${WHITE}• Output file: $output_file${NC}"
    fi
}

# Check dependencies
if ! command -v gh &> /dev/null; then
    echo -e "${RED}GitHub CLI (gh) is not installed. Install it first:${NC}"
    echo -e "${YELLOW}https://cli.github.com/manual/installation${NC}"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${RED}jq is not installed. Install it first:${NC}"
    echo -e "${YELLOW}sudo apt install jq${NC}"
    exit 1
fi

# Check gh authentication
if ! gh auth status &> /dev/null; then
    echo -e "${RED}GitHub CLI not authenticated. Run: ${YELLOW}gh auth login${NC}"
    exit 1
fi

# Run the search
search_github_users

echo ""
echo -e "${PURPLE}Happy Hunting!${NC}"
