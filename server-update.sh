#!/bin/bash
cd /home/ansible/fundemental/tech
git clone --branch SLI0631 git ://git.labs.lod.netapp.com/ansible_labs_fundementals fundementals
ansible-playbook /home/ansible/fundementals/playbooks.yml -e hostname-centos reponame=tech