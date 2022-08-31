using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Butterfly_LJH : MonoBehaviour
{
    public List<Transform> waypoints;
    public float moveSpeed = 3f;
    public float amplitude = 0.1f;
    public float sinSpeed = 3f;

    float theta = 0f;
    int index = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        theta += sinSpeed * Time.deltaTime;

        if (Vector3.Distance(transform.position, waypoints[index].position) > 0.5f)
        {
            Vector3 dir = waypoints[index].position - transform.position;
            dir.Normalize();

            transform.position += dir * moveSpeed * Time.deltaTime;
            transform.position += Vector3.up * Mathf.Sin(theta) * amplitude;

        }
        else
        {
            if (index == waypoints.Count - 1)
            {
                index = 0;

            }
            else
            {
                index += 1;
            }
        }

        Vector3 mousePos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, -Camera.main.transform.position.z));

        if(Vector2.Distance(new Vector2(mousePos.x,mousePos.y),new Vector2(transform.position.x, transform.position.y)) < 0.5f)
        {
            int minIndex = 0;
            float minDistance = Vector3.Distance(waypoints[index].position, transform.position);

            for(int i = 1; i < waypoints.Count; i++)
            {
                if (Vector3.Distance(waypoints[i].position, transform.position) < minDistance)
                {
                    minDistance = Vector3.Distance(waypoints[i].position, transform.position);
                    minIndex = i;
                }
            }
            index = minIndex;
        }
    }
}
