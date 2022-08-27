#!/bin/bash

export JASON_HOME=/home/nmontes/jason-3.1
export NUMPLAYERS=2

for SEED in $(eval echo {$1..$2})
do
	export MAS_FILE=hanabi-$NUMPLAYERS-$SEED.mas2j
	cp /home/nmontes/tomabd/examples/hanabi/scripts/hanabi_template_$NUMPLAYERS.mas2j $MAS_FILE
	sed -i s+NUMPLAYERS+$NUMPLAYERS+g $MAS_FILE
	sed -i s+SEED+$SEED+g $MAS_FILE
			
	$JASON_HOME/scripts/jason $MAS_FILE
	rm $MAS_FILE
done
