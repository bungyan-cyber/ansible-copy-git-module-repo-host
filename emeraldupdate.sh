#!/bin/bash

if [ $# -ne 2 ]; then
    # TODO: print usage
        echo "Usage : sudo ./emeraldcreateport.sh RepoName PortNumber"
    exit 1
fi

if [[ $2 == ?(-)+([0-9]) ]]; then

echo ""
echo "Please go through the below Ports used and Projects already configured"
echo "**************************************************************"
cat /home/ubuntu/emeraldup/portrepo
echo ""
echo "**************************************************************"

echo ""
echo  "Please verify you create container for  $1 running at port  $2 "
echo ""
read -p "yes/no: " var
if [ $var == 'no' ]
then 
exit 1
fi
grep -q "$1" /home/ubuntu/emeraldup/portrepo
if [[ $? = 0 ]]; then
echo "Conatiner already exists for repo, Please go through the above list"
exit 1 
fi
if grep -Fxq $2 /home/ubuntu/emeraldup/portused
then 
echo "port already in use, please run the script using another port"
exit 1
else 
su -c "ansible-playbook /home/ubuntu/emeraldup/repoadd.yml -e 'hostname=equipemeraldup username=$1 portnumber=$2'" ubuntu
aws ec2 authorize-security-group-ingress --group-name stagingsg  --protocol tcp --port $2 --cidr 0.0.0.0/0
sed -i -e '/addcontenthere/r /home/ubuntu/emeraldup/scriptadd' /home/ubuntu/emeraldupdate.sh
sed -i "s/portnumber/$2/g" /home/ubuntu/emeraldupdate.sh
sed -i "s/Username/$1/g" /home/ubuntu/emeraldupdate.sh
sed -i "s/reponame/$1/g" /home/ubuntu/emeraldupdate.sh
echo "$2" >> /home/ubuntu/emeraldup/portused
echo "$2 - $1" >> /home/ubuntu/emeraldup/portrepo
fi
else 
echo "Second argument port must be a number"
fi

