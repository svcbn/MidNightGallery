using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButterflyFSM_LJH : MonoBehaviour
{
    public static ButterflyFSM_LJH instance;
    public enum ButterflyState
    {
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        state9
    };

    public ButterflyState butterflyState = ButterflyState.state1;
    public GameObject butterfly;
    public GameObject mainCam;

    public GameObject manager;
    public GameObject hand;

    public float cameraSpeed = 2f;
    public float cameraUpSpeed = 0.001f;
    public float cameraRotSpeed = 0.1f;
    public float fadeSpeed = 0.7f;

    public float _3to4Time = 1f;
    public float butterflyRunawayTime = 10f;
    public float butterflyWaitTime = 2f;
    public float backWaitTime = 3f;
    float currTime = 0f;

    public Image fadeImg;

    public Transform cameraUpPos;
    public Transform cameraBackPos;
    public Transform handRot;
    public bool isButterflyRunaway = false;
  

    // Start is called before the first frame update
    void Start()
    {
        isButterflyRunaway = false;
    }

    // Update is called once per frame
    void Update()
    {
        switch (butterflyState)
        {
            case ButterflyState.state1:
                UpdateState1();
                break;
            case ButterflyState.state2:
                UpdateState2();
                break;
            case ButterflyState.state3:
                UpdateState3();
                break;
            case ButterflyState.state4:
                UpdateState4();
                break;
            case ButterflyState.state5:
                UpdateState5();
                break;
            case ButterflyState.state6:
                UpdateState6();
                break;
            case ButterflyState.state7:
                UpdateState7();
                break;
            case ButterflyState.state8:
                UpdateState8();
                break;
            case ButterflyState.state9:
                UpdateState9();
                break;
        }
    }


    private void UpdateState1()
    {
        //페이드인
        Color tmpColor = fadeImg.color;
        tmpColor.a -= fadeSpeed * Time.deltaTime;
        fadeImg.color = tmpColor;

        if (fadeImg.color.a <= 0.05f)
        {
            Color tmpColor2 = fadeImg.color;
            tmpColor2.a = 0f;
            fadeImg.color = tmpColor2;
            butterflyState = ButterflyState.state2;
        }
        //페이드인 다되면 state2로
    }

    private void UpdateState2()
    {
        butterfly.GetComponent<ButterflyIntro_LJH>().isMove = true;
        //나비 하나가 오른쪽으로 움직임
        //시선은 나비를 따라 움직임
        if (butterfly.transform.position.x >= mainCam.transform.position.x)
        {
            Vector3 tmpPos = mainCam.transform.position;
            mainCam.transform.position = Vector3.Lerp(tmpPos, new Vector3(butterfly.transform.position.x, tmpPos.y, tmpPos.z), cameraSpeed);
        }

        if (butterfly.GetComponent<ButterflyIntro_LJH>().isFinish)
        {
            butterflyState = ButterflyState.state3;
        }
       //시선이 꽃까지 가면 (도착하면) state3로
    }

    private void UpdateState3()
    {
        //시선이 꽃 바로 위로 이동
        Vector3 tmpPos = mainCam.transform.position;
        mainCam.transform.position = Vector3.Lerp(tmpPos, cameraUpPos.position, cameraSpeed);

        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, cameraUpPos.rotation, cameraRotSpeed);

        currTime += Time.deltaTime;
        if(currTime > _3to4Time)
        {
            butterflyState = ButterflyState.state4;
            currTime = 0f;
        }
        //이동 다 했으면 state4로
    }

    private void UpdateState4()
    {
        //Manager, Hand 켜짐
        manager.SetActive(true);
        hand.SetActive(true);
        //나비 움직일 수 있음
        hand.transform.GetChild(0).transform.rotation = handRot.rotation;
        //10초 뒤, 나비 흩어지고 손으로 움직일 수 없음
        currTime += Time.deltaTime;
        if (currTime > butterflyRunawayTime)
        {
            manager.SetActive(false);
            hand.SetActive(false);
            isButterflyRunaway = true;
        }
        if (currTime > butterflyWaitTime)
        {
            currTime = 0f;
            butterflyState = ButterflyState.state5;
        }
       //나비 다 흩어지면 state5로
    }

    private void UpdateState5()
    {
        currTime += Time.deltaTime;
        //시선을 뒤로 돌아봄
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, cameraBackPos.rotation, cameraRotSpeed);
        //시선이 다 닿으면 state7로
        if (currTime > backWaitTime)
        {
            butterflyState = ButterflyState.state6;
        }
        
        
    }

    private void UpdateState6()
    {
        //짤랑
        butterflyState = ButterflyState.state7;
    }

    private void UpdateState7()
    {
        //페이드 아웃
        //페이드 아웃 다 하면 다음 씬으로
        Color tmpColor = fadeImg.color;
        tmpColor.a += fadeSpeed * Time.deltaTime;
        fadeImg.color = tmpColor;

        if (fadeImg.color.a >= 0.95f)
        {
            Color tmpColor2 = fadeImg.color;
            tmpColor2.a = 1f;
            fadeImg.color = tmpColor2;
            butterflyState = ButterflyState.state8;
        }
    }

    private void UpdateState8()
    {
       //다음 씬으로
    }
    private void UpdateState9()
    {
        
    }
}
