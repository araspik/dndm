/**** Provides rolling capability.
  * 
  * Using this module, a virtual dice can be rolled 
  * multiple times, with bonus, advantage/disadvantage, as 
  * well as a few additional features are implemented and 
  * can be parsed from a simple-to-read string.
  * 
  * Author: ARaspiK
  * License: MIT
  */
module dnd.rolling;

import dnd.rolling.parsing;

import std.typecons;
import std.traits: isSomeString;

/// Attempts to parse a roll and return a string describing
/// the results.
Nullable!(string, null) roller(S)(S text)
    if (isSomeString!S) {
  return typeof(return)(text.parseRoll
    .apply!(a => a.roll).get(null));
}
