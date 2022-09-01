using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    float speed = 5;
    
    CharacterController cc;
    // Start is called before the first frame update
    void Start()
    {
        cc = GetComponent<CharacterController>();   
    }

    // Update is called once per frame
    void Update()
    {
        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");

        Vector3 dir = Vector3.forward * v + Vector3.right * h;
        
        dir = Camera.main.transform.TransformDirection(dir);
        dir.Normalize();
        dir.y = 0;
        cc.Move(dir * speed * Time.deltaTime);
    }
}
