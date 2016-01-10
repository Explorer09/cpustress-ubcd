#!/bin/sh

for file in toolchain flex-bison; do
    echo "#!/bin/bash" >${file}.sh
    if [ "$file" = toolchain ]; then
        echo "write_option_groups_config () {"
        if [ -f eglibc/option-groups.config ]; then
            echo "cat > option-groups.config << EOF"
            cat eglibc/option-groups.config
            echo "EOF"
        else
            # Function must not be empty.
            echo ":"
        fi
        echo "}"
    fi >>${file}.sh
    awk '
    {
        if ($0 == " $ [ -f option-groups.config ] || exit 1") {
            print "write_option_groups_config";
        }
        if ($0 ~ /^ \$ /) {
            is_code = 1;
            sub(/^ \$ /, "");
            print ;
        } else if (is_code == 1 && $0 ~ /^     /) {
            sub(/^     /, "  ");
            print ;
        } else {
            is_code = 0;
            if ($0 == "")
                print "";
            else
                print "# " $0;
        }
    }
    ' ${file}.txt >>${file}.sh
done
