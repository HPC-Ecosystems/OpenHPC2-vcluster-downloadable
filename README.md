# What is a cluster?

A cluster is like a team of computers or laptops that work together to accomplish tasks more efficiently than they could individually. Imagine you have a big project that would take a long time if you did it alone. If you gather a group of friends and each person works on a part of the project, you can get it done much faster. This is similar to how a cluster works: each computer, or node, in the cluster takes on part of the workload, and together they complete the task more quickly.

In your case, you're building a virtual cluster with three laptops:

Login Node (Latop 1): This is like the team leader or the coordinator. It's where you log in to give commands and manage the cluster. It doesn't do much heavy lifting but is crucial for organizing the tasks.

Compute Nodes (Laptop 2 and Laptop 3): These are like the workers. They handle the actual processing and computation. When you give a command to the login node, it distributes the work to these compute nodes. These compute nodes, we will call them compute00 and compute01.

So, when all three laptops (one login node and two compute nodes) are connected and working together, they form a cluster that can handle larger and more complex tasks than any single laptop could on its own.

# Reference Notes

We will be using these notes to test out the virtual cluster:

https://carpentries-incubator.github.io/hpc-intro/10-hpc-intro/index.html

# In-depth Virtual Cluster Install

If you would like to have an in-depth hands-on experience of deploying an **OpenHPC 2.x** cluster for yourself, there is a hands-on guide for deploying the **OpenHPC2.x virtual lab** yourself from scratch:  

https://hpc-ecosystems.gitlab.io/training/openhpc-2.x-guide/2_virtual_lab_setup/

# Quick Virtual Cluster Install

## Software Install:
1. Install VirtualBox
2. Install Vagrant
3. Install Gitbash (if using windows)

## Setup 

What you will be building

![image](https://github.com/HPC-Ecosystems/OpenHPC2-vcluster-downloadable/assets/157092105/546a11c8-372c-4950-bc28-509d52a1f056)


### Steps

1. Open gitbash and go to your desired projects/documents folder

2. Create a directory called `vcluster` to store your virtual cluster files.  
3. Navigate into the newly created directory `vcluster`.  
5. Clone the repository to the `vcluster` directory.  

```
git clone https://gitlab.com/hpc-ecosystems/training/openhpc-2.x-virtual-lab.git 
cd openhpc-2.x-virtual-lab
```

5. `cd openhpc-2.x-virtual-lab`, if you do `ls` you should see the following files:

```
.gitignore
client00.box
compute-node.box
input.local.lab
openhpc-demo-client00.ova
openhpc-demo-client01.ova
README.md
slurm.conf.lab
Vagrantfile
```

7. Delete the existing `Vagrantfile` file with `rm Vagrantfile`, and download the new  `Vagrantfile` and the `package.box` from this repo and copy them to your local .../openhpc-2.x-virtual-lab/ folder
8. Now go to this link [pre-packaged Vagrant box](https://csircoza-my.sharepoint.com/:f:/g/personal/bjohnston_csir_co_za/Elv5PJ6ScCBLmlclV_B7vb4BEdLjkuW-GdPW7iIwfEm_kQ) and go to the folder: "OpenHPC2-vCluster files" and download "openhpc2-smshost-20240724.box". and copy it to your local .../openhpc-2.x-virtual-lab/ folder
  - *NOTE: If a password is required, please use `ohpc2template`*
  - *HINT: You can download the pre-packaged `.box` file to another location if you intend to build multiple machines from the packaged box*

You should then end up with:

```
.gitignore
client00.box
compute-node.box
input.local.lab
openhpc-demo-client00.ova
openhpc-demo-client01.ova
openhpc2-smshost-20240724.box
package.box
README.md
slurm.conf.lab
Vagrantfile
```

8. Add the pre-built Vagrant box to the Vagrant environment using:

From `...openhpc-2.x-virtual-lab/`:

```
vagrant box add openhpc/ohpc2 file://openhpc2-smshost-20240724.box
```

9. Once complete (`==> box: Successfully added box 'openhpc/ohpc2' (v0) for 'virtualbox'!`) start the **login** node (referred to as the *smshost*):

```
vagrant up smshost
```
* HINT: This should show a virtual machine in the VirtualBox GUI with the name `smshost_vcluster`*

10. Now start first compute node 0:

```
vagrant up compute00
```

Ignore `SSH private key issue`

11. Now start second compute node 1:

```
vagrant up compute01
```

In VirualBox you should see now:

![image](https://github.com/user-attachments/assets/4dbb6813-8f25-4cf9-ade4-0967b7442ae2)


12. Test nodes:

From `[vagrant@smshost vagrant]#`:

```
vagrant ssh smshost
```

From `[vagrant@smshost vagrant]#`:

```
sudo su
```

From `[root@smshost vagrant]#`:

```
sinfo
```

Output:

```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up 1-00:00:00      2  down* compute[00-01]
```

It will be likely that at this stage on first boot both compute nodes will be marked as down. This is to be expected from the virtual environment since the VMs have in effect been in a dormant state since their first original deployment many days/weeks/months ago. We need to restart the HPC services to resume normal HPC service.  

The following steps will remove an errant entry that reappears in the compute node DNS entries that will not be needed for this lab, and then restarts the Slurm workload manager.

*HINT: There is a script ***cluster_up.sh*** supplied in /vagrant/ that can be used for this process*

From `[root@smshost vagrant]#`:

`ssh` to first node as root and do:

```
ssh compute00
```

From `[root@compute00 ]#`:

```
sed -i 's/127.0.1.1 smshost smshost/#127.0.1.1 smshost smshost/' /etc/hosts
systemctl restart slurmd
exit
```

From `[root@smshost vagrant]#`:

`ssh` to second node as root and do:

```
ssh compute01
```

From `[root@compute01 ]#`:

```
sed -i 's/127.0.1.1 smshost smshost/#127.0.1.1 smshost smshost/' /etc/hosts
systemctl restart slurmd
exit
```

072 265 5731


13. You should be back at login node `[root@smshost vagrant]#`and make sure you get the following:

```
sudo sinfo
```

And get the following:

```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up 1-00:00:00      2   idle compute[00-01]
```

The `STATE` should show `idle`.

> If the `STATE` shows anything else (usually the alternative state is `down`), then the compute nodes must be brought back to service:

> `scontrol update nodename=compute0[0-1] state=resume`

14. Lastly fix a small bug in `/etc/hosts` on login node:

From `[root@smshost vagrant]# `:

```
sudo sed -i '3d' /etc/hosts
```

Now we can start using our cluster and submit jobs!




