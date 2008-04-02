%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.38"

\header {
  lsrtags = "text"
 texidoc = "
If specified, text marks may be aligned with notation objects other
than bar lines.  These objects include @code{ambitus},
@code{breathing-sign}, @code{clef}, @code{custos}, @code{staff-bar},
@code{left-edge}, @code{key-cancellation}, @code{key-signature}, and
@code{time-signature}.



In such cases, text marks will be horizontally centered above the
object. However this can be changed, as demonstrated on the second line
of this example (in a score with multiple staves, this setting should
be done for all the staves).


" }
% begin verbatim
\relative c' {
  e1
  
  % the RehearsalMark will be centered above the Clef
  \override Score.RehearsalMark #'break-align-symbols = #'(clef)
  \key a \major
  \clef treble
  \mark "↓"
  e
  
  % the RehearsalMark will be centered above the TimeSignature
  \override Score.RehearsalMark #'break-align-symbols = #'(time-signature)
  \key a \major
  \clef treble
  \time 3/4
  \mark "↓"
  e2.
  
  % the RehearsalMark will be centered above the KeySignature
  \override Score.RehearsalMark #'break-align-symbols = #'(key-signature)
  \key a \major
  \clef treble
  \time 4/4
  \mark "↓"
  e1

  \break
  e
  
  % the RehearsalMark will be aligned with the left edge of the KeySignature
  \once \override Score.KeySignature #'break-align-anchor-alignment = #LEFT
  \mark "↓"
  \key a \major
  e
  
  % the RehearsalMark will be aligned with the right edge of the KeySignature
  \once \override Score.KeySignature #'break-align-anchor-alignment = #RIGHT
  \key a \major
  \mark "↓"
  e
  
  % the RehearsalMark will be aligned with the left edge of the KeySignature
  % and then shifted right by 1 unit.
  \once \override Score.KeySignature #'break-align-anchor = #1
  \key a \major
  \mark "↓"
  e1
}
