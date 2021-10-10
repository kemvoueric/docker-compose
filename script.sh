#! /bin/bash
docker rm -f $(docker ps -aq)
rm -rf $PWD/volume/maven-proje*  || true
docker-compose down --remove-orphans
docker-compose -f docker-compose1.yml down --remove-orphans
docker-compose up -d 
sleep 10

docker-compose ps 
A=$(docker-compose ps | grep -i maven | awk '{print $5}')
if 
[[  ${A} -eq 0 ]]
then 
 sleep 5
  docker-compose -f docker-compose1.yml up -d
  echo " please visit the browser on port 86/webapp"
else 
   echo 'please check the status of maven'
 exit 1
 fi 
 
docker-compose ps 
echo
echo

docker-compose -f docker-compose1.yml ps
