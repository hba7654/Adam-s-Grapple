using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

	private float hookPower;
	private Vector2 hookDirVector;
	private bool shotHook;

    public override void _Ready()
    {
        base._Ready();

		shotHook = false;
        GD.Print(InputMap.GetActions());
    }

    public override void _PhysicsProcess(double delta)
	{
		//Gravity!
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
			velocity.Y += gravity * (float)delta;

		//// Handle Jump.
		//if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
		//	velocity.Y = JumpVelocity;

		//// Get the input direction and handle the movement/deceleration.
		//// As good practice, you should replace UI actions with custom gameplay actions.
		//Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
		//if (direction != Vector2.Zero)
		//{
		//	velocity.X = direction.X * Speed;
		//}
		//else
		//{
		//	velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
		//}

		Velocity = velocity;
		MoveAndSlide();

		
		//Grappling
		if(Input.IsActionJustPressed("ui_accept"))
        {
            //shotHook = true;
            float mouseDistance = GetViewport().GetMousePosition().DistanceSquaredTo(this.Position);
            GD.Print("Mouse distance away is: " + mouseDistance);
        }
		else if(Input.IsMouseButtonPressed(MouseButton.Left))
		{
			//if(!shotHook)
   //         {

			//}
			//else
			//{
			//}
		}
		else if(Input.IsActionJustReleased("ui_accept"))
		{
			//shotHook = false;
		}

	}
}
