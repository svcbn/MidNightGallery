using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButterflyIntro_LJH : MonoBehaviour
{
    public Transform destination;
    public float moveSpeed = 3f;
    public float amplitude = 0.01f;
    public bool isMove = false;
    public bool isFinish = false;
    public float sinSpeed = 3f;
    public bool isHandNear = false;
    public GameObject handCenter;
    public List<Transform> waypoints;
    public Transform runawayPos;
    public Vector3 dir;
    float theta = 0f;
    ButterflyFSM_LJH butterflyFSM;

    float escapeSpeed = 1f;
    public int index = 0;
    public float wayChangeTime = 3f;
    float currChangeTime = 0f;

    // Start is called before the first frame update
    void Start()
    {
        handCenter = GameObject.FindGameObjectWithTag("HandCenter");
        butterflyFSM = GameObject.FindGameObjectWithTag("ButterflyFSM").GetComponent<ButterflyFSM_LJH>();
    }

    // Update is called once per frame
    void Update()
    {
        if (isMove)
        {
            dir = destination.position - transform.position;
            dir.Normalize();

            theta += sinSpeed * Time.deltaTime;

            transform.position += dir * moveSpeed * Time.deltaTime;
            transform.position += Vector3.up * Mathf.Sin(theta) * amplitude;
        }

        if (transform.position.x >= destination.position.x)
        {
            isFinish = true;
            isMove = false;
        }

        if (isFinish)
        {
            if (butterflyFSM.isButterflyRunaway == false)
            {
                theta += sinSpeed * Time.deltaTime;

                if (!isHandNear)
                {

                    /*
                    if (Vector2.Distance(new Vector2(transform.position.x, transform.position.y),new Vector2(waypoints[index].position.x, waypoints[index].position.y)) > 1f)
                    {
                        dir = waypoints[index].position - transform.position;

                        dir.Normalize();
                        escapeSpeed = 1f;
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
                    */

                    currChangeTime += Time.deltaTime;
                    if (currChangeTime > wayChangeTime)
                    {
                        index = Random.Range(0, waypoints.Count);
                        currChangeTime = 0f;
                    }
                    dir = waypoints[index].position - transform.position;
                    dir.Normalize();
                    escapeSpeed = 1f;
                }
                //Vector3 mousePos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, -Camera.main.transform.position.z));

                //if(Vector2.Distance(new Vector2(mousePos.x,mousePos.y),new Vector2(transform.position.x, transform.position.y)) < 0.5f)
                else
                {
                    //if(Vector2.Distance(new Vector2(handCenter.transform.position.x,handCenter.transform.position.y),new Vector2(transform.position.x, transform.position.y)) >= 4f)
                    if (Vector3.Distance(handCenter.transform.position, transform.position) > 7f)
                    {
                        isHandNear = false;

                        return;
                    }

                    dir = (handCenter.transform.position - transform.position) * -1;

                    dir.Normalize();
                    escapeSpeed = 5f;

                    /*
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
                    */
                }
                //dir.z *= 0.1f;
                transform.position += dir * moveSpeed * Time.deltaTime * escapeSpeed;
                transform.position += Vector3.forward * Mathf.Sin(theta) * amplitude;
                transform.position += Vector3.up * Mathf.Sin(theta) * amplitude;
            }
            else
            {
                Vector3 dir = runawayPos.position - transform.position;
                dir.Normalize();
                theta += sinSpeed * Time.deltaTime;
                transform.position += dir * moveSpeed * Time.deltaTime * escapeSpeed;
                transform.position += Vector3.forward * Mathf.Sin(theta) * amplitude;
                transform.position += Vector3.up * Mathf.Sin(theta) * amplitude;
            }
        }

    }
}
