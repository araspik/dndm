module cli.app;

import dnd.rolling;

import std.stdio;
import std.meta: AliasSeq;
import std.range;
import std.traits: isSomeString;

/// Attempts to parse a line and returns true if it managed.
bool parseLine(S)(S line)
    if (isSomeString!S) {
  import std.algorithm: startsWith;

  if (line.startsWith("exit", "quit"))
    return false;

  static foreach (alias func; AliasSeq!(roller)) {
    auto res = func(line);
    if (!res.isNull) {
      writeln(res.get);
      return true;
    }
  }

  writeln("Unrecognized line!");

  return true;

}

void main() {
  write("$ ");
  foreach (l; stdin.byLine) {
    if (l.empty) continue;
    if (!l.parseLine) break;
    if (stdin.eof) break;
    write("$ ");
  }
}