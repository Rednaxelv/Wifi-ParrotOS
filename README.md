# Conectar WiFi - Script para ParrotOS

Este script de Bash facilita la conexión a redes WiFi en sistemas ParrotOS y otros sistemas basados en Debian que utilicen NetworkManager.

## Características

- Escanea y muestra una lista de redes WiFi disponibles.
- Permite seleccionar una red de la lista mediante un número.
- Maneja automáticamente la conexión a redes protegidas y abiertas.
- Verifica la conexión y muestra información detallada tras conectarse exitosamente.
- Maneja errores comunes y proporciona mensajes informativos.

## Requisitos

- ParrotOS o un sistema basado en Debian con NetworkManager instalado.
- Permisos de superusuario (root) o capacidad de usar `sudo`.

## Instalación

1. Clona este repositorio o descarga el archivo `conectar_wifi.sh`.
2. Dale permisos de ejecución al script:

     ```bash
     chmod +x conectar_wifi.sh
     ```
## Uso

1. Ejecuta el script:
  ```bash
  ./conectar_wifi.sh
  ```

2. O si necesitas permisos de superusuario:
  ```bash
  sudo ./conectar_wifi.sh
   ```
3. El script escaneará y mostrará una lista numerada de redes WiFi disponibles.
4. Ingresa el número correspondiente a la red a la que deseas conectarte.
5. Si la red está protegida, ingresa la contraseña cuando se te solicite.
6. El script intentará conectarse y te informará del resultado.

## Solución de problemas

- Si el script no puede encontrar redes WiFi, asegúrate de que tu adaptador WiFi esté activado y funcionando correctamente.
- Si tienes problemas para conectarte a una red específica, verifica que la contraseña sea correcta.
- Para problemas persistentes, puedes ejecutar el script con la opción de depuración de bash:
    ```bash
    bash -x ./conectar_wifi.sh

## Contribuciones
Las contribuciones son bienvenidas. Por favor, abre un issue para discutir cambios mayores antes de enviar un pull request.
