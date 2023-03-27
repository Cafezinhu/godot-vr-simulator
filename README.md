# Godot XR Simulator
Simulate XRController3D and XRCamera Input

## First Steps
- Setup your scene for VR. You can start by following Bastiaan Olij's tutorials
https://www.youtube.com/watch?v=wDXnsy2IH1A

- Insert ``XRSimulator.tscn`` into your scene, and then assign your ``XROrigin`` into the ``XR Origin`` parameter.

![How to setup a VR Simulator](https://github.com/Cafezinhu/godot-vr-simulator/blob/main/github-assets/assigngif.gif?raw=true)


## Camera controls
When you play the scene, your cursor will be locked in the screen. Press ``Esc`` whenever you want to release the cursor.
- Move your mouse to look around
- Scroll to move the camera up and down

## Joystick controls
- Press ``WASD`` to move the left controller's joystick
- Press the arrow keys to move the right controller's joystick

## Selecting a controller
Selecting a controller allow you to move, rotate, and press a button of the selected controller.
- Hold ``Q`` to select the left controller
- Hold ``E`` to select the right controller

## Moving and rotating the controllers
- Move your mouse to move the controller
- Scroll to move the controller closer or further away from the camera
- Move your mouse while holding ``Shift`` to rotate the controller

## Trigger and Grip
- Hold ``Left Click`` to press Trigger (``trigger_click`` will be pressed and ``trigger`` will be set to 1)
- Hold ``Right Click`` to press Grip (``grip_click`` will be pressed and ``grip`` will be set to 1)

## Other buttons
Pressing 1 to 8 (on the alphanumeric keyboard), ``-``, ``=`` and ``Enter`` will press or touch buttons on the OpenXR Action Map. On an Oculus Touch controller, pressing 1 presses ``Y`` and ``B``, 2 presses ``X`` and ``A``, ``-`` presses the primary joystick, and Enter presses the menu button.
![Keyboard](https://github.com/Cafezinhu/godot-vr-simulator/blob/main/github-assets/keyboard.png?raw=true)

### Action mapping
- 1 presses by_button
- 2 presses ax_button
- 3 presses by_touch
- 4 presses ax_touch
- 5 presses trigger_touch
- 6 presses grip_touch
- 7 presses secondary_click
- 8 presses secondary_touch
- ``-`` presses primary_click
- ``=`` presses primary_touch
- ``Enter`` presses menu_button

As stated before, pressing ``Left Click`` presses trigger_click, and ``Right Click`` presses grip_click.