using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButterflyChild_LJH : MonoBehaviour
{
    public ButterflyIntro_LJH butterflyIntro_LJH;
    public Butterfly_LJH butterfly_LJH;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (butterflyIntro_LJH)
        {
           // transform.right = butterflyIntro_LJH.dir.normalized;
            transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.LookRotation(Quaternion.Euler(0,-90,0)* butterflyIntro_LJH.dir.normalized), 2 * Time.deltaTime);
        }
        else
        {
            //transform.right = butterfly_LJH.dir.normalized;
            transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.LookRotation(Quaternion.Euler(0, -90, 0) * butterfly_LJH.dir.normalized), 2 * Time.deltaTime);
        }
    }
}
