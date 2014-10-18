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

if ! [ -d ~/.gEDA ]; then
	mkdir ~/.gEDA
fi

if ! [ -f ~/.gEDA/gafrc ]; then
	touch ~/.gEDA/gafrc
fi

echo "* Installing user-wide [gafrc]"
F=~/.gEDA/gnetlistrc
GAFRC_DIR=$(cat dot/gafrc | tr '"' ' ' | awk '{print $2}')
if [ -L $F ]; then
	#If link, make sure it's not broken
	if ! readlink -q $F >/dev/null ; then
		echo "$F: is a bad link. Replacing with fresh file" >/dev/stderr
		touch $F
	fi
fi
INSTALLED_GAFRC={"$(grep ${GAFRC_DIR} ~/.gEDA/gafrc)"-"no"}

if [ "$INSTALLED_GAFRC" == "no" ]; then
	echo "Adding this symbol-library to your system"
	dover cat dot/gafrc >> ~/.gEDA/gafrc
else
	echo "System already knows about this library."
	echo "Skipping modifying $(echo ~/.gEDA/gafrc)"
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
