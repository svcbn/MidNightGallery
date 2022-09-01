using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChimeSound : MonoBehaviour
{
    GameObject hand;
    AudioSource audios;
    public GameObject soundFactory;
    public bool first = false;
    // Start is called before the first frame update
    void Start()
    {
        hand = GameObject.Find("Hand");
        audios = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponent<SphereCollider>() && first == false)
        {
            GameObject soundg = Instantiate(soundFactory);
            soundg.transform.position = transform.position;
            audios.Play();
            
            first = true;
            print(first);
        }

    }
}
