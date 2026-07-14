# Usager

Todos tus límites de uso de IA, juntos en la barra de menú de macOS.

Usager muestra cuotas, créditos, costos y tiempos de reinicio de tus proveedores de IA sin obligarte a abrir cada servicio. Su vista Overview permite comparar hasta seis proveedores al mismo tiempo y expandir solamente el que necesita más detalle.

> Versión actual: **0.1.0** · macOS 14 o posterior · Swift 6.2+

![Usager mostrando múltiples proveedores](docs/usager.png)

## Características

- Overview configurable con varios proveedores visibles simultáneamente.
- Seguimiento de sesión, límites semanales y mensuales, créditos y costos.
- Más de 50 integraciones heredadas del proyecto original.
- Aplicación de barra de menú, sin icono permanente en el Dock.
- Procesamiento local y reutilización optativa de sesiones existentes.
- CLI para consultas y automatizaciones.
- Diseño oscuro con una única señal verde y materiales Liquid Glass en macOS compatible.

## Privacidad

Usager no envía tus credenciales a un servidor propio. Según el proveedor habilitado, puede leer configuraciones conocidas, sesiones locales, cookies autorizadas o claves de API. Las credenciales y los datos sensibles no deben incluirse en issues ni reportes públicos.

Algunas integraciones pueden solicitar acceso al Llavero o acceso completo al disco para leer sesiones de Safari. Son permisos opcionales y dependen del proveedor elegido.

## Compilar

```bash
swift build
./Scripts/package_app.sh
open Usager.app
```

Para validar el proyecto completo:

```bash
make check
make test
```

## Versión 0.1

Esta primera versión pública prioriza una base estable para iterar seguido. Las próximas versiones mejorarán el empaquetado firmado, la documentación de proveedores y la sincronización controlada con el proyecto original.

## Origen y licencia

Usager es un fork independiente de [CodexBar](https://github.com/steipete/CodexBar), creado por Peter Steinberger y distribuido bajo licencia MIT. Esta variante conserva su licencia y atribución original; el renombrado, el diseño y las modificaciones de Usager son mantenidos por [Leandro Riviello](https://www.leandroriviello.com).

Consulta [LICENSE](LICENSE) y [CHANGELOG.md](CHANGELOG.md) para más detalles.
