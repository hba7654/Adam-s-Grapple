using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerManager : MonoBehaviour
{
    private LineRenderer lineRenderer;
    private Vector2 mousePosition;
    private Vector2 grapplePoint;
    private Vector2 centripetalVector;

    [SerializeField] private float ropeLength;

    // Start is called before the first frame update
    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        centripetalVector = new Vector2(grapplePoint.x - transform.position.x, grapplePoint.y - transform.position.y).normalized;

        if(grapplePoint != Vector2.zero)
        {
            lineRenderer.enabled = true;
            DrawLine(transform.position, grapplePoint);
        }
        else
        {
            lineRenderer.enabled = false;
        }
    }

    //Called when the left mouse button is clicked, launches the grapple towards
    //the mouse cursor and checks for connection with a platform
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
                grapplePoint = hit.point;
            }
            else
            {
                grapplePoint = Vector2.zero;
            }
        }

        else if(context.canceled)
        {
            grapplePoint = Vector2.zero;
        }    
    }

    public void ExtendRetract(InputAction.CallbackContext context)
    {
        if(context.performed)
        {
            transform.position += context.ReadValue<float>() * (Vector3)centripetalVector;
        }
    }


    #region Helper Functions
    //Get the direction vector from player to mouse position
    private Vector2 GetMouseVector()
    {
        Vector3 playerPos = transform.position;
        return new Vector2(mousePosition.x - playerPos.x, mousePosition.y - playerPos.y).normalized;
    }

    //get mouse position on the screen
    private Vector2 GetMousePosition()
    {
        Vector3 playerPos = transform.position;
        Vector3 mousePos = Mouse.current.position.ReadValue();
        Vector3 Worldpos = Camera.main.ScreenToWorldPoint(mousePos);
        return new Vector2(Worldpos.x, Worldpos.y);
    }

    //Draws a line from one point to another
    private void DrawLine(Vector2 p1, Vector2 p2)
    {
        lineRenderer.SetPosition(0, p1);
        lineRenderer.SetPosition(1, p2);
    }
    #endregion
}
