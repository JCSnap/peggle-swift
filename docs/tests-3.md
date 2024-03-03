## Tests

If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

### Test Collision Physics Engine

- Test handleCollisionWithImmovableObject
  - If both objects are not coliding, their states (like velocity) should be unchanged when passed through the function
  - When an object collide with an immovable object, the movable object should not tunnel through/overlap with the immovable object in the next frame. Test this also with the maximum speed of object and lowest frame that the game allows.
  - The function should work with two different object types, as long as both of them conforms to `RoundedPhysicsObject`
  - When the movable object and immovable object overlap, the positional correction should only be applied to the movable object, the immovable object should not move after applying positional correction
  - After positional correction is applied, the objects should not overlap anymore
  - Given an object that approaches an immovable object tangentially. there should not be any unrealistic behavior, such as getting stuck or unexpected change in direction
  - Given that the two objects are colliding head on, the reflection should be along the same axis as the direction of velocity
- Test handleBoundaryCollision
  - The function should work with any object types that conform to `RoundedPhysicsObject`
  - If the object does not collide with any of the boundaries, the object state should not be modified
  - If the object collides with the boundary, the velocity of the object should be reflected, and the object should not tunnel through or overlap with the boundary. Test this also with the maximum speed of object and lowest frame that the game allows.
  - If the object overlaps with the boundary, it should apply positional correction such that the object is no longer overlapping with the boundary
  - If the object approaches two boundary at the same time, the reflection should be realistic (same axis as the direction of motion)
  - Given an immovable object placed near the boundary, the object should not penetrate through the boundary due to positional correction with the other object
  - Given an object that collides normal to the boundary, the reflection should be along the same axis as the direction of motion
  - If the object approaches the boundary tangentially, there should not be unexpected behaviour like object getting stuck or unrealistic change of direction
  - If the object collides with the boundary in any other direction, the reflection should approximate the laws of physics
- Test isObjectCollidingWithBoundarySide
  - The function should work with any object types that conform to `RoundedPhysicsObject`
  - If the object does not overlap with any of the boundaries, it should return false
  - If the object overlaps with any one of the boundaries, it should return true
  - If the object overlaps with more than one of the boundaries, it should return true

### Test World Physics Engine

- The functions should work with any object types that conform to `PhysicsObject`
- Test apply gravity to object at rest, the object's velocity should change based on the gravity applied
- Test apply gravity to object moving upwards, the object's velocity should slow down and starts moving downwards
- Test apply gravity to object moving downwards, the object's velocity should change speed up
- Test apply gravity to object moving in other direction, only the y velocity of the object should be modified and the x velocity should remain unchanged
- Test apply gravity with 0 gravity, the object velocity should not be modified
- Test apply gravity with 0 deltaTime, the object velocity should not be modified
- Test apply gravity to object of different masses, the object's velocity should change based on the gravity applied, there should not be any difference due to mass
- Test apply force with angle to an object at rest, the object should start moving in the dircetion of the angle (with angle 0 being directly downwards)
- Test apply force with angle to an object in motion, the object's velocity should account for the force
- Test apply force with with angle with delta time 0 to an object at rest, the object should not move
- Test apply force with with angle with delta time 0 to an object in motion, the object should continue moving in the same direction at the same speed
- Test apply force with with angle with force 0 to an object at rest, the object should not move
- Test apply force with with angle with force 0 to an object in motion, the object should continue moving in the same direction at the same speed

### Test Physics Peg and Ball

- When instantiating with a blue peg using the factory, a blue physics peg should be created
- When instantiating with an orange peg using the factory, an orange physics peg should be created
- Calling the `effectWhenHit` function on different subtypes of `PhysicsPeg` should give the respective different behaviours. Calling on the `BluePhysicsPeg` should cause the blue peg to light up, with no other changes to the game state. Doing the same on the `OrangePhysicsPeg` should cause the orange peg to light up, and adds a score to the game state if this is the first time being collided with, and do nothing otherwise.
- If the Physics Peg is instantiated with a negative mass, the default mass will be used instead
- If the Physics ball is instantiated with a negative mass, the default mass will be used instead

### Test PhysicsGameStateManager

