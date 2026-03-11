# example.pde.rcp

Showcase for Eclipse RCP products and applications

* providing UI and headless applications
* using feature, plugin and mixed based products
* provided on different OS (linux, macosx, win32) and different Processors (aarch64, x86_64)
* running on Java 21
* builded by Maven Tycho build version 5.0.2
* release process for proper snapshot and release versioning
* deploying of builded products and repositories
    * maven-based [Reposilite}(https://reposilite.klib.io) repository
    * github releases
* documentation via github pages
    * provide download of latest build artifacts
    * provide p2.director and maven tycho based instructions on product installations

## Source repository

https://github.com/klibio/example.pde.rcp

## Quick Links

- [Downloads](downloads) — latest artifacts from the last successful build on `main`
- [Installation Guide](installation)

<sup>last edit: {{ 'now' | date: "%Y%m%d-%H%M%S" }}</sup><br/>
{% assign source_revision = site.source_revision | default: site.github.build_revision %}
{% assign repository_nwo = site.github.repository_nwo | default: site.repository | default: 'klibio/example.pde.rcp' %}
{% if source_revision and source_revision != '' %}
<sup>source-revision: <a href="https://github.com/{{ repository_nwo }}/commit/{{ source_revision }}">{{ source_revision | slice: 0, 12 }}</a></sup>
{% else %}
<sup>source-revision:n/a</sup>
{% endif %}