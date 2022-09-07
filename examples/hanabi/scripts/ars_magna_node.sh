#!/bin/bash

export JASON_HOME=/home/nmontes/jason-3.1

for SEED in $(eval echo {$2..$3})
do
	export MAS_FILE=hanabi-$1-$SEED.mas2j
	cp /home/nmontes/tomabd/examples/hanabi/scripts/hanabi_template_$1.mas2j $MAS_FILE
	sed -i s+NUMPLAYERS+$1+g $MAS_FILE
	sed -i s+SEED+$SEED+g $MAS_FILE
			
	$JASON_HOME/scripts/jason $MAS_FILE
	rm $MAS_FILE
done
