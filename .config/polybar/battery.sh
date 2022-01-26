#!/bin/sh

for bat in $(ls /sys/class/power_supply | grep BAT)
do
	total_energy_now=$((total_energy_now+$(cat /sys/class/power_supply/$bat/energy_now)))
	total_energy_full=$((total_energy_full+$(cat /sys/class/power_supply/$bat/energy_full)))
done

battery_level=$(printf "%.0f" $(echo "($total_energy_now / $total_energy_full) * 100" | bc -l))

charging=$(cat /sys/class/power_supply/AC/online)

# unicode for the material design icons desktop font battery icons.
# in order: 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%
battery_icons_bat=("\Uf007a" "\Uf007b" "\Uf007c" "\Uf007d" "\Uf007e" "\Uf007f" "\Uf0080" "\Uf0081" "\Uf0082" "\Uf0079")
battery_icons_chr=("\Uf089c" "\Uf0086" "\Uf0087" "\Uf0088" "\Uf089d" "\Uf0089" "\Uf089e" "\Uf008a" "\Uf008b" "\Uf0085")

icon_idx=$(echo "$battery_level / 10" | bc)

if [ $charging -eq "1" ]
then
	status=${battery_icons_chr[$icon_idx]}
else
	status=${battery_icons_bat[$icon_idx]}
fi

printf "$status%s%%" $battery_level