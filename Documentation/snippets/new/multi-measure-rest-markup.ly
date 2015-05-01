
\version "2.19.20"

\header {
  lsrtags = "rhythms, text"

  texidoc = "
Markups attached to a multi-measure rest will be centered above or
below it.  Long markups attached to multi-measure rests do not cause
the measure to expand.  To expand a multi-measure rest to fit the
markup, use an empty chord with an attached markup before the
multi-measure rest.

Text attached to a spacer rest in this way is left-aligned to the
position where the note would be placed in the measure, but if the
measure length is determined by the length of the text, the text will
appear to be centered.

"
  doctitle = "Multi-measure rest markup"
}

\relative c' {
  \compressMMRests {
    \textLengthOn
    <>^\markup { [MAJOR GENERAL] }
    R1*19
    <>_\markup { \italic { Cue: ... it is yours } }
    <>^\markup { A }
    R1*30^\markup { [MABEL] }
    \textLengthOff
    c4^\markup { CHORUS } d f c
  }
}
