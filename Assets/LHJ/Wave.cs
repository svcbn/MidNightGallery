using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wave : MonoBehaviour
{
    public GameObject cube;
    
    private float angle = 0;

    public int rows = 50;
    public int cols = 50;
    public float speed = (float)0.08;

    private List<GameObject> goInt = new List<GameObject>();

    public float moveTime=3f;
    float currentTime=0f;
    bool isMove;
    float a;

    // Start is called before the first frame update
    void Start()
    {
        for (int z = 0; z < rows; z++) //50
        {
            for (int x = 0; x < cols; x++) //50
            {
                var pos = new Vector3(x - cols/2, 0, z - rows/2); //(-25, 0, -25), (-24 0, -25) //맨 끝에서부터 // -25~25
                var go = Instantiate(cube, pos, Quaternion.identity);

                goInt.Add(go);
            }
        }
    }

    // Update is called once per second
    void FixedUpdate()
    {
        //if(Input.GetMouseButtonDown(0))
            Move();
        // if(Input.GetMouseButtonDown(0))
        // {
        //     isMove=true;
        // }
        // if(isMove)
        // {
        //     currentTime+=Time.deltaTime;
        //     if(currentTime>moveTime)
        //     {
        //         currentTime=0f;
        //         isMove=false;
        //     }
        //     Move();
        // }
        //Move();
    }

    float map(float x, float in_min, float in_max, float out_min, 
              float out_max)
    {
        return (x - in_min) * (out_max - out_min) / 
                (in_max - in_min) + out_min;
    }

    //local scale 값만 바꾸기

    public void Move()
    {
        //if(!isMove) return;
        foreach (var go in goInt)
        {
            // var d = new Vector3(go.transform.localPosition.x, 0, 
            //         go.transform.localPosition.z).magnitude;  // Vector3.zero에서 거리 구하기
            //         // Get distance
            //Material mat=  go.GetComponent<MeshRenderer>().material;
            //mat.color = Color.Lerp(mat.color, Color.)
            Vector3 objectPos= new Vector3(go.transform.localPosition.x, 0, 
                    go.transform.localPosition.z);
            Vector3 mousePos= GetMousePos();
            var d= Vector3.Distance(objectPos, mousePos);
            var offset = map(d, 0, rows/2, -Mathf.PI, Mathf.PI); 
                   // value d from 0, 25, to -3.14, 3.14
                   // 중심점에서부터의 거리(중심점) 물체 각각의 중심점 
                   // 25루트2 - 0 )*(3.14+3.14) / (-25 - 3.14) ?? offset
            a = angle + offset;//offset값이 row에 따라 바뀌는 것
                                    //그리고 각각의 오브젝트 위치가 중심점에서의 거리만큼 ?
            var h = Mathf.Floor(map(Mathf.Sin(a), -1, 1, 10, 30));
            
            go.transform.localScale = new Vector3(1, h, 1);
        }
        
        angle -= speed;
    }

    private Vector3 GetMousePos()
    {
        Vector3 worldPos = Camera.main.ScreenToWorldPoint(Input.mousePosition+ new Vector3(0,0, 10f));

        return worldPos;
    }

}