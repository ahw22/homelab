#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(pwd)"
DRY_RUN=false

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n)
            DRY_RUN=true
            ;;
        *)
            echo "Unknown option: $arg"
            exit 1
            ;;
    esac
done

run() {
    if $DRY_RUN; then
        echo "    $*"
    else
        "$@"
    fi
}

echo "Starting Docker Compose updates in: $BASE_DIR"

if $DRY_RUN; then
    echo "⚠ DRY-RUN MODE ENABLED (no commands will be executed)"
fi

echo "---------------------------------------------"

for dir in */; do
    dir="${dir%/}"

    (
        cd "$BASE_DIR/$dir" || exit 0

        if [[ -f docker-compose.yml \
           || -f docker-compose.yaml \
           || -f compose.yml \
           || -f compose.yaml ]]; then

            echo ""
            echo "▶ Stack: $dir"

            run docker compose pull
            run docker compose down
            run docker compose up -d

            echo "✔ Done: $dir"
        else
            echo "⏭ Skipping $dir (no compose file)"
        fi
    )
done

echo ""
echo "All stacks processed."

