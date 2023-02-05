# Godot VR Simulator
Simulate ARVRController and ARVRCamera Input

## First Steps
- Setup your scene for VR. You can start by following Bastiaan Olij's tutorials
https://www.youtube.com/watch?v=LZ9UKR48b0Y

- Insert ``VRSimulator.tscn`` into your scene, and then assign your ``ARVROrigin`` into the ``XR Origin`` parameter.

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
- Hold ``Left Click`` to press Trigger (``Button 15`` will be pressed and ``Axis 2`` will be set to 1)
- Hold ``Right Click`` to press Grip (``Button 2`` will be pressed and ``Axis 4`` will be set to 1)

## Other buttons
Pressing 1 to 0 (on the alphanumeric keyboard), ``-``, ``=``, ``Backspace`` and ``Enter`` will press buttons numbered from 1 to 14. On an Oculus Touch controller, pressing 1 presses ``Y`` and ``B``, 7 presses ``X`` and ``A``, 3 presses the menu button.
![Keyboard](https://github.com/Cafezinhu/godot-vr-simulator/blob/main/github-assets/keyboard.png?raw=true)

### Button mapping
- 1 presses Button 1
- 2 presses Button 2
- 3 presses Button 3
- 4 presses Button 4
- 5 presses Button 5
- 6 presses Button 6
- 7 presses Button 7
- 8 presses Button 8
- 9 presses Button 9
- 0 presses Button 10
- ``-`` presses Button 11
- ``=`` presses Button 12
- ``Backspace`` presses Button 13
- ``Enter`` presses Button 14

As stated before, pressing ``Left Click`` presses Button 15, and ``Right Click`` presses Button 2