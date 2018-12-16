#!/usr/bin/env bash

# Script options
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
    printf "${CYAN}Question [Enter to cont.]: \n${NORMAL}%s\n" "$question"
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


# Look for markdown headers - lines starting with one or more `#`
function parse_headers() {
  local file="$1"
  local headers

  headers=$(grep -E "^[#]+.*$" "$file")
  echo "$headers"
}


# Get line number where section starts
function get_section_lineno() {
  local section_name="$1"
  local file="$2"
  local line

  line=$(grep -En "^$section_name$" "$file")

  # Strip line number from grep output
  echo "${line%%:*}"
}


# Reads section contents from start to the next lower level section
function get_section_content() {
  local section_name="$1"
  local file="$2"
  local file_content section_content section_lineno section_prefix

  section_prefix=${section_name%% *}
  section_lineno=$(get_section_lineno "$section_name" "$file")
  file_content=$(tail -n "+$section_lineno" "$file")

  # Read until we get into next section with same or lower level
  IFS=$'\n'; for line in $file_content; do
    if [[ "$line" =~ ^#{,${#section_prefix}}\ .*$ ]] && [[ "$line" != "$section_name" ]]; then
      # Section is at same or lower level (section)
      break
    elif [[ "$line" =~ ^#{${#section_prefix},}\ .*$ ]]; then
      # Section is at same or higher level (subsection)
      :
    fi
    section_content+="$line\n"
  done

  echo -e "$section_content"
}


function show_menu() {
  local headers="$1"
  local selection

  headers=$(sed 's/#/  /g' <<< "$headers")
  selection=$(dmenu -b -l 25 <<< "$headers")

  echo "${selection//  /\#}"
}


# Find special words (delimited by **, __)
function test_special_words() {
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


# Find line ending with `:`
# Read next lines and look for list notations 1.|*|-|```
# Skip empty lines
# Skip code blocks
function test_lists() {
  local content="$1"
  local is_list=0
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
  selected_section=$(show_menu "$headers")
  section_content=$(get_section_content "$selected_section" "$file")

  selected_test=$(echo -e "Special words\nLists\nCouples" | dmenu -p "Select type of test:" -b -l 5)
  case $selected_test in
    "Special words" )
      test_special_words "$section_content"
      ;;
    "Lists" )
      test_lists "$section_content"
      ;;
    "Couples" )
      test_couples "$section_content"
      ;;
    * )
      ;;
  esac
}


main "$@"
