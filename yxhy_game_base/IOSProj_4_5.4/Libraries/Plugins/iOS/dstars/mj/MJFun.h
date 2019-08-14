// MJFun.h: interface for the CMJFun class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MJFUNCHENGDU_H__6B6B9972_76DC_4ED5_B98D_407370829DBD__INCLUDED_)
#define AFX_MJFUNCHENGDU_H__6B6B9972_76DC_4ED5_B98D_407370829DBD__INCLUDED_


#include "MJFanCounter.h"
#include<vector>

typedef unsigned int uint32_t;
/*
struct CHENGDU_SCORE_RECORD
{
	BYTE	byCount;			//����Ѫս�Ĵ��������Ϊ3����������κ�(���һ�ο����ǻ���)��
	BYTE	byFlag[3];			// ״̬�����ơ����ڡ�����
	BYTE	byFan[3][32];		// ���� ֻ��Ҫ����128�ֽڵ�ǰ��32�ֽھ��㹻�ˡ�
	BYTE	byFanNumber[3][32];	// ��������ܡ����ȡ�ֻ��Ҫ����128�ֽڵ�ǰ��32�ֽھ��㹻�ˡ�
	BYTE	byWhoHu[3];			// ˭�͵�
	BYTE	byWhoGun[3];			// ˭���ڵ�
	int		nScore[3][4];
	int		nMoney[3][4];
	int		nScoreGang[4];		//��˵���¹η�����������ÿ���˵÷֣�֮ǰ�Ѿ����ۻ��߼ӡ�
	int		nMoneyGang[4];		//��˵���¹η�����������ÿ������Ϸ�ң�֮ǰ�Ѿ����ۻ��߼ӡ�
	int		nScoreZiMoJiaDi[4];		// �����ӵ׵ĵ÷�
	int		nMoneyZiMoJiaDi[4];		// �����ӵ׵���Ϸ��

	BOOL	bHuaZhu[4];			//˭����	FINISH_NOTILE��ʱ�������
	BOOL	bTing[4];			//˭��		FINISH_NOTILE��ʱ�������
	char	cFanTing[4];		//�����˵ķ���	FINISH_NOTILE��ʱ�������

	int		nScoreTotal[4];		//����Ӯ��
	int		nMoneyTotal[4];		//����Ӯ��Ϸ��
	int		nScoreLast[4];		//�����Ӯ��
	int		nMoneyLast[4];		//�����Ӯ��Ϸ��

	BYTE	tLast[3];			// �͵���һ��
	CHENGDU_SCORE_RECORD()
	{
		memset(this, 0, sizeof(CHENGDU_SCORE_RECORD)); 
	}
};

*/
class CMJFun : public CMJFanCounter  
{
public:
	CMJFun();
	virtual ~CMJFun();
public:
	
    int InitFanMJCounter(BYTE byStyle, bool bZiMoJiaDi, bool bJiaJiaYou)
    {
        m_byStyle = byStyle;
        m_bZiMoJiaDi = bZiMoJiaDi;
        m_bJiaJiaYou = bJiaJiaYou;
        return 0;
    }
   

	BYTE GetFan();
	BYTE GetFanMuTi();
	BOOL CountTing(FAN_COUNT*& pFanCount);

public:
    virtual	BOOL Count(FAN_COUNT*& pFanCount);
    virtual BOOL GetScore(int nScore[4]);
    virtual void InitForNext();
	virtual	BOOL TingCount(TING_COUNT*& pTingCount);
	virtual	BOOL HuPaiCount(HUPAI_COUNT*& pHuPaiCount);

public:
	//�ͻ�����ӷ��� begin
	virtual int HuPaiCount();
	virtual HUPAI_COUNT& GetHuPaiCount() { return m_HuPaiCount; }
	//�ͻ�����ӷ��� end

private:		//CHD, �ɶ��齫ר�� 
    BOOL  CHD_SetRecordAndGetScore(int nScore[4]);	//Ѫսģʽ�Ƿ֡�һ�κ��ķ֣������ܷ�
private:

