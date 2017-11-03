#!/bin/bash

set -e

# move to working directory
cd "$( dirname "${BASH_SOURCE[0]}" )"

if [ ! -f ../.env ]; then
    echo ".env file not found"
    exit 1
fi
source ../.env
export MYSQL_PWD="$MYSQL_PASSWORD"

function extract_number()
{
    sed -n -e "s/^.*$1: \([0-9\.]\+\).*/\1/p" <<< "$summary"
}

for file in "$LOGON_LOG_DIRECTORY"/*.txt; do
    summary="$(awk '/\[LogonMonitor::LogSummary\] ******************/,/\[LogonMonitor::LogSummary\] ******************/' "$file")"

    printf -v filename "%q" "$(basename "$file")"
    printf -v username "%q" "$(sed -n -e "s/^.*User: \(.*\),.*/\1/p" <<< "$summary")"

    completed_at="$(awk 'END {print $1}' <<< "$summary")"

    total="$(extract_number 'Logon Time')"
    start_to_hive_loaded="$(extract_number 'Logon Start To Hive Loaded Time')"
    start_to_classes_hive_loaded="$(extract_number 'Logon Start To Classes Hive Loaded Time')"
    profile_sync="$(extract_number 'Profile Sync Time')"
    windows_folder_redirection_apply="$(extract_number 'Windows Folder Redirection Apply Time')"
    shell_load="$(extract_number 'Shell Load Time')"
    logon_script="$(extract_number 'Total Logon Script Time')"
    user_policy_apply="$(extract_number 'User Policy Apply Time')"
    machine_policy_apply="$(extract_number 'Machine Policy Apply Time')"
    group_policy_software_install="$(extract_number 'Group Policy Software Install Time')"
    free_disk_space_available_to_user="$(extract_number 'Free Disk Space Available To User')"

    sql="INSERT INTO logon_times (\
        filename, \
        completed_at, \
        username, \
        total, \
        start_to_hive_loaded, \
        start_to_classes_hive_loaded, \
        profile_sync, \
        windows_folder_redirection_apply, \
        shell_load, \
        logon_script, \
        user_policy_apply, \
        machine_policy_apply, \
        group_policy_software_install, \
        free_disk_space_available_to_user \
    ) VALUES (\
        '$filename', \
        '$completed_at', \
        '$username', \
        '$total', \
        '$start_to_hive_loaded', \
        '$start_to_classes_hive_loaded', \
        '$profile_sync', \
        '$windows_folder_redirection_apply', \
        '$shell_load', \
        '$logon_script', \
        '$user_policy_apply', \
        '$machine_policy_apply', \
        '$group_policy_software_install', \
        '$free_disk_space_available_to_user' \
    )"

    echo "$sql" | mysql --host "$MYSQL_HOSTNAME" --user="$MYSQL_USERNAME" "$MYSQL_DATABASE"

    gzip "$file"
    mv "$file.gz" "$LOGON_LOG_ARCHIVES/"
done
