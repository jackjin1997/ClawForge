#!/usr/bin/env bash

# Fetch and basic extract GitHub Trending repos
# Usage: ./fetch_trending.sh [daily|weekly|monthly]

SPAN=${1:-daily}
URL="https://github.com/trending?since=$SPAN"

echo "### Fetching $SPAN trending from $URL..."
curl -s "$URL" | grep -A 20 'class="h3 lh-condensed"' | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed '/^$/d'
