# Eclipse p2 touchpoint

* [Eclipse help - p2 actions touchpoint](https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Fguide%2Fp2_actions_touchpoints.html&resultof%3D%2522%2574%256f%2575%2563%2568%2570%256f%2569%256e%2574%2522%2520)

* [Custom touchpoints in p2 - EclipseSource - Ian Bull](https://eclipsesource.com/blogs/2013/05/23/custom-touchpoints-in-p2/)
* [**MIND THE GAP: Tycho, Maven and p2.inf**](https://eclipsesource.com/blogs/2012/06/04/tycho-maven-p2-inf-2/)

## Tycho requirements

[Error resolving touchpoint action](https://stackoverflow.com/a/72619147)
[tycho-p2-director:materialize-products](https://tycho.eclipseprojects.io/doc/latest/tycho-p2-director-plugin/materialize-products-mojo.html)

## Custom touchpoint action scaffold in this repository

This project now contains a minimal custom action provider bundle:

- bundle: `example.rcp.touchpoint`
- extension point: `org.eclipse.equinox.p2.engine.actions`
- action name: `log`
- touchpoint type: `org.eclipse.equinox.p2.osgi`

To invoke it from `p2.inf`, use e.g.:

```properties
instructions.configure = \
	example.rcp.touchpoint.log(message:hello from p2);
instructions.configure.import = \
	example.rcp.touchpoint.log
```

Note: this is intentionally not enabled by default in `p2.inf` so normal builds stay deterministic.
