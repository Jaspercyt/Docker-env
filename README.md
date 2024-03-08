Docker 測試環境安裝
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
* 在右上角工具列找到 Cloud Shell 的 icon，點擊後會在底部開啟 Cloud Shell session。
![image](https://github.com/Jaspercyt/Docker-env/assets/88648972/6d637a07-48be-41a2-90af-d2ff322cb64f)

##### Step 02：下載並執行 GCP 環境建置及 Docker 安裝腳本
在 Cloud Shell 中執行以下指令
```bash
wget https://raw.githubusercontent.com/Jaspercyt/Docker-env/main/gce-setup.sh && bash gce-setup.sh
```
![image](https://github.com/Jaspercyt/Docker-env/assets/88648972/6c46a829-c47f-470a-8364-552a0a671937)
執行過程中可能會出現錯誤訊息 ERROR: (gcloud.compute.start-iap-tunnel) Error while connecting [4047: 'Failed to lookup instance'] 
這是正常的，因為在 VM 尚未完全啟動或在 DNS 中尚未更新，過幾分後系統更新好就沒問題了，不需要人為介入處理。
![image](https://github.com/Jaspercyt/Docker-env/assets/88648972/f6d82294-7a90-4083-be43-11f05829d000)
名稱為 docker-lab 的虛擬機建立好了
![image](https://github.com/Jaspercyt/Docker-env/assets/88648972/3981d811-36f2-4922-9c68-c8c1ed757c5d)
點選 docker-lab 的 SSH，就可以進入開始使用 Docker 了
![image](https://github.com/Jaspercyt/Docker-env/assets/88648972/8b30672c-39bf-43aa-916f-71d66ca9a1f0)
![image](https://github.com/Jaspercyt/Docker-env/assets/88648972/e15655e5-4a7c-4a62-ab43-2ba855467337)



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
