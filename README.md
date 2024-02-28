# dothome
Simple dot files manager script that requires Bash version 4 or higher.

```bash
Usage: ./dothome [ -b | --base <DIR> ] [ -d | --dotfiles <NAME> ] [ -n | --new ] [ -i | --init ] [ -a | --add <FILE> ] [ -h | --help ]
Simple dot files manager.
        -b,--base <DIR>         Base directory to use for operations. Default: '/home/onur'
        -d,--dotfiles <NAME>    Name of a directory relative to base directory to use for operations. Default: 'dotfiles'
        -n,--new                Create new dot files directory under base directory.
        -i,--init               Link files from dot files directory to their relative locations under base directory.
        -a,--add <FILE>         Move given file to dot files directory and create link under base directory.
        -h,--help               Display help.
```

## How It Works
It uses `${HOME}` as default base directory and takes with `-d` a relative directory name to use as dot files directory.
Basically reflects the home folder structure under dot files directory and links related files to their dot files directory version.
Converts names start with '.' to a version starts with 'dot.' under dot files to not having hidden files under dot files.

### New
Creates a new dot files directory.

### Add
Moves given file to dot files directory then creates link to the original location.
The moved version of the file starts with 'dot.' if it starts with '.'

### Init
Creates links relative to dot files location under base directory.
If there is already created dot files then it is  possible to link files under home with this option.
