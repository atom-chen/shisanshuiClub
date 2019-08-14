#include "MJFun.h"

int CMJFun::HuPaiCount()
{
	CMJFanCounter *pCounter = this;
	ENVIRONMENT *pEnv = &pCounter->env;
	CTiles tilesHand;
	CTiles tilesTempHand;
	CTiles temp;
	BYTE chair = pEnv->byChair;
	CMJFanCounter::CollectHandTile(tilesHand, *pEnv, chair);
	int i;
	int j;
	CTiles tilesAll;
	tilesAll.ReleaseAll();
	CMJFanCounter::CollectAllTile(tilesAll, *pEnv, chair);
	//���������
	CTiles tLaiziCards;
	tLaiziCards.ReleaseAll();
	for (i = 0; i < 4; i++)
	{
		if (pEnv->byLaiziCards[i] > 0)
		{
			tLaiziCards.AddTile(pEnv->byLaiziCards[i]);
		}
	}

	tilesHand.Sort();
	int nLaiziCount = pEnv->laizi;
	int nCardPoolLength = 37;
	memset(&m_HuPaiCount, 0, sizeof(HUPAI_COUNT));
	if (tilesHand.nCurrentLength == 0) {
		return -2;
	}

	BOOL TINGFLAG = FALSE;
	for (i = 0; i < tilesHand.nCurrentLength; i++)
	{
		int nFlagIndex = 0;
		//������ͬ������
		if (i + 1 == tilesHand.nCurrentLength || tilesHand.tile[i] != tilesHand.tile[i + 1])
		{
			//ɾ��Ҫ������
			//ÿ���ж�Ҫ��������
			tilesTempHand.ReleaseAll();
			tilesTempHand.AddTiles(tilesHand);
			tilesTempHand.DelTile(tilesHand.tile[i]);
			//Ҫ������
			m_HuPaiCount.m_HuPaiNode[i].szGiveCard = tilesHand.tile[i];
			//printf("=HHHHHHH===GIVE===11==szGiveCard[%d]==%d\n", i, tilesHand.tile[i]);

			//���Ҫ����������ӣ��������1
			if (tLaiziCards.IsHave(tilesHand.tile[i]))
			{
				//printf("==11==chu laizi nLaiziCount==%d\n", nLaiziCount);
				nLaiziCount = nLaiziCount - 1;
			}
			int nCardPoolReallyLength = 0;

			//��������,����Ƿ����ν�����
			BOOL bIsYouJin = FALSE;
			if (pEnv->checkWinParam.byTwoGoldLimit >= 2 && pEnv->checkWinParam.byTwoGoldLimit <= nLaiziCount)
			{
				CTiles tilesYouJin;
				tilesYouJin.ReleaseAll();
				//�������
				CTiles tilesYouJinLaiZi;
				tilesYouJinLaiZi.ReleaseAll();
				//������������
				CTiles tilesYouJinNoLaiZi;
				tilesYouJinNoLaiZi.ReleaseAll();

				tilesYouJin.AddTiles(tilesTempHand);
				//2���3������Ҫ�ν�
				int nYouJinLaiZiNum = nLaiziCount;
				tilesYouJin.DelTile(pEnv->byLaiziCards[0]);
				nYouJinLaiZiNum = nYouJinLaiZiNum - 1;
				for (int m = 0; m < 4; m++)
				{
					if (pEnv->byLaiziCards[m] > 0)
					{
						for (int n = 0; n < tilesYouJin.nCurrentLength; n++)
						{
							if (tilesYouJin.tile[n] == pEnv->byLaiziCards[m])
							{
								tilesYouJinLaiZi.AddTile(pEnv->byLaiziCards[m]);
							}
						}
					}
				}
				//���������
				tilesYouJin.DelTiles(tilesYouJinLaiZi);
				tilesYouJinNoLaiZi.AddTiles(tilesYouJin);
				int nYouJinNoJiangLength = pEnv->checkWinParam.byMaxHandCardLength - 2;
				if (CMJFanCounter::CheckWinNoJiangLaizi(tilesYouJinNoLaiZi, tLaiziCards, nYouJinLaiZiNum, nYouJinNoJiangLength, pEnv->checkWinParam))
				{
					bIsYouJin = TRUE;
				}
			}
			for (j = 1; j <= nCardPoolLength; j++)
			{
				//if (j % 10 != 0 && pEnv->nNSNum[j - 1] != 99999)
				if (j % 10 != 0 && pEnv->nNSNum[j - 1] != 99999)
				{
					nCardPoolReallyLength++;
					//printf("====MAX_CARD_POOL.j=  %d==\n", j);
					//1.���������Ƴص�SS��j
					tilesTempHand.AddTile(j);

					//�����ж��ܷ�win����
					temp.ReleaseAll();
					temp.AddTiles(tilesTempHand);
					//�����õ���������ƣ��������1
					int laizitemp = nLaiziCount;
					BOOL bMoJin = FALSE;
					if (tLaiziCards.IsHave(j))
					{
						bMoJin = TRUE;
						laizitemp = laizitemp + 1;
					}

					//TODO:���ж��Ƿ���Լ���  ȱһ�ŵ����
					BOOL bCanCheck = TRUE;
					BOOL bBall = FALSE;
					BOOL bBaboo = FALSE;
					BOOL bChar = FALSE;
					int nColorLimit = pEnv->checkWinParam.byColorLimit;
					if (nColorLimit > 0)
					{
						CTiles tilesAllTemp;
						tilesAllTemp.ReleaseAll();
						tilesAllTemp.AddTiles(tilesAll);
						//�����Ӧ���Ǽ�����е���
						tilesAllTemp.DelTile(tilesHand.tile[i]);
						tilesAllTemp.AddTile(j);
						for (int k = 0; k < tilesAllTemp.nCurrentLength; k++)
						{
							if (tilesAllTemp.tile[k] >= TILE_EAST)
							{
								if (2 == pEnv->checkWinParam.byColorLimit)
								{
								}
								else
								{
									bCanCheck = FALSE;
								}
							}
							//ȱһ��֧�����
							else if (tilesAllTemp.tile[k] >= TILE_CHAR_1
								&& tilesAllTemp.tile[k] <= TILE_CHAR_9
								&& !tLaiziCards.IsHave(tilesAllTemp.tile[k]))
							{
								bChar = TRUE;
							}
							else if (tilesAllTemp.tile[k] >= TILE_BALL_1
								&& tilesAllTemp.tile[k] <= TILE_BALL_9
								&& !tLaiziCards.IsHave(tilesAllTemp.tile[k]))
							{
								bBall = TRUE;
							}
							else if (tilesAllTemp.tile[k] >= TILE_BAMBOO_1
								&& tilesAllTemp.tile[k] <= TILE_BAMBOO_9
								&& !tLaiziCards.IsHave(tilesAllTemp.tile[k]))
							{
								bBaboo = TRUE;
							}
						}
						//ȱһ�Ų��ɺ�
						if (bChar && bBall && bBaboo && (nColorLimit == 1 || nColorLimit == 2))
						{
							bCanCheck = FALSE;
						}
						//��ȱ�Ų��ܺ�
						if (!bChar || !bBall || !bBaboo && (nColorLimit == 3))
						{
							bCanCheck = FALSE;
						}
						//���ܺ���һɫ
						if (((bChar && !bBall && !bBaboo) || (!bChar && bBall && !bBaboo) || (!bChar && !bBall && bBaboo))
							&& (nColorLimit == 4))
						{
							bCanCheck = FALSE;
						}
					}
					int nKeLimit = pEnv->KeLimit;
					BOOL bHaveKe = FALSE;
					if (nKeLimit)
					{
						CTiles tilesKe;
						for (int ke = 0; ke < temp.nCurrentLength; ke++)
						{
							tilesKe.ReleaseAll();
							tilesKe.AddTile(temp.tile[ke]);
							tilesKe.AddTile(temp.tile[ke]);
							tilesKe.AddTile(temp.tile[ke]);
							if (tilesKe.IsSubSet(temp))
							{
								bHaveKe = TRUE;
							}
						}
						for (int setnum = 0; setnum < pEnv->bySetCount[chair]; setnum++)
						{
							if (pEnv->tSet[chair][setnum][0] == ACTION_TRIPLET
								|| pEnv->tSet[chair][setnum][0] == ACTION_QUADRUPLET
								|| pEnv->tSet[chair][setnum][0] == ACTION_QUADRUPLET_CONCEALED
								|| pEnv->tSet[chair][setnum][0] == ACTION_QUADRUPLET_REVEALED
								|| pEnv->tSet[chair][setnum][0] == ACTION_LIANGXIER)
							{
								bHaveKe = TRUE;
							}
						}

						if (!bHaveKe)
						{
							bCanCheck = FALSE;
						}
					}
					int nYaoJiuLimit = pEnv->checkWinParam.byYaoJiuLimit;
					if (nYaoJiuLimit)
					{
						CTiles tilesAllTemp;
						tilesAllTemp.ReleaseAll();
						tilesAllTemp.AddTiles(tilesAll);
						//�����Ӧ���Ǽ�����е���
						tilesAllTemp.DelTile(tilesHand.tile[i]);
						tilesAllTemp.AddTile(j);
						BOOL bYao = FALSE;
						BOOL bJiu = FALSE;
						BOOL bZi = FALSE;
						for (int k = 0; k < tilesAllTemp.nCurrentLength; k++)
						{
							if (tilesAllTemp.tile[k] % 10 == 1)
							{
								bYao = TRUE;
							}
							if (tilesAllTemp.tile[k] % 10 == 9)
							{
								bJiu = TRUE;
							}
							if (tilesAllTemp.tile[k] > 34)
							{
								bZi = TRUE;
							}
						}
						if ((bYao || bJiu) || bZi)
						{
						}
						else
						{
							bCanCheck = FALSE;
						}
					}
					int nDanDiaoLimit = pEnv->checkWinParam.byDanDiaoLimit;
					if (nDanDiaoLimit == 1 && tilesHand.nCurrentLength == 2)
					{
						CTiles tileAllTemp;
						tileAllTemp.ReleaseAll();
						tileAllTemp.AddTiles(tilesAll);
						if (!CheckIsTripletsHu(tileAllTemp))
						{
							bCanCheck = FALSE;
						}
					}
					if (bCanCheck)
					{
						//����Ƿ�ɺ�
						BOOL bWin = FALSE;
						//��������ƿɺ�������жϣ�������CheckWin���
						int byLaiziWinNums = pEnv->checkWinParam.byLaiziWinNums;
						if (byLaiziWinNums > 0 && byLaiziWinNums <= laizitemp)
						{
							//pEnv->checkWinParam.byLaiziWinNums = 0;
							bWin = TRUE;
						}
						if (pEnv->flower == 8 && pEnv->checkWinParam.nEightFlowerHu == 1)
						{
							bWin = TRUE;
						}
						if (!bWin)
						{
							bWin = CMJFanCounter::CheckWin(temp, laizitemp, tLaiziCards, pEnv->checkWinParam);
						}
						//2���3������Ҫ�ν�
						int tempjin = 0;
						if (bMoJin)
						{
							tempjin = laizitemp - 1;
						}
						else
						{
							tempjin = laizitemp;
						}
						if (pEnv->checkWinParam.byTwoGoldLimit >= 2 && pEnv->checkWinParam.byTwoGoldLimit <= tempjin)
						{
							if (!bIsYouJin)
							{
								bWin = FALSE;
							}

						}
						//pEnv->checkWinParam.byLaiziWinNums = byLaiziWinNums;

						if (bWin)
						{
							nFlagIndex++;
							m_HuPaiCount.m_HuPaiNode[i].bCanHuPai = TRUE;
							m_HuPaiCount.m_HuPaiNode[i].szHuPaiInfo[j - 1].bHu = TRUE;
							m_HuPaiCount.m_HuPaiNode[i].szHuPaiInfo[j - 1].szHuCard = j;
							//�����������j ��ʣ���ٸ�
							int szHuCardleft = 0;
							int nHaveCount = 0;
							for (int k = 0; k < tilesHand.nCurrentLength; k++)
							{
								if (tilesHand.tile[k] == j)
								{
									nHaveCount = nHaveCount + 1;
								}
							}
							szHuCardleft = pEnv->nNSNum[j - 1] - nHaveCount;
							if (szHuCardleft < 0)
							{
								szHuCardleft = 0;
							}
							m_HuPaiCount.m_HuPaiNode[i].szHuPaiInfo[j - 1].szHuCardleft = szHuCardleft;
							TINGFLAG = TRUE;
						}
					}

					//2.�Ƴ�ȥ��������j
					tilesTempHand.DelTile(j);
				}
			}
			//���Ҫ����������ӣ��������1(i�ж����˺�Ҫ�ӻ���)
			if (tLaiziCards.IsHave(tilesHand.tile[i]))
			{
				nLaiziCount = nLaiziCount + 1;
			}
			if (nFlagIndex >= nCardPoolReallyLength || bIsYouJin)
			{
				m_HuPaiCount.m_HuPaiNode[i].flag = 1;
			}
		}
	}

	if (TINGFLAG == TRUE)
	{
		return 1;
	}
	else {
		return -1;
	}
	return 0;
}