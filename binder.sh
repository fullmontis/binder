#!/bin/bash 

# Script for generating pdf file with pages ordered to allow binding
# Needs pdftk and convert commands

if [ $# -ne 3 ]; then
    echo "Usage: $0 INFILE OUTFILE SHEET_PER_BOOKLET"
    exit
fi

# In file
INFILE=$1
# Out file
OUTFILE=$2
# Empty sheet
EMPTYFILE="/tmp/empty.pdf"
# Pages per sheet
PPS=4
# Sheet per booklet
SPB=$3
# Total pages
TOTAL=$(pdftk "$INFILE" dump_data output|grep -i NumberOfPages|cut -d" " -f2)
# Number of booklets
EXTRA=0
[ $(( $TOTAL%($SPB*$PPS) )) -ne 0 ] && EXTRA=1
BN=$(( $TOTAL/($SPB*$PPS) + $EXTRA ))

echo "$BN booklets with $SPB sheets in each"

PAGEORDER=""

for i in $(seq 1 $BN); do
    for j in $(seq 1 $SPB); do
	ENDNUM=$(( $i * $SPB * $PPS - ($j-1) * $PPS/2 ))
	STARTNUM=$(( 1 + ($i-1) * $SPB * $PPS + ($j-1) * $PPS/2 ))
	ENDNUMPREV=$(( $ENDNUM-1 ))
	STARTNUMNEXT=$(( $STARTNUM+1 ))
	if [ $ENDNUMPREV -gt $TOTAL ]; then ENDNUMPREV="B1"; else ENDNUMPREV="A$ENDNUMPREV"; fi 
	if [ $ENDNUM -gt $TOTAL ]; then ENDNUM="B1"; else ENDNUM="A$ENDNUM"; fi 
	if [ $STARTNUMNEXT -gt $TOTAL ]; then STARTNUMNEXT="B1"; else STARTNUMNEXT="A$STARTNUMNEXT"; fi 
	if [ $STARTNUM -gt $TOTAL ]; then STARTNUM="B1"; else STARTNUM="A$STARTNUM"; fi # should not happen
	PAGEORDER="$PAGEORDER $ENDNUM $STARTNUM $STARTNUMNEXT $ENDNUMPREV"
    done
done

# create empty sheet
convert xc:none -page A4 $EMPTYFILE

# generate out file
pdftk A=$INFILE B=$EMPTYFILE cat $PAGEORDER output $OUTFILE
rm $EMPTYFILE
