# openssl

这里提供的[Makefile.bat](./Makefile.bat)，使用VS2017命令行编译项目

如需要使用其它VS编译其它版本，请修改如下配置：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\xxx-x.x.x

---- ---- ---- ----

## 编译openssl-1.1.x

- 编译前需要安装**ActivePerl**
- 编译前需要安装**dmake**
```
set ACTIVEPERL_PPM_HOME=\Perl\tmp
ppm install dmake
```

1. 打开VC命令行(x64/x86)
2. 进入openssl目录
3. 配置(x64/x86)：
    1. x64配置：`perl Configure VC-WIN64A shared no-asm no-shared`
    2. x86配置：`perl Configure VC-WIN32 shared no-asm no-shared`
4. 开始编译：
    1. 全部编译：`nmake`
    2. 只编译LIB：`nmake build_libs`
5. 如编译成功，测试：`nmake test`
6. 结果在当前目录。`libcrypto.lib` & `libssl.lib`
7. 清除：`nmake clean`

- 注意到`nmake clean`会删除`include\opensslconf.h`，故应在clean之前提取

---- ---- ---- ----

## 编译openssl-1.0.x

- 编译前需要安装**ActivePerl**

1. 打开VC命令行(x64/x86)
2. 进入openssl目录
3. 配置(x64/x86)：
    1. x64配置：`perl Configure VC-WIN64A shared no-asm no-shared`
    2. x86配置：`perl Configure VC-WIN32 shared no-asm no-shared`
4. 继续配置：
    1. x64配置：`ms\do_win64a`
    2. x86配置：`ms\do_ms`
5. 开始编译：
    1. 编译LIB：`nmake -f ms\nt.mak`
    2. 编译DLL：`nmake -f ms\ntdll.mak`
6. 如编译成功，测试：`nmake -f ms\nt.mak test`
6. 结果目录：`openssl-1.0.x/inc32` & `openssl-1.0.x/out32`
7. 清除：`nmake -f ms\nt.mak clean`