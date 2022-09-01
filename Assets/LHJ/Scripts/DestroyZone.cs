using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyZone : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void OnTriggerEnter(Collider collider)
    {
        //Debug.Log("layer " + (1 << gameObject.layer) + "letter " +  LayerMask.GetMask("Letter"));
        if((1 << collider.gameObject.layer) == LayerMask.GetMask("Letter"))
        {
            DestroyObjectManager.Instance().textList.Remove(collider.gameObject);
            Destroy(collider.gameObject);
            Debug.Log(DestroyObjectManager.Instance().textList.Count);
            if(DestroyObjectManager.Instance().textList.Count == 0)
            {
                Debug.Log("NextScene");
                FadeController.Instance().FadeIn();
            }            
        }
    }
}
