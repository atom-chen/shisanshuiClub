#ifndef __MJ_SC_DEF_H__
#define __MJ_SC_DEF_H__

#include <stdlib.h>
#include <string.h>
#define PLAYER_NUMBER		4
#define WATCHER_NUMBER		16
#define MAX_HAND_TILE		17	// �����������ж�������
#define MAX_TOTAL_TILES		144
#define MAX_TOTAL_TILES_108	108
// #define MAX_FAN_NUMBER		128	// ����ж����ַ�



#define KICK_CANNOT_LOCK_MONEY			1010
#define KICK_NOMONEY					1011
#define KICK_REQUEST_EXIT				1020
#define KICK_OFFLINE					1021
//#define CS_REQUEST_BASE_INFO			301
//#define CS_SELL							302
//#define CS_GIVE							303
//#define	CS_UPDATE_WATCH_OPTION			304
//#define CS_REQUEST_EXIT					305		//��������������Ϣ�����˳�
//#define CS_REQUEST_EXIT_ANSWER			306		//��Ҵ�

//so ���� Client


//MY_NAMESPACE_BEGIN


enum PLAYER_STATUS				//��Ϸ��״̬
{
	psNoLogIn		= 0,		//�û�δ����
	psSit			= 1,		//�û�������λ�ϣ�û�㿪ʼ
	psReady			= 2,		//�û��Ѿ����˿�ʼ���ȴ��������
	psFlower		= 3,		//���������յ���ʱ����
	psGive			= 4,		//����
	psWait			= 5,		//�ȴ����˳��ƻ���ѡ��ԡ���
	psBlock			= 6,		//ѡ���Ƿ����
	psLookOn		= 7,		//�Թ�
	psOffLine		= 8,		//����
	psDingQue		= 9			//��ȱ
};

enum GAME_STATUS				//��Ϸ״̬
{
	gsNoStart		= 0,		//δ��ʼ
	gsFlower		= 1,		//����
	gsGive			= 2,		//�ȴ�ĳ��ҳ��ƣ��������һ���ó���
	gsBlock			= 3,		//�ȴ�������ƣ��ԡ������ܡ��ͣ�����һ����ץ��
	gsSelfBlock		= 4,		//�Լ�ץ�ƺ���������
	gsDingQue		= 5			//�ȴ���Ҷ�ȱ
};

// ��ʼ��������: boat   ����: 2004-3-17
enum ERRCODE
{
    EERROR = 0x000,
    ESUCCESS = 0x001
};
// ��ֹ: ������: boat   ����: 2004-3-17

typedef unsigned int TILE;
typedef unsigned int TILE_TYPE;

#define TILE_INVALID	0
#define TILE_BEGIN		1		// ѭ��ʱ��
#define TILE_CHAR_1		1
#define TILE_CHAR_2		2
#define TILE_CHAR_3		3
#define TILE_CHAR_4		4
#define TILE_CHAR_5		5
#define TILE_CHAR_6		6
#define TILE_CHAR_7		7
#define TILE_CHAR_8		8
#define TILE_CHAR_9		9
#define TILE_BAMBOO_1	11
#define TILE_BAMBOO_2	12
#define TILE_BAMBOO_3	13
#define TILE_BAMBOO_4	14
#define TILE_BAMBOO_5	15
#define TILE_BAMBOO_6	16
#define TILE_BAMBOO_7	17
#define TILE_BAMBOO_8	18
#define TILE_BAMBOO_9	19
#define TILE_BALL_1		21
#define TILE_BALL_2		22
#define TILE_BALL_3		23
#define TILE_BALL_4		24
#define TILE_BALL_5		25
#define TILE_BALL_6		26
#define TILE_BALL_7		27
#define TILE_BALL_8		28
#define TILE_BALL_9		29

#define TILE_EAST		31
#define TILE_SOUTH		32
#define TILE_WEST		33
#define TILE_NORTH		34
#define TILE_ZHONG		35
#define TILE_FA			36
#define TILE_BAI		37

#define TILE_FLOWER_CHUN	41
#define TILE_FLOWER_XIA		42
#define TILE_FLOWER_QIU		43
#define TILE_FLOWER_DONG	44
#define TILE_FLOWER_MEI		45
#define TILE_FLOWER_LAN		46
#define TILE_FLOWER_ZHU		47
#define TILE_FLOWER_JU		48
#define TILE_END			48		// ѭ��ʱ��

