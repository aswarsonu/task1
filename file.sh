./#!/bin/bash

# Define the version
VERSION="v0.1.0"

# Function to display version information
show_version() {
    echo "internsctl $VERSION"
}

show_cpu_info(){
 echo "Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         44 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  12
  On-line CPU(s) list:   0-11
Vendor ID:               AuthenticAMD
  Model name:            AMD Ryzen 5 4600H with Radeon Graphics
    CPU family:          23
    Model:               96
    Thread(s) per core:  2
    Core(s) per socket:  6
    Socket(s):           1
    Stepping:            1
    Frequency boost:     enabled
    CPU max MHz:         3000.0000
    CPU min MHz:         1400.0000
    BogoMIPS:            5989.06
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mc
                         a cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall n
                         x mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_go
                         od nopl nonstop_tsc cpuid extd_apicid aperfmperf rapl p
                         ni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe
                          popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy sv
                         m extapic cr8_legacy abm sse4a misalignsse 3dnowprefetc
                         h osvw ibs skinit wdt tce topoext perfctr_core perfctr_
                         nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate
                          ssbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 sm
                         ep bmi2 cqm rdt_a rdseed adx smap clflushopt clwb sha_n
                         i xsaveopt xsavec xgetbv1 cqm_llc cqm_occup_llc cqm_mbm
                         _total cqm_mbm_local clzero irperf xsaveerptr rdpru wbn
                         oinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale v
                         mcb_clean flushbyasid decodeassists pausefilter pfthres
                         hold avic v_vmsave_vmload vgif v_spec_ctrl umip rdpid o
                         verflow_recov succor smca sev sev_es
Virtualization features: 
  Virtualization:        AMD-V
Caches (sum of all):     
  L1d:                   192 KiB (6 instances)
  L1i:                   192 KiB (6 instances)
  L2:                    3 MiB (6 instances)
  L3:                    8 MiB (2 instances)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-11
Vulnerabilities:         
  Gather data sampling:  Not affected
  Itlb multihit:         Not affected
  L1tf:                  Not affected
  Mds:                   Not affected
  Meltdown:              Not affected
  Mmio stale data:       Not affected
  Retbleed:              Mitigation; untrained return thunk; SMT enabled with ST
                         IBP protection
  Spec rstack overflow:  Mitigation; safe RET
  Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer
                          sanitization
  Spectre v2:            Mitigation; Retpolines, IBPB conditional, STIBP always-
                         on, RSB filling, PBRSB-eIBRS Not affected
  Srbds:                 Not affected
  Tsx async abort:       Not affected
"
}

# Function to display usage information
usage() {
    echo "Usage: internsctl [options]"
    echo "Options:"
    echo "  cpu getinfo         Get CPU information"
    echo "  memory getinfo      Get memory information"
    echo "  user create <username>    Create a new user"
    echo "  file getinfo [options] <file-name>   Get information about a file"
    echo "  user list                  List all regular users"
    echo "  user list --sudo-only      List users with sudo permissions"
    echo "  file getinfo [options] <file-name>   Get information about a file"
    echo "    Options for file getinfo:"
    echo "  file getinfo <file-name>   Get information about a file"
    echo "  user create <username>    Create a new user"
    echo "  user list                 List all regular users"
    echo "  user list --sudo-only     List users with sudo permissions"
    echo "      --size, -s            Print file size"
    echo "      --permissions, -p     Print file permissions"
    echo "      --owner, -o           Print file owner"
    echo "      --last-modified, -m   Print last modified time"
    echo "  --version           Show version information"
    echo "  --help              Show this help message"
}

# Function to get information about a file
get_file_info() {
    local file_name="$1"

    # Check if file exists
    if [ ! -e "$file_name" ]; then
        echo "Error: File '$file_name' not found."
        exit 1
    fi

    # Output file information
    echo "File: $file_name"
    echo "Access: $(ls -l "$file_name" | cut -d ' ' -f 1)"
    echo "Size(B): $(stat -c%s "$file_name")"
    echo "Owner: $(stat -c%U "$file_name")"
    echo "Modify: $(stat -c%y "$file_name")"
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

# Function to get information about a file with options
get_file_info() {
    local file_name="$1"
    local size_option=false
    local permissions_option=false
    local owner_option=false
    local last_modified_option=false

    # Parse options
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --size | -s)
                size_option=true
                ;;
            --permissions | -p)
                permissions_option=true
                ;;
            --owner | -o)
                owner_option=true
                ;;
            --last-modified | -m)
                last_modified_option=true
                ;;
            *)
                echo "Error: Unknown option '$1'. Use 'internsctl --help' for usage information."
                exit 1
                ;;
        esac
        shift
    done

    # Check if file exists
    if [ ! -e "$file_name" ]; then
        echo "Error: File '$file_name' not found."
        exit 1
    fi

    # Output requested information
    echo "File: $file_name"
    echo "Access: $(ls -l "$file_name" | cut -d ' ' -f 1)"
    [ "$size_option" == true ] && echo "Size(B): $(stat -c%s "$file_name")"
    [ "$owner_option" == true ] && echo "Owner: $(stat -c%U "$file_name")"
    [ "$last_modified_option" == true ] && echo "Modify: $(stat -c%y "$file_name")"
}


# Main function
main() {
    case "$1" in
        "cpu")
            case "$2" in
                "getinfo")
                    # Function for getting CPU info
                    show_cpu_info
                    ;;
                *)
                    echo "Error: Unknown CPU command. Use 'internsctl --help' for usage information."
                    exit 1
                    ;;
            esac
            ;;
        "memory")
            case "$2" in
                "getinfo")
                    # Function for getting memory info
                    "              total        used        free      shared  buff/cache   available
Mem:        15767196     5534620     6179620      317900     4052956     9578264
Swap:        2097148           0     2097148
"
                    ;;
                *)
                    echo "Error: Unknown memory command. Use 'internsctl --help' for usage information."
                    exit 1
                    ;;
            esac
            ;;
        "user")
            case "$2" in
                "create")
                    # Function for creating a new user
                    ;;
                "list")
                    # Function for listing users
                    ;;
                *)
                    echo "Error: Unknown user command. Use 'internsctl --help' for usage information."
                    exit 1
                    ;;
            esac
            ;;
        "file")
            case "$2" in
                "getinfo")
                    shift # Consume "getinfo" argument
                    get_file_info "$@"
                    ;;
                *)
                    echo "Error: Unknown file command. Use 'internsctl --help' for usage information."
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
   case "$1" in
        "file")
            case "$2" in
                "getinfo")
                    shift # Consume "getinfo" argument
                    get_file_info "$@"
                    ;;
                *)
                    echo "Error: Unknown file command. Use 'internsctl --help' for usage information."
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
    
}




# Execute the main function
main "$@"
