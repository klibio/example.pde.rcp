# example for Eclipse RCP applications

[![CI build](https://github.com/klibio/example.pde.rcp/actions/workflows/build.yml/badge.svg)](https://github.com/klibio/example.pde.rcp/actions/workflows/10_build-validation.yml)
[![SNAPSHOT build](https://github.com/klibio/example.pde.rcp/actions/workflows/build.yml/badge.svg)](https://github.com/klibio/example.pde.rcp/actions/workflows/10_snapshot-deployment.yml)
[![RELEASE build](https://github.com/klibio/example.pde.rcp/actions/workflows/build.yml/badge.svg)](https://github.com/klibio/example.pde.rcp/actions/workflows/10_release-deployment.yml)

[![release](https://reposilite.klib.io/api/badge/latest/releases/example/rcp/products/?color=40c14a&name=example.pde.rcp)](https://reposilite.klib.io/#/releases/example/rcp/products)
[![release](https://reposilite.klib.io/api/badge/latest/snapshots/example/rcp/products/?color=40c14a&name=example.pde.rcp)](https://reposilite.klib.io/#/snapshots/example/rcp/products)

## pre-requisites

based on github repo [klibio/bootstrap](https://github.com/klibio/bootstrap)

## tycho build example

contains examples of eclipse products, features and bundles/plugins for

* Equinox Headless application
* Eclipse 4 RCP UI Products application (feature and plugin based)
* Components 1 + 2 containing features/bundles

creating products for following os, ws, arch configurations

* macosx.cocoa.aarch64
* macosx.cocoa.x86_64
* linux.gtk.aarch64
* linux.gtk.x86_64
* win32.win32.x86_64

with Maven Tycho build version 4.0.4
using Java 17
signing with self-signed code certificate

## repository structure

```text
+
|- .mvn                     # containing tycho extension and custom toolchain
|
+- bundles/                 # top-level product-bundles
|   +- e.r.app.ui/              # Eclipse RCP application UI bundle 
|   +- e.r.headless/            # Eclipse headless application bundle 
|   +- e.r.view/                # view bundle
|
+- certificates/            # code-signing
|
+- comp1/                   # component 1 - domain feature
|   +- bundles/                 # comp1 bundle folder
|   |   +- e.r.comp1.view/          # comp1 view bundle
|   |   +- build.properties         # aggregator component1.bundles
|   |
|   +- features/            # comp1 feature folder
|   |   +- e.r.comp1.feature/   # comp1 feature
|   |   +- build.properties     # aggregator component1.features
|
+- comp2/                   # component 2 - domain feature
|   +- bundles/                 # comp2 bundle folder
|   |   +- e.r.comp2.view/          # comp2 view bundle
|   |   +- build.properties         # aggregator component2.bundles
|   |
|   +- features/                # comp1 feature folder
|   |   +- e.r.comp2.feature/       # comp2 feature
|   |   +- build.properties         # aggregator component2.features
|
+- feature/                 # root feature folder
|   +- e.r.feature.all/         # container feature for everything
|   +- e.r.feature.app.ui/      # Eclipse RCP application UI feature
|   +- e.r.feature.headless/    # Headless application feature
|
+- releng/                  # release engineering folder
|   +- e.r.products/            # products
|   +- e.r.site/                # repository/update site
|   +- target.platform/         # target platform
|
+- build.sh                 # execute build and create log file inside _log
|
+- pom.xml                  # parent pom containing modules for
                                feature
                                bundles
                                comp1/feature
                                comp1/bundles
                                comp2/feature
                                comp2/bundles
                                releng

```

## W-I-P



### deploy snapshot

```bash
# starting point is current development version e.g. 0.1.0-SNAPSHOT

# before the SNAPSHOT deployment , validate via local build
./build.sh --jar-signing --gpg-signing

# build and deploy bundle to SNAPSHOT repository
./build.sh --jar-signing --gpg-signing --deploy

# continue development until next deployment
```

### deploy release

```bash
# starting point is current development version e.g. 0.1.0-SNAPSHOT

# before the RELEASE deployment, validate via local build
./build.sh --jar-signing --gpg-signing

# set the release version before building and deploying
./mvnw org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=0.1.0

# build and deploy bundle to RELEASE repository
./build.sh --jar-signing --gpg-signing --deploy

# tag release
git tag -a rel_0.1.0 -m "release 0.1.0" && git push --tags

# start next development release cycle with new version e.g. 0.2.0-SNAPSHOT
./mvnw org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=0.2.0-SNAPSHOT

# start next development release cycle with new version 
git add . \
  && git commit -m "starting next dev cycle - new version 0.2.0-SNAPSHOT" \
  && git push

# continue development until next deployment
```

```bash
# deploy locally available repository to artifactory
releng/upload_to_artifactory.sh \
    $(pwd)/releng/repo.sdk/target/repository \
    smaragd-internet-mirror-generic-local \
    example.pde.rcp/repo.sdk/$(date +'%Y%m%d-%H%M%S')
```
```bash
./build.sh
```

## Useful analyse

### Output the generated poms

`-Dpolyglot.dump.pom=pom.xml` just keep in mind that pom.xml takes
precedence over pomless configuration, so maybe choose a different name
if you only like to use this for debug purpose!

### outputs a tree view of the P2 dependecies of a tycho project 

MIND the hardcoded version

```bash
./mvnw \
    org.eclipse.tycho:tycho-p2-plugin:4.0.7:dependency-tree \
    --log-file log/build_$(date +%Y%m%d-%H%M%S).log
```

## Remarks

### creation of `example.rcp.app.ui.plugin.product`

creating `example.rcp.app.ui.plugin.product` with only bundle `example.rcp.app.ui` \
and `Add Required Plugins` (Include optional dependencies is switched off) \
and `Running` is giving error \
`org.eclipse.e4.core.di.InjectionException: java.lang.IllegalStateException: Could not create any rendering factory. Aborting ...` \
missing bundle `org.eclipse.e4.ui.workbench.renderers.swt`

## Links

### Tycho build

* [Eclipse Tycho Release overview](https://projects.eclipse.org/projects/technology.tycho)
* [Tycho Discussions](https://github.com/eclipse-tycho/tycho/discussions)
* [Tycho Release Doc - latest](https://tycho.eclipseprojects.io/doc/master/StructuredBuild.html)
* [Tycho Release Doc - Structured Build Layout and Pomless Builds](https://tycho.eclipseprojects.io/doc/master/StructuredBuild.html)
* [Tycho Wiki - Tycho Pomless](https://github.com/eclipse-tycho/tycho/wiki/Tycho-Pomless)

* [vogella Blog / Dirk Fauth - POM-less Tycho enhance](https://www.vogella.com/blog/pom-less-tycho-enhanced/)
* [Eclipse Wiki - Tycho/FAQ](https://wiki.eclipse.org/Tycho/FAQ)
* [Eclipse Wiki - Tycho/Dependency Resolution Troubleshooting](https://wiki.eclipse.org/Tycho/Dependency_Resolution_Troubleshooting)

### Maven

* [Configuring Apache Maven](https://maven.apache.org/configure.html)
* [Maven Artifactory Plugin](https://github.com/jfrog/artifactory-maven-plugin)
* [Artifactory Maven Plugin example](https://github.com/jfrog/project-examples/tree/master/artifactory-maven-plugin-example)

### Errors occured during creation

* [How to configure maven-release-plugin to use maven-scm-provider-gitexe](https://stackoverflow.com/questions/50633906/how-to-configure-maven-release-plugin-to-use-maven-scm-provider-gitexe-shallow)
* [Eclipse wiki - Tycho Category](https://wiki.eclipse.org/Category:Tycho)
* [Tycho:How to deploy to a Maven repository](https://wiki.eclipse.org/Tycho:How_to_deploy_to_a_Maven_repository)
