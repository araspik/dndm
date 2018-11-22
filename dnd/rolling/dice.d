/**** Dice: Provides dice rolling facilities.
  * 
  * Dice act like ranges of random numbers between 1 and 
  * the number of sides (inclusive).
  * 
  * Author: ARaspiK
  * License: MIT
  */
module dnd.rolling.dice;

import std.range: take, chunks, popFrontN;
import std.algorithm: map, sum;
import std.random: rndGen, Random;
import std.exception: assumeWontThrow;

/// Provides dice rolling facilities.
struct Dice {
  /// Number of sides in the die.
  size_t sides;

  /// The random number generator.
  Random* rand;

 @safe nothrow:

  /// Constructor.
  @trusted this(size_t sides) {
    this.sides = sides;
    this.rand = assumeWontThrow(&rndGen());
  }

  /// ditto
  this(size_t sides, Random* rand) {
    this.sides = sides;
    this.rand = rand;
  }

  /// Rolls and returns the result.
  size_t roll() {
    const res = front;
    popFront;
    return res;
  }

  /// Range primitives for accessing rolls.
  size_t front() const {
    return (rand.front + sides - 1) % sides + 1;
  }

  /// ditto
  void popFront() {
    rand.popFront;
  }

  /// ditto
  enum empty = false;

  /// ditto
  @trusted Dice save() const {
    return Dice(sides, cast(Random*)rand);
  }
}

/// Stores a Dice combined with number of times to roll as 
/// well as a bonus.
struct DiceSet {
  /// The Dice to use.
  Dice dice;

  /// The number of times to roll the dice.
  size_t num = 1;

  /// The bonus to add.
  int bonus = 0;

 @safe nothrow:

  /// Constructor.
  this(Dice dice, size_t num = 1, int bonus = 0) {
    this.dice = dice;
    this.num = num;
    this.bonus = bonus;
  }

  /// Constructor, taking number of sides instead of Dice.
  this(size_t sides, size_t num = 1, int bonus = 0) {
    this(Dice(sides), num, bonus);
  }

  /// Rolls the dice, modifies the result, and returns it.
  ptrdiff_t roll() {
    return dice.take(num).sum + bonus;
  }

  /// Range primitives.
  ptrdiff_t front() const {
    return dice.save.take(num).sum + bonus;
  }

  /// ditto
  void popFront() {
    dice.popFrontN(num);
  }

  /// ditto
  enum empty = false;
}
