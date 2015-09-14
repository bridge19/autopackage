1.	脚本所在目录
host:/home/scripts/resourcespack
svn目录：tap/sources/shell
2. 脚本列表
脚本										|功能
firstrun.sh  								|资源包第一次打包执行
frontendpackagewithfirstrun.sh				|第一次打包执行，调用firstrun.sh
frontendpackage.sh							|打包脚本，将依次调用getcode.sh,prebuild.sh,package.sh
getcode.sh									|取得上次打包版本的文件和最新版本文件
prebuild.sh									|对比上次打包版本文件和最新版本文件，把不同文件拷贝到build目录下
package.sh									|打包
notification.sh								|打印发布信息
util.sh										|公共方法包
2.	配置文件
配置文件与脚本处于同一目录，文件名config_${模块名}_${环境}_${客户端版本}.properties.
这样可以区分不同模块不同环境不同版本的信息。
主要内容：
wwwURL: www目录所在svn的位置
deployURL: 跟环境相关配置文件在svn的位置
envstr: 需要打包的环境，有dit, uat,preprod,prod共4个环境
model: 模块的名称，
p_ver: 应用客户端的版本号，如v1.0,v2.0.
manageURL: 中台管理系统的访问地址
staticURL: 资源包下载的访问路径的前缀
例子：
wwwURL=https://host/svn/tap/trunk/sources/tap-android/assets/www
deployURL=https://host/svn/tap/trunk/deploy
envstr=dit
model=tap
p_ver=v1.0
basecodeversion=143
manageURL=url
staticURL=url
3.	打包文件体系
构建目录生成一下子文件夹：
build:构建结果目录，结果将保存在目录output中
config：配置文件目录，中间结果，记录上一次构建版本及代码版本号
logs：构建log
refer:存放上个资源包的原始文件
src：存放当前资源包的原文件
tmp：每个svn代码版本的信息

