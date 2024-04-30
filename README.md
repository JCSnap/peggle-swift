# Peggle clone
Created a peggle clone in swift with a level designer.

## Dev Guide
You may put your dev guide either in this section, or in a new file entirely.
You are encouraged to include diagrams where appropriate in order to enhance
your guide.

Find in /docs

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Drag on the screen. Shoot by pressing the `LAUNCH` button at the bottom of the screen.

### Win and Lose Conditions
- Win when there is no more orange peg to collect, this means that if the game starts off without any orange pegs, it is considered a win the moment the ball goes out of frame
- Lose when balls run out before all orange pegs are collected. Start off with 5 balls.
- Apart from the win condition, user can try to get higher score. Score is computed based on the pegs hit (including non scoring pegs like blue and green etc.), the speed at which these pegs at hit by the ball, and the balls remaining.
- Measures taken to fulfill requirements - remove pegs and obstacles prematurely if they cause the ball to be stuck. (eg. The `No Escape` preloaded level). This means that the ball will always exit the frame within the finite time. Objects are removed prematurely based on some arbitrary collision threshold. We assume that if a ball is stuck, it would keep on colliding with the same few objects, and they should thus be removed after a threshold.

### Others
- Ball in bucket adds one ball (not just saves the current ball, but adds a ball on top of the one exited)
- Green peg is explosive peg, and will trigger an explosion within a fixed bound. if there is another green peg within the area, it is going to have a chain effect (not immediate). Only glowing green pegs will explode when power is activated.
- Red is stubborn peg.

## Level Designer Additional Features

### Peg Rotation
Select the peg/ object by clicking on it. A white box around it indicates that the object is selected. Once the object is selected, use the slider at the bottom of the level designer to rotate it.

### Peg Resizing
Select the object as mentioned above, and use the slider at the bottom of the level designer.

### Health
Use the slider to change the health. 1 is the default. 1 means that the peg will be removed after the first hit.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

### Audio
- Add audio to clicking buttons when selecting the `Level Designer` or `Game`, when selecting the different power ups, when the ball collides with objects, when the glowing pegs are removed, when the game wins/loses. This is done with the use of `SoundManager`, which handles all sound. Since the `rootVm` has an instance of `SoundManager`, every other view model can access the `playSound` method. Actions from the view triggers the `playSound` function of the respective view models, which triggers the `playSound` function of the `rootVm`. The `SoundManager` will preinitialise some sound instances, and play the sound asynchronously. Each sound is initialised with a fixed number of players (7 currently), and when a sound is activated, it will look for a free player to use. Else all 7 players are occupied (due to playing the same sound asynchronously), then nothing will happen. This is for performance issue.

### Improve overall aesthetic
- Used custom fonts.
- Use AI generated assets for power ups.
- Object in focus in the level designer are highlighted with a white bounding box. By default, the last object added will be in focus. However, user are free to select any objects in the level designer, which they can then modify their size, angle, health.

### Score
- Add number of orange pegs remaining out of the total number of orange pegs
- Add computed score, which is calculated based on the type of peg hit, and the speed at which the peg is hit. Inside `GamePeg`, since all game pegs conform to `HittableObject`, their `effectWhenHit` function is called every time a ball collides with them. Different peg types can override the `effectWhenHit` function to implement different behaviours. One of the added behaviour is to compute the score if the peg is being hit by the ball for the first time. Eg. Orange peg will add 500, Normal peg will add 100 etc. Apart from that, score is also added based on the velocity in which the ball is hit. This is calculated by taking the ratio of the ball velocity to its default velocity, multipled by some arbitrary scale factor. Score is also added based on ball count remaining.
- Improve UI for score rendering. Score will appear at the most recent hit peg. The size of the score will differ based on the speed in which the ball collides with the peg. This is done similar to the method above, where we take the ratio, then multiple by some arbitrary scale factor. It will show the score added from hitting the peg (eg. 0 for pegs that are already hit)

### Power
For different powers, different tags are going to be shown on the screen when the power is activated. For instance, the exploding power will show `BOOM TIME 💥`. This is done using a dictionary that maps the selected power type to their respective tags.
- Apart from in game features, some power also have UI changes. For instance, using the ghost power will cause the ball to change to an image of a ghost ball, using the poop power will cause the ball to change to a poop
- Add power to reverse gravity, when activated, it will reverse the gravity of the peg for a fixed duration.
- Add poop power - The ball turns into a poop for a period of time. During that time, the ball increases in size mid game, allowing it to hit more pegs.

### Game Over
- Include information like score, ball left

## Tests
For previous tests, go to `docs`

### Test navigation
- Pressing the "Game" button from home should bring to the game view
  - If there is no level, a pop up should appear to direct the user to the level designer (this should not happen since we implemented preloaded levels in this problem set)
  - Clicking on the level designer button should bring to the level designer

