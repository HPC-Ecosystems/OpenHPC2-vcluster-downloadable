#!/bin/bash

# Define the list of compute nodes
compute_nodes=("compute00" "compute01")

# Loop through the compute nodes and restart slurmd service
#for node in "${compute_nodes[@]}"; do
#    pdsh -w $node "sudo systemctl restart slurmd"
#done

pdsh -w compute0[0-1] "systemctl restart slurmd"
pdsh -w compute0[0-1] "sed -i 's/127.0.1.1 smshost smshost/#127.0.1.1 smshost smshost/' /etc/hosts"

# resume nodes to service
scontrol update nodename=compute0[0-1] state=resume

# Print a success message
echo "slurmd service restarted on compute00 and compute01."
