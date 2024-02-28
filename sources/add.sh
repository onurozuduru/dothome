
add_to_dot_dir()
{
    local file_to_add_path="$1"

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
    if [[ ! -f "${file_to_add_path}" ]]; then
        echo "File does not exist OR not a file: ${file_to_add_path}"
        exit 1
    fi
    if [[ ! -d "${DOT_DIR_PATH}" ]]; then
        echo "Dot files folder does not exist: ${DOT_DIR_PATH}"
        exit 1
    fi

    # Take relative path and do not resolve symbolic links
    local new_file_path=$(realpath -s --relative-to="${BASE_PATH}" "${file_to_add_path}")
    new_file_path="${new_file_path//${pattern_match}/${pattern_replace}}"
    if [[ "${new_file_path::1}" == '.' ]]; then
        new_file_path="${PREFIX_NO_DOT}${new_file_path#.}"
    fi
    new_file_path="${DOT_DIR_PATH}/${new_file_path}"

    if [[ -e "${new_file_path}" ]] || [[ -L "${new_file_path}" ]]; then
        echo "File already exist: ${new_file_path}"
        echo "Cannot overwrite, please remove existing file!"
        exit 1
    fi

    echo "Moving file under '${DOT_DIR_NAME}'..."
    local new_file_dir=$(dirname "${new_file_path}")
    mkdir -p "${new_file_dir}"
    if ! mv "${file_to_add_path}" "${new_file_path}"; then
        echo "Could not move the file from '${file_to_add_path}' to '${new_file_path}'"
        exit 1
    fi
    echo "File moved: ${new_file_path}"

    link_file "${new_file_path}" "${file_to_add_path}"
}
