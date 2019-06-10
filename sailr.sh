#!/bin/sh

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

function build_regex() {
  set_config_values

  regexp="^("

  if $revert; then
    regexp="${regexp}revert: )?("
  fi

  for type in "${types[@]}"
  do
    regexp="${regexp}$type|"
  done

  regexp="${regexp})(\(.+\))?: "

  regexp="${regexp}.{$min_length,$max_length}$"
}

# get the first line of the commit message
msg=$(head -1 $1)

build_regex

if [[ ! $msg =~ $regexp ]]; then
  echo -e "\n\e[1m\e[31m[INVALID COMMIT MESSAGE]"
  echo -e "------------------------\033[0m\e[0m"
  echo -e "\e[1mValid types:\e[0m \e[34m${types[@]}\033[0m"
  echo -e "\e[1mMax length (first line):\e[0m \e[34m$max_length\033[0m"
  echo -e "\e[1mMin length (first line):\e[0m \e[34m$min_length\033[0m\n"
  exit 1
fi