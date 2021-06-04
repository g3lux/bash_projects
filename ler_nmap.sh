#!/bin/bash
#documentacao http://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Bash-Conditional-Expressions-1
##variaveis iniciais
declare -A services

IPs=()
Portas=()
servicosBarra=()

function LerLinhas() {
  #IFS=$(echo -en "\n\b")
  FILE=$(cat $1 | grep -v "Host\|closed\|STATE" | sed '1d;$d')
  
  #Loop de leitura linha por linha do resultado comando ja filtrado para excluir linhas desnecessárias
  while read -r line; do
  #for line in $FILE; do    

    #Expressao regular para fazer match de linhas que têm padrao de IP 3 numeros seguidos separados por . 
    #numeros entre 0-9 com length de 3, separados por '.', e que apareça 3 vezes, e com numeros á frente do ultimo '.' #255.255.255.0
    f=$(echo $line | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}") 
    
    if [ ! -z $f ]; then #guardar valor de IP no array, quando f não vazio = tem IP
    	IPs+=($f) #por valor de f (IP) no array IPs (nao é preciso o If)
    fi

    #na linha dos protocolos fazer match com '/' e imprimir o primeiro field que tem a porta TCP
    ports=$(echo $line | grep '/' | cut -d '/' -f1) 
    #echo -e "Portas zzzz "$ports
    
    if [[ $ports == [0-9]* ]]; then #se variavel ports 
      posicao=$(( ${#IPs[@]} - 1 ))
      
      #No array das portas, no mesmo numero de index que o IP, adicionar as portas, separadas por ','
      Portas[$posicao]+="${ports},"
    fi
  #done
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

    #apaga o texto entre as virgulas e conta as virgulas 
    #de forma a usar esse numero como sequencia para o cut abaixo
    commas=$(echo ${Portas[$i]} | tr -cd , | wc -c) 
    #echo -e "commas "$commas"\n"
    
    #sequencia de sumeros, com o numero de virgulas, para usar como field no cut
    for x in $(seq 1 $commas); do
      #temp segura o numero da porta, usando o cut com delimiter ','
      temp=$(echo ${Portas[$i]} | cut -d ',' -f$x)

      #Verificar se tem alguns IPs com mais de 8 portas abertas e usa essas portas, 
      #para a estatistica de 10 portas (${#} retorna o numero total começando por 1)
      if (( "$commas" >= 8 && "$commas" < 11 && "${#servicosBarra[@]}" < 9)); then
        #echo "$temp"
        servicosBarra+=($temp)
      fi

      #Usando um array associativo, com chave o numero da porta, crio uma estatistica de quantos equipamentos têm por porta
      #se não existir index associativo com a chave(22), cria uma "ocorrencia" 
      if [ ! -v services[$temp] ]; then
        services[$temp]=1
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
    #echo $i" "${services[$i]}" "
  done | sort -t ' ' -k 7 -n
}

function MostrarComGraphs() {
  printf "\t\t"
  #ciclo for para imprimir as portas existeste no array
  for i in ${!servicosBarra[@]}; do
    printf "${servicosBarra[$i]}\t"
  done
  
  printf "\n"
  #ciclo para percorrer os indexes do array IPs, e imprimir o valor
  for i in ${!IPs[@]}; do
    printf "${IPs[$i]}\t"
    #ciclo para percorrer o array servicosBarra(que tem as portas) e faz um if
    #de comparação se IP, tem X porta aberta, e imprimir barra se tem ou ---- caso não
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

echo -e "Diretoria que atualmente estas "$(pwd)"\n\n"
read -p "Qual ficheiro a usar: " ficheiro

#verifica se o ficheiro existe
if [ -e $ficheiro ]; then
  LerLinhas $ficheiro
else
  echo "Ficheiro inexistente"
  exit
fi
while true; do 
  clear
  printf "
  Ficheiro escolhido: \033[32;1m$ficheiro\033[0m
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
    3) #Visto para a funcao MostrarComGraphs necessitar de dados da função MostrarPorServicos
        #executo a funcao e envio output para /dev/null
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
