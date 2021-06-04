#!/bin/bash
#documentacao http://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Bash-Conditional-Expressions-1
##variaveis iniciais
declare -A services

IPs=()
Portas=()
counter=0
servicosBarra=()

#SAVEIFS=$IFS
#IFS=$(echo -en "\n\b")
function LerLinhas() {
  IP=$1

  FILE=$(nmap $IP | grep -v "Host\|closed\|STATE" | sed '1d;$d')

  #Loop de leitura linha por linha do resultado comando ja filtrado para excluir linhas desnecessárias
  while read -r line; do
  #for i in $(cat nmap.log | grep -v "Host\|closed\|STATE" | sed '1d;$d'); do

    f=$(echo $line | awk -F " " '{print $5'})
    #echo -e "antes de if\n"$i"\n"
    
    if [[ $f =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then #fazer match as linhas recebidas com formato IP ()
      #echo -e $f"\n"
      IPs+=($f)
      #echo -e "portas "$(echo $i | cut -d '/' -f1)"\n"

    else ### caso o $5 imprima um hostname
      x=$(echo $line | awk 'BEGIN{FS="[()]"}{print $2}') ##usar o awk para imprimir o valor entre parenteses, quando é hostname o IP esta entre parenteses
      IPs+=($x)
      #echo -e $x"\n"
    fi

    ports=$(echo $line | grep '/' | cut -d '/' -f1) #na linha dos protocolos fazer match com '/' e imprimir o primeiro field que tem a porta TCP
    #echo -e "Portas xxxxx "$ports
    
    if [[ $ports == [0-9]* ]]; then #se variavel ports 
      #echo $(echo $i | grep '/' | cut -d '/' -f1)"\n"
      #printf "%s"$portas
      posicao=$(( ${#IPs[@]} - 1 )) 
      
      Portas[$posicao]+="${ports},"
    fi

  done <<< "$FILE"
}

function MostrarIPs() {

  for i in $(seq 0 $(( ${#IPs[@]} - 1 ))); do #ciclo for sequencia de 0 a total de posições no array - 1
    #echo "User: "${USERS[$i]}" ocorrencias: "${OCORRENCIAUSERS[$i]}
    
    printf "IPs: "${IPs[$i]}"\t\tPortas: "${Portas[$i]}"\n"
     
  done | sed 's/,$//' #strip ultima virgula
}

function MostrarPorServicos() {
  for i in $(seq 0 $(( ${#IPs[@]} - 1 ))); do  

    commas=$(echo ${Portas[$i]} | tr -cd , | wc -c) #apaga o texto entre as virgulas e conta as virgulas
    #echo -e "commas "$commas"\n"
    
    for x in $(seq 1 $commas); do
      #echo -e "virtula "$x"\n"
      temp=$(echo ${Portas[$i]} | cut -d ',' -f$x)
      #echo -e "temp "$temp"\n"
      if (( "$commas" >= 8 && "$commas" < 11 && "${#servicosBarra[@]}" < 9)); then
        #echo "$temp"
        servicosBarra+=($temp)
      fi
      if [ ! -v services[$temp] ]; then
        services[$temp]=1
        #echo -e "asd "${!services[@]}"\n"
      else
        services[$temp]=$(( ${services[$temp]} + 1 ))
      fi
      #echo ${Portas[$i]} | cut -d ',' -f$x
    done
  done 

  printf "\n\nNumero de Equipamentos por servico TCP \n"

  for i in ${!services[@]}; do
    #printf "Porta "$i" tem "${services[$i]}" PCs "
    printf "\tTem "${services[$i]}" Equipamento(s) com a Porta "$i" aberta "
    for x in $(seq 1 ${services[$i]} ); do
      printf "\u2584"
    done
    printf "\n"
  done | sort -t ' ' -k 7 -n
}

function MostrarComGraphs() {
  printf "\t\t"
  
  for i in ${!servicosBarra[@]}; do
    printf "${servicosBarra[$i]}\t"
  done
  
  printf "\n"

  for i in ${!IPs[@]}; do
    printf "${IPs[$i]}\t"

    for x in ${!servicosBarra[@]}; do
    servicoz=${servicosBarra[$x]}
    if echo ${Portas[$i]} | grep -q "$servicoz"; then
      printf "\u2584\u2584\u2584\u2584\t"
    else
      printf '%s\t' '----'
    fi
    done
    printf "\n"
  done
}

clear
read -p "Insira a Rede a pesquisar: " resposta_IP
printf "Processando..."
#OutPut=$(nmap "$resposta_IP" | grep -v "Host\|closed\|STATE" | sed '1d;$d')

LerLinhas $resposta_IP
#printf "$OutPut"
#read -p "asdasd"
while true; do 
  clear
  printf "
  IP fornecido: \033[32;1m$resposta_IP\033[0m
  \033[32;1mEstatistica de IPs / Portas\033[0m
  Selecione opcao: 

  1. Mostrar IPs e portas
  2. Mostrar Estatistica
  3. Mostrar Com Graphs
  0. Sair

  "
  read -p "Introduza a opção [0-3] > " resposta
  #echo -e "\nOpção introduzida foi ..."$REPLY

  case $resposta in 
    1)
      MostrarIPs
    ;;
    2)
      MostrarPorServicos
    ;;
    3)
      MostrarPorServicos > /dev/null 2>&1 
      MostrarComGraphs
    ;;
    *)
      echo "Saindo..." >&2
      exit 1
    ;;

  esac
  read -p "Enter para prosseguir "
  clear
done
