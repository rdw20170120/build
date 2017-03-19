#!/bin/bash
# ----------------------------------------------------------------------------
# This is ansi-color 0.6 from http://code.google.com/p/ansi-color/
# ----------------------------------------------------------------------------
# @file color
# Color and format your shell script output with minimal effort.
# Inspired by Moshe Jacobson <moshe@runslinux.net>
# @author Alister Lewis-Bowen [alister@different.com]
# ----------------------------------------------------------------------------
# This software is distributed under the MIT License.
#
# Copyright (C) 2008 Alister Lewis-Bowen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ----------------------------------------------------------------------------
# TODO: Clean up with here documents
Self=$(basename $0)

COLORS=( black red green yellow blue magenta cyan white );
NUM_COLORS=${#COLORS[@]};
EFFECTS=( nm normal bd bold ft faint it italic ul underline bk blink fb fastblink rv reverse iv invisible );
NUM_EFFECTS=${#EFFECTS[@]};

# Function: Help
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "$(${Self} bd)Color and format your shell script output with minimal effort.$(${Self})";
	echo;
	echo 'Usage:';
	echo "$(${Self} bd)${Self}$(${Self}) [ $(${Self} ul)effect$(${Self}) ] [ [lt]$(${Self} ul)fg${Self}$(${Self}) ] [ $(${Self} ul)bg${Self}$(${Self}) ]";
	echo "$(${Self} bd)${Self}$(${Self}) list";
	echo "$(${Self} bd)${Self}$(${Self}) [ -h | --help ]";
	echo;
	echo 'where:';
	echo -n "$(${Self} ul)fg${Self}$(${Self}) and $(${Self} ul)bg${Self}$(${Self}) are one of ";
	for ((i=0;i<${NUM_COLORS};i++)); do
		echo -n "$(${Self} ${COLORS[${i}]})${COLORS[${i}]}$(${Self}) ";
	done;
	echo;
	echo -n "$(${Self} ul)effect$(${Self}) can be any of ";
	for ((i=0;i<${NUM_EFFECTS};i++)); do
		echo -n "$(${Self} ${EFFECTS[${i}]})${EFFECTS[${i}]}$(${Self}) ";
	done;
	echo;
	echo "Preceed the $(${Self} ul)fg${Self}$(${Self}) with $(${Self} bd)lt$(${Self}) to use a light ${Self}."
	echo "$(${Self} bd)${Self} off$(${Self}) or $(${Self} bd)${Self}$(${Self}) resets to default ${Self}s and text effect.";
	echo "$(${Self} bd)${Self} list$(${Self}) displays all possible ${Self} combinations.";
	echo;
	echo 'Examples:';
	echo '  echo "$(${Self} ul)Underlined text$(${Self} off)"';
	echo 'results in:';
	echo "  $(${Self} ul)Underlined text$(${Self} off)";
	echo;
	echo '  echo "Make $(${Self} rv)this$(${Self} nm) reverse video text$(${Self} off)"';
	echo 'results in:';
	echo "  Make $(${Self} rv)this$(${Self} nm) reverse video text$(${Self} off)";
	echo;
	echo '  echo "$(${Self} white blue) White text on a blue background $(${Self})"';
	echo 'results in:';
	echo "  $(${Self} white blue) White text on a blue background $(${Self})";
	echo;
	echo '  echo "$(${Self} ltyellow green) lt prefix on the yellow text text $(${Self} off)"';
	echo 'results in:';
	echo "  $(${Self} ltyellow green) lt prefix on the yellow text text $(${Self} off)";
	echo;
	echo '  echo "$(${Self} bold blink red yellow) Blinking bold red text on a yellow background $(${Self})"';
	echo 'results in:';
	echo "  $(${Self} bold blink red yellow) Blinking bold red text on a yellow background $(${Self})";
	echo;
	echo;
	echo -n "Note that results may vary with these standard ANSI escape sequences because of the different configurations of terminal emulators. ";
	echo;
	exit 1;
}

# Function: List color combinations
# ----------------------------------------------------------------------------

function list {

	echo;
	echo "$(${Self} bd)These are the possible combinations of colors I can generate. ";
	echo "$(${Self} nm)Since terminal ${Self} settings vary, $(${Self} ul)the expected output may vary$(${Self}).";
	echo;
	
	for ((bg=0;bg<${NUM_COLORS};bg++)); do
		echo "${COLORS[${bg}]}:";
			for ((fg=0;fg<${NUM_COLORS};fg++)); do
				echo -n "$(${Self} ${COLORS[${fg}]} ${COLORS[${bg}]}) ${COLORS[${fg}]} $(${Self}) ";
			done;
			echo;
		echo;
	done;
	
	exit 1;
}

# Function: Test if color
# ----------------------------------------------------------------------------

function _isColor () {
  if [ -n "$1" ]; then
  	local normalize=${1#lt};
	  for ((i=0;i<${NUM_COLORS};i++)); do
	    if [ "$normalize" = ${COLORS[${i}]} ]; then return 1; fi;
		done;
	fi;
	return 0;
}

# Function: Test if text effect
# ----------------------------------------------------------------------------

function _isEffect () {
  if [ -n "$1" ]; then
	  for ((i=0;i<${NUM_EFFECTS};i++)); do
	    if [ "$1" = ${EFFECTS[${i}]} ]; then return 1; fi;
		done;
		if [ "$1" = off ]; then return 1; fi;
	fi;
	return 0;
}

# Function: Push code onto the escape sequence array
# ----------------------------------------------------------------------------

function _pushcode () { 
	codes=("${codes[@]}" $1); 
}

# Parse input arguments
# ----------------------------------------------------------------------------

if [[ "$1" = '-h' || "$1" = '--help' ]]; then help; fi;
if [ "$1" = list ];                      then list; fi;
if [[ "$1" = off || -z "$1" ]];          then 
	echo -en '\033[0m';
	exit 0;
fi;

while (( "$#" )); do

	_isColor $1;
	if [ $? -eq 1 ]; then
		if [ "$FG" = '' ]; then 
			FG=$1;
		else
		  if [ "$BG" = '' ]; then
		  	BG=$1;
		  else
		  	error="I see more than two colors. Type ${Self} -h for more information.";
		  fi;
		fi;
	else
		_isEffect $1;
		if [ $? -eq 1 ]; then
			TE=("${TE[@]}" $1);
		else
			error="I don't recognize '$1'. Type ${Self} -h for more information.";
		fi;
	fi;
	
	shift;
	
done;

if [ "$error" != '' ]; then
	echo $(${Self} bold red)${Self}: $error$(${Self}); exit 1;
fi;

# Insert text effects into the escape sequence
# ----------------------------------------------------------------------------

for ((i=0;i<${#TE[@]};i++)); do

	case "${TE[${i}]}" in
		nm | normal )      _pushcode 0;;
		bd | bold )        _pushcode 1;;
		ft | faint )       _pushcode 2;;
		it | italic )      _pushcode 3;;
		ul | underline)    _pushcode 4;;
		bl | blink)        _pushcode 5;;
		fb | fastblink)    _pushcode 6;;
		rv | reversevideo) _pushcode 7;;
		iv | invisible)    _pushcode 8;;
	esac;

done;

# Insert foreground colors into the escape sequence
# ----------------------------------------------------------------------------

if [ `expr "$FG" : 'lt'` -eq 2 ]; then _pushcode 2; fi;

case "$FG" in
	black)   _pushcode 30;;
	red)     _pushcode 31;;
	green)   _pushcode 32;;
	yellow)  _pushcode 33;;
	blue)    _pushcode 34;;
	magenta) _pushcode 35;;
	cyan)    _pushcode 36;;
	white)   _pushcode 37;;
esac;

# Insert background colors into the escape sequence
# ----------------------------------------------------------------------------

case "$BG" in
	black)   _pushcode 40;;
	red)     _pushcode 41;;
	green)   _pushcode 42;;
	yellow)  _pushcode 43;;
	blue)    _pushcode 44;;
	magenta) _pushcode 45;;
	cyan)    _pushcode 46;;
	white)   _pushcode 47;;
esac;

# Assemble and echo the ANSI escape sequence
# ----------------------------------------------------------------------------

for ((i=0;i<${#codes[@]};i++)); do
	if [ "$seq" != '' ]; then seq=$seq';'; fi;
	seq=$seq${codes[${i}]};
done;

echo -en '\033['${seq}m;

exit 0;
