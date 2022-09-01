using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rose : MonoBehaviour
{
    public GameObject rose;
    GameObject hand;
    // Start is called before the first frame update
    void Start()
    {
        hand = GameObject.Find("Hand");
    }
    float currentTime;
    float createTime = 3;
    
    // Update is called once per frame
    void Update()
    {
        
        currentTime += Time.deltaTime;

        float distance = Vector3.Distance(transform.position, hand.transform.position);
        print(distance);
        if (distance < 30)
        {
            currentTime += Time.deltaTime;
            if (currentTime > createTime)
            {
            GameObject rosee = Instantiate(rose);
                    
            currentTime = 0;
            }
        }
    }
}
