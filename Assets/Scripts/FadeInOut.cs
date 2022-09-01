using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeInOut : MonoBehaviour
{
    Image image;
    public GameObject sound;
    bool b;

    // Start is called before the first frame update
    void Start()
    {
        image = GetComponent<Image>();
    }

    // Update is called once per frame
    void Update()
    {
        if (b == false && sound.GetComponent<ChimeSound>().first == true)
        {
            b = true;
            StartCoroutine("FadeOut");
        }
    }

    IEnumerator FadeOut()
    {
        float alpht = 0;
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