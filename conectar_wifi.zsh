#!/usr/bin/env zsh

# Habilitar opciones de zsh necesarias
setopt ERR_EXIT           # Salir en caso de error
setopt PIPE_FAIL         # Si un comando en un pipeline falla, todo el pipeline falla
setopt NO_UNSET          # Error al usar variables no definidas
setopt EXTENDED_GLOB     # Habilitar globbing extendido

# Función para mostrar un mensaje de error y salir
error_exit() {
    print -P "%F{red}Error: $1%f" >&2
    exit 1
}

# Verificar si nmcli está instalado
if ! command -v nmcli >/dev/null 2>&1; then
    error_exit "nmcli no está instalado. Por favor, instala network-manager."
fi

# Escanear y obtener las redes WiFi disponibles
print -P "%F{blue}Escaneando redes WiFi disponibles...%f"

# Array para almacenar los SSIDs
typeset -a networks
networks=("${(f)$(nmcli -f SSID device wifi list | tail -n +2 | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v '^--$' | awk '!seen[$0]++')}")

# Verificar si se encontraron redes
if [[ ${#networks} -eq 0 ]]; then
    error_exit "No se encontraron redes WiFi."
fi

# Mostrar la lista de redes con colores
print -P "%F{green}Redes WiFi disponibles:%f"
integer i=1
for network in $networks; do
    print -P "%F{yellow}$i.%f ${network}"
    ((i++))
done

# Solicitar al usuario que seleccione una red
while true; do
    print -P -n "%F{cyan}Selecciona el número de la red a la que quieres conectarte: %f"
    read "selection"
    if [[ "$selection" =~ '^[0-9]+$' && "$selection" -ge 1 && "$selection" -le "${#networks}" ]]; then
        selected_ssid="${networks[$selection]}"
        break
    else
        print -P "%F{red}Selección inválida. Por favor, elige un número entre 1 y ${#networks}.%f"
    fi
done

# Solicitar la contraseña
print -P -n "%F{cyan}Introduce la contraseña de la red (dejar en blanco si es una red abierta): %f"
read -s "password"
print  # Nueva línea después de la contraseña

# Intentar conectarse a la red
print -P "%F{blue}Intentando conectarse a '$selected_ssid'...%f"

# Función para intentar la conexión
try_connect() {
    if [[ -z "$password" ]]; then
        nmcli device wifi connect "$selected_ssid" || return 1
    else
        nmcli device wifi connect "$selected_ssid" password "$password" || return 1
    fi
    return 0
}

# Intentar la conexión con manejo de errores
if ! try_connect; then
    error_exit "No se pudo conectar a la red. Verifica el SSID y la contraseña."
fi

# Verificar la conexión
if nmcli connection show --active | grep -q "$selected_ssid"; then
    print -P "%F{green}Conexión exitosa a '$selected_ssid'%f"
    
    # Mostrar información de la conexión
    print -P "%F{blue}Información de la conexión:%f"
    nmcli connection show "$selected_ssid"
else
    error_exit "La conexión no se estableció correctamente."
fi