To run the programme:

```rb ruby app.rb ```


The hardest part of the project was choosing the architectural layout. Initially, I implemented an
MCV architecture but could not settle on an adequate distinction between the controller and the 'machine' model.
Instead, I implemented a central machine with models and view which seems appropriate for a project
of this size. That said, I'd want to split 'machine' up if it were much larger.

One potential weakness of the implemented design concerns the input choices. Currently, once an item has been selected, a user is locked into providing the correct change. A real vending machine would likely have a return button. Still, this mostly stems from the CLI input being all numbers, not coins and buttons.

For testing output, I opted to use Regex which allows one to avoid testing specific
formatting which can lead to hard-to-read tests. This comes with a price: one must be careful
to extract or escape regex specific characters.

I use @@all class variables to mimic a database. This allows us to keep track of the items and change while sticking to PORO.

With more time I'd focus on guarding and testing against more edge cases.

My solution is time-boxed to ~3 hours (Option 1) but I had a headstart because, as discussed, I've done the test once before.
