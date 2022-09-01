using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextSound : MonoBehaviour
{
    AudioSource audioSource;
    SoundManager soundManager;
    // Start is called before the first frame update
    void Start()
    {
        audioSource=GetComponentInParent<AudioSource>();
        soundManager = GetComponentInParent<SoundManager>();
    }

    void OnCollisionEnter(Collision other)
    {
        if( 1<< other.gameObject.layer == LayerMask.GetMask("Hand") )
        {
            int randNum = Random.Range(0, soundManager.DingSound.Count);
            audioSource.clip = soundManager.DingSound[randNum];
            audioSource.Play();
            Debug.Log("Collision");
        }
    }
}