- Simulate a level with only blue pegs, calling `hasReachedObjective` should return true since the game should end when there is no orange pegs.
- Simulate a level with orange pegs, all of which are glowing, calling `hasReachedObjective` should return true since the game should end when there is all orange pegs are hit.
- Simulate a level with orange pegs, some of which are glowing, calling `hasReachedObjective` should return false since the game should not end when there are some orange pegs not hit.
- Calling the `initializeStartState` function should set the velocity of the ball in the direction of the cannonAngle
- Pass in different kinds of levels to `initialiseLevelProperties`, the respective properties of the game state should match the properties in the level. The pegs should be converted to their physics equivalent. The ball should be initialized to the top center of the screen. The max score should be the number of orange pegs in the level.
- When calling the `updateBall` with a time interval of 0, the ball should remain unchanged
- When calling the `updateBall` with a non-zero time interval, the ball should's position (center) should change based on its velocity given the time interval
- When calling the `handleBallExitScreen` with no ball left, the ball should be removed from the screen. Otherwise, the ball should be reset to the top center of the screen, and ball count should reduce by 1
- After calling the `handleBallExitScreen`, the collision counts of all the pegs should be reset to 0
- If all pegs have their isVisible property set to true and the `removeInvisiblePegs` function is called, no peg should be removed
- If some pegs have their isVisible property set to false and the `removeInvisiblePegs` function is called, the pegs with the isVisible property set to false should be removed
- When the `removePegsPrematurelyWith` function is called, the pegs with collision count more than the threshold should start disappearing from the screen, and after the animation is completed, the respective pegs should be removed (not just invisible). Likewise, the pegs with collision count <= to the threshold should be visible, and not removed.
- When the `resetAllCollisionCounts` function is called, all collision counts in the pegs should be reset to 0
- When the `markGlowingPegsForRemoval` function is called. All glowing pegs should start disapearing from the screen. Likewise, those not glowing should not be changed.
- When the `cleanUp` function is called, all relevant properties like pegs, level, score, ball count should be reset to their original state. One check is to play a game halfway, then switch screen and go back to the game screen, the game state should not persist

### Test TimerManager

- Initialise the timer manager with different time intervals, calling the `startTimer` should update based on the time interval set (eg. if time interval is 1.0/60.0, update should be called 60 times)
- Run a process with the startTimer then call the `invalidate` function, the process should be terminated
- Test that only one instance of Timer should be prevent even if `startTimer` is called multiple times

### Test game engine

- Calling `getNamesOfAvailableLevels` should return the names of the levels saved by the users. If no level is saved, it should return an empty array and not crash/throw errors
- Calling `checkForBoardToLoad` should render the level if there is a level indicated in the root view model, and do nothing otherwise
- Calling `setLevelFromPersistenceAndRenderGame` should load the level from persistence and initialize all properties and render the level, and do nothing if the persistence does not contain the level
- Calling the `setCannonAngle` should set the angle based on the start point and end point. The angle is with respect to the negative y-axis (0 radian is directly donwards, - pi / 2 is horizontally towards the left, pi / 2 is horizontally towards the right). Try with different start and end points.
- Calling the `setCannonAngle` with start and end points creating angles less than - pi / 2 or more than pi / 2 should bound the angle to the nearest limit (ie. -pi / 2 or pi / 2)
- Calling `startGame` should start the game loop with the ball set to the correct direction to launch
- Calling `startGame` should disable the `LAUNCH` button in the UI, and also the dotted line from the cannon
- When the `updateGameState` is called, the ball should be updated to its correct position, it should not overlap with any peg or boundary.
- When the `updateGameState` is called, it should apply gravity to the ball
- When the `updateGameState` is called, it should reflect ball by changing it's velocity if there is collision with a boundary or another object
- When the ball exits the screen through the bottom, calling the `updateGameState` should stop the game loop and handle the ball exit
- When the ball is stuck past a certain threshold, calling `updateGameState` should unstuck the ball by prematurely removing the peg beneath it
- When the ball collides with a peg, the peg should light up when `updateGameState` is called, this should work regardless of peg type.
- When there is no collision, calling `updateGameState` should not modify other states (glow, reflection etc.)
- Calling `updateGameState` should never move a peg even with collision.
- Calling `goToHomeView` should bring to the home view
- When `checkAndHandleBallExit` is called, the timer should be terminated, there should be an animation removing the glowing pegs from view, and the glowing pegs should be removed
- Calling `endGame` should terminate the timer and show the game over view
- Calling `cleanUp` should reset all states and terminate the timer

### Test Game

