using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerManager : MonoBehaviour
{
    private Vector2 mousePosition;

    [SerializeField] private float ropeLength;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void OnGrapple(InputAction.CallbackContext context)
    {
        if(context.started)
        {
            Debug.Log("Start Grapple");
            mousePosition = GetMousePosition();
            RaycastHit2D hit = Physics2D.Raycast(transform.position, GetMouseVector(), ropeLength, 1 << LayerMask.NameToLayer("Platform"));

            if(hit.collider != null) 
            {
                Debug.Log("GRAPPLIN");
            }
        }
    }

    //Get the direction vector from player to mouse position
    public Vector2 GetMouseVector()
    {
        Vector3 playerPos = transform.position;
        return new Vector2(mousePosition.x - playerPos.x, mousePosition.y - playerPos.y).normalized;
    }

    //get mouse position on the screen
    public Vector2 GetMousePosition()
    {
        Vector3 playerPos = transform.position;
        Vector3 mousePos = Mouse.current.position.ReadValue();
        Vector3 Worldpos = Camera.main.ScreenToWorldPoint(mousePos);
        return new Vector2(Worldpos.x, Worldpos.y);
    }
}
