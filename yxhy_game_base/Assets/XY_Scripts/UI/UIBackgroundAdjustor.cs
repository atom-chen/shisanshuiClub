using UnityEngine;
using System.Collections;

/// <summary>
/// �����豸�Ŀ�߱ȣ�����UISprite scale, �Ա�֤ȫ���ı���ͼ�ڲ�ͬ�ֱ���(��߱�)�µ�����Ӧ
/// ���ýű���ӵ�UISpriteͬһ�ڵ���
/// ����UICameraAdjustor�ű����ʹ��
/// </summary>

[RequireComponent(typeof(UIBasicSprite))]
public class UIBackgroundAdjustor : MonoBehaviour
{
    float standard_width = 1024f;
    float standard_height = 600f;
    float device_width = 0f;
    float device_height = 0f;

    void Awake()
    {
        device_width = Screen.width;
        device_height = Screen.height;

        SetBackgroundSize();
    }

    private void SetBackgroundSize()
    {
        UIBasicSprite m_back_sprite = GetComponent<UIBasicSprite>();

        if (m_back_sprite != null && UIBasicSprite.Type.Simple == m_back_sprite.type)
        {
            //m_back_sprite.MakePixelPerfect();
            float back_width = m_back_sprite.width;
            float back_height = m_back_sprite.height;
            

            float standard_aspect = standard_width / standard_height;
            float device_aspect = device_width / device_height;
            float extend_aspect = 0f;
            float scale = 0f;

            if (device_aspect > standard_aspect) //���������
            {
                scale = device_aspect / standard_aspect;

                extend_aspect = back_width / standard_width;
            }
            else //���߶�����
            {
                scale = standard_aspect / device_aspect;

                extend_aspect = back_height / standard_height;
            }

            if (extend_aspect >= scale) //����ߴ��������䣬����Ŵ�
            {
            }
            else //����ߴ粻�������䣬�ڴ˻����ϷŴ�
            {
                scale /= extend_aspect;
                m_back_sprite.transform.localScale *= scale;
            }
        }
    }
}