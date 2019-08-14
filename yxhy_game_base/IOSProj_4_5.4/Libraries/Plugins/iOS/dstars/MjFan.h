#pragma once
#include <string>
#include "mj/MJFun.h"

#ifdef WIN32 
	#define EXPORT_DLL extern "C" __declspec(dllexport) 
#else
	#define EXPORT_DLL extern "C"  
#endif

//----------------------------------------------------------------------
//������Ϣ
typedef struct tagHUPAIINFO_NODE
{
	BOOL		bHu;					//ÿ�ֺ��Ƿ�����
	BYTE        szHuCard;               //������
	BYTE        szHuCardleft;           //������ʣ�༸��

}HUPAIINFO_NODE;

typedef struct tagHUPAI_NODE
{
	HUPAIINFO_NODE        	szHuPaiInfo[MAX_CARD_POOL]; //������
	BYTE				 	szGiveCard;                 //������
	BYTE					flag;						//1��ʾ������
	BOOL					bCanHuPai;					//���������Ƿ��ܺ�
}HUPAI_NODE;

typedef	struct tagHUPAI_COUNT
{
	HUPAI_NODE	m_HuPaiNode[MAX_CARD_LENGTH];
}HUPAI_COUNT;

//----------------------------------------------------------------------
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
/// <param name="env">��Ϸ����</param>
/// </summary>
EXPORT_DLL int setEnvironment(tagENVIRONMENT* env);

/// <summary>
/// ��ȡ������ʾ��Ϣ
/// <param name="tn">������ʾ�������ڰ�C++������ݴ���Unity��Unityʹ��</param>
/// </summary>
/// <return>0:��ʾ��ȡ������ʾ��Ϣ�ɹ�,����ֵ:��ʾ��ȡ������ʾ��Ϣʧ��</param>
EXPORT_DLL int getHuPaiCount(HUPAI_COUNT* tn);

/// <summary>
/// ��ȡ������ʾ��İ汾��Ϣ
/// </summary>
EXPORT_DLL int getVersion();