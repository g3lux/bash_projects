#!/bin/bash
##documentation https://unix.stackexchange.com/questions/68322/how-can-i-remove-an-element-from-an-array-completely
###escala 5% em 5%
###stress ram stress-ng --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.5;}' < /proc/meminfo)k --vm-keep -m 1
### 20 linhas = 100%

trap tratarInterrupcao SIGINT; #quando ctrl + c (interrupcao), executa funcao

cpuUsageArray=()
ramUsageArray=()
diskUsageArray=()
maxRAM=$(free -m | grep Mem | awk -F ' ' {'print $2'}) #obter o valor maximo de ram (em MB)
maxDisk=$(df | grep "sda[1-9]" | awk -F ' ' '{print $2}') #obter o valor maximo de disco

function tratarInterrupcao() {
	TOTALMEDIACPU=0
	TOTALMEDIARAM=0
	TOTALMEDIADISCO=0
	for val in "${cpuUsageArray[@]}"; do
		(( TOTALMEDIACPU+=$val ))
	done	
	TOTALMEDIACPU=$(( TOTALMEDIACPU / ${#cpuUsageArray[@]} ))

	for val in "${ramUsageArray[@]}"; do
		(( TOTALMEDIARAM+=$val ))
	done
	TOTALMEDIARAM=$(( TOTALMEDIARAM / ${#ramUsageArray[@]} ))
	TOTALMEDIARAM=$(( TOTALMEDIARAM * 100 / maxRAM))

	for val in "${diskUsageArray[@]}"; do
		(( TOTALMEDIADISCO+=$val ))
	done
	TOTALMEDIADISCO=$(( TOTALMEDIADISCO / ${#diskUsageArray[@]} ))
	TOTALMEDIADISCO=$(( TOTALMEDIADISCO * 100 / maxDisk ))

	read -p "Press [Enter] key to continue..."
	unset resposta
	MostrarMenu
	read -p "Introduza a opção [0-3] > " resposta
	unset cpuUsageArray
	unset ramUsageArray	
	unset diskUsageArray
}

function CriarGrafico() {

	#consoante o parametro (obter uso de cpu,ram ou disco)
	#arrayAusar = ao array que corresponde
	clear
	if [[ "$1" == "cpu" ]]; then
		arrayAusar=("${cpuUsageArray[@]}")
		printf "\t\t\tCPU USAGE\n\n"
		divisor=100
	elif [[ "$1" == "ram" ]]; then
		arrayAusar=("${ramUsageArray[@]}")
		printf "\t\t\tRAM USAGE\n\n"
		divisor=$maxRAM
	elif [[ "$1" == "disco" ]]; then
		arrayAusar=("${diskUsageArray[@]}")
		printf "\t\t\tDISK USAGE\n\n"
		divisor=$maxDisk
	fi

	while (($linhas >= 0)); do
		if (($linhas == 20)); then #100
			printf "100\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 20)); then 
					printf "\u2588"  #antes era 2584
				else
					printf " "
				fi
				printf " "
			done #for loop
			printf "\n"
		elif (($linhas == 19)); then #95
			printf "95\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 19)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 18)); then #90
			printf "90\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 18)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 17)); then #85
			printf "85\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 17)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 16)); then #80
			printf "80\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 16)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 15)); then #75
			printf "75\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 15)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 14)); then #70
			printf "70\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 14)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 13)); then #65
			printf "65\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 13)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 12)); then #60
			printf "60\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 12)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 11)); then #55
			printf "55\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 11)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 10)); then #50
			printf "50\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 10)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 9)); then #45
			printf "45\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 9)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 8)); then #40
			printf "40\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 8)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 7)); then #35
			printf "35\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 7)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 6)); then #30
			printf "30\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 6)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 5)); then #25
			printf "25\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 5)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 4)); then #20
			printf "20\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 4)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 3)); then #15
			printf "15\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 3)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 2)); then #10
			printf "10\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 2)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 1)); then #5
			printf "5\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 1)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		elif (($linhas == 0)); then #0
			printf "0\t"
			for i in ${!arrayAusar[@]}; do
				percentage=$((${arrayAusar[$i]}*20/$divisor))
				if (($percentage >= 0)); then 
					printf "\u2588" 
				else
					printf " "
				fi
				printf " "
			done
			printf "\n"
		fi
		
	linhas=$((linhas - 1))
	done

	#consoante o parametro, atualizar a utilização media em tempo real
	if [[ "$1" == "cpu" ]]; then
		for i in ${!cpuUsageArray[@]}; do
			(( TOTALMEDIACPU += ${cpuUsageArray[$i]} ))
		done
		TOTALMEDIACPU=$(( TOTALMEDIACPU / ${#cpuUsageArray[@]} ))
		echo -e "\nUTILIZAÇÃO MÉDIA DE CPU: $TOTALMEDIACPU%"

	elif [[ "$1" == "ram" ]]; then
		for i in ${!ramUsageArray[@]}; do
			(( TOTALMEDIARAM += ${ramUsageArray[$i]} ))
		done	
		TOTALMEDIARAM=$(( TOTALMEDIARAM / ${#ramUsageArray[@]} ))
		TOTALMEDIARAM=$(( TOTALMEDIARAM * 100 / maxRAM))
		echo -e "\nUTILIZAÇÃO MÉDIA DE RAM: $TOTALMEDIARAM%"
		echo -e "UTILIZAÇÃO ATUAL DE RAM: $(free -m | grep 'Mem' | awk {'print $3'}) MB"

	elif [[ "$1" == "disco" ]]; then
		for i in ${!diskUsageArray[@]}; do
			(( TOTALMEDIADISCO += ${diskUsageArray[$i]} ))
		done	
		TOTALMEDIADISCO=$(( TOTALMEDIADISCO / ${#diskUsageArray[@]} ))
		TOTALMEDIADISCO=$(( TOTALMEDIADISCO * 100 / maxDisk ))
		echo -e "\nUTILIZAÇÃO MÉDIA DE DISCO: $TOTALMEDIADISCO%"
	fi

}

function MostrarMenu() {
	clear
	printf "
  \033[32;1mRepresentacao Grafica de CPU/RAM\033[0m
  Selecione opcao: 

  1. Mostrar uso CPU
  2. Mostrar uso RAM
  3. Mostrar uso Disco
  0. Sair

  Nota: Para sair da representacao grafica ctrl + c

  "
}

while true; do
	sleep 1
	cpuUsage=$(top -bn1 | grep Cpu | awk -F ' ' {'print $2'} | cut -d ',' -f1) #guardar uso de cpu sem decimal
	cpuUsageArray+=($cpuUsage)
	ramUsage=$(free -m | grep Mem | awk -F ' ' {'print $3'})
	ramUsageArray+=($ramUsage)
	diskUsage=$(df | grep "sda[1-9]" | awk -F ' ' '{print $3}')
	diskUsageArray+=($diskUsage)
	linhas=20
	if ((${#cpuUsageArray[@]} >= 30)); then
		#se ja tem 30 entradas no array, criar offset
		#apagar o primeiro resultado (index 0), e shift
		cpuUsageArray=("${cpuUsageArray[@]:1}") 
	fi
	if ((${#ramUsageArray[@]} >= 30)); then
		#se ja tem 30 entradas no array, criar offset
		#apagar o primeiro resultado (index 0), e shift
		ramUsageArray=("${ramUsageArray[@]:1}") 
	fi
	if ((${#diskUsageArray[@]} >= 30)); then
		#se ja tem 30 entradas no array, criar offset
		#apagar o primeiro resultado (index 0), e shift
		diskUsageArray=("${diskUsageArray[@]:1}") 
	fi
	
	#Se a primeira vez a executar
	#ainda não tem resposta, mostrar menu e guardar 
	if [[ ! $resposta ]]; then
		MostrarMenu
		read -p "Introduza a opção [0-3] > " resposta
	fi

	case $resposta in 
    1) 
		CriarGrafico "cpu"
		resposta=1
	;;

	2)
		CriarGrafico "ram"
		resposta=2
	;;
	3)
		CriarGrafico "disco"
		resposta=3
	;;

	*)
	  echo "Saindo..." >&2
	  #criarEstatistica
	  echo -e "----------"
	  
	  echo -e "UTILIZAÇÃO MÉDIA DE CPU: $TOTALMEDIACPU%"
	  echo -e "----------"
	  echo -e "UTILIZAÇÃO MÉDIA DE RAM: $TOTALMEDIARAM%"
	  echo -e "----------"
	  echo -e "UTILIZAÇÃO MÉDIA DE DISCO: $TOTALMEDIADISCO%"
	  echo -e "----------"
      exit 1

    esac
	#CriarGrafico "cpu"
	#CriarGrafico "ram"
	#echo "posicoes no array "${!cpuUsageArray[@]}
done

