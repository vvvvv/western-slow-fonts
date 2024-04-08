#!/usr/bin/env bash

declare line_prefix="⋅⋅⋅" # prefix to add to each line
declare line_postfix="" # postfix to add to each line

declare -i line_length=120 # number of characters per line not including prefix and postfix
declare timeout=10 # number of seconds to run before exiting
declare print_inline=false # print each line without a newline

declare -i _loop_pid # pid of the print_loop function

_parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --line-length)
        line_length="${2}"
        shift 2
        ;;
      --line-prefix)
        line_prefix="${2}"
        shift 2
        ;;
      --line-postfix)
        line_postfix="${2}"
        shift 2
        ;;
      --print-inline)
        print_inline=true
        shift
        ;;
      --timeout)
        timeout="${2}"
        shift 2
        ;;
      --help)
        echo "Usage: $0"
        echo "    [--timeout <number>]                 Specifies the duration, in seconds, for which this script will execute before terminating. Use 0 to continue executing indefinitely (default: ${timeout})"
        echo "    [--line-length <number>]             Number of characters per line (default: ${line_length})"
        echo "    [--line-prefix <string>]             Prefix to add to each line (default: ${line_prefix})"
        echo "    [--line-postfix <string>]            Postfix to add to each line (default: ${line_postfix})"
        echo "    [--print-inline]                     Print each line without a newline. Even worse performance"
        exit 0
        ;;
      *)
        break
        ;;
    esac
  done
}

_print_loop(){
  while read -r line; do
    if ${print_inline} ; then 
      printf "%s%s%s" "${line_prefix}" "${line}" "${line_postfix}" 
    else
      printf "%s%s%s\n" "${line_prefix}" "${line}" "${line_postfix}" 
    fi
  done < <(cat /dev/random | iconv -c -t ascii 2>/dev/null | tr -cd '[:print:]' | tr -d '\[\]\$\\' | fold -w ${line_length} )
}

_stop_loop(){
  if kill -0 "${_loop_pid}" &>/dev/null; then 
    kill "${_loop_pid}"
  fi
}

trap '_stop_loop; exit 0' SIGINT

main() {
  _parse_args "${@}"

  _print_loop &
  _loop_pid="${!}"

  sleep "${timeout}"

  _stop_loop
}

main "${@}"
