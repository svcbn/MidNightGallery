using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveLetterInput : MonoBehaviour
{
    public HandTracking handtracking;
    private Ray ray;
    public GameObject colliderPref;
    private GameObject collider;

   
    // Start is called before the first frame update
    void Start()
    {
        //collider = Resources.Load<GameObject>("")
        collider = Instantiate(colliderPref);

        if(GameObject.Find("Manager"))
			handtracking=GameObject.Find("Manager").GetComponent<HandTracking>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButton(0))
        {
			ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        }			
		else
			ray = Camera.main.ScreenPointToRay(GetFingerPoint(8));
		MoveLetter();
    }

    private Vector2 GetFingerPoint(int index)
    {
        if(handtracking)
            return handtracking.handPoints[index].transform.position*handtracking.adjuster;

        return Vector2.zero;
    }


    private void MoveLetter()
    {
        RaycastHit hitInfo;
        int layerMask =  LayerMask.GetMask("UI");
        if(Physics.Raycast(ray,out hitInfo, Mathf.Infinity, layerMask))
        {
            collider.transform.position = hitInfo.point+new Vector3(0, 0, -0.6f);
            //Debug.Log("Move Letter");
        }
    }
}