	BYTE m_byStyle; // 0: --��ͨģʽ�� 1: --Ѫսģʽ
	BOOL m_bZiMoJiaDi;			// �����ӵ�
	BOOL m_bJiaJiaYou;			// �Ҽ���
	int m_nZiMoJiaDi[4];		//�õ��ӵ׵�����
	static BOOL m_bNew19Check;			// �µ��۾����ͼ��
	static int m_nFourCount;
	static int m_nLaiZiNeed;

private:
	//��������
	static BOOL		CheckIsAllPairs(CTiles tiles);	//����Ƿ��Ƕ��� 
	static BOOL		CheckIsOneColor(CTiles tiles);	//����Ƿ���һɫ
	static BOOL		CheckIsTripletsHu(CTiles tilesHand);	// ���������Ƿ�������������
	static BOOL		CheckIs19Hu(CTiles tiles);	// ��������Ƿ��۾ź����͡�
	static BOOL		CheckIsHunColor(CTiles tiles);	//����Ƿ��һɫ 
	static BOOL		CheckWin7PairLaiZi(CTiles &tilesHand, int nLaiZiCount);
	static BOOL		CheckIsTripletsHuLaiZi(CTiles& tilesHand, int nlaiziCount);	// ���������Ƿ����������������
	static int      GetColorTypeCout(CTiles tiles);		//�����ɫ����

	//ȫ����,������������
	static BOOL		CheckWinYouJin(CTiles &tilesHand, int nLaiZiCount, ENVIRONMENT &env, TILE tileHu);

private:
	static void		Check000(CMJFanCounter* pCounter);	// ƽ�� 
	static void		Check001(CMJFanCounter* pCounter);	// ������
	static void		Check002(CMJFanCounter* pCounter);	// ��һɫ
	static void		Check003(CMJFanCounter* pCounter);	// ���۾�
	static void		Check004(CMJFanCounter* pCounter);	// ��С��
	static void		Check005(CMJFanCounter* pCounter);	// ���߶�
	static void		Check006(CMJFanCounter* pCounter);	// ��ԣ��������
	static void		Check007(CMJFanCounter* pCounter);	// ���߶�
	static void		Check008(CMJFanCounter* pCounter);	// ���۾�
	static void		Check009(CMJFanCounter* pCounter);	// ����	, 258������
	static void		Check010(CMJFanCounter* pCounter);	// �����߶� 

	static void		Check011(CMJFanCounter* pCounter);	//��ӷ�: ��
	static void		Check012(CMJFanCounter* pCounter);	//��ӷ�: ��
	static void		Check013(CMJFanCounter* pCounter);	//��ӷ������ϻ� 
	static void		Check014(CMJFanCounter* pCounter);	//��ӷ���������  
	static void		Check015(CMJFanCounter* pCounter);	//��ӷ������ܺ� 

	static void		Check016(CMJFanCounter* pCounter);	//ׯ��������ģ������������� 
	static void		Check017(CMJFanCounter* pCounter);	//��ׯ��������ģ�������غ����� 
												
	//�ӱ��齫
	static void		Check018(CMJFanCounter* pCounter);	// ���� 
	static void		Check019(CMJFanCounter* pCounter);	// ����
	static void		Check020(CMJFanCounter* pCounter);	// ���� 
	static void		Check021(CMJFanCounter* pCounter);	// �� 
	static void		Check022(CMJFanCounter* pCounter);	// �� 
	static void		Check023(CMJFanCounter* pCounter);	// �� 
	static void		Check024(CMJFanCounter* pCounter);	// ׯ�� 
	static void		Check025(CMJFanCounter* pCounter);	// һ����
	static void		Check026(CMJFanCounter* pCounter);	// ��������

	static void		Check027(CMJFanCounter* pCounter);	// �����߶� 
	static void		Check028(CMJFanCounter* pCounter);	// ������߶� 

	static void		Check029(CMJFanCounter* pCounter);	// �������߶�
	static void		Check030(CMJFanCounter* pCounter);	// �峬�����߶�
 
	static void		Check031(CMJFanCounter* pCounter);	// ��������߶�
	static void		Check032(CMJFanCounter* pCounter);	// ����������߶�

	static void		Check033(CMJFanCounter* pCounter);	// ׽���
	static void		Check034(CMJFanCounter* pCounter);	// ʮ����  
	static void		Check035(CMJFanCounter* pCounter);	// ��һɫһ����  
	static void		Check036(CMJFanCounter* pCounter);	// ���ϸ� 

