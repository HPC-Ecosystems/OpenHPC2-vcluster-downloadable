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

For an in-depth hands-on guide for deploying the **OpenHPC2.x virtual lab** yourself from scratch, please refer to the official guide:  

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

5. `cd openhpc-2.x-virtual-lab`
6. Delete the existing Vagrant file with `rm Vagrantfile`
7. Download the [pre-packaged Vagrant box and Vagrantfile](https://csircoza-my.sharepoint.com/:f:/g/personal/bjohnston_csir_co_za/Elv5PJ6ScCBLmlclV_B7vb4BEdLjkuW-GdPW7iIwfEm_kQ) to the `vcluster` folder
  - `package.box`  
  - `packaged-openhpc2-smshost.box`  
  - `Vagrantfile`
  - *NOTE: If a password is required, please use `ohpc2template`*
  - *HINT: You can download the pre-packaged `.box` file to another location if you intend to build multiple machines from the packaged box*

8. Add the pre-built Vagrant box to the Vagrant environment using a syntax similar to `vagrant box add my-box file:///c:/path/to/my-box.box` or as a relative path such as `file://my-box.box.`

```
/vcluster/ vagrant box add openhpc/ohpc2 file://packaged-openhpc2-smshost.box
```

9. Once complete (`==> box: Successfully added box 'openhpc/ohpc2' (v0) for 'virtualbox'!`) start the **login** node (referred to as the *smshost*):

```
/vcluster/ vagrant up smshost
```

10. Now start first compute node 0:

```
/vcluster/ vagrant up compute00
```

Ignore `SSH private key issue`

11. Now start second compute node 1:

```
/vcluster/ vagrant up compute01
```

12. Test nodes:

```
/vcluster/ vagrant ssh smshost
[vagrant@smshost2 vagrant]# sudo su
[root@smshost2 vagrant]# sudo sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up 1-00:00:00      2  down* compute[00-01]
```

Both nodes are down so `ssh` to both nodes as root and do:

```
[root@smshost2 vagrant]# ssh compute00
[root@compute00 ]# systemctl restart slurmd
```

```
[root@smshost2 vagrant]# ssh compute01
[root@compute01 ]# systemctl restart slurmd
```

13. Go back to login node (Ctrl + d) and make sure you get the following:

```
[root@smshost2 vagrant]# sudo sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up 1-00:00:00      2   idle compute[00-01]
```

The `STATE` should show `idle`.

14. Lastly fix a small bug in `/etc/hosts` on each vm:

```
[root@smshost2 vagrant]# sudo sed -i '3d' /etc/hosts
```

```
[root@compute00 ]# sudo sed -i '3d' /etc/hosts
```

```
[root@compute01]# sudo sed -i '3d' /etc/hosts
```

Now we can start using our cluster and submit jobs!


## To Do:
1. Add links
2. Add screenshots/code of expected outputs
3. Show setup with Windows Terminal