### Test cannon
- When dragging on the screen, the cannon should aim at the direction of the drag, the dotted lines should also point towards the direction of the drag
- When launch button is pressed, the ball should be ejected in the direction of the cannon and the dotted line.
- When dragging on the screen and the launch button is not pressed, the ball should not be ejected

### Test bucket
- When the launch button is pressed for the first time, the bucket should start moving from left to right and from right to left, changing direction every time it hits the bound
- When the ball collides with the bucket at its sides, the ball should be reflected and bounce off from the bucket
- When the ball enters the bucket by colliding with the top of the bucket, the ball count should increment by one, there should be a sound effect
- When the ball does not enter the bucket, the ball count should not increment
- When the ball exits the frame, the bucket should continue moving from left and right, even at the aiming stage

### Test win and lose condition
- When there is no more orange pegs on the board, the win condition should be triggered. A view should pop up to notify the user of the win, along with stats such as balls remaining, total score, orange pegs collected, and a button to return to main menu
- When the user runs out of balls before all orange pegs are collected, the lose condition should be triggered. A view should pop up to notify the uesr of the lose, along with the same states, and a button to return to the main menu
- If neither the win condition nor the lose condition is met, the same pop up should not appear. User should be able to continue playing by aiming their cannon and launching the ball
- When the game is being played, it should always terminate to either a win or lose state. In the event where a ball is stuck (due to pegs or obstacles blocking the ball from exiting the frame and decrementing the ball count or removing orange pegs), then the blocks and pegs blocking should be removed prematurely such that the ball can continue play.
- If the ball is not stuck, the blocks or pegs should not be removed prematurely

### Test power ups
- When the user picks the exploding power up, and the power is activated by clicking on the green star, all green pegs that are glowing should explode and remove pegs within 150 block radius.
- When the user picks the exploding power up, and the power is activated by clicking on the green star, all green pegs that are glowing should explode and pegs beyond a 150 block radius should not be removed
- When the user picks the exploding power up, and the power is activated by clicking on the green star, green pegs that are not glowing should not explode and remove pegs within 150 block radius.
- When the user picks the exploding power up, and the power is activated by clicking on the green star, green pegs that are not glowing should not explode and remove pegs within 150 block radius.
- When the user picks the exploding power up, and the power is activated by clicking on the green star, green pegs within the radius should explode after a fixed duration (chain reaction) and not immediately
- When the user picks the exploding power up, and the power is activated by clicking on the green star, green pegs not within the radius should not explode.
- When the user picks the exploding power up, and the power is activated by clicking on the green star, if the ball is within the radius, it should be knockedback due to the explosion
- When the user picks the spooky ball power up, and the power is activated by clicking on the green star, the ball should turn into a spooky ball (UI change) for a fixed duration
- During that duration, when the ball exits the frame, it should not remove the ball or trigger the remove peg animation. The game should play as per normal and the peg should reappear at the top of the screen at the same x position with similar y velocity.
- After the duration, the ball should exit the frame as per normal, and the ball count should be deducted.

### Test rectangular blocks
- User should be able to add a rectangular block in the level designer, and also pegs at the same time
- User should be able to save a level with rectangular blocks and pegs
- Users should not be able to add a rectangular block if doing so will cause it to overlap with another object (peg or block) or go outside bounds
- Users should not be able to drag a rectangular block to a position where it will overlap with another object (peg or block) or go outside bounds
- Users should be able to delete the block after long pressing it, or selecting the undo button and clicking on it

### Test rotatable pegs/blocks
- After adding a peg/block or selecting it, users should see the interface to rotate it at the bottom of the level designer
- Moving the slider should rotate the peg/block in real time
- User should be able to rotate the peg/block to any angle. The slider should be continuous and not discrete.
- User should be able to save the level after rotating the peg/block
- Loading a game with rotated peg/block should render the game with the rotated peg/block
- If rotating the peg/block will cause it to overlap with another object or go out of bound, the rotation should not be allowed to happen.
- The physics should work on rotated blocks/pegs. Eg. a ball colliding with a slanted rectangular block should reflect in the expected direction

### Test resizable pegs/blocks
- After adding a peg/block or selecting it, users should see the interface to resize it at the bottom of the level designer
- Moving the slider should resize the peg/block in real time
- User should be able to resize the peg/block to any size between 10 and 50. The slider should be continuous and not discrete.
- User should be able to save the level after resizing the peg/block
- Loading a game with resized peg/block should render the game with the resized peg/block
- If resizing the peg/block will cause it to overlap with another object or go out of bound, the resize should not be allowed to happen.
- The physics should work on resized blocks/pegs. Eg. a ball colliding with a bigger peg should reflect in the expected direction