#define	TILE_TYPE_CHAR			1	// ��
#define	TILE_TYPE_BAMBOO		2	// ��
#define	TILE_TYPE_BALL			3	// Ͳ
#define TILE_TYPE_OTHER			4	// ����

#define IS_TILE(t) ((t) >= TILE_BEGIN && (t) <= TILE_END)		// ����겻׼ȷ~
#define TILE_IS_CHAR(t) ((t) >= TILE_CHAR_1 && (t) <= TILE_CHAR_9)
#define TILE_IS_BAMBOO(t) ((t) >= TILE_BAMBOO_1 && (t) <= TILE_BAMBOO_9)
#define TILE_IS_BALL(t) ((t) >= TILE_BALL_1 && (t) <= TILE_BALL_9)


#define IS_TILE_SC(t) (TILE_IS_CHAR(t) || TILE_IS_BAMBOO(t) || TILE_IS_BALL(t))

#define TILE_NAME(t)\
	(TILE_CHAR_1 == (t) ? "һ��" : \
	(TILE_CHAR_2 == (t) ? "����" : \
	(TILE_CHAR_3 == (t) ? "����" : \
	(TILE_CHAR_4 == (t) ? "����" : \
	(TILE_CHAR_5 == (t) ? "����" : \
	(TILE_CHAR_6 == (t) ? "����" : \
	(TILE_CHAR_7 == (t) ? "����" : \
	(TILE_CHAR_8 == (t) ? "����" : \
	(TILE_CHAR_9 == (t) ? "����" : \
	(TILE_BAMBOO_1 == (t) ? "һ��" : \
	(TILE_BAMBOO_2 == (t) ? "����" : \
	(TILE_BAMBOO_3 == (t) ? "����" : \
	(TILE_BAMBOO_4 == (t) ? "����" : \
	(TILE_BAMBOO_5 == (t) ? "����" : \
	(TILE_BAMBOO_6 == (t) ? "����" : \
	(TILE_BAMBOO_7 == (t) ? "����" : \
	(TILE_BAMBOO_8 == (t) ? "����" : \
	(TILE_BAMBOO_9 == (t) ? "����" : \
	(TILE_BALL_1 == (t) ? "һͲ" : \
	(TILE_BALL_2 == (t) ? "��Ͳ" : \
	(TILE_BALL_3 == (t) ? "��Ͳ" : \
	(TILE_BALL_4 == (t) ? "��Ͳ" : \
	(TILE_BALL_5 == (t) ? "��Ͳ" : \
	(TILE_BALL_6 == (t) ? "��Ͳ" : \
	(TILE_BALL_7 == (t) ? "��Ͳ" : \
	(TILE_BALL_8 == (t) ? "��Ͳ" : \
	(TILE_BALL_9 == (t) ? "��Ͳ" : \
	(TILE_EAST == (t) ? "����" : \
	(TILE_SOUTH == (t) ? "�Ϸ�" : \
	(TILE_WEST == (t) ? "����" : \
	(TILE_NORTH == (t) ? "����" : \
	(TILE_ZHONG == (t) ? "����" : \
	(TILE_FA == (t) ? "����" : \
	(TILE_BAI == (t) ? "�װ�" : \
	(TILE_FLOWER_CHUN == (t) ? "��" : \
	(TILE_FLOWER_XIA == (t) ? "��" : \
	(TILE_FLOWER_QIU == (t) ? "��" : \
	(TILE_FLOWER_DONG == (t) ? "��" : \
	(TILE_FLOWER_MEI == (t) ? "÷" : \
	(TILE_FLOWER_LAN == (t) ? "��" : \
	(TILE_FLOWER_ZHU == (t) ? "��" : \
	(TILE_FLOWER_JU == (t) ? "��" : \
	"???"))))))))))))))))))))))))))))))))))))))))))


#define TILE_TYPE_NAME(t)\
	(TILE_TYPE_CHAR == (t) ? "��" : (TILE_TYPE_BAMBOO == (t) ? "��" : (TILE_TYPE_BALL == (t) ? "Ͳ" : (TILE_TYPE_OTHER == (t) ? "����������" : "����������"))))

#define GET_TILE_TYPE(t)\
	(IS_TILE(t) ? (TILE_IS_CHAR(t) ? TILE_TYPE_CHAR : (TILE_IS_BAMBOO(t) ? TILE_TYPE_BAMBOO : (TILE_IS_BALL(t) ? TILE_TYPE_BALL : TILE_TYPE_OTHER))) : TILE_INVALID)

