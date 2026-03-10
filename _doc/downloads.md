---
title: Downloads
---
# Latest Build Artifacts

This page provides a stable link to the latest artifacts from the last successful build on the `main` branch.
Artifact information is loaded directly from the [GitHub Actions API](https://docs.github.com/en/rest/actions/artifacts).

<div id="build-info">
  <p id="loading-msg">&#9203; Loading latest build information from GitHub&hellip;</p>

  <div id="build-details" style="display:none">
    <blockquote>
      <strong>Latest Build:</strong>
      Run <a id="run-link" href="#">#<span id="run-number"></span></a>
      &nbsp;|&nbsp;
      <strong>Committed:</strong> <span id="run-date"></span>
    </blockquote>

    <h2>Product Archives</h2>
    <table>
      <thead>
        <tr>
          <th>Product</th>
          <th>OS</th>
          <th>Architecture</th>
          <th>Download</th>
        </tr>
      </thead>
      <tbody id="products-table"></tbody>
    </table>

    <h2>P2 Repositories</h2>
    <table>
      <thead>
        <tr>
          <th>Repository</th>
          <th>Description</th>
          <th>Download</th>
        </tr>
      </thead>
      <tbody id="repos-table"></tbody>
    </table>

    <blockquote>
      &#8505;&#65039; <strong>Note:</strong> Downloading artifacts requires a
      <a href="https://github.com/login">GitHub account</a>.
      If a download link does not start automatically, please log in to GitHub first.
    </blockquote>
  </div>

  <div id="error-msg" style="display:none">
    <p>&#9888;&#65039; Could not load artifact information automatically.</p>
    <p>
      Please visit the
      <a href="https://github.com/klibio/example.pde.rcp/actions/workflows/10_build-validation.yml">
        GitHub Actions workflow page
      </a>
      and open the latest successful run to download artifacts manually.
    </p>
  </div>
</div>

<script>
(function () {
  'use strict';

  var REPO     = 'klibio/example.pde.rcp';
  var WORKFLOW = '10_build-validation.yml';

  /* Human-readable metadata for every artifact produced by the build workflow */
  var ARTIFACT_META = {
    /* Feature-based UI product */
    'example.rcp.app.ui.feature.product-linux.gtk.x86_64':     { product: 'Feature UI', os: 'Linux',   arch: 'x86_64',  repo: false },
    'example.rcp.app.ui.feature.product-linux.gtk.aarch64':    { product: 'Feature UI', os: 'Linux',   arch: 'aarch64', repo: false },
    'example.rcp.app.ui.feature.product-macosx.cocoa.x86_64':  { product: 'Feature UI', os: 'macOS',   arch: 'x86_64',  repo: false },
    'example.rcp.app.ui.feature.product-macosx.cocoa.aarch64': { product: 'Feature UI', os: 'macOS',   arch: 'aarch64', repo: false },
    'example.rcp.app.ui.feature.product-win32.win32.x86_64':   { product: 'Feature UI', os: 'Windows', arch: 'x86_64',  repo: false },
    /* Plugin-based UI product */
    'example.rcp.app.ui.plugin.product-linux.gtk.x86_64':      { product: 'Plugin UI',  os: 'Linux',   arch: 'x86_64',  repo: false },
    'example.rcp.app.ui.plugin.product-linux.gtk.aarch64':     { product: 'Plugin UI',  os: 'Linux',   arch: 'aarch64', repo: false },
    'example.rcp.app.ui.plugin.product-macosx.cocoa.x86_64':   { product: 'Plugin UI',  os: 'macOS',   arch: 'x86_64',  repo: false },
    'example.rcp.app.ui.plugin.product-macosx.cocoa.aarch64':  { product: 'Plugin UI',  os: 'macOS',   arch: 'aarch64', repo: false },
    'example.rcp.app.ui.plugin.product-win32.win32.x86_64':    { product: 'Plugin UI',  os: 'Windows', arch: 'x86_64',  repo: false },
    /* Mixed UI product */
    'example.rcp.app.ui.mixed.product-linux.gtk.x86_64':       { product: 'Mixed UI',   os: 'Linux',   arch: 'x86_64',  repo: false },
    'example.rcp.app.ui.mixed.product-linux.gtk.aarch64':      { product: 'Mixed UI',   os: 'Linux',   arch: 'aarch64', repo: false },
    'example.rcp.app.ui.mixed.product-macosx.cocoa.x86_64':    { product: 'Mixed UI',   os: 'macOS',   arch: 'x86_64',  repo: false },
    'example.rcp.app.ui.mixed.product-macosx.cocoa.aarch64':   { product: 'Mixed UI',   os: 'macOS',   arch: 'aarch64', repo: false },
    'example.rcp.app.ui.mixed.product-win32.win32.x86_64':     { product: 'Mixed UI',   os: 'Windows', arch: 'x86_64',  repo: false },
    /* Headless product */
    'example.rcp.headless.feature.product-linux.gtk.x86_64':   { product: 'Headless',   os: 'Linux',   arch: 'x86_64',  repo: false },
    'example.rcp.headless.feature.product-linux.gtk.aarch64':  { product: 'Headless',   os: 'Linux',   arch: 'aarch64', repo: false },
    'example.rcp.headless.feature.product-macosx.cocoa.x86_64':  { product: 'Headless', os: 'macOS',   arch: 'x86_64',  repo: false },
    'example.rcp.headless.feature.product-macosx.cocoa.aarch64': { product: 'Headless', os: 'macOS',   arch: 'aarch64', repo: false },
    'example.rcp.headless.feature.product-win32.win32.x86_64':   { product: 'Headless', os: 'Windows', arch: 'x86_64',  repo: false },
    /* P2 repositories */
    'repo.binary':   { product: 'repo.binary',   description: 'Binary p2 repository (features &amp; bundles)', repo: true },
    'repo.sdk':      { product: 'repo.sdk',      description: 'SDK p2 repository (with sources)',               repo: true },
    'repo.products': { product: 'repo.products', description: 'Products p2 repository',                         repo: true }
  };

  function esc(str) {
    var d = document.createElement('div');
    d.appendChild(document.createTextNode(String(str)));
    return d.innerHTML;
  }

  function fetchJSON(url) {
    return fetch(url).then(function (r) {
      if (!r.ok) { throw new Error('HTTP ' + r.status + ' for ' + url); }
      return r.json();
    });
  }

  function loadArtifacts() {
    var runsUrl = 'https://api.github.com/repos/' + REPO +
      '/actions/workflows/' + WORKFLOW +
      '/runs?branch=main&status=success&per_page=1';

    fetchJSON(runsUrl)
      .then(function (runsData) {
        if (!runsData.workflow_runs || runsData.workflow_runs.length === 0) {
          throw new Error('No successful runs found');
        }
        var run = runsData.workflow_runs[0];
        var artifactsUrl = 'https://api.github.com/repos/' + REPO +
          '/actions/runs/' + run.id + '/artifacts?per_page=100';

        return fetchJSON(artifactsUrl).then(function (artifactsData) {
          renderPage(run, artifactsData.artifacts || []);
        });
      })
      .catch(function (err) {
        console.error('Failed to load artifacts:', err);
        document.getElementById('loading-msg').style.display = 'none';
        document.getElementById('error-msg').style.display = 'block';
      });
  }

  function renderPage(run, artifacts) {
    document.getElementById('run-link').href = run.html_url;
    document.getElementById('run-number').textContent = run.run_number;
    document.getElementById('run-date').textContent = new Date(run.created_at).toUTCString();

    var byName = {};
    artifacts.forEach(function (a) { byName[a.name] = a; });

    var productsTbody = document.getElementById('products-table');
    var reposTbody    = document.getElementById('repos-table');

    Object.keys(ARTIFACT_META).sort().forEach(function (name) {
      var meta     = ARTIFACT_META[name];
      var artifact = byName[name];
      var downloadCell = artifact
        ? '<a href="' + esc(artifact.archive_download_url) + '">\u2b07 Download</a>'
        : '<em>not available</em>';

      if (meta.repo) {
        var row = document.createElement('tr');
        row.innerHTML =
          '<td><code>' + esc(meta.product) + '</code></td>' +
          '<td>' + meta.description + '</td>' +
          '<td>' + downloadCell + '</td>';
        reposTbody.appendChild(row);
      } else {
        var row = document.createElement('tr');
        row.innerHTML =
          '<td>' + esc(meta.product) + '</td>' +
          '<td>' + esc(meta.os) + '</td>' +
          '<td>' + esc(meta.arch) + '</td>' +
          '<td>' + downloadCell + '</td>';
        productsTbody.appendChild(row);
      }
    });

    document.getElementById('loading-msg').style.display  = 'none';
    document.getElementById('build-details').style.display = 'block';
  }

  loadArtifacts();
}());
</script>

<sup>last edit: {{ 'now' | date: "%Y%m%d-%H%M%S" }}</sup>
