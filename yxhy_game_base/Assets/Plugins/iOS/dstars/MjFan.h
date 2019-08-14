#pragma once
#include <string>
#include "mj/MJFun.h"

#ifdef WIN32 
	#define EXPORT_DLL extern "C" __declspec(dllexport)
#else
	#define EXPORT_DLL extern "C"  
#endif

CMJFun *fz = NULL;

/// <summary>
/// ��ʼ��������ʾϵͳ����
/// </summary>
/// <param name="byStyle"> ģʽ��0: --��ͨģʽ�� 1: --Ѫսģʽ</param>
/// <param name="bZiMoJiaDi">�����ӵױ�־</param>
/// <param name="bJiaJiaYou">�Ҽ��б�־</param>
EXPORT_DLL void initLib(BYTE byStyle = 0, BOOL bZiMoJiaDi = FALSE, BOOL bJiaJiaYou = FALSE);

/// <summary>
/// ����Ƿ��к�����ʾ
/// </summary>
/// <return>1:��ʾ�к�����ʾ,����ֵ:��ʾû�к�����ʾ</param>
EXPORT_DLL int checkHuPaiCount();

/// <summary>
/// ���ú�����ʾ��Ϸ����
/// <param name="env">��Ϸ����json�ַ���</param>
/// </summary>
EXPORT_DLL int setEnvironment(char* env);

/// <summary>
/// ��ȡ������ʾ��Ϣ
/// </summary>
/// <return>��ȡ������ʾ��Ϣjson��ʽ���ַ���,��ʽ���£�
/// [{"give":1,"flag":0,"win":[{"nFan":0,"nCard":3,"nLeft":4},{"nFan":0,"nCard":6,"nLeft":3},{"nFan":0,"nCard":14,"nLeft":4}, {...}, ...]}, {...}, ...]
/// 
///</return>
EXPORT_DLL char* getHuPaiCount();

/// <summary>
/// ��ȡ������ʾ��İ汾��Ϣ
/// </summary>
EXPORT_DLL int getVersion();