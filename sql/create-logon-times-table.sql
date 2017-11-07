CREATE TABLE logon_times
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(100) NOT NULL,
    completed_at_server DATETIME NOT NULL,
    completed_at_client DATETIME NOT NULL,
    username VARCHAR(20) NOT NULL,
    total DECIMAL(5,2) NOT NULL,
    start_to_hive_loaded DECIMAL(5,2) NOT NULL,
    start_to_classes_hive_loaded DECIMAL(5,2) NOT NULL,
    profile_sync DECIMAL(5,2) NOT NULL,
    windows_folder_redirection_apply DECIMAL(5,2) NOT NULL,
    shell_load DECIMAL(5,2) NOT NULL,
    logon_script DECIMAL(5,2) NOT NULL,
    user_policy_apply DECIMAL(5,2) NOT NULL,
    machine_policy_apply DECIMAL(5,2) NOT NULL,
    group_policy_software_install DECIMAL(5,2) NOT NULL,
    free_disk_space_available_to_user DECIMAL(5,2) NOT NULL,
    INDEX logon_times_completed_at_server_index(completed_at_server)
)
