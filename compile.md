# 编译步骤

```sh
source ./prepare.zsh
```

然后按照正常的编译流程执行

# 编译遇到的问题

> 整个编译过程及其缓慢，预计需要半天时间（不出错的话），硬盘空间至少 15G。

## 文件系统大小写不敏感

错误信息：

```
Build dependency: OpenWrt can only be built on a case-sensitive filesystem
```

解决方案：用 hdiutil 创建一个大小写敏感的分区挂载，然后再进行编译

例子：

```sh
hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/openwrt_build

hdiutil attach ~/openwrt_build.sparseimage -mountpoint ~/openwrt_mount

cd ~/openwrt_mount
```

结束之后，可卸载创建的分区

```sh
cd ~  # Change to a directory outside the mounted image
hdiutil detach ~/openwrt_mount

rm ~/openwrt_build.sparseimage
```

## JSONC 库编译错误

错误信息：

```
a53_musl/host/include -ffunction-sections -fdata-sections -Werror -Wall -Wcast-qual -Wno-error=deprecated-declarations -Wextra -Wwrite-strings -Wno-unused-parameter -Wstrict-prototypes -DNDEBUG -O2 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk -fPIC -D_REENTRANT -MD -MT CMakeFiles/json-c.dir/json_util.c.o -MF CMakeFiles/json-c.dir/json_util.c.o.d -o CMakeFiles/json-c.dir/json_util.c.o -c /Users/xligem/Documents/Code/lede_compile/lede/build_dir/hostpkg/json-c-0.16/json_util.c
/Users/xligem/Documents/Code/lede_compile/lede/build_dir/hostpkg/json-c-0.16/json_util.c:63:35: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
const char *json_util_get_last_err()
                                  ^
                                   void
1 error generated.
ninja: build stopped: subcommand failed.
```

解决方案：

貌似是因为编译标志有：`-Wstrict-prototypes`，因此可以直接注释掉对应的编译代码。

例如：找到 `build_dir/hostpkg/json-c-0.16/CMakeLists.txt` 中类似如下代码的地方：

```sh
# 注释掉对应的逻辑
# set(CMAKE_C_FLAGS           "${CMAKE_C_FLAGS} -Wstrict-prototypes")
```

## PATH 环境变量污染问题

错误信息：

```
find: The relative path 'Fusion.app/Contents/Public' is included in the PATH environment variable, which is insecure in combination with the -execdir action of find.  Please remove that entry from $PATH
make[2]: *** [package/Makefile:73: package/install] Error 1
```

或者

```
find: The relative path '~/.dotnet/tools' is included in the PATH environment variable, which is insecure in combination with the -execdir action of find.  Please remove that entry from $PATH
make[2]: *** [package/Makefile:73: package/install] Error 1
```

解决方案：

在执行编译命令之前，去掉 PATH 中对应的路径。

例如：

```sh
export PATH=$(echo $PATH | tr ':' '\n' | grep -v 'Fusion.app/Contents/Public' | tr '\n' ':')
# and
export PATH=$(echo $PATH | tr ':' '\n' | grep -v '~/.dotnet/tools' | tr '\n' ':')
```

## 修改管理地址

可修改默认文件 `package/lean/default-settings/files/zzz-default-settings`，添加如下代码

```sh
# 修改管理地址
uci set network.lan.ipaddr="192.168.2.1"
# 提交修改
uci commit network
```

然后编译即可
