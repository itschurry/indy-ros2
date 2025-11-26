#!/bin/bash

REPO_NAME="ghcr.io/itschurry"
PROJECT_NAME="indy"

remote_url=$(git config --get remote.origin.url)
git_head=$(git rev-parse --abbrev-ref HEAD)

# 인자가 있으면 그 값을 TAG로 사용, 없으면 git head를 검사하여 TAG를 설정
if [ -n "$1" ]; then
    TAG="$1"
    echo "Using TAG from argument: $TAG"
else
    remote_url=$(git config --get remote.origin.url)
    git_head=$(git rev-parse --abbrev-ref HEAD)
    if [ "$git_head" == "main" ]; then
        TAG=$(git describe --tags --exact-match 2>/dev/null)
    elif [ "$git_head" == "HEAD" ]; then
        TAG=$(git describe --tags --exact-match 2>/dev/null)
    else
        TAG="develop"
    fi
fi

echo "Using TAG: $TAG"

IP_ADDR=localhost
HOSTNAME=$(hostname)
USER=$(id -un)
DISP=:9

LOCAL_INC='/usr/local/include'
LOCAL_LIB='/usr/local/lib'

ENVS="--env=QT_X11_NO_MITSHM=1
      --env=XAUTHORITY=$HOME/.Xauthority
      --env=DISPLAY=$DISP
      --env=LD_LIBRARY_PATH=$LOCAL_LIB:$LD_LIBRARY_PATH
      --env=TZ=Asia/Seoul
      --device=/dev/dri:/dev/dri"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority
VOLUMES="--volume=$XSOCK:$XSOCK:ro
          --volume=$XAUTH:$HOME/.Xauthority:ro
          --volume=/etc/localtime:/etc/localtime:ro
          --volume=/dev:/dev:rw
          --volume=$HOME/shared:/mnt/shared:rw"

    # --user $(id -u):$(id -g) \
    # --hostname $HOSTNAME \
docker run \
    -it \
    $ENVS \
    $VOLUMES \
    --volume=$PWD:/indy_ws:rw \
    -e HOME=$HOME \
    --workdir /indy_ws \
    --privileged \
    --ipc host \
    --net host \
    --gpus all \
    --name ${PROJECT_NAME}_${TAG} \
    $REPO_NAME/$PROJECT_NAME:$TAG
