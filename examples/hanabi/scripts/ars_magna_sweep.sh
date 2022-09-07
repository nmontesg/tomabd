#!/bin/bash

# sbatch options
#SBATCH --job-name=hanabi_runs
#SBATCH --time=00-24:00:00
#SBATCH --mem-per-cpu=2G

#SBATCH --output=/home/nmontes/logs/%x-%j.log
#SBATCH --error=/home/nmontes/logs/%x-%j.err
#SBATCH --mail-user=nmontes@iiia.csic.es

# You must carefully match tasks, cpus, nodes,
# and cpus-per-task for your job. See docs.
#SBATCH --tasks=10
#SBATCH --nodes=10
#SBATCH --cpus-per-task=20
#SBATCH --tasks-per-node=1

# load Java
spack load openjdk@17.0.0_35

export RUNS_PER_NODE=50

for i in $(seq 1 $SLURM_JOB_NUM_NODES)
do
	let FIRST=($i-1)*$RUNS_PER_NODE
	let SECOND=$i*$RUNS_PER_NODE-1
	srun -N1 -n1 --exclusive bash scripts/ars_magna_node.sh $1 $FIRST $SECOND &
done

wait
