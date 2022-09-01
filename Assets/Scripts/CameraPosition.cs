using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraPosition : MonoBehaviour
{
    // Start is called before the first frame update
 

    // Update is called once per frame
    void Update()
    {
        transform.position = transform.position + new Vector3(0, SineAmount(), 0);
    }

    public float SineAmount()
    {
        return Mathf.Sin(Time.time * 0.1f);
    }
}
