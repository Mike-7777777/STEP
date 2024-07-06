#!/bin/bash
#SBATCH --job-name=train-nn-gpu
#SBATCH -t 10:00:00                  # estimated time # TODO: adapt to your needs
#SBATCH -p gpu            # the partition you are training on (i.e., which nodes), for nodes see sinfo -p grete:shared --format=%N,%G
#SBATCH -G RTX5000:2        # requesting GPU slices, see https://docs.hpc.gwdg.de/usage_guide/slurm/gpu_usage/index.html for more options
#SBATCH --nodes=1                    # total number of nodes
#SBATCH --ntasks=1                   # total number of tasks
#SBATCH --cpus-per-task 4            # number of CPU cores per task
#SBATCH --output=./slurm_files/slurm-%x-%j.out     # where to write output, %x give job name, %j names job id
#SBATCH --error=./slurm_files/slurm-%x-%j.err      # where to write slurm error

# module load anaconda3
# module load cuda/11.1
# source activate step

export PYTHONPATH=$CONDA_PREFIX/lib/python3.9/site-packages:$PYTHONPATH

# Printing out some info.
echo "Submitting job with sbatch from directory: ${SLURM_SUBMIT_DIR}"
echo "Home directory: ${HOME}"
echo "Working directory: $PWD"
echo "Current node: ${SLURM_NODELIST}"

# For debugging purposes.
python --version
# python -m torch.utils.collect_env
nvcc -V

# Run the script:
python -u step/run.py --cfg='step/STEP_METR-LA.py' --gpus='0,1'

# Run the script with logger:
#python -u train_with_logger.py -l ~/${SLURM_JOB_NAME}_${SLURM_JOB_ID}  -t True -p True -d True -s True -f True
