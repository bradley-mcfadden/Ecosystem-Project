# Ecosystem-Project

![ss1](https://github.com/bradley-mcfadden/Ecosystem-Project/blob/master/ss3.png)

---

This project is my interpretation of "The Ecosystem Project" from Daniel Shiffman's
"The Art of Code".

The general idea of the project is to create a program that emulates a predator-prey
ecosystem, where the strong survive and reproduce. This demo realises this behaviour
by modelling flies, frogs and fruit trees. Fruit trees attract flies, and flies attract
frogs. When flies interact with fruit, they reproduce. When frogs have eaten enough flies
and collide with another frog, then they reproduce. The traits of frogs are passed down
between generations, as well as with flies.

This project introduced me to the idea of particle systems, and was a minimal, lightweight
example for many groups of related objects interacting with each other. It also introduced
the idea of evolution among objects in programming.

If I were to make changes to the project, I would attempt a better model for frogs reproducing.
Currently, a problem arises where flies eventually die as soon as they spawn. Large frogs
dominate because they take a lot of area, but they should have to eat significantly more to
survive. Implementing a change that would drain frog energy proportionally to their size 
may adjust the population to be smaller and faster fly catchers overall.
