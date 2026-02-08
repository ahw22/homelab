#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(pwd)"
DRY_RUN=false
NO_DOWN=false
EXCLUDES=()

# ---------- ARG PARSING ----------
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n)
            DRY_RUN=true
            ;;
        --no-down)
            NO_DOWN=true
            ;;
        --exclude=*)
            IFS=',' read -r -a EXCLUDES <<< "${arg#*=}"
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

is_excluded() {
    local name="$1"
    for ex in "${EXCLUDES[@]}"; do
        [[ "$name" == "$ex" ]] && return 0
    done
    return 1
}

has_compose() {
    [[ -f docker-compose.yml \
    || -f docker-compose.yaml \
    || -f compose.yml \
    || -f compose.yaml ]]
}

# ---------- HEADER ----------
echo "Docker Compose updater"
echo "Base dir: $BASE_DIR"

$DRY_RUN && echo "⚠ DRY-RUN MODE"
$NO_DOWN && echo "⚠ NO-DOWN MODE"
[[ ${#EXCLUDES[@]} -gt 0 ]] && echo "⚠ Excluding: ${EXCLUDES[*]}"

echo "---------------------------------------------"

# ---------- ORDERED STACKS ----------
PRIORITY_STACKS=(traefik redis)
ALL_DIRS=()

for dir in */; do
    ALL_DIRS+=("${dir%/}")
done

PROCESS_ORDER=()

for p in "${PRIORITY_STACKS[@]}"; do
    [[ -d "$p" ]] && PROCESS_ORDER+=("$p")
done

for d in "${ALL_DIRS[@]}"; do
    [[ ! " ${PROCESS_ORDER[*]} " =~ " $d " ]] && PROCESS_ORDER+=("$d")
done

# ---------- MAIN LOOP ----------
for dir in "${PROCESS_ORDER[@]}"; do
    is_excluded "$dir" && {
        echo "⏭ Skipping $dir (excluded)"
        continue
    }

    (
        cd "$BASE_DIR/$dir" || exit 0

        has_compose || {
            echo "⏭ Skipping $dir (no compose file)"
            exit 0
        }

        echo ""
        echo "▶ Stack: $dir"

        run docker compose pull

        if ! $NO_DOWN; then
            run docker compose down
        fi

        run docker compose up -d
        echo "✔ Done: $dir"
    )
done

echo ""
echo "All stacks processed."