#define DINGQUE_STATE_NAME(t)\
	(DINGQUE_STATE_NONE == (t) ? "û�ڶ�ȱ״̬" : \
	(DINGQUE_STATE_DONE == (t) ? "��ѡ��ȱ" : \
(DINGQUE_STATE_DOING == (t) ? "���ڶ�ȱ" : "����Ķ�ȱ״̬")))

// #define DINGQUE_TYPE_NAME(t)\
// 	(DINGQUE_SELECT_PAI == (t) ? "����" : \
// 	(DINGQUE_SELECT_HUASE == (t) ? "����ɫ" : \
// 	(DINGQUE_AUTO_SELECT == (t) ? "�Զ���ȱ" : "����Ķ�ȱ����")))

// #define SHOW_DINGQUE_INFO(type, t)\
// 	switch(type)\
// 	{\
// 	case DINGQUE_SELECT_PAI:\
// 		{\
// 		XDEBUG_INFO("���� %s", TILE_NAME(t));\
// 		}\
// 		break;\
// 	case DINGQUE_SELECT_HUASE:\
// 		{\
// 		XDEBUG_INFO("����ɫ %s", TILE_TYPE_NAME(t));\
// 		}\
// 		break;\
// 	case DINGQUE_AUTO_SELECT:\
// 		{\
// 		XDEBUG_INFO("�Զ���ȱ");\
// 		}\
// 		break;\
// 	default:\
// 		{\
// 		XDEBUG_INFO("��ȱ���ʹ��� %d", type);\
// 		}\
// 		break;\
// 	}

//����ԡ�������
#define ACTION_EMPTY				0x0
#define ACTION_COLLECT				0x10
#define ACTION_TRIPLET				0x11
#define ACTION_QUADRUPLET			0x12
#define ACTION_QUADRUPLET_CONCEALED	0x13
#define ACTION_QUADRUPLET_REVEALED	0x14
#define ACTION_WIN					0x15
#define ACTION_TING					0x16
#define ACTION_FLOWER				0x17
#define ACTION_CANCEL_TRAY			0x18
#define ACTION_LOST					0x17	//CHD, ��ACTION_FLOWERһ��

#define ACTION_LIANGXIER			0x9   //��ϲ�� ����


#define ACTION_CANCEL_QUADRUPLET_REVEALED	0x18	// ֪ͨ�ͻ���ȡ��һ������(�������ܵ�ʱ��)

// ����
#define TING_NONE					0x00
#define TING_REQUEST_REVEALED		0x1
#define TING_REQUEST_CONCEALED		0x2
#define TING_REVEALED				0x3
#define TING_CONCEALED				0x4


// ��������
#define GAME_STYLE_NORMAL			0x01	// ���Ƿ���
#define GAME_STYLE_GUOBIAO			0x02	// ����
#define GAME_STYLE_POP				0x03	// �����齫

#define GAME_STYLE_CHENGDU			0X04	// �ط��齫:�ɶ��齫
#define GAME_STYLE_HANGZHOU			0x05	// �ط��齫:�����齫
#define GAME_STYLE_WUHAN			0x06	// �ط��齫:�人�齫

#define LOCAL_CHENGDU_NOT_XUEZHAN	0		//�ɶ��齫����Ѫսģʽ��
#define LOCAL_CHENGDU_XUEZHAN		1		//�ɶ��齫��Ѫսģʽ�� 

#define GAME_STYLE_ZHENGZHOU			0x11		//--�ط��齫:֣���齫17
#define GAME_STYLE_ZHUMADIAN			0x12		//--�ط��齫 : פ����齫18
#define GAME_STYLE_LUOYANG				0x13		//--�ط��齫 : �����齫19

#define GAME_STYLE_NANYANG			    0x14		//--�ط��齫 : �����齫20
#define GAME_STYLE_ZHOUKOU				0x15		//--�ط��齫 : �ܿ��齫21

#define GAME_STYLE_XUCHANG			    0x16		//--�ط��齫 : ����齫22
#define GAME_STYLE_PUYANG				0x17		//--�ط��齫 : ����齫23

#define GAME_STYLE_XINGXIANG			0x18		//--�ط��齫 : �����齫24
#define GAME_STYLE_KAIFENG				0x19		//--�ط��齫 : �����齫25
#define GAME_STYLE_JIAOZUO			    0x1a		//--�ط��齫 : �����齫26
#define GAME_STYLE_SHANGQIU				0x1b		//--�ط��齫 : �����齫27
#define GAME_STYLE_ANYANG			    0x1c		//--�ط��齫 : �����齫28
#define GAME_STYLE_PINGDINGSHAN			0x1d		//--�ط��齫 : ƽ��ɽ�齫29

