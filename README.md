# openssl

这里提供的[Makefile.bat](./Makefile.bat)，用于使用VS2017命令行编译openssl

如需要使用其它VS编译其它版本，请修改如下参考：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\.\openssl-1.1.0g

## 编译openssl-1.1.x

编译前需要安装**ActivePerl**

编译前需要安装**dmake**
```
    set ACTIVEPERL_PPM_HOME=\Perl\tmp
    ppm install dmake
```

注意到`nmake clean`会删除`include\opensslconf.h`，故应在clean之前提取

### 编译x64版本

1. 使用Visual Studio Tool中的“VS2013 x64 本机工具命令提示”来打开控制台
```
    vcvarsall.bat amd64
```
2. 解压下载下来的openssl的压缩包，进入解压文件夹
```
    cd /d openssl-1.1.x
    perl Configure VC-WIN64A shared no-asm no-shared
```
4. 开始编译
```
    nmake
```
5. 如编译成功，测试
```
    nmake test
```
6. 结果在当前目录。`libcrypto.lib` & `libssl.lib`

7. 清除
```
    nmake clean
```
### 编译x86版本

1. 使用Visual Studio Tool中的“VS2013 x86 本机工具命令提示”来打开控制台
```
    vcvarsall.bat x86
```
2. 解压下载下来的openssl的压缩包，进入解压文件夹
```
    cd /d openssl-1.1.x
    perl Configure VC-WIN32 shared no-asm no-shared
```
4. 开始编译
```
    nmake
```
5. 如编译成功，测试
```
    nmake test
```
6. 结果在当前目录。`libcrypto.lib` & `libssl.lib`

7. 清除
```
    nmake clean
```
## 编译openssl-1.0.x

- 编译前需要安装**ActivePerl**

### 编译x64版本

1. 使用Visual Studio Tool中的“VS2013 x64 本机工具命令提示”来打开控制台
```
    vcvarsall.bat amd64
```
2. 解压下载下来的openssl的压缩包，进入解压文件夹
```
    cd /d openssl-1.0.x
    perl Configure VC-WIN64A
```
3. 继续配置
```
    ms\do_win64a
```
4. 开始编译(release版本和dll版本)
```
    nmake -f ms\nt.mak
    nmake -f ms\ntdll.mak
```
5. 如编译成功，测试
```
    nmake -f ms\nt.mak test
```
6. 结果目录
```
    cd /d openssl-1.0.x/inc32
    cd /d openssl-1.0.x/out32
```
7. 清除
```
    nmake -f ms\nt.mak clean
```
### 编译x86版本

1. 使用Visual Studio Tool中的“VS2013 x86 本机工具命令提示”来打开控制台
```
    vcvarsall.bat x86
```
2. 解压下载下来的openssl的压缩包，进入解压文件夹
```
    cd /d openssl-1.0.x
    perl Configure VC-WIN32 no-asm
```
3. 继续配置
```
    ms\do_ms
```
4. 开始编译(release版本和dll版本)
```
    nmake -f ms\nt.mak
    nmake -f ms\ntdll.mak
```
5. 如编译成功，测试
```
    nmake -f ms\nt.mak test
```
6. 结果目录
```
    cd /d openssl-1.0.x/inc32
    cd /d openssl-1.0.x/out32
```
7. 清除
```
    nmake -f ms\nt.mak clean
```