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

## TODO
- fix pegs can be added to bucket level
- Make it such that physics object that takes in game state can only call functions allowed (delegate pattern)
- replace if...Peg with polymorphism similar to addBoard
- fix glowing persists after switching tab
- make it such that collision between ball and rectangular block will reflect in the correct direction

## Enhancements
- Assign score to pegs, and score should animate when peg is hit
- Animate when bucket captures peg
- Animate cannon
## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Please explain how the player moves the cannon.

### Win and Lose Conditions
Please explain how the player wins/loses the game.

## Level Designer Additional Features

### Peg Rotation
Please explain how the player rotates the triangular pegs.

### Peg Resizing
Please explain how the player resizes the pegs.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

### Audio
- Add audio to clicking buttons when selecting the `Level Designer` or `Game`, when selecting the different power ups, when the ball collides with objects, when the glowing pegs are removed, when the game wins/loses. This is done with the use of `SoundManager`, which handles all sound. Since the `rootVm` has an instance of `SoundManager`, every other view model can access the `playSound` method. Actions from the view triggers the `playSound` function of the respective view models, which triggers the `playSound` function of the `rootVm`. The `SoundManager` will preinitialise some sound instances, and play the sound asynchronously, adding more instances as required.
- Improve overall aesthetic - including custom fonts, backgrounds
- Score feature
- Selected object in the level designer are highlighted

## Tests
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

Your answer here
