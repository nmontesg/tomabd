#!/bin/bash

# sbatch options
#SBATCH --job-name=hanabi_runs
#SBATCH --time=00-8:00:00
#SBATCH --mem-per-cpu=2G

#SBATCH --output=/home/nmontes/logs/%x-%j.log
#SBATCH --error=/home/nmontes/logs/%x-%j.err
#SBATCH --mail-user=nmontes@iiia.csic.es

# You must carefully match tasks, cpus, nodes,
# and cpus-per-task for your job. See docs.
#SBATCH --tasks=4
#SBATCH --nodes=4
#SBATCH --cpus-per-task=20
#SBATCH --tasks-per-node=1

spack load python@3.8.11

for i in {2..5}
do
    srun -N1 -n1 --exclusive python3 results/single.py $i &
done

wait
