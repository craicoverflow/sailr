#!/bin/sh

# checks that jq is usable
function check_jq_exists_and_executable {
if ! [ -x "$(command -v jq)" ]; then
  echo -e "\`commit-msg\` hook failed. Please install jq."
  exit 1
fi
}

# set values from config file to variables
function set_config_values() {
  config=sailr.json

  enabled=$(jq -r .enabled $config)

  if [[ ! -f $config || ! $enabled ]]; then
    exit 0
  fi

  revert=$(jq -r .revert $config)
  types=($(jq -r '.types[]' $config))
  min_length=$(jq -r .length.min $config)
  max_length=$(jq -r .length.max $config)
}

# build the regex pattern based on the config file
function build_regex() {
  set_config_values

  regexp="^("

  if $revert; then
    regexp="${regexp}revert: )?(\w+)("
  fi

  for type in "${types[@]}"
  do
    regexp="${regexp}$type|"
  done

  regexp="${regexp})(\(.+\))?: "

  regexp="${regexp}.{$min_length,$max_length}$"
}

# Print out a standard error message which explains
# how the commit message should be structured
function print_error() {
  echo -e "\n\e[1m\e[31m[INVALID COMMIT MESSAGE]"
  echo -e "------------------------\033[0m\e[0m"
  echo -e "\e[1mValid types:\e[0m \e[34m${types[@]}\033[0m"
  echo -e "\e[1mMax length (first line):\e[0m \e[34m$max_length\033[0m"
  echo -e "\e[1mMin length (first line):\e[0m \e[34m$min_length\033[0m\n"
}

# make sure jq is installed
check_jq_exists_and_executable

# get the first line of the commit message
msg=$(head -1 $1)

build_regex

if [[ ! $msg =~ $regexp ]]; then
  # commit message is invalid according to config - block commit
  print_error
  exit 1
fi