- Create a level with one line of pegs side by side blocking the ball from exiting the frame. The ball should be able to exit the frame after some time (arbitrary)
- Create a level with multiple balls and 1 orange peg. Hit the peg with the first ball. The game should end early even if there are balls left.
- Create a level with multiple balls and 1 blue peg. Miss the peg with the first ball. The game should end early if there are no more orange pegs, even if there are balls left and blue pegs left.
- Create a level with multuple balls and 1 blue peg and 1 orange peg. Miss all balls on purpose. The game should end when the user run out of ball even though there are blue and red pegs remaining.
- When there is no level to load in the game view, an alert should appear with a button to the level designer view
- From the home screen, navigate to the game screen, there should be options for the user to load level (if there are level)
- From the level designer screen, after loading a level, pressing the `START` button should bring the user to the game screen with the level loaded, it should not be the load level view
- From the level designer screen, after adding pegs, pressing the `START` button should bring the user to the game screen with the level loaded, it should not be the load level view
- From the level designer screen, if no peg is added, pressing the `START` button should bring the user to the game screen with the level loaded, it should not be the load level view
- From the game view, users should be able to aim their cannon by dragging on the screen. The UI should be responsive (cannon should rotate and there should be a dotted line indicating the direction of the aim)
- When rotating the cannon, the dotted line should follow the finger, and it should also correspond to the rotation of the cannon
- Trying to rotate the cannon above the x-axis will upperbound the cannon at the x-axis. Suppose directly downwards is 0 radian, there angle of rotation should be limited to - pi / 2 to pi / 2. The UI (cannon and dotted line) should also be limited to the angle
- If the user does not alter the angle of the cannon, the cannon will be pointing downwards by default (also indicated by the dotted line)
- When the cannon is being rotated, everything else should not change (ball should not be released, pegs should not dissapear etc.)
- When the user presses the `LAUNCH` button, the ball should be launched in the direction of the cannon aim, or along the dotted line
- The score should start at 0 before the first `LAUNCH` is pressed, and the max score should correspond to the number of orange pegs in the level
- The ball count should start at 5 (or any arbitrary preset number) before the first `LAUNCH` is pressed
- When a ball is launched and is in play (have not exited the screen yet), users should not be able to launch another ball, the button to launch should be hidden, the dotted line should also be hidden. The cannon is still free to rotate.
- When a ball is launched without rotating the canon, the default direction of launch should be directly downwards
- If the cannon is rotated and the ball is launched, the initial direction of launch should be tangential to the dotted line (at least at the start before gravity alters the direction of motion)
- When the ball is launched regardless of direction, there should be a visible downward force (gravity) acting on the ball
- When the ball collides with the top, left and right boundary, it should be reflected in a manner that approximates the laws of physics (no visible unusualness)
- When the ball hits a blue peg, the peg should light up.
- When the ball hits an orange peg, the peg should light up, and the score should increase by one
- When the ball hits any peg, the ball should be reflected in an expected manner, the pegs should not be moved at all
- When the ball hits multiple pegs at the same time (eg. side by side pegs). All pegs collided should light up
- When the ball hits multiple orange pegs at the same time, the score added should correspond to the number of orange pegs collides
- When the ball hits no peg (either moving through space or hitting the boundaries), no additional pegs should light up and the score should not change
- When the ball ping pong between multiple pegs that are closed together, the ball should be reflected from one to another in an expected manner. There should be no tunneling or weird change in direction
- When the ball exits the stage (hits the bottom boundary), the ball is considered to be used, the balls remaining should reflect the change in balls count
- When the ball exits the stage, there should be an animation to remove the glowing pegs
- During the animation, user should not be able to launch a ball. The launch button should be hidden and the dotted line of the cannon should also be hidden
- Only the glowing pegs should be removed, non-glowing pegs should remain on the screen
- When the glowing pegs are removed, the score should not change, the max score should not change as well
- The `LAUNCH` button and the dotted line should only be visible once the animation is completed, and the pegs have been removed
- If there is no ball remaining, the game over modal should appear, indicating the final score, ball remaining, and a button that leads the user back to the main menu
- If the user has balls remaining, the just start aiming and press `LAUNCH` similar to how it started
- Suppose the user launches the ball, it should not collide with pegs that have been removed. Ie. when the ball goes through a region of space where a peg used to exist before removal, the ball should be able to go through freely, and there should be no side effect (score changing etc.)
- The score and max score should still include pegs that are previousy removed in the same game
- All other behaviours should be the same compared to the first launch
- When in the middle of a game and user switches screen and switches back to the game screen, the game should not persist and user should be brought back to the load level view
- When in the middle of the peg removal animation and user switches screen and switches back to the game screen, the game should not persist and user should be brought back to the load level view
- When in the middle of a game and user switches to level designer view, adds pegs and press start, the game should start with the level designer level without going through the load level view
