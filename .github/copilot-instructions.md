# Copilot Instructions for example.pde.rcp

## Overview

This repository contains examples for Eclipse RCP applications built using Java and Maven with Tycho for p2-based products.

## Build System

- **Language**: Java 17
- **Build Tool**: Maven with Tycho 4.0.4
- **Build Type**: P2-based product build
- **Results**: Bundles, p2 products, repositories, and archives

## Build Commands

```bash
# Local build
./build.sh

# Build with signing
./build.sh --jar-signing --gpg-signing

# Build with signing and deploy
./build.sh --jar-signing --gpg-signing --deploy
```

## Project Structure

The repository follows a structured Tycho build layout with pomless builds:

- **bundles/** - Top-level product bundles
  - Eclipse RCP application UI bundle
  - Eclipse headless application bundle
  - View bundles

- **comp1/** and **comp2/** - Component/domain features
  - Each contains bundles/ and features/ subdirectories

- **features/** - Root feature folder
  - Container features for different application types

- **releng/** - Release engineering folder
  - Products configuration
  - Repository/update site
  - Target platform

## Target Platforms

Products are built for:
- macOS (cocoa.aarch64, cocoa.x86_64)
- Linux (gtk.aarch64, gtk.x86_64)
- Windows (win32.x86_64)

## Code Signing

- Uses self-signed code certificates
- Configuration in `certificate/` directory

## Version Management

```bash
# Set release version
./mvnw org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=X.Y.Z

# Set development version
./mvnw org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=X.Y.Z-SNAPSHOT
```

## Important Conventions

1. Follow pomless Tycho build structure
2. Bundles use OSGi bundle conventions
3. Features define product compositions
4. Products are defined in releng/e.r.products/
5. All Maven coordinates use groupId: `example.rcp`

## When Making Changes

- Ensure changes maintain compatibility with Tycho 4.0.4
- Follow existing OSGi/Eclipse RCP patterns
- Update MANIFEST.MF files when changing bundle dependencies
- Test builds locally before committing
- Consider all target platforms when making UI changes
