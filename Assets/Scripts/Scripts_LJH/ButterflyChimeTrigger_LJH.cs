using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButterflyChimeTrigger_LJH : MonoBehaviour
{
    public ButterflyFSM_LJH butterflyFSM_LJH;

    int count = 0;
    // Start is called before the first frame update
    void Start()
    {
        butterflyFSM_LJH = GameObject.FindGameObjectWithTag("ButterflyFSM").GetComponent<ButterflyFSM_LJH>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "HandCenter")
        {
            count += 1;

            if (count > 1)
            {
                butterflyFSM_LJH.isChimeTouch = true;
            }
        }
    }
}
