# Roblox Comabat Demo

## Design

Combat is going to be JRGPG Style with a twist.

### Entering Combat

The player gets within range of the enemy to initiate combat. If they press ‘E’ they can start combat immediately otherwise if the enemy is within range for 3 secs combat will begin.

### Sequences

Combat is broken up into a series of sequences that continue until combat is over. Each sequence has 2 phases, first the prep followed by the act.. Sequences are the same in single and multiplayer. The only difference is the characters that the player controls during the prep phase.

### The Prep Phase

During the prep all characters queue up their actions at the same time. The time that they have in the prep phase is determined by their level and the amount of action points they have to spend. They can continue adding actions to their queue until the timer runs out. There are a fixed amount of action points that determine how many actions they can put in the queue. The sequence of the actions matters greatly.

Once the prep is completed all the action points are normalized for the act.

### The Act Phase

The act is where combat plays out. The players get to watch the combat as their actions play out and they discover what was selected for the other characters. The players can not do anything to alter the state of the sequence onces the act begins. Calculations will be done on each normalized action point since movement is a component of the combat.

Certain actions will break the sequence of other players. For example if the player is critically hit that could result in a stunning blow that will prevent the rest of the sequence from playing out. Or a move could be specifically designed to interrupt like a shield bash. After the act completes the players go back to the prep phase unless combat is over then they go to the combat result page.

### Action Points

Each character in combat has action points that they can spend on various actions. Actions can include things like melee attack, range attack, spell casting, item using, movement, waiting, and blocking.

A character that has a higher speed will get more action points to spend. This just means that they will do their actions faster since all the action points get normalized for the action.
The amount of action points a particular action takes is determined by the base cost of the action, any stats and modifiers the character has, and any stats and modifiers the item or action may have.

#### Examples

A character of high intelligence will be able to cast a spell faster because the intelligence stat on the character will be used to determine action points for spell casting.

But that same character will probably have lower strength and if they go to swing a mighty war hammer, they will need more action points to do so then our hulking barbarian with a large strength stat.

## Testing

This Project has been settup for testing using the Open Source Roblox Toolchain. To read more about how to setup your environment to take advantage please see [TestSetup.md](TestSetup.md)
