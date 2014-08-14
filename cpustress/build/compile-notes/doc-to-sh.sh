#!/bin/sh

awk '
BEGIN {
    print "#!/bin/bash";
}
{
    if ($0 ~ /^ \$ /) {
        is_code = 1;
        sub(/^ \$ /, "");
        print ;
    } else if (is_code == 1 && $0 ~ /^     /) {
        sub(/^     /, "");
        print ;
    } else {
        is_code = 0;
        if ($0 == "")
            print "";
        else
            print "# " $0;
    }
}
' toolchain.txt >toolchain.sh
