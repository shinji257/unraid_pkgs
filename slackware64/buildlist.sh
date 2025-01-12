#!/bin/sh
#
# USE AT YOUR OWN RISK!!!!!
#
# buildlist.sh
#
# Builds a recursive directory list file like the FILELIST.TXT that ships
# with Slackware Linux.
#
# Usage:
# Run ./buildlist.sh path/to/directory
# or ./buildlist.sh /path/to/directory /path/to/listfile
# listfile being the name of the new file that will be created, of course.

LISTFILE=FILE_LIST    # Default listfile
CHECKFILE=CHECKSUMS.md5
# Uncomment one or the other, but not both
#SIZEOP=h                 # Use human readable sizes vs bytes (ie MB/KB)
SIZEOP=""                # Use bytes for sizes

if test "$1" == ""; then
        echo "Usage: $0 directory listfile(optional)"
        exit
else
        if test ! -d $1; then
                echo "Error: $1 - No such directory..."
                exit
        fi;
fi;

if test "$2" != ""; then
        LISTFILE=$2
fi;

echo "Building \"${LISTFILE}\" from \"$1\""

date > ${LISTFILE}
cat <<- EOF >> ${LISTFILE}

Directory listing of $1

EOF

find ${1} -exec ls -dl${SIZEOP} --full-time {} \; \
        | awk '{ printf("%10s %2s %4s %4s %8s %10s %-5.5s %s\n",$1,$2,$3,$4,$5,$6,$7,$9) }' > templist.txt

if [ -f ${LISTFILE} ]; then
  rm -f ${LISTFILE}
fi
sort +7d templist.txt >> ${LISTFILE}
rm templist.txt
sed -i '/templist.txt/d' ${LISTFILE}
sed -i '/buildlist.sh/d' ${LISTFILE}

if [ -f ${CHECKFILE} ]; then
  rm -f ${CHECKFILE}
fi
find ${1} -exec md5sum {} \; >> ${CHECKFILE}

echo "Done!"
