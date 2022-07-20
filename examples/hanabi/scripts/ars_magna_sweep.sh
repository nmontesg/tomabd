#!/bin/bash

# sbatch options
#SBATCH --job-name=hanabi_param_sweep
#SBATCH --time=00-12:00:00
#SBATCH --mem-per-cpu=2G

#SBATCH --output=/home/nmontes/hanabi_param_sweep/%x-%j.log
#SBATCH --error=/home/nmontes/hanabi_param_sweep/%x-%j.err
#SBATCH --mail-user=nmontes@iiia.csic.es

# You must carefully match tasks, cpus, nodes,
# and cpus-per-task for your job. See docs.
#SBATCH --tasks=5
#SBATCH --nodes=5
#SBATCH --cpus-per-task=20
#SBATCH --tasks-per-node=1

# load Java
spack load openjdk@17.0.0_35

srun -N1 -n1 --exclusive bash ars_magna_node.sh 0 4 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 5 9 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 10 14 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 15 19 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 20 24 &

wait