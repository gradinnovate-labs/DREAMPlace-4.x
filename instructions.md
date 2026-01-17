# Project directory and Container
目前專案目錄是 mount 成 container 的 /DREAMPlace
check file:
`start_container.sh`

# compile under container
1. 使用以下找出 container instance (image=localhost/dreamplace2:cuda)

```bash
podman container ls
```

2. 以下指令執行 cmake
```bash
podman exec {container} bash -c "cd /DREAMPlace/build && cmake .. -DCMAKE_INSTALL_PREFIX=/DREAMPlace/dreamplace.bin -DPython_EXECUTABLE=$(which python) 2>&1|tee cmake.log
```

3. 以下指令執行 make
```bash
podman exec {container} bash -c "cd /DREAMPlace/build && make -j24 2>&1|tee make.log
```

4. 讀取 cmake.log
可以直接用 read tool 讀取 `build/cmake.log`

5. 讀取 make.log
可以直接用 read tool 讀取 `build/make.log`

6. 以下指令執行 placer
```bash
podman exec {container} bash -c "cd /DREAMPlace/dreamplace.bin && python3 dreamplace/Placer.py test/ispd2005/adaptec1.json 2>&1|tee placer.log"
```
