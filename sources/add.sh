
add_to_dot_dir()
{
    local file_to_add_path="$1"
    local files_to_add

    local pattern_match="\/${PREFIX_DOT}"
    local pattern_replace="/${PREFIX_NO_DOT}"

    if [[ -z "${file_to_add_path}" ]]; then
        echo "Please give file path to add!"
        exit 1
    fi
    if [[ -L "${file_to_add_path}" ]]; then
        echo "File is a link: ${file_to_add_path}"
        local link_target=$(realpath "${file_to_add_path}")
        echo "Links cannot be used as dot files, real path of the file: '${link_target}'"
        exit 1
    fi
    if [[ -d "${file_to_add_path}" ]]; then
        files_to_add=$(find "${file_to_add_path}" -type f ! -path "*.github/*" ! -path "*.git/*" -printf '%p\n')
    else
        if [[ ! -f "${file_to_add_path}" ]]; then
            echo "Does not exist: ${file_to_add_path}"
            exit 1
        fi

        files_to_add="${file_to_add_path}"
    fi
    if [[ ! -d "${DOT_DIR_PATH}" ]]; then
        echo "Dot files folder does not exist: ${DOT_DIR_PATH}"
        exit 1
    fi

    for file_to_add_path in ${files_to_add}
    do
        # Take relative path and do not resolve symbolic links
        local new_file_path=$(realpath -s --relative-to="${BASE_PATH}" "${file_to_add_path}")
        new_file_path="${new_file_path//${pattern_match}/${pattern_replace}}"
        if [[ "${new_file_path::1}" == '.' ]]; then
            new_file_path="${PREFIX_NO_DOT}${new_file_path#.}"
        fi
        new_file_path="${DOT_DIR_PATH}/${new_file_path}"

        if [[ -e "${new_file_path}" ]] || [[ -L "${new_file_path}" ]]; then
            log_error "File already exist: ${new_file_path} \nCannot overwrite, please remove existing file!"
            continue
        fi

        echo "Moving file under '${DOT_DIR_NAME}'..."
        local new_file_dir=$(dirname "${new_file_path}")
        mkdir -p "${new_file_dir}"
        if ! mv "${file_to_add_path}" "${new_file_path}"; then
            log_error "Could not move the file from '${file_to_add_path}' to '${new_file_path}'"
            continue
        fi
        echo "File moved: ${new_file_path}"

        link_file "${new_file_path}" "${file_to_add_path}"
    done
}
