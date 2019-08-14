#pragma once
#include <string>
#include "MJFunFuZhou.h"

#ifdef WIN32 
#define EXPORT_DLL extern "C" __declspec(dllexport) 
#else
#define EXPORT_DLL extern "C"  
#endif
typedef struct tagTINGINFO_NODE
{
	BOOL		bTing;						// ÿ��Ting�Ƿ�����
	int		byTingFanNumber;				// ���������Ƕ��ٷ�
	BYTE        szTingCard;                  //������
	BYTE        szTingCardleft;                  //������ʣ�༸��

}TINGINFO_NODE;

typedef struct tagTING_NODE
{
	TINGINFO_NODE        szTingInfo[MAX_CARD_POOL];                  //������
	BYTE				 szGiveCard;                  //������
	BOOL		bCanTing;						// ���������Ƿ�����
	BYTE        flag;                          //1��ʾ������
	BOOL        bIsYouJin;                     //�Ƿ����ν�/�н�

}TING_NODE;

typedef	struct tagTING_COUNT
{
	TING_NODE	m_TingNode[MAX_CARD_LENGTH];
}TING_COUNT;


CMJFunFuZhou *fz;

EXPORT_DLL void init();

EXPORT_DLL BOOL TingCount();

EXPORT_DLL void setEnvironment(tagENVIRONMENT& env);

EXPORT_DLL void getTingCount(tagTING_COUNT& tn);






