# Automotive fork maintenance

This fork carries narrowly scoped compiler fixes while they are prepared for
upstream review. It does not contain proprietary compilers, licenses, product
source, private package credentials, or internal build logs.

## Maintained changes

The combined integration branch is `automotive/compiler-support`.

| Area | Change | Focused upstream branch |
| --- | --- | --- |
| Preprocessor manifests | Recognize standard `#line` directives correctly | `upstream/fix-line-directive` |
| TASKING VX | Expand `-f` and `--option-file` arguments safely | `upstream/tasking-option-files` |
| Compiler detection | Forward GNU/Clang target options, including response files | `upstream/forward-target-options` |

Wind River Diab was validated against the current implementation without a
source change. Its observed issues were downstream launcher and license
environment configuration.

## Validation expectations

Before updating the combined branch or creating a package:

```sh
cargo fmt -- --check
cargo clippy --locked --all-targets -- -D warnings -A unknown-lints \
    -A clippy::type_complexity -A clippy::new-without-default
cargo test --locked --lib --bins --tests
```

Each proprietary compiler change must also be tested with a licensed real
compiler, an unchanged warm rebuild, and cached-versus-pass-through output
comparison. Only sanitized aggregate results belong in this public repository.

## Private package workflow

Private packages are built from an exact combined-branch commit by downstream
packaging infrastructure. The package name is kept separate from upstream
distributions so product lockfiles cannot silently switch implementations.

1. Validate the focused source changes and the combined branch.
2. Pin the packaging recipe to the exact source commit.
3. Build Linux packages on Linux and Windows packages on Windows.
4. Test package startup and real licensed compilers on each platform.
5. Publish through externally configured credentials and normal TLS
   verification.
6. Update product lockfiles only after the platform-specific artifact passes.

Do not claim a platform is supported merely because the recipe renders. A
platform is supported only after its native package has been built, installed,
and exercised with the relevant compiler workflow.

## Prefix.dev packages

The repository workflow at `.github/workflows/prefix.yml` builds native
`linux-64`, `win-64`, `osx-64`, and `osx-arm64` packages and publishes them to
the `@jamesoldiges/bobs-forge` channel. To enable its trusted publisher, enter
the following values in the channel's repository-access settings:

- GitHub owner: `Joldiges`
- Repository: `sccache_automotive`
- Workflow file: `prefix.yml`
- Environment: leave blank

The workflow uses GitHub OIDC, so it does not need a repository secret. It
publishes on pushes to `main`, version tags, and manual workflow dispatches.
After a package is published, it can be installed with:

```sh
pixi global install sccache --channel https://prefix.dev/channels/@jamesoldiges/bobs-forge
conda install -c https://prefix.dev/channels/@jamesoldiges/bobs-forge sccache
```

## Upstreaming

Keep independent root causes on independent branches. PR descriptions should be
short, tests must accompany behavior changes, and reviewer replies must be
written by the human submitter in accordance with `AGENTS.md`.
