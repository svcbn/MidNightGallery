using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireScene : MonoBehaviour
{
    // Start is called before the first frame update
    float currentTime = 0;
    float activeTime = 6f;

    public List<GameObject> fires = new List<GameObject>();
    public GameObject wrist;
    public GameObject finger;
    LayerMask layerMask;
    BH_SoundManager fireAudio;

    bool onfire = false;
    bool ignition = false;

    void Start()
    {
        layerMask = LayerMask.GetMask("Ground");
        fireAudio = GameObject.Find("SoundManager").GetComponent<BH_SoundManager>();
    }

    // -3.5 ~ 7
    // Update is called once per frame
    void Update()
    {
        currentTime += Time.deltaTime;
        if (currentTime > activeTime)
        {
            float handX = wrist.transform.localPosition.x;
            //handX = Mathf.Clamp(handX, -3.5f, 7f);

            for (int i = 0; i < fires.Count; i++)
            {
                Vector3 tempPos = Camera.main.WorldToScreenPoint(fires[i].transform.position);
                Ray ray = new Ray(finger.transform.position, Camera.main.transform.forward);
                RaycastHit hitInfo;
                Debug.DrawRay(ray.origin, ray.direction * 10f, Color.red, 5f);

                if (Physics.Raycast(ray, out hitInfo, 1000, layerMask))
                {
                    //print(Camera.main.WorldToScreenPoint(hitInfo.transform.position).x);
                    //print(tempPos.x);
                    Debug.DrawLine(ray.origin, hitInfo.point, Color.red);
                    
                    if (Camera.main.WorldToScreenPoint(hitInfo.transform.position).x - 800 > tempPos.x / 4)
                    {
                        fires[i].SetActive(true);
                    }
                    else if (Camera.main.WorldToScreenPoint(hitInfo.transform.position).x - 800 < tempPos.x / 4)
                    {
                        fires[i].SetActive(false);
                    }
                }
            }
            
            if(fires[0].activeSelf == true && onfire == false)
            {
                fireAudio.fireAudio[0].Play();
                onfire = true;
            }
            
            if(fires[0].activeSelf == true)
            {
                fireAudio.fireAudio[1].Play();
                ignition = true;
            }
            
            if(fires[0].activeSelf == false)
            {
                onfire = false;
                ignition = false;
            }
            
        }
    }
}
