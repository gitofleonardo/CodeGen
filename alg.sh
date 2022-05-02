#!/bin/bash

NUM_COUNT=
FILENAME=

while getopts 'n:f:' OPTION
do
	case $OPTION in
		n) NUM_COUNT=$OPTARG
			;;
		f) FILENAME=$OPTARG
			;;
		*) echo "Usage:${0##*/} [-n DIGIT_NUM] [-f FILENAME]" >&2
			exit 2
			;;
	esac
done

if test $NUM_COUNT -gt 10 -o $NUM_COUNT -lt 1
then
	echo "DIGIT_NUM values from 1 to 10" >&2
	exit 2
fi

cat <<EOF >> $FILENAME
#include<iostream>
using namespace std;

int main(){
	cout<<"请输入一个不多于${NUM_COUNT}位的正整数:";
	int x;
	cin>>x;

	switch(x){

EOF

CNT=0
CUR_NUM=0
WD_IN_CHINESE=('个' '十' '百' '千' '万' '十万' '百万' '千万' '亿' '十亿')
while test ${#CUR_NUM} -le $NUM_COUNT
do
	CNT=${#CUR_NUM}
	echo "	case $CUR_NUM:" >> $FILENAME
	echo "		cout<<\"是${CNT}位数\"<<endl;" >> $FILENAME
	START=0
	while test $START -lt $CNT
	do
		POS=`expr $CNT - $START - 1`
		echo "		cout<<\"${WD_IN_CHINESE[${START}]}位数是:${CUR_NUM:${POS}:1}\"<<endl;" >> $FILENAME
		let "START++"
	done
	REVERSE=`echo "$CUR_NUM" | rev`
	echo "		cout<<\"倒过来是:$REVERSE\"<<endl;" >> $FILENAME
	echo "		break;" >> $FILENAME
	let "CUR_NUM++"
done

echo "	}" >> $FILENAME
echo "	return 0;" >>$FILENAME
echo "}" >> $FILENAME
