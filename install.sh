#!/bin/bash
# Pomodoro Screen installer - by cxto21

# colors Things
purpleColour="\e[0;35m\033[1m"
yellowColour="\e[0;33m\033[1m"
cyanColour="\e[0;36m\033[1m"
greenColour="\e[0;32m\033[1m"
redColour="\e[0;31m\033[1m"
endColour="\033[0m\e[0m"

# Check that if is running by root user
if [[ $EUID -ne 0 ]]; then
	echo -e "\n        ${redColour}✗${endColour} You are not a root, you must run this tool as root"
  echo -e "(${purpleColour}used for install 'wmctrl': workspaces controller; and 'zenity': gtk floats${endColour})\n"
  exit 1
fi

# Print initial message
function print_initialMessage(){
  # print - install Header
  echo -e "\n${greenColour}[ Installing - Pomodoro Screen ]${endColour}\n"
}

# dependencies, Checks and installs
function checkDependencies(){
  set -e
  set -u
  counter=0
  #dependencies_array=(wmctrl zenity)
  dependencies_array=("$@")
  echo -e "${yellowColour}Checking Dependencies...${endColour}"
  for program in "${dependencies_array[@]}"; do
    if [ ! "$(command -v $program)" ]; then
      echo -e "   ${cyanColour}[δ]${endColour}${yellowColour}The program is not installed${endColour}"
      apt-get install $program -y
    fi
      echo -e "     ${greenColour}[Φ]${endColour}${yellowColour}Program $program is Installed${endColour}"
      let counter+=1
  done
  echo -e "   ${greenColour}✔${endColour} ${purpleColour} Correctly installed dependencies${endColour}\n"
}

# add pomodoroScreen to Path
function addToPath(){
  zenity --question --text="add 'pomodoroScreen' to your PATHs?" --width 280
  if [ ${?} == 0 ]; then
    cp pomodoroScreen.sh /usr/local/bin/pomodoroScreen && chmod 755 /usr/local/bin/pomodoroScreen
    echo -e "Then, you can run the program executing 'pomodoroScreen'"
  else
    echo -e "So, you can use the program typing './pomodoroScreen'" 
    chmod 755 pomodoroScreen.sh
  fi
  echo -e "\n"
}

function main_Installer(){
  print_initialMessage
  # Dependencies, checking and install 
  dependences_array=("wmctrl" "zenity")
  checkDependencies "${dependences_array[@]}"
  # Asking if add or not add to Path
  addToPath
}
main_Installer
