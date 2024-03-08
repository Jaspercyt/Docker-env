Kubernetes 測試環境安裝
===
###### tags:`Google Cloud` `Google Compute Engine` `Docker`

## 摘要
這個 Repository 的目的是快速在 GCP 建置一台已經安裝好 Docker 的 GCE 虛擬機。
   
## 軟體與版本
| 項次 |         軟體         |  版本  |
|:----:|:--------------------:|:------:|
|  1   |        Docker        | latest |
|  2   |        Ubuntu        | 22.04  |

## 安裝腳本說明
| 項次 |            腳本名稱            | 摘述                                                      |
|:----:|:------------------------------:| --------------------------------------------------------- |
|  1   |          gce-setup.sh          | 設定 GCP 網路環境，包括：VPC、Subnet、Firewall rule 及 VM |
|  2   |       docker-install.sh        | 在虛擬機內安裝 Docker                                     |
|  3   | delete-docker-gcp-resources.sh | 清理環境，刪除 GCP 資源                                   |

```CSS =
├── gce-setup.sh
│   └── docker-install.sh
│       └── [在虛擬機內安裝 Docker]
│
└── delete-docker-gcp-resources.sh
    └── [清理環境，刪除 GCP 資源]
```

## 4. 使用 Cloud Shell 部署 Kubernetes 叢集
### Step 01：開啟 Cloud Shell
* 登入 [GCP console](https://console.cloud.google.com/)。
* 在右上角工具列找到 Cloud Shell 的 icon ![image](https://github.com/Jaspercyt/Kubernetes-1.29.0/assets/88648972/39d3447e-a2d1-468d-8abf-77557d550682)，點擊後會在底部開啟 Cloud Shell session。
* 在底部 Cloud Shell session 的工具列點擊 ![image](https://github.com/Jaspercyt/Kubernetes-1.29.0/assets/88648972/fccf6836-2e3a-4a70-a4a9-746b1c0255bb) 可以用新分頁的方式打開 Cloud Shell。或是直接在螢幕的下方使用 Cloud Shell


##### Step 02：下載並執行部署腳本
在 Cloud Shell 中執行以下指令
```bash
wget https://raw.githubusercontent.com/Jaspercyt/Docker-env/main/gce-setup.sh && bash gce-setup.sh
```


##### Step 04：停止 VM Instance
在 Cloud Shell 中執行以下指令
```bash
gcloud compute instances stop master worker01 worker02 --zone=us-west4-a
```
![image](https://github.com/Jaspercyt/Kubernetes-1.29.0/assets/88648972/e2ea55b0-2493-4250-929d-1a8f88753747)

##### Step 05：重啟 VM Instance
在 Cloud Shell 中執行以下指令
```bash
gcloud compute instances start master worker01 worker02 --zone=us-west4-a
```
![image](https://github.com/Jaspercyt/Kubernetes-1.29.0/assets/88648972/1a3f8cb1-adc5-4ff6-8791-d659c319409d)

##### Step 06：清理環境，刪除 GCP 資源
在 Cloud Shell 中執行以下指令
```bash
wget https://raw.githubusercontent.com/Jaspercyt/Kubernetes-1.29.0/main/GCP-env/delete-k8s-gcp-resources.sh && bash delete-k8s-gcp-resources.sh
```
