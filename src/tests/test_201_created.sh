#/bin/bash
PROJECT=123
APIKEY=klsdkl
IMAGENAME=orig2.png
IMAGE=409-conflict.png
/usr/bin/curl -T ${IMAGE} http://localhost:4567/test/${PROJECT}/${IMAGENAME}/${APIKEY} 
echo -e "\n";