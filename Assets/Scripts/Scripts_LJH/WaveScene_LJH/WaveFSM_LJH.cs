using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class WaveFSM_LJH : MonoBehaviour
{
    public GameObject mainCam;
    public GameObject butterfly;
    public GameObject waterSurface;
    public GameObject manager;
    public GameObject hand;

    public Transform camDownRot;
    public Transform camRightRot;
    public Transform camForwardRot;
    public Transform camLeftRot;

    public float state1ChangeTime = 3f;
    public float state8WaitTime = 6f;
    public float waterWaitTime = 20f;
    public float camRotateSpeed = 0.001f;
    public float camFirstRotateSpeed = 0.001f;
    public float camMoveSpeed = 5f;
    public float fadeSpeed = 0.8f;

    public GameObject distortionObject;
    public Image fadeImg;
    public AudioSource chimeAudioSource;

    public bool isChimeTouch;
    public bool isChimeSoundRing;

    private float currTime = 0f;
    private float camHeight;

    public enum WaveState
    {
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        state9,
        state10,
        state11
    }

    public WaveState waveState = WaveState.state1;
    // Start is called before the first frame update
    void Start()
    {
        camHeight = mainCam.transform.position.y - waterSurface.transform.position.y;
        chimeAudioSource.clip = Resources.Load("Resources_LJH/WINDCHIME") as AudioClip;
    }

    // Update is called once per frame
    void Update()
    {
        switch (waveState)
        {
            case WaveState.state1:
                UpdateState1();
                break;
            case WaveState.state2:
                UpdateState2();
                break;
            case WaveState.state3:
                UpdateState3();
                break;
            case WaveState.state4:
                UpdateState4();
                break;
            case WaveState.state5:
                UpdateState5();
                break;
            case WaveState.state6:
                UpdateState6();
                break;
            case WaveState.state7:
                UpdateState7();
                break;
            case WaveState.state8:
                UpdateState8();
                break;
            case WaveState.state9:
                UpdateState9();
                break;
            case WaveState.state10:
                UpdateState10();
                break;
            case WaveState.state11:
                UpdateState11();
                break;

        }
    }

    private void UpdateState1()
    {
        currTime += Time.deltaTime;
        if (currTime > state1ChangeTime)
        {
            currTime = 0f;
            waveState = WaveState.state2;
        }

    }

    private void UpdateState2()
    {
        //반대편 벽을 본다 1
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, camDownRot.rotation, camRotateSpeed);

        if (mainCam.transform.rotation == camDownRot.rotation)
            waveState = WaveState.state3;

        
    }

    private void UpdateState3()
    {
        //반대편 벽을 본다 2
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, camRightRot.rotation, camRotateSpeed);
        if (mainCam.transform.rotation == camRightRot.rotation)
            waveState = WaveState.state4;
        
    }

    private void UpdateState4()
    {
        //바닥을 본다
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, camDownRot.rotation, camRotateSpeed);
        if (mainCam.transform.rotation == camDownRot.rotation)
            waveState = WaveState.state5;
        
    }

    private void UpdateState5()
    {
        //앞을 본다
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, camForwardRot.rotation, camRotateSpeed);
        if (mainCam.transform.rotation == camForwardRot.rotation)
            waveState = WaveState.state6;

    }

    private void UpdateState6()
    {
        //살짝 왼쪽 옆을 보고
        currTime += Time.deltaTime;
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, camLeftRot.rotation, camRotateSpeed);
        //if (mainCam.transform.rotation == camLeftRot.rotation)
        if (currTime > 3f)
        {
            waveState = WaveState.state7;
            currTime = 0f;
        }
    }

    private void UpdateState7()
    {
        //물을 간지럽힌다
        /*if (distortionObject.activeSelf == false)
        {
            distortionObject.SetActive(true);
        }*/
        currTime += Time.deltaTime;
        if (currTime > waterWaitTime)
        {
            waveState = WaveState.state8;
            currTime = 0f;
        }
        butterfly.SetActive(true);
    }

    private void UpdateState8()
    {
        //아래를 보고
        currTime += Time.deltaTime;
        Quaternion tmpRot = mainCam.transform.rotation;
        mainCam.transform.rotation = Quaternion.Lerp(tmpRot, camDownRot.rotation, camRotateSpeed);
        //if (mainCam.transform.rotation == camDownRot.rotation)
        if (currTime > state8WaitTime)
        {
            waveState = WaveState.state9;
            currTime = 0f;
        }
        
    }

    private void UpdateState9()
    {
        //나비를 찾아서 다이빙한다
        Vector3 tmpPos = mainCam.transform.position;
        mainCam.transform.position = Vector3.Lerp(tmpPos, new Vector3(tmpPos.x, waterSurface.transform.position.y+0.15f, tmpPos.z), camMoveSpeed);
        if (mainCam.transform.position.y <= waterSurface.transform.position.y + 0.2f)
        {
            waveState = WaveState.state10;
        }
    }

    private void UpdateState10()
    {
        //페이드아웃된다
        Color tmpColor = fadeImg.color;
        tmpColor.a += fadeSpeed * Time.deltaTime;
        fadeImg.color = tmpColor;

        if (fadeImg.color.a >= 0.95f)
        {
            Color tmpColor2 = fadeImg.color;
            tmpColor2.a = 1f;
            fadeImg.color = tmpColor2;
            waveState = WaveState.state11;
        }

    }
    private void UpdateState11()
    {
        //딸랑딸랑한다  
        //manager.SetActive(true);
        //hand.SetActive(true);
        
            if (isChimeSoundRing == false)
            {
                chimeAudioSource.Play();
                isChimeSoundRing = true;
            }
            currTime += Time.deltaTime;
            if (currTime > 1.7f)
            {
                print("Scene change");
                SceneManager.LoadScene("Butterfly_LJH");
            }
        
    }

}
