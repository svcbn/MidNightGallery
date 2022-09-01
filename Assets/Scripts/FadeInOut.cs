using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeInOut : MonoBehaviour
{
    Image image;
    public GameObject arrive;
    GameObject logo;
    bool b;

    // Start is called before the first frame update
    void Start()
    {
        image = GetComponent<Image>();
        logo = GameObject.Find("Logo");
        logo.SetActive(false);
    }
    float alpht;
    float currentime;
    float createTime = 2;
    // Update is called once per frame
    void Update()
    {
        if (b == false && arrive.GetComponent<Shin_CameraMove>().arrive == true)
        {
            
            b = true;
            StartCoroutine("FadeOut");
        }
        currentime += Time.deltaTime;
        print(currentime);
        if (currentime > createTime)
        {
            logo.SetActive(true);
            currentime = 0;
        }
    }

    IEnumerator FadeOut()
    {
        alpht = 0;
        while (alpht <= 1)
        {
            image.color = new Color(1, 1, 1, alpht);
            alpht += Time.deltaTime * 0.3f;
            yield return null;
        }
      
        
        //for (int i = 100; i >= 0; i--)
        //{
        //    float f = i / 10f;
        //    Color c = sr.material.color;
        //    c.a = f;
        //    sr.material.color = c;
        //    yield return new WaitForSeconds(0.1f);
        //}
    }
}