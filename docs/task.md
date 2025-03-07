# Proxx
[Rules](https://docs.google.com/document/d/1zLRzaU3WhSsqmGXwfQ1Fbr7mkADI8YdAz7D9POEwc-k/edit
) and playable game. Review the rules and familiarize yourself with the game. You don’t need to implement the flag functionality.
There are 4-5 parts to the exercise. For each part, please include a working coded solution along with an explanation for choosing a certain approach.
## Part 1:
Choose a data structure(s) to represent the game state. You need to keep track of the following: - NxN board
- Location of black holes
- Counts of # of adjacent black holes
- Whether a cell is open
  
## Part 2:
Populate your data structure with K black holes placed in random locations. 
Note that should place exactly K black holes and their location should be random with a uniform distribution.
 
## Part 3
  For each cell without a black hole, compute and store the number of adjacent black holes. Note that diagonals also count. E.g.

 ![img.png](img.png)

## Part 4
Write the logic that updates which cells become visible when a cell is clicked. Note that if a cell has zero adjacent black holes the game needs to automatically make the surrounding cells visible.

Note that there’s no requirement to build a UI for the game. Only the logic for updating the data structure is needed. 
