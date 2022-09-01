using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BounceBall : MonoBehaviour
{
    // Start is called before the first frame update

    Rigidbody rigidBody;
    Vector3 moveDir;
    public float speed;
    public float gravityTime=1f;
    private float currentTime;
    bool isGround;
    Vector3 velocity;
    Vector3 heightPos;
    void Start()
    {
        rigidBody = GetComponent<Rigidbody>();
        heightPos = transform.position+ new Vector3(0, 0.3f, 0);
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += moveDir* speed * Time.deltaTime;

        // if(rigidBody.velocity.y<0){
        //     rigidBody.velocity*=0.5f;
        // }
        velocity.y -= 3.5f * Time.deltaTime;

        rigidBody.velocity =velocity;

        //Vector3 newV= new Vector3(0, -9.8f * Time.deltaTime, 0);
        //rigidBody.velocity.y  += -9.8f * Time.deltaTime;

        // if(!isGround)
        // {
        //     moveDir = Vector3.down;
        // }
        // else
        // {
        //     currentTime += Time.deltaTime;
        //     if(currentTime > gravityTime)
        //         isGround=;
        //     currentTime=0f;
        //}
    }
    void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Collision");

        velocity.y = heightPos.y;        
    }
}
