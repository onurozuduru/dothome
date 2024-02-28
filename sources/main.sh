
declare -A MODES
MODES["-n"]="new_dot_dir"
MODES["--new"]="new_dot_dir"
MODES["-i"]="init_from_dot_dir"
MODES["--init"]="init_from_dot_dir"
MODES["-a"]="add_to_dot_dir"
MODES["--add"]="add_to_dot_dir"

MODE=""

FILE_TO_ADD=""

print_help() {
    echo "Usage: $0 [ -b | --base <DIR> ] [ -d | --dotfiles <NAME> ] [ -n | --new ] [ -i | --init ] [ -a | --add <FILE> ] [ -h | --help ]"
    echo -e "Simple dot files manager."
    echo -e "\t-b,--base <DIR>\t\tBase directory to use for operations. Default: '${HOME}'"
    echo -e "\t-d,--dotfiles <NAME>\tName of a directory relative to base directory to use for operations. Default: '${DOT_DIR_NAME}'"
    echo -e "\t-n,--new\t\tCreate new dot files directory under base directory."
    echo -e "\t-i,--init\t\tLink files from dot files directory to their relative locations under base directory."
    echo -e "\t-a,--add <FILE>\t\tMove given file to dot files directory and create link under base directory."
    echo -e "\t-h,--help\t\tDisplay help."
}

### Get params
# -l long options (--help)
# -o short options (-h)
# : options takes argument (--option1 arg1)
# $@ pass all command line parameters.
set -e
params=$(getopt -l "base:,dotfiles:,new,init,add:,help" -o "b:d:nia:h" -- "$@")

eval set -- "$params"

### Run
while true
do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -b|--base)
            shift
            BASE_PATH="$1"
            ;;
        -d|--dotfiles)
            shift
            DOT_DIR_NAME="$1"
            ;;
        -n|--new)
            MODE="${MODE}${MODES[$1]}"
            ;;
        -i|--init)
            MODE="${MODE}${MODES[$1]}"
            ;;
        -a|--add)
            MODE="${MODE}${MODES[$1]}"
            shift
            FILE_TO_ADD="$1"
            ;;
        --)
            shift
            break
            ;;
        *)
            print_help
            exit 0
            ;;
    esac
    shift
done

if [[ -z "${DOT_DIR_NAME}" ]]; then
    echo "Dot files target name cannot be empty!"
    exit 1
fi
if [[ -z "${BASE_PATH}" ]]; then
    echo "Base path cannot be empty!"
    exit 1
fi

DOT_DIR_PATH="${BASE_PATH}/${DOT_DIR_NAME}"

if [[ -z "${MODE}" ]]; then
    echo "Provide only one of the" "${!MODES[@]}"
    exit 1
fi
if [[ "${MODE}" != "${MODES[-n]}" && "${MODE}" != "${MODES[-i]}" && "${MODE}" != "${MODES[-a]}" ]]; then
    echo "Following flags cannot be used together: " "${!MODES[@]}"
    exit 1
fi

if [[ "${MODE}" == "${MODES[-a]}" ]]; then
    ${MODE} "${FILE_TO_ADD}"
else
    ${MODE}
fi

