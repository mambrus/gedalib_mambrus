AC_PREREQ([2.64])

dnl Options affecting the configuration
dnl Note: Default values are set here.
dnl ----------------------------------------------------------------------------
AC_DEFUN([GEDALIB_OPTIONS_CONFIG],
[
	AC_ARG_ENABLE(verbose-config,
		AS_HELP_STRING([--enable-verbose-config],
			[Configure - Shows extra information while running configure script]),
		CONF_VERBOSE=$enableval,
		CONF_VERBOSE="no"
	)

])

dnl Checks for binaries user would need
AC_DEFUN([GEDALIB_PREREQ],
[
	AC_CHECK_PROG(HAS_GSCHEM, gschem, yes, no)
	AC_CHECK_PROG(HAS_PCB, pcb, yes, no)
	AC_CHECK_PROG(HAS_GSCH2PCB, gsch2pcb, yes, no)
	AC_CHECK_PROG(HAS_XGSCH2PCB, xgsch2pcb, yes, no)

	AC_CONFIG_AUX_DIR(.)
])

dnl Main function
AC_DEFUN([GEDALIB_MAIN],
[
	GEDALIB_OPTIONS_CONFIG

	if test $CONF_VERBOSE == "yes"; then
		echo
		echo "================================================================================"
		echo "Configuring $PWD"
		echo "================================================================================"
	fi
	GEDALIB_PREREQ

	BUILD_DIR=$(pwd)
	pushd $1 >/dev/null
	BUILD_ROOT=$(pwd)
	popd >/dev/null

	pushd ${srcdir}/$1 >/dev/null
	GEDALIB_PATH=$(pwd)
	popd >/dev/null

	AC_SUBST(GEDALIB_PATH)
	AC_SUBST(BUILD_DIR)
	AC_SUBST(BUILD_ROOT)
])
