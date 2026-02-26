#! /usr/bin/env bash
set -euo pipefail

TASKWARRIOR_CONFIG="" # Used to cache the taskwarrior config.

_taskwarrior_config() {
    if [ -z "$TASKWARRIOR_CONFIG"  ]; then
        TASKWARRIOR_CONFIG="$( task _show )"
        readonly TASKWARRIOR_CONFIG
    fi

    echo "$TASKWARRIOR_CONFIG"
}

_taskwarrior_config_get() {
    local key="$1"
    local sep='='
    _taskwarrior_config | K="$key" awk -F "$sep" '$1 == ENVIRON["K"]' | cut -d "$sep" -f 2-
}

_get_filter_by_report_name() {
    local name="$1"
    _taskwarrior_config_get "report.$name.filter"
}

_count_tasks_for_report() {
    local name="$1"

    local filter
    filter="$( _get_filter_by_report_name "$name" )"

    # shellcheck disable=SC2086
    task $filter count;
}

_main() {
    echo "  $(_count_tasks_for_report 'next')   $(_count_tasks_for_report 'inbox')"
}

_main
