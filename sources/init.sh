
init_from_dot_dir()
{
    local pattern_match="${PREFIX_NO_DOT}"
    local pattern_replace="${PREFIX_DOT}"

    if [[ ! -d "${DOT_DIR_PATH}" ]]; then
        echo "Dot files folder does not exist: ${DOT_DIR_PATH}"
        exit 1
    fi

    local all_dot_files=$(find "${DOT_DIR_PATH}" -type f ! -path "*.*/*" \( ! -iname ".*" \) -printf '%P\n')

    for dot_file in ${all_dot_files}
    do
        print_line
        dot_file_path="${DOT_DIR_PATH}/${dot_file}"
        new_file_path="${dot_file//${pattern_match}/${pattern_replace}}"
        new_file_path="${BASE_PATH}/${new_file_path}"
        if [[ -e "${new_file_path}" ]] || [[ -L "${new_file_path}" ]]; then
            log_error "File already exist, cannot overwrite: ${new_file_path}"
            print_line
            continue
        fi
        new_file_dir=$(dirname "${new_file_path}")
        mkdir -p "${new_file_dir}"
        link_file "${dot_file_path}" "${new_file_path}"
        print_line
    done
}
