
new_dot_dir()
{
    if [[ -z "${DOT_DIR_NAME}" ]]; then
        echo "Name cannot be empty!"
        exit 1
    fi
    if [[ -e "${DOT_DIR_PATH}" ]]; then
        echo "Already exists: ${DOT_DIR_PATH}"
        exit 1
    fi

    echo "Creating new dot files folder..."
    mkdir "${DOT_DIR_PATH}"
    echo "Created: ${DOT_DIR_PATH}"
}
