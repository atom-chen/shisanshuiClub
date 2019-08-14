// MJFanCounter.h: interface for the CMJFanCounter class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MJFANCOUNTER_H__A720C7FA_091F_47FC_A284_B75795F05DE3__INCLUDED_)
#define AFX_MJFANCOUNTER_H__A720C7FA_091F_47FC_A284_B75795F05DE3__INCLUDED_
#pragma once

#include "MJ_sc_def.h"
#include "environment.h"
#define SO_VERSION 101

#ifndef BOOL
typedef		unsigned char	BOOL;
#endif // !BOOL

#ifndef TRUE
#define		TRUE	1
#endif

#ifndef FALSE
#define		FALSE	0
#endif

#define MAX_FAN_NUMBER		256
#define MAX_FAN_NAME		24

#define MAX_CARD_NUMBER		128


#define MAX_CARD_LENGTH		17

#define MAX_CARD_POOL		37

class CMJFun;
class CMJFanCounter
{
public:
	typedef void(*CHECKFUNC)(CMJFanCounter*);
	typedef struct tagFAN_NODE
	{
		BOOL		bFan;						// ÿ�ַ��Ƿ�����
		BOOL		bCheck;						// �Ƿ������
		CHECKFUNC	Check;						// ��麯��
		char		szFanName[MAX_FAN_NAME];	// ÿ�ַ�������
		BYTE		byFanNumber;				// ÿ�ַ��Ƕ��ٷ�
		BYTE		byCount;					// ����
		BYTE        byFanType;                  //��Ӧ������
	}FAN_NODE;

	typedef	struct tagFAN_COUNT
	{
		FAN_NODE	m_FanNode[MAX_FAN_NUMBER];
	}FAN_COUNT;

	//������Ϣ
	typedef void(*TINGFUNC)(CMJFanCounter*);
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


	//������Ϣ
	typedef void(*HUPAIFUNC)(CMJFanCounter*);
	typedef struct tagHUPAIINFO_NODE
	{
		BOOL		bHu;					// ÿ�ֺ��Ƿ�����
		BYTE        szHuCard;               //������
		BYTE        szHuCardleft;           //������ʣ�༸��

	}HUPAIINFO_NODE;

	typedef struct tagHUPAI_NODE
	{
		HUPAIINFO_NODE        	szHuPaiInfo[MAX_CARD_POOL];   //������
		BYTE				 	szGiveCard;                  //������
		BYTE					flag;                          //1��ʾ������
		BOOL					bCanHuPai;					// ���������Ƿ��ܺ�
	}HUPAI_NODE;

	typedef	struct tagHUPAI_COUNT
	{
		HUPAI_NODE	m_HuPaiNode[MAX_CARD_LENGTH];
	}HUPAI_COUNT;

	class CTiles
	{
	public:
		TILE	tile[MAX_CARD_NUMBER];
		int		nCurrentLength;

		CTiles();
		virtual ~CTiles();

		void	Swap(int src, int dst);

		void	AddTile(TILE t);
		void	AddTiles(CTiles& tiles);
		void	AddTiles(TILE* pTiles, int nCount);

		void	DelTile(TILE t);
		void	DelTiles(CTiles& tiles);
		void	DelTileAll(TILE t);

		BOOL	IsSubSet(CTiles& tiles);
		BOOL	IsHave(TILE t);
		BOOL	IsHaveNum(TILE t, int num);
		void	ReleaseAll();
		void	Sort();

		void	AddCollect(TILE tStart);	// ����һ��tStart��ʼ��˳��
		void	AddTriplet(TILE t);			// ����t�Ŀ���

		int     size();

	};

	CMJFanCounter();
	int InitFanCounter(int nMinWin, int nBaseBet)
	{
		m_nMinWin = nMinWin;
		m_nBaseBet = nBaseBet;
		return 0;
	}
	ENVIRONMENT* MutableEnv() { return &env; }
	virtual ~CMJFanCounter();

