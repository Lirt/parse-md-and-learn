#!/usr/bin/env bash

set -u

# Colors
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
MAGENTA=$(tput setaf 5)


function ask_question() {
  local question="$1"
  local answer="$2"

  clear
  if [ -n "$question" ] && [ -n "$answer" ]; then
    printf "${CYAN}Question [Enter to cont.]: \n${NORMAL}%s?\n" "$question"
    read -r -s -n1 key
    [ "$key" = "q" ] && exit 0

    if [ "$key" = "" ]; then
      printf "${GREEN}Answer [Enter to cont.]: \n${NORMAL}%s" "$answer"
      read -r -s -n1 key
      [ "$key" = "q" ] && exit 0
    fi
  fi
}

function ask_input_question() {
  local question="$1"
  local answer="$2"
}

function randomize_questions() {
  :
}

function parse_headers() {
  local headers
  headers=$(grep -E "^[#]+.*$" "$1")
  echo "$headers"
}

function get_section_lineno() {
  local section_name file line
  section_name="$1"
  file="$2"
  line=$(grep -En "^$section_name$" "$file")
  # Strip line number from grep output
  echo "${line%%:*}"
}

function get_section_content() {
  # Reads section contents from start to next lower level section
  local file_content section_prefix section_lineno section_content
  local section_name="$1"
  local file="$2"

  section_prefix=${section_name%% *}

  section_lineno=$(get_section_lineno "$section_name" "$file")
  file_content=$(tail -n "+$section_lineno" "$file")

  # Read until we get into next section with same or lower level
  IFS=$'\n'; for line in $file_content; do
    if [[ "$line" =~ ^#{,${#section_prefix}}\ .*$ ]] && [[ "$line" != "$section_name" ]]; then
      # Section |$line| is at same or lower level (topsection)
      break
    elif [[ "$line" =~ ^#{${#section_prefix},}\ .*$ ]]; then
      # Section |$line| is at same or higher level (subsection)
      :
    fi
    section_content+="$line\n"
  done

  echo -e "$section_content"
}

function create_menu() {
  local headers="$1"
  local selection

  headers=$(sed 's/#/  /g' <<< "$headers")
  selection=$(dmenu -b -l 25 <<< "$headers")

  echo "${selection//  /\#}"
}

function test_special_words() {
  # Find special words (delimited by **, __)
  local content="$1"
  local word

  IFS=$'\n'; for line in $content; do
    if [[ "$line" =~ \*\*.*\*\* ]]; then
      word=$(grep -Eo -e "\*\*.*\*\*" -e "_.*_" <<< "$line")
      word="${word//\*\*/}"
      ask_question "$word" "$line"
    fi
  done
}

function test_couples() {
  local content="$1"
  local question=""
  local answer=""

  # Randomize content
  content=$(sort -R <<< "$content")

  IFS=$'\n'; for line in $content; do
    if [[ "$line" =~ \ -\ .* ]]; then
      # Get first (left) part
      question=${line%% - *}

      # Get second (right) part
      answer="${line##* - }"

      ask_question "$question" "$answer"
    fi
  done
}

function test_lists() {
  # Find line ending with `:`
  # Read next lines and look for list notations 1.|*|-|```
  # Skip empty lines
  # Skip code blocks
  local content="$1"
  local is_list=0
  local is_code_block=0
  local question=""
  local answer=""

  IFS=$'\n'; for line in $content; do
    if [ $is_list -eq 1 ] && [[ "$line" =~ ^[[:space:]]*[*-]|^[[:space:]]*[0-9]\. ]]; then
      # Read list
      answer+="$line"$'\n'
      continue
    fi
    if [[ "$line" =~ ^.*:$ ]]; then
      # Mark question
      is_list=1
      is_code_block=0

      # Print last question and answer
      ask_question "$question" "$answer"

      # Append question
      answer=""
      question="$line"
      continue
    fi
    if [[ "$line" =~ ^\`\`\`.* ]]; then
      # Mark code block
      is_list=0
      is_code_block=1
      continue
    fi
    [ "$line" = "" ] && continue
  done

  # Print last question and answer
  ask_question "$question" "$answer"
}

function main() {
  file="$1"
  if [ ! -f "$file" ]; then
    echo "File $file is not a regular file or does not exist." 1>&2
    exit 1
  fi

  headers=$(parse_headers "$file")
  selection=$(create_menu "$headers")
  content=$(get_section_content "$selection" "$file")

  selected_test=$(echo -e "Special words\nLists\nCouples" | dmenu -p "Select type of test:" -b -l 5)
  case $selected_test in
    "Special words" )
      test_special_words "$content"
      ;;
    "Lists" )
      test_lists "$content"
      ;;
    "Couples" )
      test_couples "$content"
      ;;
    * )
      ;;
  esac
}

main "$@"
