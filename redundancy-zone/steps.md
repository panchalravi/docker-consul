docker network create --driver bridge --subnet 10.0.0.0/24 consul-net

docker run --name consul-server-1 --net consul-net --ip 10.0.0.10 -p8500:8500 -v ./config:/config -e SERVER_NUMBER=1 -e BOOTSTRAP_EXPECT=5 -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server.sh
docker run --name consul-server-2 --net consul-net --ip 10.0.0.11 -v ./config:/config -e SERVER_NUMBER=2 -e BOOTSTRAP_EXPECT=5 -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server.sh 
docker run --name consul-server-3 --net consul-net --ip 10.0.0.12 -v ./config:/config -e SERVER_NUMBER=3 -e BOOTSTRAP_EXPECT=5 -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server.sh
docker run --name consul-server-4 --net consul-net --ip 10.0.0.13 -v ./config:/config -e SERVER_NUMBER=4 -e BOOTSTRAP_EXPECT=5 -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server.sh
docker run --name consul-server-5 --net consul-net --ip 10.0.0.14 -v ./config:/config -e SERVER_NUMBER=5 -e BOOTSTRAP_EXPECT=5 -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server.sh

docker exec -it consul-server-2 consul join consul-server-1
docker exec -it consul-server-3 consul join consul-server-1
docker exec -it consul-server-4 consul join consul-server-1
docker exec -it consul-server-5 consul join consul-server-1

docker stop consul-server-4 consul-server-3

docker run --name consul-server-6 --net consul-net --ip 10.0.0.15 -v ./config:/config -e SERVER_NUMBER=6  -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server-wo-bootstrap.sh
docker run --name consul-server-7 --net consul-net --ip 10.0.0.16 -v ./config:/config -e SERVER_NUMBER=7  -d --entrypoint /bin/sh  hashicorp/consul-enterprise:latest -c /config/setup-consul-server-wo-bootstrap.sh

docker stop consul-server-7
docker stop consul-server-6

docker ps -a -q | xargs -I{} docker rm -f {}

<!-- docker exec -it consul-server-6 consul join consul-server-1
docker exec -it consul-server-7 consul join consul-server-1 -->

