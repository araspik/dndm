/**** RollAction: Describes the actions to be performed by 
  * a roll.
  * 
  * Not only does this contain the required data, but it 
  * also can execute the action and return the results as a 
  * string to be printed back to the user.
  * 
  * Author: ARaspiK
  * License: MIT
  */
module dnd.rolling.actions;

import dnd.rolling.dice;

import std.algorithm: map, sort;
import std.array: array, join;
import std.format: format;
import std.typecons: Nullable, apply;
import std.range: generate, take;
import std.exception: assumeWontThrow, assumeUnique;

/// Describes the actions to be performed by a roll.
struct RollAction {
  /// The number of times to execute the whole action.
  size_t times = 1;

  /// The die information.
  DiceSet dice;

  /// An Advantage or Disadvantage.
  Maybe!Vantage vantage;

 @safe nothrow:

  /// Constructor.
  this(size_t times, DiceSet dice, Maybe!Vantage vantage) {
    this.times = times;
    this.dice = dice;
    this.vantage = vantage;
  }

  /// Constructor, without vantage.
  this(size_t times, DiceSet dice) {
    this.times = times;
    this.dice = dice;
  }

  /// Rolls the dice and returns the results in string form.
  @trusted string roll() {
    return generate!(() => vantage
        .apply!((v) {
          auto res = v.roll(dice);
          return format!"Rolled %(%d%|, %), sum %d"
            (res, res.sum).assumeWontThrow;
        })
        .get(format!"Rolled %d"(dice.roll).assumeWontThrow))
      .take(times)
      .join('\n')
      .assumeUnique;
  }
}

/// Describes an Advantage or Disadvantage.
struct Vantage {

  /// The number of times to roll the die.
  size_t total;

  /// Whether it is advantage (true) or disadvantage.
  bool advantage = true;

  /// The number of highest/lowest numbers to utilize.
  size_t num = 1;

 @safe nothrow:

  /// Returns an array of calculated rolls, given the 
  /// DiceSet to use.
  ptrdiff_t[] roll(DiceSet dice) const {
    auto arr = dice.take(total).array;
    arr.sort!((a, b) => advantage? a > b : a < b);
    return arr[0 .. num];
  }
}

/// A Nullable for Vantages.
alias Maybe(T: Vantage) = Nullable!(Vantage, Vantage.init);