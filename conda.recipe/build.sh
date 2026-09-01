#!/usr/bin/env bash
set -euxo pipefail

cargo-bundle-licenses --format yaml --output "${SRC_DIR}/THIRDPARTY.yml"
cargo install --locked --root "${PREFIX}" --path . --bin sccache
