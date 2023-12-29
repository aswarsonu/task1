#!/bin/bash

# internsctl v0.1.0 - Custom Linux Command

# Function to display usage information
function display_usage {
    echo "Usage: internsctl [OPTIONS]"
    echo "       internsctl cpu getinfo"
    echo "       internsctl memory getinfo"
    echo "Custom Linux Command "
    echo
    echo "Options:"
    echo "  --help         Display this help message"
    echo "  --version      Display version information"
    echo 
    echo "CPU Operations:"
    echo " cpu get info    Display CPU information"
    echo "Memory Operations:"
    echo " memory getinfo  Display memory information"
    
}

# Function to create a new user
create_user() {
    if [ -z "$1" ]; then
        echo "Error: Missing username. Usage: internsctl user create <username>"
        exit 1
    fi

    sudo useradd -m -s /bin/bash "$1"
    sudo passwd "$1"
    echo "User '$1' created successfully."
}

# Function to list all regular users
list_users() {
    getent passwd | grep -E '/bin/(bash|sh)$' | cut -d: -f1
}

# Function to list users with sudo permissions
list_sudo_users() {
    getent group sudo | cut -d: -f4 | tr ',' '\n'
}
# Function to display version information
function display_version {
    echo "internsctl v0.1.0"
}

# Function to get CPU information
function get_cpu_info {
    lscpu
}

# Function to get Memory information
function get_memory_info {
    free -h 
}

# Funtion to get file information
function get_file_info {
    local filename=$1
        echo "File: $filename"
        echo "Access: $(stat -c %A $filename)"
        echo "Size(B): $(stat -c %s $filename)"
        echo "Owner: $(stat -c %U $filename)"
        echo "Modify: $(stat -c %y $filename)"
    
}    
 
# Main script logic
case "$1" in
     --help)
        display_usage
        ;;
     --version)
        display_version
        ;;
      cpu)
          case "$2" in
             getinfo)
                 get_cpu_info
                 ;;
             *)
                 echo "Error: Unknown CPU operation. Use 'internsctl --help' for usage information."
                 exit 1
                 ;;
          esac
          ;;
       memory)
          case "$2" in
             getinfo)
                 get_memory_info
                 ;;
             *)
                 echo "Error: Unknown memory operation. Use 'internsctl --help' for usage information."
                 exit 1
                 ;;
          esac
          ;;
        file)
            case "$2" in
                getinfo)
                    # check if filename provided
                    if [ -z "$3" ]; then
                        echo "Error: Missing filename. Use 'internsctl --help' for usage information."
                        exit 1
                    fi
                    get_file_info "$3"
                    ;;
                 *)
                    echo "Error: Unknown file operation. UUse 'internsctl --help' for usage information."
                    exit 1
                    ;;
            esac
            ;;   
                    
      *)
          echo "Error: Unknown option. Use 'internsctl --help' for usage information."
          exit 1
          
          case "$1" in
        "user")
            case "$2" in
                "create")
                    create_user "$3"
                    ;;
                "list")
                    if [ "$3" == "--sudo-only" ]; then
                        list_sudo_users
                    else
                        list_users
                    fi
                    ;;
                *)
                    echo "Error: Unknown user command. Use 'internsctl --help' for usage information."
                    exit 1
                    ;;
            esac
            ;;
        "--version")
            show_version
            ;;
        "--help")
            usage
            ;;
        *)
            echo "Error: Unknown command. Use 'internsctl --help' for usage information."
            exit 1
            ;;
    esac
          ;;
    
esac
