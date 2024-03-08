#!/bin/bash

echo "[TASK 1] 設定時區為 Asia/Taipei"
timedatectl set-timezone Asia/Taipei
echo "時區設定完成。"

echo "[TASK 2] 卸載所有衝突套件"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  echo "正在卸載 $pkg ..."
  sudo apt-get remove -y $pkg
done
echo "所有衝突套件卸載完成。"

echo "[TASK 3] 卸載舊版本的 Docker"
apt-get -y purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
echo "舊版本的 Docker 卸載完成。"

echo "[TASK 4] 設定 Docker 的 apt 儲存庫"
# 加入 Docker 官方的 GPG 密鑰：
apt-get -y update
apt-get -y install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
# 加入儲存庫到 Apt 來源：
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
echo "Docker 的 apt 儲存庫設定完成。"

echo "[TASK 5] 安裝 Docker 套件"
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker 套件安裝完成。"

echo "[TASK 6] 安裝自動完成腳本"
apt-get update
apt-get install bash-completion -y
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh
echo "自動完成腳本安裝完成。"

echo "[TASK 7] 啟動並啟用 Docker"
sudo groupadd docker 2> /dev/null || true # 如果群組已存在則忽略錯誤
echo "正在將用戶 $1 加入 docker 群組..."
sudo usermod -aG docker "$1" # $1 是腳本接受的第一個參數，即用戶名
echo "$1 已成功加入 docker 群組。Docker 安裝和設定流程完成。"