#!/bin/bash
# Pomodoro Screen - by cxto21
# [ES] El script está diseñado para trabajar en múltiples cosas
# adaptando la técnica de Pomodoro a un ambiente en computadora

### colors Things
purpleColour="\e[0;35m\033[1m"
yellowColour="\e[0;33m\033[1m"
cyanColour="\e[0;36m\033[1m"
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
endColour="\033[0m\e[0m"

#function: start program
function headerMessage(){
  echo -e "\n${cyanColour}♯ ${endColour}Starting ${purpleColour}Pomodoro Screen${endColour}!...\n"
  echo -e "${yellowColour}*${endColour} WorkFlow with ${redColour}'Pomodoro Technique'${endColour} inside a Linux environment"
  echo -e "${yellowColour}~${endColour} Tool by ${purpleColour}CXTO${endColour}"
}

#funtion: check dependencies, fix: if something went wrong
function checkDependencies(){
  counter=0
  dependencies_array=("$@")
  echo -e "\n" 
  echo -e "${yellowColour}Checking Dependencies...${endColour}"
  for program in "${dependencies_array[@]}"; do 
    if [ ! "$(command -v $program)" ]; then
      echo -e "${greenColour}[Φ]${endColour}${yellowColour}The program $program not is installed, please first run the installer.${endColour}"
      exit;
      let counter+=1
    fi
  done
  echo -e "   ${greenColour}✔${endColour} ${purpleColour} Correctly installed dependencies${endColour}"
}

# fix: exit failure, abort program
function setSession(){
  let TimePerScreen=$(zenity  --text="Enter the minutes for each Workspace:" --scale --value=1 --min-value=1 --max-value=221)*5 
  #if [ $? -eq "1" ]; then exit; fi
  let Cycles=$(zenity  --text="Enter the number of Cycles" --scale --value=1 --min-value=1 --max-value=221)
  #if [ $? -eq "1" ]; then exit; fi
}

#function: run Session | FIX
function runSession(){
  echo -e "\n${yellowColour}Starting session...${endColoud}"
  currentScreen=0
  cycleNumber=0
  # Init Message
  #Starting Session
  while [[ $cycleNumber -lt $Cycles ]];
  do
    if [[ $currentScreen -eq 0 ]]; then
      cycleNumber=$((cycleNumber+1))
      echo -e "    ${redColour}Cycle:${endColour} $cycleNumber\t${purpleColour}Screen: ${endColour}$currentScreen"
    else echo -e "\t\t${purpleColour}Screen: ${endColour}$currentScreen"
    fi

    ##upgrade: add log init time sceen (wmctrl -l|grep "^current"|awk'{print $1 $4}'')
    sleep $TimePerScreen
    ##upgrade: add log finish time screen
    lastScreen=$(wmctrl -d | tail -n 1 | awk '{print $1}')
    lastScreen=$((lastScreen+0))
    #setting the next currentScreen using math module.
    currentScreen=$(((currentScreen+1)%$lastScreen))
    wmctrl -s $currentScreen
  done
}

# Main:
function main(){
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
