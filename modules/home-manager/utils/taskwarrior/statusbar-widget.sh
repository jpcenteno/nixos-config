#! /usr/bin/env bash
set -euo pipefail

_get_filter_by_report_name() {
    task _show | grep "^report.$1.filter=" | cut -d '=' -f '2-'
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
