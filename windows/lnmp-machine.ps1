#
# Start Docker Machine
#

$HYPERV_BOOT2DOCKER_URL="https://ci2.khs1994.com:10000/boot2docker.iso"

docker-machine -D create `
    -d hyperv `
    --engine-registry-mirror https://dockerhub.azk8s.cn `
    --hyperv-memory "2048" `
    --hyperv-cpu-count "2" `
    --hyperv-virtual-switch zy `
    --hyperv-boot2docker-url=${HYPERV_BOOT2DOCKER_URL} `
    $args[0]
