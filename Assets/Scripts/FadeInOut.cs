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
    // Update is called once per frame
    void Update()
    {
        if (b == false && arrive.GetComponent<Shin_CameraMove>().arrive == true)
        {
            
            b = true;
            StartCoroutine("FadeOut");
        }
        
        if (alpht > 0.8)
        {
            logo.SetActive(true);
        }
    }

    IEnumerator FadeOut()
    {
        alpht = 0;
        while (alpht <= 1)
        {
            image.color = new Color(1, 1, 1, alpht);
            alpht += Time.deltaTime * 0.1f;
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