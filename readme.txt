1.	�ű�����Ŀ¼
host:/home/scripts/resourcespack
svnĿ¼��tap/sources/shell
2. �ű��б�
�ű�										|����
firstrun.sh  								|��Դ����һ�δ��ִ��
frontendpackagewithfirstrun.sh				|��һ�δ��ִ�У�����firstrun.sh
frontendpackage.sh							|����ű��������ε���getcode.sh,prebuild.sh,package.sh
getcode.sh									|ȡ���ϴδ���汾���ļ������°汾�ļ�
prebuild.sh									|�Ա��ϴδ���汾�ļ������°汾�ļ����Ѳ�ͬ�ļ�������buildĿ¼��
package.sh									|���
notification.sh								|��ӡ������Ϣ
util.sh										|����������
2.	�����ļ�
�����ļ���ű�����ͬһĿ¼���ļ���config_${ģ����}_${����}_${�ͻ��˰汾}.properties.
�����������ֲ�ͬģ�鲻ͬ������ͬ�汾����Ϣ��
��Ҫ���ݣ�
wwwURL: wwwĿ¼����svn��λ��
deployURL: ��������������ļ���svn��λ��
envstr: ��Ҫ����Ļ�������dit, uat,preprod,prod��4������
model: ģ������ƣ�
p_ver: Ӧ�ÿͻ��˵İ汾�ţ���v1.0,v2.0.
manageURL: ��̨����ϵͳ�ķ��ʵ�ַ
staticURL: ��Դ�����صķ���·����ǰ׺
���ӣ�
wwwURL=https://host/svn/tap/trunk/sources/tap-android/assets/www
deployURL=https://host/svn/tap/trunk/deploy
envstr=dit
model=tap
p_ver=v1.0
basecodeversion=143
manageURL=url
staticURL=url
3.	����ļ���ϵ
����Ŀ¼����һ�����ļ��У�
build:�������Ŀ¼�������������Ŀ¼output��
config�������ļ�Ŀ¼���м�������¼��һ�ι����汾������汾��
logs������log
refer:����ϸ���Դ����ԭʼ�ļ�
src����ŵ�ǰ��Դ����ԭ�ļ�
tmp��ÿ��svn����汾����Ϣ

