#!/bin/bash

# Mostrar mensaje de error y salir

error_exit(){
	echo "Error: $1" > 2
	exit 1
}

# Verificar si nmcli está instalado

command -v nmcli >/dev/null 2>&1 || error_exit "nmcli no está instalado. Por favor, instale network-manager."

# Escanear y obtener redes Wifi disponibles

echo "Escaneando redes wifi disponibles..."
readarray -t networks < <(nmcli -f SSID device wifi list | tail -n +2 | awk '!seen[$0]++' | sed '/^--$/d' | sed 's/^[ \t]*//;s/[ \t]*$//')

# Verificar si se encontraron redes

if [ ${#networks[@]} -eq 0 ]; then
	error_exit "No se encontró redes Wifi"
fi

#Mostrar lista de redes

echo "Redes disponibles"
for i in "${!networks[@]}"; do
	echo "$((i+1)). ${networks[i]}"
done

# Solicitar al usuario elegir una red
while true; do
	read -p "Selecciona el numero de la red a la que quieres conectarte: " selection
	if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#networks[@]}" ]; then
		selected_ssid="${networks[$((selection-1))]}"
		break
	else
		echo "Selección invalida. Seleccione un número entre 1 y ${#networks[@]}."
	fi
done

# Solicitar contraseña

read -s -p "Introduce la contraseña de la red (dejar en blanco si es una red abierta): " password
echo

# Intentar conectarse a la red

echo "Intentando conectarse a $selected_ssid..."
if [ -z "$password" ]; then
	nmcli device wifi connect "$selected_ssid" || error_exit "No se pudo conectar a la red."
else
	nmcli device wifi connect "$selected_ssid" password "$password" || error_exit "No se pudo conectar a la red, verifica la contrseña"
fi

# Verificar la conexion

if nmcli connection show --active | grep -q "selected_ssid"; then
	echo "Conexion exitosa a $selected_ssid"

	#Mostrar informacion de l conexion
	echo "Informacion de la conexion:"
	nmcli connection show "selected_ssid"
else
	error_exit "La conexion no se estableció correctmente"
fi
