#!/bin/bash
# Pomodoro Screen - cxto21
# [ES] El script está diseñado para trabajar en múltiples cosas
# adaptando la técnica de Pomodoro a un ambiente en computadora

### colors Things 
PURPLE_COLOUR="\e[0;35m\033[1m"
YELLOW_COLOUR="\e[0;33m\033[1m"
CYAN_COLOUR="\e[0;36m\033[1m"
GREEN_COLOUR="\e[0;32m\033[1m"
RED_COLOUR="\e[0;31m\033[1m"
END_COLOUR="\033[0m\e[0m"

#function: start program
function headerMessage(){
  echo -e "\n${CYAN_COLOUR}♯ ${END_COLOUR}Starting ${PURPLE_COLOUR}Pomodoro Screen${END_COLOUR}! At $(date)...\n"
  echo -e "${YELLOW_COLOUR}*${END_COLOUR} WorkFlow with ${RED_COLOUR}'Pomodoro Technique'${END_COLOUR} inside a Linux environment"
  echo -e "${YELLOW_COLOUR}~${END_COLOUR} Tool-script by ${PURPLE_COLOUR}CXTO${END_COLOUR}"
}

#funtion: check dependencies
function checkDependencies(){
  set -e
  counter=0
  dependencies_array=("$@")
  echo -e "\n" 
  echo -e "${YELLOW_COLOUR}Checking Dependencies...${END_COLOUR}"
  for program in "${dependencies_array[@]}"; do 
    if [ ! "$(command -v $program)" ]; then
      if [[ $? -eq "1" ]]; then exit; fi
      echo -e "${GREEN_COLOUR}[Φ]${END_COLOUR}${YELLOW_COLOUR}The program $program not is installed, please first run the installer.${END_COLOUR}"
      exit;
      let counter+=1
    fi
  done
  echo -e "   ${GREEN_COLOUR}✔${END_COLOUR} ${PURPLE_COLOUR} Correctly installed dependencies${END_COLOUR}"
}

#function: setSession
function setSession(){
  set -u
  set -e 
  echo -e "\n${YELLOW_COLOUR}Setting session...${END_COLOUR}"

  let input_TIME_PER_SESSION=$(zenity  --text="Enter the minutes for each Workspace:" --scale --value=1 --min-value=1 --max-value=221 || echo "-1") 
  if [[ $? -eq "1" || $input_TIME_PER_SESSION -le 0 ]]; then echo "Something wrong"; exit; fi
  let TIME_PER_SESSION=$input_TIME_PER_SESSION*60 
  let input_NUMBER_OF_CYCLES=$(zenity  --text="Enter the number of Cycles" --scale --value=1 --min-value=1 --max-value=221 || echo "-1") 
  if [[ $? -eq "1" || $input_NUMBER_OF_CYCLES -le 0 ]]; then echo "Something wrong"; exit; fi
  let NUMBER_OF_CYCLES=$input_NUMBER_OF_CYCLES 

  echo -e "    ${CYAN_COLOUR}Timer:${TIME_PER_SESSION}sg\t${CYAN_COLOUR}Screen: $NUMBER_OF_CYCLES${END_COLOUR}"


}

#function: run Session
function runSession(){
  echo -e "\n${YELLOW_COLOUR}Starting session...${END_COLOUR}"
  currentScreen=0
  cycleNumber=0
  # Init Message
  #Starting Session
  while [[ $cycleNumber -lt $NUMBER_OF_CYCLES ]];
  do
    if [[ $currentScreen -eq 0 ]]; then
      cycleNumber=$((cycleNumber+1))
      echo -e "    ${RED_COLOUR}Cycle:${END_COLOUR} $cycleNumber\t${PURPLE_COLOUR}Screen: ${END_COLOUR}$currentScreen"
    else echo -e "\t\t${PURPLE_COLOUR}Screen: ${END_COLOUR}$currentScreen"
    fi

    sleep $TIME_PER_SESSION
    lastScreen=$(wmctrl -d | tail -n 1 | awk '{print $1}')
    lastScreen=$((lastScreen+0))
    currentScreen=$(((currentScreen+1)%$lastScreen))
    wmctrl -s $currentScreen
  done
}

# Main function:
function main(){
  set -e
  #Print Header Message
  headerMessage
  #Check
  checkDependencies;
  #Global variables
  setSession
  #Start-
  runSession
}
main