#define GAME_STYLE_SHIJIAZHUANG			0x21		//--�ط��齫 : ʯ��ׯ�齫33
#define GAME_STYLE_BAZHOU				0x22		//--�ط��齫 : �����齫34
#define GAME_STYLE_LANGFANG				0x23		//--�ط��齫 : �ȷ��齫35

#define GAME_STYLE_TANGSHAN				0x20		//--�ط��齫 : ��ɽ�齫32


#define GAME_STYLE_BAODING      49       			//-- �ط��齫:�����齫49
#define GAME_STYLE_XINGTAI      50        			//-- �ط��齫:��̨�齫50
#define GAME_STYLE_CANGZHOU     51        			//-- �ط��齫:�����齫51

#define GAME_STYLE_ZHANGJIAKOU  52        			//-- �ط��齫:�żҿ��齫52
#define GAME_STYLE_CHENGDE      53        			//-- �ط��齫:�е��齫53
#define GAME_STYLE_HENGSHUI     54        			//-- �ط��齫:��ˮ�齫54

#define GAME_STYLE_HBTDH        55       		 	//--�ط��齫:�ӱ��Ƶ����齫55
#define GAME_STYLE_QINHUANGDAO  56        			//--�ط��齫:�ػʵ��齫56
#define GAME_STYLE_HBHZ         57        			//--�ط��齫:�ӱ������齫57
#define GAME_STYLE_HANDAN       58        			//-- �ط��齫:�����齫58

#define GAME_STYLE_FUZHOU			0x24	//--�ط��齫 : �����齫
#define GAME_STYLE_QUANZHOU			0x25	//--�ط��齫 : Ȫ���齫
#define GAME_STYLE_XIAMEN			0x26	//--�ط��齫 : �����齫
#define GAME_STYLE_ZHANGZHOU		0x27	//--�ط��齫 : �����齫
#define GAME_STYLE_HONGZHONG		0x28	//--�ط��齫 : �����齫
#define GAME_STYLE_LONGYAN          0x29    //--�ط��齫 : �����齫41
#define GAME_STYLE_NINGDE           0x2a    //--�ط��齫 : �����齫42
#define GAME_STYLE_SANMING          0x2b    //--�ط��齫 : �����齫43
#define GAME_STYLE_13_PUTIAN        0x2c    //--�ط��齫 : ����13���齫44
#define GAME_STYLE_FUDING           0x2d    //--�ط��齫 : �����齫45
#define GAME_STYLE_DAXI             0x2e    //--�ط��齫 : ��Ϫ�齫46
#define GAME_STYLE_NANPING          0x2f    //--�ط��齫 : ��ƽ�齫47
#define GAME_STYLE_PINGTAN          0x30    //--�ط��齫 : ƽ̶�齫48

#define GAME_STYLE_FUQING           101     //--�ط��齫 : �����齫101
#define GAME_STYLE_SHIYAN           106     //--�ط��齫 : ʮ�߿�����
#define GAME_STYLE_ZHUOJI           107     //--�ط��齫 : ׽���齫107

//�ຣ
//���ɶ��齫
//GAME_STYLE_CHENGDU = 0X04    --�ط��齫:�ɶ��齫
#define GAME_STYLE_258					 0x41    //�ط��齫 : 258�齫65
#define GAME_STYLE_GEERMU				 0x42    //�ط��齫 : ���ľ�齫66


//���ɹ� ��100��ʼ
#define GAME_STYLE_TONGLIAO				201    //�ط��齫:ͨ���齫
#define GAME_STYLE_XAMTDH				202    //�ط��齫 : �˰����Ƶ����齫
#define GAME_STYLE_XAMQH					203    //�ط��齫 : �˰����Ƶ����齫

#define WIN_SELFDRAW					0	// ����
#define WIN_GUN							1	// ����
#define WIN_GANGDRAW					2	// ���ϻ�
#define WIN_GANG						3	// ����
#define WIN_GANGGIVE					4	// ������
#define WIN_CHD_NOTILE					5	// �ɶ��齫���Ʋ��в黨��
#define WIN_CHD_EXIT					6	//��������

#define GIVE_STATUS_NONE				0		// ��ͨ
#define GIVE_STATUS_GANG				1		// ����
#define GIVE_STATUS_GANGGIVE			2		// ���ܺ�������

#define DRAW_STATUS_NONE				0
#define DRAW_STATUS_GANG				1		// ��������


#endif //__MJ_SC_DEF_H__
