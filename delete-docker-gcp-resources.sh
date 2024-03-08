#!/bin/bash

# 宣告變數
echo "初始化變數..."
INSTANCE_NAMES=("docker-lab")
REGION_DOCKER="us-west4"
ZONE_DOCKER="${REGION_DOCKER}-a"
VPC_NAME="gcp-docker-vpc"
SUBNET_NAME="gcp-docker-subnet"

# 刪除 VM Instance
echo "開始刪除虛擬機實例..."
for INSTANCE_NAME in "${INSTANCE_NAMES[@]}"; do
  echo "檢查虛擬機實例 $INSTANCE_NAME 是否存在..."
  if gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE_DOCKER" &>/dev/null; then
    echo "正在刪除虛擬機實例: $INSTANCE_NAME"
    gcloud compute instances delete "$INSTANCE_NAME" --zone="$ZONE_DOCKER" --quiet
    echo "虛擬機實例 $INSTANCE_NAME 已被刪除。"
  else
    echo "虛擬機實例 $INSTANCE_NAME 不存在於區域 $ZONE_DOCKER，跳過刪除。"
  fi
done

# 查找並刪除指定 VPC 的所有防火牆規則
echo "正在查找 VPC $VPC_NAME 的所有防火牆規則..."
FIREWALL_RULES=$(gcloud compute firewall-rules list --format="value(name)" --filter="network:$VPC_NAME")
if [ -z "$FIREWALL_RULES" ]; then
  echo "未找到 VPC $VPC_NAME 的防火牆規則，或已無剩餘規則。"
else
  for RULE in $FIREWALL_RULES; do
    echo "正在刪除防火牆規則: $RULE"
    gcloud compute firewall-rules delete "$RULE" --quiet
    echo "防火牆規則 $RULE 已被刪除。"
  done
fi

# 刪除 Subnet
echo "檢查子網路 $SUBNET_NAME 是否存在..."
if gcloud compute networks subnets describe "$SUBNET_NAME" --region="$REGION_DOCKER" &>/dev/null; then
  echo "正在刪除子網路: $SUBNET_NAME"
  gcloud compute networks subnets delete "$SUBNET_NAME" --region="$REGION_DOCKER" --quiet
  echo "子網路 $SUBNET_NAME 已被刪除。"
else
  echo "子網路 $SUBNET_NAME 不存在於區域 $REGION_DOCKER，跳過刪除。"
fi

# 刪除 VPC
echo "檢查 VPC $VPC_NAME 是否存在..."
if gcloud compute networks describe "$VPC_NAME" &>/dev/null; then
  echo "正在刪除 VPC: $VPC_NAME"
  gcloud compute networks delete "$VPC_NAME" --quiet
  echo "VPC $VPC_NAME 已被刪除。"
else
  echo "VPC $VPC_NAME 不存在，跳過刪除。"
fi

# 從 Cloud Shell 中刪除腳本
echo "檢查腳本 delete-docker-gcp-resources.sh 是否存在..."
if [ -f "delete-docker-gcp-resources.sh" ]; then
  rm "delete-docker-gcp-resources.sh"
  echo "腳本 delete-docker-gcp-resources.sh 已被刪除。"
else
  echo "腳本 delete-docker-gcp-resources.sh 不存在，無需刪除。"
fi

echo "資源刪除腳本執行完畢。"