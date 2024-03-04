
BASE_PATH="${HOME}"
DOT_DIR_NAME="dotfiles"
DOT_DIR_PATH=""
PREFIX_DOT='.'
PREFIX_NO_DOT='dot.'

print_line()
{
    echo "--------------------------------------------------------------------------------"
}

print_error_line()
{
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}

log_error()
{
    print_error_line
    echo -e "$1"
    print_error_line
}

link_file()
{
    local target_path
    local link_path
    target_path="$1"
    link_path="$2"

    echo "Linking file: ${target_path}"
    if ! ln -s "${target_path}" "${link_path}"; then
        echo "Could not link file: '${link_path}'->'${target_path}'"
        exit 1
    fi
    echo "File linked: '${link_path}'->'${target_path}'"
}
