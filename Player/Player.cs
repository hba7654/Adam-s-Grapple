using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

	private Vector2 hookDirVector;
	private bool shotHook;
	private Node hook;
    private float maxHookPower;

    public override void _Ready()
    {
        base._Ready();

		shotHook = false;

		maxHookPower = (float)GetMeta("maxHookPower");
		//hook = GetNode((NodePath)GetMeta("hook"));
    }

    public override void _PhysicsProcess(double delta)
	{
		//Gravity!
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
			velocity.Y += gravity * (float)delta;
/*
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
*/

		Velocity = velocity;
		MoveAndSlide();

		
		//Grappling
		if(Input.IsMouseButtonPressed(MouseButton.Left))
		{
			//The frame the mouse was clicked, shoot the hook
			if (!shotHook)
			{
                shotHook = true;
				Vector2 mouse = GetLocalMousePosition();
                float hookPower = mouse.Length();
                GD.Print("Mouse distance away is: " + hookPower);

				hookDirVector = mouse.Normalized();
                hookPower *= (float)GetMeta("hookPowerMult");
                GD.Print("Hook power is: " + hookPower);

				if (hookPower > maxHookPower)
				{
					hookPower = maxHookPower;
                    GD.Print("Hook power is now: " + hookPower);
                }

				//TODO: - Create hook instance at player position
				//		- add force with magnitude hookPower, direction hookDirVector
            }
			//else if hook landed
				//allow player movement
		}
		else
		{
			//The frame the mouse was released
			if (shotHook)
			{
				shotHook = false;

				//Release rope
					//Detach player from rope

				//Disable movement (no rope to retract/expand)
			}
		}

	}
}
