MASTER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster_master)
SLAVE_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker-compose ps | grep redis-cluster_slave | awk '{print$1}'))
SENTINEL_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker-compose ps | grep redis-cluster_sentinel_1 | awk '{pritn$1}'))

echo Redis master: $MASTER_IP
echo Redis Slave: $SLAVE_IP
echo ------------------------------------------------
echo Initial status of sentinel
echo ------------------------------------------------
docker exec redis-cluster_sentinel_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster_sentinel_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
echo ------------------------------------------------

echo Stop redis master
docker pause redis-cluster_master_1
echo Wait for 15 seconds
sleep 15
echo Current infomation of sentinel
docker exec redis-cluster_sentinel_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster_sentinel_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster


echo ------------------------------------------------
echo Restart Redis master
docker unpause redis-cluster_master_1
sleep 5
echo Current infomation of sentinel
docker exec redis-cluster_sentinel_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster_sentinel_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
