#!/bin/bash

# sbatch options
#SBATCH --job-name=hanabi_runs
#SBATCH --time=00-12:00:00
#SBATCH --mem-per-cpu=2G

#SBATCH --output=/home/nmontes/hanabi_runs/%x-%j.log
#SBATCH --error=/home/nmontes/hanabi_runs/%x-%j.err
#SBATCH --mail-user=nmontes@iiia.csic.es

# You must carefully match tasks, cpus, nodes,
# and cpus-per-task for your job. See docs.
#SBATCH --tasks=10
#SBATCH --nodes=10
#SBATCH --cpus-per-task=20
#SBATCH --tasks-per-node=1

# load Java
spack load openjdk@17.0.0_35

srun -N1 -n1 --exclusive bash ars_magna_node.sh 0 49 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 50 99 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 100 149 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 150 199 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 200 249 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 250 299 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 300 349 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 350 399 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 400 449 &
srun -N1 -n1 --exclusive bash ars_magna_node.sh 450 499 &

wait