#! /bin/bash

if ! (( "$OSTYPE" == "gnu-linux" )); then
  echo "docker-compose-golang-dev runs only on GNU/Linux operating system. Exiting..."
  exit
fi

############################ CLEAN SUBROUTINE #################################

clean() {
  docker-compose stop
  docker system prune -af --volumes
} 

############################ START SUBROUTINE #################################

start() {

###############################################################################
# 1.) Assign variables and create directory structure
###############################################################################

  #PROJECT_NAME is parent directory
  PROJECT_NAME=`echo ${PWD##*/}`
  PROJECT_UID=`id -u`
  PROJECT_GID=`id -g`
  
###############################################################################
# 2.) Generate configuration files
###############################################################################

  if [[ ! -f docker-compose.yml ]]; then
    touch docker-compose.yml
    cat <<EOF> docker-compose.yml
    version: "3.8"

    services:
      go:
        image: golang:latest
        user: $PROJECT_UID:$PROJECT_GID
        working_dir: /opt/app/api
        volumes:
          - .:/opt/app/api

EOF
  fi

###############################################################################
# 3.) Compile the source
###############################################################################

  docker-compose run go /bin/bash -c "go build `ls *.go`"
}

"$1"
