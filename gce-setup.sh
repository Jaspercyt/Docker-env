#!/bin/bash

echo "正在初始化變數..."
NETWORK_DOCKER="gcp-docker-vpc"                # VPC 網路名稱
SUBNET_DOCKER="gcp-docker-subnet"              # Subnet 名稱
REGION_DOCKER="us-west4"                       # 指定 Region
ZONE_DOCKER="${REGION_DOCKER}-a"               # 指定 Zone
SUBNET_RANGE_DOCKER="10.0.0.0/24"              # Subnet IP Range
MACHINE_TYPE_DOCKER="e2-small"                 # 虛擬機型號
IMAGE_FAMILY_DOCKER="ubuntu-2204-lts"          # 使用 Ubuntu 映像檔
IMAGE_PROJECT_DOCKER="ubuntu-os-cloud"         # 映像檔所在的專案
BOOT_DISK_SIZE_DOCKER="10GB"                   # 開機磁碟大小
BOOT_DISK_TYPE_DOCKER="pd-standard"            # 開機磁碟類型
INSTANCE_NAME="docker-lab"                     # VM 名稱
INSTANCE_IP="10.0.0.10"                        # VM 的私有 IP 地址

echo "建立自定義的 VPC 網路 $NETWORK_DOCKER..."
gcloud compute networks create $NETWORK_DOCKER --subnet-mode=custom

echo "在 VPC 網路 $NETWORK_DOCKER 內建立 Subnet $SUBNET_DOCKER，並指定範圍為 $SUBNET_RANGE_DOCKER..."
gcloud compute networks subnets create $SUBNET_DOCKER --network=$NETWORK_DOCKER --region=$REGION_DOCKER --range=$SUBNET_RANGE_DOCKER

echo "定義防火牆規則，允許 ICMP、SSH、HTTP、HTTPS 連線以及內部網路溝通..."
FIREWALL_RULES=(
  "gcp-docker-vpc-allow-icmp icmp INGRESS 65534 0.0.0.0/0"
  "gcp-docker-vpc-allow-ssh tcp:22 INGRESS 65534 0.0.0.0/0"
  "allow-http tcp:80 INGRESS 1000"
  "allow-https tcp:443 INGRESS 1001"
  "allow-lb-health-check tcp:8080 INGRESS 1002"
  "gcp-docker-vpc-allow-internal icmp,tcp,udp INGRESS 1003"
)

echo "開始建立防火牆規則..."
for rule in "${FIREWALL_RULES[@]}"; do
  read -r name allow direction priority source_ranges destination_ranges <<<"$rule"
  echo "建立防火牆規則：$name"
  gcloud compute firewall-rules create $name \
      --network=$NETWORK_DOCKER \
      --allow=$allow \
      --direction=$direction \
      --priority=$priority \
      --source-ranges=${source_ranges:-0.0.0.0/0} \
      ${destination_ranges:+--destination-ranges=$destination_ranges}
done

echo "正在建立 VM $INSTANCE_NAME..."
gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE_DOCKER \
    --machine-type=$MACHINE_TYPE_DOCKER \
    --network=$NETWORK_DOCKER \
    --subnet=$SUBNET_DOCKER \
    --network-tier=STANDARD \
    --maintenance-policy=TERMINATE \
    --preemptible \
    --no-restart-on-failure \
    --scopes=default \
    --tags=http-server,https-server \
    --image-family=$IMAGE_FAMILY_DOCKER \
    --image-project=$IMAGE_PROJECT_DOCKER \
    --boot-disk-size=$BOOT_DISK_SIZE_DOCKER \
    --boot-disk-type=$BOOT_DISK_TYPE_DOCKER \
    --boot-disk-device-name=$INSTANCE_NAME \
    --private-network-ip=$INSTANCE_IP

echo "VM $INSTANCE_NAME 建立完成。"

echo "從 Cloud Shell 中刪除腳本 gce-setup.sh..."
rm "gce-setup.sh"
echo "gce-setup.sh 腳本執行完畢。"

echo "開始安裝 Docker..."
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE_DOCKER --command="wget https://raw.githubusercontent.com/Jaspercyt/Docker-env/main/docker-install.sh && bash docker-install.sh '$USER'"