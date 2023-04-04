using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
public class HandTracking : MonoBehaviour
{
    // Start is called before the first frame update
    public UDPReceive udpReceive;
    public GameObject[] handPoints;

    public GameObject hand;

    public float speed = 20f;
    public float adjuster = 100;

    public int[] fingerPoints= new int[5];
    public string fingerPointS; 
    
    void Start()
    {
        hand = GameObject.Find("Hand");
    }
 
    // Update is called once per frame
    void Update()
    {
        string data = udpReceive.data;
 
        data = data.Remove(0, 1);
        data = data.Remove(data.Length-1, 1);
        //print(data);
        string[] points = data.Split(',');
        //print(points[0]);

        fingerPointS="";
        fingerPointS += points[0]+ (points[1])+ (points[2]) + (points[3]) + (points[4]);
        
        //0        1*3      2*3
        //x1,y1,z1,x2,y2,z2,x3,y3,z3
        fingerPoints[0] = int.Parse(points[0]);
        fingerPoints[1] = int.Parse(points[1]);
        fingerPoints[2] = int.Parse(points[2]);
        fingerPoints[3] = int.Parse(points[3]);
        fingerPoints[4] = int.Parse(points[4]);
 
        for ( int i = 0; i<21; i++)
        { 
            float x = 9 - float.Parse(points[i * 3 + 5]) /adjuster;
            float y = float.Parse(points[i * 3 + 6]) / adjuster;
            float z = float.Parse(points[i * 3 + 7]) / adjuster;

            handPoints[i].transform.localPosition = Vector3.Lerp(handPoints[i].transform.localPosition, new Vector3(x, y, z), speed * Time.deltaTime);
            //hand.transform.position = new Vector3(0, 0, z/2);
        }
 
 
    }
}
