using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BH_SoundManager : MonoBehaviour
{

    public List<AudioSource> fireAudio;

    public static BH_SoundManager Instance;
    // Start is called before the first frame update

    private void Awake()
    {
        Instance = this;
    }

}