### Test stubborn peg
- Usyers should be able to add stubborn pegs to the level in the level designer alongside other pegs and blocks.
- Users should be able to save a level containing stubborn pegs along with other objects without any issues.
- Stubborn pegs added to the level should retain their properties (e.g., position, size) when the level is loaded again.
- Upon impact from a ball or another peg, stubborn pegs should move according to the conservation of momentum, reflecting realistic physics behavior.
- The velocity and direction of stubborn pegs' movement after impact should correlate with the impacting object's velocity and angle of impact.
- Stubborn pegs should be able to influence the movement of balls and other movable objects upon collision, adhering to realistic physics interactions. 
- Users should not be able to place a stubborn peg in a position that causes it to overlap with existing objects or exceed the game board's boundaries.
- Stubborn pegs should not overlap with other objects or exit the game board due to their movement post-collision. If such a scenario is imminent, the movement should be adjusted to prevent overlap or out-of-bound situations.
- Stubborn pegs should bounce off the game board's walls when they collide, with the bounce angle corresponding to the angle of incidence, similar to how balls behave.

### Test health
- Pegs with HPs should have a clear visual distinction from regular pegs, ensuring players can easily identify them.
- A green rectangular health bar should be displayed on or near each peg with HP, accurately representing the peg's current health status.
- The health bar should decrease proportionally as the peg takes damage, providing immediate visual feedback on the peg's remaining HP.
- Users should be able to add pegs with HPs in the level designer without any issues using the slider after the object has been selected, alongside other pegs and obstacles.
- Levels containing pegs with HPs should be savable, and these pegs should retain their HP properties when the level is reloaded.
- The amount of damage dealt to pegs with HPs should be proportionate to collision speed.
- Pegs should glow at first hit, but removed when their HP reaches 0.
- Pegs should not be removed when their HP is not 0, even if they are glowing.

### Test preloaded levels
- There should be 3 preloaded levels that users can choose to load
- Clicking on any of the levels should bring users to the game view
- Preloaded levels should maintain consistent layout and appearance across various iPad screen sizes, ensuring a uniform gameplay experience.
- Pegs positioned at strategic points, such as corners, should retain their relative placement on the board, irrespective of the device used.
- The game board in preloaded levels should be appropriately letterboxed to accommodate different screen aspect ratios, ensuring the gameplay area remains consistent while non-interactive margins adjust accordingly.
- Letterboxing should effectively utilize the screen space, expanding the game board vertically or horizontally as needed, without distorting the gameplay area.
- Levels designed to be fully visible without scrolling on one iPad model should exhibit the same non-scrolling behavior on all other models, preserving the gameplay dynamics.
- Players should be capable of loading preloaded levels into the Level Designer for modifications while maintaining the integrity of the original preloaded content.
- Modifications to preloaded levels within the Level Designer should be savable as new level with different names
- Users should not be able to overwrite preloaded levels

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

No I generally do not think I have designed my code well in the previous problem sets, or else I won't bet getting 61/130 and 65/130 respectively. Having said that, I do think that there are some parts that are well done in the sense that I would not have done it or figure it before this course. One of it is the aggressive use of protocols (or interfaces). I am quite satisfied with how protocols are used to enforce implementations and hide irrelevant information. Apart from that, I think that the separation of responsibilities through the view models and the various utility classes like 'GameStateManager` and `PersistenceManager` has definitely made my life easier in the subsequent problem sets. I am also generally satisfied with how I try to adhere to the rules of `Model`, `ViewModel` and `View`, though I think towards the end I slip through a bit as my `View` becomes more and more complex.

There are quite a some technical debts that caused me to spend way more time than needed in this problem set. Fistly, my board in the previous problem set is tightly coupled with the peg (eg. they store an array of pegs). With the added requirement of blocks, I spent a lot of time rewriting a lot of code to make it make. For instance, it now holds an array of `BoardObject`, which Peg and Obstacle inherits from. [This](https://github.com/cs3217-2324/problem-set-4-JCSnap/commit/aa11f3ad49cc57a72b3e146ec22b4315d66420b2) is one of the many changes that I have to make as a result. It also forces me to [refactor](https://github.com/cs3217-2324/problem-set-4-JCSnap/commit/8f2088c23b65fd2b2a3e7091e4d7041cec1018ce) my game engine as a result. Because similarly, it is tightly coupled with `GamePeg`. Furthermore, it also affected how I encode and decode the data, which I had to rewrite a lot of it as well. The changes that I have to make are not localised and it made it deeply regret not doing it right the first time as I suffered greatly as a result. 

Another technical debt is not making the physics engine extensible. Ionly need to care about interaction between circle and circle. Now with the new requirements, my old design is not very scallable. Which is why I have to refactor a lot to adopt a more OOP approach towards my physics engine. Now, round physics object's isColliding method can be implemented differently from a rectangle physics object's isColliding method through polymorphism.

If I were to redo the entire application, I think I would have plan more and preempt future changes more. I would abstract prematurely, even if I do not need to yet. The mistake that I made the past few weeks is to only abstract when I am required to. By the time that happens, the other part of my code is already dependent of the implementation. When the time comes to abstract them, I have to refactor and even rewrite a lot. Another thing that I would have tried differently is to maybe use more protocol oriented approach. Now that I have a bit more understanding of protocols, I get to appreciate it more. I would probably consider replacing some of my object oriented approaches to a protocol oriented ones.
