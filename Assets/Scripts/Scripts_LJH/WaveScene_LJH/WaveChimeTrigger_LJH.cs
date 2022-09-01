using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveChimeTrigger_LJH : MonoBehaviour
{
    public WaveFSM_LJH waveFSM_LJH;
    public AudioSource source;
    int count = 0;
    // Start is called before the first frame update
    void Start()
    {
        waveFSM_LJH = GameObject.FindGameObjectWithTag("WaveFSM").GetComponent<WaveFSM_LJH>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "HandCenter")
        {
            source.Play();
            print("1");
            /*count += 1;

            if (count > 1)
            {
                waveFSM_LJH.isChimeTouch = true;
            }*/
        }
    }
}
