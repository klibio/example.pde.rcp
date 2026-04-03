# Copilot Instructions for example.pde.rcp

## Overview

This repository contains Eclipse RCP and Equinox examples built with a pomless Tycho layout. The workspace produces bundles, features, p2 repositories, and packaged products for multiple platforms.

Link to existing docs instead of repeating them:

- `README.md` for the main build and release flow
- `_doc/installation.md` for product installation
- `certificate/README_signing.md` for signing setup
- `features/example.rcp.feature.touchpoint/README_p2touchpoint.md` for the custom p2 touchpoint example

## Build And Toolchain

- Language: Java 21+
- Build tool: Maven Wrapper with Tycho 5.0.2
- Build entrypoint: `./build.sh`
- Tycho version and Maven settings are injected from `.mvn/maven.config`
- The build writes logs into `_log/`

Use these commands:

```bash
# Local verification build
./build.sh

# Print effective settings and other diagnostics
./build.sh --diag

# Build with signing enabled
./build.sh --jar-signing --gpg-signing

# Build and deploy to configured Maven repositories
./build.sh --jar-signing --gpg-signing --deploy

# Set release version
./mvnw org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=X.Y.Z

# Set next development version
./mvnw org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=X.Y.Z-SNAPSHOT
```

## Repository Structure

- `bundles/`: top-level application bundles such as `example.rcp.app.ui`, `example.rcp.headless`, `example.rcp.touchpoint`, and `example.rcp.view`
- `comp1/` and `comp2/`: example domain components with their own bundles and features
- `features/`: root features and container features such as `example.rcp.feature.all`
- `releng/products/`: product definitions and packaged product outputs
- `releng/repo.binary/` and `releng/repo.sdk/`: p2 repository assembly
- `releng/target.platform/`: target platform definition
- `tests/`: unit and integration/UI test bundles

## Product Variants

The build defines these product IDs in `pom.xml`:

- `example.rcp.app.ui.feature.product`
- `example.rcp.app.ui.plugin.product`
- `example.rcp.app.ui.mixed.product`
- `example.rcp.headless.feature.product`

Target environments:

- macOS: `cocoa/aarch64`, `cocoa/x86_64`
- Linux: `gtk/aarch64`, `gtk/x86_64`
- Windows: `win32/x86_64`

## Conventions And Pitfalls

1. Keep the pomless Tycho layout intact. Files such as `.polyglot.pom.tycho`, `feature.xml`, `target-platform.target`, and `no_deploy.txt` are used by `.mvn/settings.xml` to activate Maven profiles. Do not remove or rename these marker files casually.
2. Do not bypass `.mvn/maven.config`. It provides the Tycho version, settings file, toolchains file, and thread count. If Tycho placeholders do not resolve, check this file first.
3. `build.sh` enforces Java 21 or newer. If the environment does not satisfy that requirement, the build exits before Maven runs.
4. Bundle and feature versions follow Tycho qualifier conventions. Avoid hardcoding timestamped versions.
5. When changing OSGi dependencies, update the relevant `MANIFEST.MF`, feature definitions, and product definitions together.
6. The integration test bundle `tests/example.rcp.tests.it` is a fragment of `example.rcp.app.ui` and enables `useUIHarness=true`. Fragment host version mismatches will break the test build.
7. The custom p2 touchpoint action lives in `bundles/example.rcp.touchpoint`. Normal builds keep the example action disabled in `p2.inf` for determinism.
8. Signing is optional and based on the demo configuration in `certificate/`. `build.sh` reads `certificate/sign.properties` when available.
9. Generated output under `target/` and `_log/` should not be treated as source of truth when editing code.

## GitHub Actions Security

All GitHub Actions steps must reference actions by their full commit SHA, not by a mutable tag or branch. This prevents supply-chain attacks where a tag could be silently moved to a different (malicious) commit.

Format: `uses: owner/repo@<full-commit-sha> # vX` — always include a trailing comment with the human-readable version so the SHA can be verified.

Example:
```yaml
uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6
```

When adding a new action or upgrading an existing one:
1. Look up the commit SHA for the desired tag (e.g. via `git ls-remote https://github.com/owner/repo.git refs/tags/vX`).
2. Use the dereferenced commit SHA (`refs/tags/vX^{}`), not the tag-object SHA.
3. Append a comment with the version tag for human readability.
4. Update `dependabot.yml` keeps the `github-actions` ecosystem enabled so Dependabot can propose SHA-bump PRs automatically.

## When Making Changes

- Preserve existing OSGi and Eclipse RCP patterns instead of introducing non-standard build wiring.
- Prefer changing the smallest relevant bundle, feature, or product definition rather than broad cross-repo edits.
- Validate with `./build.sh` after build-related, manifest, feature, target-platform, or product changes.
- For signing or deployment changes, verify the required environment variables before editing build logic.
- For UI changes, consider all target platforms because SWT and product packaging are cross-platform.

## Files To Inspect First

- `pom.xml`
- `build.sh`
- `.mvn/maven.config`
- `.mvn/settings.xml`
- `releng/target.platform/target-platform.target`
- `tests/example.rcp.tests.it/pom.xml`

## AI Agent Guidance

- Link to the existing documentation files above instead of copying long instructions into new files.
- When answering repo questions, prefer verified build facts from `build.sh`, `.mvn/`, and `pom.xml` over stale generated output or assumptions.
- If a user asks for test generation around the RCP UI, inspect `tests/example.rcp.tests.it` first because UI test behavior differs from the root Tycho surefire defaults.