	//����Ϊ����ӵĺ������ӱ��ȷ��齫
	static void		Check037(CMJFanCounter* pCounter);	// �غ�
	static void		Check038(CMJFanCounter* pCounter);	// ׽���������ӣ�  
	static void		Check039(CMJFanCounter* pCounter);	// һ����������ӣ�
	static void		Check040(CMJFanCounter* pCounter);	// ��С�ԣ�����ӣ� 
	static void		Check041(CMJFanCounter* pCounter);	// �����߶ԣ�����ӣ�
	static void		Check042(CMJFanCounter* pCounter);	// ���������߶ԣ�����ӣ� 
	static void		Check043(CMJFanCounter* pCounter);	// ��������߶ԣ�����ӣ�  
	static void		Check044(CMJFanCounter* pCounter);	// ���������ӣ� 
	static void		Check045(CMJFanCounter* pCounter);	// ����죨����ӣ�
	static void		Check046(CMJFanCounter* pCounter);	// ������������ӣ� 
	static void		Check047(CMJFanCounter* pCounter);	// ��һɫ������ӣ�  
	static void		Check048(CMJFanCounter* pCounter);	// 13�ۣ�����ӣ�
	static void		Check049(CMJFanCounter* pCounter);	// ���ƣ�����ӣ�

	//����Ϊ��ɽ����
	static void		Check051(CMJFanCounter* pCounter);	// ������������ӣ�
	static void		Check052(CMJFanCounter* pCounter);	// �����ڣ�����ӣ�
	static void		Check053(CMJFanCounter* pCounter);	// ����������ӣ�
	static void		Check054(CMJFanCounter* pCounter);	// ����������ӣ�
	static void		Check055(CMJFanCounter* pCounter);	// ����������ӣ�

	//��������
	static void		Check056(CMJFanCounter* pCounter);	// �����ǣ�����ӣ�
	static void		Check057(CMJFanCounter* pCounter);	// �Ľ�����Ļ��

	//����������
	static void		Check058(CMJFanCounter* pCounter);	// ����
	static void		Check059(CMJFanCounter* pCounter);	// ȱһ��
	static void		Check060(CMJFanCounter* pCounter);	// ������
	static void		Check061(CMJFanCounter* pCounter);	// �۾���
	static void		Check062(CMJFanCounter* pCounter);	// ����
	static void		Check063(CMJFanCounter* pCounter);	// ʮ������
	static void		Check064(CMJFanCounter* pCounter);	// ��һɫ

	//���ݻ�һɫ
	static void		Check065(CMJFanCounter* pCounter);	// ��һɫ
	static void		Check066(CMJFanCounter* pCounter);	// �з���˳��
	static void		Check067(CMJFanCounter* pCounter);	// ����
	static void		Check068(CMJFanCounter* pCounter);	// ����
	
// 	static void		Check069(CMJFanCounter* pCounter);	// ��һɫ�߶�
// 	static void		Check070(CMJFanCounter* pCounter);	// ��һɫ�����߶�
// 	static void		Check071(CMJFanCounter* pCounter);	// ��һɫһ����
// 	static void		Check072(CMJFanCounter* pCounter);	// ���ǲ���


	static void		Check069(CMJFanCounter* pCounter);	// ţ�ƽ�

	//����������
	static void		Check070(CMJFanCounter* pCounter);	// С��Ԫ
	static void		Check071(CMJFanCounter* pCounter);	// ����Ԫ
	static void		Check072(CMJFanCounter* pCounter);	// ���Ĺ� ȫƵ��
	static void		Check073(CMJFanCounter* pCounter);	// ���Ĺ� ȫƵ��
	static void		Check074(CMJFanCounter* pCounter);	// ���Ĺ� ��Ƶ��
	static void		Check075(CMJFanCounter* pCounter);	// ���Ĺ� ��Ƶ��

	static void		Check076(CMJFanCounter* pCounter);	// �к�
	//׽������
	static void		Check077(CMJFanCounter* pCounter);	// ˫��
	static void		Check078(CMJFanCounter* pCounter);	// ���߶�
	static void		Check079(CMJFanCounter* pCounter);	// ������
};

#endif // !defined(AFX_MJFUNCHENGDU_H__6B6B9972_76DC_4ED5_B98D_407370829DBD__INCLUDED_)
