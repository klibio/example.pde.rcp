# Installation Guide

This document describes how to install each product configuration from the p2 repository.

## Product Configurations

The p2 repository contains the following product configurations:

| Product ID | Type | Description |
|---|---|---|
| `example.rcp.app.ui.feature.product` | feature-based | Eclipse RCP UI application (feature installation) |
| `example.rcp.app.ui.plugin.product` | bundle-based | Eclipse RCP UI application (explicit bundle list) |
| `example.rcp.app.ui.mixed.product` | mixed | Eclipse RCP UI application (features + explicit plugins) |
| `example.rcp.headless.feature.product` | feature-based | Eclipse RCP headless application |

## Target Platforms

Products are available for the following platform combinations:

| OS | Architecture | Archive Suffix |
|---|---|---|
| Linux | x86_64 | `linux.gtk.x86_64.tar.gz` |
| Linux | aarch64 | `linux.gtk.aarch64.tar.gz` |
| macOS | x86_64 | `macosx.cocoa.x86_64.tar.gz` |
| macOS | aarch64 | `macosx.cocoa.aarch64.tar.gz` |
| Windows | x86_64 | `win32.win32.x86_64.zip` |

---

## Installation via p2 Director

### Prerequisites

- [Eclipse p2 Director](https://wiki.eclipse.org/Equinox/p2/Director_application) or
- Eclipse IDE with p2 tooling

Set the repository URL (replace `<repo-url>` with the actual p2 repository URL, e.g. from a GitHub release):

```bash
REPO_URL=<repo-url>
INSTALL_DIR=/opt/example-rcp
```

### 1. Feature-based UI Product

```bash
# Linux/macOS
java -jar org.eclipse.equinox.launcher_*.jar \
  -application org.eclipse.equinox.p2.director \
  -repository "${REPO_URL}" \
  -installIU "example.rcp.app.ui.product" \
  -tag InitialState \
  -destination "${INSTALL_DIR}/feature" \
  -profile ExampleRcpFeature \
  -profileProperties "org.eclipse.update.install.features=true" \
  -p2.os linux -p2.ws gtk -p2.arch x86_64 \
  -roaming

# Windows (PowerShell)
java -jar org.eclipse.equinox.launcher_*.jar `
  -application org.eclipse.equinox.p2.director `
  -repository "$env:REPO_URL" `
  -installIU "example.rcp.app.ui.product" `
  -tag InitialState `
  -destination "$env:INSTALL_DIR\feature" `
  -profile ExampleRcpFeature `
  -profileProperties "org.eclipse.update.install.features=true" `
  -p2.os win32 -p2.ws win32 -p2.arch x86_64 `
  -roaming
```

### 2. Bundle-based UI Product

```bash
# Linux/macOS
java -jar org.eclipse.equinox.launcher_*.jar \
  -application org.eclipse.equinox.p2.director \
  -repository "${REPO_URL}" \
  -installIU "example.rcp.app.ui.product" \
  -tag InitialState \
  -destination "${INSTALL_DIR}/plugin" \
  -profile ExampleRcpPlugin \
  -p2.os linux -p2.ws gtk -p2.arch x86_64 \
  -roaming
```

### 3. Mixed UI Product

```bash
# Linux/macOS
java -jar org.eclipse.equinox.launcher_*.jar \
  -application org.eclipse.equinox.p2.director \
  -repository "${REPO_URL}" \
  -installIU "example.rcp.app.ui.product" \
  -tag InitialState \
  -destination "${INSTALL_DIR}/mixed" \
  -profile ExampleRcpMixed \
  -profileProperties "org.eclipse.update.install.features=true" \
  -p2.os linux -p2.ws gtk -p2.arch x86_64 \
  -roaming
```

### 4. Headless Product

```bash
# Linux/macOS
java -jar org.eclipse.equinox.launcher_*.jar \
  -application org.eclipse.equinox.p2.director \
  -repository "${REPO_URL}" \
  -installIU "example.rcp.headless.product" \
  -tag InitialState \
  -destination "${INSTALL_DIR}/headless" \
  -profile ExampleRcpHeadless \
  -p2.os linux -p2.ws gtk -p2.arch x86_64 \
  -roaming

# Run headless application
${INSTALL_DIR}/headless/example-rcp-headless
```

---

## Installation via Maven Tycho

You can also materialize products using Maven Tycho's p2 director plugin.

### Prerequisites

- Java 21
- Maven 3.9+

### Build and materialize all products locally

```bash
# Build the project and materialize all products
./mvnw clean verify

# Products will be placed in releng/products/target/products/
```

### Materialize a specific product using Tycho director plugin

```bash
# Materialize the feature-based UI product for Linux x86_64
./mvnw org.eclipse.tycho:tycho-p2-director-plugin:materialize-products \
  -pl releng/products \
  -Dp2.os=linux -Dp2.ws=gtk -Dp2.arch=x86_64

# Materialize the headless product for Linux x86_64
./mvnw org.eclipse.tycho:tycho-p2-director-plugin:materialize-products \
  -pl releng/products \
  -Dp2.os=linux -Dp2.ws=gtk -Dp2.arch=x86_64
```

### Install from a p2 repository using Tycho director plugin

```bash
# Install feature-based UI product from remote repository
./mvnw org.eclipse.tycho:tycho-p2-director-plugin:director \
  -Ddestination=/opt/example-rcp/feature \
  -Drepository=<repo-url> \
  -DinstallIU=example.rcp.app.ui.product \
  -Dprofile=ExampleRcpFeature \
  -Dp2.os=linux -Dp2.ws=gtk -Dp2.arch=x86_64

# Install headless product from remote repository
./mvnw org.eclipse.tycho:tycho-p2-director-plugin:director \
  -Ddestination=/opt/example-rcp/headless \
  -Drepository=<repo-url> \
  -DinstallIU=example.rcp.headless.product \
  -Dprofile=ExampleRcpHeadless \
  -Dp2.os=linux -Dp2.ws=gtk -Dp2.arch=x86_64
```

---

## p2 Repository Structure

The build produces the following repositories and archives:

| Artifact | Description | Location |
|---|---|---|
| `repo.binary-*.zip` | Binary p2 repository with features and bundles | `releng/repo.binary/target/` |
| `repo.sdk-*.zip` | SDK p2 repository with sources | `releng/repo.sdk/target/` |
| `products-*.zip` | Product p2 repository | `releng/products/target/` |
| `example.rcp.app.ui.feature.product-*.<os>.<ws>.<arch>.*` | Feature-based UI product archives | `releng/products/target/` |
| `example.rcp.app.ui.plugin.product-*.<os>.<ws>.<arch>.*` | Bundle-based UI product archives | `releng/products/target/` |
| `example.rcp.app.ui.mixed.product-*.<os>.<ws>.<arch>.*` | Mixed UI product archives | `releng/products/target/` |
| `example.rcp.headless.feature.product-*.<os>.<ws>.<arch>.*` | Headless product archives | `releng/products/target/` |

### p2 Repository Categories

The binary p2 repository (`repo.binary`) contains the following categories:

| Category | Label | Contents |
|---|---|---|
| `category.example.rcp.ui` | Example RCP UI Applications | UI application features |
| `category.example.rcp.headless` | Example RCP Headless Applications | Headless application features |
| `category.example.rcp.all` | Example RCP All Features | All features including touchpoint |

### Eclipse Target Platform Reference

The products reference the following Eclipse base repositories:

- **Eclipse RCP 4.38**: `https://download.eclipse.org/eclipse/updates/4.38/R-4.38-202512010920`
  - `org.eclipse.equinox.sdk.feature.group`
  - `org.eclipse.rcp.feature.group`
  - `org.eclipse.equinox.executable.feature.group`
  - `org.eclipse.equinox.p2.engine`
