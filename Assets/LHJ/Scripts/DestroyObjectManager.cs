using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class DestroyObjectManager : MonoBehaviour
{
    public List<GameObject> textList = new List<GameObject>();

    private static DestroyObjectManager _instance;
    public static DestroyObjectManager Instance()
    {
        return _instance;
    }
    private void Awake()
    {
        _instance=this;
    }
    // Start is called before the first frame update
    void Start()
    {
        GameObject textObj =GameObject.Find("Text");
        for(int i=0; i< textObj.transform.childCount; i++)
        {
            textList.Add(textObj.transform.GetChild(i).gameObject);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
