using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireScene : MonoBehaviour
{
    // Start is called before the first frame update

    public List<GameObject> fires = new List<GameObject>();
    public GameObject wrist;

    void Start()
    {

    }

    // -3.5 ~ 7
    // Update is called once per frame
    void Update()
    {
        float x = wrist.transform.localPosition.x;
        
    }
}