	virtual	BOOL Count(FAN_COUNT*& pFanCount);
	virtual BOOL GetScore(int nScore[4]);
	virtual void InitForNext() {};
	virtual BOOL CheckWin(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	virtual	BOOL TingCount(TING_COUNT*& pTingCount);
	virtual	BOOL HuPaiCount(HUPAI_COUNT*& pHuPaiCount);
protected:
	ENVIRONMENT env;
	FAN_COUNT	m_FanCount;

	TING_COUNT	m_TingCount;
	HUPAI_COUNT	m_HuPaiCount;

	int			m_nGameStyle;			// ��Ϸ����
	int			m_nMinWin;				// �ܺ��Ƶ���С����
	int			m_nBaseBet;				// �׷�
	static int         m_nWind;
	static int         m_nJiang;
	static int         m_nYaoJiu;
	static int         m_bZFBWind; //�з��׳�˳
protected:

	//�����Ⱦ��������
	static BOOL CheckWinLimit(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);

	//������Ƽ�飺7С�ԡ�ʮ���ۡ�13������8С�Եȡ�����
	static BOOL CheckWinSpecial(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);

	//�������Ƽ��
	static BOOL CheckWinPublic(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	//�����齫�������
	static BOOL CheckWinNormalLongYan(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	//���˽����۾����������  ������齫
	static BOOL CheckWinNormalWJYJPu(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	//258���������  �����硢�����齫
	static BOOL CheckWinNormal258Jiang(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);

	//�߿�����:ͨ���齫
	static BOOL CheckWinNormalBKD(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	static BOOL CheckWinNormalB(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	static BOOL CheckWinNormalK(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);
	static BOOL CheckWinNormalD(CTiles &tilesHand, int nLaiziCount, CTiles &laiziCard, CHECKWIN_PARAM &checkWinParam);

protected:
	static void	CollectAllTile(CTiles &tilesAll, ENVIRONMENT &env, BYTE chair);	// �õ�ĳȫ��ȫ������
	static void	CollectHandTile(CTiles &tilesHand, ENVIRONMENT &env, BYTE chair);   // �õ����ϵ���
	static void	CollectLaiziTile(CTiles &tilesLaizi, ENVIRONMENT &env);   // �õ��ƾֵ������

	//tilesHandȫ������
	static BOOL CheckWinNormal(CTiles &tilesHand, int nCardLength);
	//tilesHandȥ�������ȫ������
	static BOOL CheckWinNoJiang(CTiles &tilesHand, int nCardLength);
	//tilesHand����������
	static BOOL CheckWinNormalLaiZi(CTiles &tilesHand, CTiles &laiziCard, int nLaiZiCount, int nCardLength, CHECKWIN_PARAM &checkWinParam);
	//tilesHandȥ�����������������
	static BOOL CheckWinNoJiangLaizi(CTiles &tilesHand, CTiles &laiziCard, int nLaiZiCount, int nCardLength, CHECKWIN_PARAM &checkWinParam);	// ȥ����ʣ�µ���,���������
	//�����˽����۾����Ƿ��Ӯ�� tilesHand����������
	static BOOL CheckWinWJYJPu(CTiles &tilesHand, CHECKWIN_PARAM &checkWinParam);

	static BOOL		CheckIsTriplet(CTiles tilesHand);	// ���������Ƿ�������������

	//7С��
	static BOOL CheckWinDouble(CTiles &tilesHand);
	static BOOL CheckWinDoubleLaiZi(CTiles &tilesHand, int nLaiZiCount);
	//ʮ����
	static BOOL CheckWinShiSanYao(CTiles &tilesHand);
	static BOOL CheckWinShiSanYaoLaizi(CTiles &tilesHand, int nLaiZiCount);//����ӵ�13��
	static BOOL CheckWinShiSanYaoLaiziLongYan(CTiles &tilesHand, CTiles &laiziCard, int nLaiZiCount); //����ӵ�13�� �װ��滻����ԭ������
	//ʮ������
	static BOOL CheckWinShiSanBuKao(CTiles &tilesHand);
	//���ǲ���
	static BOOL CheckWinQiXingBuKao(CTiles &tilesHand);
	//8С��
	static int  CheckWinPair8(CTiles &tilesHand, int nLaiZiCount, int nLength = 17, bool bLast = false);


	friend class CMJFun;
};

#endif // !defined(AFX_MJFANCOUNTER_H__A720C7FA_091F_47FC_A284_B75795F05DE3__INCLUDED_)
