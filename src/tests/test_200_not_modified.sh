#/bin/bash
PROJECT=123
APIKEY=klsdkl
IMAGENAME=orig.png
IMAGE=200-not-modified.png
/usr/bin/curl -T ${IMAGE} http://localhost:4567/test/${PROJECT}/${IMAGENAME}/${APIKEY} 
echo -e "\n";