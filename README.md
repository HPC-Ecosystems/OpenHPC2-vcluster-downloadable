# Setup Virtual Cluster

For an in-depth install and explanation follow:

https://hpc-ecosystems.gitlab.io/training/openhpc-2.x-guide/2_virtual_lab_setup/

# Quick Install

## Software Install:
1. Install VirtualBox
2. Install Vagrant
3. Install Gitbash (if using windows)

## Setup 

What you will be building:

![image](https://github.com/ChpcTraining/hpc_carpentry/assets/157092105/1c46431b-7fac-41a4-9206-283641a45bce)

### Steps

1 Open gitbash and go to your desired projects/documents folder

2. Create a directory called `mkdir vcluster` to store your virtual cluster files
3. ```cd vcluster```
4. Clone the repo
```
git clone https://gitlab.com/hpc-ecosystems/training/openhpc-2.x-virtual-lab.git 
cd openhpc-2.x-virtual-lab
```
5. `cd openhpc-2.x-virtual-lab`
6. Delete the existing Vagrant file with `rm Vargrantfile`
7. Download Vagrant files [link] and add them to the `/vcluster` folder
- `package.box`
- `packaged-openhpc2-smshost.box`
- `Vagrantfile`

8. Add the pre-built Vagrant box to the Vagrant environment

```
/vcluster/ vagrant box add openhpc/ohpc2 file:/packaged-openhpc2-smshost.box
```

9. Once complete start the login node:

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


