#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}
trap ctrl_c INT

# Variables globales
mainUrl="https://htbmachines.github.io/bundle.js"

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
  echo -e "\t${purpleColour}-u${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}"
  echo -e "\t${purpleColour}-m${endColour}${grayColour} Buscar por un nombre de máquina${endColour}"
  echo -e "\t${purpleColour}-i${endColour}${grayColour} Buscar por dirección IP${endColour}"
  echo -e "\t${purpleColour}-o${endColour}${grayColour} Buscar por Sistema Operativo${endColour}"
  echo -e "\t${purpleColour}-s${endColour}${grayColour} Buscar por Skill${endColour}"
  echo -e "\t${purpleColour}-c${endColour}${grayColour} Buscar por certificación${endColour}"
  echo -e "\t${purpleColour}-y${endColour}${grayColour} Obtener link de resolución de máquina en YouTube${endColour}"
  echo -e "\t${purpleColour}-d${endColour}${grayColour} Obtener las dificultades de las máquinas${endColour}"
  echo -e "\t${purpleColour}-h${endColour}${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function updateFiles(){
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
    curl -s $mainUrl > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${greenColour}[+] Todos los archivos han sido descargados correctamente${endColour}\n"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando si hay actualizaciones pendientes...${endColour}"
    curl -s $mainUrl > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}No se han detectado actualizaciones${endColour}\n"
      rm bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando actualizaciones pendientes${endColour}"
      rm bundle.js && mv bundle_temp.js bundle.js
      sleep 1
      echo -e "\n${greenColour}[+] Actualizaciones descargadas con éxito${endColour}\n"
    fi
    tput cnorm
  fi
}

function searchMachine(){
  machineName="$1"
  machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"

  if [ "$machineName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando las propiedades de la máquina${endColour} ${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
    echo "$machineName_checker"
  else
    echo -e "\n${redColour}[!] La máquina proporcionada no existe${endColour}\n"
  fi
  echo -e "\n"
}

function searchIP(){
  ipAddress="$1"
  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

  if [ "$machineName" ]; then 
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La máquina correspondiente a la IP${endColour} ${blueColour}$ipAddress${endColour}${grayColour} es:${endColour} ${blueColour}$machineName${endColour}\n"
  else
    echo -e "\n${redColour}[!] La dirección IP proporcionada no corresponde a ninguna máquina${endColour}\n"
  fi
}

function getYoutubeLink(){
  machineName="$1"
  youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep youtube | tr -d '"' | tr -d ',' | awk 'NF{print $NF}')"

  if [ "$youtubeLink" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}El tutorial para esta máquina está en el siguiente enlace:${endColour} ${blueColour}$youtubeLink${endColour}\n"
  else
    echo -e "\n${redColour}[!] La máquina proporcionada no existe${endColour}\n"
  fi
}

function getMachinesDifficulty(){
  difficulty="$1"
  results_check="$(cat bundle.js | grep -i "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$results_check" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Máquinas con dificultad${endColour} ${blueColour}$difficulty${endColour}${grayColour}:${endColour}\n"
    echo "$results_check"
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] La dificultad indicada no es correcta${endColour}\n"
  fi
}

function getOSMachines(){
  os="$1"
  os_results="$(cat bundle.js | grep -i "so: \"$os\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$os_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Máquinas con sistema operativo${endColour} ${blueColour}$os${endColour}${grayColour}:${endColour}\n"
    echo "$os_results"
    echo -e "\n"
  else
    echo -e "\n${redColour}[!] El sistema operativo ingresado no es correcto${endColour}\n"
  fi
}

function getOSDifficultyMachines(){
  difficulty="$1"
  os="$2"
  check_results="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$check_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Máquinas con sistema operativo${endColour} ${blueColour}$os${endColour} ${grayColour}y dificultad${endColour} ${blueColour}$difficulty${endColour}${grayColour}:${endColour}\n"
    echo "$check_results"
  else
    echo -e "\n${redColour}[!] El sistema operativo o dificultad ingresado es incorrecto${endColour}\n"
  fi
}

function getSkill(){
  skill="$1"
  check_skill="$(cat bundle.js | grep skills -B 6 | grep -i "$skill" -B 6 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$check_skill" ]; then
    echo -e "\n${greenColour}[+]${endColour} ${grayColour}Máquinas con la skill${endColour} ${blueColour}$skill${endColour}${grayColour}:${endColour}\n"
    echo "$check_skill"
  else
    echo -e "\n${redColour}[!] No existen máquinas con la skill${endColour} ${blueColour}$skill${endColour}\n"
  fi
}

function getCertification(){
  certification="$1"
  check_certification="$(cat bundle.js | grep -i "$certification" -B 7 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$check_certification" ] ; then
    echo -e "${greenColour}[+]${endColour}${grayColour} Listando las maquinas que te preparan para la certificiacion${endColour}${blueColour} $certification${endColour}${grayColour}:${endColour}"
    cat bundle.js | grep -i "$certification" -B 7 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "${redColour}[!]No se encuentra la certificacion:${endColour}${blueColour} $certification${endColour}"
  fi
}


# Variables controladoras
declare -i parameter_counter=0
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:c:h" arg; do
  case $arg in
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=5;;
    o) os="$OPTARG"; chivato_os=1; let parameter_counter+=6;;
    s) skill="$OPTARG"; let parameter_counter+=7;;
    c) certification="$OPTARG"; let parameter_counter+=8;;
    h) helpPanel; exit 0;;
  esac
done

# Lógica principal
if [ $parameter_counter -eq 1 ]; then
  searchMachine "$machineName"
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP "$ipAddress"
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink "$machineName"
elif [ $parameter_counter -eq 5 ]; then
  getMachinesDifficulty "$difficulty"
elif [ $parameter_counter -eq 6 ]; then
  getOSMachines "$os"
elif [ $parameter_counter -eq 7 ]; then
  getSkill "$skill"
elif [ $parameter_counter -eq 8 ]; then
  getCertification "$certification"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
  getOSDifficultyMachines "$difficulty" "$os"
else
  helpPanel
fi

