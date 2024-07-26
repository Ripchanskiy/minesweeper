### Description
Simple minesweeper game without flags

### Strategies
#### Iterative Approach
    # Pros:
    # - Avoids stack overflow issues by using an explicit stack.
    # - More efficient for large datasets with reduced call overhead.
    # - Better memory usage and handling of large grids.
    # Cons:
    # - Slightly more complex to implement.
    # - Requires explicit stack management.
#### Recursive Approach
    # Recursive Approach
    # Pros:
    # - Simpler and easier to understand for small datasets.
    # - Directly reflects the logical process of revealing cells.
    # Cons:
    # - Can lead to stack overflow for large grids.
    # - Less efficient due to overhead from recursive function calls.

### How to run the rocket
```shell
ruby play.rb
```

### Tests
```shell
bundle exec rspec
```
