#!/usr/bin/env sh

LIGHT_GRAY="\033[0;37m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
UNDO_COLOR="\033[0m"

release_tag=master
sailr_repo="https://github.com/craicoverflow/sailr/tree/$release_tag"

# checks that jq is usable
check_jq_exists_and_executable() {
if ! [ -x "$(command -v jq)" ]; then
  echo "\`commit-msg\` hook failed. Please install jq."
  exit 1
fi
}

# check if the config file exists
# if it doesnt we dont need to run the hook
check_sailr_config() {
  if [[ ! -f "$CONFIG" ]]; then
    echo "Sailr config file is missing. To set one see $sailr_repo#usage"
    exit 0
  fi
}

set_config() {
  local_config="$PWD/sailr.json"

  if [ -f "$local_config" ]; then
    CONFIG=$local_config
  elif [ -n "$SAILR_CONFIG" ]; then
    CONFIG=$SAILR_CONFIG
  fi
}

# set values from config file to variables
set_config_values() {
  enabled=$(jq -r .enabled "$CONFIG")

  if [[ ! $enabled ]]; then
    exit 0
  fi

  revert=$(jq -r .revert "$CONFIG")
  types=($(jq -r '.types[]' "$CONFIG"))
  min_length=$(jq -r .length.min "$CONFIG")
  max_length=$(jq -r .length.max "$CONFIG")
}

# build the regex pattern based on the config file
build_regex() {
  set_config_values

  regexp="^[.0-9]+$|"

  if $revert; then
      regexp="${regexp}^([Rr]evert|[Mm]erge):? )?.*$|^("
  fi

  for type in "${types[@]}"
  do
    regexp="${regexp}$type|"
  done

  regexp="${regexp%|})(\(.+\))?: "

  regexp="${regexp}.{$min_length,$max_length}$"
}

print_error() {
  echo "${RED}[Invalid Commit Message]${UNDO_COLOR}"
  echo "------------------------"
}

set_config

# check if the repo has a sailr config file
check_sailr_config

# make sure jq is installed
check_jq_exists_and_executable

# get the first line of the commit message
INPUT_FILE=$1
commit_message=`head -n1 $INPUT_FILE`

build_regex

commit_msg_len=${#commit_message}
if [[ $commit_msg_len -lt $min_length || $commit_msg_len -gt $max_length ]]; then
  print_error
  echo "${LIGHT_GRAY}Expected length: Min=${CYAN}$min_length${UNDO_COLOR} Max=${CYAN}$max_length${UNDO_COLOR}"
  echo "Actual length: ${YELLOW}${commit_msg_len}${UNDO_COLOR}"
  exit 1
fi

if [[ ! $commit_message =~ $regexp ]]; then
  print_error
  echo "${LIGHT_GRAY}Expected prefixes: ${CYAN}${types[@]}${UNDO_COLOR}"
  # echo "${LIGHT_GRAY}Expected Regex: ${CYAN}$regexp${UNDO_COLOR}"
  echo "Actual commit message: ${YELLOW}\"$commit_message\"${UNDO_COLOR}"
  exit 1
fi
