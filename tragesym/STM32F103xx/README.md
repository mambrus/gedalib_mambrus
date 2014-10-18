# STM32F103x6 STM32F103x8 STM32F103xB
## Extract raw symbol data 

### LQFP48 uS:s
* STM32F103Cx

    cat all_table.txt | \
		grep -Ev '^#' | \
		awk '$2!="-"{print $2";"$5";"$6}' |\
		sed -E 's/I\/O$/io/;s/I$/in/;s/O$/out/;s/S$/pwr/' | \
		tee LQFP48_table.txt

####Manual changes
pin 5 & 6
OSC_IN, OSC_OUT

### LQFP64 uS:s
* STM32F103Rx

    cat all_table.txt | \
		grep -Ev '^#' | \
		awk '$3!="-"{print $3";"$5";"$6}' |\
		sed -E 's/I\/O$/io/;s/I$/in/;s/O$/out/;s/S$/pwr/' | \
		tee LQFP64_table.txt

### LQFP100 uS:s
* STM32F103Vx


    cat all_table.txt | \
		grep -Ev '^#' | \
		awk '$4!="-"{print $4";"$5";"$6}' |\
		sed -E 's/I\/O$/io/;s/I$/in/;s/O$/out/;s/S$/pwr/' | \
		tee LQFP100_table.txt

### BGA100 uS:s
* STM32F103Vx

    cat all_table.txt | \
		grep -Ev '^#' | \
		awk '$1!="-"{print $1";"$5";"$6}' |\
		sed -E 's/I\/O$/io/;s/I$/in/;s/O$/out/;s/S$/pwr/' | \
		tee BGA100_table.txt

## Generate symbol
* Paste pins in spread-sheet
* Change attributes to suite
* Save spread-sheet
* Export as text into a name <device>.src
   * Make sure strings are not quoted (")
   * Separator must be <TAB>
* Run tragesym. Example:
    tragesym STM32F103Cx.src ../../sym/STM32F103Cx.sym
