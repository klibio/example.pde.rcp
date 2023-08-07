# example for Eclipse RCP applications

[![Java Maven Tycho CI](https://github.com/klibio/example.pde.rcp/actions/workflows/build.yml/badge.svg)](https://github.com/klibio/example.pde.rcp/actions/workflows/build.yml)

## pre-requisites

based on github repo [klibio/bootstrap](https://github.com/klibio/bootstrap)

## tycho build example

contains examples of eclipse products, features and bundles/plugins for

* Equinox Headless application
* Eclipse 4 RCP UI application
* Components 1 + 2 containing features/bundles

and Maven Tycho build version 3.0.4 requiring Java 17

```
+
|- .mvn                     # containing tycho extension and custom toolchain
|
+- feature/                 # root feature folder
|   +- e.r.feature.all/         # container feature for everything
|   +- e.r.feature.app.ui/      # Eclipse RCP application UI feature
|   +- e.r.feature.headless/    # Headless application feature
|
+- bundles/                 # top-level product-bundles
|   +- e.r.app.ui/              # Eclipse RCP application UI bundle 
|   +- e.r.headless/            # Eclipse headless application bundle 
|   +- e.r.view/                # view bundle
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

```bash
./build.sh
```

## Useful analyse

### Output the generated poms
 `-Dpolyglot.dump.pom=pom.xml` just keep in mind that pom.xml takes precedence over pomless configuration, so maybe choose a different name if you only like to use this for debug purpose!

### outputs a tree view of the P2 dependecies of a tycho project 
MIND the hardcoded version
```bash
./mvnw \
    org.eclipse.tycho:tycho-p2-plugin:3.0.4:dependency-tree \
    --log-file log/build_$(date +%Y%m%d-%H%M%S).log
```

## Remarks

### creation of `example.rcp.app.ui.plugin.product`
    creating `example.rcp.app.ui.plugin.product` with only bundle `example.rcp.app.ui`
    and `Add Required Plugins` (Include optional dependencies is switched off)
    and `Running` is giving error 
    `org.eclipse.e4.core.di.InjectionException: java.lang.IllegalStateException: Could not create any rendering factory. Aborting ...`
    missing bundle `org.eclipse.e4.ui.workbench.renderers.swt`

## Links

### Tycho build

* [Eclipse Tycho Release overview](https://projects.eclipse.org/projects/technology.tycho)
* [Tycho Discussions](https://github.com/eclipse-tycho/tycho/discussions)
* [Tycho Release Doc - latest](https://tycho.eclipseprojects.io/doc/master/StructuredBuild.html)
* [Tycho Release Doc - Structured Build Layout and Pomless Builds](https://tycho.eclipseprojects.io/doc/master/StructuredBuild.html)
* [Tycho Wiki - Tycho Pomless](https://github.com/eclipse-tycho/tycho/wiki/Tycho-Pomless)

* [vogella Blog / Dirk Fauth - POM-less Tycho enhance ](https://www.vogella.com/blog/pom-less-tycho-enhanced/)
* [Eclipse Wiki - Tycho/FAQ  - ](https://wiki.eclipse.org/Tycho/FAQ)
* [Eclipse Wiki - Tycho/Dependency Resolution Troubleshooting](https://wiki.eclipse.org/Tycho/Dependency_Resolution_Troubleshooting)

### Maven

* [Configuring Apache Maven](https://maven.apache.org/configure.html)
