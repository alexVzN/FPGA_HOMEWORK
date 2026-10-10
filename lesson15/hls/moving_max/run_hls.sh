#!/usr/bin/env bash
# Headless flow for one variant:
#   ./run_hls.sh hls_config.cfg build_a csim csynth cosim package
set -e
cd "$(dirname "$0")"
source "$HOME/Xilinx/2026.1/Vitis/settings64.sh"
cfg=${1:-hls_config.cfg}; work=${2:-build_a}; shift 2 || true
for step in "${@:-csim csynth}"; do
  if [ "$step" = csynth ]; then
    v++ -c --mode hls --config "$cfg" --work_dir "$work"
  else
    vitis-run --mode hls --"$step" --config "$cfg" --work_dir "$work"
  fi
done
