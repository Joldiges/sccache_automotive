@echo on

cargo-bundle-licenses --format yaml --output "%SRC_DIR%\THIRDPARTY.yml"
if %ERRORLEVEL% neq 0 exit 1
set "CARGO_HOME=%TEMP%\cargo-home"
set "CFLAGS=%CFLAGS% /std:c11"
set "AWS_LC_SYS_NO_JITTER_ENTROPY=1"
cargo install --locked --root "%PREFIX%" --path . --bin sccache
if %ERRORLEVEL% neq 0 exit 1
