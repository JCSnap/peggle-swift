[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/BAJPqr99)
# CS3217 Problem Set 4

**Name:** Justin Cheah Yun Fei

**Matric No:** A0259195N

## Tips
1. CS3217's docs is at https://cs3217.github.io/cs3217-docs. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

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
- Lose when balls run out before all orange pegs are collected
- Apart from the win condition, user can try to get higher score. Score is computed based on the pegs hit (including non scoring pegs like blue and green etc.), the speed at which these pegs at hit by the ball, and the balls remaining.

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
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

### Test navigation
- Pressing the "Game" button from home should bring to the game view
  - If there is no level, a pop up should appear to direct the user to the level designer (this should not happen since we implemented preloaded levels in this problem set)
  - There should be 3 preloaded levels that users can choose to load
  - Clicking on any of the levels should bring users to the game view


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
