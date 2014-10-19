#! /bin/bash

# Detect where we are, regardless of this is a link or invoked from anywhere,
# then use this path for further sub-scripting.
pushd "$(dirname $0)" > /dev/null
THIS_DIR=$(pwd)
export PATH=${THIS_DIR}:$PATH

source ${THIS_DIR}/bin/ask_user_continue.sh
TS=$(date "+%y%m%d_%H%M%S")

#Execute arguments verbosely
function dover() {
	echo "$@"
	"$@"
}
set -e
set -u
set -o pipefail

autogen.sh
configure

NO_PREV_GAFRC="No"

if ! [ -d ~/.gEDA ]; then
	mkdir ~/.gEDA
	NO_PREV_GAFRC="Yes"
fi

if ! [ -f ~/.gEDA/gafrc ]; then
	touch ~/.gEDA/gafrc
	NO_PREV_GAFRC="Yes"
fi

echo "* Installing user-wide [gafrc]"
# Fix prerequisite
F=~/.gEDA/gafrc
if [ -L $F ]; then
	#If link, make sure it's not broken
	if readlink -q $F >/dev/null ; then
		echo "$F: is a bad link. Replacing with fresh file"
		dover $F ${F}_BADLINK_${TS}.bak
		dover touch $F
		NO_PREV_GAFRC="Yes"
	fi
fi

# Component libraries adding, both specific directories and
# search-directories in one go. 
# Arg #1 is the type of search in ./dot/gafrc
function install_gafrc_path() {
	local SEARCH_FOR=$1

	for SYM_LIB in $(
		grep -vE '^;' dot/gafrc | \
		grep "${SEARCH_FOR}" | \
		tr '"' ' ' | \
		awk '{print $2}'
	); do
		echo "  Test for installing ${SYM_LIB}"
		set +e
		INSTALLED_GAFRC=$(grep ${SYM_LIB} $F | grep -vE '^;')
		set -e

		if [ "no$INSTALLED_GAFRC" == "no" ]; then
			echo "  Adding this symbol-library to your user-config"
			grep  ${SYM_LIB} dot/gafrc | grep -vE '^;' >> $F
		else
			echo "  User-config already knows about this library."
			echo "  Skipping modifying $(echo $F)"
		fi
	done
}

if [ "x${NO_PREV_GAFRC}" == "xYes"  ]; then
	dover cp dot/gafrc ~/.gEDA/gafrc
else
	install_gafrc_path "component-library"
	install_gafrc_path "source-library"
fi

function install_rc() {
	local TRG_RCFILE=~/.gEDA/$1
	local SRC_RCFILE=${THIS_DIR}/dot/${1}


	echo "* Installing user-wide [${1}]"
	if [ -e ${TRG_RCFILE} ]; then
		set +u
		set +e
		ask_user_continue \
			"${TRG_RCFILE} already exists. Overwrite (current will be backed-up)? (Y/n)"\
			"Installing ${TRG_RCFILE}. Current backed up as ${TRG_RCFILE}_${TS}.bak"\
			"Keeping old ${TRG_RCFILE}"
		RC=$?

		set -u
		set -e
		if [ $RC -eq 0 ]; then
			dover cp ${TRG_RCFILE} ${TRG_RCFILE}_${TS}.bak
			# If link, make sure it's removed
			rm -f ${TRG_RCFILE}
			dover cp ${SRC_RCFILE} ${TRG_RCFILE}
		#else
		#	do_second_choice
		fi
	else
		dover cp ${SRC_RCFILE} ${TRG_RCFILE}
	fi
}

install_rc gnetlistrc
install_rc gschemrc
echo "* Install complete"

popd > /dev/null
