//////////////////////////////////////////////////////////////////////////////////////
//
//  FileName    :   environment.h
//  Comment     :   ��Ϸ���������㷬ʱʹ��
//
//////////////////////////////////////////////////////////////////////////////////////

#ifndef _ENVIRONMENT_H
#define _ENVIRONMENT_H
#include <stdio.h>
typedef	unsigned int BYTE;
typedef unsigned int TILE;

#define MAX_ENV_FAN 256
typedef struct tagENV_FAN
{
	BYTE    byFanType; 		//����
	BYTE    byFanNumber;	//����
	BYTE    byCount;
	int    byNoCheck[MAX_ENV_FAN];	//���ķ���
}ENV_FAN;

//checkWin һЩ��������
typedef struct tagCheckWinParam
{
	//�������
	BYTE	byCheck7pairs;			//���7С�ԣ�0����� 1�������ͨ�� 2��ӿ����κ���
	BYTE	byCheck8Pairs;			//���8С�ԣ�0����� 1�������ͨ�� 2��ӿ����κ���
	BYTE	byCheckShiSanYao;		//���ʮ���ۣ�0����� 1�������ͨ�� 2��ӿ����κ���
	BYTE    byLaiziWinNums;			//N������ƿɺ� 0�����
	BYTE	byShiSanBuKao;			//ʮ������: 0����� 1���

	BYTE	byQiXingBuKao;			//���ǲ���: 0����� 1���
	//
	BYTE	by258Jiang;				//258��: 0�����, 1�������ͨ�� 2��ӿ����κ���
	BYTE	byWindPu;				//����: 0�����
	BYTE	byJiangPu;				//����: 0�����
	BYTE	byYaoJiuPu;				//�۾���: 0�����

	BYTE	byShunZFB;				//�з�����˳��: 0����� 1�������ͨ�� 2��ӿ����κ���
	BYTE	byShunWind;				//����������˳��: 0����� 1����������ϳ�˳��(��Ӳ����滻), 
									//2��˳����ϳ�˳��(��Ӳ����滻),3����������ϳ�˳��(��ӿ��滻), 
									//4��˳����ϳ�˳��(��ӿ��滻)

	BYTE	byBKDHu;				//���Ʊ����Ǳ߿���:0����飬1
	
	BYTE   	byBaiChangeGoldUse;	 	//�װ嵱����ʹ��(�װ�䵱����ӵ�������)
	BYTE    byMaxHandCardLength;	//������������
	BYTE	nGameStyle;				//��Ϸ����

	BYTE    nEightFlowerHu;      //0û�У�1���Ż��ɺ�
	BYTE   	byKaiMenLimit;	 	//�������ƣ�0û�У�1û�г����ܲ��ܺ�
	BYTE    byColorLimit;		////������Ҫ��ɫ���� 0û�У�1ȱһ�ź��ɴ����ƣ�2ȱһ�ź����ɴ����ƣ�3�ֻ�ɫ��ȫ
	BYTE	byQYSHu;				//�л�ɫ����ʱ���Ƿ���Ժ���һɫ��0�����ԣ�1����
	BYTE   	byYaoJiuLimit;	 	//�۾����ƣ�0û�У�1��
	BYTE    byDanDiaoLimit;	//�ְ�һ���������ƽ�����Ʈ�����ͣ����С��ԡ��Ͳ����������ƣ�0�ޣ�1 ��

	BYTE    nNSNum[37];         // ʣ������Ƶ���Ŀ
	BYTE    byOneGoldLimit;     //�����ܵ��ں�
	BYTE    byTwoGoldLimit;		//˫�����ϱ����ν��
	tagCheckWinParam()
	{
		byCheck7pairs = 0;
		byCheck8Pairs = 0;
		byCheckShiSanYao = 0;
		byLaiziWinNums = 0;
		byShiSanBuKao = 0;
		byQiXingBuKao = 0;
		by258Jiang = 0;
		byWindPu = 0;
		byJiangPu = 0;
		byYaoJiuPu = 0;

		byShunZFB = 0;
		byShunWind = 0;
		byBKDHu = 0;
		byBaiChangeGoldUse = 0;
		byMaxHandCardLength = 14;
		nGameStyle = 0;
		nEightFlowerHu = 0;
		byKaiMenLimit = 0;
		byColorLimit = 0;
		byQYSHu = 0;// �����л�ɫ���ƵĻ�(�˰��˱���3ɫ��)�����Ժ���һɫ
		byYaoJiuLimit = 0;
		byDanDiaoLimit = 0;
		//���ó�ʼ��
		//memset(&nNSNum, 0, sizeof(nNSNum));
		byOneGoldLimit = 0;     //�����ܵ��ں�
		byTwoGoldLimit = 0 ;		//˫�����ϱ����ν��
	};
}CHECKWIN_PARAM;

