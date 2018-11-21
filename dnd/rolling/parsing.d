/**** Roller Parsing: Parses rolling expressions into a 
  * RollAction.
  * 
  * Parsings need for regex separates it from the main 
  * rolling module.
  * 
  * Author: ARaspiK
  * License: MIT
  */
module dnd.rolling.parsing;

import dnd.rolling.actions;
import dnd.rolling.dice;

import std.conv: to;
import std.regex: ctRegex, matchFirst;
import std.typecons: Nullable;
import std.traits: isSomeString;

/// The regex used for parsing rolls.
private enum rollRegex =
  // roll
  `^ roll\s+`
  // <times> of
  ~ `(?: (?P<times> \d+ ) \s+ of \s+ )?`
  // <rolls>d<sides>
  ~ `(?P<rolls> \d+ ) d (?P<sides> \d+ ) \s*`
  // +/- <bonus>
  ~ `(?P<bonus> [+-]? \d+ )? \s*`
  // >/< <use>x<total>
  ~ `(?: (?P<adv> [><] ) \s* (?: (?P<use> \d+ ) x )? (?P<total> \d+ ))?`;

/// Parses a roll string into a roll action.
/// Returns a null state if not possible.
Nullable!RollAction parseRoll(S)(S text)
    if (isSomeString!S) {

  auto match = text.matchFirst(ctRegex!(rollRegex, "x"));

  if (match.empty)
    return typeof(return)();


  RollAction res = RollAction(1, DiceSet(
    Dice(match["sides"].to!size_t)));

  if (match["times"].length)
    res.times = match["times"].to!size_t;

  if (match["rolls"].length)
    res.dice.num = match["rolls"].to!size_t;

  if (match["bonus"].length)
    res.dice.bonus = match["bonus"].to!int;

  if (match["adv"].length) {
    res.vantage = Vantage(match["total"].to!size_t);
    res.vantage.advantage = match["adv"][0] == '>';

    if (match["use"].length)
      res.vantage.num = match["use"].to!size_t;
  }

  return typeof(return)(res);
}
