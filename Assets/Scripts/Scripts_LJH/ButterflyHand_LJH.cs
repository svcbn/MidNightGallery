using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
public class ButterflyHand_LJH : MonoBehaviour
{
   // public static ButterflyHand_LJH instance;
    public float handRange = 5f;
    public GameObject handCenter;
    public Collider[] coll;
    public Transform[] waypoints;
    public GameObject[] farWaypointsList;
    public List<Collider> collList;

    int butterflyLayerMask;
    int waypointLayerMask;
    // Start is called before the first frame update
    void Start()
    {
        butterflyLayerMask = 1 << LayerMask.NameToLayer("Butterfly");
        waypointLayerMask = 1 << LayerMask.NameToLayer("ButterflyWaypoints");
    }

    // Update is called once per frame
    void Update()
    {

        coll = Physics.OverlapSphere(transform.position, handRange, butterflyLayerMask);
/*        List<GameObject> tmpFarWaypoints;
        for (int i = 0; i < waypoints.Length; i++) {
            if (Vector2.Distance(new Vector2(transform.position.x, transform.position.y), new Vector2(waypoints[i])))
                }*/

        if (coll.Length > 0)
        {
            collList = coll.ToList();
            /*
            for (int i = 0; i < collList.Count; i++)
            {
                if (Vector2.Distance(new Vector2(transform.position.x, transform.position.y), new Vector2(collList[i].transform.position.x, collList[i].transform.position.y)) >= handRange-1)
                {
                    collList[i].GetComponent<Butterfly_LJH>().isHandNear = false;
                    collList.RemoveAt(i);
                }
            }
            */
            for (int i = 0; i < collList.Count; i++)
            {
                collList[i].GetComponent<Butterfly_LJH>().isHandNear = true;
            }
        }
        
    }
/*
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Butterfly")
        {
            butterflyList.Add(other.gameObject);
            other.gameObject.GetComponent<Butterfly_LJH>().isHandNear = true;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Butterfly")
        {
            butterflyList.Remove(other.gameObject);
            other.gameObject.GetComponent<Butterfly_LJH>().isHandNear = false;
        }
    }*/
}