typedef	struct tagENVIRONMENT
{
	BYTE	byChair;			// ���˭��
	BYTE	byTurn;				// �ֵ�˭������ǵ��ڣ����ǵ��ڵ��Ǹ���
	TILE	tHand[4][17];		// �ļ����ϵ���
	BYTE	byHandCount[4];		// �����м�����

	TILE	tSet[4][4][3];		// �ļң�4���ƣ�flag��tile��chair
	BYTE	bySetCount[4];		// set�м�����

	TILE	tGive[4][40];		// �ļҳ�������
	BYTE	byGiveCount[4];		// ÿ�˳��˼�����

	TILE	tLast;				// ���͵�������
	BYTE	byFlag;				// 0������1���ڡ�2���ϻ���3����
	
	BYTE	byRoundWind;		// Ȧ��
	BYTE	byPlayerWind;		// �ŷ�
	BYTE	byTilesLeft;		// ��ʣ�������ƣ��������㺣�׵�

	BYTE	byFlowerCount[4];	// 4�Ҹ��ж����Ż�
	
	BYTE	byTing[4];			// ���Ƶ����

	BYTE	byDoFirstGive[4];	// 4���Ƿ������(�����Ҫ�����жϵغ�)

	BYTE	byRecv[6];

	BYTE    byLaiziCards[4];    // ��������飬�ݶ������4��

	BYTE    nNSNum[37];         // ʣ������Ƶ���Ŀ

	BYTE    byMaxHandCardLength;	//������������

	int 	byDoCheck[MAX_ENV_FAN];	//��Ҫ����ķ���

	ENV_FAN byEnvFan[MAX_ENV_FAN];  //��������:{"byFanNumber"=1,"byFanType"=2,"byNoCheck"={1,2,3...}}

	CHECKWIN_PARAM checkWinParam;	//check win ��һЩ��Ҫ�Ĳ���

	BYTE   	byQYSNoWord;		//��һɫ�Ƿ������һɫ
	BYTE    nMissHu;            // ȱһ�ű�־
	BYTE    nMissWind;			// ȱһ�ſ����з���
	// BYTE    nMissHun;		// ȱһ�ſ����л���(ȱͲ��,���������Ͳ��,���ü���)
	BYTE    byDealer;			// ׯ��
	BYTE    gamestyle;          // ��Ϸ���ͣ�
	BYTE    laizi;              // ����������������
	BYTE    flower;             // ������
	BYTE    byGangTimes;        // ���ϻ�ʱ���ܵĴ���
	BYTE    byHaiDi;			// �Ƿ��Ǻ���(�ľ�ǰ���һ�ţ������жϺ������ºͺ�����)


	//����lua���ж� �Ͳ�Ҫ��C++���ж���
	BYTE    byGodTingFlag;      // ������־
	BYTE    byGroundTingFlag;   // ������־
	BYTE    byXiaoSaTingFlag;   // ������־
	// BYTE    bDanDiaoHu;	        // ������
	BYTE    byHunYouFlag;       // ���Ʊ�־
			
	BYTE   KeLimit;                 //����limit
	BYTE   byHaveWinds;             //�Ƴز�һ�����Ƶ�������һ����27��31��34
	// BYTE    bkaAdd;             // ���ź�
	// BYTE    n258Jiang;          // 258��־

}ENVIRONMENT;

//void PrintEnv(const ENVIRONMENT* pstEnv);

#endif	// _ENVIRONMENT_H
