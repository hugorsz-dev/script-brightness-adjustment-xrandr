#!/bin/bash

# MAIN LOOP

while true; do 

# SCREEN SELECTION LOOP

while true; do 

# DISPLAY AVAILABLE SCREENS

echo "Available monitors: "
xrandr --listmonitors | grep "+"
echo " A: +All available monitors"

# Loop: SELECT AVAILABLE SCREENS  

limit=$(xrandr --listmonitors | grep -c "+") ## Count the available screens with grep

while true; do

	read -p "Select a monitor number: " input 

	if [[ "$input" == "A" ]]; then ## If we want to adjust all screens, add the exception 'A' and skip the loop
		break; 
	fi

	if [[ "$input" =~ ^[0-9]+$ ]]; then # If the string contains only numbers...
		
		if [[ "$input" -gt "-1"  ]] && [[ "$input" -lt "$(($limit))" ]]; then 
			monitorNumber=$(($input+2)) ## Add one to adapt it to the +2 line scheme of xrandr
			break;

		else 
			echo "Incorrect range"
		fi
	else 
		echo "You have not entered a number"	
	fi
done

# If all monitors have been selected, skip this loop

if [[ "$input" == "A" ]]; then ## If we want to adjust all screens, add the exception 'A' and skip the loop
		break; 
fi

# SCREEN FILTERING AND ASSIGNMENT
## On the list of monitors, we choose the previously determined line, and from that line we separate by spaces; from this separation, the fourth line will always result in the name of the monitor.

screen=$(xrandr --listmonitors | sed -n "${monitorNumber}p"  | grep -oP "(?<= )[^ ]*" | sed -n 4p)

echo "Configuring for $screen"

# BRIGHTNESS ASSIGNMENT LOOP

while true; do

	read -p "Enter brightness [5 - 200]: " input

	if [[ "$input" =~ ^[0-9]+$ ]]; then # If the string contains only numbers...

		if [[ "$input" -gt "4" ]] && [[ "$input" -lt "201" ]]; then

			brightness=$(echo "$input/100" | bc -l) # To get decimals. 
        		xrandr --output $screen --brightness $brightness 

			echo "Brightness changed."

		else

			echo "Out of range."
		fi

	else 
	
		echo "Parameter entered is not a number. Returning to screen selection."
		break
	fi
done

# END OF SCREEN SELECTION LOOP
done
echo "Configuring all screens simultaneously"

# SELECTING MULTIPLE SCREENS

while true; do

read -p "Enter brightness [5 - 200]: " input

# BRIGHTNESS PROCESSING

if [[ "$input" =~ ^[0-9]+$ ]]; then # If the string contains only numbers...

		if [[ "$input" -gt "4" ]] && [[ "$input" -lt "201" ]]; then # ... and it is between 5 and 200
 
			counter=0 ## Counter that will iterate through all existing screens. 

			while true; do 		
				
				if [[ "$counter" -ge "$limit" ]]; then ## If the counter is greater than or equal to the limit, there will be no screens left to adjust
					break
				fi	

				monitorNumber=$(($counter+2)) ## The number - i.e., the line accessed by sed - must be adjusted to the xrandr +2 scheme

				screen=$(xrandr --listmonitors | sed -n "${monitorNumber}p"  | grep -oP "(?<= )[^ ]*" | sed -n 4p) # As seen before

				echo "Brightness changed on $screen"
				
				brightness=$(echo "$input/100" | bc -l) # To get decimals. 

				xrandr --output $screen --brightness $brightness 

				counter=$(($counter + 1))
			
			done	


		else

			echo "Out of range."
		fi

	else 
	
		echo "Parameter entered is not a number. Returning to screen selection."
		break
	fi
done
done 
