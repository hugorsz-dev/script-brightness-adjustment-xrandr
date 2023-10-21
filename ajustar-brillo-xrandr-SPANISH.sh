#!/bin/bash

# BUCLE PRINCIPAL

while true; do 

# BUCLE SELECCIÓN DE UNA PANTALLA

while true; do 

# MOSTRAR PANTALLAS DISPONIBLES

echo "Monitores disponibles: "
xrandr --listmonitors | grep "+"
echo " A: +Todos los monitores disponibles"

# Bucle: SELECCIONAR PANTALLA DISPONIBLES  

limite=$(xrandr --listmonitors | grep -c "+") ## Con el grep, cuenta las pantallas disponibles

while true; do

	read -p "Seleccione un número de monitor: " input 

	if [[ "$input" == "A" ]]; then ## Si queremos ajustar todas las pantallas, se añade la excepción A y se salta el bucle
		break; 
	fi

	if [[ "$input" =~ ^[0-9]+$ ]]; then # Si la cadena tiene solo números...
		
		if [[ "$input" -gt "-1"  ]] && [[ "$input" -lt "$(($limite))" ]]; then 
			numeroMonitor=$(($input+2)) ## Sumamos uno para adaptarlo al esquema de +2 línea del xrandr
			break;

		else 
			echo "Rango incorrecto"
		fi
	else 
		echo "No ha introducido un número"	
	fi
done

# Si se han elegido todos los monitores, saltar este bucle

if [[ "$input" == "A" ]]; then ## Si queremos ajustar todas las pantallas, se añade la excepción A y se salta el bucle
		break; 
fi

# FILTRADO Y ASIGNACIÓN DE PANTALLA
## Sobre el listado de monitores, elegimos la línea determinada previamente, y sobre la misma hacemos una separación entre espacios; de dicha separación, la cuarta línea siempre resultará en el nombre del monitor.

pantalla=$(xrandr --listmonitors | sed -n "${numeroMonitor}p"  | grep -oP "(?<= )[^ ]*" | sed -n 4p)

echo "Configurando para $pantalla"

# BUCLE: ASIGNACIÓN DE BRILLO - Bucle

while true; do

	read -p "Introduzca brillo [5 - 200]: " input

	if [[ "$input" =~ ^[0-9]+$ ]]; then # Si la cadena tiene solo números...

		if [[ "$input" -gt "4" ]] && [[ "$input" -lt "201" ]]; then

			brillo=$(echo "$input/100" | bc -l) # Para conseguir decimales. 
        		xrandr --output $pantalla --brightness $brillo 

			echo "Brillo cambiado."

		else

			echo "Fuera de rango."
		fi

	else 
	
		echo "Parámetro introducido no es un número. Volviendo a selección de pantalla."
		break
	fi
done

# CIERRE DEL BUCLE PARA SELECCIÓN DE UNA PANTALLA
done
echo "Configurando simultáneamente todas las pantallas"

# SELECCIÓN DE VARIAS PANTALLAS

while true; do

read -p "Introduzca brillo [5 - 200]: " input

# PROCESAMIENTO DEL BRILLO

if [[ "$input" =~ ^[0-9]+$ ]]; then # Si la cadena tiene solo números...

		if [[ "$input" -gt "4" ]] && [[ "$input" -lt "201" ]]; then # ... y está entre 5 y 200
 
			contador=0 ## Contador que iterará por todas las pantallas existentes. 

			while true; do 		
				
				if [[ "$contador" -ge "$limite" ]]; then ## Si el contador es mayor o igual al límite, no quedarán pantallas por ajustar
					break
				fi	

				numeroMonitor=$(($contador+2)) ## El número - es decir, la línea a la que accede el sed - debe ajustarse al esquema de xrandr (+2)

				pantalla=$(xrandr --listmonitors | sed -n "${numeroMonitor}p"  | grep -oP "(?<= )[^ ]*" | sed -n 4p) # Visto anteriormente

				echo "Brillo cambiado en $pantalla"
				
				brillo=$(echo "$input/100" | bc -l) # Para conseguir decimales. 

				xrandr --output $pantalla --brightness $brillo 

				contador=$(($contador + 1))
			
			done	


		else

			echo "Fuera de rango."
		fi

	else 
	
		echo "Parámetro introducido no es un número. Volviendo a selección de pantalla."
		break
	fi
done
done 
