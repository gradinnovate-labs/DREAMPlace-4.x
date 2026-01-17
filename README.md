# DREAMPlace 建置說明 (NVIDIA CUDA sm_120 支援)

本文件說明如何建置支援 NVIDIA CUDA sm_120 架構的 DREAMPlace。

> **注意**：本版本為 DREAMPlace 的修改版本，針對 NVIDIA CUDA sm_120 架構進行調整。如需查看原始 README，請參考 [README-orig.md](README-orig.md)。

## 專案特點

此版本的 DREAMPlace 針對 NVIDIA CUDA sm_120 架構進行修改，在執行 CMake 時需要額外設定 `-DCMAKE_CXX_ABI=1`。

## 1. 克隆專案

使用 `git clone --recursive` 命令克隆專案，同時下載所有子模組：

```bash
git clone --recursive <repository-url>
cd DREAMPlace-4.x
```

**注意**：`--recursive` 參數非常重要，它會同時克隆所有依賴的子模組（Limbo、Flute、OpenTimer、CUB 等）。如果忘記使用此參數，可以在克隆完成後執行：

```bash
git submodule init
git submodule update
```

## 2. 建置容器

本專案提供腳本來簡化容器建置流程。

### 建置容器映像檔

使用 `build_container.sh` 建置容器：

```bash
./build_container.sh
```

此腳本會：
- 使用專案根目錄的 `Dockerfile` 建置映像檔
- 將映像檔標記為 `dreamplace2:cuda`

**選項**：若要重新建置容器（刪除舊映像檔），可以使用：

```bash
./build_container.sh --remove
```

此選項會：
- 刪除所有使用 `dreamplace2:cuda` 映像檔的容器
- 刪除 `dreamplace2:cuda` 映像檔
- 重新建置映像檔

### 啟動容器

使用 `start_container.sh` 啟動容器：

```bash
./start_container.sh
```

此腳本會：
- 啟動 `dreamplace2:cuda` 容器
- 將當前目錄掛載到容器的 `/DREAMPlace`
- 啟用 GPU 支援（`--gpus 1`）
- 開放端口 9090（`-p 9090:9090`）
- 進入容器的 bash 環境

**容器環境設定**：
- 專案目錄掛載為 `/DREAMPlace`
- 使用 GPU 加速
- 已預裝 CUDA 12.8.0

## 3. 在容器中建置

進入容器後，依照以下步驟執行建置：


### 執行 CMake

**關鍵設定**：必須加入 `-DCMAKE_CXX_ABI=1` 參數。

```bash
cd /DREAMPlace/build && cmake .. -DCMAKE_INSTALL_PREFIX=/DREAMPlace/dreamplace.bin -DPython_EXECUTABLE=\$(which python) -DCMAKE_CXX_ABI=1 2>&1 | tee cmake.log
```

**參數說明**：
- `-DCMAKE_INSTALL_PREFIX=/DREAMPlace/dreamplace.bin`：安裝目錄
- `-DPython_EXECUTABLE=\$(which python)`：Python 執行檔路徑
- `-DCMAKE_CXX_ABI=1`：**關鍵參數**，設定 C++ ABI 版本為 1（符合這個版本的 pytorch  編譯要求）
- `2>&1 | tee cmake.log`：將輸出同時顯示在終端機並寫入 `cmake.log`


### 執行 Make

```bash
cd /DREAMPlace/build && make -j24 2>&1 | tee make.log
```

**參數說明**：
- `-j24`：使用 24 個並行執行緒進行編譯（可根據系統資源調整）
- `2>&1 | tee make.log`：將輸出同時顯示在終端機並寫入 `make.log`

### 執行 Install

```bash
cd /DREAMPlace/build && make install 2>&1 | tee install.log
```

### 檢視編譯日誌

編譯過程的日誌會儲存在以下位置，可以直接查看：

- **CMake 日誌**：`build/cmake.log`
- **Make 日誌**：`build/make.log`
- **Install 日誌**：`build/install.log`

## 4. 測試安裝

建置完成後，可以執行測試以驗證安裝：

```bash
cd /DREAMPlace/dreamplace.bin && python3 dreamplace/Placer.py test/ispd2005/adaptec1.json 2>&1 | tee placer.log
```

此命令會：
- 使用 `adaptec1` 測試案例
- 執行完整的放置流程
- 將輸出寫入 `placer.log`

