#!/usr/bin/env bash
set -euo pipefail

THRESHOLD_PCT="${EMERGENCY_THRESHOLD_PCT:-85}"
STATE_DIR="/var/lib/oci-emergency-disk-guard"
SERVICES=(
  a2a-sin-code-backend
  a2a-sin-code-command
  a2a-sin-code-frontend
  a2a-sin-code-fullstack
  a2a-sin-code-plugin
  a2a-sin-code-tool
)

log() {
  logger -t oci-emergency-disk-guard -- "$*" || true
  printf '%s\n' "$*" >&2 || true
}

current_use_pct() {
  df -P / | awk 'NR==2 {gsub("%", "", $5); print $5+0}'
}

current_avail_gb() {
  df -BG --output=avail / | awk 'NR==2 {gsub("G", "", $1); print $1+0}'
}

run_fast_mitigations() {
  if [ -x /usr/local/bin/cleanup-runner-libs.sh ]; then
    /usr/local/bin/cleanup-runner-libs.sh >/dev/null 2>&1 || true
  fi
  if [ -x /usr/local/bin/oci-log-rotation.sh ]; then
    /usr/local/bin/oci-log-rotation.sh >/dev/null 2>&1 || true
  fi
}

stop_services() {
  local stopped=0
  for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc"; then
      systemctl stop "$svc" || true
      stopped=$((stopped + 1))
    fi
  done
  printf '%s' "$stopped"
}

before_pct="$(current_use_pct)"
before_avail="$(current_avail_gb)"

if [ "$before_pct" -lt "$THRESHOLD_PCT" ]; then
  log "no emergency stop needed root=${before_pct}% avail=${before_avail}G threshold=${THRESHOLD_PCT}%"
  exit 0
fi

log "threshold exceeded root=${before_pct}% avail=${before_avail}G threshold=${THRESHOLD_PCT}% - applying fast mitigations"
run_fast_mitigations

after_pct="$(current_use_pct)"
after_avail="$(current_avail_gb)"
if [ "$after_pct" -lt "$THRESHOLD_PCT" ]; then
  log "recovered without stopping services root=${after_pct}% avail=${after_avail}G threshold=${THRESHOLD_PCT}%"
  exit 0
fi

mkdir -p "$STATE_DIR"
stopped_count="$(stop_services)"
timestamp="$(date -u +%FT%TZ)"
cat > "$STATE_DIR/last-stop.txt" <<EOF
timestamp=$timestamp
before_pct=$before_pct
after_pct=$after_pct
before_avail_gb=$before_avail
after_avail_gb=$after_avail
threshold_pct=$THRESHOLD_PCT
stopped_count=$stopped_count
services=${SERVICES[*]}
EOF

log "emergency stop triggered root=${after_pct}% avail=${after_avail}G threshold=${THRESHOLD_PCT}% stopped=${stopped_count}"
