#!/bin/bash
if [ $# -ne 2 ]; then
    # TODO: print usage
	echo "Usage : sudo ./serverupdate RepoName Hostname"
    exit 1
fi
if [[ "$2" =~ ^(pbeta5|pbeta6|pbeta7|pbeta8|pbeta9|pbeta10|pbeta11)$ ]]; then 
  ansible-playbook  --ask-pass --ask-become-pass gitpull-update.yml -e "hostname=$2 ftpuser=$2"
  exit 0
fi

if [ $2 == 'develbetastage' ]; then
  ansible-playbook  --ask-pass --ask-become-pass gitpull-update.yml -e "hostname=$2 ftpuser=adminftp"
  exit 0
fi

if [[ $1 == 'mci-erp' && $2 == 'equiponyx' ]]; then
  su -c "ansible-playbook /home/ubuntu/mcipull.yml -e 'hostname=$2'" ubuntu
  exit 0
fi

if [ $2 == 'hakcipta' ]; then
  su -c "ansible-playbook /home/ubuntu/gitpull.yml -e 'hostname=$2'" ubuntu
  exit 0
fi
cd /home/ubuntu/gitrepos
if [ ! -d "$1" ] ; then
    su -c "git clone git@github.com:HashMicro/$1" ubuntu
    if [ $? == 0 ] ; then   
    	cd $1 
    	ls -d * >> /home/ubuntu/modulelist.txt
    	su -c "ansible-playbook /home/ubuntu/ansible-update.yml -e 'hostname=$2 reponame=$1 filename=modulelist.txt'" ubuntu 
    	su -c "rm -rf /home/ubuntu/modulelist.txt" ubuntu
        su -c "rm -rf /home/ubuntu/gitrepos/$1" ubuntu
    else
        echo "-----------------------------"
        echo "please enter correct reponame"
        exit 1
    fi
else
 #   su -c "git -C /home/ubuntu/gitrepos/$1 remote update" ubuntu
 #   git -C /home/ubuntu/gitrepos/$1 diff --stat --diff-filter=ACM master origin/master
 #   GitResult=$(su -c "git -C /home/ubuntu/gitrepos/$1 diff --stat --diff-filter=ACM master origin/master" ubuntu | sed '/\.\.\./d' |grep -v "files changed" | grep -v "file changed" | awk -F"/" '{print $1}'  | sort | uniq)
 #   su -c "git -C /home/ubuntu/gitrepos/$1 pull" ubuntu
 #  if [ -z "$GitResult" ]
#	then
 #      echo "nothing to update" 
  #      exit 0;
  # else
   #name=modules
   #echo $name
   #if [[ -e /home/ubuntu/"$name".txt ]] ; then
   #     i=0
    #    while [[ -e /home/ubuntu/$name-$i.txt ]] ; do
     #   let i++ 
    #done
    #name=$name-$i
    #fi  
    #echo $GitResult | tr " " "\n" >> /home/ubuntu/"$name".txt

    #su -c "ansible-playbook /home/ubuntu/ansible-update.yml -e 'hostname=$2 reponame=$1 filename=$name.txt'" ubuntu
   #fi  
   echo "nothing to do"
fi
